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
local prewarnLocust			= mod:NewSoonAnnounce(28785, 2)
local warnLocust			= mod:NewCastAnnounce(28785, 3)
local timerLocust			= mod:NewNextTimer(90, 28785)
local specWarnLocust		= mod:NewSpecialWarningSpell(28785)
local timerLocustRemaining	= mod:NewBuffActiveTimer(16, 28785)
-----DARK GAZE-----
local specWarnDarkGaze		= mod:NewSpecialWarningYou(1003011)
-----IMPALE------
local timerImpale			= mod:NewCDTimer(10, 28783)
local warnImpale			= mod:NewTargetAnnounce(28783, 2)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(600)

local tankName = ''

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerLocust:Start(-delay)
	prewarnLocust:Schedule(85-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(1003011) then 
		if args:IsPlayer() then
			specWarnDarkGaze:Show();
			SendChatMessage(L.YellDarkGaze, "YELL")
		end
	end	
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(28785) then
		timerLocust:Start()
		specWarnLocust:Show()
		prewarnLocust:Schedule(85)
		timerLocustRemaining:Schedule(3)
	elseif args:IsSpellID(28783) then
		timerImpale:Start()
		tankName = mod:GetBossTarget(15956)
		self:ScheduleMethod(0.1, "anubImpale")
	end
end

function mod:anubImpale()
	local target = mod:GetBossTarget(15956)
	if target then
		warnImpale:Show(target)
		if target == UnitName("player") then 
		end
	elseif target == tankName then
		self:ScheduleMethod(0.1, "anubImpale")
	end
	local targetShade = mod:GetBossTarget(1003012)
	if targetShade then
		warnImpale:Show(targetShade)
		if targetShade == UnitName("player") then 
		end
	end
end