local mod	= DBM:NewMod("Hakkar", "DBM-ZG", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(14834)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS_DOSE",
	"CHAT_MSG_RAID_BOSS_EMOTE"
)

local warnSiphonSoon	= mod:NewSoonAnnounce(24324)
local timerSiphon		= mod:NewNextTimer(60, 24324)

local warnInsanity		= mod:NewTargetAnnounce(24327)
local timerInsanity		= mod:NewTargetTimer(10, 24327)
local timerNextInsanity	= mod:NewNextTimer(30, 24327)

local warnBlood			= mod:NewTargetAnnounce(24328)
local specWarnBlood		= mod:NewSpecialWarningYou(24328)
local timerBlood		= mod:NewTargetTimer(16, 24328)

local specWarnPool		= mod:NewSpecialWarningYou(340510)
local specWarnPoison	= mod:NewSpecialWarningYou(24320)

local warnSonSoon		= mod:NewSoonAnnounce(46729)
local timerSon			= mod:NewNextTimer(60, 46729)

local enrageTimer		= mod:NewBerserkTimer(585)

function mod:OnCombatStart(delay)
	enrageTimer:Start(-delay)
	warnSiphonSoon:Schedule(55-delay)
	timerSiphon:Start(-delay)
	timerNextInsanity:Start(-delay)
	warnSonSoon:Schedule(25-delay)
	timerSon:Start(30-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(24327, 24178) then
		warnInsanity:Show(args.destName)
		timerInsanity:Start(args.destName)
		timerNextInsanity:Start()
	elseif args:IsSpellID(24328, 350416) or args:IsSpellID(350418, 350417) then
		warnBlood:Show(args.destName)
		timerBlood:Start(args.destName)
		if args:IsPlayer() then
			specWarnBlood:Show()
		end
	elseif args:IsSpellID(340510, 350419, 350420) then
		if args:IsPlayer() then
			specWarnPool:Show()
		end
	elseif args:IsSpellID(24320) then
		if args:IsPlayer() then
			specWarnPoison:Show()
		end
	elseif args:IsSpellID(24324) then
		warnSiphonSoon:Cancel()
		warnSiphonSoon:Schedule(55)
		timerSiphon:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(340510, 350419, 350420) then
		if args:IsPlayer() then
			specWarnPool:Show()
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find("A Son of Hakkar joins the fight!") then
		warnSonSoon:Schedule(55)
		timerSon:Start()
	end
end