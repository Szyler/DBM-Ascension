local mod	= DBM:NewMod("Loatheb", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2568 $"):sub(12, -3))
mod:SetCreatureID(16011)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

-----SPORES-----
local warnSporeNow					= mod:NewSpellAnnounce(29234, 3)
local warnSporeSoon					= mod:NewSoonAnnounce(29234, 2)
local timerSpore					= mod:NewNextTimer(18, 29234)
local specWarnCloudOfBlight			= mod:NewSpecialWarningMove(79008)
-----IMPENDING DOOM-----
local warnDoomNow					= mod:NewSpellAnnounce(29204, 3)
local timerDoom						= mod:NewNextTimer(180, 29204)
-----HEALING AURA-----
local warnHealSoon					= mod:NewAnnounce("WarningHealSoon", 4, 48071)
local warnHealNow					= mod:NewAnnounce("WarningHealNow", 1, 48071, false)
local timerAura						= mod:NewBuffActiveTimer(17, 55593)
-----SOFT ENRAGE-----
local warnSoftEnrageSoon			= mod:NewSpellAnnounce(79009, 3)
local warnSoftEnrageNow				= mod:NewSoonAnnounce(79009, 2)
local loathebHealth
local phase
-----MISC-----
mod:AddBoolOption("SporeDamageAlert", false)
local doomCounter	= 0

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	phase = 1
	doomCounter = 0
	if mod:IsDifficulty("heroic25") then
		sporeTimer = 15
	else
		sporeTimer = 15
	end
	timerSpore:Start(sporeTimer - delay)
	warnSporeSoon:Schedule(sporeTimer - delay)
	timerDoom:Start(120 - delay, doomCounter + 1)
	self:ScheduleMethod(sporeTimer, "SporeSpawn")
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(29204, 55052) then  -- Inevitable Doom
		doomCounter = doomCounter + 1
		local timer = 30
		if doomCounter >= 7 then
			if doomCounter % 2 == 0 then timer = 17
			else timer = 12 end
		end
		warnDoomNow:Show(doomCounter)
		timerDoom:Start(timer, doomCounter + 1)
	elseif args:IsSpellID(55593) then
		timerAura:Start()
		warnHealSoon:Schedule(14)
		warnHealNow:Schedule(17)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(79008) then 
		if args:IsPlayer() then
			specWarnCloudOfBlight:Show();
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(79008) then 
		if args:IsPlayer() then
			specWarnCloudOfBlight:Show();
		end
	end
end

function mod:SporeSpawn(args)
	timer = 14
	warnSporeNow:Show()
	timerSpore:Start(timer)
	warnSporeSoon:Schedule(timer-3)
	self:ScheduleMethod(timer, "SporeSpawn")
end

function mod:UNIT_HEALTH(args)
    loathebHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
	
	if loathebHealth < 25 and phase == 1 then
		phase = 2
		warnSoftEnrageSoon:Show()
	elseif loathebHealth < 20 and phase == 2 then
		phase = 3
		warnSoftEnrageNow:Show()
	end
end