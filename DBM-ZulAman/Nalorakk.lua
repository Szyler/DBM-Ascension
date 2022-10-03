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
	"CHAT_MSG_MONSTER_YELL"
)

local warnBear			= mod:NewAnnounce("WarnBear", 4, 39414)
local warnBearSoon		= mod:NewAnnounce("WarnBearSoon", 3, 39414)
local warnNormal		= mod:NewAnnounce("WarnNormal", 4, 39414)
local warnNormalSoon	= mod:NewAnnounce("WarnNormalSoon", 3, 39414)
local warnSilence		= mod:NewSpellAnnounce(42398, 3)
local specWarnFury		= mod:NewSpecialWarningSpell(2135837)
local specWarnFuryStacks= mod:NewSpecialWarningStack(2135838)
local specWarnRend		= mod:NewSpecialWarningTarget(2135834)

local timerBear			= mod:NewTimer(45, "TimerBear", 39414)
local timerNormal		= mod:NewTimer(30, "TimerNormal", 39414)
local timerCharge1		= mod:NewTimer(15, "Charge (1)", 2135805)
local timerCharge2		= mod:NewTimer(15, "Charge (2)", 2135805)
local timerCharge3		= mod:NewTimer(15, "Charge (3)", 2135805)
local timerNextFury		= mod:NewNextTimer(45, 2135837)
local timerNextRoar		= mod:NewNextTimer(2135829, 14) -- HC 2135830 , ASC 10Man 2135831, ASC25man 2135832 --2136323 is ZUL'JIN ROAR!!!
local timerNextRend 	= mod:NewNextTimer(10,2135834) --timer seems to not be constant, need to find out 
local berserkTimer		= mod:NewBerserkTimer(600)

local roarSpam = 0
local roarCount = 0
local chargeCount = 0
function mod:bearCharge()
	self:unscheduleMethod("bearCharge")
		timerCharge1:Start(13)
		timerCharge2:Start(14)
		timerCharge3:Start(15)
		chargeCount = 0
end
function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerNextFury:Start()
	self:bearCharge()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2135812) then
		timerNextRoar:Start()
		timerNextFury:Start()
	elseif args:IsSpellID(2135837) then
		specWarnFury:Show()
	elseif args:IsSpellID(2135804, 2135805, 2135806, 2135807) then
		
		chargeCount = chargeCount+1
		if chargeCount == 3 then
			self:bearCharge()
		end
	elseif args:IsSpellID(2135833, 2135834, 2135835, 2135836) then
		specWarnRend:Show(args.destName)
		timerNextRend:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2135829, 2135830, 2135831, 2135832) and (GetTime() - roarSpam > 2.5)then
		roarSpam = GetTime()
		roarCount = roarCount+1
		timerNextRoar:Start(math.max(3,14-roarCount))
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2135838) then
		if args.amount == 25 or args.amount == 50 or args.amount == 75 then
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
