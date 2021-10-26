extends Spatial

const OFFSET_ARROW = Vector3(0, 10, 0)
const OFFSET_HP = Vector3(0, 2, 0)

func hoverover():
	$Arrow.translate(
		OFFSET_ARROW
	)
	$Window.translate(
		OFFSET_HP
	)
