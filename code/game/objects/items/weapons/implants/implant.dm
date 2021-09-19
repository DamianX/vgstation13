/obj/item/weapon/implant
	name = "implant"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant"
	_color = "b"
	/// The mob this has been implanted into.
	var/implanted
	var/mob/imp_in
	/// The limb of the mob this has been implanted into.
	var/datum/organ/external/part
	var/allow_reagents = FALSE
	var/malfunction = NONE


/obj/item/weapon/implant/proc/insert(mob/living/target, target_limb, mob/implanter)
	if(ishuman(target))
		var/datum/organ/external/organ = target.get_organ(target_limb)
		if(!organ || organ.gcDestroyed || !organ.is_existing())
			CRASH("Tried to implant invalid organ")
		organ.implants += src
		part = organ
	forceMove(target)
	imp_in = target
	implanted(implanter)
	return TRUE

/obj/item/weapon/implant/proc/remove(mob/user)

/obj/item/weapon/implant/proc/trigger(emote, mob/source)
	return

/obj/item/weapon/implant/proc/activate()
	return

// What does the implant do when it's removed?
/obj/item/weapon/implant/proc/handle_removal(mob/remover)
	return

// What does the implant do upon injection?
// return 0 if the implant fails (ex. Revhead and loyalty implant.)
// return 1 if the implant succeeds (ex. Nonrevhead and loyalty implant.)
/obj/item/weapon/implant/proc/implanted(mob/implanter)
	return 1

/obj/item/weapon/implant/proc/get_data()
	return "No information available"

/obj/item/weapon/implant/proc/hear(message, mob/source)
	return

/obj/item/weapon/implant/proc/islegal()
	return 0

/obj/item/weapon/implant/proc/meltdown()	//breaks it down, making implant unrecongizible
	to_chat(imp_in, "<span class='warning'>You feel something melting inside [part ? "your [part.display_name]" : "you"]!</span>")
	if (part)
		part.take_damage(burn = 15, used_weapon = "Electronics meltdown")
	else
		var/mob/living/M = imp_in
		M.apply_damage(15,BURN)
	name = "melted implant"
	desc = "Charred circuit in melted plastic case. Wonder what that used to be..."
	icon_state = "implant_melted"
	malfunction = IMPLANT_MALFUNCTION_PERMANENT

/obj/item/weapon/implant/proc/makeunusable(var/probability=50)
	if(prob(probability))
		visible_message("<span class='warning'>\The [src] fizzles and sparks!</span>")
		name = "melted " + initial(name)
		desc = "Charred circuit in melted plastic case."
		icon_state = "implant_melted"
		malfunction = IMPLANT_MALFUNCTION_PERMANENT

/obj/item/weapon/implant/Destroy()
	if(part)
		part.implants -= src
	imp_in = null
	if(reagents)
		qdel(reagents)
		reagents = null
	..()
