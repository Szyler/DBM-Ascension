local mod	= DBM:NewMod("Noth", "DBM-Naxx", 3)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15954)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"PLAYER_ALIVE"
)

-----TELEPORT-----
local warnTeleportNow		= mod:NewAnnounce("Teleport Now", 3, 46573, nil, "Show warning for Noth teleporting to and from the balcony")
local warnTeleportSoon		= mod:NewAnnounce("Teleport in 10 seconds", 1, 46573, nil, "Show pre-warning for Noth teleporting to and from the balcony")
local timerTeleport			= mod:NewTimer(600, "Teleport to Balcony", 46573, nil, "Show timer for Noth teleporting to the balcony")
local timerTeleportBack		= mod:NewTimer(600, "Teleport to Raid", 46573, nil, "Show timer for Noth teleporting from the balcony")
-----CURSE-----
local warnCurse				= mod:NewSpellAnnounce(29213, 2)
local specWarnCurse			= mod:NewSpecialWarningYou(29213)
-----Adds-----
local timerSkeletons		= mod:NewNextTimer(30, 52611)
--Rise, my soldiers! Rise and fight once more!
-----MISC-----
-- local berserkTimer			= mod:NewBerserkTimer(375)
local phase = 0

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	-- berserkTimer:Start(375-delay)
	timerSkeletons:Start(15-delay)
	timerSkeletons:Schedule(15)
	phase = 0
	self:BackInRoom()
end

function mod:Balcony()
	local timer
	if phase == 1 then timer = 60
	elseif phase == 2 then timer = 60
	elseif phase == 3 then timer = 60 
	else return	end
	timerTeleportBack:Show(timer)
	warnTeleportSoon:Schedule(timer - 10)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "BackInRoom")
	timerSkeletons:Start(5)
	timerSkeletons:Schedule(5)
end

function mod:BackInRoom()
	phase = phase + 1
	local timer
	if phase == 1 then timer = 75
	elseif phase == 2 then timer = 75 
	elseif phase == 3 then timer = 75 
	else return end
	timerTeleport:Show(timer)
	warnTeleportSoon:Schedule(timer - 10)
	warnTeleportNow:Schedule(timer)
	self:ScheduleMethod(timer, "Balcony")
	timerSkeletons:Start(15)
	timerSkeletons:Schedule(15)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(29213, 54835, 350288) then	-- Curse of the Plaguebringer
		warnCurse:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(29213, 54835, 350288) then 
		if args:IsPlayer() then
			specWarnCurse:Show();
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(29213, 54835, 350288) then 
		if args:IsPlayer() then
			specWarnCurse:Show();
		end
	end
end