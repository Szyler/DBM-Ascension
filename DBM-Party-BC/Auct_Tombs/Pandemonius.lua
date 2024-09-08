local mod	= DBM:NewMod("Pandemonius", "DBM-Party-BC", 8)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(18341)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_DAMAGE"
)

local warnShell     			= mod:NewSpellAnnounce(32358, 3)
local timerShell    			= mod:NewBuffActiveTimer(7, 32358)
local timerNextShell			= mod:NewNextTimer(20, 32358)
local timerNextBlast			= mod:NewNextTimer(20, 32325)

function mod:OnCombatStart(delay)
	timerNextBlast:Start(10-delay)
	timerNextShell:Start(20-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(32358, 38759) then
		warnShell:Show()
		timerShell:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(32325) then
		timerNextBlast:Start()
	end
end

-- 32325 - Void Blast