
//These are shuttle areas; all subtypes are only used as teleportation markers, they have no actual function beyond that.
//Multi area shuttles are a thing now, use subtypes! ~ninjanomnom

/area/shuttle
	name = "Shuttle"
	requires_power = FALSE
	always_unpowered = FALSE
//	valid_territory = FALSE
	icon_state = "shuttle"
	// Loading the same shuttle map at a different time will produce distinct area instances.
	unique = FALSE
	var/unmortarable = FALSE

///area/shuttle/Initialize(mapload)
//	if(!canSmoothWithAreas)
//		canSmoothWithAreas = type
//	. = ..()

/area/shuttle/PlaceOnTopReact(list/new_baseturfs, turf/fake_turf_type, flags)
	. = ..()
	if(length(new_baseturfs) > 1 || fake_turf_type)
		return // More complicated larger changes indicate this isn't a player
	if(ispath(new_baseturfs[1], /turf/open/floor/plating))
		new_baseturfs.Insert(1, /turf/baseturf_skipover/shuttle)

////////////////////////////Single-area shuttles////////////////////////////
/area/shuttle/dropship/Initialize(mapload, ...)
	. = ..()
	var/area/area = get_area(src)
	area.area_flags |= MARINE_BASE

/area/shuttle/dropship/alamo
	name = "Dropship Alamo"
	unmortarable = TRUE

/area/shuttle/dropship/elevator
	name = "Ship Elevator"

/area/shuttle/dropship/minielevator
	name = "Elevator"

/area/shuttle/dropship/normandy
	name = "Dropship Normandy"
	unmortarable = TRUE

/area/shuttle/dropship/triumph
	name = "Dropship Triumph"

/area/shuttle/cas
	name = "Condor Jet"

/area/shuttle/minidropship
	name = "Tadpole Drop Shuttle"
	unmortarable = TRUE
	//area_flags = NO_CONSTRUCTION

/area/shuttle/minidropship/Initialize(mapload, ...)
	. = ..()
	var/area/area = get_area(src)
	area.area_flags |= MARINE_BASE

/area/shuttle/ert
	name = "Emergency Response Team"

/area/shuttle/ert/upp
	name = "UPP ERT"

/area/shuttle/ert/pmc
	name = "PMC ERT"

/area/shuttle/big_ert
	name = "Big ERT Ship"

/area/shuttle/ert/ufo
	name = "Small UFO"

/area/shuttle/transit
	name = "Hyperspace"
	desc = "Weeeeee"
	base_lighting_alpha = 255


/area/shuttle/escape_pod
	name = "Escape Pod"
	minimap_color = MINIMAP_AREA_ESCAPE

/area/shuttle/custom
	name = "Custom player shuttle"

/area/shuttle/arrival
	name = "Arrival Shuttle"
	unique = TRUE  // SSjob refers to this area for latejoiners

/area/shuttle/pod_1
	name = "Escape Pod One"

/area/shuttle/pod_2
	name = "Escape Pod Two"

/area/shuttle/pod_3
	name = "Escape Pod Three"

/area/shuttle/pod_4
	name = "Escape Pod Four"

/area/shuttle/mining
	name = "Mining Shuttle"

/area/shuttle/labor
	name = "Labor Camp Shuttle"

/area/shuttle/supply
	name = "Supply Shuttle"

/area/shuttle/supply/som
	name = "SOM Supply Shuttle"

/area/shuttle/supply/clf
	name = "CLF Supply Shuttle"

/area/shuttle/vehicle_supply
	name = "Vehicle Supply Shuttle"

/*
/area/shuttle/escape
	name = "Emergency Shuttle"

/area/shuttle/escape/backup
	name = "Backup Emergency Shuttle"

/area/shuttle/escape/luxury
	name = "Luxurious Emergency Shuttle"
	noteleport = TRUE

/area/shuttle/escape/arena
	name = "The Arena"
	noteleport = TRUE

/area/shuttle/escape/meteor
	name = "\proper a meteor with engines strapped to it"*/

/area/shuttle/transport
	name = "Transport Shuttle"
//	blob_allowed = FALSE

/area/shuttle/assault_pod
	name = "Steel Rain"
//	blob_allowed = FALSE

/area/shuttle/sbc_starfury
	name = "SBC Starfury"
//	blob_allowed = FALSE

/area/shuttle/sbc_fighter1
	name = "SBC Fighter 1"
//	blob_allowed = FALSE

/area/shuttle/sbc_fighter2
	name = "SBC Fighter 2"
//	blob_allowed = FALSE

/area/shuttle/sbc_corvette
	name = "SBC corvette"
//	blob_allowed = FALSE

/area/shuttle/syndicate_scout
	name = "Syndicate Scout"
//	blob_allowed = FALSE

/area/shuttle/caravan
//	blob_allowed = FALSE
	requires_power = TRUE

/area/shuttle/caravan/syndicate1
	name = "Syndicate Fighter"

/area/shuttle/caravan/syndicate2
	name = "Syndicate Fighter"

/area/shuttle/caravan/syndicate3
	name = "Syndicate Drop Ship"

/area/shuttle/caravan/pirate
	name = "Pirate Cutter"

/area/shuttle/caravan/freighter1
	name = "Small Freighter"

/area/shuttle/caravan/freighter2
	name = "Tiny Freighter"

/area/shuttle/caravan/freighter3
	name = "Tiny Freighter"

/area/shuttle/canterbury
	name = "Canterbury"
	requires_power = TRUE
	always_unpowered = FALSE

/area/shuttle/canterbury/Initialize(mapload, ...)
	. = ..()
	var/area/area = get_area(src)
	area.area_flags |= MARINE_BASE

/area/shuttle/canterbury/cic
	name = "Combat Information Center"

/area/shuttle/canterbury/medical
	name = "Medical"

/area/shuttle/canterbury/general
	name = "Canterbury"
