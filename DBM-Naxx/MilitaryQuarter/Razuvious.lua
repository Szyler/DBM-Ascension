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
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

-----DISRUPTING SHOUT-----
local warnShoutNow			= mod:NewSpellAnnounce(29107, 2)
local warnShoutSoon			= mod:NewSoonAnnounce(29107, 3)
local timerShout			= mod:NewCDTimer(10, 29107)
local warnShoutNowBackup	= mod:NewSpellAnnounce(29107, 2)
local warnShoutSoonBackup	= mod:NewSoonAnnounce(29107, 3)
local timerShoutBackup		= mod:NewCDTimer(10, 29107)
-----SHADOW BURST-----
local warnShadowBurstNow	= mod:NewSpellAnnounce(1003108, 2)
local warnShadowBurstSoon	= mod:NewSoonAnnounce(1003108, 3)
local timerShadowBurst		= mod:NewNextTimer(25, 1003108)
-----JAGGED KNIFE-----
local warnKnifeNow			= mod:NewTargetAnnounce(55550, 2)
local specWarnKnife			= mod:NewSpecialWarningSpell(55550, nil, nil, nil, 10)
-----BRUISING BLOW-----
local warnBlowNow			= mod:NewSpellAnnounce(26613, 2)
local warnBlowSoon			= mod:NewSoonAnnounce(26613, 3)
local timerBlow				= mod:NewNextTimer(15, 26613)
-----CURSE OF FEEBLENESS-----
local warnCurseNow			= mod:NewSpellAnnounce(1003253, 2)
local warnCurseEndSoon		= mod:NewSoonAnnounce(1003253, 3)
local timerCurse			= mod:NewBuffActiveTimer(120, 1003253)
-----MISC-----
local razHealth
local phase
local notKT					= 0
local warnPhase2			= mod:NewPhaseAnnounce(2)

-----BOSS FUNCTIONS-----
function mod:OnCombatStart(delay)
	phase = 1
	self.vb.phase = 1
	RealRazuv = 1
	-----Shout-----
	warnShoutNow:Schedule(16 - delay)
	warnShoutSoon:Schedule(11 - delay)
	timerShout:Start(16 - delay)
	-----Shadow Burst-----
	warnShadowBurstNow:Schedule(25-delay)
	warnShadowBurstSoon:Schedule(20-delay)
	timerShadowBurst:Start(25-delay)
	-----Bruising Blow-----
	warnBlowNow:Schedule(15-delay)
	warnBlowSoon:Schedule(10-delay)
	timerBlow:Start(15-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(55550) then 
		warnKnifeNow:Show(args.destName)
		if args:IsPlayer() then
			specWarnKnife:Show(10);
			SendChatMessage(L.YellKnife, "YELL")
			notKT = 1
		end
	elseif args:IsSpellID(1003253) then 
		timer = 120
		warnCurseNow:Schedule(timer)
		warnCurseEndSoon:Schedule(timer-10)
		timerCurse:Start(timer)
		notKT = 1
	end		
end

function mod:SPELL_CAST_SUCCESS(args)
	if RealRazuv then
		if args:IsSpellID(26613) then
			timer = 15
			warnBlowNow:Schedule(timer)
			warnBlowSoon:Schedule(timer-5)
			timerBlow:Start(timer)

		elseif args:IsSpellID(29107) then
			if notKT == 1 then
				timer = 10

				self:Unschedule("warnShoutNowBackup")
				self:Unschedule("warnShoutSoonBackup")
				timerShoutBackup:Stop()

				warnShoutNow:Schedule(timer)
				warnShoutSoon:Schedule(timer-3)
				timerShout:Start(timer)
				
				warnShoutNowBackup:Schedule(timer*2)
				warnShoutSoonBackup:Schedule(timer*2-3)
				timerShoutBackup:Start(timer*2)
			end
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(1003108) then
		timer = 25
		warnShadowBurstNow:Schedule(timer)
		warnShadowBurstSoon:Schedule(timer-5)
		timerShadowBurst:Start(timer)
	end
end

function mod:UNIT_HEALTH(args)
    razHealth = math.max(0, UnitHealth("boss1")) / math.max(1, UnitHealthMax("boss1")) * 100;
	if razHealth < 40 and phase == 1 then
		phase = 2
		self.vb.phase = 2
		warnPhase2:Show();
		-----Shadow Burst-----
		warnShadowBurstNow:Cancel();
		warnShadowBurstSoon:Cancel();
		timerShadowBurst:Cancel();
	end
end