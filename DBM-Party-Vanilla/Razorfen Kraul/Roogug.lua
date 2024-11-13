local mod	= DBM:NewMod("Roogug", "DBM-Party-Vanilla", 11)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(6168)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

--Rumbler spawned on engage
local warningSummonEarthRumbler		= mod:NewSpellAnnounce(8270, 2)

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(8270) then
		warningSummonEarthRumbler:Show()
	end
end
