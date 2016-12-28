/datum/game_mode/borer
	name = "Cortical Borers"
	round_description = "A group of cortical borers has arrived on the station."
	extended_round_description = "The borers will work to create a plan, either individually or as a group. Will the crew help these strange creatures or work against them?"
	config_tag = "borer"
	required_players = 8
	required_enemies = 2
	end_on_antag_death = 0
	auto_recall_shuttle = 0
	antag_tags = list(MODE_BORER)
	disabled_jobs = list("AI")