/*
	Gerericises ability trees for future use.
*/
// The tree is the main structure of the overal ability progression. Each tree is a group of branches with some other duties.
// The tree contains a list of branches associated with the tree. The tree is named using a define in the file /code/__defines/trees.dm
// Each tree is stored sectioned with its branches.
/datum/tree
	var/list/datum/branch/branches = list()		// What branches the tree has.in it.
	var/name = "An ability tree"				// The define for the tree in question
	var/desc = "What the tree does."			// Short description telling the user the tree's purpose.
	var/unlock_currency = "Units"				// What the name of the exchange currency is. For example,points.
	var/gather_rate = 1							// How much of the currency is gathered per tick.
	var/base_cost = 1							// The default cost of a level 1 ability in this tree.
	var/linear_scale							// How much the abilities of branches in this tree go up linearly by default.
	var/mult_scale = 1							// How much the abilities of branches in thie tree go up multiplicatively by default.
	var/useage_currency							// If using abilities in this tree costs currency and what the name of that currency is.
	var/useage_gather_rate						// The rate at which the currency to use abilities is gathered.
	var/useage_base_cost = 0					// The base amount using an ability costs. Can scale linearly or multiplicitavely with the ability level.
	var/useage_linear_scale						// How much the cost to use abilities of branches in this tree go up linearly by default.
	var/useage_mult_scale = 1					// How much the cost to use abilities of branches in thie tree go up multiplicatively by default.
//	var/preselect_ability = 0					// Whether abilities need to be selected in order for currency to be gathered. (ToDo: impliment this for the malfAI tree.)
	var/self_abilities = 1						// Whether the assosiated abilities wil affect the person the bark of the tree is assigned to.

// Branches are used as a part of a tree. A branch represents a section of abilities in which the avaliable abilities
// are dependant on other abilities contained in the branch. For example, if I was making a tree for elemental abilities,
// I may have the branches fire, water, earth, and air where only upon unlocking a certain number of air abilities will
// more become avaliable.
/datum/branch
	var/datum/tree/in_tree						// The tree this branch is in.
	var/list/datum/ability/abilities = list()	// All the abilities in this branch.
	var/name = "A branch of an ability tree."	// The define for the branch in question.
	var/desc = "Branch desc"					// A short description of the purpose of the branch.
	var/base_cost								// The basic cost for a level 1 ability in this branch.
	var/linear_scale							// How much the abilities of branches in this tree go up linearly by default.
	var/mult_scale								// How much the abilities of branches in thie tree go up multiplicatively by default.
	var/useage_base_cost						// The basic cost to use a level 1 ability in this branch.
	var/useage_linear_scale						// How much the cost to use abilities of branches in this tree go up linearly by default.
	var/useage_mult_scale						// How much the cost to use abilities of branches in thie tree go up multiplicatively by default.
	var/level_exclusive = 0						// Says whether a branch can only have one ability per level.

// The abilities are different things that may be unlocked. Each ability will have an associated verb that is granted to the player
// upon unlock. Abilities have a cost and a level. By default you need to unlock at least one level three ability before any level
// four abilities will become avaliable for unlock. Note that this is branch specific so unlocking an ability in another branch
// will not impact which abilities are avaliable in the current branch.
// Additionally, which abilities are unlocked is NOT stored in the abilities themselves, but instead is stored in bark.

/datum/ability
	var/datum/branch/in_branch					// The branch of the tree this ability is on.
	var/ability = null 							// Path to verb which will be given to the mob designated by the bark when researched.
	var/name = "Unknown Ability"				// Name of this ability.
	var/level = 1								// What level of the tree this ability is on.
	var/cost									// The cost to unlock this ability.
	var/useage_cost								// The cost to use this ability.

// Each different object with acceess to an ability tree has a bark object assosiated with them. This bark object
// tracks what the individual has unlocked and avaliable as the overarching tree is a singleton.
/datum/bark
	var/datum/tree/for_tree						// The tree this bark covers.
	var/branch_stats[][3]						// A multidimentional list that stores information about the currency invested in and the unlock level of each branch.
	var/current_currency = 0					// How much currency the object containing the bark currently has avaliable.
	var/total_currency = 0						// How much currency the object has had in total, including that which has already been spent.
	var/mob/controller							// Who gets to control the bark as the entity which owns the bark may not be the entity who gets access to the tree.
	var/ability_currency						// W


/datum/tree/proc/init()

	if (!linear_scale)
		linear_scale = base_cost

	if (useage_currency && !useage_linear_scale)
		useage_linear_scale = useage_base_cost

	for (var/datum/branch/B in branches)
		B.init()


/datum/branch/proc/init()

	if (!base_cost)
		base_cost = in_tree.base_cost
	if (!linear_scale)
		linear_scale = in_tree.linear_scale
	if (!mult_scale)
		mult_scale = in_tree.mult_scale

	if (in_tree.useage_currency)
		if (!useage_base_cost)
			useage_base_cost = in_tree.useage_base_cost
		if (!useage_linear_scale)
			useage_linear_scale = in_tree.useage_linear_scale
		if (!useage_mult_scale)
			useage_mult_scale = in_tree.useage_mult_scale
//	else
//		if (useage_base_cost)
//			#error If you don't have a name for useage_currency in a tree, you can't use any of the useage_* variables in the branches.
//		if (useage_linear_scale)
//			#error If you don't have a name for useage_currency in a tree, you can't use any of the useage_* variables in the branches.
//		if (useage_mult_scale)
//			#error If you don't have a name for useage_currency in a tree, you can't use any of the useage_* variables in the branches.

	for (var/datum/ability/A in abilities)
		A.init()

/datum/ability/proc/init()

	if (!cost)
		cost = ((in_branch.base_cost + (in_branch.linear_scale * level)) * (in_branch.mult_scale ^ level))

	if (!useage_cost)
		useage_cost = ((in_branch.useage_base_cost + (in_branch.useage_linear_scale * level)) * (in_branch.useage_mult_scale ^ level))
//	else if (in_branch.in_tree.useage_currency)
//		#error If you don't have a name for useage_currency in a tree, you can't use any of the useage_* variables in the abilites.

/datum/bark/proc/init()
	var/count = 0
	for (var/datum/branch/B in for_tree.branches)
		branch_stats[count][0] = B
		count++
