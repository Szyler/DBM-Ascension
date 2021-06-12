local mod	= DBM:NewMod("Tavarok", "DBM-Party-BC", 8)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))
mod:SetCreatureID(18343)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local WarnPrison   					= mod:NewTargetAnnounce(32361)
local timerPrison   				= mod:NewTargetTimer(5, 32361)
local timerNextPrison   			= mod:NewNextTimer(15, 32361)
local warnEarthquake		 		= mod:NewSpellAnnounce(33919, 3)
local timerNextEarthquake   		= mod:NewNextTimer(16, 33919)
local timerNextArcing   			= mod:NewCDTimer(9, 38761)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(32361) then
		WarnPrison:Show(args.destName)
		timerPrison:Start(args.destName)
		timerNextPrison:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(32361) then
		timerPrison:Cancel(args.destName)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(33919) then
		warnEarthquake:Show()
		timerNextEarthquake:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 38761 then
		timerNextArcing:Start()
	end
end

-- 32361 - Crystal Prison
-- 33919 - Earthquake
-- 38761 - Arcing Smash