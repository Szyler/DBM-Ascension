local mod	= DBM:NewMod("Archimonde", "DBM-Hyjal")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(17968,26648,26647)
mod:SetUsedIcons(8)
mod:RegisterCombat("combat")
mod:SetBossHealthInfo(
	17968, "Archimonde",
	26648, "Narmak",
	26647, "Haaroon"
)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED",
	"UNIT_HEALTH"
)
-- -------------- RP -------------------
local timerCombatStart			= mod:NewTimer(23, "Combat starting in ", 800462)

--Haaroon & Narmak
local timerShockwave			= mod:NewTimer(25, "Haaroon casting 3 Shockwaves", 2141567)
local timerCastsShockwave		= mod:NewCastTimer(3, 2141567)
local warnShockwave				= mod:NewSpellAnnounce(2141567, 3)
local timerFelBombs				= mod:NewTimer(25, "Narmak throwing 4 Fel Bombs", 2141553)
local timerFelExplosionSoon		= mod:NewTimer(10, "Fel Bombs exploding soon", 2141553)
local timerFelExplosion			= mod:NewTimer(4, "Fel Bombs exploding", 2141553)
local warnFelBombs				= mod:NewSpellAnnounce(2141553, 3)

------------ Archimonde ----------------
-- Transitions
local warnAddPhase				= mod:NewAnnounce("Kill Narmak and Haaroon to engage Archimonde", 3, 10066)
local warnFirePhase				= mod:NewAnnounce("Fire Phase incoming!", 3, 76325)
local warnLightningPhaseSoon	= mod:NewAnnounce("Lightning Phase at 70 percent health!", 3, 2141471)
local warnLightningPhase		= mod:NewAnnounce("Lightning Phase incoming!", 3, 2141471)
local timerCallLightning		= mod:NewCastTimer(4, 2141471)
local warnVoidPhaseSoon			= mod:NewAnnounce("Void Phase at 40 percent health!", 3, 2141480)
local warnVoidPhase				= mod:NewAnnounce("Void Phase incoming!", 3, 2141480)

-- All fight
local timerNextForceofWill		= mod:NewNextTimer(45, 2141400)
local warnSpecialForceofWill	= mod:NewSpecialWarning("Force of Will", 2141400)
local warnForceofWillSoon		= mod:NewAnnounce("Force of Will in 5 seconds", 2141400)
local timerForceofWill			= mod:NewCastTimer(2, 2141400)
local warnCurseoftheDefiler		= mod:NewSpellAnnounce(2141422)
local timerCurseoftheDefiler	= mod:NewNextTimer(30, 2141422)
local specWarnWeakCurse			= mod:NewSpecialWarning("Curse of the Defiler is weakened. Decurse now!", 2141428)
local warnDecurseJaina			= mod:NewAnnounce("Decurse Jaina now!", 2141428)
local warnDecurseTyrande		= mod:NewAnnounce("Decurse Tyrande now!",2141428)
local warnDecurseThrall			= mod:NewAnnounce("Decurse Thrall now!", 2141428)

--Fire Phase
local timerNextDoomMeteor		= mod:NewNextTimer(45, 2141405)
local timerCastDoomMeteor		= mod:NewCastTimer(6, 2141405)
local warnDoomMeteor			= mod:NewSpellAnnounce(2141405)
local timerDrawFlames			= mod:NewNextTimer(55, 2141442)
local warnDrawFlames			= mod:NewSpellAnnounce(2141442)

--Lightning Phase
local timerLightningStrikes		= mod:NewTimer(10, "Lightning Strikes", 2141456)
local warnLightningStrikes		= mod:NewSpecialWarning("Lightning Strikes Soon!", 2141456)
local timerLivingLightning		= mod:NewNextTimer(45,2141462)
local warnLivingLightning		= mod:NewAnnounce("Archimonde is summoning Living Lightning!", 2141462, 2)

-- Void Phase
local warnGoT					= mod:NewSpellAnnounce(2141604, 3)
local timerNextGoT				= mod:NewNextTimer(60, 2141604)
local timerCastGoT				= mod:NewCastTimer(3, 2141604)
local timerVoidHerald			= mod:NewTimer(20, "Void Herald incoming", 5108)
local timerVoidTendril			= mod:NewTimer(20, "Void Tendrils spawning", 2117107)

-- Jaina
local warnWardWinter			= mod:NewAnnounce("Ward of Winter on %s!", 2140155)
local warnSpecWardsofWinter		= mod:NewSpecialWarning("Ward of Winter on you!", 2140155)
local timerWardWinter			= mod:NewTargetTimer(15, 2140155)
local timerNextWardWinter		= mod:NewNextTimer(45, 2140155)

-- Thrall
local warnTotemofLightning		= mod:NewAnnounce("A Lightning Capture Totem is up for 15 seconds!", 2140264)
local timerTotemofLightning		= mod:NewTimer(30, "Lightning Capture Totem duration", 2140264)
local timerNextTotemofLightning	= mod:NewNextTimer(45, 2140264)

--Tyrande
local warnLightofElune			= mod:NewAnnounce("Light of Elune on %s!",2140073)
local timerLightofElune			= mod:NewNextTimer(50, 2140073)
local warnSpecLightofElune		= mod:NewSpecialWarning("Light of Elune on you!", 2140073)

-- fight
local berserkTimer				= mod:NewBerserkTimer(900)
local prewarn
local phase
local terror
local lastDoomfire
local remainingDoomfire
local lastForce
local remainingForce
local drawFlames

function mod:OnCombatStart(delay)
prewarn 		= 0
phase 			= 0
terror 			= 0
lastDoomfire 	= 0
lastForce 		= 0
drawFlames		= 0
end

function mod:AddPhase()
	warnAddPhase:Show()
	timerFelBombs:Start(8)
	timerShockwave:Start(12)
end

function mod:FirePhase()
	phase = 1
	berserkTimer:Start()
	warnFirePhase:Show()
	timerNextDoomMeteor:Start(10)
	warnForceofWillSoon:Schedule(25)
	timerNextForceofWill:Start(30)

	if mod:IsDifficulty("heroic10", "heroic25") then
		timerNextWardWinter:Start(180)
	else
		timerNextWardWinter:Start(50)
	end
end

function mod:LightningPhase()
	phase = 2
	warnLightningPhase:Show()
	timerCallLightning:Start()
	warnForceofWillSoon:Schedule(33)
	timerNextForceofWill:Start(38)
	timerTotemofLightning:Start(28)
	timerLightningStrikes:Start(16)
	warnLightningStrikes:Schedule(14)
	self:ScheduleMethod(15,"LightningStrikes")
end

function mod:VoidPhase()
	phase = 3
	warnVoidPhase:Show()
	warnForceofWillSoon:Schedule(33)
	timerForceofWill:Start(38)
	timerNextGoT:Start(3)
	timerVoidTendril:Start(23)
	warnLightningStrikes:Schedule(10)
	timerLightningStrikes:Start(12)
	self:ScheduleMethod(12,"LightningStrikes")
end

function mod:CancelP0Timers()
	timerFelBombs:Stop()
	timerShockwave:Stop()
end

function mod:CancelP1Timers()
	timerNextDoomMeteor:Stop()
	timerNextForceofWill:Stop()
	warnForceofWillSoon:Cancel()
end

function mod:CancelP2Timers()
	self:UnscheduleMethod("LightningStrikes")
	timerLightningStrikes:Stop()
	warnLightningStrikes:Cancel()
	timerNextForceofWill:Stop()
	warnForceofWillSoon:Cancel()
	timerLivingLightning:Stop()
end

function mod:LightningStrikes()
	self:UnscheduleMethod("LightningStrikes")
	timerLightningStrikes:Start()
	warnLightningStrikes:Schedule(8)
	self:ScheduleMethod(10,"LightningStrikes")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2141428) and args:IsPlayer() then -- Grasp of the Defiler is Weakened
		specWarnWeakCurse:Show()
	end
	if args:IsSpellID(2141428) and args.destName == "Lady Jaina Proudmoore" then
		warnDecurseJaina:Show()
	elseif args:IsSpellID(2141428) and args.destName == "Tyrande Whisperwind" then
		warnDecurseTyrande:Show()
	elseif args:IsSpellID(2141428) and args.destName == "Thrall" then
		warnDecurseThrall:Show()
	end
	if args:IsSpellID(2141422,2141423,2141424,2141425) and args:IsPlayer() then -- Curse of the Defiler
		warnCurseoftheDefiler:Show()
	end
	if args:IsSpellID(2140155) then
		if args:IsPlayer() then
			warnSpecWardsofWinter:Show()
		else
			warnWardWinter:Show(args.destName)
		end
		self:SetIcon(args.destName, 4, 15)
		timerWardWinter:Start(args.destName)
		timerNextWardWinter:Start()
	end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(2141422,2141423,2141424,2141425) and args:IsPlayer() then -- Curse of the Defiler
		warnCurseoftheDefiler:Show(args.amount)
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2141455,2141456,2141457,2141458) and DBM:AntiSpam(6,5) then
		self:UnscheduleMethod("LightningStrikes")
		warnLightningStrikes:Cancel()
		self:ScheduleMethod(0,"LightningStrikes")
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2141553) and DBM:AntiSpam(5,3) then -- Fel Iron Bombs
		warnFelBombs:Show()
		timerFelBombs:Start()
		timerFelExplosionSoon:Start(11)
		timerFelExplosion:Schedule(11)
	elseif args:IsSpellID(2141567) and DBM:AntiSpam(5,4) then -- Shockwave
		warnShockwave:Show()
		timerShockwave:Start()
		timerCastsShockwave:Start()
	elseif args:IsSpellID(2141405) then -- Doomfire Meteor
		warnDoomMeteor:Show()
		timerCastDoomMeteor:Start()
		timerNextDoomMeteor:Start()
		lastDoomfire = GetTime()
	elseif args:IsSpellID(2141400) then -- Force of Will
		warnSpecialForceofWill:Show()
		warnForceofWillSoon:Schedule(40)
		timerForceofWill:Start()
		timerNextForceofWill:Start()
		lastForce = GetTime()
	elseif args:IsSpellID(2141519) then -- Call Lightning
		self:ScheduleMethod(0, "CancelP1Timers")
		self:ScheduleMethod(0, "LightningPhase")
	elseif args:IsSpellID(2141604) then -- Glimpse of Tomorrow
		warnGoT:Show()
		timerCastGoT:Start()
		if terror == 1 then
			timerNextGoT:Start(60)
		elseif terror == 0 then
			terror = 1
			timerNextGoT:Start(15)
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2141442) then -- Draw Flames
		warnDrawFlames:Show()
		if drawFlames == 1 then
			timerNextDoomMeteor:Start()
		elseif drawFlames == 2 then
			timerNextForceofWill:Start()
		end
	elseif args:IsSpellID(2141473) then -- Summon Living Lightning
		warnLivingLightning:Show()
		timerLivingLightning:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.FightStartYell or msg:find(L.FightStartYell) then -- Archimonde
		timerCombatStart:Start()
		self:ScheduleMethod(23,"AddPhase")
	end
	if msg == L.FirePhase or msg:find(L.FirePhase) then --Archimonde
		self:ScheduleMethod(0,"CancelP0Timers")
		self:ScheduleMethod(0,"FirePhase")
	end
	if msg == L.LightningCapTotem or msg:find(L.LightningCapTotem) then --Thrall
		warnTotemofLightning:Show()
		timerTotemofLightning:Start()
		timerNextTotemofLightning:Start()
	end
	if msg == L.LightofElune or msg:find(L.LightofElune) then -- Tyrande
		local lightofElune = msg:find(L.LightofElune)
		if lightofElune == UnitName("Player") then
			warnSpecLightofElune:Show()
		else
			warnLightofElune:Show(lightofElune)
		end
		self:SetIcon(lightofElune, 3, 50)
		timerLightofElune:Start()
	end
	if msg == L.CalloftheVoid or msg:find(L.CalloftheVoid) then --Archimonde Void Phase
		self:ScheduleMethod(0, "CancelP2Timers")
		self:ScheduleMethod(0,"VoidPhase")
	end
--	if msg == L.VoidSpawn or msg:find(L.VoidSpawn) then -- Archimonde Void Spawn
	--end
end

function mod:UNIT_HEALTH(uId)
	if self:GetUnitCreatureId(uId) == 17968 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.85 and prewarn == 0 and DBM:AntiSpam(5,2) then
		prewarn = 1
		remainingDoomfire = 45 - (GetTime() - lastDoomfire)
		remainingForce = 45 - (GetTime() - lastForce)
		if  remainingDoomfire < remainingForce then
			timerNextDoomMeteor:Cancel()
			timerDrawFlames:Start(remainingDoomfire)
			drawFlames = 1
		else
			timerNextForceofWill:Cancel()
			timerDrawFlames:Start(remainingForce)
			drawFlames = 2
		end
	end
	if self:GetUnitCreatureId(uId) == 17968 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.75 and prewarn == 1 and DBM:AntiSpam(5,2) then
		prewarn = 2
		warnLightningPhaseSoon:Show()
	elseif self:GetUnitCreatureId(uId) == 17968 and (UnitHealth(uId) / UnitHealthMax(uId)) <= 0.45 and prewarn == 2 and DBM:AntiSpam(5,3) then
		prewarn = 3
		warnVoidPhaseSoon:Show()
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 26647 then
		timerShockwave:Stop()
	elseif cid == 26648 then
		timerFelBombs:Stop()
	end
end

function mod:CombatEnd()
	self:ScheduleMethod("CancelP0Timers")
	self:ScheduleMethod("CancelP1Timers")
	self:ScheduleMethod("CancelP2Timers")
end