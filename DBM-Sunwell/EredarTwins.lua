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








local mod	= DBM:NewMod("Brutallus", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(24882)


mod:RegisterCombat("combat")
mod:RegisterCombat("yell", L.Pull)

mod.disableHealthCombat = true


mod:RegisterEvents(
	"SPELL_CAST_START",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"UNIT_HEALTH",
	"UNIT_DIED"
)

local warnMeteorSlash			= mod:NewSpellAnnounce(2145705, 2) -- 2145704, 2145705, 2145707, 2145708
local warnMeteorSlashStack 		= mod:NewSpecialWarningStack(2145705, nil, 3) -- 2145704, 2145705, 2145707, 2145708
local timerNextMeteorSlash		= mod:NewNextTimer(10, 2145705) -- 2145704, 2145705, 2145707, 2145708

-- 10%, 10%, 13%, 15%, 15%.

local warnTrample				= mod:NewSpellAnnounce(2145709, 3) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerNextTrample			= mod:NewNextTimer(30, 2145709) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerCastTrample			= mod:NewCastTimer(10, 2145709) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerTargetTrample		= mod:NewTargetTimer(10, 2145709) -- 2145709 spell_aura_applied

local warnFelfireBreath			= mod:NewSpellAnnounce(2145717, 2) -- 2145717, 2145718, Spell_cast_start
local timerNextFelfireBreath	= mod:NewNextTimer(60, 2145717) -- 2145717, 2145718, Spell_cast_start
local warnFelfireBurnYou		= mod:NewSpecialWarningYou(2145719) -- 2145719, 2145720, 2145721 spell_damage dbm:antiSpam(5)
local warnFelfireBurn			= mod:NewTargetAnnounce(2145719, 3) -- 2145719, 2145720, 2145721 spell_damage dbm:antiSpam(5)

local timerExcitement			= mod:NewBuffActiveTimer(50, 2145703) -- 2145703 Aura_applied Spell_aura_removed

local berserkTimer				= mod:NewBerserkTimer(360)

local hasExcitement = 0
local oldhasExcitement = 0
local hp = 100
local newHP = 100
local hpAtEnd = 0
local oldTime = 0
local currTime = 0
local timeElapsed = 0
local timeToEnd = 0

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	hasExcitement = 0
	oldhasExcitement = 0
	hp = 100
	newHP = 100
	timerNextMeteorSlash:Start(10-delay)
	timerNextFelfireBreath:Start(45-delay)
	berserkTimer:Start(-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2145705, 2145706, 2145707, 2145708) then
		if args.destName == UnitName("Player") and args.amount and args.amount > 2 then
			warnMeteorSlashStack:Show(args.amount or 1)
		end
	elseif args:IsSpellID(2145709) then --only main target
		timerTargetTrample:Start(args.destName)
	elseif args:IsSpellID(2145717, 2145718) then
		warnFelfireBreath:Show(args.destName)
		timerNextFelfireBreath:Start()
	elseif args:IsSpellID(2145703) then
		timerExcitement:Start(args.destName)
		hasExcitement = hasExcitement + 1
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2145705, 2145706, 2145707, 2145708) then
		warnMeteorSlash:Show()
		timerNextMeteorSlash:Start()
	-- elseif args:IsSpellID(2145709, 2145710, 2145711) then
	-- 	timerNextTrample:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2145719, 2145720, 2145721) and DBM:AntiSpam(5) then
		if args.destName == UnitName("Player") then
			warnFelfireBurnYou:Show()
		else
			warnFelfireBurn:Show(args.destName)
		end
	end
end
mod.SPELL_MISSED = mod.SPELL_DAMAGE

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2145703) then
		timerExcitement:Stop()
		warnTrample:Show()
		timerCastTrample:Start()
		timerNextMeteorSlash:Stop()
		timerNextMeteorSlash:Start(13)
	end
end

function mod:OnCombatEnd()
end

function mod:UNIT_HEALTH(unit)
	if (mod:GetUnitCreatureId(unit) == 24882) then
		if hasExcitement ~= oldhasExcitement then
			hp = math.ceil((math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100)

			oldhasExcitement = hasExcitement
			if hasExcitement == 1 	  or hasExcitement == 2 then hpAtEnd = hp - 10
			elseif hasExcitement == 3 						then hpAtEnd = hp - 13
			elseif hasExcitement == 4 or hasExcitement == 5 then hpAtEnd = hp - 15
			elseif hasExcitement == 6 						then hpAtEnd = hp - 17
			elseif hasExcitement == 7 or hasExcitement == 8 then hpAtEnd = hp - 19
			end
			newHP = hp
			currTime = GetTime()
		elseif hp ~= newHP then
			newHP = math.ceil((math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100)
			oldTime = currTime
			currTime = GetTime()
			timeElapsed = currTime - oldTime

			timeToEnd = timeElapsed * (newHP - hpAtEnd)
			timerNextTrample(timeToEnd)
        end
    end
end

--[[
Timers
	Meteor Slash		10 seconds after pull.  Happens twice, once 10 seconds after the other.  Rotation is approx Pull, 10s, 10s, 14s, 10s, 20s, 10s, 20s, 10s, etc.  The 20 seconds are random, between 17 seconds and 23 seconds.													
	Trample				23 seconds after pull, then every 60 seconds													
	Felfire Breath		45 seconds after pull, then every 60 seconds

Notes
	Meteor slash timer is fucked.  The 20 second timer is very approximate, and ranges from 17 to 23 seconds.
]]--
