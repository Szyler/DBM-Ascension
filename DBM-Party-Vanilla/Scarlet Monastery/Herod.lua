local mod	= DBM:NewMod("Herod", "DBM-Party-Vanilla", 12)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3975)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

local warningEnrage					= mod:NewTargetNoFilterAnnounce(8269, 2)

local specWarnWhirlwind				= mod:NewSpecialWarningRun(8989, nil, nil, nil, 4, 2)

local timerWhirlwindCD				= mod:NewCDTimer(18, 8989, nil, nil, nil, 4, nil, DBM_CORE_L.DEADLY_ICON)

function mod:OnCombatStart(delay)
	timerWhirlwindCD:Start(10.5-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(8269) then
		specWarnWhirlwind:Show()
		specWarnWhirlwind:Play("justrun")
		timerWhirlwindCD:Start()
	elseif args.spellName == Enrage and args:IsDestTypeHostile() then
		warningEnrage:Show(args.destName)
	end
end
