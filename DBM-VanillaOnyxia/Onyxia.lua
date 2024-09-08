local mod	= DBM:NewMod("Onyxia", "DBM-Onyxia")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 3763 $"):sub(12, -3))
mod:SetCreatureID(10184)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"SPELL_CAST_START",
	"UNIT_DIED",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnPhase3			= mod:NewPhaseAnnounce(3)
local warnPhase2Soon		= mod:NewAnnounce("Phase 2 Soon", 1)
local warnPhase3Soon		= mod:NewAnnounce("Phase 3 Soon", 1)
local warnFireball			= mod:NewTargetAnnounce(2108300, 3)
local warnBlastNova	 		= mod:NewCastAnnounce(2108401, 2)
local WarnWhelpsSoon		= mod:NewAnnounce("Onyxian Whelps soon", 1)
local WarnSpearTarget		= mod:NewTimer(30, "%s", 2108415)

local specWarnDeepBreath	= mod:NewSpecialWarningMove(18609, 2)
local specWarnFireballYou	= mod:NewSpecialWarningYou(2108300, 2)

local timerFlameBreath		= mod:NewCastTimer(2, 2108321) 
local timerBreath			= mod:NewCastTimer(8, 17086)
local timerBlastNova		= mod:NewCastTimer(4, 2108401)
local timerBellowingRoar	= mod:NewCastTimer(5, 2108326)
local timerFireball			= mod:NewTargetTimer(4, 2108300)
local timerIntBlastNova		= mod:NewCDTimer(40, 2108401)-- Internal CD for a Guard to cast Blast Nova twice
local timerWhelps			= mod:NewTimer(95, "Onyxian Whelps", "Interface\\Icons\\INV_Misc_Head_Dragon_Red")

local timerNextFlameBreath	= mod:NewNextTimer(20, 2108321) 
local timerNextDeepBreath	= mod:NewCDTimer(75, 17086)--Range from 75-80 seconds in between based on where she moves to.
local timerNextBellowingRoar= mod:NewCDTimer(45, 2108326)
local timerNextBlastNova	= mod:NewCDTimer(40, 2108401)
local timerNextSecondNova	= mod:NewCDTimer(30, 2108401)
local timerNextTailSwipe	= mod:NewNextTimer(22, 2108312)
-- local timerIntBlastNova2	= mod:NewCDTimer(40, 2108401)-- second one for secondary add

local lastBlastNova = 0

local prewarnP2
local warnP2
local prewarnP3
local warnP3
local lastTargetGUID

mod:AddBoolOption(L.FireballMark)

function mod:preP2()
	warnPhase2Soon:Show()
end

function mod:alertP2()
	warnPhase2:Show()
end

function mod:preP3()
	warnPhase3Soon:Show()
end

function mod:alertP3()
	warnPhase3:Show()
end

function mod:WhelpsSpawn()
	self:UnscheduleMethod("WhelpsSpawn")
	WarnWhelpsSoon:Show()
	timerWhelps:Start()
	self:ScheduleMethod(95,"WhelpsSpawn")
end

function mod:OnCombatStart(delay)
	prewarnP2 = 0
	warnP2 = 0
	prewarnP3 = 0
	warnP3 = 0
	lastTargetGUID = 0
	timerFlameBreath:Start()
	timerNextTailSwipe:Start()
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellP2 or msg:find(L.YellP2) then
		timerNextDeepBreath:Start(77)
		timerNextBlastNova:Start()
		self:ScheduleMethod(2,"WhelpsSpawn")
	elseif msg == L.YellP3 or msg:find(L.YellP3) then
		timerNextDeepBreath:Stop()
		timerNextBlastNova:Stop()
		timerIntBlastNova:Stop()
		self:UnscheduleMethod("WhelpsSpawn")
		self:ScheduleMethod(2,"WhelpsSpawn")
		timerNextBellowingRoar:Start(8)
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.EmoteDeepBreath or msg:find(L.EmoteDeepBreath) then
		specWarnDeepBreath:Show()
		timerBreath:Start()
		timerNextDeepBreath:Stop()
		timerNextDeepBreath:Start()
	elseif msg:find(L.EmoteSpear) then
		name = string.match(msg, "is picked up by (.*)")
		--"A scream releases as the spear is picked up by XXX!"
		WarnSpearTarget:Show(name);		
	end
end

function mod:MassiveFireball()
	local target = nil
	target = mod:GetBossTarget(10184)
	local myName = UnitName("player")
	if target == myName then
		specWarnFireballYou:Show()
		SendChatMessage("Fireball on "..UnitName("player"), "YELL")
	else
		warnFireball:Show(target)
	end
	timerFireball:Start(target)
	if self.Options.FireballMark then
		self:SetIcon(target, 8, 3)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2108300, 2108301, 2108302, 2108303) then
		self:ScheduleMethod(0.4, "MassiveFireball")
	elseif args:IsSpellID(2108401, 2108402, 2108403, 2108404) then
		if args.sourceGUID ~= lastTargetGUID then
			warnBlastNova:Show()
			timerBlastNova:Start()
			timerNextSecondNova:Start()
			timerNextBlastNova:Start()
			lastTargetGUID = args.sourceGUIDs
		end
		-- if GetTime() - lastBlastNova > 20  then --Trying it to only trigger from new Add Blast Nova.
		-- 	timerIntBlastNova:Start()
		-- end
		-- lastBlastNova = GetTime()
	elseif args:IsSpellID(2108326) then --18431
		timerBellowingRoar:Start()
		timerNextBellowingRoar:Stop()
		timerNextBellowingRoar:Start()
		--if args:IsSpellID(17086, 18351, 18564, 18576) or args:IsSpellID(18584, 18596, 18609, 18617) then	-- 1 ID for each direction
	--	specWarnDeepBreath:Show() -- potentially deprecated because all new spell IDs
	--	timerBreath:Start()
	--	timerNextDeepBreath:Stop()
	--	timerNextDeepBreath:Start()
	--end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 10184 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.90 and prewarnP2 == 0 then
		prewarnP2 = 1
		self:ScheduleMethod(0, "preP2")		
	elseif self:GetUnitCreatureId(uId) == 10184 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.85 and warnP2 == 0 then
		warnP2 = 1
		self:ScheduleMethod(0, "alertP2")
	elseif self:GetUnitCreatureId(uId) == 10184 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.40 and prewarnP3 == 0 then
		prewarnP3 = 1
		self:ScheduleMethod(0, "preP3")
	elseif self:GetUnitCreatureId(uId) == 10184 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.35 and warnP3 == 0 then
		warnP3 = 1
		self:ScheduleMethod(0, "alertP3")
	end
end

function mod:UNIT_DIED(args)
	if args.destGUID == lastTargetGUID then
		timerNextSecondNova:Cancel()
		lastTargetGUID = 0
	end
end

--429201 item of spear

