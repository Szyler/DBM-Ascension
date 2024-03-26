local mod	= DBM:NewMod("Nalorakk", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(23576)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_DAMAGE",
	"SPELL_CAST_START",
	"SPELL_SUMMON",
	"CHAT_MSG_MONSTER_YELL"
)

local warnBear			= mod:NewAnnounce("WarnBear", 4, 39414)
local warnBearSoon		= mod:NewAnnounce("WarnBearSoon", 3, 39414)
local warnNormal		= mod:NewAnnounce("WarnNormal", 4, 39414)
local warnNormalSoon	= mod:NewAnnounce("WarnNormalSoon", 3, 39414)
local warnSilence		= mod:NewSpellAnnounce(42398, 3)
local specWarnFury		= mod:NewSpecialWarningSpell(2135837)
local specWarnFuryStacks= mod:NewSpecialWarningStack(2135838)
local specWarnRend		= mod:NewSpecialWarningTarget(2135833)
local timerNextWhirling	= mod:NewNextTimer(15, 2135814)

local timerNextImpale	= mod:NewNextTimer(15, 2135823)
local warnImpale		= mod:NewTargetAnnounce(2135824, 3) --2135823, 2135824, 2135825, 2135826, 2135827

local timerBear			= mod:NewTimer(45, "TimerBear", 39414)
local timerNormal		= mod:NewTimer(30, "TimerNormal", 39414)
local specWarnCharge	= mod:NewSpecialWarningYou(2135805)
local timerCharge1		= mod:NewTimer(13, "Charge (1)", 2135805)
local timerCharge2		= mod:NewTimer(14, "Charge (2)", 2135805)
local timerCharge3		= mod:NewTimer(15, "Charge (3)", 2135805)
local timerNextFury		= mod:NewNextTimer(45, 2135837)
local timerNextRoar		= mod:NewNextTimer(2135829, 14) -- HC 2135830 , ASC 10Man 2135831, ASC25man 2135832 --2136323 is ZUL'JIN ROAR!!!
local timerNextRend 	= mod:NewNextTimer(10, 2135833) --timer seems to not be constant, need to find out 

local timerSpirit		= mod:NewTargetTimer(15, 2135881)
local warnSpiritYou		= mod:NewSpecialWarningYou(2135881) 

local berserkTimer		= mod:NewBerserkTimer(600)

local roarSpam = 0
local roarCount = 0
local roarTimer = 0
-- local chargeCount = 0

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerNextFury:Start()
	timerCharge:Start(12)
	-- timerCharge2:Start(13)
	roarSpam = 0
	roarCount = 0
	roarTimer = 0
	-- self:bearCharge()
end

-- function mod:bearCharge()
-- 	self:UnscheduleMethod("bearCharge")
-- 	timerCharge1:Start()
-- 	timerCharge2:Start()
-- 	timerCharge3:Start()
-- 	-- chargeCount = 0
-- end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2135812) then
		timerNextRoar:Start()
		timerNextFury:Start()
	elseif args:IsSpellID(2135837) then
		specWarnFury:Show()
	elseif args:IsSpellID(2135804, 2135805, 2135806, 2135807) and DBM:AntiSpam(5) then
		timerCharge:Start()
		-- timerCharge1:Start()
		-- timerCharge2:Start()
		-- timerCharge3:Start()
		-- chargeCount = chargeCount+1
		-- if chargeCount == 3 then
		-- 	self:bearCharge()
		-- end
		if args:IsPlayer() and (args.amount and args.amount > 1) then
			specWarnCharge:Show()
		end
	elseif args:IsSpellID(2135833, 2135834, 2135835, 2135836) then
		specWarnRend:Show(args.destName)
		timerNextRend:Start()
	elseif args:IsSpellID(2135824, 2135825, 2135826, 2135827) then
		warnImpale:Show(args.destName)
	elseif args:IsSpellID(2135881) then
		timerSpirit:Start(args.destName)
		if args:IsPlayer() then
			warnSpiritYou:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2135838) then
		if args.amount == 25 or args.amount == 50 or args.amount == 75  or args.amount == 100 then
			specWarnFuryStacks:Show(args.amount)
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2135812) then
		timerNextRoar:Stop()
		timerNextFury:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2135829, 2135830, 2135831, 2135832) and DBM:AntiSpam() then
		roarCount = roarCount + 1
		roarTimer = math.max(3, 14-roarCount)
		timerNextRoar:Start(roarTimer)
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2135823) then
		timerNextImpale:Start()
	end
end

function mod:SPELL_SUMMON(args)
	if args:IsSpellID(2135814) and DBM:AntiSpam() then
		timerNextWhirling:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellBear or msg:find(L.YellBear) then
		timerBear:Cancel()
		warnBearSoon:Cancel()
		warnBear:Show()
		timerNormal:Start()
		warnNormalSoon:Schedule(25)
	elseif msg == L.YellNormal or msg:find(L.YellNormal) then
		timerNormal:Cancel()
		warnNormalSoon:Cancel()
		warnNormal:Show()
		timerBear:Start()
		warnBearSoon:Schedule(40)
	end
end
