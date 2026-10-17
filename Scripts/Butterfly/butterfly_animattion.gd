extends AnimatedSprite2D

const ANIMATION_BUTTERFLY: String = "Butterfly"


func _play_butterfly_animation()-> void:
	play(ANIMATION_BUTTERFLY)
	animation_looped
