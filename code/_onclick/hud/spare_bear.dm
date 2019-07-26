/datum/hud/proc/spare_bear_hud(var/ui_style='icons/mob/screen1_White.dmi')
	src.adding = list()
	src.other = list()
	ui_style = 'icons/mob/screen1_White.dmi'

	var/obj/abstract/screen/using

	using = getFromPool(/obj/abstract/screen)
	using.name = "drop"
	using.icon = ui_style
	using.icon_state = "act_drop"
	using.screen_loc = ui_drop_throw
	using.layer = HUD_BASE_LAYER
	src.adding += using

	init_hand_icons(ui_style)

	mymob.throw_icon = getFromPool(/obj/abstract/screen)
	mymob.throw_icon.icon = ui_style
	mymob.throw_icon.icon_state = "act_throw_off"
	mymob.throw_icon.name = "throw"
	mymob.throw_icon.screen_loc = ui_drop_throw

	mymob.healths = getFromPool(/obj/abstract/screen)
	mymob.healths.icon = ui_style
	mymob.healths.icon_state = "health0"
	mymob.healths.name = "health"
	mymob.healths.screen_loc = ui_health

	mymob.pullin = getFromPool(/obj/abstract/screen)
	mymob.pullin.icon = ui_style
	mymob.pullin.icon_state = "pull0"
	mymob.pullin.name = "pull"
	mymob.pullin.screen_loc = ui_pull_resist

	mymob.zone_sel = getFromPool(/obj/abstract/screen/zone_sel)
	mymob.zone_sel.icon = ui_style
	mymob.zone_sel.overlays.len = 0
	mymob.zone_sel.overlays += image('icons/mob/zone_sel.dmi', "[mymob.zone_sel.selecting]")

	mymob.client.reset_screen()

	mymob.client.screen += list(mymob.throw_icon, mymob.zone_sel, mymob.healths, mymob.pullin)
	mymob.client.screen += src.adding + src.other