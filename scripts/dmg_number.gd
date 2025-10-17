class_name DMGNumber
extends Label

func start(value : int) :
	self.text = str(value)
	var tween = create_tween()
	self.position = Vector2(0, 0)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0.55), 0.45)
	tween.parallel().tween_property(self, "position", Vector2(8, -26), 0.45).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.55)
	tween.parallel().tween_property(self, "position", Vector2(16, 50), 0.55).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()
