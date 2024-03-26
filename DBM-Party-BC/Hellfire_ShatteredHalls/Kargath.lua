local mod	= DBM:NewMod("Kargath", "DBM-Party-BC", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(16808)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE"
)

local timerBladeDance		= mod:NewNextTimer(30, 30739)
local warnBladeDance	    = mod:NewSpellAnnounce(30739, 3)
local timerCharge	    	= mod:NewNextTimer(30, 30600)

function mod:OnCombatStart(delay)
	timerBladeDance:Start(35)
	timerCharge:Start(48)
end

local BladeDanceSpam = 0
function mod:SPELL_DAMAGE(args)
	if args.spellId == 25821 then
		timerCharge:Start()
	elseif args:IsSpellID(28375, 30739) and (GetTime() - BladeDanceSpam) > 20 then
		BladeDanceSpam = GetTime()
		warnBladeDance:Show()
		timerBladeDance:Start()
	end
end

-- 30739 - Blade Dance
-- 25821 - Charge
