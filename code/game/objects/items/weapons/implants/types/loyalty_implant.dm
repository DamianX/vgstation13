/obj/item/weapon/implant/loyalty
	name = "loyalty implant"
	desc = "Induces constant thoughts of loyalty to Nanotrasen."

/obj/item/weapon/implant/loyalty/get_data()
	return {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Nanotrasen Employee Management Implant<BR>
<b>Life:</b> Ten years.<BR>
<b>Important Notes:</b> Personnel injected with this device tend to be much more loyal to the company.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
<b>Special Features:</b> Will prevent and cure light forms of brainwashing.<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}


/obj/item/weapon/implant/loyalty/implanted(mob/implanter)
	if(malfunction == IMPLANT_MALFUNCTION_PERMANENT)
		return 0
	if(!iscarbon(M))
		return 0
	var/mob/living/carbon/H = M
	for(var/obj/item/weapon/implant/I in H)
		if(istype(I, /obj/item/weapon/implant/traitor))
			if(I.imp_in == H)
				H.visible_message("<span class='big danger'>[H] seems to resist the implant!</span>", "<span class='danger'>You feel a strange sensation in your head that quickly dissipates.</span>")
				return 0
	if(isrevhead(H))
		H.visible_message("<span class='big danger'>[H] seems to resist the implant!</span>", "<span class='danger'>You feel the corporate tendrils of Nanotrasen try to invade your mind!</span>")
		return 0
	if(iscultist(H) && veil_thickness >= CULT_ACT_I)
		to_chat(H, "<span class='danger'>You feel the corporate tendrils of Nanotrasen trying to invade your mind!</span>")
		spawn (1)//waiting for the implant to have its loc moved inside the body
			H.implant_pop()
		return 1
	if(isrevnothead(H))
		var/datum/role/R = H.mind.GetRole(REV)
		R.Drop()

	to_chat(H, "<span class = 'notice'>You feel a surge of loyalty towards Nanotrasen.</span>")
	return 1
/obj/item/weapon/implant/loyalty/handle_removal(var/mob/remover)
	makeunusable(15)
