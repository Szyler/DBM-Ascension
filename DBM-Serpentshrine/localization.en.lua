local L

---------------------------
--  Hydross the Unstable --
---------------------------
L = DBM:GetModLocalization("Hydross")

L:SetGeneralLocalization{
	name = "Hydross the Unstable"
}

L:SetWarningLocalization{
	WarnMark 		= "%s : %s",
	WarnTidalPower	= "%s : %s",
	WarnPhase		= "%s Phase",
	SpecWarnMark	= "%s : %s"
}

L:SetTimerLocalization{
	TimerMark	= "Next %s : %s"
}

L:SetOptionLocalization{
	WarnMark		= "Show warning for Marks",
	WarnTidalPower	= "Show warning for $spell:85413",
	WarnPhase		= "Show warning for next phase",
	SpecWarnMark	= "Show warning when Marks debuff damage over 100%",
	TimerMark		= "Show timer for next Marks",
	Berserk			= "Show timer for Berserk",
}

L:SetMiscLocalization{
	Frost	= "Frost",
	Nature	= "Nature"
}

-----------------------
--  The Lurker Below --
-----------------------
L = DBM:GetModLocalization("LurkerBelow")

L:SetGeneralLocalization{
	name 				= "The Lurker Below"
}

L:SetWarningLocalization{
	WarnSubmerge		= "Submerged",
	WarnEmerge			= "Emerged",
}

L:SetTimerLocalization{
	TimerSubmerge		= "Sumberge CD",
	TimerEmerge			= "Emerge CD"
}

L:SetOptionLocalization{
	WarnSubmerge		= "Show warning when submerge",
	WarnEmerge			= "Show warning when emerge",
	TimerSubmerge		= "Show timer for submerge",
	TimerEmerge			= "Show timer for emerge",
}

L:SetMiscLocalization{
	EmoteEmerge			= "emerges from the dephts",
	EmoteSubmerge		= "submerges into the depths",
	EmoteBreath			= "takes a deep breath",
}

--------------------------
--  Leotheras the Blind --
--------------------------
L = DBM:GetModLocalization("Leotheras")

L:SetGeneralLocalization{
	name = "Leotheras the Blind"
}

L:SetWarningLocalization{
	WarnPhase		= "%s Phase"
}

L:SetTimerLocalization{
	TimerPhase	= "Next %s Phase"
}

L:SetOptionLocalization{
	WarnPhase		= "Show warning for next phase",
	TimerPhase		= "Show time for next phase",
	DemonIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(37676),
	ChaosIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(85365),
	ChaosYellOpt	= "Yell when you are about to be hit by $spell:85365"
}

L:SetMiscLocalization{
	Human		= "Human",
	Demon		= "Demon",
	YellDemon	= "Be gone, trifling elf%.%s*I am in control now!",
	YellPhase2	= "No... no! What have you done? I am the master! Do you hear me? I am... aaggh! Can't... contain him.",
	ChaosYell	= "Chaos Blast on "..UnitName("PLAYER").."!"
}

-----------------------------
--  Fathom-Lord Karathress --
-----------------------------
L = DBM:GetModLocalization("Fathomlord")

L:SetGeneralLocalization{
	name = "Fathom-Lord Karathress"
}

L:SetWarningLocalization{
	BlessingTides	= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
}

L:SetTimerLocalization{
	BlessingTides	= "Show $spell:351302 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
	Caribdis		= "Fathom-Guard Caribdis",
	Tidalvess		= "Fathom-Guard Tidalvess",
	Sharkkis		= "Fathom-Guard Sharkkis",
	BlessingTides	= "Fathom-Guard Sharkkis"
}

--------------------------
--  Morogrim Tidewalker --
--------------------------
L = DBM:GetModLocalization("Tidewalker")

L:SetGeneralLocalization{
	name = "Morogrim Tidewalker"
}

L:SetWarningLocalization{
	SpecWarnMurlocs			= "Murlocs Coming!",
	WarnRisingBubble		= "Bubbles",
	WarnWateryGlobule		= "Water Globule spawned!",
	HPLoss					= "Morogrim went down %.1f%%!"
}

L:SetTimerLocalization{
	TimerMurlocs			= "Murlocs: %s",
	TimerWateryGlobule	 	= "Next Watery Globule",
	TimerBubble	 			= "Next Bubbles",
	TimerBurst				= "Bubble Burst"
}

L:SetOptionLocalization{
	SpecWarnMurlocs		= "Show special warning when Murlocs spawning",
	TimerMurlocs		= "Show timer for Murlocs spawning",
	-- GraveIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(38049),
	HealerIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(83544),
	WarriorIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(83554),
	MageIcon			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(83551),
	WarnHealer			= "Show speciw al warning when Healer spawns",
	WarnWarrior			= "Show special warning when Warrior spawns",
	WarnMage			= "Show special warning when Mage spawns",
	WarnWateryGlobule	= "Show warning when Water Globule spawns",
	TimerWateryGlobule = "Show timer for next $spell:37854",
	WarnRisingBubble	= "Show special warning when Rising Bubble spawns",
	TimerRisingBubble	= "Show timer for when Rising Bubble spawns",
	RisingBubbleIcon	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(83561),
	HPLoss				= "Show how much damage Morogrim has taken after Bursting Bubble explodes."
}

L:SetMiscLocalization{
	WarnHealer					= "Murloc Healer spawned!",
	WarnWarrior					= "Murloc Warrior spawned!",
	WarnMage					= "Murloc Mage spawned!",
	DBM_MOROGRIM_BURSTING_SPAWN	= "A Bursting Bubble floats through the room."
}

-----------------
--  Lady Vashj --
-----------------
L = DBM:GetModLocalization("Vashj")

L:SetGeneralLocalization{
	name = "Lady Vashj"
}

L:SetWarningLocalization{
	WarnElemental		= "Tainted Elemental (%s)",
	WarnHydra			= "Hydra",
	WarnNaga			= "Naga Elite (%s)",
	WarnEnchantress		= "Enchantress",
	WarnShield			= "Shield %d/4 down",
	WarnLoot			= "Tainted Core on >%s<",
	-- WarnLootYou			= "Tainted Core on YOU",
	SpecWarnElemental	= "Tainted Elemental - Switch!",
	SpecWarnSiren		= "Coilfang Siren - Switch!",
	WarnSporebat		= "Toxic Sporebat",
	WarnPhoenix			= "Phoenix"
}

L:SetTimerLocalization{
	TimerElementalActive	= "Elemental Active",
	TimerElemental			= "Elemental CD (%d)",
	TimerHydra				= "Next Hydra (%d)",
	TimerNaga				= "Next Naga Elite (%d)",
	TimerEnchantress		= "Next Enchantress (%d)",
	ChargeExplosion			= "Charge Explosion",
	Discharge				= "Static Discharge",
	NextGenerator			= "Next Shield Generator",
	NextSporebat			= "Next Toxic Sporebat"
}

L:SetOptionLocalization{
	WarnElemental			= "Show warning for Tainted Elemental spawn",
	WarnHydra				= "Show warning for Hydra spawn",
	WarnNaga				= "Show warning for Naga Elite spawn",
	WarnEnchantress			= "Show warning for Enchantress spawn",
	WarnSporebat			= "Show warning for Toxic Sporebat spawn",
	WarnShield				= "Show warning for Phase 2 shield down",
	WarnLoot				= "Show warning for who loots the Tainted Core",
	WarnPhoenix				= "Show warning for when Phoenix will rebirth on Ascended",
	TimerElementalActive	= "Show timer for how long Tainted Elemental is active",
	TimerElemental			= "Show timer for Tainted Elemental cooldown",
	TimerHydra				= "Show timer for next Hydra",
	TimerNaga				= "Show timer for next Elite",
	TimerEnchantress		= "Show timer for next Enchantress",
	SpecWarnElemental		= "Show special warning when Tainted Elemental coming",
	-- ChargeIcon				= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(38280),
	AimedIcon				= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(351310),
	ChargeYellOpt         	= "Yell when you are affected by $spell:38280",
	AimedYellOpt        	= "Yell when you are affected by $spell:351310",
	LootIcon				= "Set icon on the target carrying Tainted Core",
	LootYellOpt        		= "Yell when you are carrying Tainted Core",
	AutoChangeLootToFFA		= "Switch loot mode to Free for All in Phase 2",
	SpecWarnSiren			= "Show special warning for when Coilfang Siren spawns",
	Discharge				= "Show timer for when Shield Generator will deal its damage",
	NextGenerator			= "Show timer for when Shield Generator activates in Phase 3",
	ChargeExplosion			= "Show timer for Charge Explosion",
	NextSporebat			= "Show timer for when next Toxic Sporebat will spawn in Phase 3"
}

L:SetMiscLocalization{
	DBM_VASHJ_YELL_PHASE2	= "The time is now! Leave none standing!",
	DBM_VASHJ_YELL_PHASE3	= "You may want to take cover.",
	DBM_VASHJ_DISCHARGE		= "The air crackles with electricity!",
	DBM_VASHJ_ELITE			= "Coilfang Elite appear to protect the Matron!",
	DBM_VASHJ_HYDRA			= "A Coilfang Hydra joins the fight!",
	DBM_VASHJ_TAINTED		= "A Tainted Elemental emerged from the waters!",
	DBM_VASHJ_TAINTED_DEAD	= "The Tainted Elemental has been slain! Quickly use its core to shut down the Shield Generator!",
	LootMsg					= "([^%s]+).*Hitem:(%d+)",
	ChargeYell				= "Static Charge on me!",
	AimedYell				= "Aimed Shot on me!",
	LootYell				= "I am carrying the Tainted Core!",
}
