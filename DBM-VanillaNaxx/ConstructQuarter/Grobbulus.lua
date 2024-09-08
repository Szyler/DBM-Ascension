local mod	= DBM:NewMod("Grobbulus", "DBM-Naxx", 2)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 4154 $"):sub(12, -3))
mod:SetCreatureID(15931)
mod:SetUsedIcons(8)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"UNIT_DIED",
	"PLAYER_ALIVE"
)

-----MUTATING INJECTION-----
local warnInjection			= mod:NewTargetAnnounce(28169, 2)
local specWarnInjection		= mod:NewSpecialWarningYou(2122807)
local timerInjection		= mod:NewTargetTimer(10, 2122807)
local timerNextInjection	= mod:NewNextTimer(15, 2122807)
-----POISON CLOUD-----
local timerPoisonCloud		= mod:NewNextTimer(8, 2122812)
local warnCloud				= mod:NewSpellAnnounce(2122812, 2)
local specWarnPoison1		= mod:NewSpecialWarningMove(2122812, true, nil, true)
-----VIVIFYING TOXIN-----
local timerStitchedGiant 	= mod:NewTimer(60, "Stitched Giant", 79012)
-----SLIME SPRAY-----
local timerSpray			= mod:NewCDTimer(20, 2122818)
local warnSpray				= mod:NewSpellAnnounce(2122818, 2)
-----MISC-----
local enrageTimer			= mod:NewBerserkTimer(480)
mod:AddBoolOption("SetIconOnInjectionTarget", true)
local mutateIcons = {}

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	table.wipe(mutateIcons)
	enrageTimer:Start(-delay)
	-----Poison Cloud-----
	timerPoisonCloud:Start(10-delay)
	self:ScheduleMethod(10-delay,"PoisonCloud")
	-----Vivifying Toxin-----
	timerStitchedGiant:Start(20-delay)
	self:ScheduleMethod(20-delay, "StitchedGiant")
	-----Slime Spray-----
	timerSpray:Start(25-delay)
	----Injection----
	timerNextInjection:Start(10-delay)
end

local function addIcon()
	for i,j in ipairs(mutateIcons) do
		local icon = 9 - i
		mod:SetIcon(j, icon)
	end
end

local function removeIcon(target)
	for i,j in ipairs(mutateIcons) do
		if j == target then
			table.remove(mutateIcons, i)
			mod:SetIcon(target, 0)
		end
	end
	addIcon()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2122807) then
		if args:IsPlayer() then
			specWarnInjection:Show()
		else
			warnInjection:Show(args.destName)
		end
		timerInjection:Start(args.destName)
		timerNextInjection:Start()
		if self.Options.SetIconOnInjectionTarget then
			table.insert(mutateIcons, args.destName)
			addIcon()
		end
	elseif args:IsSpellID(2122812,2122813,2122814) then
		if args:IsPlayer() then
			specWarnPoison1:Show()
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2122812,2122813,2122814) then
		if args:IsPlayer() then
			specWarnPoison1:Show()
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2122807) then
		timerInjection:Cancel(args.destName)--Cancel timer if someone is dumb and dispels it.
		if self.Options.SetIconOnInjectionTarget then
			removeIcon(args.destName)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2122818) then
		timerSpray:Start()
		warnSpray:Show()
	end
end

function mod:PoisonCloud()
	timerPoisonCloud:Stop()
	timerPoisonCloud:Start()
	warnCloud:Show()
	self:ScheduleMethod(8,"PoisonCloud")
end

function mod:StitchedGiant()
	timerStitchedGiant:Stop()
	timerStitchedGiant:Start()
	self:ScheduleMethod(60,"StitchedGiant")
end

--if args:IsSpellID(28240) then
--	timer = 15
--	timerCloud:Start(timer)
--	warnCloud:Schedule(timer)
--	prewarnCloud:Schedule(timer-5)

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15931 or cid == 26627 then
		timerInjection:Stop()
		timerSpray:Stop()
		timerNextInjection:Stop()
	end
end

function mod:OnCombatEnd()
	timerInjection:Stop()
	timerSpray:Stop()
	timerNextInjection:Stop()
end