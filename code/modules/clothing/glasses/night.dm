
// nightvision goggles

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	species_exception = list(/datum/species/robot)
	sprite_sheets = list(
		"Combat Robot" = 'icons/mob/species/robot/glasses.dmi',
		"Sterling Combat Robot" = 'icons/mob/species/robot/glasses_bravada.dmi',
		"Chilvaris Combat Robot" = 'icons/mob/species/robot/glasses_charlit.dmi',
		"Hammerhead Combat Robot" = 'icons/mob/species/robot/glasses_alpharii.dmi',
		"Ratcher Combat Robot" = 'icons/mob/species/robot/glasses_deltad.dmi')
	icon_state = "night"
	worn_icon_state = "glasses"
	lighting_cutoff = LIGHTING_CUTOFF_MEDIUM
	toggleable = TRUE


/obj/item/clothing/glasses/night/tx8
	name = "\improper BR-8 battle sight"
	desc = "A headset and night vision goggles system for the BR-8 Battle Rifle. Allows highlighted imaging of surroundings. Click it to toggle."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle)


/obj/item/clothing/glasses/night/m42_night_goggles
	name = "\improper M42 scout sight"
	desc = "A headset and night vision goggles system for the M42 Scout Rifle. Allows highlighted imaging of surroundings. Click it to toggle."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	vision_flags = SEE_TURFS
	toggleable = 1
	actions_types = list(/datum/action/item_action/toggle)


/obj/item/clothing/glasses/night/m42_night_goggles/upp
	name = "\improper Type 9 elite goggles"
	desc = "A headset and night vision goggles system used by USL forces. Allows highlighted imaging of surroundings. Click it to toggle."
	icon_state = "upp_goggles"
	deactive_state = "upp_goggles_0"

/obj/item/clothing/glasses/night/sectoid
	name = "alien lens"
	desc = "A thick, black coating over an alien's eyes, allowing them to see in the dark."
	icon_state = "alien_lens"
	worn_icon_state = "alien_lens"
	lighting_cutoff = LIGHTING_CUTOFF_FULLBRIGHT
	item_flags = DELONDROP
	toggleable = FALSE
	active = TRUE

/obj/item/clothing/glasses/night/sectoid/Initialize(mapload)
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, SECTOID_TRAIT)

/obj/item/clothing/glasses/night/m56_goggles
	name = "\improper KTLD head mounted sight"
	desc = "A headset and goggles system made to pair with any KTLD weapon, such as the SG type weapons. Has a low-res short range imager, allowing for view of terrain."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "m56_goggles"
	deactive_state = "m56_goggles_0"
	toggleable = TRUE
	actions_types = list(/datum/action/item_action/toggle)
	vision_flags = SEE_TURFS

/obj/item/clothing/glasses/night/sunglasses
	name = "\improper KTLD sunglasses"
	desc = "A pair of designer sunglasses. This pair has been fitted with a KTLD head mounted sight."
	icon = 'icons/obj/clothing/glasses.dmi'
	icon_state = "m56sunglasses"
	worn_icon_state = "m56sunglasses"
	deactive_state = "degoggles_mesonsunglasses"
	toggleable = TRUE
	actions_types = list(/datum/action/item_action/toggle)
	vision_flags = SEE_TURFS
	prescription = TRUE

/obj/item/clothing/glasses/night/optgoggles
	name = "\improper Optical imager ballistic goggles"
	desc = "Standard issue NTC goggles. This pair has been fitted with an internal optical imaging scanner."
	icon_state = "optgoggles"
	worn_icon_state = "optgoggles"
	deactive_state = "degoggles_optgoggles"
	toggleable = TRUE
	actions_types = list(/datum/action/item_action/toggle)
	species_exception = list(/datum/species/robot)
	sprite_sheets = list(
		"Combat Robot" = 'icons/mob/species/robot/glasses.dmi',
		"Sterling Combat Robot" = 'icons/mob/species/robot/glasses_bravada.dmi',
		"Chilvaris Combat Robot" = 'icons/mob/species/robot/glasses_charlit.dmi',
		"Hammerhead Combat Robot" = 'icons/mob/species/robot/glasses_alpharii.dmi',
		"Ratcher Combat Robot" = 'icons/mob/species/robot/glasses_deltad.dmi')
	equip_slot_flags = ITEM_SLOT_EYES
	goggles = TRUE

/obj/item/clothing/glasses/night/optgoggles/prescription
	name = "\improper Optical imager prescription ballistic goggles"
	desc = "Standard issue NTC prescription goggles. This pair has been fitted with an internal optical imaging scanner."
	prescription = TRUE

/obj/item/clothing/glasses/night/vsd
	name = "\improper CM-12 night vision goggles"
	desc = "KZ's night vision goggles, For the extra tacticool feel, Crash Core and your superior officers are not responsible for blindness and burning."
	icon = 'icons/mob/clothing/eyes.dmi'
	icon_state = "vsd_nvg"
	worn_icon_state = "vsd_nvg"
	deactive_state = "vsd_nvg_off"
	toggleable = TRUE
	actions_types = list(/datum/action/item_action/toggle)
	tint = COLOR_VERY_SOFT_YELLOW
	worn_layer = COLLAR_LAYER

/obj/item/clothing/glasses/night/vsd/alt
	name = "\improper CM-13 night vision faceplate"
	desc = "KZs night vision Faceplate, made for attachments to the Medium armor variant of their armor. Crash Core and your superior officers are not responsible for blindness and burning."
	icon_state = "vsd_alt"
	worn_icon_state = "vsd_alt"
	deactive_state = "vsd_alt_off"
	tint = COLOR_VERY_SOFT_YELLOW
