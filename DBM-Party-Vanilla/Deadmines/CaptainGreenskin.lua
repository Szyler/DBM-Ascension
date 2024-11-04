local mod	= DBM:NewMod("CaptainGreenskin", "DBM-Party-Vanilla", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(647)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

--TODO, consider a cleave timer if not cast too often
local warningPoisonedHarpoon		= mod:NewTargetNoFilterAnnounce(5208, 2, nil, "RemovePoison")

local timerPoisonedHarpoonCD		= mod:NewAITimer(30, 5208, nil, "RemovePoison", nil, 5, nil, DBM_CORE_L.POISON_ICON)

function mod:OnCombatStart(delay)
	timerPoisonedHarpoonCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(5208) then
		timerPoisonedHarpoonCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(5208) then
		warningPoisonedHarpoon:Show(args.destName)
	end
end
