local mod	= DBM:NewMod(423, "DBM-Party-Vanilla", 8, 232)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(13282)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

--TODO, spawns affect uppercut timer?
local warningSpawns					= mod:NewSpellAnnounce(21707, 2)
local warningUppercut				= mod:NewSpellAnnounce(10966, 2)

local timerSpawnsCD					= mod:NewCDTimer(180, 21707)
local timerUppercutCD				= mod:NewCDTimer(180, 10966)

function mod:OnCombatStart(delay)
	timerSpawnsCD:Start(1-delay)--6
	timerUppercutCD:Start(1-delay)--18
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(10966) then
		warningUppercut:Show()
		timerUppercutCD:Start()
	elseif args:IsSpellID(21707) then
		warningSpawns:Show()
		timerSpawnsCD:Start()
	end
end
