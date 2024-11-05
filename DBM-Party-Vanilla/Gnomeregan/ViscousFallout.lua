local mod	= DBM:NewMod(420, "DBM-Party-Vanilla", 7, 231)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7079)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warningToxicVolley			= mod:NewSpellAnnounce(21687, 2, nil, "Healer|RemovePoison")

local timerToxicVolleyCD			= mod:NewCDTimer(180, 21687)

function mod:OnCombatStart(delay)
	timerToxicVolleyCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(21687) then
		warningToxicVolley:Show()
		timerToxicVolleyCD:Start()
	end
end
