/obj/item/stack/material/sandstone/

/obj/machinery/door/unpowered/simple/event/scale/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "scale", complexity)

/obj/machinery/door/unpowered/simple/event/bone/New(var/newloc,var/material_name,var/complexity)
	..(newloc, "bone", complexity)

/material/event
	name = "event"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "scale"
	table_icon_base = "scale"
	icon_reinf = "reinf_stone"
	icon_colour = "#ffffff"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	brute_armor = 3
	door_icon_base = "scale"
	sheet_singular_name = "scale"
	sheet_plural_name = "scales"
	conductive = 0

/material/event/scale
	name = "scale"

/material/event/bone
	name = "bone"
	stack_type = /obj/item/stack/material/sandstone
	icon_base = "bone"
	table_icon_base = "bone"
	icon_reinf = "reinf_stone"
	icon_colour = "#ffffff"
	shard_type = SHARD_STONE_PIECE
	weight = 22
	hardness = 55
	brute_armor = 3
	door_icon_base = "bone"
	sheet_singular_name = "bone"
	sheet_plural_name = "bones"
	conductive = 0
