/mob/living/simple_animal/hostile/warriorbug
	name = "warrior bug"
	desc = "A plague from the Klendathu system. They seem bent on galactic expansion."
	icon = 'icons/mob/arachnid.dmi'
	icon_state = "arachnid"
	icon_living = "arachnid"
	icon_dead = "arachnid_dead"
	speak_emote = list("roars")
	emote_hear = list("hisses")
	speak_chance = 5
	turns_per_move = 5
	see_in_dark = 10
	meat_type = /obj/item/reagent_containers/food/snacks/meat/spidermeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "punches"
	stop_automated_movement_when_pulled = 0
	maxHealth = 175
	health = 175
	melee_damage_lower = 15
	melee_damage_upper = 20
	heat_damage_per_tick = 20
	cold_damage_per_tick = 20
	faction = "klendathu"
	move_to_delay = 6
	speed = 4
	attack_sound = 'sound/weapons/bladeslice.ogg'
	size = SIZE_BIG
	pixel_x = -16 * PIXEL_MULTIPLIER
	pixel_y = -12 * PIXEL_MULTIPLIER

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
