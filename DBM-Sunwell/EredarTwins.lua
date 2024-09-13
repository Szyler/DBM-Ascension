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

-- Alythess
local warnFallingStar				= mod:NewSpellAnnounce(2145023, 3) -- 2145022, 2145023, 2145023 spell_Cast_start 40s CD, Unless pushed back
local warnRisingSunCut				= mod:NewSpellAnnounce(2145925, 3) -- 2145925 spell_Cast_start 40s CD, Unless pushed back
local warnRisingSunKick				= mod:NewSpellAnnounce(2145920, 3) -- 2145918, 2145919, 2145920 spell_Cast_start
local warnFling						= mod:NewSpellAnnounce(2145917, 3) -- 2145917 spell_Cast_start 40s CD, Unless pushed back
local warnDawnDancer				= mod:NewSpellAnnounce(2145027, 3) -- 2145027 spell_Cast_start	
local warnFireDance					= mod:NewSpellAnnounce(2145928, 3) -- 2145928 	
local warnFlashBurn					= mod:NewSpellAnnounce(2145930, 3) -- 2145929, 2145930, 2145931 spell_Cast_start
local warnSolarBurnStack			= mod:NewSpecialWarningStack(2145905, nil, 5) -- 2145905, 2145906 spell_aura_applied
local warnSolarFlare				= mod:NewSpellAnnounce(2145907, 3) -- 2145907, 2145908

-- Sacrolash
local warnCrashingMoon				= mod:NewSpellAnnounce(2146023, 3) -- 2146022, 2146023, 2146024 spell_Cast_start 40s CD, Unless pushed back
local warnRisingMoonCut				= mod:NewSpellAnnounce(2146025, 3) -- 2146025 spell_Cast_start 40s CD, Unless pushed back
local warnRisingMoonKick			= mod:NewSpellAnnounce(2146020, 3) -- 2146018, 2146019, 2146020 spell_Cast_start
local warnFling						= mod:NewSpellAnnounce(2146017, 3) -- 2146017 spell_Cast_start 40s CD, Unless pushed back
local warnDuskRunner				= mod:NewSpellAnnounce(2146027, 3) -- 2146027 spell_Cast_start	
-- local warnFireDance					= mod:NewSpellAnnounce(2146028, 3) -- 2146028 spell_Cast_start
local warnCrushingShadow			= mod:NewSpellAnnounce(2146030, 3) -- 2146030 spell_Cast_start
local warnCrushingShadowDot			= mod:NewSpellAnnounce(2146031, 3) -- 2146031 spell_Cast_start
local warnLunarBurnStack			= mod:NewSpecialWarningStack(2146005, nil, 5) -- 2145905, 2146006 spell_aura_applied
local warnLunarFlare				= mod:NewSpellAnnounce(2146007, 3) -- 2145907, 2145908


local berserkTimer					= mod:NewBerserkTimer(600)

----
local warnBossLeaves				= mod:NewSpellAnnounce(12345, 3)
local timerBossLeaves				= mod:NewNextTimer(0, 12345)
--lower HP boss leaves after 10 seconds
local warnCharge					= mod:NewSpellAnnounce(2145907, 3)
local timerCharge					= mod:NewNextTimer(30, 2145907)
--boss charges to farthest player and leaves copies of herself, doing damage
local warnTankCombo					= mod:NewSpellAnnounce(2145919, 3)
local timerTankCombo				= mod:NewNextTimer(0, 2145919)
--boss gang bangs a tank, very hot
local warnPhase2					= mod:NewSpellAnnounce(12345, 3)
local timerPhase2					= mod:NewNextTimer(0, 12345)
--Initial boss hits 50% HP and swaps other boss in
local warnPhase3					= mod:NewSpellAnnounce(12345, 3)
local timerPhase3					= mod:NewNextTimer(0, 12345)
--Bosses merge together when secondary boss hits 0 HP

function mod:OnCombatStart(delay)
	timerBossLeaves:Start(10-delay)
	timerCharge:Start(15-delay)
	timerTankCombo:Start(40-delay)
	berserkTimer:Start(-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show()
	end
end

function mod:UNIT_HEALTH(uId)
	if (self:GetUnitCreatureId(uId) == 25165 or self:GetUnitCreatureId(uId) == 25166) and (UnitHealth(uId) / UnitHealthMax(uId)) == 0.5 and DBM:AntiSpam(5,2) then
		--SZYLER PLS UNSCHEDULE ALL OTHER TIMERS HERE IDK HOW
		warnPhase2:Show()
		timerPhase2:Start(5)
		timerCharge:Cancel()
		timerTankCombo:Cancel()
		timerTankCombo:Start(30)
		timerCharge:Start(35)
	elseif (self:GetUnitCreatureId(uId) == 25165 or self:GetUnitCreatureId(uId) == 25166) and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.0 and DBM:AntiSpam(5,2) then
		-- Add your code here
		warnPhase3:Show()
		timerPhase3:Start(8)
		timerCharge:Cancel()
		timerTankCombo:Cancel()
		timerCharge:Start(12)
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