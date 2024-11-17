extends Node

var player_current_attack = false

var curren_scene = "world"
var transition_scene = false

var player_exit_cliffside_posx = 490
var player_exit_cliffside_posy = 19

var player_start_posx = 895
var player_start_posy = 535

var game_first_loadin = true

func finish_changescene():
	if transition_scene == true:
		transition_scene = false
		if curren_scene == "world":
			curren_scene = "cliff_side"
		else:
			curren_scene = "world"
