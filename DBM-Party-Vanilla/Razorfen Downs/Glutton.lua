local mod	= DBM:NewMod("Glutton", "DBM-Party-Vanilla", 10)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(8567)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

--TODO, add Disease Cloud when data is known
local warningEnrage					= mod:NewSpellAnnounce(12795, 2)

--[[
function mod:OnCombatStart(delay)

end
--]]

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(12795) then
		warningEnrage:Show()
	end
end
