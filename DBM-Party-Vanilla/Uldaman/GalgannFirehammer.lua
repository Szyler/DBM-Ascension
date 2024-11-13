local mod	= DBM:NewMod(471, "DBM-Party-Vanilla", 18, 239)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7291)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local warningFireNova				= mod:NewSpellAnnounce(11969, 2)

local specWarnFlameSpike			= mod:NewInterruptAnnounce(6725)
local specWarnFlameLash				= mod:NewInterruptAnnounce(3356)

local timerFireNovaCD				= mod:NewCDTimer(180, 11969)

function mod:OnCombatStart(delay)
	timerFireNovaCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(6725) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnFlameSpike:Show(args.sourceName)
			specWarnFlameSpike:Play("kickcast")
		end
	elseif args:IsSpellID(3356) then
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnFlameLash:Show(args.sourceName)
			specWarnFlameLash:Play("kickcast")
		end
	elseif args:IsSpellID(11969) then
		warningFireNova:Show()
		timerFireNovaCD:Start()
	end
end
