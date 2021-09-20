/obj/item/weapon/implant/traitor
	name = "greytide implant"
	desc = "Greytide station wide."
	icon_state = "implant_evil"

/obj/item/weapon/implant/traitor/get_data()
	return {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Greytide Mind-Slave Implant<BR>
<b>Life:</b> ??? <BR>
<b>Important Notes:</b> Any humanoid injected with this implant will become loyal to the injector and the greytide, unless of course the host is already loyal to someone else.<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a small pod of nanobots that manipulate the host's mental functions.<BR>
<b>Special Features:</b> Glory to the Greytide!<BR>
<b>Integrity:</b> Implant will last so long as the nanobots are inside the bloodstream."}

/obj/item/weapon/implant/traitor/insert(mob/living/target, target_limb, mob/implanter)
	if(!iscarbon(target))
		to_chat(implanter, "<span class='danger'>The implant doesn't seem to be compatible with [target]!</span>")
		return FALSE
	if(!target.mind)
		to_chat(implanter, "<span class='danger'>[target] lacks a mind to affect!</span>")
		return FALSE
	return ..()

/obj/item/weapon/implant/traitor/implanted(mob/implanter)
	var/mob/living/carbon/H = M
	if(M == user)
		to_chat(user, "<span class='notice'>You feel quite stupid for doing that.</span>")
		if(isliving(user))
			user:brainloss += 10
		return
	for(var/obj/item/weapon/implant/I in H)
		if(istype(I, /obj/item/weapon/implant/traitor) || istype(I, /obj/item/weapon/implant/loyalty))
			if(I.imp_in == H)
				H.visible_message("<span class='big danger'>[H] seems to resist the implant!</span>", "<span class='danger'>You feel a strange sensation in your head that quickly dissipates.</span>")
				return 0
	if(istraitor(H))
		H.visible_message("<span class='big danger'>[H] seems to resist the implant!</span>", "<span class='danger'>You feel a familiar sensation in your head that quickly dissipates.</span>")
		return 0
	to_chat(H, "<span class = 'notice'>You feel a surge of loyalty towards [user.name].</span>")

	var/datum/faction/F = find_active_faction_by_typeandmember(/datum/faction/syndicate/greytide, null, user.mind)
	if(!F)
		F = ticker.mode.CreateFaction(/datum/faction/syndicate/greytide, 0, 1)
		F.HandleNewMind(user.mind)

	var/success = F.HandleRecruitedMind(H.mind)
	if(!success)
		visible_message("<span class = 'warning'>The head of \the [H] begins to glow a deep red. It is going to explode!</span>")
		spawn(3 SECONDS)
			var/datum/organ/external/head/head_organ = H.get_organ(LIMB_HEAD)
			head_organ.explode()
		return 0
	to_chat(H, "<B><span class = 'big warning'>You've been shown the Greytide by [user.name]!</B> You now must lay down your life to protect them and assist in their goals at any cost.</span>")
	F.forgeObjectives()
	update_faction_icons()
	log_admin("[ckey(user.key)] has mind-slaved [ckey(H.key)].")
	return 1

/obj/item/weapon/implant/traitor/handle_removal(var/mob/remover)
	if (!imp_in.mind)
		return
	var/datum/role/R = imp_in.mind.GetRole(IMPLANTSLAVE)
	if (!R)
		return
	log_admin("[key_name(remover)] has removed a greytide implant from [key_name(imp_in)].")
	R.Drop(FALSE)

	makeunusable(90)
