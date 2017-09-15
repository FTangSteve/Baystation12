/mob/living/silicon/sil_brainmob
	var/obj/item/organ/internal/posibrain/container = null
	var/emp_damage = 0//Handles a type of MMI damage
	var/alert = null
	use_me = 0 //Can't use the me verb, it's a freaking immobile brain
	icon = 'icons/obj/surgery.dmi'
	icon_state = "brain-prosthetic"

	New()
		var/datum/reagents/R = new/datum/reagents(1000)
		reagents = R
		R.my_atom = src
		if(istype(loc, /obj/item/organ/internal/posibrain))
			container = loc
		..()

	Destroy()
		if(key)				//If there is a mob connected to this thing. Have to check key twice to avoid false death reporting.
			if(stat!=DEAD)	//If not dead.
				death(1)	//Brains can die again. AND THEY SHOULD AHA HA HA HA HA HA
			ghostize()		//Ghostize checks for key so nothing else is necessary.
		..()

	say_understands(var/other)//Goddamn is this hackish, but this say code is so odd
		if (istype(other, /mob/living/silicon/ai))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/decoy))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/pai))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/silicon/robot))
			if(!(container && istype(container, /obj/item/device/mmi)))
				return 0
			else
				return 1
		if (istype(other, /mob/living/carbon/human))
			return 1
		if (istype(other, /mob/living/carbon/slime))
			return 1
		return ..()

/mob/living/silicon/sil_brainmob/update_canmove()
	if(in_contents_of(/obj/mecha))
		canmove = 1
		use_me = 1
	else if(container && istype(container, /obj/item/organ/internal/posibrain) && istype(container.loc, /turf))
		canmove = 1
		use_me = 1
	else
		canmove = 0
	return canmove

/mob/living/silicon/sil_brainmob/isSynthetic()
	return 1

/mob/living/silicon/sil_brainmob/binarycheck()
	return isSynthetic()

/mob/living/silicon/sil_brainmob/check_has_mouth()
	return 0

/mob/living/silicon/sil_brainmob/show_laws(mob/M)
	if(M)
		to_chat(M, "<b>Obey these laws [M]:</b>")
		src.laws_sanity_check()
		src.laws.show_laws(M)

/mob/living/silicon/sil_brainmob/open_subsystem(var/subsystem_type, var/mob/given)
	var/stat_silicon_subsystem/SSS = silicon_subsystems[subsystem_type]
	if(!istype(SSS))
		return FALSE
	SSS.Click(given)
	return TRUE
