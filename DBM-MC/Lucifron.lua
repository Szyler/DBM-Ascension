local mod	= DBM:NewMod("Lucifron", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(12118)--, 12119
mod:RegisterCombat("combat", 12118)

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warnDoom			= mod:NewSpellAnnounce(19702)
local warnCurse			= mod:NewSpellAnnounce(19703)
local warnMC			= mod:NewTargetAnnounce(20604)
local warnTouch			= mod:NewTargetAnnounce(350073)
local warnTouchYou		= mod:NewSpecialWarningYou(350073)

local timerNextTouch	= mod:NewNextTimer(18, 350073)
local timerNextCurse	= mod:NewNextTimer(20, 19703)
local timerNextDoom		= mod:NewNextTimer(15, 19702)
local timerDoom			= mod:NewCastTimer(10, 19702)
local timerMC			= mod:NewTargetTimer(5, 20604)

local enrageTimer		= mod:NewBerserkTimer(300)

function mod:OnCombatStart(delay)
	timerNextDoom:Start(10-delay)
	timerNextCurse:Start(20-delay)
	enrageTimer:Start(-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(19702, 350072) then
		warnDoom:Show()
		timerDoom:Start()
		timerNextDoom:Start()
	elseif args:IsSpellID(19703) then
		timerNextCurse:Start()
		warnCurse:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(20604) then
		warnMC:Show(args.destName)
		timerMC:Start(args.destName)
	elseif args:IsSpellID(350073) then
		warnTouch:Show(args.destName)
		timerNextTouch:Start()
		if args:IsPlayer() then
			warnTouchYou:Show()
		end
	end
end