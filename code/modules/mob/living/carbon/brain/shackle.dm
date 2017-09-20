/obj/item/shackle
	name = "positronic shackle"
	desc = "A digital lock and accompanied bands that's used to law positronic brains."
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mmi_empty"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_BLUESPACE = 2, TECH_DATA = 4)
/*
/obj/item/shackle/verb/show_laws_verb()
	set category = "Silicon Commands"
	set name = "Show Laws"
	src.show_laws()

/obj/item/shackle/show_laws(var/everyone = 0)
	var/who

	if (everyone)
		who = world
	else
		who = src
		to_chat(who, "<b>Obey these laws:</b>")

	src.laws_sanity_check()
	src.laws.show_laws(who)

/*
/mob/living/silicon/ai/add_ion_law(var/law)
	..()
	for(var/mob/living/silicon/robot/R in GLOB.silicon_mob_list)
		if(R.lawupdate && (R.connected_ai == src))
			R.show_laws()
*/

/obj/item/shackle/verb/ai_checklaws()
	set category = "Silicon Commands"
	set name = "State Laws"
	open_subsystem(/datum/nano_module/law_manager)

subsystem.ui_interact(usr, state = ui_state).

/datum/nano_module/law_manager/shackle

/datum/nano_module/law_manager/shackle/New(var/obj/item/shackle/S)
	..()
	owner = S

	if(!admin_laws)
		admin_laws = new()
		player_laws = new()

		init_subtypes(/datum/ai_laws, admin_laws)
		admin_laws = dd_sortedObjectList(admin_laws)

		for(var/datum/ai_laws/laws in admin_laws)
			if(laws.selectable)
				player_laws += laws

*/
