local L

--------------
--  Onyxia  --
--------------
L = DBM:GetModLocalization("Onyxia")

L:SetGeneralLocalization{
	name = "Onyxia"
}

L:SetWarningLocalization{
    WarnWhelpsSoon		= "Onyxian Whelps soon",
	WarnPhase2Soon		= "Phase 2 soon",
	WarnPhase3Soon		= "Phase 3 soon"
}

L:SetTimerLocalization{
	TimerWhelpsSoon			= "Onyxian Whelps"
}

L:SetOptionLocalization{
    WarnWhelpsSoon			= "Show pre-warning for Onyxian Whelps",
	WarnWhelps				="Show warning for Onyxian Whelps spawning",
	SoundWTF				= "Play some funny sounds from a legendary classic Onyxia raid",
	WarnPhase2Soon			= "Show pre-warning for Phase 2 (at ~90%)",
	WarnPhase3Soon			= "Show pre-warning for Phase 3 (at ~40%)",
	FireballMark		 	= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(2105161)
}

L:SetMiscLocalization{
	YellP2 			= "This meaningless exertion bores me. I'll incinerate you all from above!",
	YellP3 			= "It seems you'll need another lesson, mortals!",
	EmoteDeepBreath = "%s takes in a deep breath..."
}

