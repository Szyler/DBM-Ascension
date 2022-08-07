local L

DBMGUI_TAB_OTHER_BC	= "Outlands" -- do not translate

-- Magtheridon
DBM_MAG_NAME			= "Magtheridon";
DBM_MAG_DESCRIPTION		= "Announces Infernals and Dark Mending and shows timers for Phase 2 and Blast Nova.";
DBM_MAG_OPTION_1		= "Announce Infernals";
DBM_MAG_OPTION_2		= "Announce Heal";
DBM_MAG_OPTION_3		= "Announce Blast Nova";
DBM_MAG_OPTION_4		= "Announce Quake";
DBM_MAG_OPTION_5		= "Announce Blast Nova that happens before Quake";

DBM_MAG_EMOTE_PULL		= "%s is nearly free of his bonds!";

DBM_MAG_EMOTE_NOVA		= "%s begins to cast Blast Nova!";

DBM_MAG_PHASE2_WARN		= "*** Phase 2 in %s sec ***";
DBM_MAG_WARN_P2			= "*** Magtheridon is free ***";
DBM_MAG_EMOTE_P2		= "Maghteridon breaks free!";
DBM_MAG_WARN_P3			= "*** Phase 3 incoming!";

DBM_MAG_WARN_INFERNAL	= "*** Infernal ***";
DBM_MAG_WARN_HEAL		= "*** Heal ***";
DBM_MAG_WARN_NOVA_NOW	= "*** Blast Nova ***";
DBM_MAG_WARN_NOVA_SOON	= "Get ready for Blast Nova!";
DBM_MAG_WARN_QUAKE		= "*** Quake ***";
PreQuakeNova			= "*** PRE-QUAKE BLAST NOVA ***";

--Magtheridon
L = DBM:GetModLocalization("Magtheridon")

L:SetGeneralLocalization{
	name = "Magtheridon"
}

L:SetTimerLocalization{
	TimerFingers			= "Next Finger of Death",
	TimerHands	 			= "Next Hand of Death",
	TimerRoofCollapsing		= "Roof is collapsing"
}
L:SetWarningLocalization{
	MagCleave				= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
}

L:SetOptionLocalization{
	MagCleave				= "Show $spell:30619 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)
}

L:SetMiscLocalization{
	DBM_MAG_YELL_PHASE2		= "I... am... unleashed!",
	DBM_MAG_YELL_PHASE3		= "I will not be taken so easily! Let the walls of this prison tremble... and fall!",
	DBM_MAG_EMOTE_PHASE2	= "%s breaks free!"
}