local mod	= DBM:NewMod("Archimonde", "DBM-Hyjal", 1)

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(17968, 26647, 26648)
mod:RegisterCombat("combat")
mod:SetBossHealthInfo(26647, "Haaroon", 26648, "Narmak")

mod:RegisterEvents(
    "CHAT_MSG_MONSTER_YELL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)
-- Pre-fight
local timerNextBerserkerLeap			= mod:NewNextTimer(25, 2141551)
local timerNextFelFireCharge			= mod:NewNextTimer(25, 2141560)

-- All phases
local timerNextForceOfWill				= mod:NewNextTimer(45, 2141400)
local warnForceOfWill					= mod:NewSpecialWarningSpell(2141400)
local warnGraspOfTheDefiler				= mod:NewSpecialWarningYou(2141422)
local warnWardOfWinter					= mod:NewSpecialWarningYou(2140155)

-- Phase 2
local timerNextDoomfireMeteor			= mod:NewNextTimer(45, 2141405)

-- Phase 3
local timerNextSummonLivingLightnings	= mod:NewNextTimer(45, 2141473)
-- local timerNextLightningStrike		= mod:NewNextTimer(1, 2141456)

-- Phase 4
local timerNextGlimpseOfTomorrow		= mod:NewNextTimer(60, 2141604)
-- local timerNextCallOfTheVoid			= mod:NewNextTimer(1, 2141480)

function mod:OnCombatStart(delay)
	self.vb.phase = 0
    timerNextBerserkerLeap:Start(13 - delay)
	timerNextFelFireCharge:Start(18 - delay)
end

function mod:SPELL_AURA_APPLIED(args)
	self.vb.phase = self.vb.phase or 0 -- Hack! Getting comparisons with nil
    if args:IsSpellID(2141422, 2141423, 2141424, 2141425) and args:IsPlayer() then
        warnGraspOfTheDefiler:Show()
    elseif args:IsSpellID(2141450) and self.vb.phase < 2 then
        self.vb.phase = 2
        timerNextDoomfireMeteor:Stop()
		timerNextForceOfWill:Start()
		timerNextSummonLivingLightnings:Start(15)
    elseif args:IsSpellID(2141481) and self.vb.phase < 3 then
        self.vb.phase = 3
		timerNextSummonLivingLightnings:Stop()
		timerNextForceOfWill:Start()
		timerNextGlimpseOfTomorrow:Start(15)
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
        self.vb.phase = 1

        timerNextBerserkerLeap:Stop()
        timerNextFelFireCharge:Stop()

        timerNextForceOfWill:Start(30)
        timerNextDoomfireMeteor:Start(10)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2141400) then
		warnForceOfWill:Show()
		timerNextForceOfWill:Start()
	elseif args:IsSpellID(2141405) then
		timerNextDoomfireMeteor:Start()
	elseif args:IsSpellID(2141473) then
		timerNextSummonLivingLightnings:Start()
	elseif args:IsSpellID(2141604) then
		-- TODO: Might need to ignore first glimpse?
		timerNextGlimpseOfTomorrow:Start()
	elseif args:IsSpellID(2141560) then -- TODO: Remove this check or the cast success check...
		timerNextFelFireCharge:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2141551, 2141552) then
		timerNextBerserkerLeap:Start()
	elseif args:IsSpellID(2141560) then
		timerNextFelFireCharge:Start()
	end
end