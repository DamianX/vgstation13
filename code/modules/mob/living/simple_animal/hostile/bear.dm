//Space bears!
/mob/living/simple_animal/hostile/bear
	name = "space bear"
	desc = "RawrRawr!!"
	icon_state = "bear"
	icon_living = "bear"
	icon_dead = "bear_dead"
	icon_gib = "bear_gib"
	speak = list("RAWR!","Rawr!","GRR!","Growl!")
	speak_emote = list("growls", "roars")
	emote_hear = list("rawrs","grumbles","grawls")
	emote_see = list("stares ferociously", "stomps")
	var/default_icon_space = "bear"
	var/default_icon_floor = "bearfloor"
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/bearmeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"
	stop_automated_movement_when_pulled = 0
	maxHealth = 60
	health = 60
	attacktext = "mauls"
	melee_damage_lower = 20
	melee_damage_upper = 30
	size = SIZE_BIG
	speak_override = TRUE

	//Space bears aren't affected by atmos.
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	var/stance_step = 0

	faction = "russian"

//SPACE BEARS! SQUEEEEEEEE~     OW! FUCK! IT BIT MY HAND OFF!!
/mob/living/simple_animal/hostile/bear/Hudson
	name = "Hudson"
	desc = ""
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "hits"

/mob/living/simple_animal/hostile/bear/panda
	name = "space panda"
	desc = "Endangered even in space. A lack of bamboo has driven them somewhat mad."
	icon_state = "panda"
	icon_living = "panda"
	icon_dead = "panda_dead"
	default_icon_floor = "panda"
	default_icon_space = "panda"
	maxHealth = 50
	health = 50
	melee_damage_lower=10
	melee_damage_upper=35

/mob/living/simple_animal/hostile/bear/polarbear
	name = "space polar bear"
	desc = "You would think that space would be considered cold enough for regular space bears, well these are adapted for colder climates"
	icon_state = "polarbear"
	icon_living = "polarbear"
	icon_dead = "polarbear_dead"
	default_icon_floor = "polarbear"
	default_icon_space = "polarbear"
	maxHealth = 75
	health = 75
	melee_damage_lower=10
	melee_damage_upper=40

/mob/living/simple_animal/hostile/bear/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, glide_size_override = 0)
	..()
	if(stat != DEAD)
		if(loc && istype(loc,/turf/space))
			icon_state = default_icon_space
		else
			icon_state = default_icon_floor


/mob/living/simple_animal/hostile/bear/Life()
	if(timestopped)
		return 0 //under effects of time magick
	. =..()
	if(!.)
		return

	switch(stance)

		if(HOSTILE_STANCE_TIRED)
			stop_automated_movement = 1
			stance_step++
			if(stance_step >= 10) //rests for 10 ticks
				if(target && target in ListTargets())
					stance = HOSTILE_STANCE_ATTACK //If the mob he was chasing is still nearby, resume the attack, otherwise go idle.
				else
					stance = HOSTILE_STANCE_IDLE

		if(HOSTILE_STANCE_ALERT)
			stop_automated_movement = 1
			var/found_mob = 0
			if(target && target in ListTargets())
				if(CanAttack(target))
					stance_step = max(0, stance_step) //If we have not seen a mob in a while, the stance_step will be negative, we need to reset it to 0 as soon as we see a mob again.
					stance_step++
					found_mob = 1
					src.dir = get_dir(src,target)	//Keep staring at the mob

					if(stance_step in list(1,4,7)) //every 3 ticks
						var/action = pick( list( "growls at [target]", "stares angrily at [target]", "prepares to attack [target]", "closely watches [target]" ) )
						if(action)
							emote("me",, action)
			if(!found_mob)
				stance_step--

			if(stance_step <= -20) //If we have not found a mob for 20-ish ticks, revert to idle mode
				stance = HOSTILE_STANCE_IDLE
			if(stance_step >= 7)   //If we have been staring at a mob for 7 ticks,
				stance = HOSTILE_STANCE_ATTACK

		if(HOSTILE_STANCE_ATTACKING)
			if(stance_step >= 20)	//attacks for 20 ticks, then it gets tired and needs to rest
				emote("me",,"is worn out and needs to rest" )
				stance = HOSTILE_STANCE_TIRED
				stance_step = 0
				walk(src, 0) //This stops the bear's walking
				return



/mob/living/simple_animal/hostile/bear/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target = user
	..()

/mob/living/simple_animal/hostile/bear/attack_hand(mob/living/carbon/human/M as mob)
	if(stance != HOSTILE_STANCE_ATTACK && stance != HOSTILE_STANCE_ATTACKING)
		stance = HOSTILE_STANCE_ALERT
		stance_step = 6
		target = M
	..()

/mob/living/simple_animal/hostile/bear/Process_Spacemove(var/check_drift = 0)
	return 1	//No drifting in space for space bears!

/mob/living/simple_animal/hostile/bear/proc/crayon_check(var/atom/the_target)
	for(var/obj/effect/decal/cleanable/crayon/C in get_turf(the_target))
		if(!C.on_wall && C.name == "o") //drawing a circle around yourself is the only way to ward off space bears!
			return TRUE
	return FALSE

/mob/living/simple_animal/hostile/bear/CanAttack(var/atom/the_target)
	. = ..()
	if(crayon_check(the_target))
		return FALSE

/mob/living/simple_animal/hostile/bear/FindTarget()
	. = ..()
	if(.)
		emote("me",,"stares alertly at [.].")
		stance = HOSTILE_STANCE_ALERT

/mob/living/simple_animal/hostile/bear/LoseTarget()
	..(5)

/mob/living/simple_animal/hostile/bear/attack_icon()
	return image(icon = 'icons/mob/attackanims.dmi', icon_state = "bear")


/mob/living/simple_animal/hostile/bear/spare
	name = "spare bear"
	desc = "A trained space bear wearing a command hat and a golden collar."
	icon_state = "sparebear"
	default_icon_space = "sparebear"
	default_icon_floor = "sparebear"
	icon_dead = "sparebear_dead"
	health = 120
	maxHealth = 120
	search_objects = 1
	wanted_objects = list(
		/obj/item/weapon/card/id/captains_spare,
	)
	held_items = list(null, null)
	var/datum/fuzzy_ruling/head_of_staff_filter/mob_rule_path = /datum/fuzzy_ruling/head_of_staff_filter/mind
	var/list/obj/abstract/Overlays/obj_overlays[TOTAL_LAYERS]

/mob/living/simple_animal/hostile/bear/spare/id
	mob_rule_path = /datum/fuzzy_ruling/head_of_staff_filter/id

/mob/living/simple_animal/hostile/bear/spare/Destroy()
	drop_hands(force_drop = TRUE)
	..()

/mob/living/simple_animal/hostile/bear/spare/death(var/gibbed = FALSE)
	drop_hands(force_drop = TRUE)
	..()

/mob/living/simple_animal/hostile/bear/spare/update_inv_hand(index, var/update_icons = 1)
	if(!obj_overlays)
		return
	var/obj/abstract/Overlays/hand_layer/O = obj_overlays["[HAND_LAYER]-[index]"]
	if(!O)
		O = getFromPool(/obj/abstract/Overlays/hand_layer)
		obj_overlays["[HAND_LAYER]-[index]"] = O
	else
		overlays.Remove(O)
		O.overlays.len = 0
	var/obj/item/I = get_held_item_by_index(index)
	if(I && I.is_visible())
		var/t_state = I.item_state
		var/t_inhand_state = I.inhand_states[get_direction_by_index(index)]
		var/icon/check_dimensions = new(t_inhand_state)
		if(!t_state)
			t_state = I.icon_state
		O.name = "[index]"
		O.icon = t_inhand_state
		O.icon_state = t_state
		O.color = I.color
		O.pixel_x = (-1*(check_dimensions.Width() - WORLD_ICON_SIZE)/2)
		#define MAGICAL_BEAR_HAND_Y_OFFSET 5
		O.pixel_y = (-1*(check_dimensions.Height() - WORLD_ICON_SIZE)/2)+MAGICAL_BEAR_HAND_Y_OFFSET
		#undef MAGICAL_BEAR_HAND_Y_OFFSET
		O.layer = O.layer
		if(I.dynamic_overlay && I.dynamic_overlay["[HAND_LAYER]-[index]"])
			var/image/dyn_overlay = I.dynamic_overlay["[HAND_LAYER]-[index]"]
			O.overlays.Add(dyn_overlay)
		I.screen_loc = get_held_item_ui_location(index)
		overlays.Add(O)
	if(update_icons)
		update_icons()

/mob/living/simple_animal/hostile/bear/spare/UnarmedAttack(var/atom/A)
	if(istype(A, /obj/item/weapon/card/id/captains_spare))
		A.attack_hand(src)
		return
	return ..()

/mob/living/simple_animal/hostile/bear/spare/proc/is_allowed(atom/thing)
	if(istype(thing, /obj/item/weapon/card/id/captains_spare))
		return FALSE
	var/datum/fuzzy_ruling/head_of_staff_filter/mob_filter = locate() in target_rules
	return !mob_filter.evaluate(thing)

/mob/living/simple_animal/hostile/bear/spare/crayon_check(var/atom/the_target)
	return FALSE

/datum/fuzzy_ruling/head_of_staff_filter
	var/list/allowed_ranks = list(
		"Captain",
		"Head of Personnel",
		"Head of Security",
		"Chief Engineer",
		"Research Director",
		"Chief Medical Officer",
	)

/datum/fuzzy_ruling/head_of_staff_filter/evaluate(var/datum/D)
	CRASH("not implemented")

/datum/fuzzy_ruling/head_of_staff_filter/id/evaluate(var/datum/D)
	var/mob/living/carbon/human/dude = D
	if(!ishuman(dude))
		return ismob(dude)
	var/obj/item/weapon/card/id/passport = dude.get_item_by_slot(slot_wear_id)
	if(isnull(passport))
		return 1
	if(!istype(passport)) // It's a PDA or wallet
		passport = passport.GetID()
	if(!istype(passport))
		return 1
	if(!(passport.rank in allowed_ranks))
		return 1
	return 0

/datum/fuzzy_ruling/head_of_staff_filter/mind/evaluate(var/datum/D)
	var/mob/living/carbon/human/dude = D
	if(!ishuman(dude))
		return ismob(dude)
	var/datum/mind/dude_mind = dude.mind
	if(!istype(dude_mind))
		return 1
	if(!(dude_mind.assigned_role in allowed_ranks))
		return 1
	return 0

// Prioritize the spare ID, never attack heads of staff based on their ID or mind
/mob/living/simple_animal/hostile/bear/spare/initialize_rules()
	target_rules.Add(new mob_rule_path)
	target_rules.Add(new /datum/fuzzy_ruling/is_obj{weighting = 0.5})
	var/datum/fuzzy_ruling/distance/D = new /datum/fuzzy_ruling/distance
	D.set_source(src)
	target_rules.Add(D)

/mob/living/simple_animal/hostile/bear/spare/CanAttack(atom/new_target)
	if(is_allowed(new_target))
		return FALSE
	return ..()

/mob/living/simple_animal/hostile/bear/spare/AttackingTarget()
	. = ..()
	var/obj/item/weapon/card/id/captains_spare/spare_id = target
	if(!istype(spare_id))
		return
	if(!find_empty_hand_index())
		return
	emote("me",,"grasps \the [spare_id]!")
	spare_id.attack_hand(src)

/mob/living/simple_animal/hostile/bear/spare/attack_hand(mob/living/carbon/human/M)
	var/obj/item/weapon/card/id/captains_spare/held_spare_id = get_held_item_by_index(1)
	if(!held_spare_id)
		return ..()
	if(M.a_intent != I_HELP || !is_allowed(M))
		return ..()
	drop_item(held_spare_id, force_drop = TRUE)
	M.put_in_hands(held_spare_id)
	emote("me",,"hands \the [held_spare_id] to [M].")

/mob/living/simple_animal/hostile/bear/spare/attackby(obj/item/O, mob/user)
	var/obj/item/weapon/card/id/captains_spare/spare_id = O
	if(!istype(spare_id))
		return ..()
	if(!user.drop_item(spare_id))
		to_chat(user, "<span class='warning'>You can't let go of \the [spare_id]!</span>")
		return
	put_in_hands(spare_id)
	user.emote("me",,"hands \the [spare_id] to \the [src].")