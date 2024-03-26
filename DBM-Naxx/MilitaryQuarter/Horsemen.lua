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
	"PLAYER_ALIVE",
	"UNIT_DIED"
)

-----MARKS-----
local warnMarkSoon			= mod:NewAnnounce("WarningMarkSoon", 1, 28835, false)
local warnMarkNow			= mod:NewAnnounce("WarningMarkNow", 2, 28835)
local specWarnMarkOnPlayer	= mod:NewSpecialWarning("SpecialWarningMarkOnPlayer", nil, false, true)
local specWarnHolyWrathYou	= mod:NewSpecialWarningYou(2124141,2)
local warnHolyWrath			= mod:NewTargetAnnounce(2124141,2)
local specWarnDeepChillYou	= mod:NewSpecialWarningYou(2124167,2)
local warnDeepChill			= mod:NewTargetAnnounce(2124167,2)
local specWarnMeteorYou		= mod:NewSpecialWarningYou(2124128,2)
local warnMeteor			= mod:NewTargetAnnounce(2124128,2)
local specWarnFamineYou		= mod:NewSpecialWarningYou(2124166,2)
local warnFamine			= mod:NewTargetAnnounce(2124166,2)

----timers----				
local timerMark				= mod:NewTimer(12, "Mark of the Apocalypse", 2124107)
local timerHolyWrath		= mod:NewTargetTimer(3.8, 2124141)
local timerNextHolyWrath	= mod:NewNextTimer(20, 2124141)
local timerDeepChill		= mod:NewTargetTimer(3.8, 2124167)
local timerNextDeepChill	= mod:NewNextTimer(20, 2124167)
local timerMeteor			= mod:NewTargetTimer(7.8, 2124128)
local timerNextMeteor		= mod:NewNextTimer(20, 2124128)
local timerFamine			= mod:NewTargetTimer(3.8, 2124166)
local timerNextFamine		= mod:NewNextTimer(20, 2124166)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(606)
local meteorTarget = nil
mod:AddBoolOption("HealthFrame", true)
mod:SetBossHealthInfo(
	16064, L.Korthazz,
	30549, L.Rivendare,
	16065, L.Blaumeux,
	16063, L.Zeliek
)
local markCounter = 0
local markSpam = 0

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start()
	timerMark:Start(18-delay)
	timerNextMeteor:Start(21-delay)
	timerNextDeepChill:Start(11-delay)
	timerNextHolyWrath:Start(25-delay)
	timerNextFamine:Start(16-delay)
	markCounter = 0
end

function mod:Meteor()
	local myName = UnitName("player")
	if meteorTarget == myName then
		specWarnMeteorYou:Show()
		SendChatMessage("Meteor on "..UnitName("PLAYER").."!", "Say")
	else
		warnMeteor:Show(meteorTarget)
	end
	timerMeteor:Start(meteorTarget)
	timerNextMeteor:Start()
	self:SetIcon(meteorTarget, 7, 8)
end

function mod:DeepChill()
	local targetDC = mod:GetBossTarget(30549) or mod:GetBossTarget(26622)
	if targetDC == UnitName("player") then
		specWarnDeepChillYou:Show()
		SendChatMessage("Deep Chill on "..UnitName("PLAYER").."!", "Say")
	else
		warnDeepChill:Show(targetDC)
	end
	timerDeepChill:Start(targetDC)
	timerNextDeepChill:Start()
	self:SetIcon(targetDC, 6, 4)
end

function mod:HolyWrath()
	local targetHW = mod:GetBossTarget(16063) or mod:GetBossTarget(26624)
	if targetHW == UnitName("player") then
		specWarnHolyWrathYou:Show()
		SendChatMessage("Holy Wrath on "..UnitName("PLAYER").."!", "Say")
	else
		warnHolyWrath:Show(targetHW)
	end
	timerHolyWrath:Start(targetHW)
	timerNextHolyWrath:Start()
	self:SetIcon(targetHW, 1, 4)
end

function mod:Famine()
    local famineTarget = mod:GetBossTarget(16065) or mod:GetBossTarget(26625) --Finds target of boss (if exsists) otherwise, find target of shade (if exists)
	if famineTarget == UnitName("player") then --if target == player
		specWarnFamineYou:Show()
		SendChatMessage("Field of Famine on "..UnitName("PLAYER").."!", "Say")
	else
		warnFamine:Show(famineTarget)
	end
	timerFamine:Start(famineTarget) --we want timers to start even if player is the target, you had the timers only in the "if not player".
	timerNextFamine:Start()
	self:SetIcon(famineTarget, 3, 4)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2124103,2124107,2124111,2124115) and (GetTime() - markSpam) > 5 then
		markSpam = GetTime()
		markCounter = markCounter + 1
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2124141) then
		self:ScheduleMethod(0.25, "HolyWrath")
	elseif args:IsSpellID(2124167) then
		self:ScheduleMethod(0.25, "DeepChill")
	elseif args:IsSpellID(2124166) then
		self:ScheduleMethod(0.25, "Famine")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2124128) then
		self:ScheduleMethod(0.25, "Meteor")
		meteorTarget = args.destName
	elseif args:IsSpellID(2124103, 2124104, 2124105, 2124106) or args:IsSpellID(2124107, 2124108, 2124109, 2124110) or args:IsSpellID(2124111, 2124112, 2124113, 2124114) or args:IsSpellID(2124115, 2124116, 2124117, 2124118) then
		timerMark:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2124103,2124107,2124111,2124115) and args:IsPlayer() then
		if args.amount >= 3 then
			specWarnMarkOnPlayer:Show(args.spellName, args.amount)
		end
	elseif args:IsSpellID(2124103, 2124104, 2124105, 2124106) or args:IsSpellID(2124107, 2124108, 2124109, 2124110) or args:IsSpellID(2124111, 2124112, 2124113, 2124114) or args:IsSpellID(2124115, 2124116, 2124117, 2124118) then
		timerMark:Start()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 16063 or 26624 then
		timerNextHolyWrath:Stop()
	elseif cid == 16064 or 26623 then
		timerNextMeteor:Stop()
	elseif cid == 16065 or 26625 then
		timerNextFamine:Stop()
	elseif cid == 30549 or 26622 then
		timerNextDeepChill:Stop()
	elseif cid >= 26622 and cid <= 26625 then
		timerMark:Stop()
	end
end
