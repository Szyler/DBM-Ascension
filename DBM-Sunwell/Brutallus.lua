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
	if args:IsSpellID(2145719, 2145720, 2145721) and dbm:antiSpam(5) then
		if args.destName == UnitName("Player") then
			warnFelfireBurnYou:Show()
		elseif
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
