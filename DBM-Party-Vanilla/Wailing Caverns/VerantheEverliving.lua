local mod	= DBM:NewMod(480, "DBM-Party-Vanilla", 19, 240)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(5775)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local warnVines			= mod:NewSpellAnnounce(8142, 2)

local timerVinesCD		= mod:NewCDTimer(180, 8142)

function mod:OnCombatStart(delay)
	timerVinesCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(8142) then
		warnVines:Show(args.sourceName)
		timerVinesCD:Start()
	end
end
