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
	var/currency = "Units"						// What the name of the exchange currency is. For example,points.
	var/gather_rate = 1							// How much of the currency is gathered per tick.
	var/base_cost = 1							// The default cost of a level 1 ability in this tree.
	var/linear_scale							// How much the abilities of branches in this tree go up linearly by default.
	var/mult_scale = 1							// How much the abilities of branches in thie tree go up multiplicatively by default.
	var/preselect_ability = 0					// Whether abilities need to be selected in order for currency to be gathered.

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
	var/level_exclusive = 0						// Says whether a branch can only have one ability per level.

// The abilities are different things that may be unlocked. Each ability will have an associated verb that is granted to the player
// upon unlock. Abilities have a cost and a level. By default you need to unlock at least one level three ability before any level
// four abilities will become avaliable for unlock. Note that this is branch specific so unlocking an ability in another branch
// will not impact which abilities are avaliable in the current branch.
// Additionally, which abilities are unlocked is NOT stored in the abilities themselves, but instead is stored in bark.

/datum/ability
	var/datum/branch/in_branch					// The branch of the tree this ability is on.
	var/ability = null 							// Path to verb which will be given to the AI when researched.
	var/name = "Unknown Ability"				// Name of this ability.
	var/level = 1								// What level of the tree this ability is on.
	var/cost									// The cost to unlock this ability.

// Each different object with acceess to an ability tree has a bark object assosiated with them. This bark object
// tracks what the individual has unlocked and avaliable as the overarching tree is a singleton.
/datum/bark
	var/datum/tree/for_tree						// The tree this bark covers.
	var/branch_stats[][3]						// A multidimentional list that stores information about the currency invested in and the unlock level of each branch.
	var/current_currency = 0					// How much currency the object containing the bark currently has avaliable.
	var/total_currency = 0						// How much currency the object has had in total, including that which has already been spent.


/datum/tree/proc/init()

	if (!linear_scale)
		linear_scale = 1 * base_cost

	for (var/datum/branch/B in branches)
		B.init()


/datum/branch/proc/init()

	if (!base_cost)
		base_cost = in_tree.base_cost
	if (!linear_scale)
		linear_scale = in_tree.linear_scale
	if (!mult_scale)
		mult_scale = in_tree.mult_scale

	for (var/datum/ability/A in abilities)
		A.init()

/datum/ability/proc/init()

	if (!cost)
		cost = ((in_branch.base_cost + (in_branch.linear_scale * level)) * (in_branch.mult_scale ^ level))

/datum/bark/proc/init()
	var/count = 0
	for (var/datum/branch/B in for_tree.branches)
		branch_stats[count][0] = B
		count++
