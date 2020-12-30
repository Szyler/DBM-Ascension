local mod	= DBM:NewMod("Faerlina", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2248 $"):sub(12, -3))
mod:SetCreatureID(15953, 16506)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"PLAYER_ALIVE"
)

-----ENRAGE-----
local warnEnrageSoon			= mod:NewSoonAnnounce(28798, 3)
local warnEnrageNow				= mod:NewSpellAnnounce(28798, 4)
local timerEnrage				= mod:NewCDTimer(60, 28798)
-----EMBRACE-----
local warnEmbraceExpire			= mod:NewBuffEndSoonAnnounce(28732, 2)
local warnEmbraceExpired		= mod:NewBuffEndNowAnnounce(28732, 3)
local warnEmbraceActive			= mod:NewSpellAnnounce(28732, 1)
local timerEmbrace				= mod:NewBuffActiveTimer(20, 28732)
-----RAIN OF FIRE-----
local specWarnRainOfFire		= mod:NewSpecialWarningMove(1003054, true, nil, true)
local soundRainOfFire			= mod:SoundAlert(1003054)
-----POISON-----
local specWarnPoisonPool		= mod:NewSpecialWarningMove(869762, true, nil, true)
local specWarnClingingPoison	= mod:NewSpecialWarningMove(1003060, true, nil, true)
local soundPoison				= mod:SoundInfo(869762)
-----MISC-----
local berserkTimer				= mod:NewBerserkTimer(300)
local embraceSpam = 0
local enraged = false

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start(300-delay)

	timer = 60
	timerEnrage:Start(timer - delay)
	warnEnrageSoon:Schedule(timer - 5 - delay)
	enraged = false
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(28732, 54097)				-- Widow's Embrace
	and (GetTime() - embraceSpam) > 5 then  -- This spell is casted twice in Naxx 25 (bug?)
		embraceSpam = GetTime()
		warnEmbraceExpire:Cancel()
		warnEmbraceExpired:Cancel()
		warnEnrageSoon:Cancel()
		timerEnrage:Stop()
		if enraged then
			timer = 55
			timerEnrage:Start(timer)
			warnEnrageSoon:Schedule(timer)
		end
		timer = 20
		timerEmbrace:Start(timer)
		warnEmbraceActive:Show()
		warnEmbraceExpire:Schedule(timer - 55)
		warnEmbraceExpired:Schedule(timer)
		enraged = false
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(28798, 54100) then
		warnEnrageNow:Show()
		enraged = GetTime()
	end
	if args:IsSpellID(1003054) then 
		if args:IsPlayer() then
			specWarnRainOfFire:Show(5);
			soundRainOfFire:Play();
		end
	end
	if args:IsSpellID(869762) then 
		if args:IsPlayer() then
			specWarnPoisonPool:Show(5);
			soundPoison:Play();
		end
	end
	if args:IsSpellID(1003060) then 
		if args:IsPlayer() then
			specWarnClingingPoison:Show(5);
			soundPoison:Play();
		end
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(1003054) then 
		if args:IsPlayer() then
			specWarnRainOfFire:Show(5);
			soundRainOfFire:Play();
		end
	end
	if args:IsSpellID(869762) then 
		if args:IsPlayer() then
			specWarnPoisonPool:Show(5);
			soundPoison:Play();
		end
	end
	if args:IsSpellID(1003060) then 
		if args:IsPlayer() then
			specWarnClingingPoison:Show(5);
			soundPoison:Play();
		end
	end
end

