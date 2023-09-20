local mod	= DBM:NewMod("Kazrogal", "DBM-Hyjal", 1)

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(17888, 117888, 217888, 317888)
mod:RegisterCombat("combat")

local nextPillar		= mod:NewNextTimer(55, 92177)
local nextWarstomp		= mod:NewNextTimer(55, 2141009)

function mod:Pillar()
	self:UnscheduleMethod("Pillar")
	nextPillar:Start()
	self:ScheduleMethod(55, "Pillar")
end

function mod:Warstomp()
	self:UnscheduleMethod("Warstomp")
	nextWarstomp:Start()
	self:ScheduleMethod(55, "Warstomp")
end

function mod:OnCombatStart(delay)
	nextPillar:Start(-delay - 45)
	nextWarstomp:Start(-delay)
	self:ScheduleMethod(10 - delay, "Pillar")
	self:ScheduleMethod(55 - delay, "Warstomp")
end

function mod:OnCombatEnd()
	self:UnscheduleMethod("Pillar")
	self:UnscheduleMethod("Warstomp")
end