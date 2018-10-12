/mob/living/carbon/monkey/get_unarmed_verb()
	return attack_text

/mob/living/carbon/monkey/get_unarmed_damage()
	return rand(1,3)

/mob/living/carbon/monkey/get_unarmed_hit_sound()
	return 'sound/weapons/bite.ogg'

/mob/living/carbon/monkey/knockout_chance_modifier()
	return 2

/mob/living/carbon/monkey/unarmed_attack_mob(mob/living/)
	if(istype(wear_mask, /obj/item/clothing/mask/muzzle))
		to_chat(src, "<span class='notice'>You can't do this with \the [wear_mask] on!</span>")
		return

	return ..()
