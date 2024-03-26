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
	"PLAYER_ALIVE",
	"UNIT_DIED",
	"SPELL_AURA_REFRESH"
)

-----ENRAGE-----
-- local warnEnrageSoon			= mod:NewSoonAnnounce(28798, 3)
-----Frenzy-----
-- local warnFrenzyNow				= mod:NewSpellAnnounce(28798, 4)
local timerSadism				= mod:NewNextTimer(30, 2123101)
local timerBloodBath			= mod:NewBuffActiveTimer(45, 2123102)
local warnBloodBathSoon			= mod:NewAnnounce("Faerlina is getting hungry for blood!", 2, 2123102)
local warnSadism				= mod:NewSpellAnnounce(2123101, 3)
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
	timerSadism:Start(60-delay)
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
	if args:IsSpellID(2123101) then
		warnSadism:Show(args.spellName, args.destName, args.amount or 1)
		timerSadism:Start(30)
	elseif args:IsSpellID(2123102) then
		timerSadism:Stop()
		timerBloodBath:Start()
		warnBloodBathSoon:Schedule(40)
	elseif args:IsSpellID(2123107,2123108,2123109,2123110) then 
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

function mod:SPELL_AURA_REFRESH(args)
	if args:IsSpellID(2123102) then
		timerSadism:Stop()
		timerBloodBath:Start()
		warnBloodBathSoon:Cancel()
		warnBloodBathSoon:Schedule(40)
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2123101) then
		warnSadism:Show(args.spellName, args.destName, args.amount or 1)
		timerSadism:Start()
	elseif args:IsSpellID(2123107,2123108,2123109,2123110) then 
		if args:IsPlayer() then
			specWarnRainOfFire:Show();
		end
	elseif args:IsSpellID(2123115,2123116,2123117,2123118) then 
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
	if args:IsSpellID(2123107,2123108,2123109,2123110) then
		if args:IsPlayer() then
			specWarnRainOfFire:Show()
		end
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15956 or cid == 26615 then
		timerSadism:Stop()
	end
end

function mod:OnCombatEnd()
	timerSadism:Stop()
end