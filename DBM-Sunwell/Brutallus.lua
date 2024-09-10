local mod	= DBM:NewMod("Brutallus", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(24882)
mod:SetUsedIcons(1, 2, 3, 4, 5, 6, 7)

mod:RegisterCombat("combat")
mod:RegisterCombat("yell", L.Pull)

mod.disableHealthCombat = true


mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_DIED"
)

local warnMeteorSlash		= mod:NewSpellAnnounce(2145705, 2)
local timerMeteorSlash10	= mod:NewNextTimer(10, 2145705)
local timerMeteorSlash14	= mod:NewNextTimer(14, 2145705)
local timerMeteorSlash20	= mod:NewNextTimer(20, 2145705)

local warnTrample			= mod:NewSpellAnnounce(2145709, 2)
local timerTrampleStart		= mod:NewNextTimer(30, 2145709)
local timerTrampleEnd		= mod:NewNextTimer(10, 2145709)

local warnFelfireBurn		= mod:NewSpellAnnounce(2145719, 2)
local timerFelfireBurn		= mod:NewNextTimer(30, 2145719)

local berserkTimer			= mod:NewBerserkTimer(360)

local slashNumber = 0

function mod:OnCombatStart(delay)
	self.vb.phase = 1
	slashNumber = 0
	timerMeteorSlash10:Start(10-delay)
	timerTrampleStart:Start(23-delay)
	timerFelfireBreath:Start(45-delay)
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2145705, 2145706, 2145707, 2145708) and slashNumber + 1 %2 == 0 then
		--10 second timer for the second swing of every set
		slashNumber += 1
		timerMeteorSlash10:Start()
	elseif args:IsSpellID(2145705, 2145706, 2145707, 2145708) and slashNumber == 1 then
		--Second round of Meteor Slashes, happens 14 seconds after the previous slash
		slashNumber += 1
		timerMeteorSlash14:Start()
	elseif args:IsSpellID(2145705, 2145706, 2145707, 2145708) then
		--Starting at the third, all slashes are approx 20 seconds apart.  I swear to god this is random (17-23) and I'm not crazy
		slashNumber += 1
		timerMeteorSlash20:Start()
	elseif args:IsSpellID(2145709, 2145710, 2145711) then
		warnTrample:Show(args.destName)
		timerTrampleStart:Start()
		timerTrampleEnd:Start()
	elseif args:IsSpellID(2145718, 2145719, 2145720, 2145721) then
		warnFelfireBurn:Show(args.destName)
		timerFelfireBurn:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2145709, 2145710, 2145711) then
		warnTrample:Show(args.destName)
		timerTrampleEnd:Start()
	end
end

function mod:OnCombatEnd()
	slashNumber = 0
end

--[[
Timers
	Meteor Slash		10 seconds after pull.  Happens twice, once 10 seconds after the other.  Rotation is approx Pull, 10s, 10s, 14s, 10s, 20s, 10s, 20s, 10s, etc.  The 20 seconds are random, between 17 seconds and 23 seconds.													
	Trample				23 seconds after pull, then every 60 seconds													
	Felfire Breath		45 seconds after pull, then every 60 seconds

Notes
	Meteor slash timer is fucked.  The 20 second timer is very approximate, and ranges from 17 to 23 seconds.
]]--
