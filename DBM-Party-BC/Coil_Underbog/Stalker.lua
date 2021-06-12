local mod	= DBM:NewMod("Stalker", "DBM-Party-BC", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(17882)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED"
)

local warnChain		 			= mod:NewSpellAnnounce(831717, 3)
local timerLightningCast		= mod:NewCastTimer(4, 831717)
local timerNextLightning		= mod:NewNextTimer(8, 831717)
local timerStatic				= mod:NewTargetTimer(12, 831715)
local timerNextStatic			= mod:NewNextTimer(8, 831715)
local warnStatic		 		= mod:NewSpellAnnounce(831715, 3)
local timerNextLevitate			= mod:NewNextTimer(29, 31704)

function mod:OnCombatStart(delay)
	timerNextLightning:Start(-delay)
	timerNextStatic:Start(15-delay)
	timerNextLevitate:Start(-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 831717 then
		warnChain:Show()
		timerLightningCast:Start()
		if timerNextLevitate:GetTime() < 8 then
			timerNextLightning:Start(13)
		else
			timerNextLightning:Start()
		end
	elseif args.spellId == 831715 then
		warnStatic:Show()
		timerStatic:Start(args.destName)
		timerNextStatic:Start()
	elseif args.spellId == 31704 then
		timerNextLevitate:Start()
	end
end

-- 38755 - Summon Spore Strider
-- 831717 - Chain Lightning
-- 31704 - Levitate
-- 831715 - Static Charge