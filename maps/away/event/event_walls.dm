/turf/simulated/wall/event

/turf/simulated/wall/event/flesh
	name = "flesh"
	desc = "A huge chunk of flesh used to seperate rooms."
	icon = 'maps/away/event/wall.dmi'
	icon_state = "flesh"
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

/turf/simulated/wall/event/bone
	name = "bone"
	desc = "A huge chunk of bone used to seperate rooms."
	icon = 'maps/away/event/wall.dmi'
	icon_state = "bone"
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

/turf/simulated/wall/event/blueskin
	name = "skin"
	desc = "A huge chunk of skin used on the outside of large animals."
	icon = 'maps/away/event/wall.dmi'
	icon_state = "blue"
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

/turf/simulated/wall/event/scale
	name = "scales"
	desc = "A wall made of numerous interlocking scales."
	icon = 'maps/away/event/wall.dmi'
	icon_state = "scale"
	floor_type = /turf/simulated/floor/event/scale
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

/turf/simulated/wall/event/fat
	name = "blubber"
	desc = "A thick layer of blubber."
	icon = 'maps/away/event/wall.dmi'
	icon_state = "fat"
	opacity = 1
	density = 1
	blocks_air = 1
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall

/turf/simulated/wall/event/New()
	..()
	name = initial(name)
	desc = initial(desc)
	icon = initial(icon)
	icon_state = initial(icon_state)

/turf/simulated/wall/event/update_icon()
	icon = initial(icon)
	icon_state = initial(icon_state)
	overlays.Cut()