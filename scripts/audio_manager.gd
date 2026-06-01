extends Node

@onready var music = $Music
@onready var bg1 = $BGFrogs
@onready var bg2 = $BGFrogs2





func play_music(stream: AudioStream) -> void:
	music.stream = stream
	music.play()

func play_bg1(stream: AudioStream) -> void:
	bg1.stream = stream
	bg1.play()

func play_bg2(stream: AudioStream) -> void:
	bg2.stream = stream
	bg2.play()
