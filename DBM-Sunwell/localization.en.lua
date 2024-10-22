local L

---------------
--  Kalecgos --
---------------
L = DBM:GetModLocalization("Kalecgos")

L:SetGeneralLocalization{
	name = "Kalecgos"
}

L:SetWarningLocalization{
	WarnPortal			= "Portal #%d : >%s< (Group %d)",
	SpecWarnWildMagic	= "Wild Magic - %s!"
}

L:SetOptionLocalization{
	WarnPortal			= "Show warning for $spell:46021 target",
	SpecWarnWildMagic	= "Show special warning for Wild Magic",
	ShowFrame			= "Show Spectral Realm frame" ,
	FrameClassColor		= "Use class colors in Spectral Realm frame",
	FrameUpwards		= "Expand Spectral Realm frame upwards",
	FrameLocked			= "Set Spectral Realm frame not movable",
	RangeFrame			= "Show range check frame"
}

L:SetMiscLocalization{
	Demon				= "Sathrovarr the Corruptor",
	Heal				= "Healing + 100%",
	Haste				= "Spell Haste + 100%",
	Hit					= "Melee Hit - 50%",
	Crit				= "Crit Damage + 100%",
	Aggro				= "AGGRO + 100%",
	Mana				= "Cost Reduce 50%",
	FrameTitle			= "Spectral Realm",
	FrameLock			= "Frame Lock",
	FrameClassColor		= "Use Class Colors",
	FrameOrientation	= "Expand upwards",
	FrameHide			= "Hide Frame",
	FrameClose			= "Close"
}

----------------
--  Brutallus --
----------------
L = DBM:GetModLocalization("Brutallus")

L:SetGeneralLocalization{
	name = "Brutallus"
}
L:SetOptionLocalization{
    -- felFireYellOpt       = "Yell when you are affected by $spell:2145719"
}
L:SetMiscLocalization{
	BrutPull			= "Ah, more lambs to the slaughter!",
	-- felFireYellYell		= "$spell:2145719 on "..UnitName("PLAYER").."!"
}

--------------
--  Felmyst --
--------------
L = DBM:GetModLocalization("Felmyst")

L:SetGeneralLocalization{
	name = "Felmyst"
}

L:SetWarningLocalization{
	WarnPhase		= "%s Phase"
}

L:SetTimerLocalization{
	TimerPhase		= "Next %s Phase"
}

L:SetOptionLocalization{
	WarnPhase		= "Show warning for next phase",
	TimerPhase		= "Show time for next phase",
	VaporIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(45392),
	EncapsIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(45665)
}

L:SetMiscLocalization{
	Air				= "Air",
	Ground			= "Ground",
	AirPhase		= "I am stronger than ever before!",
	Breath			= "%s takes a deep breath."
}

--------------
--  High Commander Arynyes --
--------------
L = DBM:GetModLocalization("Arynyes")

L:SetGeneralLocalization({
	name = "High Commander Arynyes"
})

L:SetWarningLocalization({

})

L:SetTimerLocalization({

})

L:SetOptionLocalization({

})

L:SetMiscLocalization({
	GauntletPull		= "Man the cannons, summoners; bring forth the imps!",
	ArynPull			= "I will not fail!"
})

-----------------------
--  The Eredar Twins --
-----------------------
L = DBM:GetModLocalization("Twins")

L:SetGeneralLocalization{
	name = "Eredar Twins"
}

L:SetWarningLocalization{
	WarnLunarStacks				= "%s stacks: (%d)",--(args.spellName, args.destName, args.amount or 1)
	WarnSolarStacks				= "%s stacks: (%d)"
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	NovaIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(45329),
	ConflagIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(45333),
	RangeFrame		= "Show range check frame"
}

L:SetMiscLocalization({
	Nova						= "directs Shadow Nova at (.+)%.",
	Conflag						= "directs Conflagration at (.+)%.",
	Sacrolash					= "Lady Sacrolash",
	Alythess					= "Grand Warlock Alythess",
	Sacrolythess				= "Sacro'lythess",
	TwinsPull					= "Your luck has run its course!",
	SacroAbsorb					= "Alythess! Your fire burns within me!",
	AlythAbsorb					= "Sacrolash!",
	AlythPhase					= "Fires consume.",
	SacroPhase					= "Shadows engulf.",
	SacroCombo					= "Fire to the aid of shadow!",
	AlythCombo					= "Shadow to the aid of fire!",
	TwinsMerge					= "Edir harach!"
})

------------
--  M'uru --
------------
L = DBM:GetModLocalization("Muru")

L:SetGeneralLocalization{
	name = "M'uru"
}

L:SetWarningLocalization{
	WarnHuman		= "Humanoids (%d)",
	WarnVoid		= "Void Sentinel (%d)",
	WarnFiend		= "Dark Fiend spawned"
}

L:SetTimerLocalization{
	TimerHuman		= "Next Humanoids (%s)",
	TimerVoid		= "Next Void (%s)",
	TimerPhase		= "Entropius"
}

L:SetOptionLocalization{
	WarnHuman		= "Show warning for Humanoids",
	WarnVoid		= "Show warning for Void Sentinels",
	WarnFiend		= "Show warning for Fiends in phase 2",
	TimerHuman		= "Show timer for Humanoids",
	TimerVoid		= "Show timer for Void Sentinels",
	TimerPhase		= "Show time for Phase 2 transition"
}

L:SetMiscLocalization{
	Entropius		= "Entropius"
}

----------------
--  Kil'jeden --
----------------
L = DBM:GetModLocalization("Kil")

L:SetGeneralLocalization{
	name = "Kil'jaeden"
}

L:SetWarningLocalization{
	-- WarnPhaseSoon				= "Next Phase at %s percent health",
	WarnDarkOrb					= "Dark Orbs Spawned",
	WarnBlueOrb					= "Dragon Orb activated",
	SpecWarnDarkOrb				= "Dark Orbs Spawned!",
	SpecWarnBlueOrb				= "Dragon Orbs Activated!",
	WarnPhaseSoon				= "Phase %s soon",
	WarnPhase					= "Phase %s"
}

L:SetTimerLocalization{
	TimerBlueOrb				= "Dragon Orbs activate",
	TimerWorldBreaker			= "World Breaker: %s"
}

L:SetOptionLocalization{
	WarnDarkOrb					= "Show warning for Dark Orbs",
	WarnBlueOrb					= "Show warning for Dragon Orbs",
	SpecWarnDarkOrb				= "Show special warning for Dark Orbs",
	SpecWarnBlueOrb				= "Show special warning for Dragon Orbs",
	TimerBlueOrb				= "Show timer for Dragon Orbs activate"
}

L:SetMiscLocalization{
	Phase2KJ		= "The expendable have perished. So be it! Now I shall succeed where Sargeras could not! I will bleed this wretched world and secure my place as the true master of the Burning Legion! The end has come! Let the unravelling of this world commence!",
	Phase3KJ		= "Another step toward destruction!",
	Phase4KJ		= "I will not be denied! This world shall fall!",
	Phase5KJ		= "Do not harbor false hope! You cannot win!",
	Phase6KJ		= "Kalec... Kalec?",
	OrbYell1		= "I will channel my powers into the orbs! Be ready!",
	OrbYell2		= "I have empowered another orb! Use it quickly!",
	OrbYell3		= "Another orb is ready! Make haste!",
	OrbYell4		= "I have channeled all I can! The power is in your hands!",
	ConflaglMarkOpt	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(2146673)
}

----------------
--  Trash --
----------------
L = DBM:GetModLocalization("Trash")

L:SetGeneralLocalization{
	name = "Trash"
}

L:SetMiscLocalization{

}
