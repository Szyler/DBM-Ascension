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
	"SPELL_AURA_REMOVED",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

-----SPORES-----
local warnSporeNow					= mod:NewSpellAnnounce(29234, 3)
local warnSporeSoon					= mod:NewSoonAnnounce(29234, 2)
local timerSpore					= mod:NewNextTimer(30, 29234)
local specWarnCloudOfBlight			= mod:NewSpecialWarningMove(79008)
-----IMPENDING DOOM-----
local warnDoomNow					= mod:NewSpellAnnounce(29204, 3)
local timerDoom						= mod:NewNextTimer(180, 29204)
local timerDoomDamage				= mod:NewTimer(8, "Inevitable Doom expires!", 2122623)
-----HEALING AURA-----
local warnHealSoon					= mod:NewAnnounce("WarningHealSoon", 4, 48071)
local warnHealNow					= mod:NewAnnounce("WarningHealNow", 1, 48071, false)
local timerNecrotic					= mod:NewBuffActiveTimer(16, 2122601)
local timerCastHeal					= mod:NewTimer(4, "Heal now!", nil)
-----SOFT ENRAGE-----
local warnSoftEnrageSoon			= mod:NewSpellAnnounce(79009, 3)
local warnSoftEnrageNow				= mod:NewSoonAnnounce(79009, 2)
local softEnrage
-----DEATHBLOOM-----
local timerNextDeathbloom			= mod:NewNextTimer(30, 2122627)
local timerDeathblooming			= mod:NewTimer(15, "Deathbloom expires!", 2122627)
local specWarnDeathblooming			= mod:NewSpecialWarningSpell(2122627, 3)
local warnDeathbloom				= mod:NewSpellAnnounce(2122631, 3)
-----MISC-----
mod:AddBoolOption("SporeDamageAlert", false)
local doomCounter	= 0
local doomSpam

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	doomSpam = 0
	softEnrage = 0
	doomCounter = 0
	timerSpore:Start(15-delay)
	timerNecrotic:Start(10-delay)
	timerDoom:Start(30-delay)
	timerNextDeathbloom:Start(10-delay)
	self:ScheduleMethod(15-delay, "SporeSpawn")
end

-- Deathbloom (2122631)
-- Deathbloom trigger (2122627)
-- Necrotic Aura (2122601)
-- Aura of Famine (2122605)
-- Inevitable Doom (2122623)
-- Cloud of Plight (2122646)

function mod:SporeSpawn()
	warnSporeNow:Show()
	timerSpore:Start()
	warnSporeSoon:Schedule(25)
	self:ScheduleMethod(30, "SporeSpawn")
end

function mod:SPELL_CAST_SUCCESS()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2122646) then
		if args:IsPlayer() then
			specWarnCloudOfBlight:Show();
		end
	end
	if args:IsSpellID(2122623,2122624,2122625,2122626) and (GetTime() - doomSpam) > 5 then
		doomSpam = GetTime()  -- Inevitable Doom
		doomCounter = doomCounter + 1
		local timer = 30
		if doomCounter >= 7 then
			if doomCounter % 2 == 0 then timer = 17
			else timer = 12 end
		end
		warnDoomNow:Show(doomCounter)
		timerDoom:Start(timer, doomCounter + 1)
		timerDoomDamage:Start()
	end
	if args:IsSpellID(2122601) then
		timerNecrotic:Start()
		warnHealSoon:Schedule(15)
		warnHealNow:Schedule(16)
		timerCastHeal:Schedule(16)
	end
	if args:IsSpellID(2122631) then
		warnDeathbloom:Show()
	end
	if args:IsSpellID(2122627) then
		specWarnDeathblooming:Show()
		timerDeathblooming:Start()
		timerNextDeathbloom:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2122646) then
		if args:IsPlayer() then
			specWarnCloudOfBlight:Show();
		end
	end
	if args:IsSpellID(2122631) then
		if args:IsPlayer() and args.amount > 5 then
		specWarnDeathblooming:Show()
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 16011 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.25 and softEnrage == 0 then
		softEnrage = 1
		warnSoftEnrageSoon:Show()
	elseif  self:GetUnitCreatureId(uId) == 16011 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.20 and softEnrage == 1 then
		softEnrage = 2
		warnSoftEnrageNow:Show()
		warnSporeSoon:Unschedule()
		timerSpore:Stop()
		self:UnscheduleMethod("SporeSpawn")
	end
end