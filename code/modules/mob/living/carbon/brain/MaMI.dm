/obj/item/organ/internal/brain/mami
	name = "\improper Machine-Man Interface"
	desc = "A complex socket-system of electrodes and neurons intended to give silicon-based minds control of organic tissue."
	origin_tech = Tc_BIOTECH + "=4;" + Tc_PROGRAMMING + "=4"
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "mami_empty"
	robotic = TRUE
	var/obj/item/device/mmi/posibrain/posibrain = null

/obj/item/organ/internal/brain/mami/attackby(obj/item/O, mob/user)
	if(istype(O,/obj/item/device/mmi/posibrain) && !brainmob)
		if(!user.drop_item(O, src))
			to_chat(user, "<span class='warning'>You can't let go of \the [src]!</span>")
			return
		var/obj/item/device/mmi/posibrain/brain_obj = O
		if(!brain_obj.brainmob || !brain_obj.brainmob.mind || !brain_obj.brainmob.ckey)
			to_chat(user, "<span class='warning'>You aren't sure where this brain came from, but you're pretty sure it's a useless brain.</span>")
			return

		posibrain = brain_obj

		src.visible_message("<span class='notice'>[user] sticks \a [O] into \the [src].</span>")

		brainmob = posibrain.brainmob
		brainmob.forceMove(src)
		brainmob.container = src

		to_chat(src.brainmob, "<b><font color='red' size=3>Recall your positronic directives!</font></b>")
		to_chat(src.brainmob, "<b>You are \a [posibrain], brought into existence on [station_name()].</b>")
		to_chat(src.brainmob, "<b>As a synthetic intelligence, you answer to all crewmembers, as well as the AI.</b>")
		to_chat(src.brainmob, "<b>Remember, the purpose of your existence is to serve the crew and the station. Above all else, do no harm.</b>")

		name = "Machine-Man Interface: [brainmob.real_name]"
		icon_state = "mami_full"
		return 1
	return ..()

/obj/item/organ/internal/brain/mami/attack_self(mob/user)
	if(brainmob && !posibrain)
		posibrain = new(src)
		posibrain.icon_state = "posibrain-occupied"
		brainmob.stat = CONSCIOUS
	if(posibrain)
		to_chat(user, "You upend \the [src], dropping its contents onto the floor.")
		posibrain.forceMove(user.loc)
		posibrain.brainmob = brainmob
		brainmob.container = posibrain
		brainmob.forceMove(posibrain)

		icon_state = "mami_empty"
		name = initial(name)

		posibrain = null
		brainmob = null
		return 1
	return ..()
