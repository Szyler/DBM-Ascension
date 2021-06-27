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

local warnMark			= mod:NewAnnounce(L.WarnMark, 3, 351203)
local warnPhase			= mod:NewAnnounce("WarnPhase", 4)
local warnTomb			= mod:NewTargetAnnounce(38235, 3)
local specWarnTidal		= mod:NewSpecialWarning("Tidalwave, stack!")
-- local warnSludge	= mod:NewTargetAnnounce(38246, 2)--Maybe filter it some if spammy?

-- local specWarnMark	= mod:NewSpecialWarning("SpecWarnMark")

local timerTidal		= mod:NewTimer(45, "Tidalwave", 351203)
-- local timerMark		= mod:NewTimer(15, "TimerMark", 351203)
local timerSludge		= mod:NewTargetTimer(12, 38246)

local berserkTimer		= mod:NewBerserkTimer(600)

local lastMark = 0
-- local markOfH, markOfC = DBM:GetSpellInfo(351203), DBM:GetSpellInfo(351204)

mod:AddBoolOption("RangeFrame", true)

function mod:OnCombatStart(delay)
	-- timerMark:Start(16-delay, markOfH, "10%")
	berserkTimer:Start(-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show()
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 38235 then
		warnTomb:Show(args.destName)
	elseif args.spellId == 38246 then
		warnSludge:Show(args.destName)
		timerSludge:Start(args.destName)
	-- elseif args.spellId == 351203 then
	-- 	timerMark:Cancel()
	-- 	timerMark:Start()
	elseif args:IsSpellID(351279) then
		warnPhase:Show(L.Frost)
		-- timerMark:Start(16, markOfH, "10%")
	elseif args:IsSpellID(351278) then
		warnPhase:Show(L.Nature)
		-- timerMark:Start(16, markOfC, "10%")
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(38246, 351203) then
		if args.amount and (GetTime() - lastMark) > 2 and args.amount >= 10 and args.amount % 5 == 0 then
			lastMark = GetTime()
			warnMark:Show(args.amount, args.spellName)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 38235 then
		warnTomb:Stop(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(85416, 351276, 351277) then     
		specWarnTidal:Show()
		timerTidal:Start()
	end
end

-- 351203 - Mark of Hydross
-- 351204 - Mark of Corruption