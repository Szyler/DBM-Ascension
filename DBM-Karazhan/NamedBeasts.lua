local mod1	= DBM:NewMod("Shadikith", "DBM-Karazhan")
local L		= mod1:GetLocalizedStrings()
mod1:SetCreatureID(16180)
mod1:RegisterCombat("combat")

mod1:RegisterEvents(
    "SPELL_AURA_APPLIED",
    "SPELL_CAST_SUCCESS"
)

local warningDive			= mod1:NewTargetAnnounce(29903, 3)
local DiveCD   			    = mod1:NewCDTimer(30, 29903)
local timerSilence			= mod1:NewCDTimer(10, 29904)
local timerKnockback   		= mod1:NewCDTimer(8, 29905)

function mod1:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29904) then
        timerSilence:Start()
    end
end

function mod1:SPELL_CAST_START(args)
	if args:IsSpellID(29905) then
        timerKnockback:Start()
    end
end

function mod1:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(29903) then
        warningDive:Show(args.destName)
        DiveCD:Start()
    elseif args:IsSpellID(29905) then
        timerKnockback:Start()
    end
end

local mod2	= DBM:NewMod("Hyakiss", "DBM-Karazhan")
local L		= mod2:GetLocalizedStrings()
mod2:SetCreatureID(16179)
mod2:RegisterCombat("combat")

mod2:RegisterEvents(
    "SPELL_AURA_APPLIED",
    "SPELL_CAST_SUCCESS"
)
local warningWeb			= mod2:NewTargetAnnounce(29896, 3)
local timerWeb			    = mod2:NewTargetTimer(10, 29896)
local timerPoisonVolley		= mod2:NewCDTimer(24, 29293)
-- local timerAcidicFang	= mod2:NewTargetTimer(10, 29901)
local warnAcidicFang		= mod2:NewAnnounce(L.WarnAcidicFang, 2, 29901)

function mod2:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29896) then
        warningWeb:Show(args.destName)
        timerWeb:Show(args.destName)
    end
end

function mod2:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(29901) and args.amount > 2 then
        warnAcidicFang:Show(args.spellName, args.destName, args.amount or 1)
	end
end

local mod3	= DBM:NewMod("Rokad", "DBM-Karazhan")
local L		= mod3:GetLocalizedStrings()
mod3:SetCreatureID(16181)
mod3:RegisterCombat("combat")

mod3:RegisterEvents(
    "SPELL_AURA_APPLIED"
)

local warnHowlCurse			= mod3:NewTargetAnnounce(29304, 3)
local warnBleed			    = mod3:NewTargetAnnounce(85356, 3)
local warnEnrage			= mod3:NewAnnounce("Soft Enrage", 2, 29691)

function mod3:SPELL_AURA_APPLIED(args)
    if args:IsSpellID(29304) then
        warnHowlCurse:Show(args.destName)
    elseif args:IsSpellID(85356) then
        warnBleed:Show(args.destName)
    elseif args:IsSpellID(29691) then
        warnEnrage:Show(args.destName)
	end
end