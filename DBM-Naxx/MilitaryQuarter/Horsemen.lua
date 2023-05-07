local mod	= DBM:NewMod("Horsemen", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16063, 16064, 16065, 30549)
mod:RegisterCombat("combat", 16063, 16064, 16065, 30549)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"PLAYER_ALIVE"
)

-----MARKS-----
local warnMarkSoon			= mod:NewAnnounce("WarningMarkSoon", 1, 28835, false)
local warnMarkNow			= mod:NewAnnounce("WarningMarkNow", 2, 28835)
local specWarnMarkOnPlayer	= mod:NewSpecialWarning("SpecialWarningMarkOnPlayer", nil, false, true)
local specWarnHolyWrathYou	= mod:NewSpecialWarningYou(2124141,2)
local warnHolyWrath			= mod:NewTargetAnnounce(2124141,3)
local specWarnDeepChillYou	= mod:NewSpecialWarningYou(2124167,2)
local warnDeepChill			= mod:NewTargetAnnounce(2124167,3)
local specWarnMeteorYou		= mod:NewSpecialWarningYou(2124128,2)
local warnMeteor			= mod:NewTargetAnnounce(2124128,3)
local specWarnFamineYou		= mod:NewSpecialWarningYou(2124166,2)
local warnFamine			= mod:NewTargetAnnounce(2124166,3)

----timers----
local timerMark				= mod:NewNextTimer(12, 2124103)
local timerHolyWrath		= mod:NewCastTimer(4, 2124141)
local timerNextHolyWrath	= mod:NewNextTimer(20, 2124141)
local timerDeepChill		= mod:NewCastTimer(4, 2124167)
local timerNextDeepChill	= mod:NewNextTimer(20, 2124167)
local timerMeteor			= mod:NewCastTimer(8, 2124128)
local timerNextMeteor		= mod:NewNextTimer(20, 2124128)
local timerFamine			= mod:NewCastTimer(8, 2124166)
local timerNextFamine		= mod:NewNextTimer(20, 2124166)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(606)
mod:AddBoolOption("HealthFrame", true)
mod:SetBossHealthInfo(
	16064, L.Korthazz,
	30549, L.Rivendare,
	16065, L.Blaumeux,
	16063, L.Zeliek
)
local markCounter = 0

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start()
	timerMark:Start(18-delay)
	self:ScheduleMethod(18,"Mark")
	markCounter = 0
	self:ScheduleMethod("MarkZeliek")
	self:ScheduleMethod("MarkKorthazz")
	self:ScheduleMethod("MarkMograine")
	self:ScheduleMethod("MarkBlaumeux")
end

function mod:Mark()
self:UnscheduleMethod("Mark")
timerMark:Stop()
timerMark:Start()
self:ScheduleMethod(12,"Mark")
end

function mod:HolyWrath()
	local targetHW = nil
	targetHW = mod:GetBossTarget(16063)
	local myName = UnitName("player")
	if targetHW == myName then
		specWarnHolyWrathYou:Show()
		SendChatMessage("Holy Wrath on"..UnitName("PLAYER").."!", "Say")
	else
		warnHolyWrath:Show(targetHW)
	end
	timerHolyWrath:Start(targetHW)
	timerNextHolyWrath:Start()
	self:SetIcon(targetHW, 1, 4)
	self:ScheduleMethod(4, "MarkZeliek")
end

function mod:DeepChill()
	local targetDC = nil
	targetDC = mod:GetBossTarget(30549)
	local myName = UnitName("player")
	if targetDC == myName then
		specWarnDeepChillYou:Show()
		SendChatMessage("Deep Chill on"..UnitName("PLAYER").."!", "Say")
	else
		warnDeepChill:Show(targetDC)
	end
	timerDeepChill:Start(targetDC)
	timerNextDeepChill:Start()
	self:SetIcon(targetDC, 6, 4)
	self:ScheduleMethod(4, "MarkMograine")
end

function mod:Meteor()
	local targetM = nil
	targetM = mod:GetBossTarget(16064)
	local myName = UnitName("player")
	if targetM == myName then
		specWarnMeteorYou:Show()
		SendChatMessage("Meteor on"..UnitName("PLAYER").."!", "Say")
	else
		warnMeteor:Show(targetM)
	end
	timerMeteor:Start(targetM)
	timerNextMeteor:Start()
	self:SetIcon(targetM, 7, 8)
	self:ScheduleMethod(8, "MarkKorthazz")
end

function mod:Famine()
	local targetF = nil
	targetF = mod:GetBossTarget(16065)
	local myName = UnitName("player")
	if targetF == myName then
		specWarnFamineYou:Show()
		SendChatMessage("Field of Famine on"..UnitName("PLAYER").."!", "Say")
	else
		warnFamine:Show(targetF)
	end
	timerFamine:Start(targetF)
	timerNextFamine:Start()
	self:SetIcon(targetF, 3, 3)
	self:ScheduleMethod(3, "MarkBlaumeux")
end

local markSpam = 0
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2124103,2124107,2124111,2124115) and (GetTime() - markSpam) > 5 then
		markSpam = GetTime()
		markCounter = markCounter + 1
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2124141) then
		self:scheduleMethod(0.2, "HolyWrath")
	end
	if args:IsSpellID(2124167) then
		self:scheduleMethod(0.2, "DeepChill")
	end
	if args:IsSpellID(2124166) then
		self:ScheduleMethod(0.2, "Famine")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2124128) then
		self:scheduleMethod(0.2, "Meteor")
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2124103,2124107,2124111,2124115) and args:IsPlayer() then
		if args.amount >= 3 then
			specWarnMarkOnPlayer:Show(args.spellName, args.amount)
		end
	end
end

function mod:MarkZeliek(uId)
	Zeliek = (self:GetUnitCreatureId(uId) == 16063)
	self:SetIcon(Zeliek, 1)
end

function mod:MarkKorthazz(uId)
	Korthazz = (self:GetUnitCreatureId(uId) == 16064)
	self:SetIcon(Korthazz, 7)
end

function mod:MarkMograine(uId)
	Mograine = (self:GetUnitCreatureId(uId) == 30549)
	self:SetIcon(Mograine, 6)
end

function mod:MarkBlaumeux(uId)
	Blaumeux = (self:GetUnitCreatureId(uId) == 16065)
	self:SetIcon(Blaumeux, 3)
end