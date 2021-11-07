extends Node

signal restart_game

var do_quick_intro = false

enum State {
	MENU,
	INTRO,
	GAME,
	GAME_OVER,
	GAME_WIN
}

var current_state = State.MENU

func _ready():
	Events.connect("game_over", self, "on_game_over")
	pass

func _input(event):
	match current_state:
		State.MENU:
			if event is InputEventKey and event.is_pressed() or event is InputEventJoypadButton:
				current_state = State.INTRO
				if do_quick_intro:
					$CutscenePlayer.play("QuickIntro")
				else:
					$CutscenePlayer.play("Intro")					
		State.GAME_OVER:
			if event is InputEventKey and event.is_pressed() or event is InputEventJoypadButton:
				emit_signal("restart_game")

func on_game_over():
	current_state = State.GAME_OVER
	$CutscenePlayer.play("GameOver")
