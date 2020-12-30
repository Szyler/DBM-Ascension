local mod	= DBM:NewMod("Huhuran", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 185 $"):sub(12, -3))
mod:SetCreatureID(15509)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

local warnSoon		= mod:NewAnnounce("Adds Soon", 2, 1002077)
local warnSpawn		= mod:NewAnnounce("Adds Spawned", 3, 1002077)
local prewarnSoftEnrage		= mod:NewAnnounce("Soft Enrage Soon", 2, 1002304)
local warnSoftEnrage		= mod:NewAnnounce("Soft Enrage Now", 3, 1002304)
local timerSpawn	= mod:NewTimer(60, "Adds", 1002077)

local warnSting			= mod:NewTargetAnnounce(26180, 2)
local warnAcid			= mod:NewAnnounce("WarnAcid", 3)

local timerSting		= mod:NewBuffActiveTimer(12, 26180)
local timerStingCD		= mod:NewCDTimer(20, 26180)
local timerAcid			= mod:NewTargetTimer(30, 26050)

local specWarnAcid		= mod:NewSpecialWarningStack(26050, nil, 10)

local berserkTimer	=	mod:NewBerserkTimer(420)
local StingTargets = {}
local check1
local check2

function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)	
	self:ScheduleMethod(0-delay, "initialSpawn")
	table.wipe(StingTargets)
	check1 = 0
	check2 = 0
end

function mod:Soon()
	warnSoon:Show()
end

function mod:Spawn()
	warnSpawn:Show()
end

function mod:initialSpawn()
	timera = 10
	timerSpawn:Start(timera)
	self:ScheduleMethod(timera-5,"Soon")
	self:ScheduleMethod(timera, "Spawn")
	self:ScheduleMethod(timera, "reSpawn")
end

function mod:reSpawn()
	timerb = 30
	timerSpawn:Start(timerb)
	self:ScheduleMethod(timerb-5,"Soon")
	self:ScheduleMethod(timerb, "Spawn")
	self:ScheduleMethod(timerb, "reSpawn")
end

local function warnStingTargets()
	warnSting:Show(table.concat(StingTargets, "<, >"))
	timerSting:Start()
	table.wipe(StingTargets)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(26180) then
		StingTargets[#StingTargets + 1] = args.destName
		self:Unschedule(warnStingTargets)
		self:Schedule(0.3, warnStingTargets)
	elseif args:IsSpellID(26050) then
		warnAcid:Show(args.spellName, args.destName, args.amount or 1)
		timerAcid:Start(args.destName)
		if args:IsPlayer() and (args.amount or 1) >= 10 then
			specWarnAcid:Show()
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(26180) then
		timerSting:Cancel()
	end
end

function mod:UNIT_HEALTH(args)
    huhuranHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
	
	if huhuranHealth < 35 and check1 == 0 then
		check1 = 1
		prewarnSoftEnrage:Show()
	elseif skeramHealth < 30 and check2 == 0 then
		check2 = 1
		warnSoftEnrage:Show()
	end
end