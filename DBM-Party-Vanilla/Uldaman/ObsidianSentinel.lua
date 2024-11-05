local mod	= DBM:NewMod(748, "DBM-Party-Vanilla", 18, 239)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7023)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningReflection				= mod:NewTargetAnnounce(9941, 2)
local warningSplinteredObsidian		= mod:NewSpellAnnounce(10072, 2)

function mod:SPELL_CAST_SUCCESS(args)
	--if args.spellId == 10072 and self:AntiSpam(3, 1) then
	if args.spellId == 10072 and self:AntiSpam(3, 1) then
		warningSplinteredObsidian:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	--if args.spellId == 9941 and self:AntiSpam(3, args.destName) then
	if args.spellId == 9941 and self:AntiSpam(3, args.destName) then
		warningReflection:Show(args.destName)
	end
end
