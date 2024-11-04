local mod	= DBM:NewMod(485, "DBM-Party-Vanilla", 20, 241)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7272)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningFeveredPlague			= mod:NewTargetNoFilterAnnounce(8600, 2, nil, "RemoveDisease")
local warningThekaTransoform		= mod:NewSpellAnnounce(11089, 2)

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(11089) then
		warningThekaTransoform:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 8600 and args:IsDestTypePlayer() and self:CheckDispelFilter() then
		warningFeveredPlague:Show(args.destName)
	end
end
