local mod	= DBM:NewMod("Gothik", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16060)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_AURA_APPLIED", --This should allow the addon to process this Event using the scripting from Kel'Thuzad for Harvest Soul.
	"SPELL_AURA_APPLIED_DOSE", --This should allow the addon to process this Event using the scripting from Kel'Thuzad for Harvest Soul.
	"UNIT_DIED",
	"PLAYER_ALIVE" 
)

-----ADD DEATHS-----
local warnRiderDown				= mod:NewAnnounce("Unrelenting Rider Killed", 2, 36461, nil, "Show a warning when an Unrelenting Rider is killed")
local warnKnightDown			= mod:NewAnnounce("Unrelenting Death Knight Killed", 2, 36461, nil, "Show a warning when an Unrelenting Rider is killed")
-----HARVEST SOUL-----
local warnHarvestSoon			= mod:NewSoonAnnounce(28679, 3)
local warnHarvest				= mod:NewSpellAnnounce(28679, 2)
local timerHarvest				= mod:NewNextTimer(15, 28679)
-----COMBAT START----
local timerCombatStart			= mod:NewTimer(25, "Combat Starts", 2457, nil, "Show timer for the start of combat")
local warnCombatStartSoon		= mod:NewAnnounce("Combat Starts Soon", 2, 2457, nil, "Show pre-warning for the end of the Safety Dance")
local warnCombatStart			= mod:NewAnnounce("Combat Starts Now", 3, 2457, nil, "Show warning for the end of the Safety Dance")
-----GOTHIK ARRIVES----
local timerGothik				= mod:NewTimer(100, "Gothik Arrives", 46573, nil, "Show timer for the arrival of Gothik")
local warnGothikSoon			= mod:NewAnnounce("Gothik Arrives Soon", 2, 46573, nil, "Show pre-warning for the arrival of Gothik")
local warnGothik 				= mod:NewAnnounce("Gothik Arrives Now", 3, 46573, nil, "Show warning for the arrival of Gothik")

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	self:ScheduleMethod(115, "HarvestSoul")
	-----HARVEST SOUL-----
	harvestSoulIntiialTimer = 115
	warnHarvestSoon:Schedule(harvestSoulIntiialTimer-5)
	warnHarvest:Schedule(harvestSoulIntiialTimer)
	timerHarvest:Start(harvestSoulIntiialTimer)
	-----COMBAT START----
	combatStartTimer = 25 
	timerCombatStart:Start(combatStartTimer)
	warnCombatStartSoon:Schedule(combatStartTimer-5)
	warnCombatStart:Schedule(combatStartTimer)
	-----GOTHIK ARRIVES----
	gothikTimer = 100
	timerGothik:Start(gothikTimer)
	warnGothikSoon:Schedule(gothikTimer-5)
	warnGothik:Schedule(gothikTimer)

end

function mod:HarvestSoul()
	timer = 15
	timerHarvest:Start(timer)
	warnHarvestSoon:Schedule(timer-3, 15)
	warnHarvest:Schedule(timer)
	self:ScheduleMethod(timer, "HarvestSoul")
end

function mod:UNIT_DIED(args)
	if bit.band(args.destGUID:sub(0, 5), 0x00F) == 3 then
		local guid = tonumber(args.destGUID:sub(9, 12), 16)
		if guid == 16126 then -- Unrelenting Rider
			warnRiderDown:Show()
		elseif guid == 16125 then -- Unrelenting Death Knight
			warnKnightDown:Show()
		end
	end
end