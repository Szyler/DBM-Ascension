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

local specWarnFrostbolt				= mod:NewInterruptAnnounce(12675)
local specWarnFrostSpectres			= mod:NewSpecialWarningSwitch(13322, "-Healer", nil, nil, 1, 2)

local timerAmnennarsWrathCD			= mod:NewCDTimer(180, 13009)
local timerFrostboltCD				= mod:NewCDTimer(180, 12675)
local timerSummonFrostSpectresCD	= mod:NewCDTimer(180, 13322)

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
