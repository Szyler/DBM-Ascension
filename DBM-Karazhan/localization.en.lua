local L

--AnimalBosses
L = DBM:GetModLocalization("Hyakiss")

L:SetGeneralLocalization{
	name = "Hyakiss the Lurker"
}

L:SetWarningLocalization{
	WarnAcidicFang			= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
}

L:SetOptionLocalization{
	WarnAcidicFang			= "Show $spell:29901 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)
}

L:SetMiscLocalization{
}

--Attumen
L = DBM:GetModLocalization("Attumen")

L:SetGeneralLocalization{
	name = "Attumen the Huntsman"
}

L:SetWarningLocalization{
	AttSunder			= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
}

L:SetOptionLocalization{
	AttSunder			= "Show $spell:85178 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)
}

L:SetMiscLocalization{
	DBM_ATH_YELL_1		= "Come Midnight, let's disperse this petty rabble!",
	KillAttumen			= "Always knew... someday I would become... the hunted."
}


--Moroes
L = DBM:GetModLocalization("Moroes")

L:SetGeneralLocalization{
	name = "Moroes"
}

L:SetWarningLocalization{
	DBM_MOROES_VANISH_FADED	= "Vanish faded",
	DinnerServed			= "Dinner is Served!",
	DBM_MOROES_GARROTE		= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
}

L:SetTimerLocalization{
	DBM_MOROES_SOULBURST	= "Dance (%s)" --danceType = {[0] = "Circle", [1] = "Star", [2] = "Line"}
}

L:SetOptionLocalization{
	DBM_MOROES_VANISH_FADED	= "Show vanish fade warning",
	DBM_MOROES_GARROTE		= "Show $spell:37066 targets and stack number warning",
	DBM_MOROES_SOULBURST	= "Show timer for $spell:85089",
	DinnerServed			= "Show warning for $spell:85090",
	FoodYell				= "Yell your given hunger debuff $spell:85090"
}

L:SetMiscLocalization{
	DBM_MOROES_YELL_START	= "Hm, unannounced visitors. Preparations must be made...",
	DBM_MOROES_DINNER		= "Dinner is served!",
	YellApple				= "Apples",
	YellWine				= "Wine",
	YellFruit				= "Oranges",
	YellBoar				= "Boar",
	YellFish				= "Fish"
}


-- Maiden of Virtue
L = DBM:GetModLocalization("Maiden")

L:SetGeneralLocalization{
	name = "Maiden of Virtue"
}

L:SetWarningLocalization{
	warnPrayer			= "Run to boss!",
	WarnPrayerRun 		= "Run away! (8 yards)"
}

L:SetOptionLocalization{
	RangeFrame			= "Show range frame (10)",
	WarnPrayerRun 		= "Show warning to run away from $spell:85106"
}

L:SetMiscLocalization{
	DesperatePrayer		= "The Maiden of Virtue begins to make a Desperate Prayer!"
}


-- Romulo and Julianne
L = DBM:GetModLocalization("RomuloAndJulianne")

L:SetGeneralLocalization{
	name = "Romulo and Julianne"
}

L:SetWarningLocalization{
	warningPosion		= "%s on >%s< (%d)",		-- Mortal Wound on >args.destName< (args.amount)
}

L:SetTimerLocalization{
	TimerCombatStart	= "Combat starts",
	OperaSpotlight 		= "Spotlight"
}

L:SetOptionLocalization{
	TimerCombatStart	= "Show time for start of combat",
	OperaSpotlight 		= "Show timers for $spell:85112",
	warningPosion		= DBM_CORE_AUTO_ANNOUNCE_OPTIONS.spell:format(30830, GetSpellInfo(30830) or "unknown")
}

L:SetMiscLocalization{
	Event				= "Tonight... we explore a tale of forbidden love!",
	RJ_Pull				= "What devil art thou, that dost torment me thus?",
	DBM_RJ_PHASE2_YELL	= "Come, gentle night; and give me back my Romulo!",
	Romulo				= "Romulo",
	Julianne			= "Julianne",
	STAGE_FRIGHT		= "The audience deserves to be entertained!",
	Spotlight			= "Spotlight"
}


-- Big Bad Wolf
L = DBM:GetModLocalization("BigBadWolf")

L:SetGeneralLocalization{
	name = "The Big Bad Wolf"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
	OperaSpotlight 			= "Spotlight"
}

L:SetOptionLocalization{
	RRHIcon		= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(30753),
	OperaSpotlight 			= "Show timers for $spell:85112"
}

L:SetMiscLocalization{
	DBM_BBW_YELL_1			= "The better to own you with!",
	STAGE_FRIGHT			= "The audience deserves to be entertained!",
	Spotlight				= "Spotlight"
}


-- Curator
L = DBM:GetModLocalization("Curator")

L:SetGeneralLocalization{
	name = "The Curator"
}

L:SetWarningLocalization{
	TerminationTarget		= "Termination on YOU! %s",
	BreakCrystalWarning		= "Break A Crystal"
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
	RangeFrame				= "Show range frame (10)",
	TerminationTarget		= "Show warning for $spell:85082 on yourself",
	BreakCrystalWarning		= "Show warning for when to break crystal for $spell:85084",
	CuratorIcon				= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(85082)
}

L:SetMiscLocalization{
	DBM_CURA_YELL_PULL		= "The Menagerie is for guests only.",
	DBM_CURA_YELL_OOM		= "Your request cannot be processed.",
	YellTermination			= "%s Termination on %s! %s",
}


-- Terestian Illhoof
L = DBM:GetModLocalization("TerestianIllhoof")

L:SetGeneralLocalization{
	name = "Terestian Illhoof"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
}

L:SetOptionLocalization{
}

L:SetMiscLocalization{
	DBM_TI_YELL_PULL		= "Ah, you're just in time. The rituals are about to begin!",
	Kilrek					= "Kil'rek",
	DChains					= "Demon Chains"
}


-- Shade of Aran
L = DBM:GetModLocalization("Aran")

L:SetGeneralLocalization{
	name = "Shade of Aran"
}

L:SetWarningLocalization{
	DBM_ARAN_DO_NOT_MOVE	= "Flame Wreath - Do not move!",
	DBM_ARAN_VULNERABLE		= "Shade of Aran is vulnerable!",
	VolatilePoly			= "Volatile Polymorph!",
	ArcaneSpiral			= "Full Room Cover!",
	DoubleCast				= "Double Cast - Interrupt %s!"
}

L:SetTimerLocalization{
	timerSpecial			= "Special: %s",
	ArcaneSpiralTimer		= "Boom"
}

L:SetOptionLocalization{
	timerSpecial			= "Show timer for special ability cooldown",
	DBM_ARAN_DO_NOT_MOVE	= "Show special warning for $spell:30004",
	DBM_ARAN_VULNERABLE		= "Show special warning when $spell:85182 is removed",
	VolatilePoly			= "Show special warning for $spell:85273",
	ArcaneSpiral			= "Show special warning for full Arcane Spiral",
	DoubleCast				= "Show special warning for Double Cast",
	ArcaneSpiralTimer		= "Show timer for full Arcane Spiral",
	WreathIcons				= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(29946),
	ElementalIcons			= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(29962),
	SheepIcons				= DBM_CORE_AUTO_ICONS_OPTION_TEXT:format(85273),
	MarkCurrentTarget		= "Set Skull on the current target"
}

L:SetMiscLocalization{
	DBM_ARAN_BLIZZARD_1		= "Back to the cold dark with you!",
	DBM_ARAN_BLIZZARD_2		= "I'll freeze you all!",
	DBM_ARAN_FULL			= "Ah, the whimsical floes of magic..."
}


--Netherspite
L = DBM:GetModLocalization("Netherspite")

L:SetGeneralLocalization{
	name = "Netherspite"
}

L:SetWarningLocalization{
	DBM_NS_WARN_PORTAL_SOON	= "Portal Phase in 5",
	DBM_NS_WARN_BANISH_SOON	= "Banish Phase in 5",
	warningPortal			= "Portal Phase",
	warningBanish			= "Banish Phase"
}

L:SetTimerLocalization{
	timerPortalPhase	= "Portal Phase",
	timerBanishPhase	= "Banish Phase"
}

L:SetOptionLocalization{
	DBM_NS_WARN_PORTAL_SOON	= "Show pre-warning for Portal phase",
	DBM_NS_WARN_BANISH_SOON	= "Show pre-warning for Banish phase",
	warningPortal			= "Show warning for Portal phase",
	warningBanish			= "Show warning for Banish phase",
	timerPortalPhase		= "Show timer for Portal Phase duration",
	timerBanishPhase		= "Show timer for Banish Phase duration",
	SaySmol					= "Announce your presence for easier location after reaching 35 stacks of $spell:30421"
}

L:SetMiscLocalization{
	DBM_NS_EMOTE_PHASE_2	= "%s goes into a nether-fed rage!",
	DBM_NS_EMOTE_PHASE_1	= "%s cries out in withdrawal, opening gates to the nether."
}


--Prince Malchezaar
L = DBM:GetModLocalization("Prince")

L:SetGeneralLocalization{
	name = "Prince Malchezaar"
}

L:SetWarningLocalization{
	ShadowCrystalDead1		= "Shadow Crystals destroyed (1/3)",
	ShadowCrystalDead2		= "Shadow Crystals destroyed (2/3)",
	ShadowCrystalDead3		= "Shadow Crystals destroyed (3/3)",
	--InfernalOnYou			= "Next Infernal on you!",
	PriSunder				= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)	
}

L:SetTimerLocalization{
	AmplifyDamage			= "Amplify Damage #%s" --ampDmg stacks
}

L:SetOptionLocalization{
	ShadowCrystal			= "Show number of Shadow Crystals destroyed",
	AmplifyDamage			= "Show $spell:85207 targets and stack number warning",
	PriSunder				= "Show $spell:85198 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)
	--InfernalOnYou			= "Show special warning on Next Infernal on you!",
}

L:SetMiscLocalization{
	DBM_PRINCE_YELL_PULL	= "Madness has brought you here to me. I shall be your undoing!",
	DBM_PRINCE_YELL_P2		= "Simple fools! Time is the fire in which you'll burn!",
	DBM_PRINCE_YELL_P3		= "How can you hope to stand against such overwhelming power?",
	DBM_PRINCE_YELL_INF1	= "All realities, all dimensions are open to me!",
	DBM_PRINCE_YELL_INF2	= "You face not Malchezaar alone, but the legions I command!",
	DBM_PRINCE_YELL_INF3	= "The celestial forces are mine to manipulate."
}


-- Nightbane
L = DBM:GetModLocalization("Nightbane")

L:SetGeneralLocalization{
	name = "Nightbane"
}

L:SetWarningLocalization{
	DBM_NB_DOWN_WARN 		= "Ground Phase in 15 sec",
	DBM_NB_DOWN_WARN2 		= "Ground Phase in 5 sec",
	DBM_NB_AIR_WARN			= "Air Phase",
	SmolderingBreath		= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)	
}

L:SetTimerLocalization{
	timerNightbane			= "Nightbane incoming",
	timerAirPhase			= "Air Phase"
}

L:SetOptionLocalization{
	DBM_NB_AIR_WARN			= "Show warning for Air Phase",
	PrewarnGroundPhase		= "Show pre-warnings for Ground Phase",
	timerNightbane			= "Show timer for Nightbane summon",
	timerAirPhase			= "Show timer for Air Phase duration",
	SmolderingBreath		= "Show $spell:85245 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)
}

L:SetMiscLocalization{
	DBM_NB_EMOTE_PULL		= "An ancient being awakens in the distance...",
	DBM_NB_YELL_PULL		= "What fools! I shall bring a quick end to your suffering!",
	DBM_NB_YELL_AIR			= "Miserable vermin. I shall exterminate you from the air!",
	DBM_NB_YELL_GROUND		= "Enough! I shall land and crush you myself!",
	DBM_NB_YELL_GROUND2		= "Insects! Let me show you my strength up close!"
}


-- Wizard of Oz
L = DBM:GetModLocalization("Oz")

L:SetGeneralLocalization{
	name = "Wizard of Oz"
}

L:SetWarningLocalization{
}

L:SetTimerLocalization{
	OperaSpotlight 			= "Spotlight"
}

L:SetOptionLocalization{
	AnnounceBosses			= "Show warnings for boss spawns",
	ShowBossTimers			= "Show timers for boss spawns",
	DBM_OZ_OPTION_1			= "Show range check frame in phase 2",
	OperaSpotlight 			= "Show timers for $spell:85112"
}

L:SetMiscLocalization{
	DBM_OZ_WARN_TITO		= "Tito",
	DBM_OZ_WARN_ROAR		= "Roar",
	DBM_OZ_WARN_STRAWMAN	= "Strawman",
	DBM_OZ_WARN_TINHEAD		= "Tinhead",
	DBM_OZ_WARN_CRONE		= "The Crone",
	DBM_OZ_YELL_DOROTHEE	= "Oh Tito, we simply must find a way home! The old wizard could be our only hope! Strawman, Roar, Tinhead, will you - wait... oh golly, look we have visitors!",
	DBM_OZ_YELL_ROAR		= "I'm not afraid a' you! Do you wanna' fight? Huh, do ya'? C'mon! I'll fight ya' with both paws behind my back!",
	DBM_OZ_YELL_STRAWMAN	= "Now what should I do with you? I simply can't make up my mind.",
	DBM_OZ_YELL_TINHEAD		= "I could really use a heart. Say, can I have yours?",
	DBM_OZ_YELL_CRONE		= "Woe to each and every one of you, my pretties!",
	STAGE_FRIGHT			= "The audience deserves to be entertained!",
	Spotlight				= "Spotlight"
}


-- Named Beasts
L = DBM:GetModLocalization("Shadikith")

L:SetGeneralLocalization{
	name = "Shadikith the Glider"
}

L = DBM:GetModLocalization("Hyakiss")

L:SetGeneralLocalization{
	name = "Hyakiss the Lurker"
}

L = DBM:GetModLocalization("Rokad")

L:SetGeneralLocalization{
	name = "Rokad the Ravager"
}

-- Opera

L = DBM:GetModLocalization("Opera")

L:SetGeneralLocalization{
	name = "Opera"
}

L:SetWarningLocalization{
	OperaSpotlight 			= "Spotlight"
}

L:SetTimerLocalization{
	OperaSpotlight 			= "Spotlight",
	OperaSpotlightIn		= "Get into Spotlight",
	OperaSpotNotUse			= "DO NOT USE: %s" --(spellName)
}

L:SetOptionLocalization{
	OperaSpotlight 			= "Show timers for $spell:85112",
	OperaSpotlightIn 		= "Show timers for when to run into $spell:85112",
	OperaSpotNotUse			= "Show the spell to avoid $spell:85114"
}

L:SetMiscLocalization{
	STAGE_FRIGHT			= "The audience deserves to be entertained!"
}



