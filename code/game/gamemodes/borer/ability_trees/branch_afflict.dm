// These are the sticks! Sticks are undesireable things the borer can do to the host to convince them to do what the borer tells them.
// This will consist of things for positive punisment and for negative reinforcement.
datum/branch/afflict
	name = BRANCH_AFFLICT

datum/ability/afflict_test
	name = "Test Afflict"
	ability = new/datum/ability/verb/afflict_test()

datum/ability/verb/afflict_test()
	world <<"Afflict Test!"