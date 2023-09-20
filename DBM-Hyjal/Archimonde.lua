local mod	= DBM:NewMod("Archimonde", "DBM-Hyjal", 1)

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(17968, 117968, 217968, 317968)
mod:RegisterCombat("yell", "Fight! Fight to your dying breath!")

mod:RegisterEvents(
    "CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)
-- Pre-fight
local nextBerserkerLeap	        	= mod:NewNextTimer(25, 2141551)
local nextFelFireCharge		        = mod:NewNextTimer(25, 2141560)

-- All phases
local nextForceOfWill               = mod:NewNextTimer(45, 2141400)
local castForceOfWill               = mod:NewSpecialWarningSpell(2141400)
local warnGraspOfTheDefiler	        = mod:NewSpecialWarningYou(2141422)
local warnWardOfWinter  	        = mod:NewSpecialWarningYou(2140155)

-- Phase 2
local nextDoomfireMeteor            = mod:NewNextTimer(45, 2141405)

-- Phase 3
local nextSummonLivingLightnings    = mod:NewNextTimer(45, 2141473)
-- local nextLightningStrike           = mod:NewNextTimer(1, 2141456)

-- Phase 4
local nextGlimpseOfTomorrow         = mod:NewNextTimer(60, 2141604)
-- local nextCallOfTheVoid             = mod:NewNextTimer(1, 2141480)

local current_phase = 0

function mod:OnCombatStart(delay)
    current_phase = 0
    nextBerserkerLeap:Start(-delay - 20)
	nextFelFireCharge:Start(-delay - 15)
end

function mod:SPELL_AURA_APPLIED(args)
    if args:IsSpellID(2141422, 2141423, 2141424, 2141425) and args:IsPlayer() then
        warnGraspOfTheDefiler:Show()
    elseif current_phase < 2 and args:IsSpellID(2141450) then
        current_phase = 2
        nextDoomfireMeteor:Stop()
		nextSummonLivingLightnings:Start(-30)
    elseif current_phase < 3 and args:IsSpellID(2141481) then
        current_phase = 3
		nextSummonLivingLightnings:Stop()
		nextGlimpseOfTomorrow:Start(-45)
    elseif args:IsSpellID(2140155, 2140156) and args:IsPlayer() then
        warnWardOfWinter:Show()
    end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
    if args:IsSpellID(2141422, 2141423, 2141424, 2141425) and args:IsPlayer() then
        warnGraspOfTheDefiler:Show()
    end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == "Your resistance is insignificant." then
        current_phase = 1

        nextBerserkerLeap:Stop()
        nextFireCharge:Stop()

        nextForceOfWill:Start(-15)
        nextDoomfireMeteor:Start(-35)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2141400) then
		castForceOfWill:Show()
		nextForceOfWill:Start()
	elseif args:IsSpellID(2141405) then
		nextDoomfireMeteor:Start()
	elseif args:IsSpellID(2141473) then
		nextSummonLivingLightnings:Start()
	elseif args:IsSpellID(2141604) then
		-- TODO: Might need to ignore first glimpse?
		nextGlimpseOfTomorrow:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2141551, 2141552) then
		nextBerserkerLeap:Start()
	elseif args:IsSpellID(2141560) then
		nextFelFireCharge:Start()
	end
end