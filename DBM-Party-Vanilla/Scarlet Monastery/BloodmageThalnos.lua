local mod	= DBM:NewMod("BloodmageThalnos", "DBM-Party-Vanilla", 12)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4543)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

--TODO, still can't use CD timer yet because only have initial timers from a single log, Fire nova timer too variable (8.5, 21 wtf?) to be useful
local warningFlameSpike				= mod:NewSpellAnnounce(8814, 2)
local warningFireNova				= mod:NewSpellAnnounce(12470, 2)

local timerFlameSpikeCD				= mod:NewAITimer(180, 8814, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
--	timerFlameSpikeCD:Start(15.8-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(8814) then
		warningFlameSpike:Show()
		timerFlameSpikeCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(12470) then
		warningFireNova:Show()
	end
end
