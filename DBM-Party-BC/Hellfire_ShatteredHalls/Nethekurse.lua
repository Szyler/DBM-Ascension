local mod	= DBM:NewMod("Nethekurse", "DBM-Party-BC", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(16807)

mod:RegisterCombat("combat")


mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
    "SPELL_SUMMON",
    "SPELL_AURA_APPLIED"
)

local timerShadowSlam		= mod:NewCDTimer(7, 29544)
local timerDeathcoil		= mod:NewNextTimer(7, 29544)
local timerDeathcoil		= mod:NewTargetTimer(12, 831623)
local warnFear			    = mod:NewTargetAnnounce(39661, 3)
local warnVoid			    = mod:NewSpellAnnounce(30496, 3)
local timerVoid		        = mod:NewNextTimer(12, 30496)
local warnBerserk			= mod:NewSpellAnnounce(30502)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 35953 then
		timerShadowSlam:Start()
	elseif args.spellId == 39661 then
		warnFear:Show()
		timerDeathcoil:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args.spellId == 30496 then
		warnVoid:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 30502 then
		warnBerserk:Show()
	end
end


-- 35953 - Shadow Slam
-- 39661 - Death Coil
-- 30496 - Lesser Shadow Fissure
-- 30502 - Dark Spin