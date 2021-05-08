local mod	= DBM:NewMod("Kel'Thuzad", "DBM-Naxx", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2574 $"):sub(12, -3))
mod:SetCreatureID(15990)
mod:SetUsedIcons(8)
mod:RegisterCombat("yell", L.Yell)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START", --This should allow the addon to process this Event using the scripting from Anub'Rekhan for Impale.
	"SPELL_CAST_SUCCESS",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

----------PHASE 1----------
-----MAJOR ADD WAVE-----
local warnMajorWave		= mod:NewAnnounce("Major Wave Spawned", 2, 1003064, nil, "Show warning for Major Wave spawn")
local warnMajorWaveSoon	= mod:NewAnnounce("Major Wave Spawns Soon", 3, 1003064, nil, "Show pre-warning for Major Wave spawn")
local timerMajorWave	= mod:NewTimer(30, "Next Major Wave", 1003064, nil, "Show timer for Major Wave spawn")
-----CONSTRICTING CHAINS-----
local warnChains		= mod:NewTargetAnnounce(1003114, 2)
-----WAIL OF SOULS-----
local warnWailSoul		= mod:NewSpellAnnounce(1003115, 2)
-----PHASE 1 -> 2 TRANSITION-----
local warnPhase2		= mod:NewPhaseAnnounce(2, 3)
local timerPhase2		= mod:NewTimer(180, "Phase Two", 29485, nil, "Show timer for Phase Two")
-----PHASE 2 -> 3 TRANSITION-----
local warnPhase3		= mod:NewPhaseAnnounce(3, 3)
local timerPhase3		= mod:NewTimer(378, "Phase Three", 29485, nil, "Show timer for Phase Three")
----------PHASE 2----------
-----SHADE OF NAXXRAMAS-----
local warnNaxxShade		= mod:NewAnnounce("Shade of Naxx Spawned", 2, 25228, nil, "Show warning for Shade of Naxxramas spawn")
local warnNaxxShadeSoon	= mod:NewAnnounce("Shade of Naxx Spawns Soon", 3, 25228, nil, "Show pre-warning for Shade of Naxxramas spawn")
local timerNaxxShade	= mod:NewTimer(60, "Next Shade of Naxx", 25228, nil, "Show timer for Shade of Naxxramas spawn")
-----DISRUPTING SHOUT-----
local warnShout			= mod:NewSpellAnnounce(29107, 2)
local warnShoutSoon		= mod:NewSoonAnnounce(29107, 3)
local timerShout		= mod:NewCDTimer(16, 29107)
-----SEEING RED-----
local warnSeeingRed		= mod:NewSpellAnnounce(1003255, 2)
-----GASTRIC AFFLICTION-----
local warnGastric		= mod:NewTargetAnnounce(1003086, 2)
local specWarnGastric	= mod:NewSpecialWarningYou(1003086)
-----VOID ZONE-----
local specWarnVoid		= mod:NewSpecialWarningYou(28865)
-----SAFETY DANCE-----
local warnDanceSoon		= mod:NewAnnounce("Safety Dance Soon", 2, 46573, nil, "Show pre-warning for the Safetyy Dance")
local warnDance			= mod:NewAnnounce("Dance Ends Now", 3, 46573, nil, "Show warning for the Safety Dance")
local timerDance		= mod:NewTimer(22, "Safety Dance Starts", 46573, nil, "Show timer for the Safety Dance")
-----HARVEST SOUL-----
local warnHarvestSoon	= mod:NewSoonAnnounce(28679, 3)
local warnHarvest		= mod:NewSpellAnnounce(28679, 2)
local timerHarvest		= mod:NewNextTimer(15, 28679)
-----MAEXXNA SPIDERLINGS-----
local timerSpider		= mod:NewNextTimer(16, 43134)
-----NOTH'S SHADE (UNSCRIPTED)-----
local warnNothShade		= mod:NewAnnounce("Noth's Shade Spawned", 2, 1003072, nil, "Show warning for Noth's Shade spawn")
local timerNothShade	= mod:NewTimer(60, "Next Noth's Shade", 1003072, nil, "Show timer for Noth's Shade spawn")
-----FROST BLAST-----
local warnBlast			= mod:NewSpellAnnounce(29879, 2)
local timerBlast		= mod:NewCDTimer(16, 29879)
-----DETONATE MANA-----
local warnMana			= mod:NewSpellAnnounce(27819, 2)
local timerMana			= mod:NewCDTimer(30, 27819)
-----DEATH AND DECAY-----
local specWarnDnD		= mod:NewSpecialWarningYou(1003113)
-----CHAINS OF KEL'THUZAD-----
local warnChains		= mod:NewSpellAnnounce(28410, 2)
local timerChains		= mod:NewCDTimer(16, 28410)
-----RANGE CHECK-----
mod:AddBoolOption("ShowRange", true)
----------BOSS TRACKING----------
local anub
local faerlina
local maexx
local noth
local heigan
local loatheb
local razuv
local gothik
local horse
local patch
local grobb
local gluth
local thadd

local spiderHealth
local plagueHealth
local militaryHealth
local constructHealth

local spiderBoss
local plagueBoss
local militaryBoss
local constructBoss

local heiganDanceStart
----------MISC----------
local notRealRazuv		= 0
local hasShoutCast		= 0
local phase 			= 0
local shadesSpawned		= 0
local berserkTimer		= mod:NewBerserkTimer(1140)
-----CODE START-----
function mod:OnCombatStart(delay)
	mod:phaseOne()
	berserkTimer:Start(1140)
	notRealRazuv = 1
	self.vb.phase = 1
end

function mod:phaseOne()
	phase = 1
	anub = 0
	faerlina = 0
	maexx = 0
	noth = 0
	heigan = 0
	loatheb = 0
	razuv = 0
	gothik = 0
	horse = 0
	patch = 0
	grobb = 0
	gluth = 0
	thadd = 0
	spiderBoss = 0
	plagueBoss = 0
	militaryBoss = 0
	constructBoss = 0
	heiganDanceStart = 0
	shadesSpawned = 0
	hasShoutCast = 0
	DBM.RangeCheck:Hide()
	mod:phase2Transition()
	mod:timerMajorWaveRepeat()
	self:ScheduleMethod(30, "timerMajorWaveRepeat")
	self:ScheduleMethod(60, "timerMajorWaveRepeat")
	self:ScheduleMethod(90, "timerMajorWaveRepeat")
end

function mod:timerMajorWaveRepeat()
	timer = 30
	warnMajorWave:Schedule(timer)
	warnMajorWaveSoon:Schedule(timer-5)
	timerMajorWave:Start(timer)
end

function mod:phase2Transition()
	timer = 180
	warnPhase2:Schedule(timer)
	warnPhase2Soon:Schedule(timer-10)
	timerPhase2:Start(timer)
	self:ScheduleMethod(timer, "phaseTwo")
end

function mod:phaseTwo()
	phase = 2	
	self.vb.phase = 2
	if self.Options.ShowRange then
		mod:RangeTogglePhaseTwo()
	end
	-----SHADE SPAWNS-----
	-- mod:timerNaxxShadeRepeat()
	mod:phase3Transition()
	-- timer = 34
	-- self:ScheduleMethod(timer, "timerNaxxShadeRepeat")
	-- self:ScheduleMethod(timer+60, "timerNaxxShadeRepeat")
	-- self:ScheduleMethod(timer+120, "timerNaxxShadeRepeat")
	-----HEALTH CHECK DEBUGS-----
	-- local shade1 = UnitGUID("boss1")
	-- local shade2 = UnitGUID("boss2")
	-- local shade3 = UnitGUID("boss3")
	-- local shade4 = UnitGUID("boss4")
	-- mod:checkHealth()
end

function mod:phase3Transition()
	timer = 600
	warnPhase3:Schedule(timer)
	warnPhase3Soon:Schedule(timer-10)
	timerPhase3:Start(timer)
	self:ScheduleMethod(timer, "phaseThree")
end

function mod:phaseThree()
	phase = 3
	self.vb.phase = 3
	if self.Options.ShowRange then
		mod:RangeTogglePhaseThree()
	end
	timerBlast:Start(45)
	timerMana:Start(30)
	timerChains:Start(90)
end

function mod:SPELL_CAST_START()
	if args:IsSpellID(28478) and phase == 2 then
		self:Unschedule("warnPhase3")
		self:Unschedule("warnPhase3Soon")
		self:UnscheduleMethod("phaseThree")
		timerPhase3:Stop()
		mod:phaseThree()
	end
end

-- function mod:timerNaxxShadeRepeat()
-- 	if shadesSpawned == 0 then
-- 		timer = 34
-- 		warnNaxxShade:Schedule(timer)
-- 		warnNaxxShadeSoon:Schedule(timer-10)
-- 		timerNaxxShade:Start(timer)
-- 		shadesSpawned = shadesSpawned+1
-- 		warnShout:Schedule(timer+16)
-- 		warnShoutSoon:Schedule(timer+11)
-- 		timerShout:Start(timer+16)
-- 	else
-- 		timer = 60
-- 		warnNaxxShade:Schedule(timer)
-- 		warnNaxxShadeSoon:Schedule(timer-10)
-- 		timerNaxxShade:Start(timer)
-- 		shadesSpawned = shadesSpawned+1
-- 		if hasShoutCast == 0 then
-- 			warnShout:Schedule(timer+16)
-- 			warnShoutSoon:Schedule(timer+11)
-- 			timerShout:Start(timer+16)
-- 		end
-- 	end
-- end

function mod:SPELL_AURA_APPLIED(args)
	-----CONSTRICTING CHAINS-----
	if args:IsSpellID(1003114) then
		warnChains:Show(args.destName)
		if args.destName == UnitName("player") then
		end
	end
	-----HARVEST SOUL-----
	if args:IsSpellID(28679) then 
		if args:IsPlayer() then
			timer = 15
			warnHarvestSoon:Schedule(timer-5)
			warnHarvest:Schedule(timer)
			timerHarvest:Start(timer)
		end
	end
	-----SEEING RED-----
	if args:IsSpellID(1003255) then
		warnSeeingRed:Show()
	end
	-----GASTRIC AFFLICTION-----
	if args:IsSpellID(1003086) then
		warnGastric:Show(args.destName)
		if args.destName == UnitName("player") then
			specWarnGastric:Show()
		end
	end
	-----VOID ZONE-----
	if args:IsSpellID(28865) then
		if args.destName == UnitName("player") then
			specWarnVoid:Show()
		end
	end
	-----DEATH AND DECAY-----
	if args:IsSpellID(1003113) then
		if args.destName == UnitName("player") then
			specWarnDnD:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	-----HARVEST SOUL-----
	if args:IsSpellID(28679) then 
		if args:IsPlayer() then
			timer = 15
			warnHarvestSoon:Schedule(timer-5)
			warnHarvest:Schedule(timer)
			timerHarvest:Start(timer)
		end
	end
	-----GASTRIC AFFLICTION-----
	if args:IsSpellID(1003086) then
		warnGastric:Show(args.destName)
		if args.destName == UnitName("player") then
			specWarnGastric:Show()
		end
	end
	-----VOID ZONE-----
	if args:IsSpellID(28865) then
		if args.destName == UnitName("player") then
			specWarnVoid:Show()
		end
	end
	-----DEATH AND DECAY-----
	if args:IsSpellID(1003113) then
		if args.destName == UnitName("player") then
			specWarnDnD:Show()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	----------SPELL TRACKING----------
	-----DISRUPTING SHOUT-----
	if args:IsSpellID(29107) then
		if notRealRazuv == 1 then
			timer = 16
			warnShout:Show()
			warnShoutSoon:Schedule(timer-5)
			timerShout:Start(timer)
			hasShoutCast = 1
		end
	-----WAIL OF SOULS-----
	elseif args:IsSpellID(1003115) then
		warnWailSoul:Show()
	-----FROST BLAST-----
	elseif args:IsSpellID(29879) then 
		warnBlast:Show()
		timerBlast:Start(45)
	-----MANA DETONATION-----
	elseif args:IsSpellID(27819) then
		warnMana:Show()
		timerMana:Start(30)
	-----CHAINS-----
	elseif args:IsSpellID(28410) then
		warnChains:Show()
		timerChains:Start(90)
	end
	--[[
	----------BOSS CHECKING TOOLS----------
	-----ANUB-----
	if args:IsSpellID(28783) and args:sourceGUID(shade1) and spiderBoss == 0 then
		spiderBoss = 1
		anub = 1
	elseif args:IsSpellID(28783) and args:sourceGUID(shade2) and spiderBoss == 0 then
		spiderBoss = 2
		anub = 2
	elseif args:IsSpellID(28783) and args:sourceGUID(shade3) and spiderBoss == 0 then
		spiderBoss = 3
		anub = 3
	elseif args:IsSpellID(28783) and args:sourceGUID(shade4) and spiderBoss == 0 then
		spiderBoss = 4
		anub = 4
	end
	-----NOTH-----
	if args:IsSpellID(29213) and args:sourceGUID(shade1) and plagueBoss == 0 then
		plagueBoss = 1
		noth = 1
	elseif args:IsSpellID(29213) and args:sourceGUID(shade2) and plagueBoss == 0 then
		plagueBoss = 2
		noth = 2
	elseif args:IsSpellID(29213) and args:sourceGUID(shade3) and plagueBoss == 0 then
		plagueBoss = 3
		noth = 3
	elseif args:IsSpellID(29213) and args:sourceGUID(shade4) and plagueBoss == 0 then
		plagueBoss = 4
		noth = 4
	end
	-----RAZUVIOUS-----
	if args:IsSpellID(29107) and args:sourceGUID(shade1) and militaryBoss == 0 then
		militaryBoss = 1
		razuv = 1
	elseif args:IsSpellID(29107) and args:sourceGUID(shade2) and militaryBoss == 0 then
		militaryBoss = 2
		razuv = 2
	elseif args:IsSpellID(29107) and args:sourceGUID(shade3) and militaryBoss == 0 then
		militaryBoss = 3
		razuv = 3
	elseif args:IsSpellID(29107) and args:sourceGUID(shade4) and militaryBoss == 0 then
		militaryBoss = 4
		razuv = 4
	end
	-----PATCHWERK-----
	if args:IsSpellID(28308) and args:sourceGUID(shade1) and constructBoss == 0 then
		constructBoss = 1
		patch = 1
	elseif args:IsSpellID(28308) and args:sourceGUID(shade2) and constructBoss == 0 then
		constructBoss = 2
		patch = 2
	elseif args:IsSpellID(28308) and args:sourceGUID(shade3) and constructBoss == 0 then
		constructBoss = 3
		patch = 3
	elseif args:IsSpellID(28308) and args:sourceGUID(shade4) and constructBoss == 0 then
		constructBoss = 4
		patch = 4
	end
	]]--
end

function mod:UNIT_HEALTH(uId)
	--[[
	if phase == 2 then
		-----SPIDER WING-----
		if spiderBoss == 1 then
			spiderHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
		elseif spiderBoss == 2 then
			spiderHealth = math.max(0, UnitHealth("boss2")) / math.max(1, UnitHealthMax("boss2")) * 100;
		elseif spiderBoss == 3 then
			spiderHealth = math.max(0, UnitHealth("boss3")) / math.max(1, UnitHealthMax("boss3")) * 100;
		elseif spiderBoss == 4 then
			spiderHealth = math.max(0, UnitHealth("boss4")) / math.max(1, UnitHealthMax("boss4")) * 100;
		end
		-----PLAGUE WING-----
		if plagueBoss == 1 then
			plagueHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
		elseif plagueBoss == 2 then
			plagueHealth = math.max(0, UnitHealth("boss2")) / math.max(1, UnitHealthMax("boss2")) * 100;
		elseif plagueBoss == 3 then
			plagueHealth = math.max(0, UnitHealth("boss3")) / math.max(1, UnitHealthMax("boss3")) * 100;
		elseif plagueBoss == 4 then
			plagueHealth = math.max(0, UnitHealth("boss4")) / math.max(1, UnitHealthMax("boss4")) * 100;
		end
		-----MILITARY WING-----
		if militaryBoss == 1 then
			militaryHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
		elseif militaryBoss == 2 then
			militaryHealth = math.max(0, UnitHealth("boss2")) / math.max(1, UnitHealthMax("boss2")) * 100;
		elseif militaryBoss == 3 then
			militaryHealth = math.max(0, UnitHealth("boss3")) / math.max(1, UnitHealthMax("boss3")) * 100;
		elseif militaryBoss == 4 then
			militaryHealth = math.max(0, UnitHealth("boss4")) / math.max(1, UnitHealthMax("boss4")) * 100;
		end
		-----CONSTRUCT WING-----
		if constructBoss == 1 then
			constructHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
		elseif constructBoss == 2 then
			constructHealth = math.max(0, UnitHealth("boss2")) / math.max(1, UnitHealthMax("boss2")) * 100;
		elseif constructBoss == 3 then
			constructHealth = math.max(0, UnitHealth("boss3")) / math.max(1, UnitHealthMax("boss3")) * 100;
		elseif constructBoss == 4 then
			constructHealth = math.max(0, UnitHealth("boss4")) / math.max(1, UnitHealthMax("boss4")) * 100;
		end
	end
	]]--
end

function mod:checkHealth()
	--[[
	if phase == 2 then
		self:ScheduleMethod(1, checkHealth)
	end
	-----SPIDER WING-----
	if spiderHealth < 67 then
		anub = spiderBoss
	elseif spiderHealth > 67 and spiderHealth < 34 then
		anub = 0 
		faerlina = spiderBoss
	elseif spiderHealth > 34 and spiderHealth < 1 then
		faerlina = 0
		maexx = spiderBoss
		timer = 8
		timerSpider:Start(timer)
		self:ScheduleMethod(timer, "spiderTimerRepeat")
	elseif spiderHealth == 0 then
		maexx = 0
	end
	-----PLAGUE WING-----
	if plagueHealth < 67 then
		noth = plagueBoss
	elseif plagueHealth > 67 and plagueHealth < 34 then
		noth = 0 
		heigan = plagueBoss
		if heiganDanceStart == 0 then
			heiganDanceStart = 1
			timer = 21
			timerDance:Start(timer)
			warnDance:Schedule(timer)
			warnDanceSoon:Schedule(timer-5)
		end		
	elseif plagueHealth > 34 and spiderHealth < 1 then
		heigan = 0
		loatheb = plagueBoss
	elseif plagueHealth == 0 then
		loatheb = 0
	end
	-----MILITARY WING-----
	if militaryHealth < 67 then
		razuv = militaryBoss
	elseif militaryHealth > 67 and militaryHealth < 34 then
		razuv = 0 
		gothik = militaryBoss
		timer = 15
		warnHarvestSoon:Schedule(timer-5)
		warnHarvest:Schedule(timer)
		timerHarvest:Start(timer)
	elseif militaryHealth > 34 and militaryHealth < 1 then
		gothik = 0
		horse = militaryBoss
		warnHarvestSoon:Cancel()
		warnHarvest:Cancel()
		timerHarvest:Stop()
	elseif militaryHealth == 0 then
		horse = 0
	end
	-----CONSTRUCT WING-----
	if constructHealth < 75 then
		patch = constructBoss
	elseif constructHealth > 75 and constructHealth < 50 then
		patch = 0 
		grobb = constructBoss
	elseif constructHealth > 50 and constructHealth < 25 then
		grobb = 0 
		gluth = constructBoss
	elseif constructHealth > 25 and constructHealth < 1 then
		gluth = 0
		thadd = constructBoss
	elseif constructHealth == 0 then
		thadd = 0
	end
	]]--
end

function mod:spiderTimerRepeat()
	if maexx == 0 then
	else
		timer = 16
		timerSpider:Start(timer)
		self:ScheduleMethod(timer, "spiderTimerRepeat")
	end
end

function mod:RangeTogglePhaseTwo(show)
	if show then
		DBM.RangeCheck:Show(15)
	else
		DBM.RangeCheck:Hide()
	end
end

function mod:RangeTogglePhaseThree(show)
	if show then
		DBM.RangeCheck:Show(10)
	else
		DBM.RangeCheck:Hide()
	end
end
