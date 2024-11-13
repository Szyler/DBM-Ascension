local mod	= DBM:NewMod("Hamhock", "DBM-Party-Vanilla", 15)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(1717)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

--TODO, add timer for chain lightning if it's not spam cast
local warningBloodlust				= mod:NewTargetAnnounce(6742, 2)

mod:AddRangeFrameOption("10")

function mod:OnCombatStart(delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(6742) then
		warningBloodlust:Show(args.destName)
	end
end
