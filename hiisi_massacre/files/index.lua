local GLOBAL_MODES, GLOBAL_MUTATORS, APPLETS, BOSS_BARS,
	WAND_STATS, SPELL_STATS, MATTER_DESCS, ITEM_CATS, GUI_STRUCT = unpack( index.STRUCT )

index.STRUCT[9].vanilla_gold = GUI_STRUCT.gold
GUI_STRUCT.gold = function( screen_w, screen_h, xys )
    local xD = index.D
    xys.gold = index.STRUCT[9].vanilla_gold( screen_w, screen_h, xys )

    local pic_x, pic_y = unpack( xys.gold )
    pen.hallway( function()
        if( xD.gmod.menu_capable ) then return end
        
        pen.c.phl_sucker = pen.c.phl_sucker or {}
        local x, y = EntityGetTransform( xD.player_id )
        local sucker_id = pen.life_support( pen.c.phl_sucker, "main_counter",
            "mods/hiisi_massacre/files/philosophers_legacy_sucker.xml", x, y )

        local count = pen.magic_storage( xD.player_id, "philosophers_legacy", "value_int", nil, 0 )
        local mtr_comp = EntityGetFirstComponentIncludingDisabled( sucker_id, "MaterialInventoryComponent" )
        if( pen.vld( mtr_comp, true )) then
            local mtrs = ComponentGetValue2( mtr_comp, "count_per_material_type" )
            local mtr_num = pen.get_matter( mtrs, CellFactory_GetType( "philosophers_legacy" ))[2]
            if( mtr_num > 0 ) then
                pen.magic_storage( xD.player_id, "philosophers_legacy", "value_int", count + mtr_num )
                AddMaterialInventoryMaterial( sucker_id, "philosophers_legacy", 0 )
                pen.play_sound({ "data/audio/Desktop/player.bank", "player/pick_gold_sand", true }, x, y )
            end
        end

        local le_money = math.floor( pen.estimate( "philosophers_legacy", count, "exp", count/1000 ))
        
        local tip_x, tip_y = unpack( xys.hp )
        local v = pen.get_short_num( le_money )
        local tip = "Philosopher's Legacy: "..le_money
        local is_hovered = index.tipping( pic_x + 2.5, pic_y - 1, pen.Z.TIPS,
            { 10.5 + pen.get_text_dims( v, true ), 8 }, tip, { pos = { tip_x - 44, tip_y }, is_left = true })
        
        local c = is_hovered and pen.P.VNL.YELLOW or pen.P.WHITE
        pen.new.image( pic_x + 2.5, pic_y - 1.5, pen.Z.MAIN, "data/ui_gfx/hud/money.png", { color = c, has_shadow = true })
        pen.new.text( pic_x + 13, pic_y, pen.Z.MAIN, v, { color = c, is_huge = false, has_shadow = true, alpha = 0.9 })

        pic_y = pic_y + 8
    end)

    return { pic_x, pic_y }
end