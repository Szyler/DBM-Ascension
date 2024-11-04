local mod	= DBM:NewMod("TwilightLordKelris", "DBM-Party-Vanilla", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4832)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

--TODO, maybe interrupt warning for mind blast
local warningSleep			= mod:NewTargetNoFilterAnnounce(8399, 2)

local timerSleepCD			= mod:NewAITimer(180, 8399, nil, nil, nil, 3, nil, DBM_CORE_L.MAGIC_ICON)

function mod:OnCombatStart(delay)
	timerSleepCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 8399 and args:IsSrcTypeHostile() then
		timerSleepCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 8399 and args:IsDestTypePlayer() then
		warningSleep:Show(args.destName)
	end
end
