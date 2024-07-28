extends Control

signal opened
signal closed

var isOpen = false

@onready var inventory: Inventory = preload("res://resources/inventory/playerInventory.tres")
@onready var ItemStackGuiClass = preload("res://scenes/UI/Inventory/itemsStackGui.tscn")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

var itemInHand: ItemsStackGui

func _ready():
	connectSlots()
	inventory.updated.connect(update)
	update()

func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		var inventorySlot: InventorySlot = inventory.slots[i]
		
		if !inventorySlot.item: continue
		
		var itemStackGui: ItemsStackGui = slots[i].itemStackGui
		if !itemStackGui:
			itemStackGui = ItemStackGuiClass.instantiate()
			slots[i].insert(itemStackGui)
			
		itemStackGui.inventorySlot = inventorySlot
		itemStackGui.update()

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()

func onSlotClicked(slot):
	if slot.isEmpty():
		if !itemInHand: return
		insertItemInSlot(slot)
		return
	
	if !itemInHand:
		takeItemFromSlot(slot)


func takeItemFromSlot(slot):
	itemInHand = slot.takeItem()
	add_child(itemInHand)
	updateItemInHand()
	
func insertItemInSlot(slot):
	var item = itemInHand
	
	remove_child(itemInHand)
	itemInHand = null
	
	slot.insert(item)


func updateItemInHand():
	if !itemInHand: return
	itemInHand.global_position = get_global_mouse_position() - itemInHand.size/2

func _input(event):
	updateItemInHand()
