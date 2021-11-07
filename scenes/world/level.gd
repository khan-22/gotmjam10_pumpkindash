extends Node

enum State {
	MENU,
	INTRO,
	GAME
}

var current_state = State.MENU

func _ready():
	pass

func _input(event):
	match current_state:
		State.MENU:
			if event is InputEventKey or event is InputEventJoypadButton:
				current_state = State.INTRO
				$CutscenePlayer.play("Intro")
			

