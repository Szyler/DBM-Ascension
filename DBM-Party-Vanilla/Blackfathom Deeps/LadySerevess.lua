local mod	= DBM:NewMod("LadySerevess", "DBM-Party-Vanilla", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4831)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningSlow			= mod:NewTargetAnnounce(246, 2)

local timerSlowCD			= mod:NewCDTimer(180, 246)

function mod:OnCombatStart(delay)
	timerSlowCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	--if args.spellId == 246 and args:IsSrcTypeHostile() then
	if args.spellId == 246 and args:IsSrcTypeHostile() then
		timerSlowCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	--if args.spellId == 246 and args:IsDestTypePlayer() then
	if args.spellId == 246 and args:IsDestTypePlayer() then
		warningSlow:Show(args.destName)
	end
end
