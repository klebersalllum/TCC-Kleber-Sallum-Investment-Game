extends Node2D

var next_scene = null

var player_location = Vector2(0, 0)
var player_direction = Vector2(0, 0)

enum TransitionType { NEW_SCENE, PARTY_SCREEN, MENU_ONLY }
var transition_type = TransitionType.NEW_SCENE

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func transition_to_party_screen():
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	transition_type = TransitionType.PARTY_SCREEN
	
func transition_exit_party_screen():
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	transition_type = TransitionType.MENU_ONLY

func _input(event):
	if get_node_or_null('DialogueNode') == null:
		if event.is_action_pressed("x"):
			get_tree().paused= true
			var dialog = Dialogic.start('Dinheiro')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect('timeline_end', self,'unpause')
			add_child(dialog)

# warning-ignore:unused_argument
func unpause(timeline_name):
	get_tree().paused=false

func transition_to_scene(new_scene: String, spawn_location, spawn_direction):
	next_scene = new_scene
	player_location = spawn_location
	player_direction = spawn_direction
	transition_type = TransitionType.NEW_SCENE
	$ScreenTransition/AnimationPlayer.play("FadeToBlack")
	
func finished_fading():
	match transition_type:
		TransitionType.NEW_SCENE:
			$CurrentScene.get_child(0).queue_free()
			$CurrentScene.add_child(load(next_scene).instance())
			
			var player = Utils.get_player()
			player.set_spawn(player_location, player_direction)
		TransitionType.PARTY_SCREEN:
			$Menu.load_party_screen()
		TransitionType.MENU_ONLY:
			$Menu.unload_party_screen()
	
	$ScreenTransition/AnimationPlayer.play("FadeToNormal")
