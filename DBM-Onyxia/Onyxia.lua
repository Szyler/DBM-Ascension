local mod	= DBM:NewMod("Onyxia", "DBM-Onyxia")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 3763 $"):sub(12, -3))
mod:SetCreatureID(10184)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_CAST_START",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnPhase3			= mod:NewPhaseAnnounce(3)
local warnPhase2Soon		= mod:NewAnnounce("Phase 2 Soon", 1)
local warnPhase3Soon		= mod:NewAnnounce("Phase 3 Soon", 1)

local specWarnBlastNova		= mod:NewSpecialWarningMove(2105147)
local specWarnDeepBreath	= mod:NewSpecialWarningMove(18609)

local timerNextDeepBreath	= mod:NewCDTimer(35, 17086)--Range from 35-60seconds in between based on where she moves to.
local timerBreath			= mod:NewCastTimer(8, 17086)
local timerBlastNova		= mod:NewCastTimer(4, 2105147)
local timerBellowingRoar	= mod:NewCastTimer(4, 18431)
local timerNextBellowingRoar= mod:NewCDTimer(45, 18431)
local timerNextBlastNova	= mod:NewCDTimer(32, 2105147)-- +/- a few seconds as it varies depending on Guard movement.
local timerIntBlastNova1	= mod:NewCDTimer(40, 2105147)-- Internal CD for a Guard to cast Blast Nova twice
local timerIntBlastNova2	= mod:NewCDTimer(40, 2105147)-- second one for secondary add
local lastBlastNova = 0

local prewarnP2
local warnP2
local prewarnP3
local warnP3

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
	elseif msg == L.YellP3 or msg:find(L.YellP3) then
		timerNextDeepBreath:Stop()
		timerNextBellowingRoar:Start(8)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(17086, 18351, 18564, 18576) or args:IsSpellID(18584, 18596, 18609, 18617) then	-- 1 ID for each direction
		specWarnDeepBreath:Show()
		timerBreath:Start()
		timerNextDeepBreath:Start()
	end
	if args:IsSpellID(2105145, 2105146, 2105147, 2105148) then
		specWarnBlastNova:Show()
		timerBlastNova:Start()
		lastBlastNova = GetTime()
		if (GetTime() - lastBlastNova) <= 1 or (GetTime() - lastBlastNova) > 15  then --Trying it to only trigger from new Add Blast Nova.
			timerNextBlastNova:Start()
		end
		if (timerNextBlastNova:GetTime() >= 37 and timerIntBlastNova1:GetTime() > 30) or (timerNextBlastNova:GetTime() <= 3 and timerIntBlastNova1:GetTime() > 30) then
			timerIntBlastNova2:Start()
		elseif
			timerNextBlastNova:GetTime() >= 37 and (timerIntBlastNova2:GetTime() == nil or timerIntBlastNova2:GetTime() > 30) or timerNextBlastNova:GetTime() <= 3 and (timerIntBlastNova2:GetTime() == nil or timerIntBlastNova2:GetTime() > 30) then --Trying to only get the Internal CD on the Nova closest to the timer.
			timerIntBlastNova1:Start()
		end
	end
	if args:IsSpellID(18431) then
		timerBellowingRoar:Start()
		timerNextBellowingRoar:Stop()
		timerNextBellowingRoar:Start()
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