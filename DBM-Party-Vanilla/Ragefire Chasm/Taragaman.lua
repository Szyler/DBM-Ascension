local mod	= DBM:NewMod("Taragaman", "DBM-Party-Vanilla", 9)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(11520)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warningUppercut			= mod:NewSpellAnnounce(18072, 3, nil, "Tank", 2)
local warningFireNova			= mod:NewSpellAnnounce(11970, 3)

local timerUppercutCD			= mod:NewCDTimer(180, 18072)
local timerFireNovaCD			= mod:NewCDTimer(180, 11970)

function mod:OnCombatStart(delay)
	timerUppercutCD:Start(1-delay)
	timerFireNovaCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(18072) then
		warningUppercut:Show()
		timerUppercutCD:Start()
	elseif args:IsSpellID(11970) then
		warningFireNova:Show()
		timerFireNovaCD:Start()
	end
end
