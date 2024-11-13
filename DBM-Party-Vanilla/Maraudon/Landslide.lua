local mod	= DBM:NewMod(429, "DBM-Party-Vanilla", 8, 232)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(12203)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)

--TODO, verify timers further, in classic timers are never very static
local warningLandSlide				= mod:NewSpellAnnounce(21808, 2)
local warningKnockAway				= mod:NewSpellAnnounce(11130, 2)
local warningTrample				= mod:NewSpellAnnounce(5568, 2)

local specWarnWrath					= mod:NewInterruptAnnounce(21807)

local timerLandslideCD				= mod:NewCDTimer(180, 21808)
local timerKnockAwayCD				= mod:NewCDTimer(15.9, 11130, nil, nil, nil, 2)
local timerTrampleCD				= mod:NewCDTimer(13.4, 5568, nil, nil, nil, 2)

function mod:OnCombatStart(delay)
	timerTrampleCD:Start(6-delay)--6
	timerKnockAwayCD:Start(9-delay)--9
	timerLandslideCD:Start(1-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(21808) then
		warningLandSlide:Show()
		timerLandslideCD:Start()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(110762, 11130) then--Retail, Classic (not confirmed, no actual data yet)
		warningKnockAway:Show()
		timerKnockAwayCD:Start()
	elseif args:IsSpellID(5568) then
		warningTrample:Show()
		timerTrampleCD:Start()
	end
end
