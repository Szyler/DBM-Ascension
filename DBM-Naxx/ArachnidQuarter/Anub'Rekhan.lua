local mod	= DBM:NewMod("Anub'Rekhan", "DBM-Naxx", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 2943 $"):sub(12, -3))
mod:SetCreatureID(15956)
mod:RegisterCombat("combat")
mod:EnableModel()
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"PLAYER_ALIVE",
	"UNIT_DIED"
)

-----LOCUST SWARM-----
local prewarnLocust			= mod:NewSoonAnnounce(2123004, 2)
local warnLocust			= mod:NewCastAnnounce(2123004, 3)
local timerLocust			= mod:NewNextTimer(90, 2123004)
local specWarnLocust		= mod:NewSpecialWarningSpell(2123004)
local timerLocustRemaining	= mod:NewBuffActiveTimer(17, 2123004)
-----DARK GAZE-----
local specWarnDarkGaze		= mod:NewSpecialWarningYou(1003011)
-----IMPALE------
local timerImpale			= mod:NewCDTimer(15, 2123001)
local warnImpale			= mod:NewTargetAnnounce(2123001, 2)
-----MISC-----
local berserkTimer			= mod:NewBerserkTimer(600)

local tankName = ''

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	berserkTimer:Start(-delay)
	timerLocust:Start(-delay)
	prewarnLocust:Schedule(85-delay)
	timerImpale:Start(10-delay)
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
	if args:IsSpellID(2123003) then
		timerLocust:Start()
		specWarnLocust:Show()
		prewarnLocust:Schedule(85)
		timerLocustRemaining:Schedule(3)
		timerImpale:Stop()
		timerImpale:Start(30)
	elseif args:IsSpellID(2123001) then
		timerImpale:Start()
		tankName = mod:GetBossTarget(15956)
		self:ScheduleMethod(0.1, "anubImpale")
	end
end

function mod:anubImpale()
	local target = mod:GetBossTarget(15956) or mod:GetBossTarget(26614)
	if target ~= tankName then
		warnImpale:Show(target)
	elseif target == tankName then
		self:ScheduleMethod(0.1, "anubImpale")
	end
end

function mod:OnCombatEnd()
	timerLocust:Stop()
	warnLocust:Cancel()
	timerImpale:Stop()
	warnImpale:Cancel()
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15956 or cid == 26614 then
		timerLocust:Stop()
		warnLocust:Cancel()
		timerImpale:Stop()
		warnImpale:Cancel()
	end
end