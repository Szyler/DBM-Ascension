local mod	= DBM:NewMod("Anetheron", "DBM-Hyjal", 1)

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(17808, 117808, 217808, 317808)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warnNightmare			= mod:NewSpecialWarningTarget(2140830)
local warnInfernalRain		= mod:NewSpecialWarningYou(2140810)

local nextCarrion			= mod:NewNextTimer(30, 2140800)
local nextInfernalRain		= mod:NewNextTimer(45, 2140810)
local nextNightmare			= mod:NewNextTimer(45, 2140830)

function mod:Nightmare()
	self:UnscheduleMethod("Nightmare")
	nextNightmare:Start()
	self:ScheduleMethod(45, "Nightmare")
end

function mod:OnCombatStart(delay)
	nextCarrion:Start(-20 - delay)
	nextInfernalRain:Start(-25 - delay)
	nextNightmare:Start(-10 - delay)
	self:ScheduleMethod(35 - delay, "Nightmare")
end

function mod:OnCombatEnd()
	self:UnscheduleMethod("Nightmare")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(
		2140468,
		2140469,
		2140470,
		2140471,
		2140810,
		2140811,
		2140812,
		2140813,
		2140818,
		2140819,
		2140820,
		2140821
	) and args:IsPlayer() then
		warnInfernalRain:Show()
		SendChatMessage("I'M BAD, I STAND IN FIRE", "YELL")
	elseif args:IsSpellID(2140830, 2140831) and args:IsPlayer() then
		warnNightmare:Show(args.destName)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(
		2140468,
		2140469,
		2140470,
		2140471,
		2140810,
		2140811,
		2140812,
		2140813,
		2140818,
		2140819,
		2140820,
		2140821
	) and args:IsPlayer() then
		warnInfernalRain:Show()
		SendChatMessage("I'M BAD, I STAND IN FIRE", "YELL")
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2140800) then
		nextCarrion:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2140814) then
		nextInfernalRain:Start()
	end
end