local mod	= DBM:NewMod("Anub'Rekhan", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2943 $"):sub(12, -3))
mod:SetCreatureID(15956)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"PLAYER_ALIVE"
)

-----LOCUST SWARM-----
local prewarnLocustInitial	= mod:NewCooldownAnnounce(28785, 2)
local prewarnLocust			= mod:NewSoonAnnounce(28785, 2)
local warnLocust			= mod:NewCastAnnounce(28785, 3)
local timerLocust			= mod:NewNextTimer(90, 28785)
local timerLocustInitial	= mod:NewCDTimer(90, 28785)
local timerLocustRemaining	= mod:NewBuffActiveTimer(15, 28785)
local specWarnLocust		= mod:NewSpecialWarningSpell(28785)
local soundLocust			= mod:SoundRunAway(28785)
-----DARK GAZE-----
local specWarnDarkGaze		= mod:NewSpecialWarningYou(1003011)
local soundDarkGaze			= mod:SoundAlarmLong(1003011)
-----IMPALE------
local warnImpale			= mod:NewTargetAnnounce(28783, 2)
local soundImpale			= mod:SoundInfo(28783)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(600)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start()

	timer = 90
	timerLocustInitial:Show(timer)
	prewarnLocustInitial:Schedule(timer)
end

function mod:locustRepeat()
	timer = 90
	timerLocust:Show(timer)
	prewarnLocust:Schedule(timer-5)
	warnLocust:Schedule(timer)
	soundLocust:Schedule(timer)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1003011) then 
		if args:IsPlayer() then
			timer = 10
			specWarnDarkGaze:Show(timer);
			soundDarkGaze:Play();
			SendChatMessage(L.YellDarkGaze, "YELL")
		end
	end	
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28785) then
		timer = 18
		mod:locustRepeat()
		specWarnLocust:Show(18)
		timerLocustRemaining:Show(18)
	elseif args:IsSpellID(28783) then
		self:ScheduleMethod(0.1, "anubImpale")
	end
end

function mod:anubImpale()
	local target = mod:GetBossTarget(15956)
	if target then
		warnImpale:Show(target)
		if target == UnitName("player") then 
			soundImpale:Play()
		end
	end
	local targetShade = mod:GetBossTarget(1003012)
	if targetShade then
		warnImpale:Show(targetShade)
		if targetShade == UnitName("player") then 
			soundImpale:Play()
		end
	end
end