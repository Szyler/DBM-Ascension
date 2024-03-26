local L

----------------
--  Lucifron  --
----------------
L = DBM:GetModLocalization("Lucifron")

L:SetGeneralLocalization{
	name = "Lucifron"
}

----------------
--  Magmadar  --
----------------
L = DBM:GetModLocalization("Magmadar")

L:SetGeneralLocalization{
	name = "Magmadar"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    lavaBombYellOpt           = "Yell when you are affected by $spell:2105054"
}

L:SetMiscLocalization{
    lavaBombYell			    = "Lava Bomb on me!",
}

----------------
--  Gehennas  --
----------------
L = DBM:GetModLocalization("Gehennas")

L:SetGeneralLocalization{
	name = "Gehennas"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    CaveinYellOpt           = "Yell when you are affected by $spell:20277"
}

L:SetMiscLocalization{
    RainYell			    = "Rain of Fire on me!",
}

------------
--  Garr  --
------------
L = DBM:GetModLocalization("Garr")

L:SetGeneralLocalization{
	name = "Garr"
}

--------------
--  Geddon  --
--------------
L = DBM:GetModLocalization("Geddon")

L:SetGeneralLocalization{
	name = "Baron Geddon"
}

L:SetOptionLocalization{
	SetIconOnBombTarget	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(20475)
}

----------------
--  Shazzrah  --
----------------
L = DBM:GetModLocalization("Shazzrah")

L:SetGeneralLocalization{
	name = "Shazzrah"
}

----------------
--  Sulfuron  --
----------------
L = DBM:GetModLocalization("Sulfuron")

L:SetGeneralLocalization{
	name = "Sulfuron Harbringer"
}

----------------
--  Golemagg  --
----------------
L = DBM:GetModLocalization("Golemagg")

L:SetGeneralLocalization{
	name 					= "Golemagg the Incinerator"
}
L:SetWarningLocalization{
	WarnP2Soon				= "Phase 2 soon"
}
L:SetOptionLocalization{
	WarnP2Soon 				= "Warn when phase 2 is about to start",
	CaveinYellOpt           = "Yell when you are affected by $spell:36240"
}
L:SetMiscLocalization{
	CaveinYell			    = "Cave in on me!",
}

-----------------
--  Majordomo  --
-----------------
L = DBM:GetModLocalization("Majordomo")

L:SetGeneralLocalization{
	name = "Majordomo Executus"
}

L:SetMiscLocalization{
	Kill	= "Impossible! Stay your attack, mortals... I submit! I submit!"
}

----------------
--  Ragnaros  --
----------------
L = DBM:GetModLocalization("Ragnaros")

L:SetGeneralLocalization{
	name = "Ragnaros"
}
L:SetWarningLocalization{
	WarnSubmerge		= "Submerge",
	WarnSubmergeSoon	= "Submerge soon",
	WarnEmerge			= "Emerge",
	WarnEmergeSoon		= "EmergeSoon",
	RagFire				= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
}
L:SetTimerLocalization{
	TimerCombatStart	= "Combat starts",
	TimerSubmerge		= "Submerge",
	TimerEmerge			= "Emerge"
}
L:SetOptionLocalization{
	TimerCombatStart	= "Show time for start of combat",
	WarnSubmerge		= "Show warning for submerge",
	WarnSubmergeSoon	= "Show pre-warning for submerge",
	TimerSubmerge		= "Show timer for submerge",
	WarnEmerge			= "Show warning for emerge",
	WarnEmergeSoon		= "Show pre-warning for emerge",
	TimerEmerge			= "Show timer for emerge",
	RagFire				= "Show $spell:85178 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)
}
L:SetMiscLocalization{
	Submerge	= "COME FORTH, MY SERVANTS! DEFEND YOUR MASTER!",
	Pull		= "Behold Ragnaros - the Firelord! He who was ancient when this world was young! Bow before him, mortals! Bow before your ending!"
}


L:SetWarningLocalization{
}

L:SetOptionLocalization{
}