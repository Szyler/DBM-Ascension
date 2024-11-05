local mod	= DBM:NewMod("BaronSilverlaine", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3887)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

local warningVeilofShadow			= mod:NewTargetAnnounce(7068, 2)

local timerVeilofShadowCD			= mod:NewCDTimer(180, 7068)

function mod:OnCombatStart(delay)
	timerVeilofShadowCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(7068) then
		timerVeilofShadowCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(7068) then
		warningVeilofShadow:Show(args.destName)
	end
end
