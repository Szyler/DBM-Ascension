local mod	= DBM:NewMod("OverlordRamtusk", "DBM-Party-Vanilla", 11)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4420)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local warningWhirlingBarrage		= mod:NewCastAnnounce(8259, 2)

--function mod:OnCombatStart(delay)

--end

function mod:SPELL_CAST_START(args)
	--if args.spellId == 8259 and self:AntiSpam(3, 1) then
	if args.spellId == 8259 and self:AntiSpam(3, 1) then
		warningWhirlingBarrage:Show()
	end
end
