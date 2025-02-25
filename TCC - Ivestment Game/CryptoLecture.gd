extends Area2D

var player_entered = false
func _ready():
	connect("body_entered", self, "_on_NPC_body_entered")
	connect("body_exited", self, "_on_NPC_body_exited")

func _process(_delta):
	$QuestionMark.visible = player_entered


func _input(event):
	if get_node_or_null('DialogueNode') == null:
		if event.is_action_pressed("ui_accept") and player_entered:
			get_tree().paused= true
			var dialog = Dialogic.start('CryptoLecture')
			dialog.pause_mode = Node.PAUSE_MODE_PROCESS
			dialog.connect('timeline_end', self,'unpause')
			Global.npc_crypto=true
			add_child(dialog)

func unpause(timeline_name):
	get_tree().paused=false

func _on_NPC_body_entered(body):
	if body.name == 'Player':
		player_entered = true

func _on_NPC_body_exited(body):
	if body.name == 'Player':
		player_entered = false
