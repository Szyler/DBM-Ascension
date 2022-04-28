local L

-----------
-- Al'ar --
-----------

L = DBM:GetModLocalization("Alar")

L:SetGeneralLocalization{
	name = "Al'ar"
}

L:SetWarningLocalization{
	WarnEmber 			= "Ember of Al'ar spawned!",
	-- WarnDive			= "Al'ar Dive! Run away!",
	SpecWarnFeather		= "Blazing Wings fading in 15 Seconds!",
	FlameBreath			= "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
}

L:SetTimerLocalization{
	NextPlatform		= "Next platform in:",
	AlarUp				= "Al'ar flies up in:",
	AlarDive			= "Al'ar dive:",
	TimerEmberSpawn		= "Next ember of Al'ar spawn:"
}


L:SetOptionLocalization{
	WarnEmber 			= "Show warning when Ember of Al'ar spawns",
	WarnAlarRebirth		= "Show warning for Al'ar rebirth casts",
	WarnFlameCascade	= "Show warning when Al'ar is about to cast Flame Cascade",
	-- WarnDive			= "Show warning for Al'ar Dive",
	Berserk 			= "Show timer for Berserk",
	NextPlatform 		= "Show timer for Al'ar platform switch",
	AlarUp 				= "Show timer for Al'ar flying up in phase 2",
	AlarDive			= "Show Al'ar dive timer countdown",
	TimerEmberSpawn   	= "Show timer for next Ember of Al'ar spawn",
	SpecWarnFeather		= "Show reminder for Blazing Wings",
	FlameBreath			= "Show $spell:2135155 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
	LivingBombYellOpt	= "Yell when you are affected by $spell:2135178"
}

L:SetMiscLocalization{
	EmoteAlarUp			= "flies high into the air!",
	EmotePhase3			= "attempts to escape, losing feathers as he flies away in fear!"
}


-------------------------------
-- High Astromancer Solarian --
-------------------------------

L = DBM:GetModLocalization("Solarian")

L:SetGeneralLocalization{
	name = "High Astromancer Solarian"
}

L:SetWarningLocalization{
	specWarnPriest			= "Kill %s",
	-- SpecWarnLunar			= "Lunar Wrath. Unable to move!",
	-- SpecWarnFinishAdd		= "Finish off the priest!",
	SpecWarnVoidSpawn		= "Solarian Voidspawn!",
	WarnPhase2Soon			= "Phase 2 soon"
}

L:SetTimerLocalization{
	TimerAdds				= "Add phase in:",
	-- TimerNextLWrathPop		= "%s going off in: ",
	-- TimerNextSWrathPop		= "%s going off in: ",
	TimerVoidSpawn			= "Next Solarian Voidspawn in:",
	TimerNextHealS			= "Solarian Priest heal CD:",
	TimerNextHealL			= "Lunarian Priest heal CD:"
}

L:SetOptionLocalization{
	-- Berserk 				= "Show timer for Berserk",
	TimerAdds				= "Show timer for the first add phase",
	specWarnPriest			= "Show warning of the Priest with the opposite phase of High Astromancer Solarian",
	-- SpecWarnLunar			= "Show warning when lunar wrath casted on others",
	SpecWarnVoidSpawn		= "Show warning when add spawns in void phase",
	TimerVoidSpawn			= "Show timer for add spawn in void phase",
	-- SpecWarnFinishAdd		= "Show when you should switch to finish off Priest",
	WrathYellOpt			= "Yell when you are affected by $spell:2135278 or $spell:2135287",
	-- TimerNextLWrathPop		= "Show countdown for $spell:2135283 explosion",
	-- TimerNextSWrathPop		= "Show countdown for $spell:2135292 explosion",
	TimerNextHealS			= "Show timer for next Solarian Priest heal",
	TimerNextHealL			= "Show timer for next Lunarian Priest heal",
	WarnPhase2Soon			= "Announce when phase 2 is about to start",
	StartingPriest          = "Automatically mark and warn Solarian/Lunarian Priest on the initial add phase",
	StartingSolarian        = "Mark Solarian Priest",
	PanicYellOpt			= "Yell when you are affected by $spell:2135243",
	OrbitalBlastTargetOpt	= "Set icon on $spell:2135224 target"
}

L:SetMiscLocalization{
	SolarianPhase1			= "I will crush your delusions of grandeur!",
	SolarianYellAddPhase	= "You are hopelessly outmatched!",
	LunarWrathYell			= "Lunar Wrath on "..UnitName("PLAYER").."! I have to run!",
	SolarWrathYell 			= "Solar Wrath on "..UnitName("PLAYER").."! Run away from me!"
}

--------------------------
-- Kael'thas Sunstrider --
--------------------------
L = DBM:GetModLocalization("KaelThas")

L:SetGeneralLocalization{
	name = "Kael'thas Sunstrider",
}

L:SetWarningLocalization{
	-- WarnGaze			= "Gaze on >%s<",
	-- SpecWarnGaze		= "Gaze on YOU - Run away!",
	-- SpecWarnSeal		= "Seal of blood stacks %s on %s, Tanks swap!"
	KTSeal				= "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
}

L:SetTimerLocalization{
	-- TimerNextGaze		= "Thaladred target switch in: "
}

L:SetOptionLocalization{
	Berserk 			= "Show timer for Berserk",
	-- WarnGaze			= "Show warning for Thaladred's Gaze target",
	-- SpecWarnGaze		= "Show special warning when Gaze on you",
	-- SpecWarnSeal		= "Show warning for Seal of blood stacks", --set to 4 currently 
	KTSeal				= "Show $spell:2135342 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
	GazeIcon			= "Set icon on $spell:2135337 target",
	FocusedBurst		= "Set icon on $spell:2135392 target"
	-- TimerNextGaze		= "Show timer for Thaladred's Gaze"
}


L:SetMiscLocalization{
	kaelYellP1			= "Energy. Power. My people are addicted to it... a dependence made manifest after the Sunwell was destroyed. Welcome... to the future. A pity you are too late to stop it. No one can stop me now! Selama ashal'anore!";
	emoteGaze			= "Thaladred the Darkener sets eyes on ";
}


--[=====[ 
DBM_EYE_TAB			= "EyeTab"
DBM_TEMPEST_KEEP	= "Tempest Keep";


-- Void Reaver
DBM_VOIDREAVER_NAME						= "Void Reaver";
DBM_VOIDREAVER_DESCRIPTION				= "Announces Arcane Orb and Pounding.";
DBM_VOIDREAVER_OPTION_WARN_ORB			= "Announce Arcane Orb targets";
DBM_VOIDREAVER_OPTION_YELL_ORB			= "Send chat message when he casts Arcane Orb on you";
DBM_VOIDREAVER_OPTION_ORB_ICON			= "Set icon on Arcane Orb target";
DBM_VOIDREAVER_OPTION_WARN_POUNDING		= "Announce Pounding";
DBM_VOIDREAVER_OPTION_WARN_POUNDINGSOON	= "Show \"Pounding soon\" warning";
DBM_VOIDREAVER_OPTION_SOUND				= "Play sound when he casts Arcane Orb on you"

DBM_VOIDREAVER_POUNDING					= "Pounding";

DBM_VOIDREAVER_WARN_ORB					= "*** Arcane Orb on >%s< ***";
DBM_VOIDREAVER_YELL_ORB					= "Arcane Orb incoming! Run away from me!";
DBM_VOIDREAVER_WARN_ENRAGE				= "*** Enrage in %s %s ***";
DBM_VOIDREAVER_WARN_POUNDING			= "*** Pounding ***";
DBM_VOIDREAVER_WARN_POUNDING_SOON		= "*** Pounding soon ***";
DBM_VOIDREAVER_SPECWARN_ORB				= "Arcane Orb on you!";

DBM_VOIDREAVER_R_FURY					= "Righteous Fury"

-- Solarian
DBM_SOLARIAN_NAME						= "High Astromancer Solarian";
DBM_SOLARIAN_DESCRIPTION				= "Announces Wrath and her adds.";
DBM_SOLARIAN_OPTION_WARN_WRATH			= "Announce Wrath";
DBM_SOLARIAN_OPTION_ICON_WRATH			= "Set icon on Wrath target";
DBM_SOLARIAN_OPTION_SPECWARN_WRATH		= "Show special warning when you are afflicted by Wrath";
DBM_SOLARIAN_OPTION_WARN_PHASE			= "Announce adds";
DBM_SOLARIAN_OPTION_WHISPER_WRATH		= "Send whisper to Wrath targets"
DBM_SOLARIAN_OPTION_SOUND				= "Play sound when you are afflicted by Wrath"

DBM_SOLARIAN_YELL_ENRAGE				= "Enough of this!%s*Now I call upon the fury of the cosmos itself."

DBM_SOLARIAN_SPECWARN_WRATH				= "Wrath on you!";
DBM_SOLARIAN_ANNOUNCE_WRATH				= "*** Wrath on >%s< ***";
DBM_SOLARIAN_ANNOUNCE_SPLIT				= "*** Adds incoming ***";
DBM_SOLARIAN_ANNOUNCE_PRIESTS_SOON		= "*** Priests & Solarian in 5 sec ***";
DBM_SOLARIAN_ANNOUNCE_PRIESTS_NOW		= "*** Priests & Solarian spawned ***";
DBM_SOLARIAN_ANNOUNCE_AGENTS_NOW		= "*** Agents spawned ***";
DBM_SOLARIAN_ANNOUNCE_SPLIT_SOON		= "*** Split in 5 seconds ***";
DBM_SOLARIAN_ANNOUNCE_ENRAGE_PHASE		= "*** Voidwalker Phase ***";

-- Al'ar
DBM_ALAR_NAME							= "Al'ar";
DBM_ALAR_DESCRIPTION					= "Shows timers and warnings for Al'ar.";
DBM_ALAR_OPTION_MELTARMOR				= "Announce Melt Armor";
DBM_ALAR_OPTION_METEOR					= "Announce Meteor";

DBM_ALAR_FLAME_BUFFET					= "Flame Buffet";

DBM_ALAR_WARN_MELTARMOR					= "*** Melt Armor on >%s< ***";
DBM_ALAR_WARN_REBIRTH					= "*** Phase 2 ***";
DBM_ALAR_WARN_FIRE						= "Flame Patch";
DBM_ALAR_WARN_ADD						= "*** Next platform - add incoming ***";
DBM_ALAR_WARN_METEOR					= "*** Meteor ***";
DBM_ALAR_WARN_METEOR_SOON				= "*** Meteor soon ***";
DBM_ALAR_WARN_ENRAGE					= "*** Enrage in %s %s ***";

-- Kael'thas
DBM_KAEL_NAME							= "Kael'thas Sunstrider";
DBM_KAEL_DESCRIPTION					= "Shows timers for the Kael'thas encounter.";

DBM_KAEL_OPTION_PHASE					= "Announce phases";
DBM_KAEL_OPTION_ICON_P1					= "Set icon on Thaladred's target";
DBM_KAEL_OPTION_WHISPER_P1				= "Send whisper to Thaladred's target";
DBM_KAEL_OPTION_RANGECHECK				= "Show distance frame";
DBM_KAEL_OPTION_CONFLAG					= "Announce conflagration";
DBM_KAEL_OPTION_CONFLAG2				= "Announce conflagration in phase 3";
DBM_KAEL_OPTION_CONFLAGTIMER2			= "Show conflagration timer in phase 3";
DBM_KAEL_OPTION_FEAR					= "Announce fear";
DBM_KAEL_OPTION_FEARSOON				= "Show \"fear soon\" warning";
DBM_KAEL_OPTION_TOY						= "Announce remote toy in phase 1";
DBM_KAEL_OPTION_FRAME					= "Show health of the weapons";
DBM_KAEL_OPTION_ADDFRAME				= "Show health of the advisors";
DBM_KAEL_OPTION_PYRO					= "Announce pyroblast";
DBM_KAEL_OPTION_BARRIER					= "Announce shock barrier";
DBM_KAEL_OPTION_BARRIER2				= "Announce shock barrier in phase 5";
DBM_KAEL_OPTION_PHOENIX					= "Announce phoenix spawns";
DBM_KAEL_OPTION_WARNMC					= "Announce mind control";
DBM_KAEL_OPTION_ICONMC					= "Set icons on mind control targets";
DBM_KAEL_OPTION_GRAVITY					= "Announce gravity lapse";

DBM_KAEL_YELL_PHASE1					= "Energy. Power. My people are addicted to it... a dependence made manifest after the Sunwell was destroyed. Welcome... to the future. A pity you are too late to stop it. No one can stop me now! Selama ashal'anore!";
DBM_KAEL_EMOTE_THALADRED_TARGET			= "sets eyes on ([^%s]+)!";
DBM_KAEL_YELL_PHASE1_SANGUINAR			= "You have persevered against some of my best advisors... but none can withstand the might of the Blood Hammer. Behold, Lord Sanguinar!";
DBM_KAEL_YELL_PHASE1_CAPERNIAN			= "Capernian will see to it that your stay here is a short one.";
DBM_KAEL_YELL_PHASE1_TELONICUS			= "Well done, you have proven worthy to test your skills against my master engineer, Telonicus.";
DBM_KAEL_YELL_THALA_DOWN				= "Forgive me, my prince! I have... failed.";
DBM_KAEL_YELL_CAPERNIAN_DOWN			= "This is not over!";

DBM_KAEL_YELL_PHASE2					= "As you see, I have many weapons in my arsenal....";
DBM_KAEL_YELL_PHASE3					= "Perhaps I underestimated you. It would be unfair to make you fight all four advisors at once, but... fair treatment was never shown to my people. I'm just returning the favor.";
DBM_KAEL_YELL_PHASE4					= "Alas, sometimes one must take matters into one's own hands. Balamore shanal!";
DBM_KAEL_YELL_PHASE5					= "I have not come this far to be stopped! The future I have planned will not be jeopardized! Now you will taste true power!!";

DBM_KAEL_WEAPONS = {
	["Staff of Disintegration"] = 1,
	["Infinity Blades"] = 2,
	["Cosmic Infuser"] = 3,
	["Warp Slicer"] = 4,
	["Devastation"] = 5,
	["Netherstrand Longbow"] = 6,
	["Phaseshift Bulwark"] = 7
};
DBM_KAEL_WEAPONS_NAMES = {
	"Staff",
	"Dagger",
	"Mace",
	"Sword",
	"Axe",
	"Bow",
	"Shield"
};


DBM_KAEL_ADVISORS = {
	["Thaladred the Darkener"] = 1,
	["Lord Sanguinar"] = 2,
	["Grand Astromancer Capernian"] = 3,
	["Master Engineer Telonicus"] = 4,
};

DBM_KAEL_ADVISORS_NAMES = {
	"Thaladred",
	"Sanguinar",
	"Capernian",
	"Telonicus"
};

DBM_KAEL_INFOFRAME_TITLE				= "Weapons";
DBM_KAEL_INFOFRAME_ADDS_TITLE			= "Advisors";

DBM_KAEL_CAST_PHOENIX_REBIRTH			= "Phoenix begins to cast Rebirth.";
DBM_KAEL_EMOTE_PYROBLAST				= "begins to cast Pyroblast";
DBM_KAEL_EGG							= "Phoenix Egg";
DBM_KAEL_YELL_GRAVITY_LAPSE				= "Having trouble staying grounded?";
DBM_KAEL_YELL_GRAVITY_LAPSE2			= "Let us see how you fare when your world is turned upside down.";


DBM_KAEL_SPECWARN_THALADRED_TARGET		= "Run away!";
DBM_KAEL_WARN_THALADRED_TARGET			= "*** Thaladred sets eyes on >%s< ***";
DBM_KAEL_WHISPER_THALADRED_TARGET		= "Thaladred sets eyes on YOU! Run away!";
DBM_KAEL_WARN_INC						= "*** %s incoming ***";
DBM_KAEL_SANGUINAR						= "Lord Sanguinar";
DBM_KAEL_CAPERNIAN						= "Capernian";
DBM_KAEL_TELONICUS						= "Telonicus";
DBM_KAEL_WARN_FEAR						= "*** Fear in 1.5 sec ***";
DBM_KAEL_WARN_FEAR_SOON					= "*** Fear soon ***";
DBM_KAEL_WARN_CONFLAGRATION				= "*** Conflagration on >%s< ***";
DBM_KAEL_WARN_REMOTETOY					= "*** Remote Toy on >%s< ***";

DBM_KAEL_WARN_PHASE1					= "*** Phase 1 - Thaladred incoming ***";
DBM_KAEL_WARN_PHASE2					= "*** Phase 2 - Weapons incoming ***";
DBM_KAEL_WARN_PHASE3					= "*** Phase 3 - Adds incoming ***";
DBM_KAEL_WARN_PHASE4					= "*** Phase 4 - Kael'thas incoming ***";
DBM_KAEL_WARN_PHASE5					= "*** Phase 5 ***";

DBM_KAEL_WARN_PYRO						= "*** Pyroblast ***";
DBM_KAEL_WARN_BARRIER_SOON				= "*** Shock Barrier in 5 sec ***";
DBM_KAEL_WARN_BARRIER_NOW				= "*** Shock Barrier ***";
DBM_KAEL_WARN_BARRIER_DOWN				= "*** Shield down! ***";
DBM_KAEL_WARN_PHOENIX					= "*** Phoenix spawned ***";
DBM_KAEL_WARN_MC_TARGETS				= "*** Mind Control: %s ***";
DBM_KAEL_WARN_REBIRTH					= "*** Phoenix down - egg spawned ***";
DBM_KAEL_WARN_GRAVITY_LAPSE				= "*** Gravity Lapse ***";
DBM_KAEL_GRAVITY_SOON					= "*** Gravity Lapse soon ***";
DBM_KAEL_GRAVITY_END_SOON				= "*** Gravity Lapse ends in 5 sec ***"; 
--]=====]