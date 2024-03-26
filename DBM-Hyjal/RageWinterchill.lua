local mod	= DBM:NewMod("RageWinterchill", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(17767)
mod:SetUsedIcons(8)
mod:RegisterCombat("combat", 17767)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_MISSED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_HEALTH",
	"UNIT_DIED"
)

--DnD
local warnDnDSoon		= mod:NewSoonAnnounce(2140600, 2)
local timerDnDCD		= mod:NewNextTimer(30, 2140601)
local timerDnDextra		= mod:NewNextTimer(10, 2140601)
local specWarnDnD		= mod:NewSpecialWarningMove(2140600, 2)
-- Frozen Solid
local specWarnFrozen	= mod:NewSpecialWarningYou(2140617, 2)
local timerFrozen		= mod:NewTimer(10,"Frozen Solid", 2140617)
local sayFrozenFade		= mod:NewFadesYell(2140617)
-- Lich Slap
local timerNextSlap		= mod:NewNextTimer(30, 2140645)
local warnLichSlap		= mod:NewTargetAnnounce(2140645)
-- Winter's Touch
local warnWT			= mod:NewTargetAnnounce(2140605, 2)
local specWarnWT		= mod:NewSpecialWarningYou(2140605, 2)
local timerNextWT		= mod:NewCDTimer(15, 2140605)
local timerWT			= mod:NewCastTimer(1.3, 2140605)
-- Transitions
local warnTransSoon		= mod:NewSpecialWarning("Intermission Phase Soon", 1, 500933)
local warnTransmission	= mod:NewAnnounce("Transmission: Kill the Phylacteries!", 2, 500933)
-- Ice Barrage
local warnIceBarrage	= mod:NewSpellAnnounce(2140624, 2)
local timerIceBarrage	= mod:NewCastTimer(8, 2140624)
local timerNextBarrage = mod:NewNextTimer(45, 2140624)
--Chilled to the Bone
local SpecWarnChilled 	= mod:NewSpecialWarning("You have %s stacks of Chilled to the Bone!", 2140612)
--Frost Nova
local timerNextNova  	= mod:NewNextTimer(30, 2140620)
-- Chains of Winterchill
local warnChains		= mod:NewAnnounce("%s is chained with >%s<!", 2140654)
local timerChains		= mod:NewNextTimer(15, 2140654)

--fight
local prewarn
local phylDeath
local phylRemaining
local phylAnnounce		=mod:NewAnnounce("There are %s Phylacteries remaining", 2)
local phase
local lastDnD
local remainingDnD
local lastWintersTouch
local remaininTouch
local lastNova
local remainingNova
local lastSlap
local remainingSlap
local berserkTimer		= mod:NewBerserkTimer(600)

mod:AddBoolOption("ChainWhisper", false)

function mod:OnCombatStart(delay)
	prewarn 			= 1
	phylDeath 			= 0
	phase 				= 1
	lastDnD				= nil
	remainingDnD		= nil
	lastWintersTouch 	= nil
	remaininTouch		= nil
	lastNova			= nil
	remainingNova		= nil
	lastSlap			= nil
	remainingSlap		= nil
	berserkTimer:Start(-delay)
	self:ScheduleMethod(0-delay,"DnD")
	timerNextWT:Start(10-delay)
	timerNextBarrage:Start(45-delay)
	timerNextNova:Start(37-delay)
	timerNextSlap:Start(10-delay)
	timerChains:Start(15-delay)
	DBM.BossHealth:AddBoss(17772, L.Jaina)
end

function mod:BossPhase()
	self:ScheduleMethod(10,"DnD")
	timerNextSlap:Start(10)
	timerDnDextra:Start(10)
	timerNextWT:Start(20)
	timerNextBarrage:Start(25)
	timerNextNova:Start(5)
	phase = 1
end

function mod:Intermission()
	warnTransmission:Show()
	self:ScheduleMethod(0,"CancelTimers")
	phase = 2
	phylDeath = 0
end

function mod:CancelTimers()
	timerDnDCD:Stop()
	warnDnDSoon:Cancel()
	self:UnscheduleMethod("DnD")
	timerIceBarrage:Stop()
	timerNextBarrage:Stop()
	timerNextWT:Stop()
	timerNextSlap:Stop()
	timerNextNova:Stop()
end

function mod:WTouch()
	local targetWT = mod:GetBossTarget(17767)
	if targetWT == UnitName("player") then
		specWarnWT:Show()
		SendChatMessage("Winter's Touch on "..UnitName("PLAYER").."!", "SAY")
	else
		warnWT:Show(targetWT)
	end
	timerWT:Start(targetWT)
	self:SetIcon(targetWT, 8, 2)
end

function mod:DnD()
	self:UnscheduleMethod("DnD")
	lastDnD = GetTime()
	timerDnDCD:Start(30)
	warnDnDSoon:Schedule(25)
	self:ScheduleMethod(30,"DnD")
	end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2140600,2140601,2140602,2140603) then
		if args:IsPlayer() and DBM:AntiSpam(8,1) then
		specWarnDnD:Show()
		end
	end
	if args:IsSpellID(2140620,2140621,2140622,2140623) and DBM:AntiSpam(5,6) then
		lastNova = GetTime()
		timerNextNova:Start(65)
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(2140620,2140621,2140622,2140623) and DBM:AntiSpam(5,5) then
		lastNova = GetTime()
		timerNextNova:Start(65)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2140617) and args:IsPlayer() then
		specWarnFrozen:Show()
		SendChatMessage(L.SayFrozenFade, "SAY")
		sayFrozenFade:Countdown(10,3)
		timerFrozen:Start()
	end
	if args:IsSpellID(2140654) and args:IsPlayer() then
		warnChains:Show(args.sourceName, args.destName)
		if self.Options.ChainWhisper then
			SendChatMessage("I'm linked with you", "WHISPER")
		end
--		SendChatMessage("destName is "..args.destName.."", "SAY")
--		if args.destName == UnitName("Player") then
--			specWarnChains:Show(args.destName)
--		elseif args.sourceName == UnitName("Player") then
--			specWarnChains:show(args.sourceName)
--		end
	end
end

-- SendChatMessage(""..UnitName("PLAYER").." is chained to "..args.destName.."!", "YELL")
-- SendChatMessage(""..args.destName.." is chained to "..UnitName("PLAYER").."!", "YELL")

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2140612) and args:IsPlayer() and args.amount > 14 and DBM:AntiSpam(5,4) then
		SpecWarnChilled:Show(args.amount)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2140605) then
		self:ScheduleMethod(0.2,"WTouch")
		lastWintersTouch = GetTime()
		timerNextWT:Start()
	end
	if args:IsSpellID(2140624) then
		warnIceBarrage:Show()
		timerIceBarrage:Start()
		timerNextBarrage:Start(70)
		remaininTouch = (15 - (GetTime() - lastWintersTouch))
		remainingDnD = (30 - (GetTime() - lastDnD))
		remainingNova = (30 - (GetTime() - lastNova))
		remainingSlap = (30 - (GetTime() - lastSlap))
		timerDnDCD:Stop()
		warnDnDSoon:Cancel()
		warnDnDSoon:Schedule(remainingDnD + 5)
		timerDnDCD:Start(remainingDnD + 10)
		self:UnscheduleMethod("DnD")
		self:ScheduleMethod(remainingDnD + 10,"DnD")
		timerNextWT:Stop()
		timerNextWT:Start(remaininTouch + 10)
		timerNextNova:Stop()
		timerNextNova:Start(remainingNova + 10)
		timerNextSlap:Stop()
		timerNextSlap:Start(remainingSlap + 10)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2140645) then
		timerNextSlap:Start(30)
		lastSlap = GetTime()
		warnLichSlap:Show(args.destName)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.TransitionYell or msg:find(L.TransitionYell) then
		self:ScheduleMethod(0,"Intermission")
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 26634 then
		phylDeath = phylDeath + 1
		phylRemaining = (6 - phylDeath)
		phylAnnounce:Show(phylRemaining)
	end
	if cid == 26634 and phylRemaining == 0 then
		self:ScheduleMethod(1,"BossPhase")
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 17767 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.70 and prewarn == 1 and DBM:AntiSpam(5,2) then
		prewarn = 2
		warnTransSoon:Show()
	elseif self:GetUnitCreatureId(uId) == 17767 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.36 and prewarn == 2 and DBM:AntiSpam(5,3) then
		prewarn = 3
		warnTransSoon:Show()
	end
end

function mod:OnCombatEnd()
	DBM.BossHealth:RemoveBoss(17772)
	self:UnscheduleMethod("BossPhase")
	self:UnscheduleMethod("Intermission")
end

--function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
--	if msg == L.Transition1 or msg:find(L.Transition1) and phase == 1 then
--		self:ScheduleMethod(0,"Intermission")
--		phase = 2
--	elseif msg == L.Transition2 or msg:find(L.Transition2) and phase == 2 then
--		self:ScheduleMethod(0,"BossPhase")
--		phase = 1
--	end
--end

--function mod:CHAT_MSG_MONSTER_EMOTE(msg)
--	if msg == L.Transition1 or msg:find(L.Transition1) and phase == 1 then
--		self:ScheduleMethod(0,"Intermission")
--		phase = 2
--	elseif msg == L.Transition2 or msg:find(L.Transition2) and phase == 2 then
--		self:ScheduleMethod(0,"BossPhase")
--		phase = 1
--	end
--end