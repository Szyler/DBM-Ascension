local mod	= DBM:NewMod(463, "DBM-Party-Vanilla", 17, 237)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(5709)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningDeepSlumber			= mod:NewTargetNoFilterAnnounce(12890, 2)
local warningAcidBreath				= mod:NewSpellAnnounce(12533, 2)
local warningWarStomp				= mod:NewSpellAnnounce(24375, 2)

local timerDeepSlumberCD			= mod:NewAITimer(180, 12890, nil, nil, nil, 3, nil, DBM_CORE_L.MAGIC_ICON)
local timerAcidBreathCD				= mod:NewAITimer(180, 12533, nil, nil, nil, 5, nil, DBM_CORE_L.TANK_ICON)
local timerWarStompCD				= mod:NewAITimer(180, 24375, nil, nil, nil, 2)

function mod:OnCombatStart(delay)
	timerDeepSlumberCD:Start(1-delay)
	timerAcidBreathCD:Start(1-delay)
	timerWarStompCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(12890) then
		timerDeepSlumberCD:Start()
	elseif args:IsSpellID(12533) then
		warningAcidBreath:Show()
		timerAcidBreathCD:Start()
	elseif args:IsSpellID(24375) then
		warningWarStomp:Show()
		timerWarStompCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(12890) then
		warningDeepSlumber:Show(args.destName)
	end
end
