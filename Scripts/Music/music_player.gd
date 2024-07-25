extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	play()

func change_music(new_music : AudioStream):
	if stream != new_music:
		print("test1")
		stream = new_music
		play()

func _process(_delta):
	if !playing:
		play()
