/datum/emote
	var/key = "" //What calls the emote
	var/key_third_person = "" //This will also call the emote
	var/message = "" //Message displayed when emote is used
	var/message_alien = "" //Message displayed if the user is a grown alien
	var/message_larva = "" //Message displayed if the user is an alien larva
	var/message_AI = "" //Message displayed if the user is an AI
	var/message_monkey = "" //Message displayed if the user is a monkey
	var/message_simple = "" //Message to display if the user is a simple_animal
	var/message_param = "" //Message to display if a param was given
	var/emote_type = EMOTE_VISIBLE //Whether the emote is visible or audible
	var/list/mob_type_allowed_typecache = /mob //Types that are allowed to use that emote
	var/list/mob_type_blacklist_typecache //Types that are NOT allowed to use that emote
	var/list/mob_type_ignore_stat_typecache
	var/stat_allowed = CONSCIOUS
	var/sound //Sound to play when emote is called
	var/emote_flags = NONE
	/// Cooldown between two uses of that emote. Every emote has its own coodldown
	var/cooldown = 2 SECONDS

	var/static/list/emote_list = list()


/datum/emote/New()
	if(key_third_person)
		emote_list[key_third_person] = src

	if(ispath(mob_type_allowed_typecache))
		switch(mob_type_allowed_typecache)
			if(/mob)
				mob_type_allowed_typecache = GLOB.typecache_mob
			if(/mob/living)
				mob_type_allowed_typecache = GLOB.typecache_living
			else
				mob_type_allowed_typecache = typecacheof(mob_type_allowed_typecache)
	else
		mob_type_allowed_typecache = typecacheof(mob_type_allowed_typecache)

	mob_type_blacklist_typecache = typecacheof(mob_type_blacklist_typecache)
	mob_type_ignore_stat_typecache = typecacheof(mob_type_ignore_stat_typecache)


/datum/emote/proc/run_emote(mob/user, params, type_override, intentional = FALSE, prefix, range = 7, ghost_visible = TRUE)
	. = TRUE
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	var/msg = select_message_type(user)
	if(params && message_param)
		msg = select_param(user, params)

	msg = replace_pronoun(user, msg)

	if(!msg)
		return

	if(intentional)
		user.log_message(msg, LOG_EMOTE)
	var/dchatmsg = "[prefix]<b>[user]</b> [msg]"

	var/tmp_sound = get_sound(user)
	if(tmp_sound && (!(emote_flags & EMOTE_FORCED_AUDIO) || !intentional))
		playsound(user, tmp_sound, 50, emote_flags & EMOTE_VARY)

	if(user.client)
		for(var/mob/M AS in GLOB.dead_mob_list)
			if(!ismob(M) || isnewplayer(M) || !M.client)
				continue
			var/T1 = get_turf(user)
			var/T2 = get_turf(M)
			if((!(M.client.prefs.toggles_chat & CHAT_GHOSTSIGHT) && (get_dist(T1, T2) > range)))
				if(!check_other_rights(M.client, R_ADMIN, FALSE))
					continue
			if((M.faction != FACTION_NEUTRAL && user.faction != FACTION_NEUTRAL ) && M.faction != user.faction)
				user.balloon_alert(M, "does something you cannot see.")
				continue
			// If this is not meant to be visible to ghosts, make sure not to display it unless the user is an admin
			if (!(ghost_visible || check_rights_for(M.client, R_ADMIN)))
				continue
			M.show_message("[FOLLOW_LINK(M, user)] [dchatmsg]")

	// Ensure it filters to 'local' within chat tabs
	msg = span_emote("[msg]")

	// ghost_visible is set to false because the whole thing right above us already displays the message to ghosts. Don't wanna put it in chat twice.
	if(emote_type == EMOTE_AUDIBLE)
		user.audible_message(msg, audible_message_flags = EMOTE_MESSAGE, emote_prefix = prefix, hearing_distance = range, ghost_visible = FALSE)
	else
		user.visible_message(msg, visible_message_flags = EMOTE_MESSAGE, emote_prefix = prefix, vision_distance = range, ghost_visible = FALSE)

/// For handling emote cooldown, return true to allow the emote to happen
/datum/emote/proc/check_cooldown(mob/user, intentional)
	if(!intentional)
		return TRUE
	if(TIMER_COOLDOWN_RUNNING(user, "emote[key]"))
		return FALSE
	TIMER_COOLDOWN_START(user, "emote[key]", cooldown)
	return TRUE

/datum/emote/proc/get_sound(mob/living/user)
	return sound //by default just return this var.


/datum/emote/proc/replace_pronoun(mob/user, message)
//	if(findtext(message, "their"))
//		message = replacetext(message, "their", user.p_their())
//	if(findtext(message, "them"))
//		message = replacetext(message, "them", user.p_them())
	if(findtext(message, "%s"))
		message = replacetext(message, "%s", user.p_s())
	return message


/datum/emote/proc/select_message_type(mob/user)
	. = message
	if(!(emote_flags & EMOTE_MUZZLE_IGNORE) && user.is_muzzled() && emote_type == EMOTE_AUDIBLE)
		return "makes a [pick("strong ", "weak ", "")]noise."
	if(isxeno(user) && message_alien)
		. = message_alien
	else if(isxenolarva(user) && message_larva)
		. = message_larva
	else if(isAI(user) && message_AI)
		. = message_AI
	else if(ismonkey(user) && message_monkey)
		. = message_monkey
	else if(isanimal(user) && message_simple)
		. = message_simple


/datum/emote/proc/select_param(mob/user, params)
	return replacetext(message_param, "%t", params)


/datum/emote/proc/can_run_emote(mob/user, status_check = TRUE, intentional = FALSE)
	. = TRUE

	if(!is_type_in_typecache(user, mob_type_allowed_typecache))
		return FALSE

	if(is_type_in_typecache(user, mob_type_blacklist_typecache))
		return FALSE

	if(intentional)
		if(emote_flags & EMOTE_FORCED_AUDIO)
			return FALSE

		if(sound || get_sound(user))
			if(HAS_TRAIT(user, TRAIT_MUTED))
				user.balloon_alert(user, "You are muted!")
				return FALSE
			if(TIMER_COOLDOWN_RUNNING(user, COOLDOWN_EMOTE))
				user.balloon_alert(user, "You just did an audible emote")
				return FALSE
			else
				TIMER_COOLDOWN_START(user, COOLDOWN_EMOTE, 8 SECONDS)

		if(user.client)
			if(user.client.prefs.muted & MUTE_IC)
				to_chat(user, span_warning("You cannot send emotes (muted)."))
				return FALSE

			if(user.client.handle_spam_prevention(message, MUTE_IC))
				message_admins("Spam prevention triggered by [user] at [ADMIN_VERBOSEJMP(user)]")
				return FALSE

			if(is_banned_from(user.ckey, "Emote"))
				to_chat(user, span_warning("You cannot send emotes (banned)."))
				return FALSE

	if(status_check && !is_type_in_typecache(user, mob_type_ignore_stat_typecache))
		if(user.stat > stat_allowed)
			if(!intentional)
				return FALSE

			switch(user.stat)
				if(UNCONSCIOUS)
					to_chat(user, span_notice("You cannot [key] while unconscious."))
				if(DEAD)
					to_chat(user, span_notice("You cannot [key] while dead."))
			return FALSE

		if(emote_flags & EMOTE_RESTRAINT_CHECK)
			if(isliving(user))
				var/mob/living/L = user
				if(L.incapacitated())
					if(!intentional)
						return FALSE
					user.balloon_alert(user, "You cannot [key] while stunned")
					return FALSE

		if(emote_flags & EMOTE_ARMS_CHECK)
			///okay snapper
			var/mob/living/carbon/snapper = user
			var/datum/limb/left_hand = snapper.get_limb("l_hand")
			var/datum/limb/right_hand = snapper.get_limb("r_hand")
			if((!left_hand.is_usable()) && (!right_hand.is_usable()))
				to_chat(user, span_notice("You cannot [key] without a working hand."))
				return FALSE

		if((emote_flags & EMOTE_RESTRAINT_CHECK) && user.restrained())
			if(!intentional)
				return FALSE
			user.balloon_alert(user, "You cannot [key] while restrained")
			return FALSE

		if(emote_flags & EMOTE_ACTIVE_ITEM)
			if(!isnull(user.get_active_held_item()))
				return TRUE
			user.balloon_alert(user, "You need to hold an item to [key] it.")
			return FALSE
