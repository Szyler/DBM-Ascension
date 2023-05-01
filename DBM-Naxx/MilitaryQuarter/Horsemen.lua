local mod	= DBM:NewMod("Horsemen", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16063, 16064, 16065, 16062)
mod:RegisterCombat("combat", 16063, 16064, 16065, 16062)
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
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

----timers----
local timerHolyWrath		= mod:NewCastTimer(4, 2124141)
local timerDeepChill		= mod:NewCastTimer(4, 2124167)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(600)
mod:AddBoolOption("HealthFrame", true)
mod:SetBossHealthInfo(
	16064, L.Korthazz,
	16062, L.Mograine,
	16065, L.Blaumeux,
	16063, L.Zeliek
)
local markCounter = 0

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start()
	markCounter = 0
end

function mod:HolyWrath()
	local target = nil
	target = mod:GetBossTarget(16063)
	local myName = UnitName("player")
	if target == myName then
		specWarnHolyWrathYou:Show()
		SendChatMessage("Holy Wrath on"..UnitName("PLAYER").."!", "Say")
	else
		warnHolyWrath:Show(target)
	end
	timerHolyWrath:Start(target)
	self:SetIcon(target, 1, 3)
end

function mod:DeepChill()
	local target = nil
	target = mod:GetBossTarget(16062)
	local myName = UnitName("player")
	if target == myName then
		specWarnDeepChillYou:Show()
		SendChatMessage("Deep Chill on"..UnitName("PLAYER").."!", "Say")
	else
		warnDeepChill:Show(target)
	end
	timerDeepChill:Start(target)
	self:SetIcon(target, 6, 3)
end

local markSpam = 0
function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28832, 28833, 28834, 28835) and (GetTime() - markSpam) > 5 then
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
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(28832, 28833, 28834, 28835) and args:IsPlayer() then
		if args.amount >= 3 then
			specWarnMarkOnPlayer:Show(args.spellName, args.amount)
		end
	end
end