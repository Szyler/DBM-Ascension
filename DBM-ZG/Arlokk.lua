local mod	= DBM:NewMod("Arlokk", "DBM-ZG", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(14515)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS"
)

-- local warnPain		= mod:NewTargetAnnounce(24212)

-- local timerPain		= mod:NewTargetTimer(18, 24212)
local warnPhase2		= mod:NewPhaseAnnounce(2)

local warnMark			= mod:NewTargetAnnounce(24210)
local specWarnMark		= mod:NewSpecialWarningYou(24210)
local timerMark			= mod:NewTargetTimer(20, 24210)

local warnKidney		= mod:NewTargetAnnounce(340086)
local timerKidney		= mod:NewTargetTimer(20, 340086)

local warnRavage		= mod:NewTargetAnnounce(24213)
local timerRavage		= mod:NewTargetTimer(36, 24213)
local timerRavage2		= mod:NewTargetTimer(6, 24213)

local warnFlurry		= mod:NewSpellAnnounce(100328)
local timerFlurry		= mod:NewTargetTimer(5, 100328)

function mod:OnCombatStart(delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(24210) then
		warnMark:Show(args.destName)
		timerMark:Start(args.destName)
		if args:IsPlayer() then
			specWarnMark:Show()
		end
	elseif args:IsSpellID(24213) then
		warnRavage:Show(args.destName)
		timerRavage:Start()
		timerRavage2:Start(6)
	elseif args:IsSpellID(340086) then
		warnKidney:Show(args.destName)
		timerKidney:Start()
	elseif args:IsSpellID(340500) then
		warnPhase2:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(100328) then
		warnFlurry:Show()
		timerFlurry:Start(args.destName)
	end
end