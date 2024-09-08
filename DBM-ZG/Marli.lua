local mod	= DBM:NewMod("Marli", "DBM-ZG", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(14510)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warnSpiders			= mod:NewSpellAnnounce(24083)
local timerSpiders			= mod:NewNextTimer(30, 24083)

-- local warnCorrosive	= mod:NewTargetAnnounce(24111)
-- local timerCorrosive	= mod:NewTargetTimer(30, 24111)

local warnEnveloping		= mod:NewSpellAnnounce(24110)
local timerEnveloping		= mod:NewNextTimer(30, 24110)

local warnDrain				= mod:NewTargetAnnounce(24300)
local timerDrain			= mod:NewTargetTimer(8, 24300)

local warnEnlarge			= mod:NewSpellAnnounce(24109)

function mod:OnCombatStart(delay)
	timerSpiders:Start(20-delay)
	self:ScheduleMethod(20, "spiderSpawn")
end

function mod:spiderSpawn()
	self:UnscheduleMethod("spiderSpawn")
	warnSpiders:Show()
	timerSpiders:Start()
	self:ScheduleMethod(30, "spiderSpawn")
end

function mod:SPELL_AURA_APPLIED(args)
	-- if args:IsSpellID(24111) then
	-- 	-- warnCorrosive:Show(args.destName)
	-- 	-- timerCorrosive:Start(args.destName)
	-- else
	if args:IsSpellID(24300, 350036) then
		warnDrain:Show(args.destName)
		timerDrain:Start(args.destName)
	elseif args:IsSpellID(24110) then
		warnEnveloping:Show()
		timerEnveloping:Start()
	elseif args:IsSpellID(24109) then
		warnEnlarge:Show()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	-- if args:IsSpellID(24111) then
	-- 	timerCorrosive:Cancel(args.destName)
	-- else
	if args:IsSpellID(24300, 350036) then
		timerDrain:Cancel(args.destName)
	end
end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args:IsSpellID(24083) then
-- 		warnSpiders:Show()
-- 	end
-- end