local mod	= DBM:NewMod("ArchmageArugal", "DBM-Party-Vanilla", 14)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(4275)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningArugalsCurse			= mod:NewTargetNoFilterAnnounce(7621, 2)
local warningShadowPort				= mod:NewSpellAnnounce(7587, 2)

local timerArugalsCurseCD			= mod:NewAITimer(180, 7621, nil, nil, nil, 3, nil, DBM_CORE_L.CURSE_ICON)
local timerShadowPortCD				= mod:NewAITimer(180, 7587, nil, nil, nil, 6)

function mod:OnCombatStart(delay)
	timerArugalsCurseCD:Start(1-delay)
	timerShadowPortCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(7621) then
		timerArugalsCurseCD:Start()
	elseif args:IsSpellID(7587) then
		warningShadowPort:Show()
		timerShadowPortCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(7621) then
		warningArugalsCurse:Show(args.destName)
	end
end
