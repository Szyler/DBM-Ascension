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

local warnRainOfFire		= mod:NewSpecialWarningYou(2141200)
local nextRainOfFire		= mod:NewNextTimer(25, 2141200)
local nextLegionPortal		= mod:NewTimer(45, "Legion Portal", 35717)
local nextHowlOfAzgalor		= mod:NewNextTimer(30, 2141209)
local spamYell = 0

function mod:LegionPortal()
	self:UnscheduleMethod("LegionPortal")
	nextLegionPortal:Start()
	self:ScheduleMethod(45, "LegionPortal")
end

function mod:OnCombatStart(delay)
	nextRainOfFire:Start(-delay)
	nextLegionPortal:Start(-delay - 15)
	nextHowlOfAzgalor:Start(-delay + 5)
	self:ScheduleMethod(30 - delay, "LegionPortal")
end

function mod:OnCombatEnd()
	self:UnscheduleMethod("LegionPortal")
end

function mod:SPELL_AURA_APPLIED(args)
	if (
		args:IsSpellID(2141200, 2141201, 2141202, 2141203, 2141204, 2141205, 2141206, 2141207) and
		args:IsPlayer() and
		GetTime() - spamYell >= 5
	) then
		spamYell = GetTime()
		warnRainOfFire:Show()
		SendChatMessage("I'M BAD, I STAND IN FIRE", "YELL")
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if (
		args:IsSpellID(2141200, 2141201, 2141202, 2141203, 2141204, 2141205, 2141206, 2141207) and
		args:IsPlayer() and
		GetTime() - spamYell >= 5
	) then
		spamYell = GetTime()
		warnRainOfFire:Show()
		SendChatMessage("I'M BAD, I STAND IN FIRE", "YELL")
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2141200, 2141201, 2141202, 2141203, 2141204, 2141205, 2141206, 2141207) then
		nextRainOfFire:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2141209) then
		nextHowlOfAzgalor:Start()
	end
end