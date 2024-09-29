local mod	= DBM:NewMod("Kil", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25657, 25588, 25696, 25315)
mod:SetUsedIcons(4, 5, 6, 7, 8)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_INTERRUPT",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_SAY",
	"UNIT_HEALTH",
	"UNIT_DIED"
)
--Phase 1
-- Apolyon
local warnSoulbomb 					= mod:NewTargetAnnounce(2146682, 2)
local YellSoulbomb 					= mod:NewFadesYell(2146682)
local timerTargetSoulbomb 			= mod:NewTargetTimer(10, 2146682)
local timerNextSoulbomb 			= mod:NewNextTimer(10, 2146682)

local warnSoulrend 					= mod:NewSpellAnnounce(2146680, 2) -- 2146680 Spell_cast_Start
local timerNextSoulRend 			= mod:NewNextTimer(30, 2146680) -- 2146680 Spell_cast_Start (20 yard radius)
local timerCastSoulRend				= mod:NewCastTimer(3, 2146680) -- 2146680 Spell_cast_Start

-- Agamath	
-- local warnRagingBlow 				= mod:NewSpellAnnounce(2146684, 3)
local timerNextRagingBlow 			= mod:NewNextTimer(10, 2146684)

local warnFelRage 					= mod:NewTargetAnnounce(2146688, 2)
local timerFelRage 					= mod:NewTargetTimer(5, 2146688)

-- Archonisus	
local warnSummonWildImps 			= mod:NewSpellAnnounce(2146676, 3) -- 2146676 Spell_cast_Start
local timerNextSummonWildImps 		= mod:NewNextTimer(31, 2146676) -- 2146676 Spell_cast_Start
local timerCastImplosion 			= mod:NewCastTimer(31, 2146691)
local warnImplosion 				= mod:NewSpellAnnounce(2146691, 3) -- Spell_Damage 2146691

local warnSpecYouConflag			= mod:NewSpecialWarningYou(2146673)
local warnTargetConflag 			= mod:NewTargetAnnounce(2146673, 3)
local timerTargetConflag			= mod:NewTargetTimer(2.85, 2146673)

-- make warnings and timers for 	these, and make the trigger in their respective functions
-- Change all args.spellID into 	args:IsSpellID() with comma separated for the spellIDs

local berserkTimer					= mod:NewBerserkTimer(900)
local warnPhaseSoon					= mod:NewAnnounce("WarnPhaseSoon", 2, nil)
local warnPhase						= mod:NewAnnounce("WarnPhase", 2, nil)

-- overall KJ
-- KJ timers	
local timerEmerge					= mod:NewTimer(18,"Kil'Jaeden is emerging", nil)

local timerTargetLegionLightning	= mod:NewTargetTimer(2.85, 2146510) -- 2146510, 2146511 Spell_cast_start
local warnTargetLegionLightning		= mod:NewTargetAnnounce(2146510, 2) -- 2146510, 2146511 Spell_cast_start
local warnSpecYouLegionLightning	= mod:NewSpecialWarningYou(2146510) -- 2146510, 2146511 Spell_cast_start

local timerNextFireBloom			= mod:NewNextTimer(30, 2146523) -- 2146523, 2146524, 2146525, 2146526 Spell_cast_start
local timerCastFireBloom			= mod:NewCastTimer(1.4, 2146523)
local timerTargetFireBloom			= mod:NewTargetTimer(15, 2146524) -- 2146523, 2146524, 2146525, 2146526 Spell_cast_start
local specwarnFireBloom				= mod:NewSpecialWarningYou(2146524)
local warnFireBloomTargets			= mod:NewTargetAnnounce(2146524, 2)
local yellFireBloom					= mod:NewFadesYell(2146524)

local warnReflections				= mod:NewSpellAnnounce(2146538, 3) -- 2146522 Spell_cast_start
local timerNextReflections			= mod:NewNextTimer(60, 2146538) -- 2146522 Spell_cast_start

local timerNextWorldBreaker 		= mod:NewNextTimer(30, 2146515) -- 2146519, 2146520 Spell_cast_start
local warnWorldBreaker				= mod:NewSpellAnnounce(2146515, 1) -- 2146519, 2146520 Spell_cast_start
local timerWorldBreaker				= mod:NewTimer(1.4, "TimerWorldBreaker", 2146515)

-- Events
local timerNextMiniEvent			= mod:NewTimer(60, "Next random Mini-Event", nil)

local warnDarkness 					= mod:NewSpellAnnounce(2146540, 3) -- 2146540, 2146541, 2146542 Spell_cast_start
local timerNextDarkness				= mod:NewNextTimer(55, 2146540) -- 2146540, 2146541, 2146542 Spell_cast_start
local timerCastDarkness				= mod:NewCastTimer(9, 2146540)

local timerDragonOrb				= mod:NewTimer(60, "Dragon Orb active in", nil)
local warnDragonOrb					= mod:NewAnnounce("Dragon Orb activated!", 3, nil)

-- Phase 2
local timerCastAllConsuming	 		= mod:NewCastTimer(2, 2146521) -- 2146521 Spell_cast_start
local timerDurAllConsuming			= mod:NewTimer(85, "The All Consuming Darkness duration", 2146521)
local specWarnConsumingDarkness		= mod:NewSpecialWarningMove(2146554, 2)

local timerCastAnnihilate			= mod:NewCastTimer(4, 2146555) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start
local warnAnnihilate				= mod:NewSpellAnnounce(2146555, 2) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start
local timerChannelAnnihilate		= mod:NewTimer(50, "Annihilate duration",2146555) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start
local timerNextAnnihilate			= mod:NewNextTimer(96, 2146555) -- 2146555, 2146556, 2146557, 2146560 Spell_cast_start

-- phase 3
local warnObliterate				= mod:NewSpellAnnounce(2146575, 3)	-- 2146575, 2146576, 2146578 Spell_cast_start
local timerCastObliterate			= mod:NewCastTimer(4, 2146575)	-- 2146575, 2146576, 2146578 Spell_cast_start
local timerObliterateEvent			= mod:NewTimer(54, "Obliterate Event duration", 2146575)
local warnObliterateCount			= mod:NewAnnounce("%s Obliterate remaining", 2146575)

-- phase 4
local warnArmageddon				= mod:NewSpellAnnounce(2146581, 3)
local timerCastArmageddon			= mod:NewCastTimer(2, 2146581)
local timerChannelArmageddon		= mod:NewTimer(50, "Armageddon duration", 2146581)
local timerCastFirestorm			= mod:NewCastTimer(4, 2146585)

-- Everything else
local fireBloomTargets = {}
local fireBloomIcon = 6
local obliterateCount
local worldbreaker
local longObliterateDone = false

self.vb.phase = 1

-- Need to add: timerTargetBlueFight (Dragon form, 1 minute, 2146650) [not in combatlog]
-- seperate triggers for Main Event and Mini Event? [yes]
-- Correct timers after transition [p2 and p3 timers working] -- fix p4 and p5 [yes]
-- some kind of self.vb.phase == 6 for next Darkness cast (after mini-events or after last orb) 
-- Orb timer into each phase [yes]
-- add special warning if you walk into the All Consuming Darkness [yes]

local function WarnFireBloomTargets()
	warnFireBloomTargets:Show(table.concat(fireBloomTargets, "<, >"))
	table.wipe(fireBloomTargets)
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	timerNextSoulbomb:Start(5-delay)
	timerNextSoulRend:Start(20-delay)
	obliterateCount = 0
	worldbreaker = 0
	longObliterateDone = false
end

local function CancelTimers()
	timerNextWorldBreaker:Cancel()
	timerNextFireBloom:Cancel()
	timerNextReflections:Cancel()
	timerNextDarkness:Cancel()
	timerNextMiniEvent:Cancel()
end

function mod:LegionLightningTarget()
	local target = nil
	target = mod:GetBossTarget(25315)
	if target == UnitName("player") then
		warnSpecYouLegionLightning:Show()
	else
		warnTargetLegionLightning:Show(target)
	end
	timerTargetLegionLightning:Start(target)
	self:SetIcon(target, 8, 3)
end

function mod:ConflagTarget()
	local conflagTarget = nil
	conflagTarget = mod:GetBossTarget(25696)
	if conflagTarget == UnitName("player") then
		warnSpecYouConflag:Show()
	else
		warnTargetConflag:Show(conflagTarget)
	end
	timerTargetConflag:Start(conflagTarget)
	self:SetIcon(conflagTarget, 8, 3)
end

function mod:SPELL_CAST_START(args)
	if self.vb.phase == 1 then
		if args:IsSpellID(2146680) then
			warnSoulrend:Show()
			timerNextSoulRend:Start()
			timerCastSoulRend:Start()
		elseif args:IsSpellID(2146684) then
			-- warnRagingBlow:Show()
			timerNextRagingBlow:Start()
		elseif args:IsSpellID(2146673) then
			self:ScheduleMethod(0.15,"ConflagTarget");
		elseif args:IsSpellID(2146676) then
			warnSummonWildImps:Show()
			timerNextSummonWildImps:Start()
			timerCastImplosion:Start()
			warnImplosion:Schedule(27)
		end
	elseif self.vb.phase >= 2 and args.sourceName == "Kil'jaeden" then
		if args:IsSpellID(2146509) then
			self:ScheduleMethod(0.15,"LegionLightningTarget");
		elseif args:IsSpellID(2146515, 2146516) and args.sourceName =="Kil'jaeden" then
			if worldbreaker == 0 then
				timerWorldBreaker:Start("Knockup")
				timerNextWorldBreaker:Start()
				worldbreaker = 1
			else
				timerWorldBreaker:Start("Knockback")
				worldbreaker = 0
			end
			warnWorldBreaker:Show()
		elseif args:IsSpellID(2146538) then
			warnReflections:Show()
			if self.vb.phase == 2 then
				timerNextReflections:Start(60)
			elseif self.vb.phase == 6 and DBM:AntiSPam(15, 1) then
				timerNextMiniEvent:Start()
				timerNextDarkness:Start(20)
			else
				timerNextMiniEvent:Start()
			end
		elseif args:IsSpellID(2146523) then
			timerNextFireBloom:Start()
			timerCastFireBloom:Start()
		elseif args:IsSpellID(2146555) then
			timerChannelAnnihilate:Schedule(4)
			timerNextDarkness:Schedule(45, 20)
			timerNextFireBloom:Schedule(50, 28)
			timerNextWorldBreaker:Schedule(50, 35)
			timerNextMiniEvent:Schedule(50,48)
			timerDragonOrb:Start(59)
		elseif args:IsSpellID(2146560) then
			timerCastAnnihilate:Start()
			warnAnnihilate:Show()
			timerChannelAnnihilate:Schedule(4, 11)
			timerNextMiniEvent:Start(60)
			if self.vb.phase == 6 and DBM:AntiSPam(15, 2) then
				timerNextDarkness:Start(20)
			end
		elseif args:IsSpellID(2146521) then
			timerCastAllConsuming:Start()
		elseif args:IsSpellID(2146540) then
			warnDarkness:Show()
			timerCastDarkness:Start()
		elseif args:IsSpellID(2146575) then
			warnObliterate:Show()
			timerCastObliterate:Start()
			longObliterateDone = false
		elseif args:IsSpellID(2146576) then
			timerCastObliterate:Start()
			if not longObliterateDone and obliterateCount < 9 then
				warnObliterateCount:Show(10 - obliterateCount)
				obliterateCount = obliterateCount + 1
			elseif not longObliterateDone and obliterateCount == 9 then
				warnObliterateCount:Show(1)
				obliterateCount = 0
				longObliterateDone = true
			elseif longObliterateDone and obliterateCount < 3 then
				warnObliterateCount:Show(3 - obliterateCount)
				obliterateCount = obliterateCount + 1
			elseif longObliterateDone and obliterateCount == 2 then
				warnObliterateCount:Show(1)
				obliterateCount = 0
			end
			if self.vb.phase == 6 and DBM:AntiSpam(15, 3) then
				timerNextDarkness:Start(20)
			end
		elseif args:IsSpellID(2146581) then
			warnArmageddon:Show()
			timerCastArmageddon:Start()
			timerChannelArmageddon:Schedule(2)
			timerNextDarkness:Schedule(45,15)
			timerNextFireBloom:Schedule(50,15)
			timerNextWorldBreaker:Schedule(50,20)
		elseif args:IsSpellID(2146590) then
			warnArmageddon:Show()
			timerCastArmageddon:Start()
			timerChannelArmageddon:Schedule(2, 10)
			timerNextMiniEvent:Start()
			if self.vb.phase == 6 and DBM:AntiSpam(15, 4) then
				timerNextDarkness:Start(20)
			end
		end
	end
end

function mod:SPELL_INTERRUPT(args)
	if (args.extraSpellId == 2146673 or args.spellId ==  2146673) and args.destName == "Archonisus" then
		-- warnSpecYouConflag:Hide()
		-- warnTargetConflag:Hide()
		timerTargetConflag:Cancel()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if self.vb.phase == 1 then
		if args:IsSpellID(2146688) then
			warnFelRage:Show(args.destName)
			timerFelRage:Start(args.destName)
		elseif args:IsSpellID(2146681) then
			if args:IsPlayer() then
				YellSoulbomb:Countdown(10, 3)
			end
			warnSoulbomb:Show(args.destName)
			timerNextSoulbomb:Start()
			timerTargetSoulbomb:Start(args.destName)
		end
	else
		if args:IsSpellID(2146524) and args.sourceName == "Kil'jaeden" then
			fireBloomTargets[#fireBloomTargets + 1] = args.destName
			if args:IsPlayer() then
				specwarnFireBloom:Show()
				yellFireBloom:Countdown(15,3)
			end
			timerTargetFireBloom:Start(args.destName)
			self:SetIcon(args.destName, fireBloomIcon, 60)
			fireBloomIcon = fireBloomIcon - 1
			self:Unschedule(WarnFireBloomTargets)
			self:Schedule(0.2, WarnFireBloomTargets)
		elseif args:IsSpellID(2146554) and args:IsPlayer() and DBM:AntiSpam(5, 5) then
			specWarnConsumingDarkness:Show()
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID() and args.sourceName == "Kil'jaeden" then
		self:SetIcon(args.destName, 0)
		fireBloomIcon = fireBloomIcon + 1
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Phase2KJ or msg:find(L.Phase2KJ) then
		self.vb.phase = 2
		warnPhase:Show(2)
		berserkTimer:Start()
		timerEmerge:Start()
		timerNextFireBloom:Start(28)
		timerNextWorldBreaker:Start(33)
		timerNextReflections:Start(43)
	elseif msg == L.Phase3KJ or msg:find(L.Phase3KJ) then
		self.vb.phase = 3
		warnPhase:Show(3)
		self:Schedule(0, CancelTimers)
		timerCastAllConsuming:Start()
		timerNextAnnihilate:Start(28)
		timerDurAllConsuming:Schedule(3)
	elseif msg == L.Phase4KJ or msg:find(L.Phase4KJ) then
		self.vb.phase = 4
		warnPhase:Show(4)
		self:Schedule(0, CancelTimers)
		timerObliterateEvent:Start(45)
		timerNextDarkness:Schedule(45,10)
		timerNextFireBloom:Schedule(45, 24)
		timerNextWorldBreaker:Schedule(45, 29)
		timerNextMiniEvent:Schedule(45, 43)
		timerDragonOrb:Start(51)
	elseif msg == L.Phase5KJ or msg:find(L.Phase5KJ) then
		self.vb.phase = 5
		warnPhase:Show(5)
		self:Schedule(0, CancelTimers)
		timerNextDarkness:Schedule(45,19)
		timerCastFirestorm:Schedule(54, 24)
		timerNextWorldBreaker:Schedule(54, 29)
		timerNextMiniEvent:Schedule(54,44)
		timerDragonOrb:Start(59)
	elseif msg == L.Phase6KJ or msg:find(L.Phase6KJ) then
		self.vb.phase = 6
		warnPhase:Show(6)
		self:Schedule(0, CancelTimers)
		timerDragonOrb:Start(20)
		timerNextDarkness:Start(25)
		timerNextFireBloom:Start(39)
		timerNextWorldBreaker:Start(44)
		timerNextMiniEvent:Start(59)
	elseif msg == L.OrbYell1 or msg:find(L.OrbYell1) or
	    msg == L.OrbYell2 or msg:find(L.OrbYell2) or
	    msg == L.OrbYell3 or msg:find(L.OrbYell3) or
	    msg == L.OrbYell4 or msg:find(L.OrbYell4) then
		warnDragonOrb:Show()
	end
end
mod.CHAT_MSG_MONSTER_SAY = mod.CHAT_MSG_MONSTER_YELL

function mod:UNIT_HEALTH(unit)
	if self:GetUnitCreatureId(unit) == 25315 then
	local health = DBM_UnitHealthPercent(unit)
		if health <= 84 and self.vb.phase == 2 and DBM:AntiSpam(35, 6) then
			warnPhaseSoon:Show(3)
		elseif health <= 64 and self.vb.phase == 3 and DBM:AntiSpam(35, 6) then
			warnPhaseSoon:Show(4)
		elseif health <= 44 and self.vb.phase == 4 and DBM:AntiSpam(35, 6) then
			warnPhaseSoon:Show(5)
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 25588 then -- 
		timerNextSoulbomb:Stop()
		timerNextSoulRend:Stop()
	elseif cid == 25657 then -- Agamath
		timerNextRagingBlow:Stop()
		timerFelRage:Stop()
	elseif cid == 25696 then -- Archonisus
		timerNextSummonWildImps:Stop()
	end
end