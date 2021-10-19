local mod	= DBM:NewMod("Onyxia", "DBM-Onyxia")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 3763 $"):sub(12, -3))
mod:SetCreatureID(10184)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"SPELL_CAST_START",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnPhase3			= mod:NewPhaseAnnounce(3)
local warnPhase2Soon		= mod:NewAnnounce("Phase 2 Soon", 1)
local warnPhase3Soon		= mod:NewAnnounce("Phase 3 Soon", 1)
local warnFireball			= mod:NewTargetAnnounce(2105160, 3)
local warnBlastNova	 		= mod:NewCastAnnounce(2105147, 2)
local WarnWhelpsSoon		= mod:NewAnnounce("Onyxian Whelps soon", 1)

local specWarnDeepBreath	= mod:NewSpecialWarningMove(18609, 2)
local specWarnFireballYou	= mod:NewSpecialWarningYou(2105160, 2)

local timerBreath			= mod:NewCastTimer(8, 17086)
local timerBlastNova		= mod:NewCastTimer(4, 2105147)
local timerBellowingRoar	= mod:NewCastTimer(4, 18431)
local timerFireball			= mod:NewCastTimer(4, 2105160)

local timerWhelps			= mod:NewTimer(95, "Onyxian Whelps", "Interface\\Icons\\INV_Misc_Head_Dragon_Red")
local timerNextDeepBreath	= mod:NewCDTimer(75, 17086)--Range from 75-80 seconds in between based on where she moves to.
local timerNextBellowingRoar= mod:NewCDTimer(45, 18431)
local timerNextBlastNova	= mod:NewCDTimer(32, 2105147)-- +/- a few seconds as it varies depending on Guard movement.
local timerIntBlastNova		= mod:NewCDTimer(40, 2105147)-- Internal CD for a Guard to cast Blast Nova twice
-- local timerIntBlastNova2	= mod:NewCDTimer(40, 2105147)-- second one for secondary add

local lastBlastNova = 0

local prewarnP2
local warnP2
local prewarnP3
local warnP3

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
	end
end

function mod:MassiveFireball()
	local target = nil
	target = mod:GetBossTarget(10184)
	local myName = UnitName("player")
	if target == myName then
		specWarnFireballYou:Show()
	else
		warnFireball:Show(target)
	end
	timerFireball:Start(target)
	if self.Options.FireballMark then
		self:SetIcon(target, 8, 3)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2105158, 2105159, 2105160, 2105161) then
		self:ScheduleMethod(0.4, "MassiveFireball")
	end
	if args:IsSpellID(2105145, 2105146, 2105147, 2105148) then
		warnBlastNova:Show()
		timerBlastNova:Start()
		timerNextBlastNova:Start()
		if GetTime() - lastBlastNova > 20  then --Trying it to only trigger from new Add Blast Nova.
			timerIntBlastNova:Start()
		end
		lastBlastNova = GetTime()
	end
	if args:IsSpellID(18431) then
		timerBellowingRoar:Start()
		timerNextBellowingRoar:Stop()
		timerNextBellowingRoar:Start()
	end
		--if args:IsSpellID(17086, 18351, 18564, 18576) or args:IsSpellID(18584, 18596, 18609, 18617) then	-- 1 ID for each direction
	--	specWarnDeepBreath:Show() -- potentially deprecated because all new spell IDs
	--	timerBreath:Start()
	--	timerNextDeepBreath:Stop()
	--	timerNextDeepBreath:Start()
	--end
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