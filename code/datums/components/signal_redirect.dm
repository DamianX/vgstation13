// This should only be used by non components trying to listen to a signal
// If you use this inside a component I will replace your eyes with lemons ~ninjanomnom

/datum/component/redirect
	dupe_mode = COMPONENT_DUPE_ALLOWED

/datum/component/redirect/Initialize(var/list/signals, var/datum/callback/_callback)
	//It's not our job to verify the right signals are registered here, just do it.
	if(!length(signals) || !istype(_callback))
		warning("signals are [list2params(signals)], callback is [_callback]]")
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, signals, _callback)
