local mod	= DBM:NewMod("Faerlina", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15953, 16506)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_PERIODIC_DAMAGE",
	"PLAYER_ALIVE"
)

-----ENRAGE-----
-- local warnEnrageSoon			= mod:NewSoonAnnounce(28798, 3)
-----Frenzy-----
-- local warnFrenzyNow				= mod:NewSpellAnnounce(28798, 4)
local timerFrenzy				= mod:NewNextTimer(60, 28798)
local warnFrenzy				= mod:NewAnnounce(L.FaerlinaFrenzy, 2, 28798)
-----EMBRACE-----
local warnEmbraceActive			= mod:NewSpellAnnounce(28732, 1)
local timerEmbrace				= mod:NewBuffActiveTimer(20, 28732)
-----RAIN OF FIRE-----
local specWarnRainOfFire		= mod:NewSpecialWarningMove(1003054, true, nil, true)
-----POISON-----
local specWarnPoisonPool		= mod:NewSpecialWarningMove(869762, true, nil, true)
local specWarnClingingPoison	= mod:NewSpecialWarningMove(1003060, true, nil, true)
-----Malicious Strike-----
local warnMalicious				= mod:NewAnnounce(L.FaerlinaMalicious, 2, 350250)
-----MISC-----
local berserkTimer				= mod:NewBerserkTimer(600)
-- local embraceSpam = 0
-- local enraged = false

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerFrenzy:Start(-delay)
	-- timer = 60
	-- timerEnrage:Start(timer - delay)
	-- warnEnrageSoon:Schedule(timer - 5 - delay)
	-- enraged = false
end

-- function mod:SPELL_CAST_SUCCESS(args)
-- 	if args:IsSpellID(28732, 54097)				-- Widow's Embrace
-- 	and (GetTime() - embraceSpam) > 5 then  -- This spell is casted twice in Naxx 25 (bug?)
-- 		embraceSpam = GetTime()
-- 		-- warnEnrageSoon:Cancel()
-- 		timerEnrage:Stop()
-- 		if enraged then
-- 			timer = 55
-- 			timerEnrage:Start(timer)
-- 			-- warnEnrageSoon:Schedule(timer)
-- 		end
-- 		timer = 20
-- 		timerEmbrace:Start(timer)
-- 		warnEmbraceActive:Show()
-- 		enraged = false
-- 	end
-- end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28798, 54100) then
		warnFrenzy:Show(args.spellName, args.destName, args.amount or 1)
		timerFrenzy:Start()
	elseif args:IsSpellID(1003054) then 
		if args:IsPlayer() then
			specWarnRainOfFire:Show();
		end
	elseif args:IsSpellID(869762, 350284) then 
		if args:IsPlayer() then
			specWarnPoisonPool:Show();
		end
	elseif args:IsSpellID(1003060) then 
		if args:IsPlayer() then
			specWarnClingingPoison:Show();
		end
	elseif args:IsSpellID(350250) then
		warnMalicious:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(28798, 54100) then
		warnFrenzy:Show(args.spellName, args.destName, args.amount or 1)
		timerFrenzy:Start()
	elseif args:IsSpellID(1003054) then 
		if args:IsPlayer() then
			specWarnRainOfFire:Show();
		end
	elseif args:IsSpellID(869762, 350284) then 
		if args:IsPlayer() then
			specWarnPoisonPool:Show();
		end
	elseif args:IsSpellID(1003060) then 
		if args:IsPlayer() then
			specWarnClingingPoison:Show();
		end
	elseif args:IsSpellID(350250) then
		warnMalicious:Show(args.spellName, args.destName, args.amount or 1)
	end
end

function mod:SPELL_PERIODIC_DAMAGE(args)
	if args:IsSpellID(350286) then
		if args:IsPlayer() then
			specWarnRainOfFire:Show()
		end
	end
end