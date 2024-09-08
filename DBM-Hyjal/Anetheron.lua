local mod	= DBM:NewMod("Anetheron", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(17808)
mod:SetUsedIcons(1,2,3,4,5,6,7,8)
mod:RegisterCombat("combat", 17808)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REFRESH",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED"
)

-- Unknown Entity spawn
-- Unknown Effigy warning (2 stacks++)
-- Teleport active (plus body notification?)

--Carrion Swarm
local warnSwarm				= mod:NewSpellAnnounce(2140800, 3)
local timerSwarm			= mod:NewNextTimer(30, 2140800)

--Nightmare
local timerNextNightmare	= mod:NewNextTimer(45, 2140830)
local warnNightmareSoon		= mod:NewAnnounce("Nightmare soon!", 2140830)
local warnNightmare			= mod:NewAnnounce("%s is sent into the Nightmare!", 2140830)

-- Ring of Frost
local timerNextRingofFrost	= mod:NewNextTimer(45, 2140153)
local timerRingofFrost		= mod:NewTimer(15, "Ring of Frost duration", 2140153)

-- Infernal Rain
local timerNextInfernal		= mod:NewNextTimer(45, 2140810)
local timerInfernal			= mod:NewTimer(10, "Infernal spawning", 2140810)
local timerInfernalRain		= mod:NewTimer(19, "Infernal Rain duration", 2140818)

-- Fight
local target1
local target2
local target3

function mod:OnCombatStart(delay)
	timerSwarm:Start(10-delay)
	timerNextNightmare:Start(35-delay)
	timerNextInfernal:Start(20-delay)
	self:ScheduleMethod(35-delay,"Nightmare")
	target1 = nil
	target2 = nil
	target3 = nil
	DBM.BossHealth:AddBoss(17772, L.Jaina)
end

function mod:Nightmare()
	self:UnscheduleMethod("Nightmare")
	timerNextNightmare:Start()
	warnNightmareSoon:Schedule(40)
	self:ScheduleMethod(45,"Nightmare")
end

function mod:InfernalRain()
	self:UnscheduleMethod("InfernalRain")
	timerInfernal:Stop()
	timerInfernalRain:Stop()
	timerNextInfernal:Stop()
	timerInfernal:Start()
	timerInfernalRain:Start()
	timerNextInfernal:Start()
	self:ScheduleMethod(45,"InfernalRain")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2140825) then
		if 	target3 == nil and target2 ~= nil and target1 ~= nil then
				target3 = args.DestName
				self:setIcon(target3, 2)
				DBM.BossHealth:AddBoss(92171,target3)
				warnNightmare:Show(target3)
		elseif target2 == nil and target1 ~= nil then
				target2 = args.DestName
				self:setIcon(target2, 2)
				DBM.BossHealth:AddBoss(92171,target2)
				warnNightmare:Show(target2)
		elseif  target1 == nil then
				target1 = args.DestName
				self:setIcon(target1, 1)
				DBM.BossHealth:AddBoss(92171,target1)
				warnNightmare:Show(target1)
		end
	end
	if args:IsSpellID(2140825) and args.destName == target1 then
		DBM.BossHealth:RemoveBoss(92171,target1)
		self:setIcon(target1, 0)
		target1 = nil
	elseif args:IsSpellID(2140825) and args.destName == target2 then
		DBM.BossHealth:RemoveBoss(92171,target2)
		self:setIcon(target2, 0)
		target2 = nil
	elseif args:IsSpellID(2140825) and args.destName == target3 then
		DBM.BossHealth:RemoveBoss(92171,target3)
		self:setIcon(target3, 0)
		target3 = nil
	end
end

function mod:SPELL_AURA_REFRESH(args)
	if args:IsSpellID(2140825) and args.destName == target1 then
		DBM.BossHealth:RemoveBoss(92171,target1)
		self:setIcon(target1, 0)
		target1 = nil
	elseif args:IsSpellID(2140825) and args.destName == target2 then
		DBM.BossHealth:RemoveBoss(92171,target2)
		self:setIcon(target2, 0)
		target2 = nil
	elseif args:IsSpellID(2140825) and args.destName == target3 then
		DBM.BossHealth:RemoveBoss(92171,target3)
		self:setIcon(target3, 0)
		target3 = nil
	end
end

function mod:SPELL_AURA_REMOVED(args)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2140800) then
		warnSwarm:Show()
		timerSwarm:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Infernal1 or msg == L.Infernal2	or msg:find(L.Infernal1) or msg:find(L.Infernal2) then
		self:UnscheduleMethod("InfernalRain")
		timerInfernal:Stop()
		timerNextInfernal:Stop()
		timerInfernalRain:Stop()
		timerNextInfernal:Start(45)
		timerInfernal:Start(10)
		timerInfernalRain:Start(19)
		self:ScheduleMethod(45,"InfernalRain")
	end
	if msg == L.RingofFrost or msg:find(L.RingofFrost) then
		timerNextRingofFrost:Start()
		timerRingofFrost:Schedule(2)
	end
end

function mod:UNIT_DIED(args)
	if args.destName == target1 then
		DBM.BossHealth:RemoveBoss(92171,target1)
		target1 = nil
	elseif args.destName == target2 then
		DBM.BossHealth:RemoveBoss(92171,target2)
		target2 = nil
	elseif	args.destName ==target3 then
		DBM.BossHealth:RemoveBoss(92171,target3)
		target3 = nil
	end
end

function mod:OnCombatEnd()
	DBM.BossHealth:RemoveBoss(92171,target1)
	DBM.BossHealth:RemoveBoss(92171,target2)
	DBM.BossHealth:RemoveBoss(92171,target3)
	DBM.BossHealth:RemoveBoss(17772)
	target1 = nil
	target2 = nil
	target3 = nil
	self:UnscheduleMethod("Nightmare")
	self:UnscheduleMethod("InfernalRain")
end


function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == " Anetheron sends %s into a nightmare!" or msg:find(L.Nightmare) then
		if target3 == nil and target2 ~= nil and target1 ~= nil then
				target3 = msg:find(L.Nightmare)
				self:SetIcon(target3, 3)
				DBM.BossHealth:AddBoss(92171,target3)
		elseif target2 == nil and target1 ~= nil then
				target2 = msg:find(L.Nightmare)
				self:SetIcon(target2, 2)
				DBM.BossHealth:AddBoss(92171,target2)
		elseif 	target1 == nil then
				target1 = msg:find(L.Nightmare)
				self:SetIcon(target1, 1)
				DBM.BossHealth:AddBoss(92171,target1)
		end
	end
end
