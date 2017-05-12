


/obj/item/organ/internal/voicebox/nabber
	name = "vocal synthesiser"
	parent_organ = BP_CHEST


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

	var/datum/gas_mixture/breath = owner.get_breath_from_environment()
	var/acetone_volume_raw = owner.reagents.get_reagent_amount("acetone")

	if((acetone_volume_raw < acetone_level || !acetone_volume_raw) && breath)
		var/datum/reagents/temp = new/datum/reagents(1)
		temp.add_reagent("acetone", 1)
		temp.trans_to_mob(owner, amount, CHEM_BLOOD,, 1)
	..()

/obj/item/organ/internal/tracheae
	name = "tracheae"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = BP_TRACH
	parent_organ = BP_GROIN

	var/breath_type
	var/poison_type
	var/exhale_type

	var/min_breath_pressure = 30

	var/safe_exhaled_max = 10
	var/safe_toxins_max = 10
	var/SA_para_min = 1
	var/SA_sleep_min = 5
	var/breathing = 0


/obj/item/organ/internal/tracheae/set_dna(var/datum/dna/new_dna)
	..()
	sync_breath_types()

/obj/item/organ/internal/tracheae/replaced()
	..()
	sync_breath_types()

/obj/item/organ/internal/tracheae/proc/sync_breath_types()
	min_breath_pressure = species.breath_pressure
	breath_type = species.breath_type ? species.breath_type : "oxygen"
	poison_type = species.poison_type ? species.poison_type : "phoron"
	exhale_type = species.exhale_type ? species.exhale_type : "carbon_dioxide"


/obj/item/organ/internal/tracheae/proc/handle_breath(var/datum/gas_mixture/breath)
	if(!owner)
		return 1
	if(!breath)
		return 1

	var/breath_pressure = breath.total_moles*R_IDEAL_GAS_EQUATION*breath.temperature/BREATH_VOLUME

	if(breath.total_moles == 0)
		return 1

	var/safe_pressure_min = min_breath_pressure // Minimum safe partial pressure of breathable gas in kPa
	// Lung damage increases the minimum safe pressure.
	if(is_broken())
		owner.adjustOxyLoss(1)
	else if(is_bruised())
		owner.adjustOxyLoss(3)

	var/failed_inhale = 0
	var/failed_exhale = 0

	var/inhaling = breath.gas[breath_type]
	var/poison = breath.gas[poison_type]
	var/exhaling = exhale_type ? breath.gas[exhale_type] : 0

	var/inhale_pp = (inhaling/breath.total_moles)*breath_pressure
	var/toxins_pp = (poison/breath.total_moles)*breath_pressure
	var/exhaled_pp = (exhaling/breath.total_moles)*breath_pressure
	// Not enough to breathe
	if(inhale_pp < safe_pressure_min)

		var/ratio = inhale_pp/safe_pressure_min
		owner.adjustOxyLoss(max(HUMAN_MAX_OXYLOSS*(1-ratio), 0))	// Don't fuck them up too fast (space only does HUMAN_MAX_OXYLOSS after all!)
		failed_inhale = 1

	owner.oxygen_alert = failed_inhale

	var/inhaled_gas_used = inhaling/6
	breath.adjust_gas(breath_type, -inhaled_gas_used, update = 0) //update afterwards

	if(exhale_type)
		breath.adjust_gas_temp(exhale_type, inhaled_gas_used, owner.bodytemperature, update = 0) //update afterwards
		// Too much exhaled gas in the air
		var/word
		var/warn_prob
		var/oxyloss
		var/alert

		if(exhaled_pp > safe_exhaled_max)
			word = pick("extremely dizzy","short of breath","faint","confused")
			warn_prob = 15
			oxyloss = HUMAN_MAX_OXYLOSS
			alert = 1
			failed_exhale = 1
		else if(exhaled_pp > safe_exhaled_max * 0.7)
			word = pick("dizzy","short of breath","faint","momentarily confused")
			warn_prob = 1
			alert = 1
			failed_exhale = 1
			var/ratio = 1.0 - (safe_exhaled_max - exhaled_pp)/(safe_exhaled_max*0.3)
			if (owner.getOxyLoss() < 50*ratio)
				oxyloss = HUMAN_MAX_OXYLOSS
		else if(exhaled_pp > safe_exhaled_max * 0.6)
			word = pick("a little dizzy","short of breath")
			warn_prob = 1
		else
			owner.co2_alert = 0

		if(!owner.co2_alert && word && prob(warn_prob))
			to_chat(owner, "<span class='warning'>You feel [word].</span>")
			owner.adjustOxyLoss(oxyloss)
			owner.co2_alert = alert

	// Too much poison in the air.
	if(toxins_pp > safe_toxins_max)
		var/ratio = (poison/safe_toxins_max) * 10
		owner.reagents.add_reagent("toxin", Clamp(ratio, MIN_TOXIN_DAMAGE, MAX_TOXIN_DAMAGE))
		breath.adjust_gas(poison_type, -poison/6, update = 0) //update after
		owner.phoron_alert = 1
	else
		owner.phoron_alert = 0

	// If there's some other shit in the air lets deal with it here.
	if(breath.gas["sleeping_agent"])
		var/SA_pp = (breath.gas["sleeping_agent"] / breath.total_moles) * breath_pressure
		if(SA_pp > SA_para_min)		// Enough to make us paralysed for a bit
			owner.Paralyse(3)	// 3 gives them one second to wake up and run away a bit!
			if(SA_pp > SA_sleep_min)	// Enough to make us sleep as well
				owner.Sleeping(5)
		else if(SA_pp > 0.15)	// There is sleeping gas in their lungs, but only a little, so give them a bit of a warning
			if(prob(20))
				owner.emote(pick("giggle", "laugh"))

		breath.adjust_gas("sleeping_agent", -breath.gas["sleeping_agent"]/6, update = 0) //update after

	// Were we able to breathe?
	var/failed_breath = failed_inhale || failed_exhale
	if (!failed_breath)
		owner.adjustOxyLoss(-5)
		if(robotic < ORGAN_ROBOT && species.breathing_sound && is_below_sound_pressure(get_turf(owner)))
			if(breathing || owner.shock_stage >= 10)
				sound_to(owner, sound(species.breathing_sound,0,0,0,5))
				breathing = 0
			else
				breathing = 1

	handle_temperature_effects(breath)
	breath.update_values()
	return failed_breath

/obj/item/organ/internal/tracheae/proc/handle_temperature_effects(datum/gas_mixture/breath)
	// Hot air hurts :(
	if((breath.temperature < species.cold_level_1 || breath.temperature > species.heat_level_1) && !(COLD_RESISTANCE in owner.mutations))
		var/damage = 0
		if(breath.temperature <= species.cold_level_1)
			if(prob(20))
				to_chat(owner, "<span class='danger'>You feel your face freezing and icicles forming in your lungs!</span>")

			switch(breath.temperature)
				if(species.cold_level_3 to species.cold_level_2)
					damage = COLD_GAS_DAMAGE_LEVEL_3
				if(species.cold_level_2 to species.cold_level_1)
					damage = COLD_GAS_DAMAGE_LEVEL_2
				else
					damage = COLD_GAS_DAMAGE_LEVEL_1

			owner.apply_damage(damage, BURN, BP_HEAD, used_weapon = "Excessive Cold")
			owner.fire_alert = 1
		else if(breath.temperature >= species.heat_level_1)
			if(prob(20))
				to_chat(owner, "<span class='danger'>You feel your face burning and a searing heat in your lungs!</span>")

			switch(breath.temperature)
				if(species.heat_level_1 to species.heat_level_2)
					damage = HEAT_GAS_DAMAGE_LEVEL_1
				if(species.heat_level_2 to species.heat_level_3)
					damage = HEAT_GAS_DAMAGE_LEVEL_2
				else
					damage = HEAT_GAS_DAMAGE_LEVEL_3

			owner.apply_damage(damage, BURN, BP_HEAD, used_weapon = "Excessive Heat")
			owner.fire_alert = 2

		//breathing in hot/cold air also heats/cools you a bit
		var/temp_adj = breath.temperature - owner.bodytemperature
		if (temp_adj < 0)
			temp_adj /= (BODYTEMP_COLD_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed
		else
			temp_adj /= (BODYTEMP_HEAT_DIVISOR * 5)	//don't raise temperature as much as if we were directly exposed

		var/relative_density = breath.total_moles / (MOLES_CELLSTANDARD * BREATH_PERCENTAGE)
		temp_adj *= relative_density

		if (temp_adj > BODYTEMP_HEATING_MAX) temp_adj = BODYTEMP_HEATING_MAX
		if (temp_adj < BODYTEMP_COOLING_MAX) temp_adj = BODYTEMP_COOLING_MAX
//		log_debug("Breath: [breath.temperature], [src]: [bodytemperature], Adjusting: [temp_adj]")
		owner.bodytemperature += temp_adj

	else if(breath.temperature >= species.heat_discomfort_level)
		species.get_environment_discomfort(owner,"heat")
	else if(breath.temperature <= species.cold_discomfort_level)
		species.get_environment_discomfort(owner,"cold")

/obj/item/organ/internal/heart/nabber
	open = 1

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