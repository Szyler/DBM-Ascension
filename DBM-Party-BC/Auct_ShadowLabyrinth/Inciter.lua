local mod = DBM:NewMod("Inciter", "DBM-Party-BC", 10)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))

mod:SetCreatureID(18667)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warnChaos         	= mod:NewSpellAnnounce(9931019)
local timerChaos        	= mod:NewBuffActiveTimer(8, 9931019)
local timerNextChaos    	= mod:NewNextTimer(50, 9931019)
local timerNextCharge    	= mod:NewNextTimer(20, 33709)
local warnCharge			= mod:NewTargetAnnounce(33709, 3)
-- local warnStomp         	= mod:NewSpellAnnounce(833707)
local timerNextStomp    	= mod:NewNextTimer(20, 833707)

function mod:OnCombatStart(delay)
    timerNextChaos:Start(30-delay)
    timerNextCharge:Start(8-delay)
    timerNextStomp:Start(16-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 9931019 then
		warnChaos:Show()
		timerChaos:Start()
		timerNextChaos:Start()
	elseif args.spellId == 33709 then
		warnCharge:Show()
		timerNextCharge:Start()
	elseif args.spellId == 833707 then
		-- warnStomp:Show()
		if timerNextChaos:GetTime() < 20 then 
			timerNextStomp:Start(30)
		else
			timerNextStomp:Start()
		end
	end
end

-- 33709 - Charge
-- 833707 - War Stomp
-- 9931019 - Incite Chaos (old = 33676)