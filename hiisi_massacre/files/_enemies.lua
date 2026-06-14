local VANILLA_PATH = "data/entities/animals/"

local enemies = { --steal the list from 19a
	{
		weight = function( info, circle_id )
			return circle_id == 1 and 1 or -1
		end,
		path = VANILLA_PATH.."scavenger_glue.xml",
	},
	{
		weight = 1,
		path = VANILLA_PATH.."miner.xml",
	},
	{
		weight = 1,
		path = VANILLA_PATH.."miner_fire.xml",
	},
	{
		weight = 3,
		path = VANILLA_PATH.."shotgunner.xml",
	},
	{
		weight = 5,
		path = VANILLA_PATH.."scavenger_smg.xml",
	},
	{
		weight = 3,
		path = VANILLA_PATH.."scavenger_grenade.xml",
	},
	{
		weight = 3,
		path = VANILLA_PATH.."scavenger_mine.xml",
	},
	{
		weight = 3,
		path = VANILLA_PATH.."scavenger_clusterbomb.xml",
	},
	{
		weight = 2,
		path = VANILLA_PATH.."sniper.xml",
	},
	{
		weight = 1,
		path = VANILLA_PATH.."scavenger_poison.xml",
	},
	{
		weight = 1,
		path = VANILLA_PATH.."flamer.xml",
	},
	{
		weight = 1,
		path = VANILLA_PATH.."icer.xml",
	},
	{
		weight = 1,
		path = VANILLA_PATH.."scavenger_leader.xml",
	},
}

--<{> MAGIC APPEND MARKER <}>--

return enemies