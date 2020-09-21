#define NEEDED_CHARGE_TO_RESTOCK_IMP 30

//Warden upgrade's implanter
/obj/item/implanter/cyborg
	name = "cyborg implanter"
	desc = "Can be refilled in about sixty seconds at any cyborg recharging station."
	imp_type = /obj/item/implant/loyalty
	var/charge = 0

/obj/item/implanter/cyborg/update()
	..()
	name = "[initial(name)][imp? " - [imp.name]":""]"

/obj/item/implanter/cyborg/restock()
	charge++
	if(charge >= NEEDED_CHARGE_TO_RESTOCK_IMP && !imp) //takes about 60 seconds.
		if(imp_type)
			imp = new imp_type(src)
			update()
			charge = initial(charge)

#undef NEEDED_CHARGE_TO_RESTOCK_IMP