local mod	= DBM:NewMod("AgathelostheRaging", "DBM-Party-Vanilla", 11)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4422)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

--https://classic.wowhead.com/spell=8555/left-for-dead nani? is wowhead tripping? no mention of this in comments or guides
local warningEnrage				= mod:NewTargetAnnounce(8269, 2)

--function mod:OnCombatStart(delay)

--end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(8269) then
		warningEnrage:Show(args.destName)
	end
end
