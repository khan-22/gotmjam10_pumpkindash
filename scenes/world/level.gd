extends Node

signal restart_game
signal go_to_credits

var do_quick_intro = false

var ok_to_skip = false

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
	Events.connect("game_win", self, "on_game_won")
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
			if ok_to_skip and (event is InputEventKey and event.is_pressed() or event is InputEventJoypadButton):
				emit_signal("restart_game")

func on_game_over():
	current_state = State.GAME_OVER
	$CutscenePlayer.play("GameOver")
	yield(get_tree().create_timer(2.0), "timeout")
	ok_to_skip = true

func on_game_won():
	current_state = State.GAME_WIN
	$CutscenePlayer.play("GameWon")
	#yield(get_tree().create_timer(2.0), "timeout")
