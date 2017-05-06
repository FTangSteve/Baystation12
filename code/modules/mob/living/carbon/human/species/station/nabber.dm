/datum/species/nabber
	name = SPECIES_NABBER
	name_plural = "Nab-PlaceHolders"
	blurb = "A race of large insectoid creatures."

	blood_color = "#525252"
	flesh_color = "#525252"

	reagent_tag = IS_NABBER

	icon_template = 'icons/mob/human_races/r_nabber.dmi'
	icobase = 'icons/mob/human_races/r_nabber.dmi'
	deform = 'icons/mob/human_races/r_nabber.dmi'

	slowdown = -1
	total_health = 300
	brute_mod = 0.85
	burn_mod =  1.35
	mob_size = MOB_LARGE

	appearance_flags = 0
	spawn_flags = SPECIES_IS_RESTRICTED

	reagent_tag = IS_NABBER

/datum/species/diona/get_blood_name()
	return "haemolymph"
