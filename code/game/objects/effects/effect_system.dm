/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/


/obj/effect/effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = 0
	flags = 0
	w_type=NOT_RECYCLABLE
	pass_flags = PASSTABLE|PASSGRILLE|PASSMACHINE

/obj/effect/acidable()
	return FALSE

/obj/effect/effect/water
	name = "water"
	icon_state = "extinguish"
	var/life = 15

/obj/effect/effect/water/spray
	name = "spray"
	icon_state = "extinguish_gray"

/obj/effect/effect/water/New()
	. = ..()

	spawn(7 SECONDS)
		qdel(src)

/obj/effect/effect/water/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	if (--life < 1)
		qdel(src)
		return 0

	. = ..()

/obj/effect/effect/water/to_bump(atom/A)
	if(reagents)
		reagents.reaction(A)
	return ..()

/datum/effect/effect/system
	var/number = 3
	var/cardinals = FALSE
	var/turf/location
	var/atom/holder
	var/setup = FALSE

/datum/effect/effect/system/proc/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc
	setup = 1

/datum/effect/effect/system/proc/attach(atom/atom)
	holder = atom

/datum/effect/effect/system/proc/start()
	return

/obj/effect/canSingulothPull(var/obj/machinery/singularity/singulo)
	return FALSE

/obj/effect/blob_act()
	return

/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
var/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread() -- creates new system
steam.set_up(5, 0, mob.loc) -- sets up variables
OPTIONAL: steam.attach(mob)
steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effect/effect/steam
	name = "steam"
	icon_state = "extinguish"
	density = 0

/datum/effect/effect/system/steam_spread

/datum/effect/effect/system/steam_spread/set_up(n = 3, c = FALSE, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc

/datum/effect/effect/system/steam_spread/start()
	for(var/i in 1 to number)
		spawn(0)
			if(holder)
				location = get_turf(holder)
			var/obj/effect/effect/steam/steam = new /obj/effect/effect/steam(location)
			var/direction
			if(cardinals)
				direction = pick(cardinal)
			else
				direction = pick(alldirs)
			for(var/j in 1 to pick(1,2,3))
				sleep(0.5 SECONDS)
				step(steam,direction)
			spawn(2 SECONDS)
				if(steam)
					qdel(steam)

/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effect/effect/sparks
	name = "sparks"
	desc = "it's a spark what do you need to know?"
	icon_state = "sparks"
	anchored = TRUE

	var/move_dir = 0
	var/energy = 0

/obj/effect/effect/sparks/New(var/travel_dir)
	..()
	var/turf/T = loc
	if(istype(T))
		T.hotspot_expose(1000, 100, surfaces = 1)

/obj/effect/effect/sparks/proc/start(var/travel_dir, var/max_energy=3)
	move_dir=travel_dir
	energy=rand(1,max_energy)
	processing_objects.Add(src)
	var/turf/T = loc
	if (istype(T, /turf))
		T.hotspot_expose(1000, 100, surfaces = 1)

/obj/effect/effect/sparks/Destroy()
	processing_objects.Remove(src)
	var/turf/T = loc

	if (istype(T, /turf))
		T.hotspot_expose(1000, 100, surfaces = 1)

	..()

/obj/effect/effect/sparks/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	..()
	var/turf/T = loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100, surfaces = 1)

/obj/effect/effect/sparks/process()
	if(energy==0)
		processing_objects.Remove(src)
		returnToPool(src)
		return
	else
		step(src,move_dir)
	energy--

/datum/effect/effect/system/spark_spread/set_up(var/n = 3, var/use_cardinals = 0, loca)
	number = min(10,n)
	cardinals = use_cardinals

	if (istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect/effect/system/spark_spread/start()
	if (holder)
		location = get_turf(holder)
	if(!location)
		return
	var/list/directions
	if (cardinals)
		directions = cardinal.Copy()
	else
		directions = alldirs.Copy()

	playsound(location, "sparks", 100, 1)
	for (var/i = 1 to number)
		var/nextdir=pick_n_take(directions)
		if(nextdir)
			var/obj/effect/effect/sparks/sparks = getFromPool(/obj/effect/effect/sparks, location)
			sparks.start(nextdir)

// This sparks.
/proc/spark(var/atom/loc, var/amount = 3, var/cardinals = TRUE)
	loc = get_turf(loc)
	var/datum/effect/effect/system/spark_spread/S = new
	S.set_up(amount, cardinals, loc)
	S.start()

/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////


/obj/effect/effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = TRUE
	anchored = FALSE
	var/amount = 6
	var/time_to_live = 100

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -WORLD_ICON_SIZE
	pixel_y = -WORLD_ICON_SIZE

/obj/effect/effect/smoke/New()
	. = ..()
	spawn(time_to_live)
		qdel(src)

/obj/effect/effect/smoke/Crossed(mob/living/carbon/M)
	..()
	if(istype(M))
		affect(M)

/obj/effect/effect/smoke/proc/affect(var/mob/living/carbon/M)
	if (istype(M))
		return 0
	if (M.internal != null && M.wear_mask && (M.wear_mask.clothing_flags & MASKINTERNALS))
		return 0
	return 1

/obj/effect/effect/smoke/Destroy()
	if(reagents)
		reagents.my_atom = null
		reagents = null
	..()

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/bad
	time_to_live = 200

/obj/effect/effect/smoke/bad/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/effect/smoke/bad/affect(var/mob/living/carbon/M)
	if (!..())
		return 0
	M.drop_item()
	M.adjustOxyLoss(1)
	if (M.coughedtime != 1)
		M.coughedtime = 1
		M.audible_cough()
		spawn(2 SECONDS)
			M.coughedtime = 0

/obj/effect/effect/smoke/bad/Cross(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	if(air_group || (height==0))
		return 1
	if(istype(mover, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = mover
		B.damage = (B.damage/2)
	return 1
/////////////////////////////////////////////
// Sleep smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/sleepy

/obj/effect/effect/smoke/sleepy/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	..()
	for(var/mob/living/carbon/M in get_turf(src))
		affect(M)

/obj/effect/effect/smoke/sleepy/affect(mob/living/carbon/M)
	if (!..())
		return 0

	M.drop_item()
	M:sleeping += 1
	if (M.coughedtime != 1)
		M.coughedtime = 1
		M.audible_cough()
		spawn(2 SECONDS)
			M.coughedtime = 0
/////////////////////////////////////////////
// Mustard Gas
/////////////////////////////////////////////


/obj/effect/effect/smoke/mustard
	name = "mustard gas"
	icon_state = "mustard"

/obj/effect/effect/smoke/mustard/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	..()
	for(var/mob/living/carbon/human/R in get_turf(src))
		affect(R)

/obj/effect/effect/smoke/mustard/affect(var/mob/living/carbon/human/R)
	if (!..())
		return 0
	if (R.wear_suit != null)
		return 0

	R.burn_skin(0.75)
	if (R.coughedtime != 1)
		R.coughedtime = 1
		R.emote("gasp")
		spawn(2 SECONDS)
			R.coughedtime = 0
	R.updatehealth()

/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////

/datum/effect/effect/system/smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/smoke_type = /obj/effect/effect/smoke

/datum/effect/effect/system/smoke_spread/set_up(n = 5, c = FALSE, loca, direct)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

/datum/effect/effect/system/smoke_spread/start()
	for(var/i in 1 to number)
		if(total_smoke > 20)
			return
		spawn(0)
			if(holder)
				location = get_turf(holder)
			var/obj/effect/effect/smoke/smoke = new smoke_type(location)
			total_smoke++
			var/direction = src.direction
			if(!direction)
				if(cardinals)
					direction = pick(cardinal)
				else
					direction = pick(alldirs)
			for(var/j in 1 to pick(0,1,1,1,2,2,2,3))
				sleep(1 SECONDS)
				step(smoke,direction)
			spawn(smoke.time_to_live*0.75+rand(10,30))
				if(smoke)
					qdel(smoke)
				total_smoke--


/datum/effect/effect/system/smoke_spread/bad
	smoke_type = /obj/effect/effect/smoke/bad

/datum/effect/effect/system/smoke_spread/sleepy
	smoke_type = /obj/effect/effect/smoke/sleepy


/datum/effect/effect/system/smoke_spread/mustard
	smoke_type = /obj/effect/effect/smoke/mustard
/////////////////////////////////////////////
// Chem smoke
/////////////////////////////////////////////
/obj/effect/effect/smoke/chem
	icon = 'icons/effects/chemsmoke.dmi'

/obj/effect/effect/smoke/Destroy()
	if(reagents)
		qdel(reagents)
		reagents = null
	..()

/obj/effect/effect/smoke/chem/New()
	. = ..()
	create_reagents(500)

/obj/effect/effect/smoke/chem/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	..()
	var/static/list/nerfed_reagents = list(RADIUM, URANIUM, CARBON, THERMITE, BLEACH)
	for(var/atom/A in view(2, src))
		if(reagents.has_any_reagents(nerfed_reagents))//Prevents unholy radium spam by reducing the number of 'greenglows' down to something reasonable -Sieve
			if(prob(5))
				reagents.reaction(A)
		else
			reagents.reaction(A)

/obj/effect/effect/smoke/chem/affect(mob/living/carbon/M)
	reagents.reaction(M)

/datum/effect/effect/system/smoke_spread/chem
	smoke_type = /obj/effect/effect/smoke/chem
	var/obj/chemholder

/datum/effect/effect/system/smoke_spread/chem/New()
	..()
	chemholder = new/obj()
	var/datum/reagents/R = new/datum/reagents(500)
	chemholder.reagents = R
	R.my_atom = chemholder

/datum/effect/effect/system/smoke_spread/chem/set_up(var/datum/reagents/carry = null, n = 5, c = 0, loca, direct)
	if(n > 20)
		n = 20
	number = n
	cardinals = c
	if(carry)
		carry.copy_to(chemholder, carry.total_volume)


	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

/datum/effect/effect/system/smoke_spread/chem/start()
	var/color = mix_color_from_reagents(chemholder.reagents.reagent_list)
	for(var/i in 1 to number)
		if(total_smoke > 20)
			return
		spawn(0)
			if(holder)
				location = get_turf(holder)
			var/obj/effect/effect/smoke/chem/smoke = new /obj/effect/effect/smoke/chem(location)
			total_smoke++
			var/direction = src.direction
			if(!direction)
				if(cardinals)
					direction = pick(cardinal)
				else
					direction = pick(alldirs)

			if(chemholder.reagents.total_volume != 1) // can't split 1 very well
				chemholder.reagents.copy_to(smoke, chemholder.reagents.total_volume / number) // copy reagents to each smoke, divide evenly

			if(color)
				smoke.icon += color // give the smoke color, if it has any to begin with
			else
				// if no color, just use the old smoke icon
				smoke.icon = 'icons/effects/96x96.dmi'
				smoke.icon_state = "smoke"

			for(var/j in pick(0,1,1,1,2,2,2,3))
				sleep(1 SECONDS)
				step(smoke, direction)
			spawn(rand(16 SECONDS, 18 SECONDS))
				if(smoke)
					qdel(smoke)
					smoke = null
				total_smoke--

// Goon compat.
/datum/effect/effect/system/smoke_spread/chem/fart

/datum/effect/effect/system/smoke_spread/chem/fart/set_up(var/mob/M, n = 5, c = FALSE, loca, direct)
	if(n > 20)
		n = 20
	number = n
	cardinals = c

	chemholder.reagents.add_reagent(SPACE_DRUGS, rand(1,10))

	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

	var/contained = "\[[chemholder.reagents.get_reagent_ids()]\]"
	var/area/A = get_area(location)

	var/where = "[A.name] | [location.x], [location.y]"
	var/whereLink=formatJumpTo(location,where)

	var/more = "(<A HREF='?_src_=holder;adminmoreinfo=\ref[M]'>?</a>)"
	message_admins("[M][more] produced a toxic fart in ([whereLink])[contained].", 0, 1)
	log_game("[M][more] produced a toxic fart in ([where])[contained].")


/////////////////////////////////////////////
//////// Attach an Ion trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////

/obj/effect/effect/trails
	name = ""
	icon_state = ""
	anchored = TRUE

	var/base_name = "ion"

/obj/effect/effect/trails/New()
	..()
	name = "[base_name] trails"
	icon_state = "[base_name]_trails"

/obj/effect/effect/trails/proc/Play()
	flick("[base_name]_fade", src)
	icon_state = "blank"
	spawn(2 SECONDS)
		if(src)
			returnToPool(src)

/obj/effect/effect/trails/ion
	base_name = "ion"

/datum/effect/effect/system/trail
	var/turf/oldposition
	var/processing = TRUE
	var/on = TRUE

	var/trail_type = /obj/effect/effect/trails/ion

/datum/effect/effect/system/trail/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect/effect/system/trail/start()
	if(!on)
		on = TRUE
		processing = TRUE
	if(processing)
		processing = FALSE
		spawn(0)
			var/turf/T = get_turf(holder)
			if(T != oldposition)
				if(istype(T, /turf/space))
					var/obj/effect/effect/trails/I = getFromPool(trail_type, oldposition)
					oldposition = T
					I.dir = holder.dir
					I.Play()
			spawn(0.2 SECONDS)
				if(on)
					processing = 1
					start()

/datum/effect/effect/system/trail/proc/stop()
	processing = FALSE
	on = FALSE

/datum/effect/effect/system/trail/space_trail
	var/turf/oldloc // secondary ion trail loc
	var/turf/currloc

/datum/effect/effect/system/trail/space_trail/start()
	if(!on)
		on = 1
		processing = 1
	if(processing)
		processing = 0
		spawn(0)
			var/turf/T = get_turf(holder)
			if(currloc != T)
				switch(holder.dir)
					if(NORTH)
						oldposition = T
						oldposition = get_step(oldposition, SOUTH)
						oldloc = get_step(oldposition,EAST)
					if(SOUTH) // More difficult, offset to the north!
						oldposition = get_step(holder,NORTH)
						oldposition = get_step(oldposition,NORTH)
						oldloc = get_step(oldposition,EAST)
					if(EAST) // Just one to the north should suffice
						oldposition = T
						oldposition = get_step(oldposition, WEST)
						oldloc = get_step(oldposition,NORTH)
					if(WEST) // One to the east and north from there
						oldposition = get_step(holder,EAST)
						oldposition = get_step(oldposition,EAST)
						oldloc = get_step(oldposition,NORTH)
				if(istype(T, /turf/space))
					var/obj/effect/effect/trails/ion/I = getFromPool(/obj/effect/effect/trails/ion, oldposition)
					var/obj/effect/effect/trails/ion/II = getFromPool(/obj/effect/effect/trails/ion, oldloc)
					I.dir = holder.dir
					II.dir = holder.dir
					flick("ion_fade", I)
					flick("ion_fade", II)
					I.icon_state = "blank"
					II.icon_state = "blank"
					spawn(2 SECONDS)
						if(I)
							returnToPool(I)
						if(II)
							returnToPool(II)

			spawn(0.2 SECONDS)
				if(on)
					processing = 1
					start()
			currloc = T


/////////////////////////////////////////////
//////// Attach a steam trail to an object (eg. a reacting beaker) that will follow it
// even if it's carried of thrown.
/////////////////////////////////////////////

/datum/effect/effect/system/steam_trail_follow
	var/turf/oldposition
	var/processing = TRUE
	var/on = TRUE

/datum/effect/effect/system/steam_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect/effect/system/steam_trail_follow/start()
	if(!on)
		on = TRUE
		processing = TRUE
	if(processing)
		processing = FALSE
		spawn(0)
			if(number < 3)
				var/obj/effect/effect/steam/I = new /obj/effect/effect/steam(oldposition)
				number++
				oldposition = get_turf(holder)
				I.dir = holder.dir
				spawn(1 SECONDS)
					if(I)
						qdel(I)
					number--
				spawn(0.2 SECONDS)
					if(on)
						processing = TRUE
						start()
			else
				spawn(0.2 SECONDS)
					if(on)
						processing = TRUE
						start()

/datum/effect/effect/system/steam_trail_follow/proc/stop()
	processing = FALSE
	on = FALSE



// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

/obj/effect/effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = FALSE
	anchored = TRUE
	density = FALSE
	layer = ABOVE_HUMAN_PLANE
	var/amount = 3
	var/expand = 1
	animate_movement = 0
	var/metal = 0
	var/lowest_temperature = 0

/obj/effect/effect/foam/fire
	name = "fire supression foam"
	icon_state = "mfoam"

/obj/effect/effect/foam/New(loc, var/ismetal = 0)
	. = ..(loc)
	icon_state = "[ismetal ? "m":""]foam"
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, 1, -3)
	spawn((metal ? 0.6 : 0.3) SECONDS)
		process()
	spawn(12 SECONDS)
		processing_objects.Remove(src)
		sleep(3 SECONDS)

		if(metal)
			var/turf/T = get_turf(src)
			if(istype(T, /turf/space))
				T.ChangeTurf(/turf/simulated/floor/foamedmetal)
			if(metal == 2)
				var/obj/structure/foamedmetal/M = new(loc)
				M.metal = metal
				M.updateicon()

		flick("[icon_state]-disolve", src)
		sleep(0.5 SECONDS)
		qdel(src)

/obj/effect/effect/foam/fire/New(loc, datum/reagents/R)
	reagents = R
	reagents.my_atom = src
	var/ccolor = mix_color_from_reagents(reagents.reagent_list)
	if(ccolor)
		icon += ccolor
	var/savedtemp
	if(reagents.has_reagent(WATER))
		var/turf/simulated/T = get_turf(src)
		var/datum/gas_mixture/old_air = T.return_air()
		savedtemp = old_air.temperature
		if(istype(T) && savedtemp > lowest_temperature)
			var/datum/gas_mixture/lowertemp = old_air.remove_volume(CELL_VOLUME)
			lowertemp.temperature = max(min(lowertemp.temperature - 500, lowertemp.temperature / 2), 0)
			lowertemp.react()
			T.assume_air(lowertemp)
	spawn(0.3 SECONDS)
		process()
	spawn(12 SECONDS)
		processing_objects.Remove(src)
		sleep(3 SECONDS)
		var/turf/simulated/T = get_turf(src)
		var/datum/gas_mixture/local_air = T.return_air()
		flick("[icon_state]-disolve", src)
		if((local_air.temperature < lowest_temperature) && (savedtemp > lowest_temperature)) //ie, we have over-chilled
			local_air.temperature = lowest_temperature
		else if((local_air.temperature < lowest_temperature) && (savedtemp < lowest_temperature) && savedtemp) //ie it chilled when it shouldn't have
			local_air.temperature = savedtemp
		sleep(0.5 SECONDS)
		qdel(src)
	AddToProfiler()

/obj/effect/effect/foam/fire/process()
	if(--amount < 0)
		return

// on delete, transfer any reagents to the floor
/obj/effect/effect/foam/Destroy()
	if(!metal && reagents && !istype(src, /obj/effect/effect/foam/fire))
		for(var/atom/A in oview(0,src))
			if(A == src)
				continue
			reagents.reaction(A, 1, 1)
	..()


/obj/effect/effect/foam/process()
	if(--amount < 0)
		return

	for(var/direction in cardinal)
		var/turf/T = get_step(src,direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if (reagents)
				for(var/datum/reagent/R in reagents.reagent_list)
					F.reagents.add_reagent(R.id,1)

// foam disolves when heated
// except metal foams
/obj/effect/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)

		spawn(0.5 SECONDS)
			qdel(src)

/obj/effect/effect/foam/Crossed(var/atom/movable/AM)
	if(metal)
		return
	if(istype(src, /obj/effect/effect/foam/fire))
		if(isliving(AM))
			var/mob/living/M = AM
			reagents.reaction(M)
		return

	if (istype(AM, /mob/living/carbon))
		var/mob/living/carbon/M = AM
		if (M.Slip(5, 2, 1))
			to_chat(M, "<span class='notice'>You slipped on the foam!</span>")


/datum/effect/effect/system/foam_spread
	var/amount = 5				// the size of the foam spread.
	var/list/carried_reagents	// the IDs of reagents present when the foam was mixed
	var/metal = 0				// 0=foam, 1=metalfoam, 2=ironfoam

/datum/effect/effect/system/foam_spread/set_up(amt=5, loca, var/datum/reagents/carry = null, var/metalfoam = 0)
	amount = round(sqrt(amt / 3), 1)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal = metalfoam

	// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed
	// with (defaults to water if none is present). Rather than actually transfer the reagents,
	// this makes a list of the reagent ids and spawns 1 unit of that reagent when the foam disolves.

	if(carry && !metal)
		for(var/datum/reagent/R in carry.reagent_list)
			carried_reagents += R.id

/datum/effect/effect/system/foam_spread/start()
	spawn(0)
		var/obj/effect/effect/foam/F = locate() in location
		if(F)
			F.amount += amount
			return

		F = new(location, metal)
		F.amount = amount

		if(!metal)			// don't carry other chemicals if a metal foam
			F.create_reagents(10)

			if(carried_reagents)
				for(var/id in carried_reagents)
					F.reagents.add_reagent(id,1)
			else
				F.reagents.add_reagent(WATER, 1)

// wall formed by metal foams
// dense and opaque, but easy to break

/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = 1
	opacity = 1 	// changed in New()
	anchored = 1
	name = "foamed metal wall"
	desc = "A lightweight foamed metal wall."
	var/metal = 1		// 1=aluminum, 2=iron

/obj/structure/foamedmetal/proc/updateicon()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"

/obj/structure/foamedmetal/ex_act(severity)
	qdel(src)

/obj/structure/foamedmetal/blob_act()
	qdel(src)

/obj/structure/foamedmetal/bullet_act()
	if(metal==1 || prob(50))
		qdel(src)

/obj/structure/foamedmetal/attack_paw(var/mob/user)
	attack_hand(user)

/obj/structure/foamedmetal/attack_hand(var/mob/living/user)
	user.delayNextAttack(1 SECONDS)
	if ((M_HULK in user.mutations) || (prob(75 - metal*25)))
		user.do_attack_animation(src, user)
		user.visible_message("<span class='warning'>[user] smashes through \the [src].</span>","<span class='notice'>You smash through \the [src].</span>")
		qdel(src)
	else
		to_chat(user, "<span class='notice'>You hit \the [src] but bounce off it.</span>")

/obj/structure/foamedmetal/kick_act()
	..()

	if(prob(75 - metal*25))
		qdel(src)

/obj/structure/foamedmetal/attackby(var/obj/item/I, var/mob/living/user)
	user.do_attack_animation(src, I)
	user.delayNextAttack(10)
	if (istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I
		G.affecting.forceMove(loc)
		visible_message("<span class='warning'>[G.assailant] smashes [G.affecting] through \the [src].</span>")
		returnToPool(I)
		qdel(src)
		return

	if(prob(I.force*20 - metal*25))
		user.visible_message("<span class='warning'>[user] smashes through \the [src].</span>","<span class='notice'>You smash through \the [src] with \the [I].</span>")
		qdel(src)
	else
		to_chat(user, "<span class='notice'>You hit \the [src] to no effect.</span>")

/obj/structure/foamedmetal/Cross(atom/movable/mover, turf/target, height=1.5, air_group = 0)
	if(air_group)
		return 0
	return !density


/obj/structure/foamedmetal/proc/update_nearby_tiles()
	if (!SS_READY(SSair))
		return 0

	var/T = loc

	if (isturf(T))
		SSair.mark_for_update(T)

	return 1

/obj/structure/foamedmetal/New()
	. = ..()
	update_nearby_tiles()

/obj/structure/foamedmetal/Destroy()
	update_nearby_tiles()
	..()

/turf/simulated/floor/foamedmetal
	name = "foamed metal floor"
	desc = "A lightweight foamed metal floor."
	icon_state = "foamedmetal"
	icon_regular_floor = "foamedmetal"
	icon_plating = "foamedmetal"
	can_exist_under_lattice = 1
	plane = PLATING_PLANE

/turf/simulated/floor/foamedmetal/attack_hand(mob/living/user)
	user.delayNextAttack(1 SECONDS)
	if ((M_HULK in user.mutations) || (prob(50)))
		user.do_attack_animation(src, user)
		user.visible_message("<span class='warning'>[user] smashes through \the [src].</span>","<span class='notice'>You smash through \the [src].</span>")
		ChangeTurf(get_base_turf(z))
	else
		to_chat(user, "<span class='notice'>You hit \the [src] but bounce off it.</span>")

/turf/simulated/floor/foamedmetal/attackby(obj/item/C, mob/living/user)
	if(!(locate(/obj/structure/lattice) in contents))
		if(istype(C, /obj/item/stack/rods))
			return
	else if(istype(C, /obj/item/stack/tile))
		return
	user.delayNextAttack(1 SECONDS)
	user.do_attack_animation(src, C)
	if (istype(C, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = C
		G.affecting.forceMove(loc)
		visible_message("<span class='warning'>[G.assailant] smashes [G.affecting] through \the [src].</span>")
		returnToPool(C)
		ChangeTurf(get_base_turf(z))
		return

	if(prob(C.force*20 - 25))
		user.visible_message("<span class='warning'>[user] smashes through \the [src].</span>","<span class='notice'>You smash through \the [src] with \the [C].</span>")
		ChangeTurf(get_base_turf(z))
	else
		to_chat(user, "<span class='notice'>You hit \the [src] to no effect.</span>")

/turf/simulated/floor/foamedmetal/canBuildCatwalk()
	if(locate(/obj/structure/catwalk) in contents)
		return BUILD_FAILURE
	return locate(/obj/structure/lattice) in contents

/turf/simulated/floor/foamedmetal/canBuildLattice(var/material)
	if(x >= (world.maxx - TRANSITIONEDGE) || x <= TRANSITIONEDGE)
		return BUILD_FAILURE
	else if (y >= (world.maxy - TRANSITIONEDGE || y <= TRANSITIONEDGE ))
		return BUILD_FAILURE
	else if(!(locate(/obj/structure/lattice) in contents) && !(istype(material,/obj/item/stack/sheet/wood)))
		return 1
	return BUILD_FAILURE

/turf/simulated/floor/foamedmetal/canBuildPlating(var/material)
	if(x >= (world.maxx - TRANSITIONEDGE) || x <= TRANSITIONEDGE)
		return BUILD_FAILURE
	else if (y >= (world.maxy - TRANSITIONEDGE || y <= TRANSITIONEDGE ))
		return BUILD_FAILURE
	else if((locate(/obj/structure/lattice) in contents) && !(istype(material,/obj/item/stack/tile/wood)))
		return 1
	return BUILD_FAILURE

/datum/effect/effect/system/reagents_explosion
	var/amount 						// TNT equivalent

/datum/effect/effect/system/reagents_explosion/set_up(amt, loc)
	amount = amt
	if(istype(loc, /turf/))
		location = loc
	else
		location = get_turf(loc)

/datum/effect/effect/system/reagents_explosion/start()
	if (amount <= 2)
		spark(location, 2)

		for(var/mob/M in viewers(5, location))
			to_chat(M, "<span class='warning'>The solution violently explodes.</span>")
		for(var/mob/M in viewers(1, location))
			if (prob (50 * amount))
				to_chat(M, "<span class='warning'>The explosion knocks you down.</span>")
				M.Knockdown(rand(1,5))
		return
	else
		var/devastation = -1
		var/heavy = -1
		var/light = -1
		var/flash = -1
		var/range = 0
		// Clamp all values to MAX_EXPLOSION_RANGE
		range = min (MAX_EXPLOSION_RANGE, light + round(amount/3))
		devastation = round(min(3, range * 0.25)) // clamps to 3 devastation for grenades
		heavy = round(min(5, range * 0.5)) // clamps to 5 heavy range for grenades
		light = min(7, range) // clamps to 7 light range for grenades
		flash = range * 1.5

		for(var/mob/M in viewers(8, location))
			to_chat(M, "<span class='warning'>The solution violently explodes.</span>")

		explosion(location, devastation, heavy, light, flash)

/datum/effect/effect/system/reagents_explosion/proc/holder_damage(var/atom/holder)
	if(holder)
		var/dmglevel = 4

		if (round(amount/8) > 0)
			dmglevel = 1
		else if (round(amount/4) > 0)
			dmglevel = 2
		else if (round(amount/2) > 0)
			dmglevel = 3

		if(dmglevel<4)
			holder.ex_act(dmglevel)
