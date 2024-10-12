local mod	= DBM:NewMod("Mythic Champion", "DBM-Party-Vanilla")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(80227)
mod:RegisterCombat("combat", 80227, 80228)
mod:SetUsedIcons(8)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
    "SPELL_AURA_APPLIED_DOSE",
    "UNIT_DIED"
)
-- Frost Champion
-- FO   -   Frozen orb 2 sec cast
-- AZ 	-	Absolute Zero 4 sec cast 4 sec channel
-- IB 	- 	Ice Barrage 2 second cast 4 sec channel
-- IBDB -	Ice barrage Debuff
-- Timers starts at first SPELL_CAST_START of Frozen Orb (5 sec into the fight)
-- Icon for ice barrage + living bomb
-- Spell IDs:
-- Frozen Orb - 2129159
-- Absolute Zero - 2129169, 2129170 TBC, 2129171 WOTLK
-- Ice Barrage - 2129163, 2129164 TBC, 2129165 WOTLK
-- Ice Barrage player debuff - 2129160 TBC, 2129161, 2129162 WOTLK
-- Frostbite - 2129154 (maybe Or 2129176)
--Timers:
--0:05 - Frozen Orb #1
--*
--0:20 - Absolute Zero #1
--0:33 - Ice Barrage #1
--0:43 - Frozen Orb #2
--1:03 - Ice Barrage #2
--1:13 - Frozen Orb #3
--*
--1:28 - Absolute Zero #2
--1:41 - Ice Barrage #3
--1:51 - Frozen Orb #4
--2:11 - Ice Barrage #4
--2:21 - Frozen Orb #5
--*
--Repeats
---------------------------------------------------------------------------------
--Spell IDs:
--Fire From the Skys - 2129123
--Flame Torrent cast - 2129111, 2129112 (TBC), 2129113 (WOTLK)
--Flame Torrent damage - 2129114, 2129115 (TBC), 2129116 (WOTLK)
--Magma Infusion - 2129117, 2129118 (TBC), 2129119 (WOTLK)
--Melt Down - 2129108, 2129109 (TBC), 2129110 (WOTLK)
--Melt Down - Buff - 2129107 SPELL_AURA_APPLIED (Buff on champ)
--Living Bomb - 2129132, 2129133 (TBC), 2129134 (WOTLK)
--Timers for cast start:
--0:03 - Living Bomb #1
--0:05 - Magma Infusion #1
--0:15 - Living Bomb #2
--
--0:20 - Fire From the Skies #1
--0:31 - Flame Torrent #1
--0:33 - Living Bomb #3
--0:41 - Magma Infusion #2
--0:45 - Living Bomb #4
--0:57 - Living Bomb #5
--1:01 - Flame Torrent #2
--1:09 - Living Bomb #6
--1:11 - Magma Infusion #3
--1:21 - Living Bomb #7
--
--1:26 - Fire From the Skies #2
--1:37 - Flame Torrent #3
--1:39 - Living Bomb #8
--1:47 - Magma Infusion #4
--1:51 - Living Bomb #9
--2:03 - Living Bomb #10
--2:07 - Flame Torrent #4
--2:15 - Living Bomb #11
--2:17 - Magma Infusion #5
--2:27 - Living Bomb #12
--
--Repeat

local frostChamp = false
local fireChamp = false
--Local Variables Fire Champion
local meltdownAmount = 0
local warningFiresFromTheSkys           = mod:NewSpellAnnounce(2129123, 3)
local timerNextFiresFromTheSkys         = mod:NewNextTimer(66, 2129123)
local warningFlameTorrent               = mod:NewSpellAnnounce(2129111, 3)
local timerNextFlameTorrent             = mod:NewNextTimer(30, 2129111)
local warningMagmaInfusion              = mod:NewSpellAnnounce(2129117, 3)
local timerNextMagmaInfusion            = mod:NewNextTimer(30, 2129117)
local warningMeltDown                   = mod:NewSpellAnnounce(2129107, 3)
local timerNextMeltDown                 = mod:NewNextTimer(19, 2129107)
local warningLivingBomb                 = mod:NewSpellAnnounce(2129132, 3)
local timerNextLivingBomb               = mod:NewNextTimer(12, 2129132)

--Local Variables Frost Champion
--local sayIceBarrage               = mod:NewFadesYell(2129160)
local absoluteZeroCast              = false -- flag for the first Absolute Zero cast
local frozenOrbCounter              = 0
local iceBarrageCounter             = 0
local warningAbsoluteZero           = mod:NewSpellAnnounce(2129169, 3)
local timerNextAbsoluteZero         = mod:NewNextTimer(68, 2129169)
--local AbsoluteZeroCast            = mod:NewCastTimer(2, 2129169)
local warningFrozenOrb              = mod:NewSpellAnnounce(2129159, 3)
local timerNextFrozenOrb	 	    = mod:NewNextTimer(30, 2129159)
--local FrozenOrbCast               = mod:NewCastTimer(2, 2129159)
local warningIceBarrage             = mod:NewSpellAnnounce(2129160, 3)
local timerNextIceBarrage           = mod:NewNextTimer(30, 2129160)
--local IceBarrageCast              = mod:NewCastTimer(2, 2129161)

--Functions Fire Champion
function mod:encounterFireChampion()
    timerNextMagmaInfusion:Start(4)
    timerNextFiresFromTheSkys:Start(19)
    timerNextMeltDown:Start(20)
    timerNextFlameTorrent:Start(24)
end

function mod:handleFireChamp(args)
    if args:IsSpellID(2129111) then
	   timerNextFlameTorrent:Start(30)
	   warningFlameTorrent:Show(30)
    elseif args:IsSpellID(2129117) then
	   timerNextMagmaInfusion:Start(30)
	   warningMagmaInfusion:Show(30)
    end
end


--Functions Frost Champion
function mod:encounterFrostChampion()
    timerNextAbsoluteZero:Start(15)
    timerNextIceBarrage:Start(28)
end

function mod:handleFrostChamp(args)
    if args:IsSpellID(2129169) then
	   timerNextAbsoluteZero:Start(68)
	   warningAbsoluteZero:Show(68)
	   absoluteZeroCast = true
	   frozenOrbCounter = 0
	   iceBarrageCounter = 0
    elseif args:IsSpellID(2129159) then
	   if frostChamp == false then
		  frostChamp = true
		  self:ScheduleMethod(0,"encounterFrostChampion")
	   end
	   frozenOrbCounter = frozenOrbCounter + 1
	   local delayFrozenOrb = (absoluteZeroCast and frozenOrbCounter == 1) and 30 or 38
	   timerNextFrozenOrb:Start(delayFrozenOrb)
	   warningFrozenOrb:Show(delayFrozenOrb)
    elseif args:IsSpellID(2129160) then
	   iceBarrageCounter = iceBarrageCounter + 1
	   local delayIceBarrage = (absoluteZeroCast and iceBarrageCounter == 1) and 30 or 38
	   timerNextIceBarrage:Start(delayIceBarrage)
	   warningIceBarrage:Show(delayIceBarrage)
    end
end

function mod:SPELL_CAST_START(args)
    self:handleFrostChamp(args)
    self:handleFireChamp(args)
end

function mod:SPELL_CAST_SUCCESS(args)
    if args:IsSpellID(2129123) then
	   timerNextFiresFromTheSkys:Start(66)
	   warningFiresFromTheSkys:Show(66)
	   timerNextFlameTorrent:AddTime(6)
	   timerNextMagmaInfusion:AddTime(6)
	   timerNextLivingBomb:AddTime(6)
	   timerNextMeltDown:AddTime(6)
    end
end

function mod:SPELL_AURA_APPLIED(args)
    if args:IsSpellID(2129132) then
	   timerNextLivingBomb:Start(12)
	   warningLivingBomb:Show(12)
    elseif args:IsSpellID(2129107) then
	   if fireChamp == false then
		  fireChamp = true
		  self:ScheduleMethod(0,"encounterFireChampion")
	   end
    end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
    if args:IsSpellID(2129107) and args.destName == "Mythic Champion" then
	   timerNextMeltDown:Start(19 -	meltdownAmount)
	   warningMeltDown:Show(19 - meltdownAmount)
	   meltdownAmount = meltdownAmount +1
    end
end

function mod:UNIT_DIED(args)
    if args.destName == "Mythic Champion" then
	   frostChamp = false
	   fireChamp = false
	   timerNextAbsoluteZero:Cancel()
	   timerNextIceBarrage:Cancel()
	   timerNextFrozenOrb:Cancel()
	   timerNextMagmaInfusion:Cancel()
	   timerNextLivingBomb:Cancel()
	   timerNextFiresFromTheSkys:Cancel()
	   timerNextFlameTorrent:Cancel()
	   meltdownAmount = 0
    end
end

function mod:OnCombatEnd()
	   frostChamp = false
	   fireChamp = false
	   timerNextAbsoluteZero:Cancel()
	   timerNextIceBarrage:Cancel()
	   timerNextFrozenOrb:Cancel()
	   timerNextMagmaInfusion:Cancel()
	   timerNextLivingBomb:Cancel()
	   timerNextFiresFromTheSkys:Cancel()
	   timerNextFlameTorrent:Cancel()
	   meltdownAmount = 0
end