local mod	= DBM:NewMod("Mythic Champion", "DBM-Party-Vanilla")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(80227)
mod:RegisterCombat("combat", 80227)
mod:SetUsedIcons(8)

mod:RegisterEvents(
	"SPELL_CAST_START"
)

-- FO 		= 		Frozen orb 2 sec cast
-- AZ 		= 		Absolute Zero 4 sec cast 4 sec channel
-- IB 		= 		Ice Barrage 2 second cast 4 sec channel
-- IBDB 	= 		Ice barrage Debuff
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


local firstFrozenOrbTriggered        = false
local firstAbsoluteZeroTriggered     = false
local firstIceBarrageTriggered       = false
local firstFrozenOrb                 = false -- flag for the first Frozen Orb cast
local absoluteZeroCast               = false -- flag for the first Absolute Zero cast
local frozenOrbCounter               = 0
local iceBarrageCounter              = 0



--local warningAbsoluteZero   	= mod:NewSpellAnnounce(2129169, 3)
local timerNextAbsoluteZero     	= mod:NewNextTimer(68, 2129169)
--local AbsoluteZeroCast 			= mod:NewCastTimer(2, 2129169)

--local warningFrozenOrb     		= mod:NewSpellAnnounce(2129159, 3)
local timerNextFrozenOrb      		= mod:NewNextTimer(30, 2129159)
--local FrozenOrbCast     		= mod:NewCastTimer(2, 2129159)

--local warningIceBarrage   		= mod:NewSpellAnnounce(2129161, 3)
local timerNextIceBarrage      		= mod:NewNextTimer(30, 2129161)
--local IceBarrageCast      		= mod:NewCastTimer(2, 2129161)


mod:AddBoolOption("SetIconOnBombTarget", true)


function mod:handleFirstFrozenOrb(args)
    if not firstFrozenOrbTriggered then
        firstFrozenOrb = not firstFrozenOrb
        timerNextFrozenOrb:Start(38)
        firstFrozenOrb = true
        firstFrozenOrbTriggered = true

        -- Trigger firstAbsoluteZero and firstIceBarrage only once
        if not firstAbsoluteZeroTriggered then
            timerNextAbsoluteZero:Start(15)
            firstAbsoluteZeroTriggered = true
        elseif not firstIceBarrageTriggered then
            timerNextIceBarrage:Start(28)
            firstIceBarrageTriggered = true
        end
    end
end

function mod:SPELL_CAST_START(args)
    if args.spellId == 2129159 then
        self:handleFirstFrozenOrb(args)
    elseif args.spellId == 2129169 and firstFrozenOrbTriggered == true then
        timerNextAbsoluteZero:Start(68)
        frozenOrbCounter = 0
        iceBarrageCounter = 0
    elseif args.spellId == 2129161 then
        iceBarrageCounter = iceBarrageCounter + 1
        local delayIceBarrage = (absoluteZeroCast and iceBarrageCounter == 1) and 38 or 30
        timerNextIceBarrage:Start(delayIceBarrage)
    elseif args.spellId == 2129159 then
        frozenOrbCounter = frozenOrbCounter + 1
        local delayFrozenOrb = (absoluteZeroCast and frozenOrbCounter == 1) and 38 or 30
        timerNextFrozenOrb:Start(delayFrozenOrb)
    end
end