
//Not to be confused with /obj/item/weapon/reagent_containers/food/drinks/bottle

/obj/item/weapon/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bottle"
	item_state = "atoxinbottle"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5,10,15,25,30)
	flags = FPRINT  | OPENCONTAINER
	volume = 30
	starting_materials = list(MAT_GLASS = 1000)
	w_type = RECYK_GLASS
	melt_temperature = MELTPOINT_GLASS
	origin_tech = Tc_MATERIALS + "=1"

/obj/item/weapon/reagent_containers/glass/bottle/New(loc,altvol=30)
	volume = altvol
	..(loc)

//JUST
/obj/item/weapon/reagent_containers/glass/bottle/mop_act(obj/item/weapon/mop/M, mob/user)
	if(..())
		if(src.reagents.total_volume >= 1)
			if(M.reagents.total_volume >= 1)
				to_chat(user, "<span class='notice'>You dip \the [M]'s tip into \the [src] but don't soak anything up.</span>")
				return 1
			else
				src.reagents.trans_to(M, 1)
				to_chat(user, "<span class='notice'>You barely manage to wet [M]</span>")
				playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		else
			to_chat(user, "<span class='notice'>Nothing left to wet [M] with!</span>")
		return 1

/*
 * Hard to have colored bottles work with dynamic reagent filling
/obj/item/weapon/reagent_containers/glass/bottle/New()
	..()
	if(!icon_state)
		icon_state = "bottle[rand(1,20)]"
*/

/obj/item/weapon/reagent_containers/glass/bottle/on_reagent_change()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/pickup(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/dropped(mob/user)
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/attack_hand()
	..()
	update_icon()

/obj/item/weapon/reagent_containers/glass/bottle/update_icon()
	overlays.len = 0

	if(reagents.total_volume)
		var/image/filling = image('icons/obj/reagentfillings.dmi', src, "[icon_state]5")

		var/percent = round((reagents.total_volume / volume) * 100)
		switch(percent) //Percentages are pretty fucked so here comes the decimal rollercoaster with halfway rounding
			if(0 to 24)
				filling.icon_state = "[icon_state]5"
			if(25 to 41)
				filling.icon_state = "[icon_state]10"
			if(42 to 58)
				filling.icon_state = "[icon_state]15"
			if(59 to 74)
				filling.icon_state = "[icon_state]20"
			if(75 to 91)
				filling.icon_state = "[icon_state]25"
			if(92 to INFINITY)
				filling.icon_state = "[icon_state]30"

		filling.icon += mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		overlays += filling

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/weapon/reagent_containers/glass/bottle/unrecyclable
	starting_materials = null

/obj/item/weapon/reagent_containers/glass/bottle/inaprovaline
	name = "inaprovaline bottle"
	desc = "A small bottle. Contains inaprovaline - used to stabilize patients."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle16"

	New()
		..()
		reagents.add_reagent(INAPROVALINE, 30)

/obj/item/weapon/reagent_containers/glass/bottle/toxin
	name = "toxin bottle"
	desc = "A small bottle of toxins. Do not drink, it is poisonous."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle12"

	New()
		..()
		reagents.add_reagent(TOXIN, 30)

/obj/item/weapon/reagent_containers/glass/bottle/charcoal
	name = "activated charcoal bottle"
	desc = "A small bottle of activated charcoal. Used for treatment of overdoses."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle-charcoal"

	New()
		..()
		reagents.add_reagent("charcoal", 30)

/obj/item/weapon/reagent_containers/glass/bottle/cyanide
	name = "cyanide bottle"
	desc = "A small bottle of cyanide. Bitter almonds?"
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle12"

	New()
		..()
		reagents.add_reagent(CYANIDE, 30)

/obj/item/weapon/reagent_containers/glass/bottle/stoxin
	name = "sleep-toxin bottle"
	desc = "A small bottle of sleep toxins. Just the fumes make you sleepy."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent(STOXIN, 30)

/obj/item/weapon/reagent_containers/glass/bottle/chloralhydrate
	name = "Chloral Hydrate Bottle"
	desc = "A small bottle of Chloral Hydrate. Mickey's Favorite!"
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent(CHLORALHYDRATE, 15)		//Intentionally low since it is so strong. Still enough to knock someone out.

/obj/item/weapon/reagent_containers/glass/bottle/antitoxin
	name = "anti-toxin bottle"
	desc = "A small bottle of Anti-toxins. Counters poisons, and repairs damage, a wonder drug."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle17"

	New()
		..()
		reagents.add_reagent(ANTI_TOXIN, 30)

/obj/item/weapon/reagent_containers/glass/bottle/mutagen
	name = "unstable mutagen bottle"
	desc = "A small bottle of unstable mutagen. Randomly changes the DNA structure of whoever comes in contact."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent(MUTAGEN, 30)

/obj/item/weapon/reagent_containers/glass/bottle/ammonia
	name = "ammonia bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle20"

	New()
		..()
		reagents.add_reagent(AMMONIA, 30)

/obj/item/weapon/reagent_containers/glass/bottle/diethylamine
	name = "diethylamine bottle"
	desc = "A small bottle."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle17"

	New()
		..()
		reagents.add_reagent(DIETHYLAMINE, 30)

/obj/item/weapon/reagent_containers/glass/bottle/pacid
	name = "Polytrinic Acid Bottle"
	desc = "A small bottle. Contains a small amount of Polytrinic Acid"
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle17"
	New()
		..()
		reagents.add_reagent(PACID, 30)

/obj/item/weapon/reagent_containers/glass/bottle/adminordrazine
	name = "Adminordrazine Bottle"
	desc = "A small bottle. Contains the liquid essence of the gods."
	icon = 'icons/obj/drinks.dmi'
	//icon_state = "holyflask"
	New()
		..()
		reagents.add_reagent(ADMINORDRAZINE, 30)

/obj/item/weapon/reagent_containers/glass/bottle/capsaicin
	name = "Capsaicin Bottle"
	desc = "A small bottle. Contains hot sauce."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle3"
	New()
		..()
		reagents.add_reagent(CAPSAICIN, 30)

/obj/item/weapon/reagent_containers/glass/bottle/frostoil
	name = "Frost Oil Bottle"
	desc = "A small bottle. Contains cold sauce."
	icon = 'icons/obj/chemical.dmi'
	//icon_state = "bottle17"
	New()
		..()
		reagents.add_reagent(FROSTOIL, 30)

/obj/item/weapon/reagent_containers/glass/bottle/antisocial
	//No special name or description

	New()
		..()
		reagents.add_reagent(BICARODYNE, 30)

/obj/item/weapon/reagent_containers/glass/bottle/hypozine


/obj/item/weapon/reagent_containers/glass/bottle/hypozine/New()
	..()
	reagents.add_reagent(HYPOZINE, 30)

/obj/item/weapon/reagent_containers/glass/bottle/sacid
	name = "Sulphuric Acid Bottle"
	desc = "A small bottle. Contains a small amount of Sulphuric Acid."
	icon = 'icons/obj/chemical.dmi'
	New()
		..()
		reagents.add_reagent(SACID, 30)

/obj/item/weapon/reagent_containers/glass/bottle/rezadone
	name = "Rezadone Bottle"
	desc = "A small bottle. Contains a small amount of Rezadone."
	icon = 'icons/obj/chemical.dmi'

/obj/item/weapon/reagent_containers/glass/bottle/rezadone/New()
	..()
	reagents.add_reagent(REZADONE, 30)

/obj/item/weapon/reagent_containers/glass/bottle/alkysine
	name = "Alkysine Bottle"
	desc = "A small bottle. Contains a small amount of Alkysine."
	icon = 'icons/obj/chemical.dmi'

/obj/item/weapon/reagent_containers/glass/bottle/alkysine/New()
	..()
	reagents.add_reagent(ALKYSINE, 30)

/obj/item/weapon/reagent_containers/glass/bottle/alkysinesmall
	name = "Alkysine Bottle"
	desc = "A small bottle. Contains a small amount of Alkysine."
	icon = 'icons/obj/chemical.dmi'

/obj/item/weapon/reagent_containers/glass/bottle/alkysinesmall/New()
	..()
	reagents.add_reagent(ALKYSINE, 10)

/obj/item/weapon/reagent_containers/glass/bottle/peridaxon
	name = "Peridaxon Bottle"
	desc = "A small bottle. Contains peridaxon. Medicate cautiously."
	icon = 'icons/obj/chemical.dmi'

/obj/item/weapon/reagent_containers/glass/bottle/peridaxon/New()
	..()
	reagents.add_reagent(PERIDAXON, 30)

/obj/item/weapon/reagent_containers/glass/bottle/nanobotssmall
	name = "Nanobots Bottle"
	desc = "A small bottle. You hear beeps and boops."
	icon = 'icons/obj/chemical.dmi'

/obj/item/weapon/reagent_containers/glass/bottle/nanobotssmall/New()
	..()
	reagents.add_reagent(NANOBOTS, 10)

/obj/item/weapon/reagent_containers/glass/bottle/bleach
	name = "Bleach Bottle"
	desc = "A bottle of BLAM! Ultraclean brand bleach. Has many warning labels."
	icon = 'icons/obj/chemical.dmi'
	icon_state = "bleachbottle"
	starting_materials = list(MAT_PLASTIC = 1000)
	w_type = RECYK_MISC
	melt_temperature = MELTPOINT_PLASTIC

/obj/item/weapon/reagent_containers/glass/bottle/bleach/update_icon()
	overlays.len = 0

	if(!is_open_container())
		var/image/lid = image(icon, src, "lid_[initial(icon_state)]")
		overlays += lid

/obj/item/weapon/reagent_containers/glass/bottle/bleach/New()
	..()
	reagents.add_reagent(BLEACH, 15)
