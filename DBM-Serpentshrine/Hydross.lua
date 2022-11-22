local mod	= DBM:NewMod("Hydross", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(21216)
mod:RegisterCombat("combat", 21216)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS"
)

local warnMarkF			= mod:NewAnnounce(L.WarnMark, 3, 351203)
local warnMarkN			= mod:NewAnnounce(L.WarnMark, 3, 351204)
local warnPhase			= mod:NewAnnounce("WarnPhase", 4)
local warnTomb			= mod:NewTargetAnnounce(2137505, 3)
local specWarnTidal		= mod:NewSpecialWarning("Tidalwave, stack!")
local warnSludge		= mod:NewTargetAnnounce(2137509, 2)--Maybe filter it some if spammy?
local warnTidalPower	= mod:NewAnnounce(L.WarnMark, 3, 351204)

-- local specWarnMark	= mod:NewSpecialWarning("SpecWarnMark")

local timerNextTomb		= mod:NewNextTimer(45, 2137505)
local timerNextSludge	= mod:NewNextTimer(45, 2137509)
local timerNextTidal	= mod:NewNextTimer(45, 2137514)
local timerTidal1		= mod:NewTimer(6, "Tidal Wave (1)", 2137514)
local timerTidal2		= mod:NewTimer(6, "Tidal Wave (2)", 2137514)
local timerTidal3		= mod:NewTimer(6, "Tidal Wave (3)", 2137514)
local timerSludge		= mod:NewTargetTimer(12, 2137509)
-- local timerMark		= mod:NewTimer(15, "TimerMark", 351203)

local berserkTimer		= mod:NewTimer(600, "Berserk", 26662)

local lastMarkF = 0
local lastMarkN = 0
local lastTidalPower = 0
local LastTombSludge = 0
-- local markOfH, markOfC = DBM:GetSpellInfo(351203), DBM:GetSpellInfo(351204)

mod:AddBoolOption("RangeFrame", true)

function mod:tidalWave()
	self:UnscheduleMethod("tidalWave")
	specWarnTidal:Show()
	timerNextTidal:Start()
	timerTidal1:Start()
	if mod:IsDifficulty("heroic10", "heroic25") then
		timerTidal2:Schedule(3)
		specWarnTidal:Schedule(3)
		timerTidal3:Schedule(6)
		specWarnTidal:Schedule(6)
	end
	self:ScheduleMethod(45, "tidalWave")
end

function mod:PhaseChangeAddTime()
	local elapsed, total = timerNextTidal:GetTime();
	local currentRemainingTidalTimer = total - elapsed
	timerNextTidal:AddTime(2.5)
	self:UnscheduleMethod("tidalWave")
	self:ScheduleMethod(currentRemainingTidalTimer+2, "tidalWave")
	berserkTimer:AddTime(2)
end

function mod:OnCombatStart(delay)
	-- timerMark:Start(16-delay, markOfH, "10%")
	berserkTimer:Start(-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show()
	end
	timerNextTomb:Start(10-delay)
	timerNextTidal:Start(30-delay)
	self:ScheduleMethod(30-delay, "tidalWave")
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	-- elseif args.spellId == 351203 then
	-- 	timerMark:Cancel()
	-- 	timerMark:Start()
	if args:IsSpellID(2137504) then -- Corruption transform on boss
		warnPhase:Show(L.Nature)
		timerNextTomb:Stop()
		if GetTime() - LastTombSludge <= 32 then
			timerNextSludge:Start(42)
		else 
			timerNextSludge:Start(12)
		end
		self:PhaseChangeAddTime()
		-- timerMark:Start(16, markOfC, "10%")
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2137504) then -- Losing Corruption transform on boss
		warnPhase:Show(L.Frost)
		timerNextSludge:Stop()
		if GetTime() - LastTombSludge <= 32 then
			timerNextTomb:Start(42)
		else 
			timerNextTomb:Start(12)
		end
		self:PhaseChangeAddTime()
		-- timerMark:Start(16, markOfH, "10%")
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if 	args:IsSpellID(2137523, 2137524, 2137525, 2137526) then	 -- Mark of Hydross
		if args.amount and (GetTime() - lastMarkF) > 2 and args.amount >= 10 and args.amount % 5 == 0 then
			lastMarkF = GetTime()
			warnMarkF:Show(args.amount, args.spellName)
		end
	elseif args:IsSpellID(2137527, 2137528, 2137529, 2137530) then   	  -- Mark of Corruption
		if args.amount and (GetTime() - lastMarkN) > 2 and args.amount >= 10 and args.amount % 5 == 0 then
			lastMarkN = GetTime()
			warnMarkN:Show(args.amount, args.spellName)
		end
	elseif args:IsSpellID(2137514) then   	-- Tidal Power
		if args.amount and (GetTime() - lastTidalPower) > 2 and args.amount >= 75 and args.amount % 5 == 0 then
			lastTidalPower = GetTime()
			warnTidalPower:Show(args.amount, args.spellName)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2137505, 2137506, 2137507, 2137508) then
		warnTomb:Show(args.destName)
		timerNextTomb:Start()
		LastTombSludge = GetTime()
	elseif args:IsSpellID(2137509, 2137510, 2137511, 2137512) then
		warnSludge:Show(args.destName)
		timerSludge:Start(args.destName)
		timerNextSludge:Start()
		LastTombSludge = GetTime()
	end
end