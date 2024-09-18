local mod	= DBM:NewMod("Brutallus", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(24882)


mod:RegisterCombat("combat")
mod:RegisterCombat("yell", L.BrutPull)

mod.disableHealthCombat = true


mod:RegisterEvents(
	"SPELL_CAST_START",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_HEALTH",
	"UNIT_DIED"
)

local warnMeteorSlash			= mod:NewSpellAnnounce(2145705, 2) -- 2145704, 2145705, 2145707, 2145708
local warnMeteorSlashStack 		= mod:NewSpecialWarningStack(2145705, nil, 3) -- 2145704, 2145705, 2145707, 2145708
local timerNextMeteorSlash		= mod:NewNextTimer(10, 2145705) -- 2145704, 2145705, 2145707, 2145708

-- 10%, 10%, 13%, 15%, 15%.

local warnTrample				= mod:NewSpellAnnounce(2145709, 3) -- 2145709, 2145710, 2145711 spell_aura_applied
local warnTrampleSoon			= mod:NewSoonAnnounce(2145709, 3) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerNextTrample			= mod:NewNextTimer(30, 2145709) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerCastTrample			= mod:NewCastTimer(10, 2145709) -- 2145709, 2145710, 2145711 spell_aura_applied
local timerTargetTrample		= mod:NewTargetTimer(10, 2145709) -- 2145709 spell_aura_applied

local warnFelfireBreath			= mod:NewSpellAnnounce(2145717, 2) -- 2145717, 2145718, Spell_cast_start
local timerNextFelfireBreath	= mod:NewNextTimer(60, 2145717) -- 2145717, 2145718, Spell_cast_start

local specwarnFelfireBurn		= mod:NewSpecialWarningYou(2145719) -- 2145719, 2145720, 2145721 spell_aura_applied
local warnFelfireTargets		= mod:NewTargetAnnounce(2145719, 3) -- 2145719, 2145720, 2145721 spell_aura_applied
local timerFelFireBurn			= mod:NewTimer(5, "%s: Felfire Burn spreads in:", 2145719)
local timerTargetFelFireBurn	= mod:NewTargetTimer(60, 2145719) -- 2145719, 2145720, 2145721 spell_aura_applied
local timerNextFelFireBurn		= mod:NewNextTimer(60, 2145719) -- 2145719, 2145720, 2145721 spell_cast_start

local timerExcitement			= mod:NewBuffActiveTimer(50, 2145703) -- 2145703 Aura_applied Spell_aura_removed


local excitementStage = 0
local oldhasExcitement = 0
local hasExcitement = false
local hp = 100
local prevHP = 100
local hpAtEnd = 0
local oldTime = 0
local currTime = 0
local timeElapsed = 0
local timeToEnd = 0

local felfireTargets = {}
local felfireIcon = 7

local function WarnFelfireTargets()
	warnFelfireTargets:Show(table.concat(felfireTargets, "<, >"))
	table.wipe(felfireTargets)
	-- felfireIcon = 7
end

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	felfireIcon = 7
	hasExcitement = false
	excitementStage = 0
	oldhasExcitement = 0
	hp = 100
	prevHP = 100
	timerNextMeteorSlash:Start(10-delay)
	timerNextFelfireBreath:Start(45-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2145705, 2145706, 2145707, 2145708) then
		if args.destName == UnitName("Player") and args.amount and args.amount > 2 then
			warnMeteorSlashStack:Show(args.amount or 1)
		end
	elseif args:IsSpellID(2145709) then --only main target
		timerTargetTrample:Start(args.destName)
	elseif args:IsSpellID(2145703) then
		hasExcitement = true
		timerExcitement:Start(args.destName)
		excitementStage = excitementStage + 1
	elseif args:IsSpellID(2145719, 2145720, 2145721, 2145721) then
		felfireTargets[#felfireTargets + 1] = args.destName
		if args:IsPlayer() then
			specwarnFelfireBurn:Show()
			timerFelFireBurn:Start(args.destName)
		end
		timerTargetFelFireBurn:Start(args.destName)
		self:SetIcon(args.destName, felfireIcon, 60)
		felfireIcon = felfireIcon - 1
		self:Unschedule(WarnFelfireTargets)
		self:Schedule(0.2, WarnFelfireTargets)
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2145703) then
		hasExcitement = false
		timerExcitement:Stop()
		warnTrample:Show()
		timerCastTrample:Start()
		timerNextMeteorSlash:Stop()
		timerNextMeteorSlash:Start(13)
		timerNextTrample:Stop()
	elseif args:IsSpellID(2145719, 2145720, 2145721, 2145721) then
		self:SetIcon(args.destName, 0)
		felfireIcon = felfireIcon + 1
		-- for i, name in ipairs(felfireTargets) do
		-- 	if name == args.destName then
		-- 		table.remove(felfireTargets, i)
		-- 	end
		-- end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2145705, 2145706, 2145707, 2145708) then
		warnMeteorSlash:Show()
		timerNextMeteorSlash:Start()
		if timerTargetTrample:GetTime() > 0 then
			timerTargetTrample:AddTime(2)
		end
	-- elseif args:IsSpellID(2145709, 2145710, 2145711) then
	-- 	timerNextTrample:Start()
	elseif args:IsSpellID(2145717) and args.sourceName == "Brutallus" then
		timerNextFelfireBreath:Start()
		warnFelfireBreath:Show()
	end
end

function mod:OnCombatEnd()
end

function mod:UNIT_HEALTH(unit)
	if (mod:GetUnitCreatureId(unit) == 24882) and hasExcitement then
		hp = math.ceil((math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100)
		if excitementStage ~= oldhasExcitement then

			oldhasExcitement = excitementStage
			if excitementStage == 1 	  or excitementStage == 2 then hpAtEnd = hp - 9
			elseif excitementStage == 3 						then hpAtEnd = hp - 12
			elseif excitementStage == 4 or excitementStage == 5 then hpAtEnd = hp - 13
			elseif excitementStage == 6 						then hpAtEnd = hp - 15
			elseif excitementStage == 7 or excitementStage == 8 then hpAtEnd = hp - 17
			end
			prevHP = hp
			currTime = GetTime()
		elseif hp ~= prevHP then
			prevHP = math.ceil((math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100)
			oldTime = currTime
			currTime = GetTime()
			timeElapsed = currTime - oldTime

			timeToEnd = timeElapsed * (hp - hpAtEnd)
			if timeToEnd < 5 and timeToEnd > 0 then
				warnTrampleSoon:Show()
			end

			timerNextTrample:Start(timeToEnd)
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
