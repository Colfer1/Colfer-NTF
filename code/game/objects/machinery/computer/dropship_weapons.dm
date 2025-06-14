
/obj/machinery/computer/dropship_weapons
	name = "abstract dropship weapons controls"
	desc = "A computer to manage equipments and weapons installed on the dropship."
	density = TRUE
	icon_state = "dropship_console_right"
	screen_overlay = "dropship_console_right_emissive"
	circuit = null
	opacity = FALSE
	resistance_flags = RESIST_ALL
	interaction_flags = INTERACT_MACHINE_TGUI
	var/shuttle_tag  // Used to know which shuttle we're linked to.
	var/obj/structure/dropship_equipment/selected_equipment //the currently selected equipment installed on the shuttle this console controls.
	var/list/shuttle_equipments = list() //list of the equipments on the shuttle this console controls

/obj/machinery/computer/dropship_weapons/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)

	if(!ui)
		ui = new(user, src, "CAS", name)
		ui.open()

/obj/machinery/computer/dropship_weapons/ui_data(mob/user)
	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_tag)
	if(!shuttle)
		WARNING("[src] could not find shuttle [shuttle_tag] from SSshuttle")
		return

	. = list()
	.["equipment_data"] = list()
	for(var/obj/effect/overlay/temp/laser_target/laser_target in GLOB.active_laser_targets)
		if(user.faction != laser_target.faction) //we dont see others lasers
			continue
		var/area/laser_area = get_area(laser_target)
		.["targets_data"] += list(list("target_name" = "[laser_target.name] ([laser_area.name])", "target_tag" = laser_target.target_id))
	shuttle_equipments = shuttle.equipments
	var/equipment_index = 0
	while(equipment_index < length(shuttle.equipments))
		equipment_index++
		var/obj/structure/dropship_equipment/equipment = shuttle.equipments[equipment_index]
		if(istype(equipment))
			.["equipment_data"] += list(list("id" = equipment_index, "name" = sanitize(copytext(equipment.name, 1, MAX_MESSAGE_LEN)), "eqp_tag" = equipment_index, "is_interactable" = (equipment.dropship_equipment_flags & IS_INTERACTABLE)))


	.["selected_eqp_name"] = ""
	.["selected_eqp_ammo_name"] = ""
	.["selected_eqp_ammo_amt"] = 0
	.["selected_eqp_max_ammo_amt"] = 0
	.["display_used_weapon"] = 0
	if(selected_equipment)
		.["selected_eqp_name"] = sanitize(copytext(selected_equipment.name,1,MAX_MESSAGE_LEN))
		.["selected_eqp"] = .["selected_eqp_name"]
		if(selected_equipment.ammo_equipped)
			.["selected_eqp_ammo_name"] = sanitize(copytext(selected_equipment.ammo_equipped.name,1,MAX_MESSAGE_LEN))
			.["selected_eqp_ammo_amt"] = selected_equipment.ammo_equipped.ammo_count
			.["selected_eqp_max_ammo_amt"] = selected_equipment.ammo_equipped.max_ammo_count
		.["display_used_weapon"] = selected_equipment.screen_mode

	.["shuttle_mode"] = shuttle.mode == SHUTTLE_CALL

/obj/machinery/computer/dropship_weapons/ui_act(action, list/params)
	. = ..()
	if(.)
		return

	var/obj/docking_port/mobile/marine_dropship/shuttle = SSshuttle.getShuttle(shuttle_tag)
	if(!shuttle)
		stack_trace("Invalid shuttle_tag [shuttle_tag]")
		return

	switch(action)
		if("equip_interact")
			var/base_tag = text2num(params["equip_interact"])
			var/obj/structure/dropship_equipment/E = shuttle_equipments[base_tag]
			E.linked_console = src
			E.equipment_interact(usr)

		if("open_fire")
			var/targ_id = text2num(params["open_fire"])
			var/mob/living/L = usr
			if(!istype(L))
				return
			if(!L.skills.getRating(SKILL_PILOT)) //everyone can fire dropship weapons while fumbling.
				L.visible_message(span_notice("[L] fumbles around figuring out how to use the automated targeting system."),
				span_notice("You fumble around figuring out how to use the automated targeting system."))
				var/fumbling_time = 10 SECONDS
				if(!do_after(L, fumbling_time, TRUE, src, BUSY_ICON_UNSKILLED))
					return FALSE
			for(var/X in GLOB.active_laser_targets)
				var/obj/effect/overlay/temp/laser_target/LT = X
				if(LT.target_id == targ_id)
					if(shuttle.mode != SHUTTLE_CALL)
						to_chat(L, span_warning("Dropship can only fire while in flight."))
						return
					if(shuttle.mode == SHUTTLE_HIJACK_LOCK)
						return
					if(!(selected_equipment?.dropship_equipment_flags & IS_WEAPON))
						to_chat(L, span_warning("No weapon selected."))
						return
					var/obj/structure/dropship_equipment/cas/weapon/DEW = selected_equipment
					if(!DEW.ammo_equipped || DEW.ammo_equipped.ammo_count <= 0)
						to_chat(L, span_warning("[DEW] has no ammo."))
						return
					if(!COOLDOWN_FINISHED(DEW, last_fired))
						to_chat(L, span_warning("[DEW] just fired, wait for it to cool down."))
						return
					if(QDELETED(LT)) // Quick final check on the Laser target
						return
					DEW.open_fire(LT)
					break

		if("deselect")
			selected_equipment = null

	return TRUE


/obj/machinery/computer/dropship_weapons/dropship1
	name = "\improper 'Alamo' weapons controls"
	req_access = list(ACCESS_MARINE_DROPSHIP)
	opacity = FALSE

/obj/machinery/computer/dropship_weapons/dropship1/Initialize(mapload)
	. = ..()
	shuttle_tag = SHUTTLE_ALAMO

/obj/machinery/computer/dropship_weapons/dropship2
	name = "\improper 'Normandy' weapons controls"
	req_access = list(ACCESS_MARINE_DROPSHIP)

/obj/machinery/computer/dropship_weapons/dropship2/Initialize(mapload)
	. = ..()
	shuttle_tag = SHUTTLE_NORMANDY
