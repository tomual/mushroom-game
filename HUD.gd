extends CanvasLayer

func _ready():
	for member in get_tree().get_nodes_in_group("interactable"):
		print_debug(member)
		member.connect("interactable_available", self, "interactable_available")

func interactable_available():
	print_debug("interactable_available")
