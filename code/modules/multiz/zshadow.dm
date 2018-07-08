/mob  // TODO: rewrite as obj. If more efficient
	var/mob/zshadow/above_shadow
	var/mob/zshadow/below_shadow

/mob/zshadow
	plane = OVER_OPENSPACE_PLANE
	name = "shadow"
	desc = "Z-level shadow"
	status_flags = GODMODE
	anchored = 1
	unacidable = 1
	density = 0
	opacity = 0					// Don't trigger lighting recalcs gah! TODO - consider multi-z lighting.
	//auto_init = FALSE 			// We do not need to be initialize()d
	var/mob/owner = null		// What we are a shadow of.

/mob/zshadow/can_fall()
	return FALSE

/mob/zshadow/New(var/mob/L)
	if(!istype(L))
		qdel(src)
		return
	..() // I'm cautious about this, but its the right thing to do.
	owner = L
	sync_icon(L)
	GLOB.dir_set_event.register(L, src, /mob/zshadow/proc/update_dir)
	GLOB.invisibility_set_event.register(L, src, /mob/zshadow/proc/update_invisibility)


/mob/Destroy()
	if(above_shadow)
		qdel(above_shadow)
		above_shadow = null
	. = ..()

/mob/zshadow/Destroy()
	GLOB.dir_set_event.unregister(owner, src, /mob/zshadow/proc/update_dir)
	GLOB.invisibility_set_event.unregister(owner, src, /mob/zshadow/proc/update_invisibility)
	. = ..()

/mob/zshadow/examine(mob/user, distance, infix, suffix)
	return owner.examine(user, distance, infix, suffix)

// Relay some stuff they hear
/mob/zshadow/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "", var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(speaker && speaker.z != src.z)
		return // Only relay speech on our actual z, otherwise we might relay sounds that were themselves relayed up!
	if(isliving(owner))
		verb += " from above"
	return owner.hear_say(message, verb, language, alt_name, italics, speaker, speech_sound, sound_vol)

/mob/zshadow/proc/sync_icon(var/mob/M)
	var/lay = src.layer
	var/pln = src.plane
	appearance = M
	color = "#848484"
	dir = M.dir
	src.layer = lay
	src.plane = pln
	if(above_shadow)
		above_shadow.sync_icon(src)

/mob/living/proc/check_shadow()
	var/mob/M = src
	if(isturf(M.loc))
		for(var/turf/simulated/open/OS = GetAbove(src); OS && istype(OS); OS = GetAbove(OS))
			//Check above
			if(!M.above_shadow)
				M.above_shadow = new /mob/zshadow(M)
			M.above_shadow.forceMove(OS)
			M = M.above_shadow

		M.clean_shadow(above_shadow)
			
		M = src
			
		for(var/turf/simulated/open/OS = get_turf(src); OS && istype(OS); OS = GetBelow(OS))
			//Check above
			var/turf/below = GetBelow(OS)
			if(!M.below_shadow)
				M.below_shadow = new /mob/zshadow(M)
			M.below_shadow.forceMove(below)
			M = M.below_shadow

		M.clean_shadow(below_shadow)
	else
		M.clean_shadow(above_shadow)
		M.clean_shadow(below_shadow)


/mob/proc/clean_shadow(var/mob/zshadow/Z)
	var/client/C = src.client
	if(C && C.eye == Z)
		src.reset_view(0)
	QDEL_NULL(Z)

//
// Handle cases where the owner mob might have changed its icon or overlays.
//

/mob/living/update_icons()
	. = ..()
	if(above_shadow)
		above_shadow.sync_icon(src)

// WARNING - the true carbon/human/update_icons does not call ..(), therefore we must sideways override this.
// But be careful, we don't want to screw with that proc.  So lets be cautious about what we do here.
/mob/living/carbon/human/update_icons()
	. = ..()
	if(above_shadow)
		above_shadow.sync_icon(src)

//Copy direction
/mob/zshadow/proc/update_dir()
	set_dir(owner.dir)


//Change name of shadow if it's updated too (generally moving will sync but static updates are handy)
/mob/fully_replace_character_name(var/new_name, var/in_depth = TRUE)
	. = ..()
	if(above_shadow)
		above_shadow.fully_replace_character_name(new_name)


/mob/zshadow/proc/update_invisibility()
	set_invisibility(owner.invisibility)