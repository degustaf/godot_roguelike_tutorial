class_name MainMenu
extends Control

signal game_requested(load: bool)

@onready var first_button := $"%NewButton"
@onready var load_button := $"%LoadButton"

func _ready() -> void:
	first_button.grab_focus()
	var has_save_file := FileAccess.file_exists("user://save_game.dat")
	load_button.disabled = has_save_file

func _on_new_button_pressed():
	game_requested.emit(false)

func _on_load_button_pressed():
	game_requested.emit(true)

func _on_quit_button_pressed():
	get_tree().quit()
