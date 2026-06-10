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
end

--hub area
	--npc after the player goes away and returns (explains what to do; use talkit for speech, should be the headless dude from YAWB concept; is present on new game afterwards)
	--dialogue should be in-world and narrated through talk-it (use vector module option)
	--crafting system for custom perks and plot items (use both pixel materials and items on the floor)
	--shop for spells
	--ability to transfer equipment between saves
--mapgen
	--10 circles, with each one requiring progressively harder to obtain unlock items/conditions
	--first 5 use vanilla enemies, the latter 5 introduce worse enemies
	--escaping and providing rare materials allows one to repair the shop antenna (this turns shop 100% free)
	--custom ost through marshall
	--hybrid gen rules (use wang for baseline shape and then manually spawn in room geometries from a pool)
	--add a map that is created during the terrain gen step