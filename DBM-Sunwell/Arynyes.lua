local mod	= DBM:NewMod("Arynyes", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25837)
mod:SetUsedIcons()

mod:RegisterCombat("yell", L.GauntletPull)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
    "CHAT_MSG_MONSTER_EMOTE",
    "CHAT_MSG_RAID_BOSS_EMOTE",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_RAID_WARNING"
)


-- Vengeful Smite 2145868 (Spell_Damage) [after Imp Bullwark]
-- Vengeful Retaliation 2145870	(Spell_cast_start) [start: 15 sec, 30 sec freq, 1 sec charge, 8 sec duration]
-- Impenetrable Bullwark 2145867 (Spell_cast_success) [start: 5 sec, 30 sec freq, 5 sec duration]
-- Judgement of Vengeance 2145874 (Spell_cast_start)  [start: 25 sec, 30 sec freq, 1 sec cast]

local timerImpBullwark			= mod:NewNextTimer(30, 2145867)
local channelImpBullwark		= mod:NewCastTimer(5, 2145867)
local specWarnImpBullwark		= mod:NewSpecialWarning("High Commander Arynyes is channeling Impenetrable Bullwark!", 2145867,3)

local timerVengeSmite			= mod:NewNextTimer(30,2145868)
local warnVengeSmite			= mod:NewSpellAnnounce(2145868, 2)

local timerVengefulRetal		= mod:NewNextTimer(30, 2145870)
local castVengefulRetal			= mod:NewCastTimer(1, 2145870)
local channelVengefulRetal		= mod:NewCastTimer(8, 2145870)
local warnVengefulRetal			= mod:NewSpellAnnounce(2145870, 2)

local timerJudgement			= mod:NewNextTimer(30, 2145874)
local castJudgement				= mod:NewCastTimer(1, 2145874)
local warnJudgement				= mod:NewSpellAnnounce(2145874, 2)

local berserkTimer				= mod:NewBerserkTimer(600)


function mod:OnCombatStart(delay)
	self.vb.phase = 1
	berserkTimer:Start(-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.sourceName == "High Commander Arynyes" and args:IsSpellID(2145867) then
		channelImpBullwark:Start()
		timerVengeSmite:Schedule(5)
		specWarnImpBullwark:Show()
		warnVengeSmite:Schedule(5)
		timerImpBullwark:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args.sourceName == "High Commander Arynyes" and args:IsSpellID(2145870, 2145872)  then
		castVengefulRetal:Start()
		channelVengefulRetal:Schedule(1)
		warnVengefulRetal:Show()
		timerVengefulRetal:Start()
	elseif args.sourceName == "High Commander Arynyes" and args:IsSpellID(2145874, 2145875, 2145876, 2145877) then
		castJudgement:Start()
		warnJudgement:Show()
		timerJudgement:Start()
	end
end


function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.ArynPull or msg:find(L.ArynPull) then
		self.vb.phase = 2
		timerImpBullwark:Start(5)
		timerVengeSmite:Start(10)
		timerVengefulRetal:Start(15)
		timerJudgement:Start(25)
	end
end

function mod:OnCombatEnd()
	timerImpBullwark:Cancel()
	timerVengeSmite:Cancel()
	timerVengefulRetal:Cancel()
	timerJudgement:Cancel()
end