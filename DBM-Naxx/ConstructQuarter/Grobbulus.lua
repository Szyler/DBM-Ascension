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
	"PLAYER_ALIVE"
)

-----MUTATING INJECTION-----
local warnInjection		= mod:NewTargetAnnounce(28169, 2)
local specWarnInjection	= mod:NewSpecialWarningYou(28169)
local timerInjection	= mod:NewTargetTimer(10, 28169)
-----POISON CLOUD-----
local timerCloud		= mod:NewNextTimer(15, 28240)
local warnCloud			= mod:NewSpellAnnounce(28240, 2)
local prewarnCloud		= mod:NewSoonAnnounce(28240, 3)
local specWarnPoison1	= mod:NewSpecialWarningMove(28241, true, nil, true)
local specWarnPoison2	= mod:NewSpecialWarningMove(28158, true, nil, true)
-----VIVIFYING TOXIN-----
local timerToxin		= mod:NewNextTimer(45, 79012)
local warnToxin			= mod:NewSpellAnnounce(79012, 2)
local prewarnToxin		= mod:NewSoonAnnounce(79012, 3)
-----SLIME SPRAY-----
local timerSpray		= mod:NewCDTimer(15, 28157)
local warnSpray			= mod:NewSpellAnnounce(28157, 2)
-----MISC-----
local enrageTimer		= mod:NewBerserkTimer(480)
mod:AddBoolOption("SetIconOnInjectionTarget", true)
local mutateIcons = {}

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	table.wipe(mutateIcons)
	enrageTimer:Start(-delay)
	-----Poison Cloud-----
	timerCloud:Start(15-delay)
	warnCloud:Schedule(15-delay)
	prewarnCloud:Schedule(10-delay)
	-----Vivifying Toxin-----
	timerToxin:Start(10-delay)
	warnToxin:Schedule(10-delay)
	prewarnToxin:Schedule(5-delay)
	-----Slime Spray-----
	timerSpray:Start(15-delay)
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
	if args:IsSpellID(28169) then
		warnInjection:Show(args.destName)
		timerInjection:Start(args.destName)
		if args:IsPlayer() then
			specWarnInjection:Show()
		end
		if self.Options.SetIconOnInjectionTarget then
			table.insert(mutateIcons, args.destName)
			addIcon()
		end
	elseif args:IsSpellID(28241) then
		if args:IsPlayer() then
			specWarnPoison1:Show()
		end
	elseif args:IsSpellID(28158) then
		if args:IsPlayer() then
			specwarnPoison2:Show()
		end
	end	
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(28241) then
		if args:IsPlayer() then
			specWarnPoison1:Show()
		end
	elseif args:IsSpellID(28158) then
		if args:IsPlayer() then
			specwarnPoison2:Show()
		end
	end	
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(28169) then
		timerInjection:Cancel(args.destName)--Cancel timer if someone is dumb and dispels it.
		if self.Options.SetIconOnInjectionTarget then
			removeIcon(args.destName)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28240) then
		timer = 15
		timerCloud:Start(timer)
		warnCloud:Schedule(timer)
		prewarnCloud:Schedule(timer-5)
	elseif args:IsSpellID(79012) then
		timer = 42.5
		timerToxin:Start(timer)
		warnToxin:Schedule(timer)
		prewarnToxin:Schedule(timer-5)
	elseif args:IsSpellID(28157, 196884) then
		timer = 15
		timerSpray:Start(timer)
		warnSpray:Show()
	end
end