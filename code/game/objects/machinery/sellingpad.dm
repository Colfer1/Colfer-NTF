/obj/machinery/exportpad
	name = "ASRS Bluespace Export Point"
	desc = "A bluespace telepad for sending valuble assets, such as valuble minerals and alien corpses. It needs to be wrenched down in a powered area to function."
	icon = 'icons/obj/machines/telecomms.dmi'
	icon_state = "broadcaster_off"
	density = FALSE
	anchored = FALSE
	use_power = IDLE_POWER_USE
	wrenchable = TRUE
	idle_power_usage = 50
	active_power_usage = 3000
	COOLDOWN_DECLARE(selling_cooldown)

/obj/machinery/exportpad/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(.)
		return
	var/obj/item/card/voucher/voucher = I
	if(istype(voucher))
		if(voucher.faction == faction)
			to_chat(user, span_warning("[src] buzzes: Cannot redeem voucher - can only be redeemed by other factions."))
			return
		else
			I.supply_export(faction)
			qdel(I)
			return TRUE
	if(istype(I, /obj/item/disk/intel_disk))
		I.supply_export(faction)
		qdel(I)
		return TRUE

/obj/machinery/exportpad/attack_hand(mob/living/user)
	. = ..()

	if (!anchored)
		to_chat(user, span_warning("Nothing happens. The [src] must be bolted to the ground first."))
		return

	if (!powered())
		to_chat(user, span_warning("A red light flashes on the [src]. It seems it doesn't have enough power."))
		playsound(loc,'sound/machines/buzz-two.ogg', 25, FALSE)
		return

	if(!COOLDOWN_FINISHED(src, selling_cooldown))
		to_chat(user, span_warning("The [src] is still recharging! It will be ready in [round(COOLDOWN_TIMELEFT(src, selling_cooldown) / 10)] seconds."))
		return
	var/can_sell = FALSE
	for(var/i in get_turf(src))
		var/atom/movable/onpad = i
		can_sell = FALSE
		if(isxeno(onpad))
			var/mob/living/carbon/xenomorph/sellxeno = onpad
			if(sellxeno.stat != DEAD)
				to_chat(user, span_warning("[src] buzzes: Live animals cannot be sold."))
				continue
			can_sell = TRUE
		if(ishuman(onpad))
			var/mob/living/carbon/human/sellhuman = onpad
			if(!can_sell_human_body(sellhuman, user.faction))
				to_chat(user, span_warning("[src] buzzes: High command is not interested in that bounty."))
				continue
			if(sellhuman.stat != DEAD)
				to_chat(user, span_warning("[src] buzzes: This bounty is not dead and cannot be sold."))
				continue
			can_sell = TRUE
		if(is_research_product(onpad))
			can_sell = TRUE
		if(istype(onpad, /obj/structure/closet))
			can_sell = TRUE
		if(istype(onpad, /obj/item/card/voucher))
			var/obj/item/card/voucher/voucher = onpad
			if(voucher.faction == user.faction)
				to_chat(user, span_warning("[src] buzzes: Cannot redeem voucher - can only be redeemed by other factions."))
			can_sell = TRUE
		if(istype(onpad, /obj/item/disk/intel_disk))
			can_sell = TRUE
		if(!can_sell)
			continue
		var/list/datum/export_report/export_reports = onpad.supply_export(user.faction)
		var/points = 0
		var/dropship_points = 0
		for(var/datum/export_report/export_report in export_reports)
			points += export_report.points
			dropship_points += export_report.dropship_points
			SSpoints.export_history += export_report
		visible_message(span_notice("[src] buzzes: The [onpad] has been sold for [points ? points : "no"] supply point[points == 1 ? "" : "s"][dropship_points ? " and [dropship_points] dropship point[dropship_points == 1 ? "" : "s"]" : ""]."))
		qdel(onpad)

	do_sparks(5, TRUE, src)
	playsound(loc,'sound/effects/phasein.ogg', 50, FALSE)
	COOLDOWN_START(src, selling_cooldown, 30 SECONDS)
	use_power = ACTIVE_POWER_USE//takes a lot more power while cooling down
	addtimer(VARSET_CALLBACK(src, use_power, IDLE_POWER_USE), 30 SECONDS)


/obj/machinery/exportpad/wrench_act(mob/living/user, obj/item/I)
	anchored = !anchored
	if(anchored)
		to_chat(user, "You bolt the [src] to the ground, activating it.")
		playsound(loc, 'sound/items/ratchet.ogg', 25, TRUE)
		icon_state = "broadcaster"
		var/minimapflag = GLOB.faction_to_minimap_flag[user.faction] || MINIMAP_FLAG_MARINE
		SSminimaps.add_marker(src, minimapflag, image('icons/UI_icons/map_blips.dmi', null, "asrs", MINIMAP_BLIPS_LAYER))
	else
		to_chat(user, "You unbolt the [src] from the ground, deactivating it.")
		playsound(loc, 'sound/items/ratchet.ogg', 25, TRUE)
		icon_state = "broadcaster_off"
		SSminimaps.remove_marker(src)
