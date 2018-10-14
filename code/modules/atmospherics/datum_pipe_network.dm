/datum/pipe_network
	var/list/datum/gas_mixture/gases = list() //All of the gas_mixtures continuously connected in this network
	var/volume = 0	//caches the total volume for atmos machines to use in gas calculations

	var/list/obj/machinery/atmospherics/normal_members = list()
	var/list/datum/pipeline/line_members = list()
		//membership roster to go through for updates and what not
	var/list/leaks = list()
	var/update = 1

	var/i
	var/j

/datum/pipe_network/proc/find_crossover()
	var/message	= "Shared pipes are:\n"
	var/list/obj/machinery/atmospherics/pipe/shared_pipe_list = list()
	for(var/i=1; i<=line_members.len-1; i++)
		var/datum/pipeline/check_base = line_members[i]
		for(var/j=i+1; j<=line_members.len; j++)
			var/datum/pipeline/check_against = line_members[j]

			for(var/obj/machinery/atmospherics/pipe/base_pipe in check_base.edges)
				for(var/obj/machinery/atmospherics/pipe/against_pipe in check_against.edges)
					var/list/obj/machinery/atmospherics/pipe/anded_list = (base_pipe.pipeline_expansion() + base_pipe) & (against_pipe.pipeline_expansion() + against_pipe)

					if(anded_list.len > 0)
						for(var/obj/v in anded_list)
							message += "[v.name] <A HREF='?_src_=vars;Vars=\ref[v]'>\ref[v]</A> \n"

						message_admins("under shared pipes")
						shared_pipe_list.Add(anded_list)

	message_admins(message)


/datum/pipe_network/Destroy()
	STOP_PROCESSING_PIPENET(src)
	for(var/datum/pipeline/line_member in line_members)
		line_member.network = null
	for(var/obj/machinery/atmospherics/normal_member in normal_members)
		normal_member.reassign_network(src, null)
	gases.Cut()  // Do not qdel the gases, we don't own them
	leaks.Cut()
	normal_members.Cut()
	line_members.Cut()
	return ..()

/datum/pipe_network/Process()
	//Equalize gases amongst pipe if called for
	if(update)
		update = 0
		reconcile_air() //equalize_gases(gases)

	//Give pipelines their process call for pressure checking and what not. Have to remove pressure checks for the time being as pipes dont radiate heat - Mport
	//for(var/datum/pipeline/line_member in line_members)
	//	line_member.process()

/datum/pipe_network/proc/build_network(obj/machinery/atmospherics/start_normal, obj/machinery/atmospherics/reference)
	//Purpose: Generate membership roster
	//Notes: Assuming that members will add themselves to appropriate roster in network_expand()

	if(!start_normal)
		qdel(src)
		return
	start_normal.network_expand(src, reference)

	update_network_gases()

	if((normal_members.len>0)||(line_members.len>0))
		START_PROCESSING_PIPENET(src)
		return 1
	qdel(src)

/datum/pipe_network/proc/merge(datum/pipe_network/giver)
	if(giver==src) return 0

	normal_members |= giver.normal_members

	line_members |= giver.line_members

	leaks |= giver.leaks

	for(var/obj/machinery/atmospherics/normal_member in giver.normal_members)
		normal_member.reassign_network(giver, src)

	for(var/datum/pipeline/line_member in giver.line_members)
		line_member.network = src

	update_network_gases()
	return 1

/datum/pipe_network/proc/update_network_gases()
	//Go through membership roster and make sure gases is up to date

	gases = list()
	volume = 0

	for(var/obj/machinery/atmospherics/normal_member in normal_members)
		var/result = normal_member.return_network_air(src)
		if(result) gases += result

	for(var/datum/pipeline/line_member in line_members)
		gases += line_member.air

	for(var/datum/gas_mixture/air in gases)
		volume += air.volume

/datum/pipe_network/proc/reconcile_air()
	equalize_gases(gases)
