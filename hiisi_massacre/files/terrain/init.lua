CHEST_LEVEL = 0
dofile_once( "data/scripts/director_helpers.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "data/scripts/biome_scripts.lua" )
dofile_once( "data/scripts/biome_modifiers.lua" )

dofile_once( "mods/index_core/files/_lib.lua" )

--horizontal
RegisterSpawnFunction( 0xff0aaaaa, "cell_init_a01" )
RegisterSpawnFunction( 0xff0aaaab, "cell_init_a02" )
RegisterSpawnFunction( 0xff0aaaac, "cell_init_a03" )
RegisterSpawnFunction( 0xff0aaaad, "cell_init_a04" )

RegisterSpawnFunction( 0xff0aaaae, "cell_init_a05" )
RegisterSpawnFunction( 0xff0aaaaf, "cell_init_a06" )
RegisterSpawnFunction( 0xff0aaaba, "cell_init_a07" )
RegisterSpawnFunction( 0xff0aaabb, "cell_init_a08" )

RegisterSpawnFunction( 0xff0aaabc, "cell_init_a09" )
RegisterSpawnFunction( 0xff0aaabd, "cell_init_a10" )
RegisterSpawnFunction( 0xff0aaabe, "cell_init_a11" )
RegisterSpawnFunction( 0xff0aaabf, "cell_init_a12" )

RegisterSpawnFunction( 0xff0aaaca, "cell_init_a13" )
RegisterSpawnFunction( 0xff0aaacb, "cell_init_a14" )
RegisterSpawnFunction( 0xff0aaacc, "cell_init_a15" )
RegisterSpawnFunction( 0xff0aaacd, "cell_init_a16" )

--vertical
RegisterSpawnFunction( 0xff1aaaaa, "cell_init_b01" )
RegisterSpawnFunction( 0xff1aaaab, "cell_init_b02" )
RegisterSpawnFunction( 0xff1aaaac, "cell_init_b03" )
RegisterSpawnFunction( 0xff1aaaad, "cell_init_b04" )
RegisterSpawnFunction( 0xff1aaaae, "cell_init_b05" )
RegisterSpawnFunction( 0xff1aaaaf, "cell_init_b06" )
RegisterSpawnFunction( 0xff1aaaba, "cell_init_b07" )
RegisterSpawnFunction( 0xff1aaabb, "cell_init_b08" )

RegisterSpawnFunction( 0xff1aaabc, "cell_init_b09" )
RegisterSpawnFunction( 0xff1aaabd, "cell_init_b10" )
RegisterSpawnFunction( 0xff1aaabe, "cell_init_b11" )
RegisterSpawnFunction( 0xff1aaabf, "cell_init_b12" )
RegisterSpawnFunction( 0xff1aaaca, "cell_init_b13" )
RegisterSpawnFunction( 0xff1aaacb, "cell_init_b14" )
RegisterSpawnFunction( 0xff1aaacc, "cell_init_b15" )
RegisterSpawnFunction( 0xff1aaacd, "cell_init_b16" )

RegisterSpawnFunction( 0xff1aaace, "cell_init_b17" )
RegisterSpawnFunction( 0xff1aaacf, "cell_init_b18" )
RegisterSpawnFunction( 0xff1aaada, "cell_init_b19" )
RegisterSpawnFunction( 0xff1aaadb, "cell_init_b20" )
RegisterSpawnFunction( 0xff1aaadc, "cell_init_b21" )
RegisterSpawnFunction( 0xff1aaadd, "cell_init_b22" )
RegisterSpawnFunction( 0xff1aaade, "cell_init_b23" )
RegisterSpawnFunction( 0xff1aaadf, "cell_init_b24" )

RegisterSpawnFunction( 0xff1aaaea, "cell_init_b25" )
RegisterSpawnFunction( 0xff1aaaeb, "cell_init_b26" )
RegisterSpawnFunction( 0xff1aaaec, "cell_init_b27" )
RegisterSpawnFunction( 0xff1aaaed, "cell_init_b28" )
RegisterSpawnFunction( 0xff1aaaee, "cell_init_b29" )
RegisterSpawnFunction( 0xff1aaaef, "cell_init_b30" )
RegisterSpawnFunction( 0xff1aaafa, "cell_init_b31" )
RegisterSpawnFunction( 0xff1aaafb, "cell_init_b32" )

--archetypes (inherent geometry; done through pixel scenes loaded on room gen): combat (platforms and cover), hallway (narrow passages and route obstructions), storage (small rooms and lots of doors), brewery (glass tanks with random liquids and useful props), volatile (suspended sections, explosives and lots of wood)
--variants (enemies and loot, finer geometry): funny, ruins, ambush (enemy spawns have a chance to being retriggered), prison, armory
--circles (additonal content layers, materials and decorations): Prologue (normal), Wastes (toxic), Abyss (flooded), Ruins (crumbling), Gehenna (burning with smoke everywhere), Crux (no enemies spawn statically, they come out of portals that open randomly + blaring alarms), Buffer (lots of turrents and heavily fortified positions), Masquerade (normal buffed enemies are bursting into abominations on death that are hostile to everything), Noose (bosses everywhere), Gates (very different enemies + all doors are always locked)

function cell_gen( x, y, is_vertical, type )
	local may_gen = true
	local old_id = EntityGetClosestWithTag( x, y, "room" )
	if( pen.vld( old_id, true )) then
		local old_x, old_y = EntityGetTransform( old_id )
		may_gen = not( pen.epc( old_x, x ) and pen.epc( old_y, y ))
	end

	if( not( may_gen )) then return end
	--unique room bgs are done through entity sprites
	--different room archetypes should have different enemy numbers

	--horizontal room should have their cielings patched with phantom platforms
	--locked doors with keys in containers (keys are universal)
	--dead ends must always be locked and always have loot
	--locked or optinally locked rooms should have only one true entrance and one true exit (spawn in hatches)
	--add bg doors that teleports between two locations (unlocked by pulling a lever at both sides)
	--ladders

	local is_valid, circle_id = true, 0
	local root_id = ( EntityGetWithTag( "room_root" ) or {})[1]
	if( pen.vld( root_id, true )) then
		local r_x, r_y = EntityGetTransform( root_id )
		local d = math.sqrt(( r_x - x )^2 + ( r_y - y )^2 ); is_valid = d > 1000
		local radius = tonumber( GlobalsGetValue( "HIISI_MASSACRE_RADIUS", "2000" ))
		for i = 1,10 do
			if( is_valid and d > radius*( i - 1 ) and d < radius*i ) then circle_id = i end
			if( d > radius*( i - 0.1 ) and d < radius*( i + 0.1 )) then
				local off_x, off_y = is_vertical and 85 or 155, is_vertical and 155 or 85
				local path = "mods/hiisi_massacre/files/rooms/stub_"..( is_vertical and "v" or "h" ).."_"
				LoadPixelScene( path.."phys.png", path.."vis.png", x - off_x, y - off_y, path.."bg.png", true, false )
				break
			end
		end
	end

	local id = EntityLoad( "mods/hiisi_massacre/files/rooms/root.xml", x, y )
	pen.magic_storage( id, "uid", "value_string", table.concat({ x, ":", y }))
	pen.magic_storage( id, "is_vertical", "value_bool", is_vertical )

	pen.magic_storage( id, "circle_id", "value_int", circle_id )
	pen.magic_storage( id, "mob_count", "value_int", pen.random( 0, 7 ))
	if( not( is_valid )) then pen.magic_storage( id, "is_occupied", "value_bool", true ) end

	local matter_rng = {
		["fff0bbaa"] = { --passive
			"water", "oil", "alcohol", },
		["fff0bbbb"] = { --dangeours
			"radioactive_liquid" },
		["fff0bbcc"] = { --magic
			 },
		["fff0bbdd"] = { --chaos
			 },
	}

	--vis and bg are optinal, check for file existance
	local is_alt = false--pen.vrandom( x + y, 1, 10 ) == 10
	local off_x, off_y = is_vertical and 70 or 140, is_vertical and 140 or 70
	local path = "mods/hiisi_massacre/files/rooms/cell_"..type..( is_alt and "b" or "a" ).."_"
	local vis_path = "mods/hiisi_massacre/files/rooms/cell_"..( is_vertical and "b" or "a" ).."_vis.png"
	-- LoadPixelScene( path.."phys.png", vis_path, x - off_x, y - off_y, nil, true, false, matter_rng )
end

for i = 1,( 16 + 32 ) do
	local type = ( i > 16 and "b" or "a" )..pen.get_long_num(( i > 16 and i - 16 or i ), 2 )
	_G[ "cell_init_"..type ] = function( x, y ) return cell_gen( x, y, i > 16, type ) end
end