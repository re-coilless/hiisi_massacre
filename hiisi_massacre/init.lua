ModMagicNumbersFileAdd( "mods/hiisi_massacre/files/magic_numbers.xml" )

function OnModInit()
	dofile_once( "mods/mnee/lib.lua" )

	local xml = pen.lib.nxml.parse( pen.magic_read( "data/biome/_biomes_all.xml" ))
	xml:add_children( pen.lib.nxml.parse_many[[
		<Biome
			height_index="0"
			color="ffa399a7"
			biome_filename="mods/hiisi_massacre/files/terrain/citadel.xml"
		></Biome>
	]])
	pen.magic_write( "data/biome/_biomes_all.xml", tostring( xml ))

	--custom ost through marshall
	--do rings with gates that are open for now
	--lua walls should be a vector module

	--enemy spawning
	--allow trading unique currency for hp, wands and spells

	--ability to transfer equipment between saves
	--the main resource is the powder absorbed by player that is flammable and is dissolved on contact with water (add new ui element for it)
end

--hub area
	--npc after the player goes away and returns (explains what to do; use talkit for speech, should be the headless dude from YAWB concept; is present on new game afterwards)
	--dialogue should be in-world and narrated through talk-it (use vector module option)
	--crafting system for custom perks and plot items (use both pixel materials and items on the floor)
	--shop for spells
--mapgen
	--made from sparematter (penman should inject this)
	--10 circles, with each one requiring progressively harder to obtain unlock items/conditions
	--first 5 use vanilla enemies, the latter 5 introduce worse enemies
	--escaping and providing rare materials allows one to repair the shop antenna (this turns shop 100% free)
	--hybrid gen rules (use wang for baseline shape and then manually spawn in room geometries from a pool)
	--add a map that is created during the terrain gen step
--rooms
	--every room has a marker at the center that controls the spawns (the actual spawns are being done from init.lua)
	--horizontal room should have their cielings patched with phantom platforms
	--locked doors with keys in containers (keys are universal)
	--dead ends must always be locked and always have loot
	--locked or optinally locked rooms should have only one true entrance and one true exit
	--add bg doors that teleport between two locations (unlocked by pulling a lever at both sides)
	--archetypes: combat, storage, hallways, utility, volatile
	--variants: funny, ruins, ambush (enemy spawns have a chance to being retriggered), prison, armory
	--circles: Prologue (normal), Wastes (toxic), Abyss (flooded), Ruins (crumbling), Gehenna (burning with smoke everywhere), Crux (no enemies spawn statically, they come out of portals that open randomly + blaring alarms), Buffer (lots of turrents and heavily fortified positions), Masquerade (normal enemies are bursting into abominations that are hostile to everything), Noose (bosses everywhere), Gates (very different enemies + all doors are always locked)
	--gates are always located in the same spots, rotated 180 between each one (the initial orientation is randomized)
--unique items
	--return gate (creates an explosion where player was, can be used to cheese doors)
	--marker beacons + chalk
	--concrete sprayer
	--breach charge
	--supply crate
	--teleporter