extends ProgressBar

@onready var train: Train = $"../../Railway/Train"

func _ready() -> void:
	min_value = 0.0
	max_value = 100.0
	value = 0.0
	
	if not is_instance_valid(train):
		await get_tree().process_frame
		train = get_node_or_null("../../../Railway/Train")

func _process(delta: float) -> void:
	if is_instance_valid(train):
		value = train.progress_ratio * 100.0
