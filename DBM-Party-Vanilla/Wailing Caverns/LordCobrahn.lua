local mod	= DBM:NewMod(475, "DBM-Party-Vanilla", 19, 240)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3669)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningDruidSlumber			= mod:NewTargetAnnounce(8040, 2)
local warningHealingTouch			= mod:NewCastAnnounce(23381, 2)
local warningPoison					= mod:NewTargetAnnounce(17330, 2, nil, "RemovePoison")

local specWarnDruidsSlumber			= mod:NewInterruptAnnounce(8040)

local timerDruidsSlumberCD			= mod:NewCDTimer(180, 8040)
local timerHealingTouchCD			= mod:NewCDTimer(180, 23381)
local timerPoisonCD					= mod:NewCDTimer(180, 23381)

function mod:OnCombatStart(delay)
	timerDruidsSlumberCD:Start(1-delay)
	timerHealingTouchCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(8040) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnDruidsSlumber:Show(args.sourceName)
			specWarnDruidsSlumber:Play("kickcast")
		end
	elseif args:IsSpellID(23381) then
		warningHealingTouch:Show()
		timerHealingTouchCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(7965) then
		timerDruidsSlumberCD:Stop()
		timerHealingTouchCD:Stop()
		timerPoisonCD:Start(1)
	elseif args:IsSpellID(17330) then
		timerPoisonCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(8040) then
		warningDruidSlumber:Show(args.destName)
	--elseif args.spellId == 17330 and self:CheckDispelFilter() then
	elseif args.spellName == Poison and args:IsDestTypePlayer() and self:CheckDispelFilter() then
		warningPoison:Show(args.destName)
	end
end
