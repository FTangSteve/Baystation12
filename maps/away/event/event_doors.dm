/obj/machinery/door/unpowered/simple/event
	autoclose = 1

/obj/machinery/door/unpowered/simple/event/scale
	icon = 'maps/away/event/scaledoor.dmi'
	icon_state = "scale"

/obj/machinery/door/unpowered/simple/event/bone
	icon = 'maps/away/event/bonedoor.dmi'
	icon_state = "bone"

/*

/obj/machinery/door/event/do_animate(animation)
	switch(animation)
		if("opening")
			icon_state = "scale_open"
		if("closing")
			icon_state = "scale_close"
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && !(stat & (NOPOWER|BROKEN)))
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/buzz-two.ogg', 50, 0)
	return
*/
