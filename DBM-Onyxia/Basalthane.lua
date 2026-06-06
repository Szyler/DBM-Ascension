local mod	= DBM:NewMod("Basalthane", "DBM-Onyxia")
local L		= mod:GetLocalizedStrings()

-- CONSTANTS --
local bossId = 1114325

local enrageSeconds = 510

local eruptionSpellId = 2108227
local infernoTrailSpellId = 2108217
local strikeSpellId = 2108206
local crackedArmorAuraId = 2108234
-- END CONSTANTS --


mod:SetRevision(("$Revision: 1 $"):sub(12, -3))
mod:SetCreatureID(bossId)

mod:RegisterCombat("combat")
mod:RegisterEvents(
    "SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
    "SPELL_AURA_APPLIED_DOSE"
)


local warnEruption          = mod:NewTargetAnnounce(eruptionSpellId, 5)
local warnInfernoTrail	 	= mod:NewCastAnnounce(infernoTrailSpellId, 3)
local warnStrike   	        = mod:NewCastAnnounce(strikeSpellId, 1)

local specWarnEruptionYou	= mod:NewSpecialWarningYou(eruptionSpellId, 2)

local timerEnrage		    = mod:NewBerserkTimer(enrageSeconds)

local timerEruption 	    = mod:NewCastTimer(5, eruptionSpellId)
local timerInfernoTrail	    = mod:NewCastTimer(2.5, infernoTrailSpellId)
local timerStrike   	    = mod:NewCastTimer(1, strikeSpellId)

local timerNextEruption     = mod:NewCDTimer(60, eruptionSpellId)
local timerNextInfernoTrail = mod:NewCDTimer(14, infernoTrailSpellId)
local timerNextStrike   	= mod:NewCDTimer(15, strikeSpellId)

local timerAuraCrackedArmor = mod:NewBuffActiveTimer(20, crackedArmorAuraId)

function mod:OnCombatStart(delay)
    timerEnrage:Start(-delay)
end

function announceEruptionTarget()
    local targetName = nil
    target = mod:GetBossTarget(bossId)
    local selfName = UnitName("player")
    if targetName == selfName then
        specWarnEruptionYou:Show()
        SendChatMessage("Eruption on "..UnitName("player"), "YELL")
    else
        warnEruption:Show(targetName)
    end
end

function mod:SPELL_CAST_START(args)
    if args:IsSpellID(eruptionSpellId) then
        self:ScheduleMethod(0.4, "announceEruptionTarget")
        timerEruption:Start(args.sourceGUID)
        timerNextEruption:Start()
    elseif args:IsSpellID(infernoTrailSpellId) then
        warnInfernoTrail:Show()
        timerInfernoTrail:Start(args.sourceGUID)
        timerNextInfernoTrail:Start()
    elseif args:IsSpellID(strikeSpellId) then
        warnStrike:Show()
        timerStrike:Start(args.sourceGUID)
        timerNextStrike:Start()
    end
end

function mod:SPELL_AURA_APPLIED(args)
    if args:IsSpellID(crackedArmorAuraId) then
        timerAuraCrackedArmor:Start(args.destName)
    end
end