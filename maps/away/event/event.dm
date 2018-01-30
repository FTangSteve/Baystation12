#include "event_areas.dm"
#include "event_floors.dm"
#include "event_walls.dm"
#include "event_structures.dm"
#include "event_materials.dm"
#include "event_doors.dm"

/obj/effect/overmap/sector/event
	name = "space whale"
	desc = "Sensors detect an orbital station above the exoplanet. Sporadic magentic impulses are registred inside it. Planet landing is impossible due to lower orbits being cluttered with chaotically moving metal chunks."
	icon_state = "object"
	known = 0

/datum/map_template/ruin/away_site/event
	name = "DeadWhale"
	id = "awaysite_deadwhale"
	description = "It's a whale."
	suffixes = list("event/whale_dead.dmm")
	cost = 1

