ModMaterialsFileAdd( "mods/hiisi_massacre/files/terrain/matter.xml" )
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
	
	--upon entering a room, the entire thing should light up
	--add gates through the rings (rotate 180 between rings)
	--custom currency + loot crates
	--basic shop + meta storage for loot
	--the pacing is rather low rn, make the spawns be in larger numbers and come in waves (up to 5)

	--lua walls should be a vector module (do a universal prop module that allows for buttons and such with culling)
	--port out key n40 firearm sections to index (add a section of "extra" for others to use)

	--allow trading unique currency for hp, wands and spells
	--display the circle number once entered for the first time + manually shorten the delay to 0 on first entry
	--random wand gen is done using pen.simulate plinko thing with an ability to shake

	--ability to transfer equipment between saves
	--the main resource is the powder absorbed by player that is flammable and is dissolved on contact with water (add new ui element for it; spawns in open crates)
end

function OnWorldPreUpdate()
	dofile_once( "mods/mnee/lib.lua" )

	if( not( pen.vld( GameGetWorldStateEntity(), true ))) then return end

	local hooman = pen.get_hooman()
	pen.hallway( function() --maybe try point-based enemy spawns?
		if( not( pen.vld( hooman, true ))) then return end

		local x, y = EntityGetTransform( hooman )
		local room_id = EntityGetClosestWithTag( x, y, "room" )
		if( not( pen.vld( room_id, true ))) then return end

		local r_x, r_y = EntityGetTransform( room_id )
		local is_vert = pen.magic_storage( room_id, "is_vertical", "value_bool" )
		local shape = is_vert and { -70, 70, -140, 140 } or { -140, 140, -70, 70 }
		if( not( pen.check_bounds({ x, y }, shape, { r_x, r_y }))) then return end

		if( not( pen.magic_storage( room_id, "is_visited", "value_bool" ))) then
			pen.magic_storage( room_id, "is_visited", "value_bool", true ) end
		if( pen.magic_storage( room_id, "is_occupied", "value_bool" )) then return end
		
		local circle_id = pen.magic_storage( room_id, "circle_id", "value_int" )
		local enemies = dofile_once( "mods/hiisi_massacre/files/_enemies.lua" )
		for i = 1,pen.magic_storage( room_id, "mob_count", "value_int" ) do
			local enemy = pen.t.random( enemies, circle_id ) --sfx: https://www.youtube.com/watch?v=xe4aagn6q10
			local e_x, e_y = pen.magic_spawner( r_x, r_y, shape, { 10, 20 }, { exc = {{ x, y, 20 }}})
			if( pen.vld( e_x )) then
				local eid = EntityLoad( enemy.path, e_x, e_y )
				pen.t.loop( EntityGetComponentIncludingDisabled( eid, "LuaComponent" ), function( i,comp )
					if( ComponentGetValue2( comp, "script_death" ) == "data/scripts/items/drop_money.lua" ) then
						EntityRemoveComponent( eid, comp )
					end
				end)
			end
		end

		pen.magic_storage( room_id, "is_occupied", "value_bool", true )
	end)

	local initer = "ITS_MASSACRE_TIME"
	if( GameHasFlagRun( initer )) then return end
	GameAddFlagRun( initer )

	GlobalsSetValue( "MRSHLL_OST_BIOME_MIN", 600 )
	GlobalsSetValue( "MRSHLL_OST_BIOME_MAX", 1800 )
	GlobalsSetValue( "HIISI_MASSACRE_RADIUS", 2500 )

	if( ModIsEnabled( "hiisi_massacre_ost" )) then
		GlobalsSetValue( "MRSHLL_OST_QUEUE", GlobalsGetValue( "MRSHLL_OST_QUEUE", pen.DIV_1 ).."mods/hiisi_massacre_ost/mrshll_list.lua"..pen.DIV_1 )
	end
end

--hub area
	--start in a cell with hamis npc across from you, rat and frog are on the same side and above; kick the door out
	--npc after the player goes away and returns (explains what to do; use talkit for speech, should be the headless dude from YAWB concept; is present on new game afterwards)
	--dialogue should be in-world and narrated through talk-it (use vector module option)
	--crafting system for custom perks and plot items (use both pixel materials and items on the floor)
	--shop for spells
--mapgen
	--made from sparematter (penman should inject this)
	--10 circles, with each one requiring progressively harder to obtain unlock items/conditions
	--first 5 use vanilla enemies, the latter 5 introduce worse enemies
	--escaping and providing rare materials allows one to repair the shop antenna (this turns shop 100% free)
	--add a map that is created during the terrain gen step
--unique items
	--return gate (creates an explosion where player was, can be used to cheese doors)
	--marker beacons + chalk
	--concrete sprayer
	--breach charge
	--supply crate
	--teleporter