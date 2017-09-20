/datum/nano_module/law_manager/pref_law_manager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]

	data["law_sets"] = package_multiple_laws(data["isAdmin"] ? admin_laws : player_laws)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "law_manager.tmpl", sanitize("[src] - [owner]"), 800, is_malf(user) ? 600 : 400, state = state)
		ui.set_initial_data(data)
		ui.open()
