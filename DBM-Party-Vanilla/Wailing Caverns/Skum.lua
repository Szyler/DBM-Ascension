local mod	= DBM:NewMod(478, "DBM-Party-Vanilla", 19, 240)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(3674)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START"
)

--TODO, fix range to one classic actually supports
local timerChainedBoltCD			= mod:NewAITimer(180, 6254, nil, nil, nil, 3)

mod:AddRangeFrameOption(10, 6254)

function mod:OnCombatStart(delay)
	timerChainedBoltCD:Start(1-delay)
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_CAST_START(args)
		if args:IsSpellID(6254) then
			timerChainedBoltCD:Start()
	end
end
