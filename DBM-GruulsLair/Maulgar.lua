local mod	= DBM:NewMod("High King Maulgar", "DBM-GruulsLair")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 161 $"):sub(12, -3))
mod:SetCreatureID(18831, 18832, 18834, 18835, 18836)
-- mod:RegisterCombat("combat")
mod:RegisterCombat("yell", "Gronn are the real power in Outland!")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SPELL_SUMMON",
	"SPELL_HEAL",
	"UNIT_DIED",
	"SPELL_AURA_REMOVED"
);

local warnWhirlwind			= mod:NewSpellAnnounce(33238, 2)
local warnWhirlCast			= mod:NewCastAnnounce(33238, 3, nil, false)
local warnSpellShield		= mod:NewTargetAnnounce(33054, 3)
local warnBlast				= mod:NewSpellAnnounce(33061, 2)
local warnPolymorphCast		= mod:NewCastAnnounce(33173, 2)
local warnPolymorph			= mod:NewTargetAnnounce(33173, 2)
local warnShield			= mod:NewTargetAnnounce(33147, 2)
local warnPermRenew			= mod:NewTargetAnnounce(85022, 3)
local warnRenew				= mod:NewTargetAnnounce(85379, 3)
local warnFelstalkCast		= mod:NewCastAnnounce(33131, 3)
local warnFelstalk			= mod:NewSpellAnnounce(33131, 3)
local warnSoulstone			= mod:NewTargetAnnounce(85023, 3)
local warnLShield			= mod:NewTargetAnnounce(85025, 3)
local warnRShield			= mod:NewTargetAnnounce(85021, 3)
local warnCharge			= mod:NewTargetAnnounce(26561, 2)

local warnPWS				= mod:NewSpecialWarning("Purge Greater Power Word: Shield!")
local warnPoH				= mod:NewSpecialWarning("Interrupt Prayer of Healing!")
local warnHeal				= mod:NewSpecialWarning("Interrupt Heal!")

local timerWhirlwind		= mod:NewBuffActiveTimer(10, 33238)
local timerNextWhirlwind	= mod:NewNextTimer(40, 33238)
local timerMightyBlow		= mod:NewCDTimer(30, 33238, nil, false)
local timerCharge			= mod:NewNextTimer(20, 26561)
local timerBlast			= mod:NewNextTimer(90, 33061)
local timerFelstalk			= mod:NewNextTimer(30, 33131)
local timerSpellshield		= mod:NewNextTimer(40, 33054)
local timerPoly				= mod:NewNextTimer(20, 33173)
local timerMaulgarEnrage	= mod:NewTimer(720, "Berserk", 44427)


local miscSoulstone			= mod:NewAnnounce("Soulstone consumed on %s", 3, 85024)

function mod:OnCombatStart(delay)
	timerNextWhirlwind:Start(30-delay)
	timerBlast:Start(30-delay)
	timerFelstalk:Start(15-delay)
	timerMaulgarEnrage:Start(-delay)
end

function mod:OnCombatEnd()
--
end

-- function mod:UNIT_DIED(args)                           -- bad bad bad, most likely wont work anyway, SPELL_AURA_APPLIED approach preferred.
--	local cid = self:GetCIDFromGUID(args.destGUID)
--		if cid == 18836 then
--			warnRenew:Show(args.destName)
--		elseif cid == 18834 then
--			warnSoulstone:Show(args.destName)
--		elseif cid == 18832 then
--			warnRShield:Show(args.destName)
--		elseif cid == 18835 then
--			warnLShield:Show(args.destName)
			
function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(85022, 85386, 85385) then
		warnPermRenew:Show(args.destName)
	elseif args:IsSpellID(85023) then
		warnSoulstone:Show(args.destName)
		timerFelstalk:Cancel()
	elseif args:IsSpellID(85021) then
		warnRShield:Show(args.destName)
		timerSpellshield:Cancel()
	elseif args:IsSpellID(85025, 85381) then
		warnLShield:Show(args.destName)
		timerPoly:Cancel()
	elseif args:IsSpellID(33147) then
		warnShield:Show(args.destName)
		warnPWS:Show()
	elseif args:IsSpellID(33232) then
		if mod:IsDifficulty("normal25") then
			timerNextWhirlwind:Cancel()
		end
		timerCharge:Start(5)
	elseif args:IsSpellID(33238) then
		warnWhirlwind:Show()
		timerWhirlwind:Start()
	elseif args:IsSpellID(33054) then
		warnSpellShield:Show(args.destName)
	elseif args:IsSpellID(33173) then
		warnPolymorph:Show(args.destName)
	elseif args:IsSpellID(85379) then
		warnRenew:Show(args.destName)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(33061) then
		warnBlast:Show()
		timerBlast:Start()
	elseif args:IsSpellID(26561) then
		warnCharge:Show(args.destName)
		timerCharge:Start()
	elseif args:IsSpellID(33054) then
		timerSpellshield:Start()
	elseif args:IsSpellID(33230) then
		timerMightyBlow:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(33131) then
		warnFelstalkCast:Show()
	elseif args:IsSpellID(33173, 85396) then
		warnPolymorphCast:Show()
		timerPoly:Start()
	elseif args:IsSpellID(85384) then
		warnPoH:Show()
	elseif args:IsSpellID(33238) then
		warnWhirlCast:Show()
		timerNextWhirlwind:Start()
	elseif args:IsSpellID(85382, 85383) then
		warnHeal:Show()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(33131, 85390) then
		warnFelstalk:Show()
		timerFelstalk:Start()
	end
end

function mod:SPELL_HEAL(args)
	if args:IsSpellID(85024) then
		miscSoulstone:Show(args.destName)
	end
end
