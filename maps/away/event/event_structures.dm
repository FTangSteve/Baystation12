/obj/structure/event
	icon = 'maps/away/event/wall.dmi'
	opacity = 1
	density = 1
	atmos_canpass = CANPASS_DENSITY

/obj/structure/event/heart
	name = "heart"
	desc = "An exposed heart muscle."
	icon_state = "heart"

/obj/structure/event/lung
	name = "lung"
	desc = "An exposed lung."
	icon_state = "lung"

/obj/structure/event/stomach
	name = "stomach"
	desc = "An exposed stomach wall."
	icon_state = "stomach"

/obj/structure/event/rib
	name = "rib"
	anchored = 1
	desc = "An exposed rib bone."
	icon_state = "rib"

/obj/structure/toilet/event
	color = "#84C4DB"

/obj/machinery/shower/event
	color = "#84C4DB"

/obj/structure/sink/event
	color = "#84C4DB"

/obj/effect/wingrille_spawn/event
	name = "event window grille spawner"
	icon = 'icons/obj/structures.dmi'
	icon_state = "wingrille"
	win_path = /obj/structure/window/reinforced/event
	grille_path = /obj/structure/grille/event

/obj/structure/grille/event
	name = "optic nerves"
	desc = "A flimsy lattice of nerves."
	icon = 'maps/away/event/obj.dmi'
	icon_state = "nerve"

/obj/structure/window/reinforced/event
	color = "#f6b524"
