local mod	= DBM:NewMod("Anetheron", "DBM-Hyjal", 1)

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(17808, 117808, 217808, 317808)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START"
)

local warnNightmare				= mod:NewSpecialWarningTarget(2140830)
local warnInfernalRain			= mod:NewSpecialWarningYou(2140810)

local timerNextCarrion			= mod:NewNextTimer(30, 2140800)
local timerNextInfernalRain		= mod:NewNextTimer(45, 2140810)
local timerNextNightmare		= mod:NewNextTimer(45, 2140830)

function mod:Nightmare()
	self:UnscheduleMethod("Nightmare")
	timerNextNightmare:Start()
	self:ScheduleMethod(45, "Nightmare")
end

function mod:InfernalRain()
	self:UnscheduleMethod("InfernalRain")
	timerNextInfernalRain:Start()
	self:ScheduleMethod(45, "InfernalRain")
end

function mod:OnCombatStart(delay)
	timerNextCarrion:Start(10 - delay)
	timerNextInfernalRain:Start(20 - delay)
	timerNextNightmare:Start(35 - delay)
	self:ScheduleMethod(20 - delay, "InfernalRain")
	self:ScheduleMethod(35 - delay, "Nightmare")
end

function mod:SPELL_AURA_APPLIED(args)
	if (
		args:IsSpellID(2140468, 2140469, 2140470, 2140471) or
		args:IsSpellID(2140810,	2140811, 2140812, 2140813) or
		args:IsSpellID(2140818, 2140819, 2140820, 2140821)
	) and args:IsPlayer() then
		warnInfernalRain:Show()
	elseif args:IsSpellID(2140830, 2140831) then
		warnNightmare:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if (
		args:IsSpellID(2140468, 2140469, 2140470, 2140471) or
		args:IsSpellID(2140810,	2140811, 2140812, 2140813) or
		args:IsSpellID(2140818, 2140819, 2140820, 2140821)
	) and args:IsPlayer() then
		warnInfernalRain:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2140800) then
		timerNextCarrion:Start()
	end
end
