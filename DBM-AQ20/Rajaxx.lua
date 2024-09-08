local mod	= DBM:NewMod("Rajaxx", "DBM-AQ20", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 171 $"):sub(12, -3))
mod:SetCreatureID(15341)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE"
)



function mod:OnCombatStart(delay)
end

local specWarnSpellReflect	= mod:NewSpecialWarning("Spell Reflect: Stop Casting", nil, "Special warning for Spell Reflect") --4500009)
local warnSpellReflect    = mod:NewSpellAnnounce(1002113)
local warnLust		= mod:NewSpellAnnounce(1002090, 4)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1002113) then
		warnSpellReflect:Show()
		specWarnSpellReflect:Show()
	elseif args:IsSpellID(1002090) then
		warnLust:Show()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(1002090) then
		warnLust:Show()
	end
end