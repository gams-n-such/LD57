class_name PlayerInventory
extends Node

#region Bamboo

@onready var bamboo_bag : Node = %BambooBunch

func get_bamboos() -> Array[BambooItem]:
	var result : Array[BambooItem] = []
	for node in bamboo_bag.get_children():
		if node is BambooItem:
			result.append(node as BambooItem)
	return result

func add_bamboo(new_bamboo : BambooItem) -> void:
	bamboo_bag.add_child(new_bamboo)

func remove_bamboo(old_bamboo : BambooItem) -> void:
	assert(bamboo_bag.is_ancestor_of(old_bamboo))
	bamboo_bag.remove_child(old_bamboo)

#endregion
