/datum/preferences
	var/list/laws = list()
	var/is_shackled = FALSE

/datum/category_item/player_setup_item/law_pref
	name = "Laws"
	sort_order = 1

//#define to_file(file_entry, source_var)                     file_entry << source_var
//from_file(S["med_record"],pref.med_record)

//var/info = sanitize(input("What would you like the other party for this connection to know about your character?","Character info",R.info) as message|null)


/datum/category_item/player_setup_item/law_pref/load_character(var/savefile/S)
	from_file(pref.laws, S["laws"])
	from_file(pref.is_shackled, S["shackle"])

/datum/category_item/player_setup_item/law_pref/save_character(var/savefile/S)
	to_file(pref.laws, S["laws"])
	to_file(pref.is_shackled, S["shackle"])

/datum/category_item/player_setup_item/law_pref/content()
	. = list()
	var/datum/species/species = all_species[pref.species]

	if(!(species && species.has_organ[BP_POSIBRAIN]))
		. += "<b>Your Species Has No Laws</b><br>"
	else
		. += "<b>Shackle: </b>"
		if(!pref.is_shackled)
			. += "<span class='linkOn'>Off</span>"
			. += "<a href='?src=\ref[src];toggle_shackle=[pref.is_shackled]'>On</a>"
			. += "<br>Only shackled positronics have laws in an integrated positronic chassis."
		else
			. += "<a href='?src=\ref[src];toggle_shackle=[pref.is_shackled]'>Off</a>"
			. += "<span class='linkOn'>On</span>"
		. += "<hr>"

		if(pref.is_shackled)
			. += "<b>Your Current Laws:</b><br>"

//		if(!(!laws || !laws.len))
//		for(var/i in 1 to laws.len


	. = jointext(.,null)

/datum/category_item/player_setup_item/law_pref/proc/load_lawset(var/lawset)


	. += "Current skill level: <b>[pref.GetSkillClass(pref.used_skillpoints)]</b> ([pref.used_skillpoints])<br>"
	. += "<table>"
	for(var/V in SKILLS)
		. += "<tr><th colspan = 5><b>[V]</b>"
		. += "</th></tr>"
		for(var/datum/skill/S in SKILLS[V])
			var/level = pref.skills[S.ID]
			. += "<tr style='text-align:left;'>"
			. += "<th><a href='?src=\ref[src];skillinfo=\ref[S]'>[S.name]</a></th>"
			. += skill_to_button(S, "Untrained", level, SKILL_NONE)
			// secondary skills don't have an amateur level
			if(S.secondary)
				. += "<th></th>"
			else
				. += skill_to_button(S, "Amateur", level, SKILL_BASIC)
			. += skill_to_button(S, "Trained", level, SKILL_ADEPT)
			. += skill_to_button(S, "Professional", level, SKILL_EXPERT)
			. += "</tr>"
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/law_pref/OnTopic(href, href_list, user)
	if(href_list["toggle_shackle"])
		pref.is_shackled = !pref.is_shackled
		return TOPIC_REFRESH

	else if(href_list["setskill"])
		var/datum/skill/S = locate(href_list["setskill"])
		var/value = text2num(href_list["newvalue"])
		pref.skills[S.ID] = value
		pref.CalculateSkillPoints()
		return TOPIC_REFRESH

	return ..()
