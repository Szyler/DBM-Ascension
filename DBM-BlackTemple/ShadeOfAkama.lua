local mod	= DBM:NewMod("Akama", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(23421)
mod:RegisterCombat("combat", 22841)
-- Akama:SetMinCombatTime(60)

mod:RegisterEvents(
	"UNIT_DIED",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_HEAL"
)

local timerNextGroup				= mod:NewNextTimer(35, 2142687)
local timerNextSorcerer				= mod:NewNextTimer(30, 2142602)
local timerSoulDomination       	= mod:NewCastTimer(300, 2142603)

local warnSorcerer					= mod:NewSpellAnnounce(2142602, 2)
local warnSoulDomination			= mod:NewSpellAnnounce(2142603, 2)
local warnDeadlyPoison				= mod:NewTargetAnnounce(2142657, 2)
local warnPoisonedShiv				= mod:NewTargetAnnounce(2142653, 2)

local warnHealingStream				= mod:NewSpellAnnounce(2142677, 2)
local warnRiptide					= mod:NewSpellAnnounce(2142680, 2) --Might be useful to warn if this is cast on shade of akama
local warnVigilance					= mod:NewSpellAnnounce(2142686, 2) --Might be useful to warn if this is cast on shade of akama

local fightStarted = false

function mod:OnCombatStart(delay)
	timerNextGroup:Start(5-delay)
	self:ScheduleMethod(5-delay, "NewGroup")
	timerNextSorcerer:Start(60-delay)
	self:ScheduleMethod(60-delay, "NewSorcerer")
	fightStarted = true
end

function mod:OnCombatEnd()
	DBM.RangeCheck:Hide()
end

function mod:NewGroup()
	self:UnscheduleMethod("NewGroup")
	timerNextGroup:Start()
	self:ScheduleMethod(35, "NewGroup")
end

function mod:NewSorcerer()
	self:UnscheduleMethod("NewSorcerer")
	warnSorcerer:Show()
	timerNextSorcerer:Start()
	self:ScheduleMethod(30, "NewSorcerer")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2142603) and fightStarted == true then
		warnSoulDomination:Show()
		timerSoulDomination:Start()
	elseif args:IsSpellID(2142657) and args.amount and args.amount >= 2 and args.amount % 2 == 0 and DBM:AntiSpam(5, 1) then
		warnDeadlyPoison:Show(args.destName)
	elseif args:IsSpellID(2142653) and args.amount and args.amount >= 2 and args.amount % 2 == 0 and DBM:AntiSpam(5, 1) then
		warnPoisonedShiv:Show(args.destName)
	elseif args:IsSpellID(2142686) and self:GetCIDFromGUID(args.destGUID) == 22841 then
		warnVigilance:Show()
	elseif args:IsSpellID(2142680) and args:GetDestCreatureID() == 22841 then --not sure if this check works
		warnRiptide:Show()
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED -- Hack to include applied_dose as well without more code

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2142603) then
		-- warnSoulDomination:Hide()
		timerSoulDomination:Stop()
	end
end

function mod:SPELL_HEAL(args)
	if args:IsSpellID(2142677) and DBM:AntiSpam(5) then
		warnHealingStream:Show()
	end
end

-- local channelersDown = 0
-- local sorcerersDown = 0
-- channelersDown = 0
-- sorcerersDown = 0


-- function Akama:OnEvent(event, arg1)
-- 	if event == "UNIT_DIED" then
-- 		if arg1.destName == DBM_AKAMA_MOB_CHANNELER then
-- 			self:SendSync("Channeler")
-- 		elseif arg1.destName == DBM_AKAMA_MOB_SORCERER then
-- 			self:SendSync("Sorcerer")
-- 		end
-- 	end
-- end

-- function Akama:OnSync(msg)
-- 	if msg == "Channeler" then
-- 		channelersDown = channelersDown + 1
-- 		self:Announce(DBM_AKAMA_WARN_CHANNELER_DOWN:format(channelersDown), 2)
-- 	elseif msg == "Sorcerer" then
-- 		sorcerersDown = sorcerersDown + 1
-- 		self:Announce(DBM_AKAMA_WARN_SORCERER_DOWN:format(sorcerersDown), 2)
-- 	end
-- end

