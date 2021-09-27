local mod	= DBM:NewMod("Shazzrah", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(12264)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS",
	"SPELL_INTERRUPT",
	"SPELL_CAST_START"
)

local warnDampen			= mod:NewSpellAnnounce(2105089)
local warnSoonCounter		= mod:NewSoonAnnounce(2105095)
local warnCastExplo			= mod:NewCastAnnounce(2105085)
-- local warnCurse			= mod:NewSpellAnnounce(19713)
-- local warnGrounding		= mod:NewSpellAnnounce(19714, 2, nil, false)
-- local warnCntrSpell		= mod:NewSpellAnnounce(19715)
-- local warnBlink			= mod:NewSpellAnnounce(21655)

-- local timerCurseCD		= mod:NewNextTimer(20, 19713)
-- local timerGrounding	= mod:NewBuffActiveTimer(30, 19714, nil, false)
-- local timerBlinkCD		= mod:NewNextTimer(30, 21655)
local timerBomb				= mod:NewTargetTimer(8, 2105097)

local timerExplo			= mod:NewCastTimer(10, 2105085)

local timerNextBomb			= mod:NewNextTimer(16, 2105097)
local timerNextCounter		= mod:NewNextTimer(26, 2105095)
local timerNextDampen		= mod:NewNextTimer(45, 2105089)
local timerNextExplo		= mod:NewNextTimer(75, 2105085)

function mod:OnCombatStart(delay)
	timerNextExplo:Start(30-delay)
	timerNextCounter:Start(25-delay)
	timerNextDampen:Start(10-delay)
	self:ScheduleMethod(25, "CounterSpell")
end

function mod:CounterSpell()
	self:UnscheduleMethod("CounterSpell")
	timerNextCounter:Start()
	warnSoonCounter:Schedule(23)
	self:ScheduleMethod(26, "CounterSpell")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2105089) then
		warnDampen:Show(args.destName)
		timerNextDampen:Start()
	elseif args:IsSpellID(2105097) then
		timerBomb:Start(args.destName)
		timerNextBomb:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2105085, 2105086) or args:IsSpellID(2105087, 2105088) then
		timerNextExplo:Start()
		warnCastExplo:Start()
		timerExplo:Start()
	end
end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args:IsSpellID(19714) then
-- 		timerGrounding:Cancel()
-- 	end
-- end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args:IsSpellID(19713) and self:IsInCombat() then
-- 		warnCurse:Show()
-- 		timerCurseCD:Start()
-- 	elseif args:IsSpellID(19715) and self:IsInCombat() then
-- 		warnCntrSpell:Show()
-- 	elseif args:IsSpellID(21655) and self:IsInCombat() then
-- 		warnBlink:Show()
-- 		timerBlinkCD:Start()
-- 	end
-- end