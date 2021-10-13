local L

--------------
--  Onyxia  --
--------------
L = DBM:GetModLocalization("Onyxia")

L:SetGeneralLocalization{
	name = "Onyxia"
}

L:SetWarningLocalization{
--  WarnWhelpsSoon		= "Onyxian Whelps soon",
	WarnPhase2Soon		= "Phase 2 soon",
	WarnPhase3Soon		= "Phase 3 soon",
	WarnGuardSpawn		= "Onyxian Lair Guard spawned",
	WarnWhelps			= "Onyxian Whelps spawned"
}

L:SetTimerLocalization{
	TimerWhelps			= "Onyxian Whelps",
	TimerGuardSpawn 	= "Lair Guard",
}

L:SetOptionLocalization{
	TimerWhelps				= "Show timer for Onyxian Whelps",
	TimerGuardSpawn			= "Show timer for Onyxian Lair Guards spawning",
--  WarnWhelpsSoon			= "Show pre-warning for Onyxian Whelps",
	WarnWhelps				="Show warning for Onyxian Whelps spawning",
	SoundWTF				= "Play some funny sounds from a legendary classic Onyxia raid",
	WarnPhase2Soon			= "Show pre-warning for Phase 2 (at ~67%)",
	WarnPhase3Soon			= "Show pre-warning for Phase 3 (at ~41%)",
	FireballMark		 		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(2105160),
}

L:SetMiscLocalization{
	YellP2 = "This meaningless exertion bores me. I'll incinerate you all from above!",
	YellP3 = "It seems you'll need another lesson, mortals!"
}

