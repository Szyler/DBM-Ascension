local mod	= DBM:NewMod("Ragglesnout", "DBM-Party-Vanilla", 10)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7354)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

local warningDominateMind			= mod:NewTargetAnnounce(7645, 2)

local specWarnHeal					= mod:NewInterruptAnnounce(12039)

local timerHealCD					= mod:NewCDTimer(180, 12039)
local timerDominateMindCD			= mod:NewCDTimer(180, 7645)

function mod:OnCombatStart(delay)
	timerHealCD:Start(1-delay)
	timerDominateMindCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(12039) then
		timerHealCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal:Show(args.sourceName)
			specWarnHeal:Play("kickcast")
		end
	elseif args:IsSpellID(7645) then
		timerDominateMindCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(7645) then
		warningDominateMind:Show(args.destName)
	end
end
