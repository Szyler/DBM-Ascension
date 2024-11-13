local mod	= DBM:NewMod("Gelihast", "DBM-Party-Vanilla", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(6243)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningNet			= mod:NewTargetAnnounce(6533, 2)

local timerNetCD			= mod:NewCDTimer(180, 6533)

function mod:OnCombatStart(delay)
	timerNetCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(6533) then
		timerNetCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(6533) then
		warningNet:Show(args.destName)
	end
end
