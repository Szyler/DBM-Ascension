local mod	= DBM:NewMod("Alva", "DBM-Party-Manastorm", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5022 $"):sub(12, -3))
mod:SetCreatureID(97700, 97701)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"PLAYER_ALIVE",
	"SPELL_CAST_START" --255464, 255465 , 255374, 255455, 255437, 255397, 255447
)

local timerNextFrostStrike			= mod:NewNextTimer(15, 255465) -- 255464, 255465 Frost Strike 15s CD
local timerNextFrostbladeStrike		= mod:NewNextTimer(15, 255428) -- 255428, 255452, 255453 Frostblade Strike 15s CD
local timerNextIceRock				= mod:NewNextTimer(6, 255374) -- 255374, 255375, 255377 Ice Rock 2 sec cast time, 6s CD
local timerNextShadowShroudSurge	= mod:NewNextTimer(58, 255455) -- 255455 Shadow Shroud Surge 7 sec cast time, 58s CD
local timerNextShadowShroudRebirth	= mod:NewNextTimer(9, 255455) -- 255455 Shadow Shroud Rebirth 2 sec cast time 9 seconds after Shadow Shroud Surge
local timerNextArcingSlice			= mod:NewNextTimer(16, 255437) -- 255437 Arcing slice 3 sec cast time, 16s CD
local timerNextBlastArrow			= mod:NewNextTimer(56, 255358) -- 255358 Blast Arrow 56s CD
local timerShadowVeilLance			= mod:NewBuffTimer(28, 255397) -- 255397 Shadow Veil Lance 2.5 sec cast time, 28s duration
local timerNextFrostRoar			= mod:NewNextTimer(9, 255447) -- 255447 Frost Roar 9/48s CD

local timerCastIceRock 				= mod:NewCastTimer(2, 255374) -- Ice Rock 2 sec cast time
local timerCastShadowShroudSurge 	= mod:NewCastTimer(7, 255455) -- Shadow Shroud Surge 7 sec cast time
local timerCastShadowShroudRebirth 	= mod:NewCastTimer(2, 255455) -- Shadow Shroud Rebirth 2 sec cast time
local timerCastArcingSlice 			= mod:NewCastTimer(3, 255437) -- Arcing slice 3 sec cast time
local timerCastShadowVeilLance 		= mod:NewCastTimer(2.5, 255397) -- Shadow Veil Lance 2.5 sec cast time
local timerFrostRoar				= mod:NewCastTimer(2, 255447) -- 255447 Frost Roar 2 sec cast time


function mod:OnCombatStart(delay)
	
end

function mod:SPELL_CAST_START(args)
	if args.spellId == 255465 then -- Frost Strike
		timerNextFrostStrike:Start()
	elseif args.spellId == 255464 then -- Frostblade Strike
		timerNextFrostbladeStrike:Start()
	elseif args.spellId == 255374 then -- Ice Rock
		timerNextIceRock:Start()
		timerCastIceRock:Start()
	elseif args.spellId == 255455 then -- Shadow Shroud Surge
		timerNextShadowShroudSurge:Start()
		timerNextShadowShroudRebirth:Start(9)
		timerCastShadowShroudSurge:Start()
	elseif args.spellId == 255437 then -- Arcing Slice
		timerNextArcingSlice:Start()
		timerCastArcingSlice:Start()
	elseif args.spellId == 255397 then -- Shadow Veil Lance
		timerShadowVeilLance:Start()
		timerCastShadowVeilLance:Start()
	elseif args.spellId == 255447 then -- Frost Roar
		timerFrostRoar:Start()
		if triggeredbefore == false then
			timerNextFrostRoar:Start(9)
			triggeredbefore = true
		else
			timerNextFrostRoar:Start(48)
			triggeredbefore = false
		end
	elseif args.spellId == 255358 then -- Blast Arrow
		timerNextBlastArrow:Start()
	end
end
