extends Spatial

const OFFSET = Vector3(0, 10, 0)

func hoverover(target):
	var spritenode = get_node("Arrow")
	spritenode.global_translate(
		target.get_global_transform().origin+OFFSET
	)
