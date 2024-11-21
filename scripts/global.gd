extends Node

var player_current_attack = false

var current_scene = "world"
var transition_scene = false

var player_exit_cliffside_posx = 490
var player_exit_cliffside_posy = 19

var player_start_posx = 895
var player_start_posy = 535

var game_first_loadin = true

var player_node: Node = null
@onready var inventory_slot_scene = preload("res://scenes/inventory_slot.tscn") 

var inventory = []
signal inventory_updated

var spawnable_items = [
	{"type": "Consumable", "name": "Apple", "effect": "Health", "texture": preload("res://FreePixelFood/Assets/FreePixelFood/Sprite/Food/Apple.png")},
	{"type": "Consumable", "name": "Cookie", "effect": "Stamina", "texture": preload("res://FreePixelFood/Assets/FreePixelFood/Sprite/Food/Cookie.png")},
	{"type": "Consumable", "name": "Sushi", "effect": "Armor", "texture": preload("res://FreePixelFood/Assets/FreePixelFood/Sprite/Food/Sushi.png")},
	{"type": "Gift", "name": "Whiskey", "effect": "", "texture": preload("res://FreePixelFood/Assets/FreePixelFood/Sprite/Food/Whiskey.png")},
]

var hotbar_size = 8
var hotbar_inventory = []

func _ready() -> void:
	inventory.resize(50)
	hotbar_inventory.resize(hotbar_size)

func add_item(item, to_hotbar = false):
	var added_to_hotbar = false
	#Add to hotbar
	if to_hotbar:
		added_to_hotbar = add_hotbar_item(item)
		inventory_updated.emit()
	
	#Add to hotbar
	if not added_to_hotbar:
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
				inventory[i]["quantity"] += item["quantity"]
				inventory_updated.emit()
				return true
			elif inventory[i] == null:
				inventory[i] = item
				inventory_updated.emit()
				return true
		return false

func remove_item(item_type, item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false

func increase_inventory_size(extra_slots):
	inventory.resize(inventory.size() + extra_slots)
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player

func finish_changescene():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "cliff_side"
		else:
			current_scene = "world"

func adjust_drop_position(position):
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("items")
	for items in nearby_items:
		if items.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position
	
func drop_item(item_data, drop_position):
	if !FileAccess.file_exists(item_data["scene_path"]):
		push_error("Scene file does not exist: " + item_data["scene_path"])
		return
		
	var item_scene = load(item_data["scene_path"])
	if !item_scene:
		push_error("Failed to load scene: " + item_data["scene_path"])
		return
		
	var item_instance = item_scene.instantiate()
	if !item_instance:
		push_error("Failed to instantiate scene")
		return
		
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
	
func add_hotbar_item(item):
	for i in range(hotbar_size):
		if hotbar_inventory[i] == null:
			# Store reference to inventory item
			hotbar_inventory[i] = item
			return true
	return false
	
func remove_hotbar_item(item_type, item_effect):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["type"] == item_type and hotbar_inventory[i]["effect"] == item_effect:
			hotbar_inventory[i]["quantity"] -= 1
			if hotbar_inventory[i]["quantity"] <= 0:
				hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false

func unassign_hotbar_item(item_type, item_effect):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["type"] == item_type and hotbar_inventory[i]["effect"] == item_effect:
			hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false
	
func is_item_assigned_to_hotbar(item_to_check):
	return item_to_check in hotbar_inventory
	
func swap_inventory_items(index1, index2):
	if index1 < 0 or index1 > inventory.size() or index2 < 0 or index2 > inventory.size():
		return false
		
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	inventory_updated.emit()
	return true

func swap_hotbar_items(index1, index2):
	if index1 < 0 or index1 > hotbar_inventory.size() or index2 < 0 or index2 > hotbar_inventory.size():
		return false
		
	var temp = hotbar_inventory[index1]
	hotbar_inventory[index1] = hotbar_inventory[index2]
	hotbar_inventory[index2] = temp
	inventory_updated.emit()
	return true
