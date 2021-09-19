/obj/item/weapon/implant
	name = "implant"
	icon = 'icons/obj/device.dmi'
	icon_state = "implant"
	var/implanted = null
	var/mob/imp_in = null
	var/datum/organ/external/part = null
	_color = "b"
	var/allow_reagents = 0
	var/malfunction = 0

/obj/item/weapon/implant/proc/trigger(emote, mob/source)
	return

/obj/item/weapon/implant/proc/activate()
	return

// What does the implant do when it's removed?
/obj/item/weapon/implant/proc/handle_removal(var/mob/remover)
	return

// What does the implant do upon injection?
// return 0 if the implant fails (ex. Revhead and loyalty implant.)
// return 1 if the implant succeeds (ex. Nonrevhead and loyalty implant.)
/obj/item/weapon/implant/proc/implanted(var/mob/source)
	return 1

/obj/item/weapon/implant/proc/get_data()
	return "No information available"

/obj/item/weapon/implant/proc/hear(message, source as mob)
	return

/obj/item/weapon/implant/proc/islegal()
	return 0

/obj/item/weapon/implant/proc/meltdown()	//breaks it down, making implant unrecongizible
	to_chat(imp_in, "<span class = 'warning'>You feel something melting inside [part ? "your [part.display_name]" : "you"]!</span>")
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
		part.implants.Remove(src)
	imp_in = null
	if(reagents)
		qdel(reagents)
	..()
