local mod	= DBM:NewMod(483, "DBM-Party-Vanilla", 20, 241)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7273)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

--TODO, no indication she actually has a heal, only lightning bolt and throns
local warningFreezeSolid			= mod:NewTargetAnnounce(11836, 2)
local warningSlam					= mod:NewSpellAnnounce(11902, 2)

local timerFreezeSolidCD			= mod:NewCDTimer(180, 11836)
local timerSlamCD					= mod:NewCDTimer(180, 11902)

function mod:OnCombatStart(delay)
	timerFreezeSolidCD:Start(1-delay)
	timerSlamCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(11836) then
		timerFreezeSolidCD:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(11836) then
		warningFreezeSolid:Show(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(11902) then
		warningSlam:Show()
		timerSlamCD:Start()
	end
end
