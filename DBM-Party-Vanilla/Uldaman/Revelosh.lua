local mod	= DBM:NewMod(467, "DBM-Party-Vanilla", 18, 239)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(6910)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local specWarnChainLightning			= mod:NewInterruptAnnounce(16006)
local specWarnLightningBolt				= mod:NewInterruptAnnounce(15801)

local timerChainLightningCD				= mod:NewCDTimer(180, 16006)
local timerLightningBoltCD				= mod:NewCDTimer(180, 15801)

function mod:OnCombatStart(delay)
	timerChainLightningCD:Start(1-delay)
	timerLightningBoltCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(16006) then
		timerChainLightningCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnChainLightning:Show(args.sourceName)
			specWarnChainLightning:Play("kickcast")
		end
	elseif args:IsSpellID(15801) then
		timerLightningBoltCD:Start()
		if self:CheckInterruptFilter(args.sourceGUID, false, true) then
			specWarnLightningBolt:Show(args.sourceName)
			specWarnLightningBolt:Play("kickcast")
		end
	end
end
