CHEST_LEVEL = 0
dofile_once("data/scripts/director_helpers.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once( "data/scripts/biome_scripts.lua" )
dofile_once( "data/scripts/biome_modifiers.lua" )

RegisterSpawnFunction( 0xffffeedd, "cell_gen" )

function cell_gen( x, y, w, h )
	print("balls")
end