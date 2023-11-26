extends Node


class_name EventClass
signal on_value_change(new_value)
@export var data=false:
	get:
		return data
	set(value):
		on_value_change.emit(value)
		data = value

