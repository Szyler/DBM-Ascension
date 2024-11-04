local mod	= DBM:NewMod(418, "DBM-Party-Vanilla", 7, 231)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(6229)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local specWarnCrowdPummel			= mod:NewSpecialWarningSpell(10887, "Melee", nil, nil, 2, 2)

local timerCrowdPummelCD			= mod:NewAITimer(180, 10887, nil, nil, nil, 2)

local timerArcingSmashD				= mod:NewAITimer(180, 8374, nil, "Tank", 2, 5, nil, DBM_CORE_L.TANK_ICON)

function mod:OnCombatStart(delay)
	timerCrowdPummelCD:Start(1-delay)
	timerArcingSmashD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(10887) then
		specWarnCrowdPummel:Show()
		specWarnCrowdPummel:Play("carefly")
		timerCrowdPummelCD:Start()
	elseif args.spellId == 8374 then
		timerArcingSmashD:Start()
	end
end
