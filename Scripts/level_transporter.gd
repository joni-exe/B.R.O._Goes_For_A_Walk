extends Node
@export var level: String

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # if the thing that enter is in the Player group then loads the enemy data from the PlayerData script.
		print("[rasdads]")		   # The enemy gets saved in the script as a resource from the area 2d itself upon entering
		get_tree().change_scene_to_file.call_deferred(level) # changes scene to the Battle_Interface scene
		 
