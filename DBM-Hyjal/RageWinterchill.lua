local mod	= DBM:NewMod("RageWinterchill", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(17767)
mod:SetUsedIcons(8)
mod:RegisterCombat("yell", "They've broken through!")

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_HEALTH",
	"UNIT_DIED"
)

--DnD
local warnDnDSoon		= mod:NewSoonAnnounce(2140600, 2)
local timerDnDCD		= mod:NewNextTimer(30, 2140601)
local timerDnDextra		= mod:NewNextTimer(10, 2140601)
local specWarnDnD		= mod:NewSpecialWarningYou(2140600, 2)
-- Frozen Solid
local specWarnFrozen	= mod:NewSpecialWarningYou(2140617, 2)
local timerFrozen		= mod:NewBuffFadesTimer(10, 2140617)
local sayFrozenFade		= mod:NewFadesSay(2140617)
-- Lich Slap
local timerLichSlap		= mod:NewNextTimer(30, 2140645)
local warnLichSlap		= mod:NewTargetAnnounce(2140645)
-- Winter's Touch
local warnWT			= mod:NewTargetAnnounce(2140605, 2)
local specWarnWT		= mod:NewSpecialWarningYou(2140605, 2)
local timerNextWT		= mod:NewCDTimer(10, 2140605)
local timerWT			= mod:NewCastTimer(1.4, 2140605)
-- Transitions
local warnTransSoon		= mod:NewAnnounce("Intermission Phase Soon", 1, 500933)
local warnTransmission	= mod:NewAnnounce("Transmission: Kill the Phylacteries!", 2, 500933)
-- Ice Barrage
local warnIceBarrage	= mod:NewSpellAnnounce(2140624, 2)
local timerIceBarrage	= mod:NewCastTimer(8, 2140624)
local timerNextIBarrage = mod:NewNextTimer(45, 2140624)

--fight
local prewarn
local phylDeath
local phylRemaining
--local phylAnnounce		=mod:NewAnnounce("There are"..phylRemaining.."Phylacteries remaining", 2)
	--"CHAT_MSG_MONSTER_EMOTE"
local berserkTimer		= mod:NewBerserkTimer(600)

function mod:OnCombatStart(delay)
	prewarn = 1
	phylDeath = 0
	berserkTimer:Start(-delay)
	self:ScheduleMethod(0-delay,"DnD")
	timerNextWT:Start(10-delay)
	timerNextIBarrage:Start(45-delay)
	DBM.BossHealth:AddBoss(17772, L.Jaina)
end

function mod:BossPhase()
	timerDnDextra:Start(10)
	timerNextWT:Start(20)
	timerNextIBarrage(25)
	self:ScheduleMethod(10, "DnD")
end

function mod:Intermission()
	warnTransmission:Show()
	self:UnscheduleMethod("DnD")
	timerDnDCD:Stop()
	timerLichSlap:Stop()
	warnDnDSoon:Hide()
	phylDeath = 0
end

function mod:WTouch()
	local targetWT = mod:GetBossTarget(17767)
	if targetWT == UnitName("player") then
		specWarnWT:Show()
		SendChatMessage("Winter's Touch on "..UnitName("PLAYER").."!", "Say")
	else
		warnWT:Show(targetWT)
	end
	timerWT:Start(targetWT)
	timerNextWT:Start()
	self:SetIcon(targetWT, 8, 2)
end

function mod:DnD()
	self:UnscheduleMethod("DnD")
	timerDnDCD:Start(30)
	warnDnDSoon:Schedule(27)
	self:ScheduleMethod(30,"DnD")
	end

function mod:SPELL_DAMAGE(args)
	if args.spellId(2140600,2140601,2140602,2140603) and args:IsPlayer() and DBM:AntiSpam(8,1) then
		specWarnDnD:Show(args.spellName)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId(2140617) and args:IsPlayer() then
		specWarnFrozen:Show()
		SendChatMessage(L.SayFrozenFade, "Say")
		sayFrozenFade:Countdown(10,3)
		timerFrozen:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
-- Frost stacks thingy
end

function mod:SPELL_CAST_START(args)
	if args.SpellID(2140605) then
		self:ScheduleMethod(0.15,"WTouch")
	end
	if args.SpellID(2140624) then
		timerIceBarrage:Start()
		warnIceBarrage:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.SpellID(2140645) then
		timerLichSlap:Start(30)
		warnLichSlap:Show()
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg == L.Transition1 or msg:find(L.Transition1) then
		self:ScheduleMethod(0,"Intermission")
	elseif msg == L.Transition2 or msg:find(L.Transition2) then
		self:ScheduleMethod(0,"BossPhase")
	end
end

--function mod:CHAT_MSG_MONSTER_YELL(msg)
-- It will be much colder in your grave.
--end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 26634 then
		phylDeath = phylDeath + 1
		phylRemaining = (5 - phylDeath)
		phylAnnounce:Show()
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
end