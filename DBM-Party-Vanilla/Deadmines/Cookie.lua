local mod	= DBM:NewMod("Cookie", "DBM-Party-Vanilla", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(645)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local specWarnHeal			= mod:NewInterruptAnnounce(5174)

local timerHealCD			= mod:NewCDTimer(180, 5174)

function mod:OnCombatStart(delay)
	timerHealCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(5174) then
		timerHealCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal:Show(args.sourceName)
			specWarnHeal:Play("kickcast")
		end
	end
end
