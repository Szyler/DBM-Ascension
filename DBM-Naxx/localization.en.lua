local L

-------------------
--  Anub'Rekhan  --
-------------------
L = DBM:GetModLocalization("Anub'Rekhan")

L:SetGeneralLocalization({
	name = "Anub'Rekhan"
})

L:SetWarningLocalization({
	SpecialLocust		= "Locust Swarm",
	WarningLocustFaded	= "Locust Swarm faded"
})

L:SetOptionLocalization({
	SpecialLocust		= "Show special warning for Locust Swarm",
	WarningLocustFaded	= "Show warning for Locust Swarm fade",
	ArachnophobiaTimer	= "Show timer for Arachnophobia (achievement)"
})

L:SetMiscLocalization({
	YellDarkGaze = "Dark Gaze on me!",
	ArachnophobiaTimer	= "Arachnophobia"
})

----------------------------
--  Grand Widow Faerlina  --
----------------------------
L = DBM:GetModLocalization("Faerlina")

L:SetGeneralLocalization({
	name = "Grand Widow Faerlina"
})

L:SetWarningLocalization({
	WarningEmbraceExpire	= "Widow's Embrace ends in 5 seconds",
	WarningEmbraceExpired	= "Widow's Embrace faded",
	FaerlinaMalicious		= "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
	FaerlinaFrenzy			= "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
})

L:SetOptionLocalization({
	WarningEmbraceExpire	= "Show pre-warning for Widow's Embrace fade",
	WarningEmbraceExpired	= "Show warning for Widow's Embrace fade",
	FaerlinaMalicious		= "Show $spell:350250 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
	FaerlinaFrenzy			= "Show warning for $spell:28798 stacks on Faerlina", --(args.spellName, args.destName, args.amount or 1)
})

---------------
--  Maexxna  --
---------------
L = DBM:GetModLocalization("Maexxna")

L:SetGeneralLocalization({
	name = "Maexxna"
})

L:SetWarningLocalization({
	WarningSpidersSoon	= "Maexxna Spiderlings in 5 seconds",
	WarningSpidersNow	= "Maexxna Spiderlings spawned",
	MaexxnaNecrotic		= "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
})

L:SetTimerLocalization({
	TimerSpider			= "Next Maexxna Spiderlings"
})

L:SetOptionLocalization({
	WarningSpidersSoon	= "Show pre-warning for Maexxna Spiderlings",
	WarningSpidersNow	= "Show warning for Maexxna Spiderlings",
	TimerSpider			= "Show timer for next Maexxna Spiderlings",
	MaexxnaNecrotic		= "Show $spell:350250 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
})

L:SetMiscLocalization({
	YellWebWrap			= "I'm wrapped! Help me!",
	ArachnophobiaTimer	= "Arachnophobia"
})

------------------------------
--  Noth the Plaguebringer  --
------------------------------
L = DBM:GetModLocalization("Noth")

L:SetGeneralLocalization({
	name = "Noth the Plaguebringer"
})

L:SetWarningLocalization({
	WarningTeleportNow	= "Teleported",
	WarningTeleportSoon	= "Teleport in 10 seconds"
})

L:SetTimerLocalization({
	TimerTeleport		= "Teleport",
	TimerTeleportBack	= "Teleport back"
})

L:SetOptionLocalization({
	WarningTeleportNow	= "Show warning for Teleport",
	WarningTeleportSoon	= "Show pre-warning for Teleport",
	TimerTeleport		= "Show timer for Teleport",
	TimerTeleportBack	= "Show timer for Teleport back"
})

L:SetMiscLocalization({
	Teleport			= "%s teleports to the balcony above!"
})

--------------------------
--  Heigan the Unclean  --
--------------------------
L = DBM:GetModLocalization("Heigan")

L:SetGeneralLocalization({
	name = "Heigan the Unclean"
})

L:SetWarningLocalization({
	WarningTeleportNow	= "Teleported",
	WarningTeleportSoon	= "Teleport in %d seconds",
	HeiganTouch			= "%s on >%s< (%d)", --(args.spellName, args.destName, args.amount or 1)
	HeiganTouchHC		= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
})

L:SetTimerLocalization({
	TimerTeleport	= "Teleport"
})

L:SetOptionLocalization({
	WarningTeleportNow	= "Show warning for Teleport",
	WarningTeleportSoon	= "Show pre-warning for Teleport",
	TimerTeleport		= "Show timer for Teleport",
	HeiganTouch			= "Show $spell:196780 targets and stack number warning", --(args.spellName, args.destName, args.amount or 1)
	HeiganTouchHC		= "Heroic: Show $spell:196791 targets and stack number warning" --(args.spellName, args.destName, args.amount or 1)
})

L:SetMiscLocalization({
	YellBurningFever = "Burning Fever on me!",
})

---------------
--  Loatheb  --
---------------
L = DBM:GetModLocalization("Loatheb")

L:SetGeneralLocalization({
	name = "Loatheb"
})

L:SetWarningLocalization({
	WarningHealSoon	= "Healing possible in 3 seconds",
	WarningHealNow	= "Heal now"
})

L:SetOptionLocalization({
	WarningHealSoon		= "Show pre-warning for the 3-second healing and mana regen window",
	WarningHealNow		= "Show warning for the 3-second healing and mana regen window",
	SporeDamageAlert	= "DISABLED"
})

-----------------
--  Patchwerk  --
-----------------
L = DBM:GetModLocalization("Patchwerk")

L:SetGeneralLocalization({
	name = "Patchwerk"
})

L:SetOptionLocalization({
	WarningHateful				= "Post Hateful Strike targets to raid chat\n(requires announce to be enabled and leader/promoted status)",
	SetIconOnGastricTarget		= "Set icons on Gastric Affliction targets"
})

L:SetMiscLocalization({
	yell1			= "Patchwerk want to play!",
	yell2			= "Kel'thuzad make Patchwerk his avatar of war!",
	HatefulStrike	= "Hateful Strike --> %s [%s]"
})

-----------------
--  Grobbulus  --
-----------------
L = DBM:GetModLocalization("Grobbulus")

L:SetGeneralLocalization({
	name = "Grobbulus"
})

L:SetOptionLocalization({
	SpecialWarningInjection		= "Show special warning when you are affected by Mutating Injection",
	SetIconOnInjectionTarget	= "Set icons on Mutating Injection targets"
})

L:SetWarningLocalization({
	SpecialWarningInjection		= "Mutating Injection on you"
})

L:SetTimerLocalization({
})

-------------
--  Gluth  --
-------------
L = DBM:GetModLocalization("Gluth")

L:SetGeneralLocalization({
	name = "Gluth"
})
L:SetWarningLocalization{
	DBM_GLUTH_VICIOUS_BITE		= "%s on >%s< (%d)" --(args.spellName, args.destName, args.amount or 1)
}

----------------
--  Thaddius  --
----------------
L = DBM:GetModLocalization("Thaddius")

L:SetGeneralLocalization({
	name = "Thaddius"
})

L:SetMiscLocalization({
	Yell	= "Stalagg crush you!",
	Emote	= "%s overload!",
	Emote2	= "The Tesla Coils overload!",
	Boss1	= "Feugen",
	Boss2	= "Stalagg",
	Charge1 = "negative",
	Charge2 = "positive"
})

L:SetOptionLocalization({
	WarningChargeChanged	= "Show special warning when your polarity changed",
	WarningChargeNotChanged	= "Show special warning when your polarity did not change",
	ArrowsEnabled			= "Show arrows (normal \"2 camp\" strategy)",
	ArrowsRightLeft			= "Show left/right arrows for the \"4 camp\" strategy (show left arrow if polarity changed, right if not)",
	ArrowsInverse			= "Inverse \"4 camp\" strategy (show right arrow if polarity changed, left if not)"
})

L:SetWarningLocalization({
	WarningChargeChanged	= "Polarity changed to %s",
	WarningChargeNotChanged	= "Polarity did not change"
})

L:SetOptionCatLocalization({
	Arrows	= "Arrows"
})

----------------------------
--  Instructor Razuvious  --
----------------------------
L = DBM:GetModLocalization("Razuvious")

L:SetGeneralLocalization({
	name = "Instructor Razuvious"
})

L:SetMiscLocalization({
	Yell1 = "Show them no mercy!",
	Yell2 = "The time for practice is over! Show me what you have learned!",
	Yell3 = "Do as I taught you!",
	Yell4 = "Sweep the leg... Do you have a problem with that?",
	YellKnife = "Jagged Knife on me!"
})

L:SetOptionLocalization({
	WarningShieldWallSoon	= "Show pre-warning for Shield Wall ending"
})

L:SetWarningLocalization({
	WarningShieldWallSoon	= "Shield Wall ends in 5 seconds"
})

----------------------------
--  Gothik the Harvester  --
----------------------------
L = DBM:GetModLocalization("Gothik")

L:SetGeneralLocalization({
	name = "Gothik the Harvester"
})

L:SetOptionLocalization({
	TimerWave			= "Show timer for next wave",
	TimerPhase2			= "Show timer for Phase 2",
	WarningWaveSoon		= "Show pre-warning for wave",
	WarningWaveSpawned	= "Show warning for wave spawned",
	WarningRiderDown	= "Show warning when an Unrelenting Rider dies",
	WarningKnightDown	= "Show warning when an Unrelenting Death Knight dies"
})

L:SetTimerLocalization({
	TimerWave	= "Wave %d",
	TimerPhase2	= "Phase 2"
})

L:SetWarningLocalization({
	WarningWaveSoon		= "Wave %d: %s in 3 sec",
	WarningWaveSpawned	= "Wave %d: %s spawned",
	WarningRiderDown	= "Rider down",
	WarningKnightDown	= "Knight down",
	WarningPhase2		= "Phase 2"
})

L:SetMiscLocalization({
	yell			= "Foolishly you have sought your own demise.",
	WarningWave1	= "%d %s",
	WarningWave2	= "%d %s and %d %s",
	WarningWave3	= "%d %s, %d %s and %d %s",
	Trainee			= "Trainees",
	Knight			= "Knights",
	Rider			= "Riders"
})

---------------------
--  Four Horsemen  --
---------------------
L = DBM:GetModLocalization("Horsemen")

L:SetGeneralLocalization({
	name = "Four Horsemen"
})

L:SetOptionLocalization({
	WarningMarkSoon				= "Show pre-warning for Mark",
	WarningMarkNow				= "Show warning for Mark",
	SpecialWarningMarkOnPlayer	= "Show special warning when you are affected by more than 4 marks"
})

L:SetTimerLocalization({
})

L:SetWarningLocalization({
	WarningMarkSoon				= "Mark %d in 3 seconds",
	WarningMarkNow				= "Mark %d",
	SpecialWarningMarkOnPlayer	= "%s: %s"
})

L:SetMiscLocalization({
	Korthazz	= "Thane Korth'azz",
	Mograine	= "Highlord Mograine",
	Blaumeux	= "Lady Blaumeux",
	Zeliek		= "Sir Zeliek"
})

-----------------
--  Sapphiron  --
-----------------
L = DBM:GetModLocalization("Sapphiron")

L:SetGeneralLocalization({
	name = "Sapphiron"
})

L:SetOptionLocalization({
	WarningAirPhaseSoon	= "Show pre-warning for air phase",
	WarningAirPhaseNow	= "Announce air phase",
	WarningLanded		= "Announce ground phase",
	TimerAir			= "Show timer for air phase",
	TimerLanding		= "Show timer for landing",
	TimerIceBlast		= "Show timer for Frost Breath",
	WarningDeepBreath	= "Show special warning for Frost Breath",
	WarningIceblock		= "Yell on Ice Block"
})

L:SetMiscLocalization({
	EmoteBreath			= "Sapphiron takes a deep breath.",
	EmoteFlying			= "Sapphiron lifts off into the air!",
	EmoteLanding		= "Sapphiron resumes his attacks!",
	WarningYellIceblock	= "I'm an Ice Block!"
})

L:SetWarningLocalization({
	WarningAirPhaseSoon	= "Air phase in 10 seconds",
	WarningAirPhaseNow	= "Air phase",
	WarningLanded		= "Sapphiron landed",
	WarningDeepBreath	= "Frost Breath"
})

L:SetTimerLocalization({
	TimerAir		= "Air phase",
	TimerLanding	= "Landing",
	TimerIceBlast	= "Frost Breath"	
})

------------------
--  Kel'Thuzad  --
------------------

L = DBM:GetModLocalization("Kel'Thuzad")

L:SetGeneralLocalization({
	name = "Kel'Thuzad"
})

L:SetOptionLocalization({
	TimerPhase2		= "Show timer for Phase 2",
	specwarnP2Soon	= "Show special warning 10 seconds before Kel'Thuzad engages",
	warnAddsSoon	= "Show pre-warning for Guardians of Icecrown",
	ShowRange		= "Show range frame when Phase 2 starts"
})

L:SetMiscLocalization({
	Yell = "Minions, servants, soldiers of the cold dark! Obey the call of Kel'Thuzad!"
})

L:SetWarningLocalization({
	specwarnP2Soon	= "Kel'Thuzad engages in 10 Seconds",
	warnAddsSoon	= "Guardians of Icecrown incoming soon"
})

L:SetTimerLocalization({
	TimerPhase2	= "Phase 2"
})

