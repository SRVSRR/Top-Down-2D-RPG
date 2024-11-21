extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuanity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var assign_button = $UsagePanel/AssignButton
@onready var outer_border = $OuterBorder

signal drag_start(slot)
signal drag_end()

var item = null
var slot_index = -1
var is_assigned = false

func set_slot_index(new_index):
	slot_index = new_index

func _ready():
	# Ensure all nodes are properly initialized
	if !icon or !quantity_label or !details_panel or !item_name or !item_type or !item_effect or !usage_panel:
		push_error("Some UI nodes are missing in inventory_slot.gd")
		return
		
	# Hide panels by default
	if details_panel:
		details_panel.visible = false
	if usage_panel:
		usage_panel.visible = false	
	
func _on_item_button_mouse_entered() -> void:
	if item != null and details_panel:
		if usage_panel:
			usage_panel.visible = false
		details_panel.visible = true

func _on_item_button_mouse_exited() -> void:
	if details_panel:
		details_panel.visible = false

func set_empty():
	if icon:
		icon.texture = null
	if quantity_label:
		quantity_label.text = ""
	
func set_item(new_item):
	if !new_item:
		set_empty()
		return
		
	item = new_item
	if icon:
		icon.texture = new_item["texture"]
	if quantity_label:
		quantity_label.text = str(item["quantity"])
	if item_name:
		item_name.text = str(item["name"])
	if item_type:
		item_type.text = str(item["type"])
	if item_effect:
		if item["effect"] != "":
			item_effect.text = str("+ ", item["effect"])
		else:
			item_effect.text = ""
	update_assignment_status()

func _on_drop_bottom_pressed() -> void:
	if item != null and Global.player_node != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0,50)
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["type"], item["effect"])
		Global.remove_hotbar_item(item["type"], item["effect"])
		if usage_panel:
			usage_panel.visible = false

func _on_use_button_pressed() -> void:
	usage_panel.visible = false
	if item != null and item["effect"] != "":
		if Global.player_node:
			Global.player_node.apply_item_effect(item)
			Global.remove_item(item["type"], item["effect"])
			Global.remove_hotbar_item(item["type"], item["effect"])
		else:
			pass

func update_assignment_status():
	is_assigned = Global.is_item_assigned_to_hotbar(item)
	if is_assigned:
		assign_button.text = "Unassigned"
	else:
		assign_button.text = "Assign"

func _on_assign_button_pressed() -> void:
	if item != null:
		if is_assigned:
			Global.unassign_hotbar_item(item["type"], item["effect"])
			is_assigned = false
		else:
			Global.add_item(item, true)
			is_assigned = true
		update_assignment_status()

func _on_item_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if item != null and usage_panel != null:
				usage_panel.visible = !usage_panel.visible
				if details_panel:
					details_panel.visible = false
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				outer_border.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				outer_border.modulate = Color(1, 1, 1)
				drag_end.emit()
