local mod	= DBM:NewMod("Twins", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25165, 25166)
mod:SetUsedIcons(7, 8)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
    "CHAT_MSG_MONSTER_YELL",
    "CHAT_MSG_MONSTER_EMOTE",
    "CHAT_MSG_RAID_BOSS_EMOTE",
    "CHAT_MSG_MONSTER_SAY",
    "CHAT_MSG_RAID_WARNING",
	"UNIT_HEALTH"
)

mod:SetBossHealthInfo(
	25165, L.Sacrolash,
	25166, L.Alythess
)

local warnBossLeaves				= mod:NewSpellAnnounce(spellID, 3)
local timerBossLeaves				= mod:NewNextTimer(0, spellID)
--lower HP boss leaves after 10 seconds
local warnCharge					= mod:NewSpellAnnounce(2145907, 3)
local timerCharge					= mod:NewNextTimer(30, 2145907)
--boss charges to farthest player and leaves copies of herself, doing damage
local warnTankCombo					= mod:NewSpellAnnounce(2145919, 3)
local timerTankCombo				= mod:NewNextTimer(0, 2145919)
--boss gang bangs a tank, very hot
local warnPhase2					= mod:NewSpellAnnounce(spellID, 3)
local timerPhase2					= mod:NewNextTimer(0, spellID)
--Initial boss hits 50% HP and swaps other boss in
local warnPhase3					= mod:NewSpellAnnounce(spellID, 3)
local timerPhase3					= mod:NewNextTimer(0, spellID)
--Bosses merge together when secondary boss hits 0 HP

function mod:OnCombatStart(delay)
	timerBossLeaves:Start(10-delay)
	timerCharge:Start(15-delay)
	timerTankCombo:Start(40-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) = (25165, 25166) and (UnitHealth(uId) / UnitHealthMax(uId)) = 0.5 and DBM:AntiSpam(5,2) then
		--SZYLER PLS UNSCHEDULE ALL OTHER TIMERS HERE IDK HOW
		warnPhase2:Show()
		timerPhase2:Start(5-delay)
		timerTankCombo:Start(30-delay)
		timerCharge:Start(35-delay)
	elseif self:GetUnitCreatureId(uId) = (25165, 25166) and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.0 and DBM:AntiSpam(5,2) then
		warnPhase3:Show()
		timerPhase3:Start(8-delay)
		timerCharge:Start(12-delay)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)

end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_DAMAGE(args)
end

function mod:SPELL_MISSED(args)
end

function mod:SPELL_CAST_START(args)
end

--[[
Timers
	Dusk to Dawn (Dawn to Dusk)		Happens at 50% boss HP.  Bosses tag out for eachother													
	Charge		15 seconds after pull & 5 seconds after each transition engage													
	Tank Combo		40 seconds after pull & 15 seconds after P2 transition engage													

Notes
	Need to unschedule all timers at every phase transition
	Need to do longer pull, unsure how often Charge & tank combo is repeated
]]--