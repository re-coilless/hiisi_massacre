CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/biome_scripts.lua" )
dofile_once( "data/scripts/biome_modifiers.lua" )
dofile_once( "mods/index_core/files/_lib.lua" )

RegisterSpawnFunction( 0xffa35700, "cell_init_a" )
RegisterSpawnFunction( 0xfff35700, "cell_init_b" )

function cell_gen( x, y, is_vertical )
	local may_gen = true
	local old_id = EntityGetClosestWithTag( x, y, "room" )
	if( pen.vld( old_id, true )) then
		local old_x, old_y = EntityGetTransform( old_id )
		may_gen = not( pen.epc( old_x, x ) and pen.epc( old_y, y ))
	end

	if( not( may_gen )) then return end
	--unique room bgs are done through entity sprites
	--align the hub room with wang grid and dynamically connect with the rooms

	--horizontal room should have their cielings patched with phantom platforms
	--locked doors with keys in containers (keys are universal)
	--dead ends must always be locked and always have loot
	--locked or optinally locked rooms should have only one true entrance and one true exit (spawn in hatches)
	--add bg doors that teleports between two locations (unlocked by pulling a lever at both sides)

	--archetypes (inherent geometry; done through pixel scenes loaded on room gen): combat, storage, hallways, utility, volatile
	--variants (enemies and loot, finer geometry): funny, ruins, ambush (enemy spawns have a chance to being retriggered), prison, armory
	--circles (additonal content layers): Prologue (normal), Wastes (toxic), Abyss (flooded), Ruins (crumbling), Gehenna (burning with smoke everywhere), Crux (no enemies spawn statically, they come out of portals that open randomly + blaring alarms), Buffer (lots of turrents and heavily fortified positions), Masquerade (normal buffed enemies are bursting into abominations on death that are hostile to everything), Noose (bosses everywhere), Gates (very different enemies + all doors are always locked)

	--gates are always located in the same spots (either to the left or to the right), rotated 180 between each one (the initial orientation is randomized)

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
				local path = "mods/hiisi_massacre/files/terrain/rooms/stub_"..( is_vertical and "v" or "h" ).."_"
				LoadPixelScene( path.."phys.png", path.."vis.png", x - off_x, y - off_y, path.."bg.png", true, false )
				break
			end
		end
	end

	local id = EntityLoad( "mods/hiisi_massacre/files/terrain/room.xml", x, y )
	pen.magic_storage( id, "uid", "value_string", table.concat({ x, ":", y }))
	pen.magic_storage( id, "is_vertical", "value_bool", is_vertical )

	pen.magic_storage( id, "circle_id", "value_int", circle_id )
	pen.magic_storage( id, "mob_count", "value_int", pen.random( 0, 7 ))
	if( not( is_valid )) then pen.magic_storage( id, "is_occupied", "value_bool", true ) end
end

function cell_init_a( x, y )
	return cell_gen( x, y, false )
end

function cell_init_b( x, y )
	return cell_gen( x, y, true )
end