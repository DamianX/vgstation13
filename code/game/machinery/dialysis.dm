/obj/machinery/dialysis
	name = "dialysis machine"
	desc = "A machine used to purge reagents from the blood. Simply connect a person to it, turn it on, and wait for the ping."
	icon = 'icons/obj/dialysis.dmi'
	icon_state = "dialysis"
	idle_power_usage = 150
	active_power_usage = 450
	anchored = TRUE
	density = TRUE
	var/list/connections = list()
	var/max_connections = 4
	var/reagent_removal_per_tick = 2
	var/toxin_healing_per_tick = 1

	machine_flags = SCREWTOGGLE | CROWDESTROY | WRENCHMOVE

/obj/machinery/dialysis/New()
	. = ..()
	component_parts = newlist(
		/obj/item/weapon/circuitboard/dialysis,
		/obj/item/weapon/stock_parts/manipulator,
		/obj/item/weapon/stock_parts/manipulator,
		/obj/item/weapon/stock_parts/micro_laser,
		/obj/item/weapon/stock_parts/micro_laser,
		/obj/item/weapon/stock_parts/console_screen
	)
	RefreshParts()

/obj/machinery/dialysis/RefreshParts()
	var/lasercount = 1
	var/manipcount = 1
	for(var/obj/item/weapon/stock_parts/part in component_parts)
		if(istype(part, /obj/item/weapon/stock_parts/micro_laser))
			lasercount += part.rating-1
		if(istype(part, /obj/item/weapon/stock_parts/manipulator))
			manipcount += part.rating-1
	reagent_removal_per_tick = initial(reagent_removal_per_tick) * manipcount
	toxin_healing_per_tick = initial(toxin_healing_per_tick) * lasercount

/obj/machinery/dialysis/Destroy()
	connections = null
	..()

/obj/machinery/dialysis/MouseDropTo(atom/over_object, mob/user)
	toggle_connection(user, over_object)

/obj/machinery/dialysis/MouseDropFrom(over_object)
	toggle_connection(usr, over_object)

/obj/machinery/dialysis/proc/toggle_connection(mob/user, mob/target)
	if(user.incapacitated() || !ishigherbeing(user) || !user.Adjacent(src))
		return

	if(connections.Remove(target))
		visible_message("<span class='notice'>[target] is detached from [src].</span>")
		return

	if(ismob(target) && Adjacent(target))
		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			if(H.species && (H.species.chem_flags & NO_INJECT))
				H.visible_message("<span class='warning'>[user] struggles to place the IV into [H] but fails.</span>")
				return

		if(connections.len >= max_connections)
			to_chat(user, "<span class='warning'>\The [src] has too many connections. Disconnect something.</span>")
			return
		visible_message("[user] attaches \the [src] to [target].")
		connections += target

/obj/machinery/dialysis/update_icon()
	overlays.len = 0
	if(panel_open)
		overlays += "dialysis_maint"
	if(!is_operational())
		return
	overlays += "dialysis_screen"

	var/index = 1
	for(var/mob/living/patient in connections)
		overlays += "dialysis_track_[index]_[patient.dialysis_status()]"
		index++

// Returns one of [25, 50, 75, 100] depending on the amount of reagents in
// the body and the amount of toxin damage.
/mob/living/proc/dialysis_status()
	var/maximumToxDmg = maxHealth * 2
	var/percentToxDmg = round(getToxLoss() / maximumToxDmg * 100)
	var/toxDmgIconState
	switch(percentToxDmg)
		if(100 to INFINITY)
			toxDmgIconState = 25
		if(50 to 75)
			toxDmgIconState = 50
		if(25 to 50)
			toxDmgIconState = 75
		if(0 to 25)
			toxDmgIconState = 100

	var/percentReagents = round(reagents.total_volume / reagents.maximum_volume * 100)
	var/reagentsIconState
	switch(percentReagents)
		if(100 to INFINITY)
			reagentsIconState = 25
		if(50 to 75)
			reagentsIconState = 50
		if(25 to 50)
			reagentsIconState = 75
		if(0 to 25)
			reagentsIconState = 100
	return "[min(toxDmgIconState, reagentsIconState)]"

/obj/machinery/dialysis/process()
	update_icon()
	if(connections.len)
		use_power = 2
	else
		use_power = 1
		return
	for(var/mob/living/M in connections)
		if(!Adjacent(M) || !isturf(M.loc))
			to_chat(M, "<span class='warning'>You disconnect from \the [src]</span>")
			connections -= M
			continue

		if(!M.reagents.remove_any(reagent_removal_per_tick) && M.getToxLoss() == 0)
			if(prob(35))
				visible_message("<span class='warning'>\The [src] beeps loudly!</span>")
				playsound(src, 'sound/machines/twobeep.ogg', 100, 1)
			continue
		M.AdjustDizzy(5 * reagent_removal_per_tick)
		M.nutrition = max(M.nutrition - 5, 0)
		M.adjustToxLoss(-toxin_healing_per_tick)
