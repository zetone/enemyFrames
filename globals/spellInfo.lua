
    HEX_CLASS_COLORS = {
        ['DRUID']   = 'ff7d0a',
        ['HUNTER']  = 'abd473',
        ['MAGE']    = '69ccf0',
        ['PALADIN'] = 'f58cba',
        ['PRIEST']  = 'ffffff',
        ['ROGUE']   = 'fff569',
        ['SHAMAN']  = 'f58cba',--'0070de',
        ['WARLOCK'] = '9482c9',
        ['WARRIOR'] = 'c79c6e',
    }
	
	RGB_SPELL_SCHOOL_COLORS = 
	{
		['physical'] 	= {.9, .9, 0},
		['arcane'] 		= {.9, .4, .9},
		['fire']		= {.9, .4, 0},
		['nature'] 		= {.3, .9, .2},
		['frost'] 		= {.4,.9, .9},
		['shadow'] 		= {.4, .4, .9},
		['holy'] 		= {.9, .4, .9}
	}

	RGB_FACTION_COLORS = 
	{
		['Alliance'] = {['r'] = 0, ['g'] = .68, ['b'] = .94}, 
		['Horde'] = {['r'] = 1, ['g'] = .1, ['b'] = .1}
	}
	
	local RGB_POWER_COLORS =
	{
		['energy']		= {1, 1, 0},
		['focus']		= {1, .5, .25},
		['mana']		= {0, 0, 1},
		['rage']		= {1, 0, 0},
		
	}
		
	GET_RGB_POWER_COLORS_BY_CLASS = function(class)
		return class == 'ROGUE' and RGB_POWER_COLORS['energy'] or class == 'WARRIOR' and RGB_POWER_COLORS['rage'] or RGB_POWER_COLORS['mana']
	end
	
	RGB_BORDER_DEBUFFS_COLOR =
	{
		--['none']		= {.8, 0, 0}
		['curse']		= {.6, 0, 1},
		['disease']		= {.6, .4, 0},
		['magic'] 		= {.2, .6, 1},
		['physical'] 	= {.8, 0, 0},
		['poison'] 		= {0, .6, 0},		
	}
	
	local iconFolders = 
	{
		['class'] 		= [[Interface\AddOns\enemyFrames\globals\resources\ClassIcons\ClassIcon_]],
		['rank']  		= [[Interface\PvPRankBadges\PvPRank]],
		['portrait'] 	= [[Interface\characterframe\TEMPORARYPORTRAIT-]],
	}

	GET_DEFAULT_ICON = function(op, value)
		local dir = iconFolders[op]
		-- rank file hack
		local a = op == 'rank' and value < 10 and '0' or ''
		return dir .. a .. value
	end
	
	RANK_BY_TITLE = 
	{
		-- alliance
		['Private']	= 1, 				['Corporal']	= 2, 		['Sergeant']	= 3, 		['Master Sergeant'] = 4, 			
		['Sergeant Major']	= 5, 		['Knight']	= 6, 			['Knight-Lieutenant'] = 7, 	['Knight-Captain']	= 8, 	['Knight-Champion']	= 9, 	
		['Lieutenant Commander'] = 10, 	['Commander']	= 11, 		['Marshal']	= 12, 			['Field Marshal']	= 13, 	['Grand Marshal']	= 14, 
		-- horde
		['Scout']	= 1, 			['Grunt']	= 2, 				['Sergeant']	= 3, 	['Senior Sergeant'] = 4, 			
		['First Sergeant']	= 5, 	['Stone Guard']	= 6, 			['Blood Guard'] = 7, 	['Legionnaire']	= 8, 	['Centurion']	= 9, 	
		['Champion'] = 10, 			['Lieutenant General']	= 11, 	['General']	= 12, 		[' 	Warlord']	= 13, 	['High Warlord']	= 14,
	}

	
	RAID_TARGET_TCOORDS = 
	{
		['star']		= {0, .25, 0, .25},
		['circle']		= {.25, .5, 0, .25},
		['diamond']		= {.5, .75, 0, .25},
		['triangle']	= {.75, 1, 0, .25},
		
		['moon']		= {0, .25, .25, .5},
		['square']		= {.25, .5, .25, .5},
		['cross']		= {.5, .75, .25, .5},
		['skull'] 		= {.75, 1, .25, .5},
	}
	SPELLINFO_TRADECASTS_TO_TRACK = {
		-- ALCHEMY
		['Greater Healing Potion']					= {['icon'] = [[Interface\Icons\Inv_potion_52]], ['casttime'] = 3},
		['Greater Fire Protection Potion']			= {['icon'] = [[Interface\Icons\Inv_potion_24]], ['casttime'] = 3},
		['Major Healing Potion']					= {['icon'] = [[Interface\Icons\Inv_potion_54]], ['casttime'] = 3},
		['Major Mana Potion']						= {['icon'] = [[Interface\Icons\Inv_potion_76]], ['casttime'] = 3},
		['Mana Potion']								= {['icon'] = [[Interface\Icons\Inv_potion_72]], ['casttime'] = 3},
		['Swiftness Potion']						= {['icon'] = [[Interface\Icons\Inv_potion_95]], ['casttime'] = 3},
		['Transmute: Arcanite']						= {['icon'] = [[Interface\Icons\Inv_misc_stonetablet_05]], ['casttime'] = 25},
		-- BLACKSMITH
		-- COOKING
		['Smoked Sagefish']							= {['icon'] = [[Interface\Icons\Inv_misc_fish_20]], ['casttime'] = 3},
		['Savory Deviate Delight']					= {['icon'] = [[Interface\Icons\Inv_misc_monsterhead_04]], ['casttime'] = 3},
		-- ENCHANTING
		['Enchant Chest - Minor Mana']				= {['icon'] = [[Interface\Icons\Ability_warstomp]], ['casttime'] = 5},
		-- ENGINEERING
		-- FIRST AID
    	['Linen Bandage']           				= {['icon'] = [[Interface\Icons\Inv_misc_bandage_15]], ['casttime'] = 3},
    	['Heavy Linen Bandage']     				= {['icon'] = [[Interface\Icons\Inv_misc_bandage_18]], ['casttime'] = 3},
    	['Wool Bandage']           					= {['icon'] = [[Interface\Icons\Inv_misc_bandage_14]], ['casttime'] = 3},
    	['Heavy Wool Bandage']     					= {['icon'] = [[Interface\Icons\Inv_misc_bandage_17]], ['casttime'] = 3},
    	['Silk Bandage']            				= {['icon'] = [[Interface\Icons\Inv_misc_bandage_01]], ['casttime'] = 3},
    	['Heavy Silk Bandage']      				= {['icon'] = [[Interface\Icons\Inv_misc_bandage_02]], ['casttime'] = 3},
    	['Mageweave Bandage']       				= {['icon'] = [[Interface\Icons\Inv_misc_bandage_19]], ['casttime'] = 3},
    	['Heavy Mageweave Bandage'] 				= {['icon'] = [[Interface\Icons\Inv_misc_bandage_20]], ['casttime'] = 3},
    	['Runecloth Bandage']       				= {['icon'] = [[Interface\Icons\Inv_misc_bandage_11]], ['casttime'] = 3},
    	['Heavy Runecloth Bandage']					= {['icon'] = [[Interface\Icons\Inv_misc_bandage_12]], ['casttime'] = 3},
		-- LEATHERWORKING
		-- MINING
		['Smelt Copper']							= {['icon'] = [[Interface\Icons\Inv_ingot_02]], ['casttime'] = 3},
		['Copper Bar']								= {['icon'] = [[Interface\Icons\Inv_ingot_02]], ['casttime'] = 3},
		['Smelt Tin']								= {['icon'] = [[Interface\Icons\Inv_ingot_05]], ['casttime'] = 3},
		['Smelt Bronze']							= {['icon'] = [[Interface\Icons\Inv_ingot_02]], ['casttime'] = 3},		
		['Smelt Silver']							= {['icon'] = [[Interface\Icons\Inv_ingot_01]], ['casttime'] = 3},	
		['Smelt Gold']								= {['icon'] = [[Interface\Icons\Inv_ingot_03]], ['casttime'] = 3},
		['Smelt Iron']								= {['icon'] = [[Interface\Icons\Inv_ingot_04]], ['casttime'] = 3},
		['Smelt Mithril']							= {['icon'] = [[Interface\Icons\Inv_ingot_06]], ['casttime'] = 3},
		['Smelt Truesilver']						= {['icon'] = [[Interface\Icons\Inv_ingot_08]], ['casttime'] = 3},
		['Smelt Thorium']							= {['icon'] = [[Interface\Icons\Inv_ingot_07]], ['casttime'] = 3},	
		['Thorium Bar']								= {['icon'] = [[Interface\Icons\Inv_ingot_07]], ['casttime'] = 3},		
		-- TAILORING
			
	}

    SPELLINFO_SPELLCASTS_TO_TRACK = {
			-- MISC
		['Cultivate Packet of Seeds'] 	= {['icon'] = [[Interface\Icons\inv_misc_food_45]], 		['casttime'] = 10},
		['Furbolg Form'] 				= {['icon'] = [[Interface\Icons\Inv_misc_monsterclaw_04]], 	['casttime'] = 2},
		['Disenchant']					= {['icon'] = [[Interface\Icons\Inv_Enchant_Disenchant]], 	['casttime'] = 3},
		['Drink Minor Potion']			= {['icon'] = [[Interface\Icons\Spell_holy_heal]], 			['casttime'] = 3},
		['Holy Smite']					= {['icon'] = [[Interface\Icons\Spell_holy_holysmite]], 	['casttime'] = 2.5},
            -- AHN'QIRAJ
        ['Explode']                 	= {['icon'] = [[Interface\Icons\Spell_fire_selfdestruct]], 	['casttime'] = 6},
            -- BLACKWING LAIR
        ['Shadow Flame']            	= {['icon'] = [[Interface\Icons\Spell_fire_incinerate]], 	['casttime'] = 2},
        ['Wing Buffet']             	= {['icon'] = [[Interface\Icons\Inv_misc_monsterscales_14]],['casttime'] = 1},
        ['Bellowing Roar']          	= {['icon'] = [[Interface\Icons\Spell_fire_fire]], 			['casttime'] = 1.75},
		    -- BLACKROCK SPIRE
        ['Flame Buffet']              	= {['icon'] = [[Interface\Icons\Spell_fire_selfdestruct]], 	['casttime'] = 6},
            -- ONYXIA
        ['Breath']                  	= {['icon'] = [[Interface\Icons\Spell_fire_fire]], 			['casttime'] = 8},
			-- MOLTEN CORE
        ['Dark Mending']              	= {['icon'] = [[Interface\Icons\Spell_shadow_chilltouch]], 			['casttime'] = 2},
        ['Dominate Mind']             	= {['icon'] = [[Interface\Icons\Spell_shadow_shadowworddominate]], 	['casttime'] = 2},
        ['Elemental Fire']            	= {['icon'] = [[Interface\Icons\Spell_fire_fireball02]], 			['casttime'] = .5},
        ['Magma Blast']               	= {['icon'] = [[Interface\Icons\Spell_fire_fireblast]], 			['casttime'] = 1},
        ['Summon Ragnaros']          	= {['icon'] = [[Interface\Icons\Spell_fire_lavaspawn]],				['casttime'] = 10},
			-- DIRE MAIL
        ['Arcane Bolt']              	= {['icon'] = [[Interface\Icons\Spell_arcane_starfire]], 			['casttime'] = 1},
			-- STRATHOLME
        ['Banshee Wail']              	= {['icon'] = [[Interface\Icons\Spell_shadow_shadowbolt]], 		['casttime'] = 1.5},
        ['Venom Spit']                	= {['icon'] = [[Interface\Icons\Spell_nature_corrosivebreath]], ['casttime'] = 2.5},
		
            -- GLOBAL
        ['Dark Mending']            = {['icon'] = [[Interface\Icons\Spell_shadow_chilltouch]], 		['casttime'] = 2},
        ['Hearthstone']             = {['icon'] = [[Interface\Icons\INV_Misc_Rune_01]], 			['casttime'] = 10},
        ['Magic Dust']              = {['icon'] = [[Interface\Icons\Inv_misc_dust_02]], 			['casttime'] = 1.5},
        ['Reckless Charge']         = {['icon'] = [[Interface\Icons\Spell_nature_astralrecal]], 	['casttime'] = .1},
        ['Sleep']                   = {['icon'] = [[Interface\Icons\Spell_nature_sleep]], 			['casttime'] = 1.5},
        ['War Stomp']               = {['icon'] = [[Interface\Icons\Ability_warstomp]], 			['casttime'] = .5},

            -- ENGINEERING
        ['Rough Copper Bomb']       = {['icon'] = [[Interface\Icons\Inv_misc_bomb_09]], ['casttime'] = 1},
    	['Large Copper Bomb']       = {['icon'] = [[Interface\Icons\Inv_misc_bomb_01]], ['casttime'] = 1},
    	['Small Bronze Bomb']       = {['icon'] = [[Interface\Icons\Inv_misc_bomb_09]], ['casttime'] = 1},
    	['Big Bronze Bomb']         = {['icon'] = [[Interface\Icons\Inv_misc_bomb_05]], ['casttime'] = 1},
    	['Iron Grenade']            = {['icon'] = [[Interface\Icons\Inv_misc_bomb_08]], ['casttime'] = 1},
    	['Big Iron Bomb']           = {['icon'] = [[Interface\Icons\Inv_misc_bomb_01]], ['casttime'] = 1},
    	['Mithril Frag Bomb']       = {['icon'] = [[Interface\Icons\Inv_misc_bomb_02]], ['casttime'] = 1},
    	['Hi-Explosive Bomb']       = {['icon'] = [[Interface\Icons\Inv_misc_bomb_07]], ['casttime'] = 1},
    	['Thorium Grenade']         = {['icon'] = [[Interface\Icons\Inv_misc_bomb_08]], ['casttime'] = 1},
    	['Dark Iron Bomb']          = {['icon'] = [[Interface\Icons\Inv_misc_bomb_05]], ['casttime'] = 1},
    	['Arcane Bomb']             = {['icon'] = [[Interface\Icons\Spell_shadow_mindbomb]], ['casttime'] = 1},
 
            -- DRUID
        ['Entangling Roots']        = {['icon'] = [[Interface\Icons\Spell_nature_stranglevines]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'nature', ['class'] = 'DRUID'},
        ['Healing Touch']           = {['icon'] = [[Interface\Icons\Spell_nature_healingtouch]], ['casttime'] = 3, ['class'] = 'DRUID'},
        ['Hibernate']               = {['icon'] = [[Interface\Icons\Spell_nature_sleep]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'nature', ['class'] = 'DRUID'},
        ['Rebirth']                 = {['icon'] = [[Interface\Icons\Spell_nature_reincarnation]], ['casttime'] = 2, ['class'] = 'DRUID'},
        ['Regrowth']                = {['icon'] = [[Interface\Icons\Spell_nature_resistnature]], ['casttime'] = 2, ['class'] = 'DRUID'},
        ['Soothe Animal']           = {['icon'] = [[Interface\Icons\Ability_hunter_beastsoothe]], ['casttime'] = 1.5, ['class'] = 'DRUID'},
        ['Starfire']                = {['icon'] = [[Interface\Icons\Spell_arcane_starfire]], ['casttime'] = 3, ['type'] = 'dmg', ['school'] = 'nature', ['class'] = 'DRUID'},
        ['Teleport: Moonglade']     = {['icon'] = [[Interface\Icons\Spell_arcane_teleportmoonglade]], ['casttime'] = 10, ['class'] = 'DRUID'},
        ['Wrath']                   = {['icon'] = [[Interface\Icons\Spell_nature_abolishmagic]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'nature', ['class'] = 'DRUID'},
            -- HUNTER
        ['Aimed Shot']              = {['icon'] = [[Interface\Icons\Inv_spear_07]], ['casttime'] = 2.5, ['type'] = 'dmg', ['school'] = 'physical', ['class'] = 'HUNTER'},
        ['Dismiss Pet']             = {['icon'] = [[Interface\Icons\Spell_nature_spiritwolf]], ['casttime'] = 5},
        ['Eyes of the Beast']       = {['icon'] = [[Interface\Icons\Ability_eyeoftheowl]], ['casttime'] = 2},
        ['Revive Pet']              = {['icon'] = [[Interface\Icons\Ability_hunter_beastsoothe]], ['casttime'] = 10},
        ['Scare Beast']             = {['icon'] = [[Interface\Icons\Ability_druid_cower]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'physical', ['class'] = 'HUNTER'},
            -- MAGE
--        ['Arcane Missile']         = {[[Interface\Icons\Spell_nature_starfall]], 3},
--		['Arcane Missiles']         = {[[Interface\Icons\Spell_nature_starfall]], 5},
--        ['Blizzard']                = {[[Interface\Icons\Spell_frost_icestorm]], 8},
        ['Conjure Food']            = {['icon'] = [[Interface\Icons\Inv_misc_food_73cinnamonroll]], ['casttime'] = 3, ['class'] = 'MAGE'},
        ['Conjure Water']           = {['icon'] = [[Interface\Icons\Inv_drink_18]], ['casttime'] = 3, ['class'] = 'MAGE'},
        ['Conjure Mana Agate']      = {['icon'] = [[Interface\Icons\Inv_misc_gem_emerald_01]], ['casttime'] = 3, ['class'] = 'MAGE'},
        ['Conjure Mana Citrine']    = {['icon'] = [[Interface\Icons\Inv_misc_gem_opal_01]], ['casttime'] = 3, ['class'] = 'MAGE'},
        ['Conjure Mana Jade']       = {['icon'] = [[Interface\Icons\Inv_misc_gem_emerald_02]], ['casttime'] = 3, ['class'] = 'MAGE'},
        ['Conjure Mana Ruby']       = {['icon'] = [[Interface\Icons\Inv_misc_gem_ruby_01]], ['casttime'] = 3, ['class'] = 'MAGE'},
--        ['Evocation']               = {[[Interf ace\Icons\Spell_nature_purge]], 8},
        ['Fireball']                = {['icon'] = [[Interface\Icons\Spell_fire_flamebolt]], ['casttime'] = 2.5, ['type'] = 'dmg', ['school'] = 'fire', ['class'] = 'MAGE'},
        ['Frostbolt']               = {['icon'] = [[Interface\Icons\Spell_frost_frostbolt02]], ['casttime'] = 2.5, ['type'] = 'dmg', ['school'] = 'frost', ['class'] = 'MAGE'},
        ['Flamestrike']             = {['icon'] = [[Interface\Icons\Spell_fire_selfdestruct]], ['casttime'] = 3, ['class'] = 'MAGE'},
        ['Polymorph']               = {['icon'] = [[Interface\Icons\Spell_nature_polymorph]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'arcane', ['class'] = 'MAGE'},
        ['Polymorph: Pig']          = {['icon'] = [[Interface\Icons\Spell_magic_polymorphpig]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'arcane', ['class'] = 'MAGE'},
        ['Polymorph: Turtle']       = {['icon'] = [[Interface\Icons\Ability_hunter_pet_turtle]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'arcane', ['class'] = 'MAGE'},
        ['Portal: Darnassus']       = {['icon'] = [[Interface\Icons\Spell_arcane_portaldarnassus]], ['casttime'] = 10},
    	['Portal: Thunder Bluff']   = {['icon'] = [[Interface\Icons\Spell_arcane_portalthunderbluff]], ['casttime'] = 10},
    	['Portal: Ironforge']       = {['icon'] = [[Interface\Icons\Spell_arcane_portalironforge]], ['casttime'] = 10},
    	['Portal: Orgrimmar']       = {['icon'] = [[Interface\Icons\Spell_arcane_portalorgrimmar]], ['casttime'] = 10},
    	['Portal: Stormwind']       = {['icon'] = [[Interface\Icons\Spell_arcane_portalstormwind]], ['casttime'] = 10},
    	['Portal: Undercity']       = {['icon'] = [[Interface\Icons\Spell_arcane_portalundercity]], ['casttime'] = 10},
    	['Teleport: Darnassus']     = {['icon'] = [[Interface\Icons\Spell_arcane_teleportdarnassus]], ['casttime'] = 10},
    	['Teleport: Thunder Bluff'] = {['icon'] = [[Interface\Icons\Spell_arcane_teleportthunderbluff]], ['casttime'] = 10},
    	['Teleport: Ironforge']     = {['icon'] = [[Interface\Icons\Spell_arcane_portalironforge]], ['casttime'] = 10},
    	['Teleport: Orgrimmar']     = {['icon'] = [[Interface\Icons\Spell_arcane_teleportorgrimmar]], ['casttime'] = 10},
    	['Teleport: Stormwind']     = {['icon'] = [[Interface\Icons\Spell_arcane_teleportstormwind]], ['casttime'] = 10},
    	['Teleport: Undercity']     = {['icon'] = [[Interface\Icons\Spell_arcane_teleportundercity]], ['casttime'] = 10},
        ['Pyroblast']               = {['icon'] = [[Interface\Icons\Spell_fire_fireball02]], ['casttime'] = 6, ['type'] = 'dmg', ['school'] = 'fire', ['class'] = 'MAGE'},
        ['Scorch']                  = {['icon'] = [[Interface\Icons\Spell_fire_soulburn]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'fire', ['class'] = 'MAGE'},
            -- PALADIN
        ['Hammer of Wrath']         = {['icon'] = [[Interface\Icons\Ability_ThunderClap]], ['casttime'] = 1},
        ['Holy Light']              = {['icon'] = [[Interface\Icons\Spell_holy_holybolt]], ['casttime'] = 2.5},
        ['Holy Wrath']              = {['icon'] = [[Interface\Icons\Spell_holy_weaponmastery]], ['casttime'] = 2},
        ['Flash of Light']          = {['icon'] = [[Interface\Icons\Spell_holy_flashheal]], ['casttime'] = 1.5},
        ['Redemption']              = {['icon'] = [[Interface\Icons\Spell_holy_resurrection]], ['casttime'] = 10},
        ['Summon Warhorse']         = {['icon'] = [[Interface\Icons\Spell_nature_swiftness]], ['casttime'] = 3},
        ['Summon Charger']          = {['icon'] = [[Interface\Icons\Ability_mount_charger]], ['casttime'] = 3},
        ['Turn Undead']             = {['icon'] = [[Interface\Icons\Spell_holy_turnundead]], ['casttime'] = 1.5},
		
            -- PRIEST
        ['Flash Heal']              = {['icon'] = [[Interface\Icons\Spell_holy_flashheal]], ['casttime'] = 1.5},
        ['Greater Heal']            = {['icon'] = [[Interface\Icons\Spell_holy_greaterheal]], ['casttime'] = 2.5},
        ['Heal']                    = {['icon'] = [[Interface\Icons\Spell_holy_heal]], ['casttime'] = 2.5},
        ['Holy Fire']               = {['icon'] = [[Interface\Icons\Spell_holy_searinglight]], ['casttime'] = 3.5, ['type'] = 'dmg', ['school'] = 'holy', ['class'] = 'PRIEST'},
		['Lesser Heal']				= {['icon'] = [[Interface\Icons\Spell_holy_lesserheal]], ['casttime'] = 1.5},
        ['Mana Burn']               = {['icon'] = [[Interface\Icons\Spell_shadow_manaburn]], ['casttime'] = 3, ['type'] = 'dmg', ['school'] = 'shadow', ['class'] = 'PRIEST'},
        ['Mind Blast']              = {['icon'] = [[Interface\Icons\Spell_shadow_unholyfrenzy]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'shadow', ['class'] = 'PRIEST'},
        ['Mind Control']            = {['icon'] = [[Interface\Icons\Spell_shadow_shadowworddominate]], ['casttime'] = 3, ['type'] = 'dmg', ['school'] = 'shadow', ['class'] = 'PRIEST'},
--		['Mind Flay']   	       	= {[[Interface\Icons\Spell_shadow_siphonmana]], 3},
--		['Mind Vision']             = {[[Interface\Icons\Spell_holy_mindvision]], 30},
        ['Prayer of Healing']       = {['icon'] = [[Interface\Icons\Spell_holy_prayerofhealing02]], ['casttime'] = 3},
        ['Resurrection']            = {['icon'] = [[Interface\Icons\Spell_holy_resurrection]], ['casttime'] = 10},
        ['Shackle Undead']          = {['icon'] = [[Interface\Icons\Spell_nature_slow]], ['casttime'] = 1.5},
        ['Smite']                   = {['icon'] = [[Interface\Icons\Spell_holy_holysmite]], ['casttime'] = 2.5, ['type'] = 'dmg', ['school'] = 'holy', ['class'] = 'PRIEST'},
            -- ROGUE
        ['Disarm Trap']             = {['icon'] = [[Interface\Icons\Spell_shadow_grimward]], 		['casttime'] = 5},
        ['Mind-numbing Poison']     = {['icon'] = [[Interface\Icons\Spell_nature_nullifydisease]], 	['casttime'] = 3},
        ['Mind-numbing Poison II']  = {['icon'] = [[Interface\Icons\Spell_nature_nullifydisease]], 	['casttime'] = 3},
        ['Mind-numbing Poison III'] = {['icon'] = [[Interface\Icons\Spell_nature_nullifydisease]], 	['casttime'] = 3},
        ['Instant Poison']          = {['icon'] = [[Interface\Icons\Spell_nature_corrosivebreath]], ['casttime'] = 3},
        ['Instant Poison II']       = {['icon'] = [[Interface\Icons\Spell_nature_corrosivebreath]], ['casttime'] = 3},
        ['Instant Poison III']      = {['icon'] = [[Interface\Icons\Spell_nature_corrosivebreath]], ['casttime'] = 3},
        ['Instant Poison IV']       = {['icon'] = [[Interface\Icons\Spell_nature_corrosivebreath]], ['casttime'] = 3},
        ['Instant Poison V']        = {['icon'] = [[Interface\Icons\Spell_nature_corrosivebreath]], ['casttime'] = 3},
        ['Instant Poison VI']       = {['icon'] = [[Interface\Icons\Spell_nature_corrosivebreath]], ['casttime'] = 3},
        ['Deadly Poison']           = {['icon'] = [[Interface\Icons\Ability_rogue_dualweild]], 		['casttime'] = 3},
        ['Deadly Poison II']        = {['icon'] = [[Interface\Icons\Ability_rogue_dualweild]], 		['casttime'] = 3},
        ['Deadly Poison III']       = {['icon'] = [[Interface\Icons\Ability_rogue_dualweild]], 		['casttime'] = 3},
        ['Deadly Poison IV']        = {['icon'] = [[Interface\Icons\Ability_rogue_dualweild]], 		['casttime'] = 3},
        ['Deadly Poison V']         = {['icon'] = [[Interface\Icons\Ability_rogue_dualweild]], 		['casttime'] = 3},
        ['Crippling Poison']        = {['icon'] = [[Interface\Icons\Ability_poisonsting]], 			['casttime'] = 3},
        ['Pick Lock']               = {['icon'] = [[Interface\Icons\Spell_nature_moonkey]], ['casttime'] = 5},
            -- SHAMAN
        ['Ancestral Spirit']        = {['icon'] = [[Interface\Icons\Spell_nature_regenerate]], ['casttime'] = 10},
        ['Astral Recall']           = {['icon'] = [[Interface\Icons\Spell_nature_astralrecal]], ['casttime'] = 10},
        ['Chain Heal']              = {['icon'] = [[Interface\Icons\Spell_nature_healingwavegreater]], ['casttime'] = 2.5},
        ['Chain Lightning']         = {['icon'] = [[Interface\Icons\Spell_nature_chainlightning]], ['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'nature', ['class'] = 'SHAMAN'},
        ['Far Sight']               = {['icon'] = [[Interface\Icons\Spell_nature_farsight]], ['casttime'] = 2},
        ['Ghost Wolf']              = {['icon'] = [[Interface\Icons\Spell_nature_spiritwolf]], ['casttime'] = 3},
        ['Healing Wave']            = {['icon'] = [[Interface\Icons\Spell_nature_healingwavegreater]], ['casttime'] = 2.5},
        ['Lesser Healing Wave']     = {['icon'] = [[Interface\Icons\Spell_nature_healingwavelesser]], ['casttime'] = 1.5},
        ['Lightning Bolt']          = {['icon'] = [[Interface\Icons\Spell_nature_lightning]], ['casttime'] = 3, ['type'] = 'dmg', ['school'] = 'nature', ['class'] = 'SHAMAN'},
            -- WARLOCK
        ['Banish']                  = {['icon'] = [[Interface\Icons\Spell_shadow_cripple]], ['casttime'] = 1.5},
        ['Create Firestone']        = {['icon'] = [[Interface\Icons\Inv_misc_gem_bloodstone_02]], ['casttime'] = 3},
        ['Create Healthstone']      = {['icon'] = [[Interface\Icons\Inv_stone_04]], ['casttime'] = 3},
        ['Create Spellstone']       = {['icon'] = [[Interface\Icons\Inv_misc_gem_sapphire_01]], ['casttime'] = 5},
        ['Create Soulstone']        = {['icon'] = [[Interface\Icons\Spell_shadow_soulgem]], ['casttime'] = 3},
--        ['Drain Life']              = {[[Interface\Icons\Spell_shadow_lifedrain02]], 5},
 --       ['Drain Mana']              = {[[Interface\Icons\Spell_shadow_siphonmana]], 5},
        ['Enslave Demon']           = {['icon'] = [[Interface\Icons\Spell_shadow_enslavedemon]], 	['casttime'] = 3},
        ['Fear']                    = {['icon'] = [[Interface\Icons\Spell_shadow_possession]], 		['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'shadow', ['class'] = 'WARLOCK'},
        ['Howl of Terror']          = {['icon'] = [[Interface\Icons\Spell_shadow_deathscream]], 	['casttime'] = 2, ['type'] = 'dmg', ['school'] = 'shadow', ['class'] = 'WARLOCK'},
        ['Immolate']                = {['icon'] = [[Interface\Icons\Spell_fire_immolation]], 		['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'fire', ['class'] = 'WARLOCK'},
        ['Inferno']                 = {['icon'] = [[Interface\Icons\Spell_fire_incinerate]], 		['casttime'] = 2},
        ['Ritual of Doom']          = {['icon'] = [[Interface\Icons\Spell_shadow_antimagicshell]], 	['casttime'] = 10},
        ['Ritual of Summoning']     = {['icon'] = [[Interface\Icons\Spell_shadow_twilight]], 		['casttime'] = 5},
        ['Searing Pain']            = {['icon'] = [[Interface\Icons\Spell_fire_soulburn]], 			['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'fire', ['class'] = 'WARLOCK'},
        ['Seduction']               = {['icon'] = [[Interface\Icons\Spell_shadow_mindsteal]], 		['casttime'] = 1.5, ['type'] = 'dmg', ['school'] = 'shadow', ['class'] = 'WARLOCK'},
        ['Shadow Bolt']             = {['icon'] = [[Interface\Icons\Spell_shadow_shadowbolt]], 		['casttime'] = 2.5, ['type'] = 'dmg', ['school'] = 'shadow', ['class'] = 'WARLOCK'},
        ['Soul Fire']               = {['icon'] = [[Interface\Icons\Spell_fire_fireball02]], 		['casttime'] = 4, ['type'] = 'dmg', ['school'] = 'fire', ['class'] = 'WARLOCK'},
        ['Summon Dreadsteed']       = {['icon'] = [[Interface\Icons\Ability_mount_dreadsteed]], 	['casttime'] = 3},
        ['Summon Felhunter']        = {['icon'] = [[Interface\Icons\Spell_shadow_summonfelhunter]], ['casttime'] = 10},
        ['Summon Felsteed']         = {['icon'] = [[Interface\Icons\Spell_nature_swiftness]], 		['casttime'] = 3},
        ['Summon Imp']              = {['icon'] = [[Interface\Icons\Spell_shadow_summonimp]], 		['casttime'] = 10},
        ['Summon Succubus']         = {['icon'] = [[Interface\Icons\Spell_shadow_summonsuccubus]], 	['casttime'] = 10},
        ['Summon Voidwalker']       = {['icon'] = [[Interface\Icons\Spell_shadow_summonvoidwalker]],['casttime'] = 10},
    }

    SPELLINFO_INTERRUPTS_TO_TRACK = {
		-- MISC
		['Inferno Effect'] = true, ['Reckless Charge'] = true,
		-- DRUID
		['Bash'] = true, ['Feral Charge Effect'] = true, ['Nature\'s Swiftness'] =  true, ['Pounce'] = true, ['Starfire Stun'] = true,
		-- HUNTER
		['Aspect of the Cheetah'] =  true, ['Aspect of the Hawk'] =  true, ['Aspect of the Monkey'] =  true, ['Freezing Trap Effect'] = true, 
		['Intimidation'] = true, ['Scatter Shot'] = true, ['Wyvern Sting'] = true,
		-- MAGE
		['Blink'] = true, ['Counterspell - Silenced'] = true, ['Fire Ward'] = true, ['Frost Ward'] = true, ['Ice Barrier'] = true, 
		['Ice Block'] = true, ['Impact'] = true, ['Mana Shield'] = true, ['Polymorph'] = true, ['Polymorph: Pig'] = true, ['Polymorph: Turtle'] = true,
		-- PALADIN
		['Divine Intervention'] = true, ['Divine Protection'] = true, ['Divine Shield'] = true, ['Hammer of Justice'] = true, 
		['Seal of the Crusader'] = true, ['Seal of Righteousness'] = true,
		-- PRIEST
		['Blackout'] = true, ['Inner Fire'] = true, ['Psychic Scream'] = true,   ['Silence'] = true,
		-- ROGUE
		['Blind'] = true, ['Gouge'] = true, ['Kidney Shot'] = true, ['Kick'] = true, ['Kick - Silenced'] = true,
		-- SHAMAN
		['Earth Shock'] = true, ['Elemental Mastery'] =  true, ['Ghost Wolf'] = true, ['Lightning Shield'] = true, ['Nature\'s Swiftness'] =  true,
		-- WARLOCK
		['Death Coil'] = true, ['Fear'] = true, ['Shadow Ward'] = true, ['Spell Lock'] = true, 
		-- WARRIOR
		['Charge Stun'] = true, ['Concussion Blow'] = true, ['Intercept Stun'] = true, ['Intimidating Shout'] = true, ['Mace Stun Effect'] = true, 
		['Pummel'] = true, ['Revenge Stun'] = true,	['Shield Bash'] = true, ['Shield Bash - Silenced'] = true,    
    }
	
	-- minus .5 seconds to channeling tracked after the 1st tick 
	SPELLINFO_CHANNELED_HEALS_SPELLCASTS_TO_TRACK = {
		-- DRUID
		['Tranquility']           	= {['icon'] = [[Interface\Icons\Spell_nature_tranquility]], ['casttime'] = 10, ['tick'] = 2},
		-- FIRST AID
		['First Aid']           	= {['icon'] = [[Interface\Icons\Spell_holy_heal]], 			['casttime'] = 6, },--['tick'] = 1},
		-- WARLOCK
		['Health Funnel']           = {['icon'] = [[Interface\Icons\Spell_shadow_lifedrain]], 	['casttime'] = 10, 	['tick'] = 1},		
	}

	SPELLINFO_CHANNELED_SPELLCASTS_TO_TRACK = {
		-- MISC
		['Fishing']					= {['icon'] = [[Interface\Icons\Trade_Fishing]], ['casttime'] = 30},
		
		-- DRUID
		['Hurricane']				= {['icon'] = [[Interface\Icons\Spell_nature_cyclone]], ['casttime'] = 9.5, ['tick'] = 1},
		
		-- HUNTER
		['Eagle Eye']      			= {['icon'] = [[Interface\Icons\Ability_hunter_eagleeye]], ['casttime'] = 60},
		['Eyes of the Beast']       = {['icon'] = [[Interface\Icons\Ability_eyeoftheowl]], ['casttime'] = 60}, 
		
		-- MAGE
		['Arcane Missile']         	= {['icon'] = [[Interface\Icons\Spell_nature_starfall]], ['casttime'] = 2.5},
		['Arcane Missiles']         = {['icon'] = [[Interface\Icons\Spell_nature_starfall]], ['casttime'] = 4.5},
		['Blizzard']                = {['icon'] = [[Interface\Icons\Spell_frost_icestorm]], ['casttime'] = 7.5, ['tick'] = 1},
		['Evocation']               = {['icon'] = [[Interface\Icons\Spell_nature_purge]], ['casttime'] = 8},
		
		-- PRIEST
		['Mind Flay']   	       	= {['icon'] = [[Interface\Icons\Spell_shadow_siphonmana]], ['casttime'] = 2.5, ['tick'] = 1},
		['Mind Vision']             = {['icon'] = [[Interface\Icons\Spell_holy_mindvision]], ['casttime'] = 30},
		
		-- WARLOCK
		['Drain Life']              = {['icon'] = [[Interface\Icons\Spell_shadow_lifedrain02]], ['casttime'] = 4.5, ['tick'] = 1},
        ['Drain Mana']              = {['icon'] = [[Interface\Icons\Spell_shadow_siphonmana]], ['casttime'] = 4.5, ['tick'] = 1},
		['Drain Soul']            	= {['icon'] = [[Interface\Icons\Spell_shadow_haunting]], ['casttime'] = 14.5, ['tick'] = 3},
		['Rain of Fire']            = {['icon'] = [[Interface\Icons\Spell_shadow_rainoffire]], ['casttime'] = 7.5, ['tick'] = 2},		

	}
	
	SPELLINFO_INSTANT_SPELLCASTS_TO_TRACK = {
		-- MISC
		['Shoot']				= true,
		-- DRUID
		['Moonfire'] 			= true,
		
		-- MAGE
		['Arcane Explosion'] 	= true,
		['Cone of Cold'] 		= true,
		['Fire Blast'] 			= true,
		['Frost Nova'] 			= true,
		
		-- PRIEST
		['Holy Nova'] 			= true,
		
		-- SHAMAN
		['Earth Shock'] 		= true,
		['Flame Shock'] 		= true,
		['Frost Shock'] 		= true,
		
		-- WARLOCK
		['Shadowburn'] 			= true,
	}
	
	SPELLINFO_TIME_MODIFIER_BUFFS_TO_TRACK = {
		['Barkskin']					= {['mod'] = 1.4, 	['list'] = {'all'}},
		['Curse of Tongues'] 			= {['mod'] = 1.6, 	['list'] = {'all'}},
		
		['Curse of the Eye'] 			= {['mod'] = 1.2, 	['list'] = {'all'}},
		
		['Mind-numbing Poison'] 		= {['mod'] = 1.6, 	['list'] = {'all'}},
		
		['Fang of the Crystal Spider'] 	= {['mod'] = 1.1, 	['list'] = {'all'}},
		
		["Nature's Swiftness"] 			= {['mod'] = 0.1, 	['list'] = {'Chain Heal', 'Far Sight', 'Ghost Wolf', 'Healing Wave', 'Lesser Healing Wave', 'Lightning Bolt',   -- shaman
															'Entangling Roots', 'Healing Touch', 'Hibernate', 'Rebirth', 'Regrowth', 'Soothe Animal', 'Wrath'}}, -- druid
								  
		['Rapid Fire']					= {['mod'] = .6, 	['list'] = {'Aimed Shot'}},
		['Shadow Trance'] 				= {['mod'] = 0.1, 	['list'] = {'Shadow Bolt'}},
		['Fel Domination']				= {['mod'] = 0.05, 	['list'] = {'Summon Felhunter', 'Summon Imp', 'Summon Succubus', 'Summon Voidwalker'}},
		
		['Presence of Mind'] 			= {['mod'] = 0.1, 	['list'] = {'Fireball', 'Frostbolt', 'Pyroblast', 'Scorch', 'Polymorph'}},
		['Mind Quickening']				= {['mod'] = 0.66, 	['list'] = {'Fireball', 'Frostbolt', 'Pyroblast', 'Scorch', 'Polymorph'}},		
	}
	
	SPELLINFO_BUFFS_TO_TRACK = {
	
        -- MISC
    	['Free Action Potion']     	= {['icon'] = [[Interface\Icons\Inv_potion_04]], 					['duration'] = 30, 	['type'] = 'magic'},
		['Invulnerability']        	= {['icon'] = [[Interface\Icons\Spell_holy_divineintervention]], 	['duration'] = 6, 	['type'] = 'magic',		['prio'] = 4},
		["Reckless Charge"] 		= {['icon'] = [[Interface\Icons\Spell_nature_astralrecal]], 		['duration'] = 12, 	['type'] = 'magic', 	['prio'] = 3},
		["Sleep"] 					= {['icon'] = [[Interface\Icons\Spell_nature_sleep]], 				['duration'] = 12, 	['type'] = 'magic', 	['prio'] = 3},
    	['Will of the Forsaken']   	= {['icon'] = [[Interface\Icons\Spell_shadow_raisedead]], 			['duration'] = 5},
    	
            -- ENGINEERING
		["Flash Bomb"] 				= {['icon'] = [[Interface\Icons\Spell_Shadow_Darksummoning]], 		['duration'] = 10, 	['prio'] = 2},
		['Fire Reflector']         	= {['icon'] = [[Interface\Icons\Spell_fire_sealoffire]], 			['duration'] = 5},
        ['Frost Reflector']        	= {['icon'] = [[Interface\Icons\Spell_frost_frostward]], 			['duration'] = 5},        
        ['Shadow Reflector']       	= {['icon'] = [[Interface\Icons\Spell_shadow_antishadow]], 			['duration'] = 5},
		
            -- DRUID
    	['Abolish Poison']         	= {['icon'] = [[Interface\Icons\Spell_nature_nullifypoison_02]],	['duration'] = 8,	['type'] = 'magic' },
		['Barkskin']				= {['icon'] = [[Interface\Icons\Spell_nature_stoneclawtotem]],		['duration'] = 15,	['type'] = 'magic', 	['prio'] = 2},
		["Entangling Roots"] 		= {['icon'] = [[Interface\Icons\Spell_nature_stranglevines]], 		['duration'] = 12, 	['type'] = 'magic', 	['prio'] = 1, 	['dr'] = 'Controlled Root'},
		["Hibernate"] 				= {['icon'] = [[Interface\Icons\Spell_nature_sleep]], 				['duration'] = 20, 	['type'] = 'magic', 	['prio'] = 3},
		['Innervate'] 				= {['icon'] = [[Interface\Icons\Spell_nature_lightning]], 			['duration'] = 20, 	['type'] = 'magic', 	['prio'] = 2},
    	['Nature\'s Grasp']        	= {['icon'] = [[Interface\Icons\Spell_nature_natureswrath]], 		['type'] = 'magic', ['duration'] = 45},
		
		--[[	HUNTER 	]]--
		['Scatter Shot']			= {['icon'] = [[Interface\Icons\Ability_golemstormbolt]],			['duration'] = 4, 	['type'] = 'physical',	['prio'] = 2},
		["Scare Beast"] 			= {['icon'] = [[Interface\Icons\Ability_druid_cower]], 				['duration'] = 10, 	['type'] = 'magic', 	['prio'] = 2, 	['dr'] = 'Fear'},
		["Freezing Trap Effect"] 	= {['icon'] = [[Interface\Icons\Spell_frost_chainsofice]], 			['duration'] = 10, 	['type'] = 'magic',		['prio'] = 3},
		['Viper Sting']				= {['icon'] = [[Interface\Icons\Ability_hunter_aimedshot]], 		['duration'] = 8, 	['type'] = 'poison', 	['prio'] = 1},
		
            -- MAGE
		['Clearcasting']			= {['icon'] = [[Interface\Icons\Spell_frost_manaburn]], 			['duration'] = 15,  ['type'] = 'magic', 	['prio'] = 1},
		['Counterspell - Silenced'] = {['icon'] = [[Interface\Icons\Spell_frost_iceshock]], 			['duration'] = 4,  	['type'] = 'magic', 	['prio'] = 2},
		["Cone of Cold"] 			= {['icon'] = [[Interface\Icons\Spell_frost_glacier]], 				['duration'] = 10, 	['type'] = 'magic',		['display'] = false,},
		--["Chilled"] 				= {['icon'] = [[Interface\Icons\Spell_frost_frostarmor02]], 		['duration'] = 7, 	['type'] = 'magic', 	['prio'] = 1},
		["Frostbite"] 				= {['icon'] = [[Interface\Icons\Spell_frost_frostarmor]], 			['duration'] = 5, 	['type'] = 'magic', 	['prio'] = 1},
		["Frost Nova"] 				= {['icon'] = [[Interface\Icons\Spell_frost_frostnova]], 			['duration'] = 8, 	['type'] = 'magic', 	['prio'] = 1, 	['dr'] = 'Controlled Root'},
    	['Frost Ward']             	= {['icon'] = [[Interface\Icons\Spell_frost_frostward]], 			['duration'] = 30, 	['type'] = 'magic'},
		['Frostbolt']				= {['icon'] = [[Interface\Icons\Spell_frost_frostbolt02]], 			['duration'] = 10, 	['type'] = 'magic',		['display'] = false,},
    	['Fire Ward']              	= {['icon'] = [[Interface\Icons\Spell_fire_firearmor]], 			['duration'] = 30, 	['type'] = 'magic'},
		--['Ice Barrier']				= {['icon'] = [[Interface\Icons\Spell_ice_lament]], 				['duration'] = 60, 	['type'] = 'magic'},
    	['Ice Block']              	= {['icon'] = [[Interface\Icons\Spell_frost_frost]], 				['duration'] = 10, 	['prio'] = 4},
		["Polymorph"] 				= {['icon'] = [[Interface\Icons\Spell_nature_polymorph]], 			['duration'] = 11, 	['type'] = 'magic', 	['prio'] = 3, 	['dr'] = 'Disorient'},
		['Polymorph: Pig']          = {['icon'] = [[Interface\Icons\Spell_magic_polymorphpig]], 		['duration'] = 11, 	['type'] = 'magic', 	['prio'] = 3, 	['dr'] = 'Disorient'},
		['Polymorph: Turtle']       = {['icon'] = [[Interface\Icons\Ability_hunter_pet_turtle]],		['duration'] = 11, 	['type'] = 'magic', 	['prio'] = 3, 	['dr'] = 'Disorient'},
		['Winter\'s Chill']			= {['icon'] = [[Interface\Icons\Spell_frost_chillingblast]], 		['duration'] = 15, 	['type'] = 'magic', 	['display'] = false,},
		
            -- PALADIN
    	['Blessing of Protection'] 	= {['icon'] = [[Interface\Icons\Spell_holy_sealofprotection]], 		['duration'] = 8, 	['type'] = 'magic', 	['prio'] = 2},
    	['Blessing of Freedom']    	= {['icon'] = [[Interface\Icons\Spell_holy_sealofvalor]], 			['duration'] = 10, 	['type'] = 'magic'},
    	['Divine Protection']      	= {['icon'] = [[Interface\Icons\Spell_holy_restoration]], 			['duration'] = 8, 	['prio'] = 4},
		['Divine Shield']			= {['icon'] = [[Interface\Icons\Spell_holy_divineintervention]], 	['duration'] = 10, 	['prio'] = 4},
		["Hammer of Justice"] 		= {['icon'] = [[Interface\Icons\Spell_holy_sealofmight]], 			['duration'] = 4, 	['type'] = 'magic',		['dr'] = 'Controlled Stun'},
		
            -- PRIEST
    	['Power Word: Shield']    	= {['icon'] = [[Interface\Icons\Spell_holy_powerwordshield]], 		['duration'] = 30, 	['type'] = 'magic'},
		["Psychic Scream"] 			= {['icon'] = [[Interface\Icons\Spell_shadow_psychicscream]], 		['duration'] = 8, 	['type'] = 'magic', 	['prio'] = 1, 	['dr'] = 'Fear'},
		['Silence']					= {['icon'] = [[Interface\Icons\Spell_shadow_impphaseshift]], 		['duration'] = 5, 	['type'] = 'magic', 	['prio'] = 1},
		
		--[[	ROGUE 	]]--
		['Blind']					= {['icon'] = [[Interface\Icons\Spell_shadow_mindsteal]],			['duration'] = 10,	['type'] = 'poison',	['prio'] = 3},
		["Cheap Shot"] 				= {['icon'] = [[Interface\Icons\Ability_cheapshot]], 				['duration'] = 4, 	['type'] = 'physical', 	['prio'] = 1},
		["Gouge"] 					= {['icon'] = [[Interface\Icons\Ability_gouge]], 					['duration'] = 5, 	['type'] = 'physical', 	['prio'] = 2, 	['dr'] = 'Disorient'},
		['Kick - Silenced'] 		= {['icon'] = [[Interface\Icons\Ability_kick]], 					['duration'] = 2, 	['type'] = 'physical', 	['prio'] = 1},
		["Sap"] 					= {['icon'] = [[Interface\Icons\Ability_sap]], 						['duration'] = 11, 	['type'] = 'physical', 	['prio'] = 3, 	['dr'] = 'Disorient'},
		['Sprint']					= {['icon'] = [[Interface\Icons\Ability_rogue_sprint]],				['duration'] = 15,							['prio'] = 1},
		
			-- SHAMAN
		['Frost Shock']				= {['icon'] = [[Interface\Icons\Spell_frost_frostshock]],			['duration'] = 8,	['type'] = 'magic',		['prio'] = 1, 	['dr'] = 'Frost Shock'},
		
		     -- WARLOCK
		['Death Coil']				= {['icon'] = [[Interface\Icons\Spell_shadow_deathcoil]],			['duration'] = 3,	['type'] = 'magic',		['prio'] = 1},
		["Fear"] 					= {['icon'] = [[Interface\Icons\Spell_shadow_possession]], 			['duration'] = 10, 	['type'] = 'magic', 	['prio'] = 2, 	['dr'] = 'Fear'},
		['Seduction']				= {['icon'] = [[Interface\Icons\Spell_shadow_mindsteal]],			['duration'] = 10, 	['type'] = 'magic', 	['prio'] = 3, 	['dr'] = 'Fear'},
    	['Shadow Trance'] 			= {['icon'] = [[Interface\Icons\Spell_shadow_twilight]], 			['duration'] = 10, 	['type'] = 'magic'},
		
		--[[	WARRRIOR 	]]--
		['Berserker Rage']			= {['icon'] = [[Interface\Icons\Spell_nature_ancestralguardian]],	['duration'] = 10,							['prio'] = 1},
		["Disarm"] 					= {['icon'] = [[Interface\Icons\Ability_warrior_disarm]], 			['duration'] = 8, 	['type'] = 'physical', 	['prio'] = 1},
		["Hamstring"] 				= {['icon'] = [[Interface\Icons\Ability_shockwave]], 				['duration'] = 15, 	['type'] = 'physical', 	['prio'] = 1},		
		['Intimidating Shout']		= {['icon'] = [[Interface\Icons\Ability_golemthunderclap]], 		['duration'] = 8, 	['type'] = 'physical', 	['prio'] = 2, 	['dr'] = 'Fear'},
		['Mortal Strike'] 			= {['icon'] = [[Interface\Icons\Ability_warrior_savageblow]], 		['duration'] = 10, 	['type'] = 'physical'},

    }
    
	SPELLINFO_WSG_FLAGS = {
		['Alliance'] 	= {['icon'] = [[Interface\Icons\inv_bannerpvp_02]]},
		['Horde'] 		= {['icon'] = [[Interface\Icons\inv_bannerpvp_01]]},
	}
	
	-- used to check if mouseover cast should be aimed at mouseover target
	SPELLINFO_SINGLE_TARGET_BUFF_SPELLS = {
		-- DRUID
		['Abolish Poison'] = true, 	['Cure Poison'] = true, 	['Healing Touch'] = true, ['Mark of the Wild'] = true, ['Rebirth'] = true, 
		['Regrowth'] = true,		['Rejuvenation'] = true, 	['Remove Curse'] = true,
		
		-- MAGE
		['Amplify Magic'] = true, ['Arcane Intellect'] = true, ['Dampen Magic'] = true, ['Remove Lesser Curse'] = true, 
		
		-- PALADIN
		['Blessing of Protection'] = true, 	['Blessing of Freedom'] = true, 	['Blessing of Kings'] = true, 	['Blessing of Might'] = true, 
		['Blessing of Sanctuary'] = true,	['Blessing of Sacrifice'] = true,	['Blessing of Wisdom'] = true, 	['Cleanse'] = true, 
		['Divine Intervention'] = true, 	['Flash of Light'] = true, 			['Holy Light'] = true, 			['Lay on Hands'] = true, 
		['Purify'] = true, 
		
		-- PRIEST
		['Cure Disease'] = true, 		['Divine Spirit'] = true, 	['Greater Heal'] = true, 	['Fear Ward'] = true, ['Flash Heal'] = true, 
		['Heal'] = true, 				['Lesser Heal'] = true, 	['Power Infusion'] = true, 	['Power Word: Fortitude'] = true,	
		['Power Word: Shield'] = true, 	['Renew'] = true, 			['Shadow Protection'] = true,
		
		-- SHAMAN
		['Chain Heal'] = true, ['Healing Wave'] = true, ['Lesser Healing Wave'] = true,
	}
	
	SPELLINFO_DEBUFF_REFRESHING_SPELLS = {
		-- MAGE
		['Fireball'] 		=  {'Fireball', },		
		['Blizzard'] 		= {'Winter\'s Chill',},
		['Cone of Cold'] 	= {'Winter\'s Chill',},
		['Frost Nova'] 		= {'Winter\'s Chill',},
		['Frostbolt'] 		= {'Frostbolt', 'Winter\'s Chill',},
		-- WARRRIOR
		['Hamstring']		= {'Hamstring',},
		['Mortal Strike']	= {'Mortal Strike',},
	}
	--
