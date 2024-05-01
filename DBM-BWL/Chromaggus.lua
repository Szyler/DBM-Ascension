local DBM = require("DBM") -- assuming DBM is a module you have in your project
local mod	= DBM:NewMod("Chromaggus", "DBM-BWL", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 188 $"):sub(12, -3))
mod:SetCreatureID(14020)
mod:RegisterCombat("combat",14020)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
    "SPELL_AURA_APPLIED"
)

--ORDER FOR PHASES IS BELOW
--FROST, FIRE, SHADOW, NATURE, ARCANE

--breath 15 sec cd
--intermission 30 sec
--Phase transmission 3 sec
--enrage 6:48~6:50
--Flame, Frost, Arcane, Acidic, Shadow Breath

--Brood Affliction: Blue    197228
--Frost Burn 197232
--Frost Breath 197233

--Brood Affliction: Red     197223
--Incinerate 197201
--Flame Breath 197205

--Brood Affliction: Black   197203
--Engulfing Shadow 197208
--2111309
--Shadow Breath 197212

--Brood Affliction: Green   197210
--Corrosive Acid 197215
--Acidic Breath 197220

--Brood Affliction: Bronze  197216
--Time Lapse 197222
--Arcane Breath 197224




--local specWarnRed   	    = mod:NewSpecialWarningYou(197223, 3)
--local specWarnGreen 	    = mod:NewSpecialWarningYou(197210, 3)
--local warnBreathSoon	    = mod:NewAnnounce("WarnBreathSoon", 1, 23316)
--local warnBreath		    = mod:NewAnnounce("WarnBreath", 2, 23316)

local enrageTimer		    = mod:NewBerserkTimer(408)
--Phases
local timerBlueNext			= mod:NewNextTimer(34, 2111286)
local timerRedNext			= mod:NewNextTimer(34, 2111263)
local timerBlackNext		= mod:NewNextTimer(34, 2111309)
local timerGreenNext		= mod:NewNextTimer(34, 2111273)
local timerBronzeNext		= mod:NewNextTimer(34, 2111296)
--Debuffs
local specWarnBlue	        = mod:NewSpecialAnnounceYou(197228, 3)
local specWarnBlack	        = mod:NewSpecialAnnounceYou(197203, 3)
local specWarnBronze	    = mod:NewSpecialAnnounceYou(197216, 3)
--Breaths
local timerFrostBreath		= mod:NewNextTimer(6, 2111240)
local timerFlameBreath		= mod:NewNextTimer(6, 2111230)
local timerShadowBreath		= mod:NewNextTimer(6, 2111235)
local timerAcidicBreath		= mod:NewNextTimer(6, 197220)
local timerArcaneBreath		= mod:NewNextTimer(6, 197224)
local timerBreathCD		    = mod:NewTimer(15, 197212)


--functions

function mod:FirstPhase()
    timerBlueNext:Start(10)
    timerBreathCD:Start(16)
end

function mod:onCombatStart(delay)
    enrageTimer:Start(-delay)
        self:ScheduleMethod(0,"FirstPhase")
end

function mod:secondBreath(delay)
    timerBreathCD:Start(15)
end

--Combat Log reading
function mod:SPELL_CAST_START(args)
    if args:IsSpellID(2111286) then
        self:ScheduleMethod(6, "secondBreath")
        timerFrostBreath:Start(6)
        timerRedNext:Start(34)
    elseif args:IsSpellID(2111263) then
        self:ScheduleMethod(6, "secondBreath")
        timerFlameBreath:Start(6)
        timerBlackNext:Start(34)
    elseif args:IsSpellID(2111309) then
        self:ScheduleMethod(6, "secondBreath")
        timerShadowBreath:Start(6)
        timerGreenNext:Start(34)
    elseif args:IsSpellID(2111273) then
        self:ScheduleMethod(6, "secondBreath")
        timerAcidicBreath:Start(6)
        timerBronzeNext:Start(34)
    elseif args:IsSpellID(2111296) then
        self:ScheduleMethod(6, "secondBreath")
        timerArcaneBreath:Start(6)
        timerBlueNext:Start(34)
    end
end

    function mod:SPELL_AURA_APPLIED(args)
    if args.IsSpellID(197228) and args:IsPlayer() then
        specWarnBlue:Show()
    elseif args.isSpellID(197216) and args:IsPlayer() then
        specWarnBronze:Show()
    elseif args.IsSpellID(197203) and args:IsPlayer() then
        specWarnBlack:Show()
    end
end