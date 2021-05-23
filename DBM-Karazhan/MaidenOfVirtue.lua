local mod	= DBM:NewMod("Maiden", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 164 $"):sub(12, -3))
mod:SetCreatureID(16457)
--mod:RegisterCombat("yell", L.DBM_MOV_YELL_PULL)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_REMOVED"
)

local warningRepentanceSoon	= mod:NewSoonAnnounce(85177, 2)
local warningRepentance		= mod:NewSpellAnnounce(85177, 3)
local warningHolyFire		= mod:NewTargetAnnounce(85122, 3)
local warnWrath				= mod:NewSpellAnnounce(32445, 2)

-- local timerRepentance		= mod:NewBuffActiveTimer(6, 85177)
local timerRepentance		= mod:NewNextTimer(53, 85177)
local timerRepentanceCast	= mod:NewCastTimer(3, 85177)

mod:AddBoolOption("RangeFrame", true)

-- Ascension specific
local warningSpecDespRun	= mod:NewSpecialWarning(L.WarnPrayerRun)
local warningDesperate		= mod:NewSpellAnnounce(85108, 2)
local timerDesperate		= mod:NewBuffActiveTimer(3, 85120)
local timerDesperateExplode	= mod:NewBuffActiveTimer(14, 85103)
local timerDesperate		= mod:NewNextTimer(53, 85120)
local timerWrath			= mod:NewNextTimer(12, 32445)
-- local timerWrathSkipped		= mod:NewCDTimer(12, 32445)

function mod:OnCombatStart(delay)
	timerRepentance:Start(20-delay)
	timerDesperate:Start(40-delay)
	timerWrath:Start(7-delay)
	-- timerWrathSkipped:Schedule(26)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
	lastRepentance = GetTime()
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end	

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(85122) then
		warningHolyFire:Show(args.destName)
	elseif args:IsSpellID(85177, 85307, 196743) then
		warningRepentanceSoon:Cancel()
		timerRepentanceCast:Start()
		timerRepentance:Start()
		warningRepentanceSoon:Schedule(40)
		if (GetTime() - lastRepentance) > 10 then--To not spam each target of Repentance
			warningRepentance:Show()
			lastRepentance = GetTime()
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(32445, 85228, 85229) then
		-- self:Unschedule(timerWrathSkipped);
		if timerDesperate:GetTime() < 12 then
			timerWrath:Start(29)
		else
			timerWrath:Start()
		end
		-- timerWrathSkipped:Schedule(20)
		warnWrath:Show()
	elseif args:IsSpellID(85120) then
			warningDesperate:Show()
			timerDesperate:Start()
			timerDesperateExplode:Start()
			warningSpecDespRun:Schedule(10)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(29522) then
		timerHolyFire:Cancel()
	end
end
