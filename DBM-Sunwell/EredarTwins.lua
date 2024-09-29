local mod	= DBM:NewMod("Twins", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25165, 25166)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
    "CHAT_MSG_MONSTER_YELL",
    "CHAT_MSG_MONSTER_EMOTE",
    "CHAT_MSG_RAID_BOSS_EMOTE",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_RAID_WARNING",
	"UNIT_HEALTH"
)

mod:SetBossHealthInfo(
	25165, L.Sacrolash,
	25166, L.Alythess
)

--phase 1
local timerDance					= mod:NewTimer(15,"Fire Dance/Dawn Runner", 2145929)
local timerTwinFade					= mod:NewTimer(10, "The strongest Twin remains", 148477)
	
-- Alythess Phase
local warnSolarBurn					= mod:NewSpecialWarningStack(2145905, nil, 4) -- 2145905, 2145906 spell_aura_applied
local timerFlingAlyth				= mod:NewTargetTimer(1, 2145916)
local warnFireDance					= mod:NewSpellAnnounce(2145928, 3) -- 2145928 	
local timerFireDance				= mod:NewNextTimer(30, 2145928)

-- Sacrolash abilities in Aly phase
local timerCrescentMoonKick			= mod:NewTargetTimer(2, 2146019)
--local warnLunarFlare				= mod:NewAnnounce(,2146007, 3) -- 2145907, 2145908
local warnCrushingShadow			= mod:NewSpellAnnounce(2146029, 3) -- 2146030 spell_Cast_start
local timerCrushingShadow			= mod:NewNextTimer(29,2146029)

-- Sacrolash Phase 
local warnLunarBurn					= mod:NewAnnounce("WarnLunarStacks", 2, 2146005)
local warnFling						= mod:NewTargetAnnounce(2146016, 3) -- 2146017 spell_Cast_start 40s CD, Unless pushed back
local timerFlingSacro				= mod:NewTargetTimer(1, 2146016)
local warnDawnRunner				= mod:NewSpellAnnounce(2146027, 3)
local timerDawnRunner				= mod:NewNextTimer(30, 2146027)

-- Alythess abilities in Sacro phase
local timerRisingSunKick			= mod:NewTargetTimer(2, 2145919)
--local warnSolarFlare				= mod:NewSpellAnnounce(2145907, 3) -- 2145907, 2145908
local warnFlashBurn					= mod:NewSpellAnnounce(2145929, 3) -- 2145929, 2145930, 2145931 spell_Cast_start
local timerFlashBurn				= mod:NewNextTimer(29, 2145929)

-- Sacro'lythess
local warnDawnDancer				= mod:NewSpellAnnounce(2145927)
local timerDawnDancer				= mod:NewNextTimer(30, 2145927)
-- everything else
local timerSacroTankCombo			= mod:NewTimer(30, "Sacrolash Tank combination", 2146016)
local timerAlythTankCombo			= mod:NewTimer(30, "Alythess Tank combination", 2145916)
local timerCrashCombination			= mod:NewTimer(4, "Falling Star and Crashing Moon", 2145922)
local warnCrashCombination			= mod:NewAnnounce("Falling Star and Crashing Moon", 2145922)
local timerCutCombination			= mod:NewTimer(5, "Crescent Moon and Rising Sun Cut", 2146025)
local warnCutCombination			= mod:NewAnnounce("Crescent Moon and Rising Sun Cut", 2146025)

local timerRoleReversal				= mod:NewTimer(5, "Role Reversal RP", 992179)
local timerTagTeam					= mod:NewTimer(5, "Both Twins are emerging", 992179)
local timerTwinsMerge				= mod:NewTimer(5, "The Twins are merging", 992179)
local berserkTimer					= mod:NewBerserkTimer(600)

local sacroPath = false
local alythPath = false


function mod:OnCombatStart(delay)
	self.vb.phase = 1
	sacroPath = false
	alythPath = false
	timerDance:Start(-delay)
	timerTwinFade:Start(-delay)
	berserkTimer:Start(-delay)
end


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2145905) and args:IsPlayer() then
		if args.amount then
			warnSolarBurn:Show(args.amount)
		end
	elseif args:IsSpellID(2146005) and args:IsPlayer() then
		if args.amount and (args.amount == 4 or args.amount >= 8) then
			warnLunarBurn:Show(args.spellName, args.amount or 1)
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:CancelTimers()
	timerDance:Cancel()
	timerAlythTankCombo:Cancel()
	timerSacroTankCombo:Cancel()
	timerFireDance:Cancel()
	timerDawnRunner:Cancel()
	timerCrushingShadow:Cancel()
	timerFlashBurn:Cancel()
	self:UnscheduleMethod("FireDance")
	self:UnscheduleMethod("DawnRunner")
end

function mod:FireDance()
	self:UnscheduleMethod("FireDance")
	warnFireDance:Show()
	timerFireDance:Start()
	self:ScheduleMethod(31,"FireDance")
end

function mod:DawnRunner()
	self:UnscheduleMethod("DawnRunner")
	warnDawnRunner:Show()
	timerDawnRunner:Start()
	self:ScheduleMethod(31, "DawnRunner")
end

function mod:DawnDancer()
	self:UnscheduleMethod("DawnDancer")
	warnDawnDancer:Show()
	timerDawnDancer:Start()
	self:ScheduleMethod(31,"DawnDancer")
end

function mod:SacroPath()
	timerSacroTankCombo:Start(30)
	timerDawnRunner:Start(5)
	timerFireDance:Start(15)
	self:ScheduleMethod(5,"DawnRunner")
	self:ScheduleMethod(15,"FireDance")
end

function mod:AlythPath()
	timerAlythTankCombo:Start(30)
	timerDawnRunner:Start(15)
	timerFireDance:Start(5)
	self:ScheduleMethod(15,"DawnRunner")
	self:ScheduleMethod(5,"FireDance")
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2146016) and args.sourceName == "Lady Sacrolash" and self.vb.phase <= 3 then
		local sacroTarget = mod:GetBossTarget(25165)
		warnFling:Show(sacroTarget)
		timerFlingSacro:Start(sacroTarget)
		timerRisingSunKick:Start(sacroTarget)
		timerCrashCombination:Start(sacroTarget)
		warnCrashCombination:Schedule(4)
		timerCutCombination:Start(sacroTarget)
		warnCutCombination:Schedule(5)
		timerSacroTankCombo:Start()
		if timerDawnRunner:GetTime() > 24 then
			timerDawnRunner:Update(0,6)
			self:UnscheduleMethod("DawnRunner")
			self:ScheduleMethod(6,"DawnRunner")
		end
	elseif args:IsSpellID(2145916) and args.sourceName == "Grand Warlock Alythess" and self.vb.phase <= 3 then
		local alythTarget = mod:GetBossTarget(25166)
		timerFlingAlyth:Start(alythTarget)
		timerCrescentMoonKick:Start(alythTarget)
		timerCrashCombination:Start(alythTarget)
		warnCrashCombination:Schedule(4)
		timerCutCombination:Start(alythTarget)
		warnCutCombination:Schedule(5)
		timerAlythTankCombo:Start()
		if timerFireDance:GetTime() > 24 then
			timerFireDance:Update(0,6)
			self:UnscheduleMethod("FireDance")
			self:ScheduleMethod(6,"FireDance")

		end
	elseif args:IsSpellID(2145929, 2145930, 2145931, 2145932) then
		warnFlashBurn:Show()
		timerFlashBurn:Start()
	elseif args:IsSpellID(2146029, 2146030, 2146031, 2146032) then
		warnCrushingShadow:Show()
		timerCrushingShadow:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.TwinsPull or msg:find(L.TwinsPull) then
		timerDance:Start()

	elseif msg == L.SacroPhase or msg:find(L.SacroPhase) then
		self:ScheduleMethod(0, "CancelTimers")
		timerSacroTankCombo:Start(30)
		timerDawnRunner:Start(5)
		self:ScheduleMethod(5, "DawnRunner")
		if self.vb.phase == 1 then
			self.vb.phase = 2
			sacroPath = true
		end
	elseif msg == L.AlythPhase or msg:find(L.AlythPhase) then
		self:ScheduleMethod(0, "CancelTimers")
		timerAlythTankCombo:Start()
		timerFireDance:Start()
		self:ScheduleMethod(5, "FireDance")
		if self.vb.phase == 1 then
			self.vb.phase = 2
			alythPath = true
		end
	elseif self.vb.phase == 4 and DBM:AntiSpam(5, 1) and (msg == L.SacroCombo or msg:find(L.SacroCombo) or msg == L.AlythCombo or msg:find(L.AlythCombo)) then
		if msg == L.SacroCombo or msg:find(L.SacroCombo) then
			local sacroTarget = mod:GetBossTarget(25165)
			timerRisingSunKick:Start(sacroTarget)
			timerCrashCombination:Start(sacroTarget)
			warnCrashCombination:Schedule(4)
			timerCutCombination:Start(sacroTarget)
			warnCutCombination:Schedule(5)
			timerSacroTankCombo:Start()
			if timerDawnRunner:GetTime() > 24 then
				timerDawnRunner:Update(0,6)
				self:UnscheduleMethod("DawnRunner")
				self:ScheduleMethod(6,"DawnRunner")
			end
			if timerFireDance:GetTime() > 24 then
				timerFireDance:Update(0,6)
				self:UnscheduleMethod("FireDance")
				self:ScheduleMethod(6,"FireDance")
			end
		elseif msg == L.AlythCombo or msg:find(L.AlythCombo) then
			local alythTarget = mod:GetBossTarget(25166)
			timerFlingAlyth:Start(alythTarget)
			timerCrescentMoonKick:Start(alythTarget)
			timerCrashCombination:Start(alythTarget)
			warnCrashCombination:Schedule(4)
			timerCutCombination:Start(alythTarget)
			warnCutCombination:Schedule(5)
			timerAlythTankCombo:Start()
			if timerFireDance:GetTime() > 24 then
				timerFireDance:Update(0,6)
				self:UnscheduleMethod("FireDance")
				self:ScheduleMethod(6,"FireDance")
			end
			if timerDawnRunner:GetTime() > 24 then
				timerDawnRunner:Update(0,6)
				self:UnscheduleMethod("DawnRunner")
				self:ScheduleMethod(6,"DawnRunner")
			end
		end
	elseif msg == L.SacroAbsorb or msg:find(L.SacroAbsorb) or msg == L.AlythAbsorb or msg:find(L.AlythAbsorb) then
		self:ScheduleMethod(0,"CancelTimers")
		self.vb.phase = 5
		timerTwinsMerge:Start()
	elseif msg == L.TwinsMerge or msg:find(L.TwinsMerge) then
		self:ScheduleMethod(0,"CancelTimers")
		timerDawnDancer:Start()
		self:ScheduleMethod(5,"DawnDancer")
	end
end

function mod:UNIT_HEALTH(uId)
	local cid = self:GetUnitCreatureId(uId)
	if cid == 25165 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.50 and self.vb.phase == 2 then
		--Sacrolash
		self.vb.phase = 3
		self:ScheduleMethod(0,"CancelTimers")
		timerRoleReversal:Start()
	elseif cid == 25166 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.50 and self.vb.phase == 2 then
		--Alythess
		self.vb.phase = 3
		self:ScheduleMethod(0,"CancelTimers")
		timerRoleReversal:Start()
	elseif cid == 25165 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.50 and self.vb.phase == 3 and alythPath == true then
		self.vb.phase = 4
		self:ScheduleMethod(0,"CancelTimers")
		timerTagTeam:Start()
		self:ScheduleMethod(5,"AlythPath")
	elseif cid == 25166 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.50 and self.vb.phase == 3 and sacroPath == true then
		self.vb.phase = 4
		self:ScheduleMethod(0,"CancelTimers")
		timerTagTeam:Start()
		self:ScheduleMethod(5,"SacroPath")
	end
end

function mod:OnCombatEnd()
	self:ScheduleMethod(0,"CancelTimers")
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end