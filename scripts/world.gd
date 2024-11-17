extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.game_first_loadin == true:
		$player.position.x = Global.player_start_posx
		$player.position.y = Global.player_start_posy
	else:
		$player.position.x = Global.player_exit_cliffside_posx
		$player.position.y = Global.player_exit_cliffside_posy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	change_scene()


func _on_cliff_side_transition_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Global.transition_scene = true
		
func change_scene():
	if Global.transition_scene == true:
		if Global.curren_scene == "world":
			get_tree().change_scene_to_file("res://scenes/cliff_side.tscn")
			Global.game_first_loadin = false
			Global.finish_changescene() 
