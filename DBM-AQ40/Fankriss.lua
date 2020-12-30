local mod	= DBM:NewMod("Fankriss", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 184 $"):sub(12, -3))
mod:SetCreatureID(15510)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE"
)

local warnHatchlingssoon	= mod:NewAnnounce("Vekniss Hatchlings Soon", 2, 1002256)
local warnExplodingsoon		= mod:NewAnnounce("Volatile Explosion Soon", 3, 1002356)
local warnSpawnssoon		= mod:NewAnnounce("Spawn of Fankriss Soon", 4, 1002297)
local warnHatchlings		= mod:NewAnnounce("Vekniss Hatchlings Spawned", 2, 1002256)
local warnExploding			= mod:NewAnnounce("Volatile Hatchlings Exploding", 3, 1002356)
local warnSpawns			= mod:NewAnnounce("Spawn of Fankriss Spawned", 4, 1002297)

local timerHatchlingA		= mod:NewTimer(60, "Hatchlings", 1002256)
local timerExplosionA		= mod:NewTimer(60, "Explosion", 1002356)
local timerHatchlingB		= mod:NewTimer(60, "Hatchlings", 1002256)
local timerExplosionB		= mod:NewTimer(60, "Explosion", 1002356)
local timerSpawnofFankriss	= mod:NewTimer(60, "Spawn of Fankriss", 1002297)

local berserkTimer	=	mod:NewBerserkTimer(540)

function mod:veknissSoon()
	warnHatchlingssoon:Show()
end

function mod:veknissWarning()
	warnHatchlings:Show()
end

function mod:explosionSoon()
	warnExplodingsoon:Show()
end

function mod:explosionWarning()
	warnExploding:Show()
end

function mod:spawnSoon()
	warnSpawnssoon:Show()
end

function mod:spawnWarning()
	warnSpawns:Show()
end

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)	
	self:ScheduleMethod(10-delay, "veknissHatchlingA")
	self:ScheduleMethod(45-delay, "veknissHatchlingB")
	self:ScheduleMethod(30-delay, "spawnofFankriss")
	self:ScheduleMethod(0-delay, "veknissInitial")
	self:ScheduleMethod(0-delay, "spawnInitial")
end

function mod:veknissInitial()
	local timeri = 10
	timerHatchlingB:Start(timeri)
	self:ScheduleMethod(timeri-5,"veknissSoon")
	self:ScheduleMethod(timeri, "veknissWarning")
	self:ScheduleMethod(timeri, "explosionInitial")
end

function mod:explosionInitial()
	local timere = 40
	timerExplosionB:Start(timere)
	self:ScheduleMethod(timere-5, "explosionSoon")
	self:ScheduleMethod(timere, "explosionWarning")
end

function mod:spawnInitial()
	local timers = 30
	timerSpawnofFankriss:Start(30)
	self:ScheduleMethod(timers-5, "spawnSoon")
	self:ScheduleMethod(timers, "spawnWarning")
end
	
function mod:veknissHatchlingA()
	local timera = 35
	timerHatchlingA:Start(timera)
	self:ScheduleMethod(timera*2, "veknissHatchlingA")
	self:ScheduleMethod(timera-5,"veknissSoon")
	self:ScheduleMethod(timera, "veknissWarning")
	self:ScheduleMethod(timera, "explosionA")
end

function mod:explosionA()
	local timeraa = 40
	timerExplosionA:Start(timeraa)
	self:ScheduleMethod(timeraa-5, "explosionSoon")
	self:ScheduleMethod(timeraa, "explosionWarning")
	self:ScheduleMethod(timeraa*2, "explosionA")
end

function mod:veknissHatchlingB()
	local timerb = 35
	timerHatchlingB:Start(timerb)
	self:ScheduleMethod(timerb*2, "veknissHatchlingB")
	self:ScheduleMethod(timerb-5,"veknissSoon")
	self:ScheduleMethod(timerb, "veknissWarning")
	self:ScheduleMethod(timerb, "explosionB")
end

function mod:explosionB()
	local timerbb = 40
	timerExplosionB:Start(timerbb)
	self:ScheduleMethod(timerbb-5, "explosionSoon")
	self:ScheduleMethod(timerbb, "explosionWarning")
	self:ScheduleMethod(timerbb*2, "explosionB")
end

function mod:spawnofFankriss()
	local timerc = 35
	timerSpawnofFankriss:Start(timerc)
	self:ScheduleMethod(timerc, "spawnofFankriss")
	self:ScheduleMethod(timerc-5, "spawnSoon")
	self:ScheduleMethod(timerc, "spawnWarning")
end
