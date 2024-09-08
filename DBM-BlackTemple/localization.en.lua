local L

--High Warlord Naj'entus
L = DBM:GetModLocalization("Najentus")

L:SetGeneralLocalization{
	name = "High Warlord Naj'entus"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    SpineYellOpt                = "Yell when you are affected by $spell:2142516",
    DischargeYellOpt            = "Yell when you are affected by $spell:2142504",
}

L:SetMiscLocalization{
    SpineYell			    = "Spine on me!",
    DBM_NAJENTUS_YELL_PULL	= "You will die in the name of Lady Vashj!",
    SayDischarge		    = "Static Charge on "..UnitName("PLAYER"),
    SayDischargeFade        = "Discharge on "..UnitName("PLAYER"),
    NewAdds                 = "New filth"
}



-- DBM_NAJENTUS_NAME					= "High Warlord Naj'entus";
-- DBM_NAJENTUS_DESCRIPTION			= "Announce Impaling Spine and Tidal Shield.";

-- DBM_NAJENTUS_OPTION_ICON			= "Set icon on Impaling Spine target";
-- DBM_NAJENTUS_OPTION_RANGECHECK		= "Show range check frame";
-- DBM_NAJENTUS_OPTION_FRAME			= "Show players with less than 8500 health";



-- DBM_NAJENTUS_WARN_SPINE				= "*** Impaling Spine on >%s< ***";
-- DBM_NAJENTUS_WARN_ENRAGE			= "*** Enrage in %s %s ***";
-- DBM_NAJENTUS_WARN_SHIELD			= "*** Tidal Shield ***";
-- DBM_NAJENTUS_WARN_SHIELD_SOON		= "*** Tidal Shield soon ***";

-- DBM_NAJENTUS_FRAME_TITLE			= "Naj'entus"
-- DBM_NAJENTUS_FRAME_TEXT				= "Players with less than 8500 health:"
-- DBM_NAJENTUS_SPELL_PWS				= "Power Word: Shield"
-- DBM_NAJENTUS_SPELL_FW				= "Frost Ward"
-- DBM_NAJENTUS_SPELL_FB				= "Fel Blossom"


-- Supremus
L = DBM:GetModLocalization("Supremus")

L:SetGeneralLocalization{
	name = "Supremus"
}

L:SetWarningLocalization{
    SupremusCracked			= "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
    WarnPhaseSoon		    = "Phase %s soon",
}

L:SetOptionLocalization{
    SupremusCracked			= "Show $spell:2142751 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
}

L:SetMiscLocalization{
    NewPillar                = "New vulcano"
}

-- DBM_SUPREMUS_NAME					= "Supremus";
-- DBM_SUPREMUS_DESCRIPTION			= "Announces phases and targets.";
-- DBM_SUPREMUS_OPTION_TARGETWARN		= "Announces Supremus' target in phase 2";
-- DBM_SUPREMUS_OPTION_TARGETICON		= "Set icon on Supremus' target";
-- DBM_SUPREMUS_OPTION_TARGETWHISPER	= "Send whisper to Supremus' target";

-- DBM_SUPREMUS_EMOTE_PHASE1			= "punches the ground in anger!";
-- DBM_SUPREMUS_EMOTE_PHASE2			= "The ground begins to crack open!";
-- DBM_SUPREMUS_EMOTE_NEWTARGET		= "acquires a new target";

-- DBM_SUPREMUS_WARN_KITE_TARGET		= "Target: >%s<";
-- DBM_SUPREMUS_WARN_PHASE_1_SOON		= "*** Tank & Spank phase in 10 sec ***";
-- DBM_SUPREMUS_WARN_PHASE_2_SOON		= "*** Kite phase in 10 sec ***";
-- DBM_SUPREMUS_WARN_PHASE_1			= "*** Tank & Spank phase ****";
-- DBM_SUPREMUS_WARN_PHASE_2			= "*** Kite phase ***";
-- DBM_SUPREMUS_SPECWARN_FIRE			= "Molten Fire";
-- DBM_SUPREMUS_SPECWARN_VOLCANO		= "Volcano";
-- DBM_SUPREMUS_WHISPER_RUN_AWAY		= "Run away!";

-- Shade of Akama
L = DBM:GetModLocalization("Akama")

L:SetGeneralLocalization{
	name = "Shade of Akama"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    }

L:SetMiscLocalization{
}


-- DBM_AKAMA_NAME						= "Shade of Akama";
-- DBM_AKAMA_DESCRIPTION				= nil;

-- DBM_AKAMA_MOB_AKAMA					= "Akama";
-- DBM_AKAMA_MOB_DEFENDER				= "Ashtongue Defender";
-- DBM_AKAMA_MOB_CHANNELER				= "Ashtongue Channeler";
-- DBM_AKAMA_MOB_SORCERER				= "Ashtongue Sorcerer";
-- DBM_AKAMA_MOB_DIES					= "%s dies.";

-- DBM_AKAMA_WARN_CHANNELER_DOWN		= "**** %s/6 channelers down ****";
-- DBM_AKAMA_WARN_SORCERER_DOWN		= "**** %s sorcerers down ****";

-- Teron Gorefiend
L = DBM:GetModLocalization("TeronGorefiend")

L:SetGeneralLocalization{
	name = "Teron Gorefiend"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    }

L:SetMiscLocalization{
    DBM_GOREFIEND_YELL_PULL				= "Vengeance is mine!"
}

-- DBM_GOREFIEND_NAME					= "Teron Gorefiend";
-- DBM_GOREFIEND_DESCRIPTION			= "Announces Shadow of Death and Incinerate.";

-- DBM_GOREFIEND_OPTION_INCINERATE		= "Announce incinerate";

-- DBM_GOREFIEND_YELL_PULL				= "Vengeance is mine!";

-- DBM_GOREFIEND_WARN_SOD				= "*** Shadow of Death: >%s< ***";
-- DBM_GOREFIEND_WARN_INCINERATE		= "*** Incinerate: >%s< ***";

-- DBM_GOREFIEND_SPECWARN_SOD			= "Shadow of Death";

-- Bloodboil
L = DBM:GetModLocalization("Bloodboil")

L:SetGeneralLocalization{
	name = "Gurtogg Bloodboil"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    }

L:SetMiscLocalization{
    DBM_BLOODBOIL_YELL_PULL				= "Horde will... crush you.";
}

-- DBM_BLOODBOIL_NAME					= "Gurtogg Bloodboil";
-- DBM_BLOODBOIL_DESCRIPTION			= "Announces Bloodboil and Fel Rage.";
-- DBM_BLOODBOIL_OPTION_SMASH			= "Announce Arcing Smash";

-- DBM_BLOODBOIL_YELL_PULL				= "Horde will... crush you.";

-- DBM_BLOODBOIL_WARN_BLOODBOIL		= "*** Bloodboil #%s ***";
-- DBM_BLOODBOIL_WARN_ENRAGE			= "*** Enrage in %s %s ***";
-- DBM_BLOODBOIL_WARN_FELRAGE_SOON		= "*** Fel Rage soon ***";
-- DBM_BLOODBOIL_WARN_NORMAL_SOON		= "*** Normal Phase in 5 sec ***";
-- DBM_BLOODBOIL_WARN_FELRAGE			= "*** Fel Rage on >%s< ***";
-- DBM_BLOODBOIL_WARN_NORMALPHASE		= "*** Normal Phase ***";
-- DBM_BLOODBOIL_WARN_SMASH			= "*** Arcing Smash ***";
-- DBM_BLOODBOIL_WARN_SMASH_SOON		= "*** Arcing Smash soon ***";

-- Essence (Reliquary) of Souls
L = DBM:GetModLocalization("Souls")

L:SetGeneralLocalization{
	name = "Essence of Souls"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    }

L:SetMiscLocalization{
    DBM_SOULS_YELL_PULL					= "Pain and suffering are all that await you!" -- Essence of Suffering
}

-- DBM_SOULS_NAME						= "Essence of Souls"
-- DBM_SOULS_DESCRIPTION				= "Announces Enrage, Fixate, Souldrain, Rune Shield, Deaden and Spite."
-- DBM_SOULS_OPTION_DRAIN				= "Announce Souldrain"
-- DBM_SOULS_OPTION_DRAIN_CAST			= "Announce Souldrain cast (useful for Mass Dispel)"
-- DBM_SOULS_OPTION_FIXATE				= "Announce Fixate"
-- DBM_SOULS_OPTION_SPITE				= "Announce Spite"
-- DBM_SOULS_OPTION_SCREAM				= "Announce Soul Scream"
-- DBM_SOULS_OPTION_SPECWARN_SPITE		= "Show special warning when you are afflicted by Spite"
-- DBM_SOULS_OPTION_WHISPER_SPITE		= "Send whisper to Spite targets"

-- DBM_SOULS_BOSS_SUFFERING			= "Essence of Suffering"
-- DBM_SOULS_BOSS_DESIRE				= "Essence of Desire"
-- DBM_SOULS_BOSS_KILL_NAME			= "Essence of Anger"
-- DBM_SOULS_YELL_PULL					= "Pain and suffering are all that await you!" -- Essence of Suffering
-- DBM_SOULS_EMOTE_ENRAGE				= "%s becomes enraged!"
-- DBM_SOULS_YELL_DESIRE				= "You can have anything you desire... for a price."
-- DBM_SOULS_YELL_DESIRE_DEMONIC		= "Shi shi rikk rukadare shi tichar kar x gular"
-- DBM_SOULS_DEBUFF_SPITE				= "([^%s]+) (%w+) afflicted by Spite%."
-- DBM_SOULS_DEBUFF_SOULDRAIN			= "([^%s]+) (%w+) afflicted by Soul Drain%."
-- DBM_SOULS_DEBUFF_FIXATE				= "([^%s]+) (%w+) afflicted by Fixate%."
-- DBM_SOULS_YELL_ANGER_INC			= "Beware: I live!"

-- DBM_SOULS_WARN_ENRAGE_SOON			= "*** Enrage soon ***"
-- DBM_SOULS_WARN_ENRAGE				= "*** Enrage ***"
-- DBM_SOULS_WARN_ENRAGE_OVER			= "*** Enrage over ***"
-- DBM_SOULS_WARN_RUNESHIELD			= "*** Rune Shield ***"
-- DBM_SOULS_WARN_RUNESHIELD_SOON		= "*** Rune Shield in 3 sec ***"
-- DBM_SOULS_WARN_DEADEN				= "*** Deaden ****"
-- DBM_SOULS_WARN_DEADEN_SOON			= "*** Deaden in 5 sec ***"
-- DBM_SOULS_WARN_DESIRE_INC			= "*** Essence of Desire - Zero mana in ~3 minutes ***"
-- DBM_SOULS_WARN_MANADRAIN			= "*** Zero mana in 20 sec ***"
-- DBM_SOULS_WARN_SPITE				= "*** Spite on %s ***"
-- DBM_SOULS_WARN_SOULDRAIN			= "*** Souldrain on %s ***"
-- DBM_SOULS_WARN_SOULDRAIN_CAST		= "*** Souldrain is casting ***"
-- DBM_SOULS_WARN_FIXATE				= "*** Fixate: >%s< ***"
-- DBM_SOULS_SPECWARN_FIXATE			= "Fixate!"
-- DBM_SOULS_WARN_SCREAM				= "*** Soul Scream ***"
-- DBM_SOULS_SPECWARN_SPITE			= "Spite!"
-- DBM_SOULS_WARN_ANGER_INC			= "*** Essence of Anger ***";
-- DBM_SOULS_WHISPER_SPITE				= "Spite on you!"

-- Mother Shahraz
L = DBM:GetModLocalization("Shahraz")

L:SetGeneralLocalization{
	name = "Mother Shahraz"
}

L:SetWarningLocalization{
    SunderAvian			    = "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
    SunderFila			    = "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
    SunderMater			    = "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
    SunderVirgo			    = "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
}

L:SetOptionLocalization{
    ShahrazAvian			= "Show $spell:2144004 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
    ShahrazFila			    = "Show $spell:2144003 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
    ShahrazMater			= "Show $spell:2144001 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
    ShahrazVirgo			= "Show $spell:2144096 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)    
}

L:SetMiscLocalization{
}


-- DBM_SHAHRAZ_NAME					= "Mother Shahraz"
-- DBM_SHAHRAZ_DESCRIPTION				= "Announces Fatal Attraction, sets an icons and sends whispers. Announces and shows a timer for Beams."
-- DBM_SHAHRAZ_OPTION_BEAM				= "Announce Beams"
-- DBM_SHAHRAZ_OPTION_BEAM_SOON		= "Show \"Beam soon\" warning"

-- DBM_SHAHRAZ_YELL_PULL				= "So... business or pleasure?"

-- DBM_SHAHRAZ_WARN_ENRAGE				= "*** Enrage in %s %s ***"
-- DBM_SHAHRAZ_WARN_FA					= "*** Fatal Attraction on %s ***"
-- DBM_SHAHRAZ_SPECWARN_FA				= "Fatal Attraction"
-- DBM_SHAHRAZ_WHISPER_FA				= "Fatal Attraction on you!"
-- DBM_SHAHRAZ_WARN_BEAM_VILE			= "*** Vile Beam ***"
-- DBM_SHAHRAZ_WARN_BEAM_SINISTER		= "*** Sinister Beam ***"
-- DBM_SHAHRAZ_WARN_BEAM_SINFUL		= "*** Sinful Beam ***"
-- DBM_SHAHRAZ_WARN_BEAM_WICKED		= "*** Wicked Beam ***"
-- DBM_SHAHRAZ_WARN_BEAM_SOON			= "*** Beam in 3 sec ***"

-- Illidari Council
L = DBM:GetModLocalization("Council")

L:SetGeneralLocalization{
	name = "Illidari Council"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
    }

L:SetMiscLocalization{
    DBM_COUNCIL_YELL_PULL1				= "Common... such a crude language. Bandal!",
    DBM_COUNCIL_YELL_PULL2				= "You wish to test me?",
    DBM_COUNCIL_YELL_PULL3				= "I have better things to do...",
    DBM_COUNCIL_YELL_PULL4				= "Flee or die!"
}

-- DBM_COUNCIL_NAME					= "Illidari Council"
-- DBM_COUNCIL_DESCRIPTION				= "Announces Circle of Healing, Deadly Poison, Divine Wrath, Vanish and shields."
-- DBM_COUNCIL_OPTION_COH				= "Announce Circle of Healing"
-- DBM_COUNCIL_OPTION_DP				= "Announce Deadly Poison"
-- DBM_COUNCIL_OPTION_DW				= "Announce Divine Wrath"
-- DBM_COUNCIL_OPTION_VANISH			= "Announce Vanish"
-- DBM_COUNCIL_OPTION_VANISHFADED		= "Show warning when Vanish fades"
-- DBM_COUNCIL_OPTION_VANISHFADESOON	= "Show warning 5 seconds before Vanish fades"
-- DBM_COUNCIL_OPTION_SN				= "Announce Reflective Shield"
-- DBM_COUNCIL_OPTION_SS				= "Announce Spell Shield"
-- DBM_COUNCIL_OPTION_SM				= "Announce Melee Shield"
-- DBM_COUNCIL_OPTION_DEVAURA			= "Announce Devotion Aura"
-- DBM_COUNCIL_OPTION_RESAURA			= "Announce Resistance Aura"

-- DBM_COUNCIL_MOB_GATHIOS				= "Gathios the Shatterer"
-- DBM_COUNCIL_MOB_MALANDE				= "Lady Malande"
-- DBM_COUNCIL_MOB_ZEREVOR				= "High Nethermancer Zerevor"
-- DBM_COUNCIL_MOB_VERAS				= "Veras Darkshadow"

-- DBM_COUNCIL_MOB_GATHIOS_EN			= "Gathios the Shatterer"
-- DBM_COUNCIL_MOB_MALANDE_EN			= "Lady Malande"
-- DBM_COUNCIL_MOB_ZEREVOR_EN			= "High Nethermancer Zerevor"
-- DBM_COUNCIL_MOB_VERAS_EN			= "Veras Darkshadow"

-- DBM_COUNCIL_YELL_PULL1				= "Common... such a crude language. Bandal!"
-- DBM_COUNCIL_YELL_PULL2				= "You wish to test me?"
-- DBM_COUNCIL_YELL_PULL3				= "I have better things to do..."
-- DBM_COUNCIL_YELL_PULL4				= "Flee or die!"

-- DBM_COUNCIL_WARN_CAST_COH			= "Circle of Healing"
-- DBM_COUNCIL_WARN_POISON				= "Deadly Poison on >%s<"
-- DBM_COUNCIL_WARN_SHIELD_NORMAL		= "Reflective Shield"
-- DBM_COUNCIL_WARN_SHIELD_SPELL		= "Spell Shield on %s"
-- DBM_COUNCIL_WARN_SHIELD_MELEE		= "Melee Shield on %s"
-- DBM_COUNCIL_WARN_VANISH				= "Vanish"
-- DBM_COUNCIL_WARN_VANISH_FADED		= "Vanished faded"
-- DBM_COUNCIL_WARN_WRATH				= "Divine Wrath on >%s<"
-- DBM_COUNCIL_WARN_AURA_DEV			= "Devotion Aura"
-- DBM_COUNCIL_WARN_AURA_RES			= "Resistance Aura"
-- DBM_COUNCIL_WARN_VANISHFADE_SOON	= "Vanish fades in 5 sec"

-- Illidan Stormrage
L = DBM:GetModLocalization("Illidan")

L:SetGeneralLocalization{
	name = "Illidan Stormrage"
}

L:SetWarningLocalization{
    TimerAddsSpawn	                    = "Adds spawning"
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
    DBM_ILLIDAN_YELL_PULL				= "You are not prepared!",
    DBM_ILLIDAN_YELL_PULL_RP			= "Akama. Your duplicity is hardly surprising. I should have slaughtered you and your malformed brethren long ago.",
    UnharnessedBlade			        = "Blade on me!",
    DBM_ILLIDAN_YELL_DEMON              = "You know nothing of power!",
    Phase5                              = "It is finished. You are beaten.",
    TimerCombatStart                    = "Combat starts",
    TimerHumanForm                      = "Human Form",
    TimerDemonForm                      = "Demon Form",
    Pull				                = "Akama. Your duplicity is hardly surprising. I should have slaughtered you and your malformed brethren long ago.",
	RealPull			                = "You are not prepared!",
	Eyebeam				                = "Stare into the eyes of the Betrayer!",
	Demon				                = "You know nothing of power!",
	DemonWithinQuote 	                = "Behold the power... of the demon within!",
	Phase4				                = "Is this it, mortals? Is this all the fury you can muster?",
	MaievTrap			                = "There shall be no prison for you this time!",
	Trapped1			                = "That is for Naisha!",
	Trapped2			                = "Bleed as I have bled!",
	Trapped3			                = "Meet your end, demon!",
	S1YouAreNotPrepared	                = "Stage One: You Are Not Prepared",
	S2FlamesOfAzzinoth	                = "Stage Two: Flames of Azzinoth",
	S3TheDemonWithin	                = "Stage Three: The Demon Within",
	S4TheLongHunt		                = "Stage Four: The Long Hunt",
	DemonWithin			                = "Demon Form"
}

L = DBM:GetModLocalization("Trash")

L:SetGeneralLocalization{
	name = "Trash mobs"
}

L:SetWarningLocalization{
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
}