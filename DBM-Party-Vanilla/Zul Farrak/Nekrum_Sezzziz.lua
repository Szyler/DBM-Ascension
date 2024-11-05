local mod	= DBM:NewMod(487, "DBM-Party-Vanilla", 20, 241)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7796, 7275)--nekrum-gutchewer, shadowpriest-sezzziz

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"UNIT_DIED"
)

local warningFeveredPlague			= mod:NewTargetAnnounce(8600, 2, nil, "RemoveDisease")

local specWarnRenew					= mod:NewInterruptAnnounce(8362)
local specWarnHeal					= mod:NewInterruptAnnounce(12039)

local timerRenewCD					= mod:NewCDTimer(180, 8362)
local timerHealCD					= mod:NewCDTimer(180, 12039)
local timerPsychicScreamCD			= mod:NewCDTimer(180, 13704)

function mod:OnCombatStart(delay)
	timerRenewCD:Start(1-delay)
	timerHealCD:Start(1-delay)
	timerPsychicScreamCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(8362) then
		timerRenewCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnRenew:Show(args.sourceName)
			specWarnRenew:Play("kickcast")
		end
	elseif args:IsSpellID(12039) then
		timerHealCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnHeal:Show(args.sourceName)
			specWarnHeal:Play("kickcast")
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(13704) then
		timerPsychicScreamCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 8600 and args:IsDestTypePlayer() and self:CheckDispelFilter() then
		warningFeveredPlague:Show(args.destName)
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 7275 then--sezzziz
		timerRenewCD:Stop()
		timerHealCD:Stop()
		timerPsychicScreamCD:Stop()
	end
end
