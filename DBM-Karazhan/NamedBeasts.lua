local mod1	= DBM:NewMod("Shadikith", "DBM-Karazhan")
local L		= mod1:GetLocalizedStrings()
mod1:SetCreatureID(16180)
mod1:RegisterCombat("combat")

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

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(29901) and args.amount > 2 then
        warnAcidicFang:Show(args.spellName, args.destName, args.amount or 1)
	end
end

local mod3	= DBM:NewMod("Rokad", "DBM-Karazhan")
local L		= mod3:GetLocalizedStrings()
mod3:SetCreatureID(16181)
mod3:RegisterCombat("combat")