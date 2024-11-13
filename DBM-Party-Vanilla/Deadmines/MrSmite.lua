local mod	= DBM:NewMod("MrSmite", "DBM-Party-Vanilla", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(646)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningSmiteSlam		= mod:NewTargetAnnounce(6435, 2)
local warningNimbleReflexes	= mod:NewTargetAnnounce(6264, 2)

local timerSmiteStomp		= mod:NewBuffActiveTimer(10, 6432)

--function mod:OnCombatStart(delay)

--end

function mod:SPELL_CAST_SUCCESS(args)
		if args:IsSpellID(6432) then
			timerSmiteStomp:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(6435) then
		warningSmiteSlam:Show(args.destName)
	elseif args:IsSpellID(6264) then
		warningNimbleReflexes:Show(args.destName)
	end
end
