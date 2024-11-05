local mod	= DBM:NewMod(486, "DBM-Party-Vanilla", 20, 241)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7271)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

local warningWardZumrah				= mod:NewSpellAnnounce(11086, 2)

local specWarnHealingWave			= mod:NewInterruptAnnounce(12491)
local specWarnShadowBoltVolley		= mod:NewInterruptAnnounce(15245)

local timerWardZumrahCD				= mod:NewCDTimer(180, 11086)
local timerHealingWaveCD			= mod:NewCDTimer(180, 12491)
local timerShadowBoltVolleyCD		= mod:NewCDTimer(180, 15245)

function mod:OnCombatStart(delay)
	timerWardZumrahCD:Start(1-delay)
	timerHealingWaveCD:Start(1-delay)
	timerShadowBoltVolleyCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(12491) then
		timerHealingWaveCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHealingWave:Show(args.sourceName)
			specWarnHealingWave:Play("kickcast")
		end
	elseif args:IsSpellID(15245) then
		timerShadowBoltVolleyCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnShadowBoltVolley:Show(args.sourceName)
			specWarnShadowBoltVolley:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(11086) then
		warningWardZumrah:Show()
		timerWardZumrahCD:Start()
	end
end
