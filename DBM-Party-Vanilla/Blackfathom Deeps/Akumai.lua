local mod	= DBM:NewMod("Akumai", "DBM-Party-Vanilla", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4829)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warningPoisonCloud		= mod:NewSpellAnnounce(3815, 4)
local warningFrenziedRage		= mod:NewSpellAnnounce(3490, 4)

local timerPoisonCloudCD		= mod:NewAITimer(180, 3815, nil, nil, nil, 3)
local timerFrenziedRageCD		= mod:NewAITimer(180, 3490, nil, nil, nil, 5, nil, DBM_CORE_L.TANK_ICON)

function mod:OnCombatStart(delay)
	timerPoisonCloudCD:Start(1-delay)
	timerFrenziedRageCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(3815) then
		warningPoisonCloud:Show()
		timerPoisonCloudCD:Start()
	elseif args:IsSpellID(3490) then
		warningFrenziedRage:Show()
		timerFrenziedRageCD:Start()
	end
end