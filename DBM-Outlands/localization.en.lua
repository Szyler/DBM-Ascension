local L

DBMGUI_TAB_OTHER_BC	= "Outlands" -- do not translate

-- LordKazzak
L = DBM:GetModLocalization("Kazzak")

L:SetGeneralLocalization{
	name = "Doom Lord Kazzak"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
    KazzakIcon				    = DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(32960),
    KazzakWhisper			    = "Whisper the target of Mark of Kazzak to keep their mana up (Only for Assist/RaidLead)"
}

L:SetMiscLocalization{
    DBM_KAZZAK_MARK_SPEC_WARN	= "You have the Mark of Kazzak, keep your mana up, or we die!";
}





DBM_KAZZAK_NAME				= "Doom Lord Kazzak";
DBM_KAZZAK_DESCRIPTION		= "Announces Enrage, Mark of Kazzak and Twisted Reflection.";
DBM_KAZZAK_OPTION_1			= "Announce Enrage";
DBM_KAZZAK_OPTION_2			= "Announce Twisted Reflection";
DBM_KAZZAK_OPTION_3			= "Announce Mark of Kazzak";
DBM_KAZZAK_OPTION_4			= "Set icon";
DBM_KAZZAK_OPTION_5			= "Send whisper";

DBM_KAZZAK_YELL_PULL		= "All mortals will perish!";
DBM_KAZZAK_YELL_PULL2		= "The Legion will conquer all!";
DBM_KAZZAK_EMOTE_ENRAGE		= "%s becomes enraged!";

DBM_KAZZAK_SUP_SEC			= "*** Enrage in %s sec ***";
DBM_KAZZAK_SUP_SOON			= "*** Enrage soon ***";
DBM_KAZZAK_TWISTED_WARN		= "*** Twisted Reflection on >%s< ***";
DBM_KAZZAK_MARK_WARN		= "*** Mark of Kazzak on >%s< ***";
DBM_KAZZAK_WARN_ENRAGE		= "*** Enrage ***";


-- Doomwalker
DBM_DOOMW_NAME			= "Doomwalker";
DBM_DOOMW_DESCRIPTION	= "Shows a timer for Earthquake.";
DBM_DOOMW_OPTION_1		= "Show range check frame";
DBM_DOOMW_OPTION_2		= "Announce Earthquake";
DBM_DOOMW_OPTION_3		= "Announce Overrun";

DBM_DOOMW_EMOTE_ENRAGE	= "%s becomes enraged!";

DBM_DOOMW_QUAKE_WARN	= "*** Earthquake ***";
DBM_DOOMW_QUAKE_SOON	= "*** Earthquake soon ***";
DBM_DOOMW_CHARGE		= "*** Overrun ***";
DBM_DOOMW_CHARGE_SOON	= "*** Overrun soon ***";
DBM_DOOMW_WARN_ENRAGE	= "*** Enrage ***";