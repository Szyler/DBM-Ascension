local mod	= DBM:NewMod("Razuvious", "DBM-Naxx", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(16061, 16803, 16803)
mod:RegisterCombat("yell", L.Yell1, L.Yell2, L.Yell3, L.Yell4)
mod:SetBossHealthInfo(
	16803, "Trainee 1",
	16803, "Trainee 2"
)
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"UNIT_HEALTH",
	"UNIT_DIED",
	"PLAYER_ALIVE",
	"SPELL_MISSED"
)

-----DISRUPTING SHOUT-----
local timerShout			= mod:NewCDTimer(8, 2123920)
-----Break Unholy Blade-----
local warnUnholyBladeNow	= mod:NewSpellAnnounce(2123928, 2)
local warnUnholyBladeSoon	= mod:NewSoonAnnounce(2123928, 2)
local timerUnholyBlade		= mod:NewNextTimer(30, 2123928)
local timerCastUnholyBlade	= mod:NewCastTimer(3, 2123928)
-----JAGGED KNIFE-----
local warnKnifeNow			= mod:NewTargetAnnounce(2123924, 2)
local timerKnife			= mod:NewNextTimer(15, 2123924)
-----Death Strike-----
local timerDeathStrike		= mod:NewNextTimer(15,2123919)
local warnDeathStrike		= mod:NewCastAnnounce(2123919)
local specwarnDeathStrike	= mod:NewSpecialWarningStack(2123919, 2)
--------Strikes--------------
local timerPlagueStrike		= mod:NewTimer(12, "Plague Strike active", 2123905)
local timerFrostStrike		= mod:NewTimer(12, "Frost Strike active", 2123904)
-----MISC-----
local prewarn
local phase
local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnPhase2Soon		= mod:NewAnnounce("Prepare to stack for Anti-Magic Zone!", 1, 2123928, nil, "Show pre-warning for Phase 2")
local timerenrage			= mod:NewTimer(180, "Enrage", 2123914)

-----PROG NOTES-------
--"Brake Unholy Blade"  (2123928) - vet ikke timer
-- 2123905,"Plague Strike" || SPELL_CAST_SUCCESS
--2123919,"Death Strike" || SPELL_CAST_START - vet ikke timer
-- 2123920 - Disrupting Shout || vet ikke timer
-- Frost Strike - (finn Spell ID). 12 sec, 20sec CD
-- finn timer Death Strike
-- finn timer Jagged Knife
-- finn timer Break Unholy Blade
-- fix trigger for p2
-- 



-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	phase = 1
	prewarn = 1
	self.vb.phase = 1
	-----Break Unholy Blade-----
	timerUnholyBlade:Start(-delay)
	if mod:GetBossTarget(16061) ~= nil then
	timerKnife:Start(-delay)
	timerDeathStrike:Start(20-delay)
	end
end

function mod:BreakUnholyBlade()
	warnUnholyBladeNow:Show()
	timerUnholyBlade:Start()
	timerCastUnholyBlade:Start()
	warnUnholyBladeSoon:Show(25)
end

function mod:DeathStrike()
	warnDeathStrike:Show()
	timerDeathStrike:Start()
end

function mod:PhaseTwo()
	timerDeathStrike:Stop()
	timerUnholyBlade:Stop()
	warnPhase2:Show();
	timerenrage:Start()
	timerShout:Start(8)
	timerKnife:Start()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2123924,2123925,2123926,2123927) then
		warnKnifeNow:Show(args.destName)
		if args:IsPlayer() then
			SendChatMessage("Jagged Cold Steel Knife on "..UnitName("PLAYER").."!", "Say")
		end
		timerKnife:Start()
	elseif args:IsSpellID(2123914) then
		self:ScheduleMethod(0,"PhaseTwo")
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2123919) and args.amount >=1 then
		if args:IsPlayer() then
			specwarnDeathStrike:Show(args.amount)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2123905) then
		timerPlagueStrike:Start()
	elseif args:IsSpellID(2123904) then
		timerFrostStrike:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2123928,2123929,2123930,2123931) then
		phase = 2
		self.vb.phase = 2
		self:ScheduleMethod(0,"PhaseTwo")
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(2123920) and (args.destName == "Instructor Razuvious" or args.destName == "Shade of Instructor Razuvious") then
		timerShout:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2123928,2123929,2123930,2123931) then
		self:ScheduleMethod(0,"BreakUnholyBlade")
	elseif args:IsSpellID(2123919) then
		self:ScheduleMethod(0, "DeathStrike")
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 16061 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.55 and phase == 1 and prewarn == 1 then
		warnPhase2Soon:Show()
		prewarn = 2
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 16061 or cid == 26620 then
		timerenrage:Stop()
		timerKnife:Stop()
	end
end

function mod:OnCombatEnd()
	timerenrage:Stop()
	timerKnife:Stop()
end