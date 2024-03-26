local mod	= DBM:NewMod("Ouro", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15517)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"UNIT_HEALTH",
	"UNIT_DIED",
	"COMBAT_LOG_EVENT_UNFILTERED",
	"PLAYER_ALIVE"
)



local prewarnShard					= mod:NewAnnounce("Shard Spawn Soon", 3, 1002340)
local warnShard						= mod:NewAnnounce("Mind-Corrupting Shard Spawned", 2, 1002340)
local timerShard					= mod:NewTimer(35, "Shard Spawn", 1002340)
local berserkTimer					= mod:NewBerserkTimer(360)

local shardsDead
local maxShards
local ouroHealth
local shardNumber


function mod:OnCombatStart(delay)
	berserkTimer:Start()
	self:ScheduleMethod(0, "initialShardSpawn")
	self:ScheduleMethod(0.1, "deadShards")
	maxShards = 1
	shardNumber = 1
end

function mod:preShard()
	prewarnShard:Show()
end

function mod:alertShard()
	warnShard:Show()
	self:ScheduleMethod(0, "alarmSound")
end

function mod:initialShardSpawn()
	shardsDead = 0
	local timer1 = 30
	timerShard:Show(timer1)
	self:ScheduleMethod(timer1-5, "preShard")
	self:ScheduleMethod(timer1, "alertShard")
	self:ScheduleMethod(timer1, "checkShards")
end

function mod:shardSpawn()
	shardsDead = 0
	local timer2 = 35	
	timerShard:Show(timer2)
	self:ScheduleMethod(timer2-5, "preShard")
	self:ScheduleMethod(timer2, "alertShard")
	self:ScheduleMethod(timer2, "checkShards")
end

function mod:deadShards()
	if maxShards == 1 and shardsDead == 1 then
		self:ScheduleMethod(0, "shardSpawn")
	elseif maxShards == 2 and shardsDead == 2 then
		self:ScheduleMethod(0, "shardSpawn")
	elseif maxShards == 3 and shardsDead == 3 then
		self:ScheduleMethod(0, "shardSpawn")
	end
	self:ScheduleMethod(0.1, "deadShards")
end

function mod:checkShards()
	if ouroHealth > 75 then
		maxShards = 1
	elseif ouroHealth < 75 and ouroHealth > 33 then
		maxShards = 2	
	elseif ouroHealth < 33 then
		maxShards = 3
	end
end

function mod:UNIT_HEALTH(args)
    ouroHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
end

function mod:UNIT_DIED(args)
	local recapID = self:GetCIDFromGUID(args.destGUID)
	if recapID == 19045 then
		shardsDead = shardsDead + 1  
	end
end