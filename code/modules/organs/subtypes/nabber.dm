


/obj/item/organ/internal/voicebox/nabber
	name = "vocal synthesiser"
	parent_organ = BP_CHEST
	organ_tag = BP_VOICE
	will_assist_languages = list(LANGUAGE_GALCOM)

/obj/item/organ/internal/voicebox/nabber/New()
	for(var/L in will_assist_languages)
		assists_languages += all_languages[L]


/obj/item/organ/internal/eyes/nabber
	name = "compound eyes"
	innate_flash_protection = FLASH_PROTECTION_VULNERABLE
	var/eyes_shielded

/obj/item/organ/internal/eyes/nabber/additional_flash_effects(var/intensity)
	if(is_usable())
		take_damage(max(0, 8 * (intensity)))
		return 1
	else
		return -1

/obj/item/organ/internal/eyes/nabber/verb/shield_eyes()
	set category = "IC"
	set name = "Shield Eyes"
	set src in usr

	eyes_shielded = !eyes_shielded

	if(eyes_shielded)
		to_chat(owner, "<span class='notice'>Nearly opaque lenses slide down to shield your eyes.</span>")
		innate_flash_protection = FLASH_PROTECTION_MAJOR
		owner.eye_blind += 20
	else
		to_chat(owner, "<span class='notice'>Your protective lenses retract out of the way.</span>")
		innate_flash_protection = FLASH_PROTECTION_VULNERABLE
		owner.eye_blind = max(0, owner.eye_blind - 20)

/obj/item/organ/internal/phoron
	name = "phoron storage"
	organ_tag = BP_PHORON
	parent_organ = BP_CHEST
	var/dexalin_level = 5
	var/phoron_level = 0.2

/obj/item/organ/internal/phoron/process()
	var amount = 0.1
	if(is_broken())
		amount *= 0.5
	else if(is_bruised())
		amount *= 0.1

	var/dexalin_volume_raw = owner.reagents.get_reagent_amount("dexalin")
	var/phoron_volume_raw = owner.reagents.get_reagent_amount("phoron")

	if((dexalin_volume_raw < dexalin_level || !dexalin_volume_raw) && (phoron_volume_raw < phoron_level || !phoron_volume_raw))
		var/datum/reagents/temp = new/datum/reagents(1)
		temp.add_reagent("phoron", 1)
		temp.trans_to_mob(owner, amount, CHEM_BLOOD,, 1)
		dexalin_volume_raw = owner.reagents.get_reagent_amount("dexalin")
		phoron_volume_raw = owner.reagents.get_reagent_amount("phoron")
	..()

/obj/item/organ/internal/liver/nabber
	name = "acetone reactor"
	var/acetone_level = 10

/obj/item/organ/internal/liver/nabber/process()
	var amount = 0.8
	if(is_broken())
		amount *= 0.5
	else if(is_bruised())
		amount *= 0.1

	var/acetone_volume_raw = owner.reagents.get_reagent_amount("acetone")

	if((acetone_volume_raw < acetone_level || !acetone_volume_raw) && owner.breath_fail_ratio < 0.25)
		var/datum/reagents/temp = new/datum/reagents(1)
		temp.add_reagent("acetone", 1)
		temp.trans_to_mob(owner, amount, CHEM_BLOOD,, 1)
	..()

/obj/item/organ/internal/respirator/tracheae
	name = "tracheae"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = BP_TRACH
	parent_organ = BP_GROIN

	active_breathing = 0

	min_breath_pressure = 30

	safe_toxins_max = 10


/obj/item/organ/internal/heart/nabber/handle_pulse()
	if(owner.stat == DEAD || robotic >= ORGAN_ROBOT)
		pulse = PULSE_NONE	//that's it, you're dead (or your metal heart is), nothing can influence your pulse
		return
	if(owner.life_tick % 5 == 0)//update pulse every 5 life ticks (~1 tick/sec, depending on server load)
		pulse = PULSE_NORM

		if(round(owner.vessel.get_reagent_amount("blood")) <= BLOOD_VOLUME_BAD)	//how much blood do we have
			pulse  = PULSE_THREADY	//not enough :(

		else if(owner.status_flags & FAKEDEATH || owner.chem_effects[CE_NOPULSE])
			pulse = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds
			pulse = Clamp(pulse + owner.chem_effects[CE_PULSE], PULSE_NONE, PULSE_2FAST)
		else
			pulse = Clamp(pulse + owner.chem_effects[CE_PULSE], PULSE_SLOW, PULSE_2FAST)

/obj/item/organ/internal/brain/nabber
	var lowblood_tally = 0
	var lowblood_mult = 2
	name = "distributed nervous system"
	parent_organ = BP_CHEST


/obj/item/organ/internal/brain/nabber/process()
	if(!owner || !owner.should_have_organ(BP_HEART))
		return

	// No heart? You are going to have a very bad time. Not 100% lethal because heart transplants should be a thing.
	var/blood_volume = owner.get_effective_blood_volume()
	if(!owner.internal_organs_by_name[BP_HEART])
		if(blood_volume > BLOOD_VOLUME_SURVIVE)
			blood_volume = BLOOD_VOLUME_SURVIVE
		owner.Paralyse(3)

	//Effects of bloodloss
	switch(blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			lowblood_tally = 1 * lowblood_mult
			if(prob(1))
				to_chat(owner, "<span class='warning'>You're finding it difficult to move.</span>")
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			lowblood_tally = 3 * lowblood_mult
			if(prob(1))
				to_chat(owner, "<span class='warning'>Moving has become very difficult.</span>")
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			lowblood_tally = 5 * lowblood_mult
			if(prob(15))
				to_chat(owner, "<span class='warning'>You're almost unable to move!</span>")
		if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
			lowblood_tally = 6 * lowblood_mult
			if(prob(10))
				to_chat(owner, "<span class='warning'>Your body is barely functioning and is starting to shut down.</span>")
				owner.Paralyse(1)
			for(var/obj/item/organ/internal/I in owner.internal_organs)
				if(prob(5))
					I.take_damage(5)

/obj/item/organ/external/chest/nabber
	name = "thorax"

/obj/item/organ/external/groin/nabber
	name = "abdomen"

/obj/item/organ/external/arm/nabber
	name = "left arm"
	amputation_point = "coxa"

/obj/item/organ/external/arm/right/nabber
	name = "right arm"
	amputation_point = "coxa"

/obj/item/organ/external/leg/nabber
	name = "left tail side"

/obj/item/organ/external/leg/right/nabber
	name = "right tail side"

/obj/item/organ/external/foot/nabber
	name = "left tail tip"

/obj/item/organ/external/foot/right/nabber
	name = "right tail tip"

/obj/item/organ/external/hand/nabber
	name = "left grasper"

/obj/item/organ/external/hand/right/nabber
	name = "right grasper"

/obj/item/organ/external/head/nabber
	name = "head"
	eye_icon = "eyes_s"
	has_lips = 0