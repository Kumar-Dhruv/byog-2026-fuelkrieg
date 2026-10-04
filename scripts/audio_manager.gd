extends Node

# Global parameters applied to all sounds
@export var base_volume: float = 0.0
@export var volume_variance: float = 2.0  # Randomly adds/subtracts up to 2.0 dB

@export var base_pitch: float = 1.0
@export var pitch_variance: float = 0.1   # Randomly adds/subtracts up to 0.1 pitch

# Dictionary mapping String IDs directly to AudioStream files
@onready var sounds: Dictionary = {
	"explosion" : preload("uid://cwapgsahw2yd2"),
	"low fuel" : preload("uid://cn1sj58jh6w4d")
}

func play(id: String) -> void:
	if not sounds.has(id):
		push_warning("AudioManager: Sound ID '" + id + "' not found!")
		return
		
	var player = AudioStreamPlayer.new()
	player.stream = sounds[id]
	
	var random_vol = randf_range(-volume_variance, volume_variance)
	player.volume_db = base_volume + random_vol
	
	var random_pitch = randf_range(-pitch_variance, pitch_variance)
	player.pitch_scale = base_pitch + random_pitch
	
	# Tag this specific player with its ID so we can find it later
	player.set_meta("sfx_id", id)
	
	add_child(player)
	player.play()
	player.finished.connect(player.queue_free)

func stop(id: String) -> void:
	# Loop through all child nodes (which are our active AudioStreamPlayers)
	for child in get_children():
		# Check if the child has our tag, and if it matches the ID we want to stop
		if child is AudioStreamPlayer and child.has_meta("sfx_id") and child.get_meta("sfx_id") == id:
			child.stop()          # Stop the audio instantly
			child.queue_free()    # Delete the node from memory
