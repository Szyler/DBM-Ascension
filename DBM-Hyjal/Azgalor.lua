local mod	= DBM:NewMod("Azgalor", "DBM-Hyjal", 1)

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(17842, 117842, 217842, 317842)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warnRainOfFire			= mod:NewSpecialWarningYou(2141200)
local timerNextRainOfFire		= mod:NewNextTimer(25, 2141200)
local timerNextHowlOfAzgalor	= mod:NewNextTimer(30, 2141209)
local timerNextLegionPortal		= mod:NewTimer(45, "Legion Portal", 35717)

function mod:LegionPortal()
	self:UnscheduleMethod("LegionPortal")
	timerNextLegionPortal:Start()
	self:ScheduleMethod(45, "LegionPortal")
end

function mod:OnCombatStart(delay)
	timerNextRainOfFire:Start(-delay)
	timerNextLegionPortal:Start(31 - delay)
	timerNextHowlOfAzgalor:Start(35 - delay)
	self:ScheduleMethod(25 - delay, "LegionPortal")
end

function mod:SPELL_AURA_APPLIED(args)
	if (
		(args:IsSpellID(2141200, 2141201, 2141202, 2141203) or args:IsSpellID(2141204, 2141205, 2141206, 2141207)) and
		args:IsPlayer() and DBM:AntiSpam()
	) then
		warnRainOfFire:Show()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if (
		(args:IsSpellID(2141200, 2141201, 2141202, 2141203) or args:IsSpellID(2141204, 2141205, 2141206, 2141207)) and
		args:IsPlayer() and DBM:AntiSpam()
	) then
		warnRainOfFire:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2141209) then
		timerNextHowlOfAzgalor:Start()
	elseif args:IsSpellID(2141200, 2141201, 2141202, 2141203) or args:IsSpellID(2141204, 2141205, 2141206, 2141207) then
		timerNextRainOfFire:Start()
	end
end