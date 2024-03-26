local mod	= DBM:NewMod("Chromius", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(26643)
mod:RegisterCombat("combat", 26643)

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_HEALTH",
	"UNIT_DIED"
)

-- Final Countdown
local specWarnFinalCountdown			= mod:NewSpecialWarning("Final Countdown! The Hourglass will vibrate %s times!", 2141735)
local warnCountdown						= mod:NewAnnounce("There are %s vibrations left!", 2141735)
local timerNextFinalCountdown			= mod:NewTimer(62,"Next Final Countdown: (%s)", 2141735)
local timerFinalDuration				= mod:NewTimer(2,"Final Countdown (%s ticks)", 2141735)
local warnFinalCDSoon					= mod:NewAnnounce("Final Countdown soon!", 2141735)
local timerFinalDelay					= mod:NewTimer(3, "Vibration travel time", 2141735)

-- Events (Mannoroth)
local timerNextChaosBlast				= mod:NewNextTimer(20,2141800)
local timerCastChaosBlast				= mod:NewTargetTimer(3.85, 2141800)
local warnChaosBlast					= mod:NewTargetAnnounce(2141800)
local specWarnChaosBlast				= mod:NewSpecialWarning("Chaos Blast on you!", 2141800)
local timerMannorothsFury				= mod:NewNextTimer(20, 2141809)
local warnMannorothsFury				= mod:NewSpellAnnounce(2141809)

--Events (Tyrande)
local warnBlackArrow					= mod:NewAnnounce("Black Arrow on %s!", 2141904)
local specWarnBlackArrow				= mod:NewSpecialWarning("Black Arrow on you!", 2141904)

--Events (Jaina)
local warnHolyLight						= mod:NewAnnounce("%s is casting Holy Light! Interrupt it!", 2141856)
local timerInsanity						= mod:NewTimer(106, "Jaina is losing her mind...", 2141884)

-- Dragon abilities
local warnArcaneBreath					= mod:NewSpellAnnounce(2141705)
local timerArcaneBreath					= mod:NewNextTimer(30, 2141705)
local timerCastArcaneBreath				= mod:NewCastTimer(2, 2141705)
local timerBreathDuration				= mod:NewTimer(3, "Arcane Breath duration", 2141705)

-- adds
local warnArcaneExplosion				= mod:NewAnnounce("Infinite Time Warder is casting Arcane Explosion!", 2141758)
local timerArcaneExplosion				= mod:NewCastTimer(4, 2141758)

-- Phases
local warnTransSoon						= mod:NewAnnounce("Portal Event incoming in 5 percent health!", 2141724)
local timerTeleport						= mod:NewTimer(5, "Teleported in", 2100249)
local warnJainaPhase					= mod:NewAnnounce("Enter the portal and kill Jaina!", 2141724)
local warnGromPhase						= mod:NewAnnounce("Enter the portal and kill the Infinite Subjugators!", 2141724)
local warnTyrandePhase					= mod:NewAnnounce("Enter the Portal and heal the Sentinels!", 2141724)
local SentinelAnnounce					= mod:NewAnnounce("There are %s Sentinels remaining!", 2140018)


-- SPELL_DAMAGE special warnings
local specWarnConsecration				= mod:NewSpecialWarningMove(2141858)
local specWarnSplitSecond				= mod:NewSpecialWarningMove(2141725)

-- fight
local timerCombatStart					= mod:NewTimer(20, "Combat starting in", 39255)
local count
local countdown
local duration
local prewarn
local SentinelsAlive
local insanity
local phase
local JainaHP
local TyrandeHP
local ThrallHP

-- INFO ---
-- SPELL_CAST_START Arcane Breath (2141705)


function mod:OnCombatStart(delay)
	duration 		= 2
	count 	 		= 1
	countdown		= 1
	prewarn	 		= 0
	phase 			= 0
	SentinelsAlive 	= 5
	JainaHP			= 0
	TyrandeHP		= 0
	ThrallHP		= 0
	insanity		= 0
	timerArcaneBreath:Start(40-delay)
	timerNextFinalCountdown:Start(67-delay, count)
	warnFinalCDSoon:Schedule(60-delay)
	self:ScheduleMethod(67-delay,"FinalCountdown")
end

function mod:FinalCountdown()
	self:UnscheduleMethod("FinalCountdown")
	countdown = count - 1
	specWarnFinalCountdown:Show(count)
	if phase == 0 then
		timerFinalDuration:Start(duration, count)
		count = count + 1
		duration = duration + 2.5
		timerNextFinalCountdown:Start(62,count)
		warnFinalCDSoon:Schedule(57)
		self:ScheduleMethod(62,"FinalCountdown")
	elseif phase == 1 then
		timerFinalDelay:Start(3)
		self:ScheduleMethod(3,"FinalDuration")
	elseif phase == 2 then
		timerFinalDelay:Start(3)
		self:ScheduleMethod(3,"FinalDuration")
	elseif phase == 3 then
		timerFinalDelay:Start(3)
		self:ScheduleMethod(3,"FinalDuration")
	end
end

function mod:FinalDuration()
	timerFinalDuration:Start(duration, count)
	count = count + 1
	duration = duration + 2.5
	self:ScheduleMethod(57,"FinalCountdown")
	timerNextFinalCountdown:Start(57,count)
	warnFinalCDSoon:Schedule(52)
end

function mod:ChaosBlast()
	local targetCB = mod:GetBossTarget(26688)
	if targetCB == UnitName("player") then
		specWarnChaosBlast:Show()
		SendChatMessage("Chaos Blast on "..UnitName("PLAYER").."!", "SAY")
	else
		warnChaosBlast:Show(targetCB)
	end
	timerCastChaosBlast:Start(targetCB)
	self:SetIcon(targetCB, 8, 4)
end

function mod:MannorothsFury()
	self:UnscheduleMethod("MannorothsFury")
	timerMannorothsFury:Start()
	warnMannorothsFury:Show()
	self:ScheduleMethod(20,"MannorothsFury")
end

function mod:StopTimers()
	timerArcaneBreath:Stop()
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2141904) then
		if args:IsPlayer() then
			specWarnBlackArrow:Show()
		else
			warnBlackArrow:Show(args.destName)
		end
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2141858,2141859,2141860,2141861) and args:IsPlayer() and DBM:AntiSpam(5,1) then
		specWarnConsecration:Show()
	end
	if args:IsSpellID(2141725,2141726,2141727,2141728) and args:IsPlayer() and DBM:AntiSpam(5,2) then
		specWarnSplitSecond:Show()
	end
	if args:IsSpellID(2141736,2141737,2141738,2141739) and DBM:AntiSpam(1.8,6) then
		if countdown >= 1 then
			warnCountdown:Show(countdown)
			countdown = countdown - 1
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2141705) then
		warnArcaneBreath:Show()
		timerArcaneBreath:Start()
		timerCastArcaneBreath:Start()
		timerBreathDuration:Schedule(2)
	end
	if args:IsSpellID(2141758) then
		warnArcaneExplosion:Show()
		timerArcaneExplosion:Start()
		self:SetIcon(args.sourceGUID, 8)
	end
	if args:IsSpellID(2141800) then
		self:ScheduleMethod(0.15, "ChaosBlast")
		timerNextChaosBlast:Start()
	end
	if args:IsSpellID(2141856) then
		warnHolyLight:Show(args.sourceName)
	end
	if args:IsSpellID(2141868,2141869,2140134,2140135) and phase == 1 and insanity == 1 and args.sourceName == "Lady Jaina Proudmoore" then
	insanity = 0
	timerInsanity:Stop()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.ChromiusRP or msg:find(L.ChromiusRP) then
		timerCombatStart:Start()
	elseif msg == L.ChromiusRP2 or msg:find(L.ChromiusRP2) then
			timerCombatStart:Start()
	elseif msg == L.JainaPhaseYell or msg:find(L.JainaPhaseYell) then -- Jaina Phase start
		warnJainaPhase:Show()
		timerInsanity:Start()
		insanity = 1
		self:ScheduleMethod(0,"StopTimers")
		DBM.BossHealth:Clear()
		phase = 1
	elseif msg == L.GromPhaseYell or msg:find(L.GromPhaseYell) then -- Grom Phase start
		warnGromPhase:Show()
		self:ScheduleMethod(0,"StopTimers")
		timerNextChaosBlast:Start(20)
		timerMannorothsFury:Start(25)
		self:ScheduleMethod(25,"MannorothsFury")
		DBM.BossHealth:Clear()
		phase = 2
	elseif msg == L.TyrandePhaseYell or msg:find(L.TyrandePhaseYell) then -- Tyrande Phase start
		warnTyrandePhase:Show()
		self:ScheduleMethod(0,"StopTimers")
		DBM.BossHealth:Clear()
		phase = 3
	end
end

function mod:UNIT_DIED(args)
	if  args.destName =="Infinite Manipulator" then
		timerTeleport:Start(5)
		timerArcaneBreath:Start(13)
		self:ScheduleMethod(7,"AddBoss")
		JainaHP = 1
		phase = 0
	end
	if args.destName =="Mannoroth" then
		timerTeleport:Start(5)
		timerArcaneBreath:Start(13)
		self:UnscheduleMethod("MannorothsFury")
		timerNextChaosBlast:Stop()
		timerMannorothsFury:Stop()
		self:ScheduleMethod(7,"AddBoss")
		ThrallHP = 1
		phase = 0
	end
	if args.destName =="Darnassus Sentinel" then
		SentinelsAlive = SentinelsAlive - 1
		if DBM:AntiSpam(1, 2) then
			SentinelAnnounce:Show(SentinelsAlive)
		end
		if SentinelsAlive == 0 then
			timerTeleport:Start(5)
			timerArcaneBreath:Start(13)
			self:ScheduleMethod(7,"AddBoss")
			TyrandeHP = 1
			phase = 0
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 26643 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.80 and prewarn == 0 and DBM:AntiSpam(5,3) then
		prewarn = 1
		warnTransSoon:Show()
	elseif self:GetUnitCreatureId(uId) == 26643 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.55 and prewarn == 1 and DBM:AntiSpam(5,4) then
		prewarn = 2
		warnTransSoon:Show()
	elseif self:GetUnitCreatureId(uId) == 26643 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.30 and prewarn == 2 and DBM:AntiSpam(5,5) then
		prewarn = 3
		warnTransSoon:Show()
	end
end

function mod:AddBoss()
	if JainaHP == 1 then
		DBM.BossHealth:AddBoss(17772,"Lady Jaina Proudmoore")
	elseif TyrandeHP == 1 then
		DBM.BossHealth:AddBoss(17948,"Tyrande Whisperwind")
	elseif ThrallHP == 1 then
		DBM.BossHealth:AddBoss(17852,"Thrall")
	end
end
