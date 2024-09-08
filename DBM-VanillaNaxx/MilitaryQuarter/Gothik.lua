local mod	= DBM:NewMod("Gothik", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16060)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_AURA_APPLIED", --This should allow the addon to process this Event using the scripting from Kel'Thuzad for Harvest Soul.
	"SPELL_AURA_APPLIED_DOSE", --This should allow the addon to process this Event using the scripting from Kel'Thuzad for Harvest Soul.
	"UNIT_DIED",
	"PLAYER_ALIVE",
	"UNIT_HEALTH",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL"
)

-----ADD DEATHS-----
local warnRiderDown				= mod:NewAnnounce("Unrelenting Rider Killed", 2, 36461, nil, "Show a warning when an Unrelenting Rider is killed")
local warnKnightDown			= mod:NewAnnounce("Unrelenting Death Knight Killed", 2, 36461, nil, "Show a warning when an Unrelenting Rider is killed")
-----HARVEST SOUL-----
local warnHarvestSoon			= mod:NewSoonAnnounce(28679, 2)
local warnHarvest				= mod:NewSpellAnnounce(28679, 2)
local timerHarvest				= mod:NewNextTimer(15, 28679)
-----COMBAT START----
local timerCombatStart			= mod:NewTimer(25, "Combat Starts", 2457, nil, "Show timer for the start of combat")
local warnCombatStartSoon		= mod:NewAnnounce("Combat Starts Soon", 2, 2457, nil, "Show pre-warning for the end of the Safety Dance")
local warnCombatStart			= mod:NewAnnounce("Combat Starts Now", 2, 2457, nil, "Show warning for the end of the Safety Dance")
-----GOTHIK ARRIVES----
local timerGothik				= mod:NewTimer(100, "Gothik Arrives", 46573, nil, "Show timer for the arrival of Gothik")
local warnGothikSoon			= mod:NewAnnounce("Gothik Arrives Soon", 2, 46573, nil, "Show pre-warning for the arrival of Gothik")
local warnGothik 				= mod:NewAnnounce("Gothik Arrives Now", 2, 46573, nil, "Show warning for the arrival of Gothik")

--------MISC--------
local phase = nil

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
end

function mod:HarvestSoul()
	timerHarvest:Start(20)
	warnHarvestSoon:Schedule(17)
	warnHarvest:Schedule(20)
	self:ScheduleMethod(20, "HarvestSoul")
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

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if (msg == L.yell or msg:find(L.yell)) and phase == nil then
		self:ScheduleMethod(100, "HarvestSoul")
		phase = 1
		-----HARVEST SOUL-----
		warnHarvestSoon:Schedule(115)
		warnHarvest:Schedule(120)
		timerHarvest:Start(120)
		-----COMBAT START----
		timerCombatStart:Start(25)
		warnCombatStartSoon:Schedule(20)
		warnCombatStart:Schedule(25)
		-----GOTHIK ARRIVES----
		timerGothik:Start(100)
		warnGothikSoon:Schedule(95)
		warnGothik:Schedule(100)
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 16060 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.11 and phase ==1 then
		self:UnscheduleMethod("HarvestSoul")
		timerHarvest:Stop()
		phase = 2
	end
end

function mod:OnCombatEnd()
	self:UnscheduleMethod("HarvestSoul")
end