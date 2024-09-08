local L

--Gruul
L = DBM:GetModLocalization("Gruul")

L:SetGeneralLocalization{
	name = "Gruul the Dragonkiller"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    CaveinYellOpt           = "Yell when you are affected by $spell:36240"
}

L:SetMiscLocalization{
    CaveinYell			    = "Cave in on me!",
}

DBMGUI_TAB_OTHER_BC	= "Outlands" -- do not translate

-- Maulgar
DBM_MAULGAR_NAME			= "High King Maulgar";
DBM_MAULGAR_DESCRIPTION		= "Announces shield and heal and shows a timer for Arcing Smash, Whirlwind and Felhunter spawn.";
DBM_MAULGAR_OPTION_1		= "Announce Greater Power Word: Shield";
DBM_MAULGAR_OPTION_2		= "Announce Spell Shield";
DBM_MAULGAR_OPTION_3		= "Announce Prayer of Healing";
DBM_MAULGAR_OPTION_4		= "Announce Heal";
DBM_MAULGAR_OPTION_5		= "Announce Whirlwind";
DBM_MAULGAR_OPTION_6		= "Announce Arcing Smash";
DBM_MAULGAR_OPTION_7		= "Announce Felhunter";

DBM_MAULGAR_WARN_GPWS		= "*** Shield on Blindeye ***";
DBM_MAULGAR_WARN_SHIELD		= "*** Spell Shield on Krosh ***";
DBM_MAULGAR_WARN_SMASH		= "Arcing Smash on >%s<: %s";
DBM_MAULGAR_WARN_POH		= "*** Blindeye casts Prayer of Healing ***";
DBM_MAULGAR_WARN_HEAL		= "*** Blindeye casts Heal ***";

DBM_MAULGAR_WARN_WHIRLWIND	= "*** Whirlwind ***";
DBM_MAULGAR_WARN_WW_SOON	= "*** Whirlwind soon ***";
DBM_MAULGAR_WARN_FELHUNTER	= "*** Felhunter ***";


DBM_MAULGAR_DODGED	= "dodged";
DBM_MAULGAR_PARRIED	= "parried";
DBM_MAULGAR_MISSED	= "missed";


-- Gruul
DBM_GRUUL_NAME				= "Gruul the Dragonkiller";
DBM_GRUUL_DESCRIPTION		= "Announces Shatter, Grow, Reverberation and Cave In.";

DBM_GRUUL_RANGE_OPTION		= "Show range check frame";
DBM_GRUUL_GROW_OPTION		= "Announce Grow";
DBM_GRUUL_SHATTER_OPTION	= "Announce Ground Slam and Shatter";
DBM_GRUUL_SILENCE_OPT		= "Announce Silence";
DBM_GRUUL_CAVE_OPTION		= "Show special warning for Cave In";
DBM_GRUUL_OPTION_GROWBAR	= "Grow"

DBM_GRUUL_SAY_PULL			= "Come.... and die."
DBM_GRUUL_GROW_EMOTE		= "%s grows in size!";
DBM_GRUUL_EMOTE_BOULDER		= "A Giant Boulder is crashing through the room!";
DBM_GRUUL_EMOTE_SHATTER		= "%s roars!";
DBM_GRUUL_SILENCE			= "Reverberation";

DBM_GRUUL_GROW_ANNOUNCE		= "*** Grow #%s ***";
DBM_GRUUL_SHATTER_WARN		= "*** Shatter ***";
DBM_GRUUL_SHATTER_20WARN	= "*** Ground Slam soon ***";
DBM_GRUUL_SHATTER_10WARN	= "*** Ground Slam - Shatter in 10 sec ***";
DBM_GRUUL_SHATTER_SOON		= "*** Shatter soon ***";
DBM_GRUUL_SILENCE_WARN		= "*** Silence ***";
DBM_GRUUL_SILENCE_SOON_WARN	= "*** Silence soon ***";
DBM_GRUUL_CAVE_IN_WARN		= "Cave In";

