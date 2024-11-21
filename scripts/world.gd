extends Node2D

@onready var items = $Items
@onready var item_spawn_area = $ItemSpawnArea
@onready var collision_shape = $ItemSpawnArea/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.game_first_loadin == true:
		$player.position.x = Global.player_start_posx
		$player.position.y = Global.player_start_posy
	else:
		$player.position.x = Global.player_exit_cliffside_posx
		$player.position.y = Global.player_exit_cliffside_posy
	spawn_random_items(25)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()

func _on_cliff_side_transition_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.transition_scene = true
		
func change_scene():
	if Global.transition_scene == true:
		if Global.current_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			Global.game_first_loadin = false
			Global.finish_changescene() 
			
func get_random_position():
	var area_rect = collision_shape.shape.get_rect()
	var x = randf_range(0, area_rect.position.x)
	var y = randf_range(0, area_rect.position.y)
	return item_spawn_area.to_global(Vector2(x,y))

func spawn_random_items(count):
	var attempts = 0
	var spawned_count = 0
	
	while spawned_count < count and attempts < 100:
		var position = get_random_position()
		spawn_item(Global.spawnable_items[randi() % Global.spawnable_items.size()], position)
		spawned_count += 1
		attempts +=1

func spawn_item(data, position):
	var item_scene = preload("res://scenes/inventory_item.tscn")
	var item_instance = item_scene.instantiate()
	item_instance.initiate_items(data["type"],data["name"],data["effect"],data["texture"])
	item_instance.global_position = position
	items.add_child(item_instance)
