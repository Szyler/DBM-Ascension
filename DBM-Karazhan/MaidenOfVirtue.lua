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

local warningHolyFire			= mod:NewTargetAnnounce(2130704, 3)

-- local timerRepentance		= mod:NewBuffActiveTimer(6, 2130700)
local warningRepentance			= mod:NewSpellAnnounce(2130700, 3)
local warningRepentanceSoon		= mod:NewSoonAnnounce(2130700, 2)
local timerRepentance			= mod:NewNextTimer(53, 2130700)
local timerRepentanceCast		= mod:NewCastTimer(3, 2130700)


-- Ascension specific
local warningSpecDespRun		= mod:NewSpecialWarning(L.WarnPrayerRun)
local warningDesperate			= mod:NewSpellAnnounce(2130728, 2)
-- local timerDesperates		= mod:NewBuffActiveTimer(3, 2130728)
local timerDesperateExplode		= mod:NewBuffActiveTimer(14, 2130736)
local timerNextDesperate		= mod:NewNextTimer(53, 2130728)
local timerDesperateCast		= mod:NewCastTimer(4, 2130728)
-- local timerWrathSkipped		= mod:NewCDTimer(12, 2130708)
local timerWrath				= mod:NewNextTimer(12, 2130708)
local warnSoonWrath				= mod:NewSoonAnnounce(2130708, 2)

mod:AddBoolOption("RangeFrame", true)


function mod:OnCombatStart(delay)
	timerRepentance:Start(20-delay)
	timerNextDesperate:Start(40-delay)
	timerWrath:Start(7-delay)
	-- timerWrathSkipped:Schedule(26)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end	

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2130704, 2130705, 2130706, 2130707) then
		warningHolyFire:Show(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2130708, 2130709, 2130710, 2130711) then
		-- self:Unschedule(timerWrathSkipped);
		local elapsed, total = timerNextDesperate:GetTime()
		if total - elapsed < 12 then
			timerWrath:Start(29)
			warnSoonWrath:Schedule(27)
		else
			timerWrath:Start()
			warnSoonWrath:Schedule(10)
		end
		-- timerWrathSkipped:Schedule(20)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2130700, 2130701, 2130702, 2130703) then -- Cast start of Repentance (3s)
			--elseif args:IsSpellID(2130700, 85307, 196743) then -- Actual spell of Repentance
		warningRepentanceSoon:Cancel()
		timerRepentanceCast:Start()
		timerRepentance:Start()
		warningRepentanceSoon:Schedule(48)
	elseif args:IsSpellID(2130728, 2130729, 2130730, 2130731) then
		warningDesperate:Show()
		timerDesperateCast:Start()
		timerNextDesperate:Start()
		timerDesperateExplode:Start()
		warningSpecDespRun:Schedule(10)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2130704) then
		timerHolyFire:Cancel()
	end
end
