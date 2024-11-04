local mod	= DBM:NewMod("AmnennartheColdbringer", "DBM-Party-Vanilla", 10)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7358)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

--TODO, check/fix frostbolt spellId
local warningAmnennarsWrath			= mod:NewSpellAnnounce(13009, 2)

local specWarnFrostbolt				= mod:NewSpecialWarningInterrupt(12675, "HasInterrupt", nil, nil, 1, 2)
local specWarnFrostSpectres			= mod:NewSpecialWarningSwitch(13322, "-Healer", nil, nil, 1, 2)

local timerAmnennarsWrathCD			= mod:NewAITimer(180, 13009, nil, nil, nil, 2)
local timerFrostboltCD				= mod:NewAITimer(180, 12675, nil, nil, nil, 4, nil, DBM_CORE_L.INTERRUPT_ICON..DBM_CORE_L.MAGIC_ICON)
local timerSummonFrostSpectresCD	= mod:NewAITimer(180, 13322, nil, nil, nil, 1, nil, DBM_CORE_L.DAMAGE_ICON)

function mod:OnCombatStart(delay)
	timerAmnennarsWrathCD:Start(1-delay)
	timerFrostboltCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(12675) then
		timerFrostboltCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnFrostbolt:Show(args.sourceName)
			specWarnFrostbolt:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(13009) then
		warningAmnennarsWrath:Show()
		timerAmnennarsWrathCD:Start()
	elseif args:IsSpellID(12642) then
		specWarnFrostSpectres:Show()
		specWarnFrostSpectres:Play("killmob")
		timerSummonFrostSpectresCD:Start()
	end
end
