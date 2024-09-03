local mod	= DBM:NewMod("Illidan", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22917)
mod:RegisterCombat("combat", 22917)
mod:SetBossHealthInfo(22917, "Illidan Stormrage")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_DIED",
	"SPELL_INTERRUPT",
	"UNIT_HEALTH",
	"UNIT_AURA"
)

-- General
local timerLongRPStart		= mod:NewTimer(39, "Combat starting in ", 560576)
local timerShortRPStart		= mod:NewTimer(3, "Combat starting in ", 560576)
local berserkTimer			= mod:NewBerserkTimer(1200) -- 20 minutes

-- Stage One: You Are Not Prepared
local warnPhase1			= mod:NewAnnounce("Stage One: You Are Not Prepared", 3, 804613)
local warnDrawSoul			= mod:NewSpellAnnounce(2144737)
local warnShear				= mod:NewSpellAnnounce(2144715)
local warnCrash				= mod:NewSpellAnnounce(2144720)
local warnBlade				= mod:NewSpellAnnounce(2144742)
local warnElites			= mod:NewAnnounce("New waves of Illidari Elites", 804613)

local timerShearCD			= mod:NewNextTimer(30, 2144715)
local timerFlameCrash		= mod:NewNextTimer(30, 2144720)
local timerDrawSoul			= mod:NewNextTimer(30, 2144737)
local timerBladeCD			= mod:NewNextTimer(40, 2144742)
local timerElites			= mod:NewTimer(60, "Illidari Elites", 804613)
local timerChainLightning	= mod:NewCastTimer(3, 2144908)
local timerChainLightningCD	= mod:NewCDTimer(9, 2144908)


-- Stage Two: Flames of Azzinoth
local warnPhase2			= mod:NewAnnounce("Stage Two: Flames of Azzinoth", 3, 801892)
--Illidan Stormrage
local warnBarrage			= mod:NewTargetAnnounce(2144811, 3)
local warnEyebeamTarget		= mod:NewAnnounce("Eye Beam on %s!", 3, "Interface\\Icons\\ability_demonhunter_eyebeam")

local specWarnBarrage		= mod:NewSpecialWarning("Shadow Barrage on >YOU!<", 2144811)
local specWarnEyebeam		= mod:NewSpecialWarning("Eyebeam on >YOU!<", 2144766)

local timerNextBarrage		= mod:NewNextTimer(10, 2144811)
local timerBarrage			= mod:NewTargetTimer(10, 2144811)
local timerEyebeam			= mod:NewTargetTimer(20, 2144816)
local timerNextEyebeam		= mod:NewNextTimer(35, 2144816)
local timerLanding			= mod:NewTimer(7, "Illidan is targetable", 560576)

local specWarnChaosBlast	= mod:NewSpecialWarning("Chaos Blast on you", 2144803)
local warnChaosBlast		= mod:NewAnnounce("Chaos Blast on %s", 2144803)
local timerCBcast			= mod:NewCastTimer(2, 2144803)

-- Flame of Azzinoth
local timerFelFireBlast		= mod:NewNextTimer(20, 2144780)

-- Stage Three: The Demon Within
local warnPhase3			= mod:NewAnnounce("Stage Three: The Demon Within", 3, 40506)
local warnParasite			= mod:NewTargetAnnounce(2144749, 3)
local specWarnParasite		= mod:NewSpecialWarning("Parasitic Shadowfiends on >YOU!<", 2144751)
local yellParasiteFades		= mod:NewFadesYell(2144751)
local warnDemonSoon			= mod:NewAnnounce("Demon Within soon", 40506)
local timerNextDemon		= mod:NewTimer(70, "Next Demon Phase", 40506)

local timerNextParasite		= mod:NewNextTimer(40, 2144749)
local timerParasite			= mod:NewTargetTimer(10, 2144751)


-- [Stage Three: The Demon Within] Demon Form

local warnDemonForm			= mod:NewAnnounce("Demon Form", 3, 40506)

local specWarnShadowDemon	= mod:NewSpecialWarning("Switch to Shadow Demons", 2144868)

local timerShadowDemon		= mod:NewNextTimer(20, 2144868)
local timerNextHuman		= mod:NewTimer(60, "Next Human Phase", 560576)
local timerChaosBurst		= mod:NewNextTimer(10, 2144858)

-- Stage Four: The Long Hunt
local warnPhase4			= mod:NewAnnounce("Stage Four: The Long Hunt", 3, 2144934)
local warnTrapped			= mod:NewAnnounce("Illidan is trapped", 3, 5116)
local specWarnTrap			= mod:NewSpecialWarning("Maiev has placed the trap!", 1499)

local timerP4RP				= mod:NewTimer(33, "Enemies to Lovers RP", 2144934)
local timerHatred			= mod:NewNextTimer(20, 2144761)
local timerTrap				= mod:NewTimer(30, "Next Maiev Trap", 1499)
local timerStun				= mod:NewTimer(15, "Illidan is trapped", 5116)

-- Stage Five: Avatar of Hatred
local warnPhase5			= mod:NewAnnounce("Stage Five: Avatar of Hatred", 3, 2145004)
local warnSoulShear			= mod:NewSpellAnnounce(2145040)
local warnHateCrash			= mod:NewSpellAnnounce(2145025)
local warnMadness			= mod:NewSpellAnnounce(2145051)
local warnUnleash			= mod:NewSpellAnnounce(2145061)
local warnStruggle			= mod:NewSpellAnnounce(2145081)
local warnHateBeam			= mod:NewSpellAnnounce(2145074)

local specWarnHatred 		= mod:NewSpecialWarning("Unleash Hatred!", 2145065)

local timerMotes			= mod:NewTimer(5, "Motes of Hatres spawning", 2145072)
local timerP5RP				= mod:NewTimer(49, "Illidan tranformation RP", 2145004)
local timerDyingRP			= mod:NewTimer(23, "Illidan dying RP", 2145004)
local timerSoulShear		= mod:NewNextTimer(35, 2145040)
local timerHateCrash		= mod:NewNextTimer(35, 2145025)
local timerMadness			= mod:NewNextTimer(110, 2145051)
local timerUnleash			= mod:NewNextTimer(110, 2145061)
local timerNextHateBeam		= mod:NewNextTimer(110, 2145074)
local timerHateBeam			= mod:NewTimer(12,"Eye Beam", 2145074)
local timerStruggle			= mod:NewNextTimer(110, 2145081)
local timerStruggling		= mod:NewTimer(10, "Illidan is struggling", 2145081)

local ParasiteTargets = {}

local illidan = false


mod:AddBoolOption(L.ParasiteIcon)

mod.vb.flamesDown = 0
local warned_flame = false
local warned_50demon = false
local warned_10demon = false
local LongPullRP = false
local Name
local bladeCount
local crashCount
local shearCount
local EliteCD = 60
local prepared
local Struggled
local eyebeamTarget
local castEyebeam = false
local castBarrage = false

function mod:warnParasiteTargets()
	warnParasite:Show(table.concat(ParasiteTargets, "<, >"))
	table.wipe(ParasiteTargets)
end

local function humanForms(self)
	self:Unschedule(humanForms)
	timerChaosBurst:Start()
	timerBladeCD:Start(15)
	timerFlameCrash:Start(25)
	timerNextParasite:Start(30)
	timerShearCD:Start(35)
	timerDrawSoul:Start(40)
	timerNextDemon:Start()
end

local function phase4Start(self)
	self:Unschedule(humanForms)
	timerBladeCD:Start(5)
	timerFlameCrash:Start(15)
	timerHatred:Start()
	timerShearCD:Start(25)
	timerDrawSoul:Start(30)
	timerParasite:Start(50)
	timerNextDemon:Start(60)
	timerTrap:Start()
end

local function humanHatredForms(self)
	self:Unschedule(humanForms)
	timerChaosBurst:Start()
	timerBladeCD:Start(15)
	timerFlameCrash:Start(25)
	timerHatred:Start(30)
	timerShearCD:Start(35)
	timerDrawSoul:Start(40)
	timerTrap:Start(30)
	timerParasite:Start(60)
	timerNextDemon:Start()
end

function mod:CancelP5timers()
	timerBladeCD:Cancel()
	timerFlameCrash:Cancel()
	timerParasite:Cancel()
	timerDrawSoul:Cancel()
	timerShearCD:Cancel()
	timerNextDemon:Cancel()
	bladeCount = 0
end

function mod:StartP5timers()
	timerBladeCD:Start(16)
	timerMadness:Start(30)
	timerSoulShear:Start(37)
	timerHateCrash:Start(44)
	timerUnleash:Start(70)
	timerNextHateBeam:Start(77)
	timerStruggle:Start(93)
end

function mod:EyeBeamReset()
	eyebeamTarget = 0
end

function mod:ChaosBlast()
	local targetCB = mod:GetBossTarget(22917)
	if targetCB == UnitName("player") then
		specWarnChaosBlast:Show()
		SendChatMessage("Chaos Blast on "..UnitName("PLAYER").."!", "SAY")
	else
		warnChaosBlast:Show(targetCB)
	end
	timerCBcast:Start(targetCB)
	self:SetIcon(targetCB, 8, 2)
end

local function illidariElites(self)
	self:Unschedule(illidariElites)
	if not EliteCD then EliteCD = 60 end
	timerElites:Start(EliteCD or 60)
	self:Schedule(EliteCD or 60, illidariElites, self)
	warnElites:Show()
	EliteCD = EliteCD - 5
end

local function Prepared(self)
	self:Unschedule(Prepared)
	prepared = true
end

function mod:OnCombatStart(delay)
	illidan = true
	self.vb.phase = 1
	warnPhase1:Show()
	eyebeamTarget = 0
	castEyebeam = false
	castBarrage = false
	warned_50demon = false
	warned_10demon = false
	warned_flame = false
	self.vb.flamesDown = 0
	bladeCount = 0
	shearCount = 0
	crashCount = 0
	EliteCD = 60
	table.wipe(ParasiteTargets)
	if LongPullRP == false or LongPullRP == nil then
		self:Schedule(8, illidariElites, self)
		timerElites:Start(8)
		timerFlameCrash:Start(18)
		timerShearCD:Start(28)
		timerDrawSoul:Start(33)
		timerBladeCD:Start(38)
		self:Schedule(5, Prepared, self)
	end
end

function mod:OnCombatEnd()
	illidan = false
	self:UnregisterAllEvents()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	LongPullRP = false
	prepared = false
	Struggled = false
end

function mod:SPELL_CAST_START(args)
	if illidan == true then
	if args:IsSpellID(2144737, 2144738, 2144739, 2144740) then
		warnDrawSoul:Show()
		timerDrawSoul:Start()
	elseif args:IsSpellID(2144868) then
		specWarnShadowDemon:Show()
	elseif args:IsSpellID(2144715) then -- Shear
		timerShearCD:Start()
		warnShear:Show()
	elseif args:IsSpellID(2144720, 2144721, 2144722, 2144723) then -- Flame Crash
		timerFlameCrash:Start()
		warnCrash:Show()
	elseif args:IsSpellID(2144742, 2145015) then
		if bladeCount >= 1 and self.vb.phase == 3 then
			timerBladeCD:Start()
			warnBlade:Show()
			bladeCount = bladeCount + 1
		elseif bladeCount >= 1 and self.vb.phase == 5 then
			timerBladeCD:Start()
			warnBlade:Show()
			bladeCount = bladeCount + 1
		elseif bladeCount >= 1 and self.vb.phase == 6 then
			warnBlade:Show()
			timerBladeCD:Start(75)
			bladeCount = 0
		elseif bladeCount == 0 and self.vb.phase == 6 then
			timerBladeCD:Start(35)
			warnBlade:Show()
			bladeCount = bladeCount + 1
		else
			timerBladeCD:Start(30)
			warnBlade:Show()
			bladeCount = bladeCount + 1
		end
	elseif args:IsSpellID(2145040) then
		warnSoulShear:Show()
		if shearCount == 0 then
			timerSoulShear:Start()
			shearCount = shearCount + 1
		elseif shearCount == 1 then
			shearCount = 0
			timerSoulShear:Start(75)
		end
	elseif args:IsSpellID(2145022, 2145023, 2145024, 2145025) then
		warnHateCrash:Show()
		if self.vb.phase == 6 and crashCount == 0 then
			timerHateCrash:Start()
			crashCount = crashCount + 1
		elseif self.vb.phase == 6 and crashCount == 1 then
			timerHateCrash:Start(74)
			crashCount = 0
		end
	elseif args:IsSpellID(2145051,2145052) then
		warnMadness:Show()
		timerMadness:Start(110)
	elseif args:IsSpellID(2144908) then
		timerChainLightning:Start(3)
		timerChainLightningCD:Start()
	elseif args:IsSpellID(2145074) then
		warnHateBeam:Show()
		timerHateBeam:Start()
		timerNextHateBeam:Start()
	elseif args:IsSpellID(2144816) then
		castEyebeam = true
	elseif args:IsSpellID(2144803) then
		self:ScheduleMethod(0.15,"ChaosBlast")
	end
end
end


function mod:SPELL_INTERRUPT(args)
	if illidan == true then
	if args:IsSpellID(2144908) then
		timerChainLightning:Cancel()
	end
end
end


function mod:SPELL_AURA_APPLIED(args)
	if illidan == true then
	if args:IsSpellID(2144751, 2144752, 2144753, 2144754, 2144755) then
		timerParasite:Start(args.destName)
		if args:IsPlayer() then
			specWarnParasite:Show()
			yellParasiteFades:Countdown(10, 3)
		end
		self:UnscheduleMethod("warnParasiteTargets")
		ParasiteTargets[#ParasiteTargets + 1] = args.destName
		self:ScheduleMethod(0.3, "warnParasiteTargets")
		if self.Options.ParasiteIcon then
			if DBM:AntiSpam(10) then self:SetIcon(args.destName, 7)
			elseif DBM:AntiSpam(10) then self:SetIcon(args.destName, 6)
			elseif DBM:AntiSpam(10) then self:SetIcon(args.destName, 5)
			elseif DBM:AntiSpam(10) then self:SetIcon(args.destName, 4)
			elseif DBM:AntiSpam(10) then self:SetIcon(args.destName, 3) 
			end
		end
		timerNextParasite:Start()
	end
	if args:IsSpellID(2144810) then
		if args.destName == args:IsPlayer() then
			specWarnBarrage:Show()
			SendChatMessage("Dark Barrage on "..UnitName("PLAYER").."!", "SAY")
		else
			warnBarrage:Show(args.destName)
		end
		self:SetIcon(args.destName, 7, 2)
		timerBarrage:Start(args.destName)
		castBarrage = true
	end
	if args:IsSpellID(2145061) and args.destName == "Illidan Stormrage" then
		timerUnleash:Start(110)
		timerMotes:Start(5)
		warnUnleash:Show()
	end
end
end

function mod:SPELL_AURA_REMOVED(args)
	if illidan == true then
	if args:IsSpellID(2144751, 2144752, 2144753, 2144754, 2144755) then
		timerParasite:Stop(args.destName)
	elseif args:IsSpellID(2144816) then
		castEyebeam = false
	elseif args:IsSpellID(2144810) then
		castBarrage = false
	end
end
end

function mod:UNIT_DIED(args)
	if illidan == true then
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 22997 then
		self.vb.flamesDown = self.vb.flamesDown + 1
		if self.vb.flamesDown >= 2 then
			self.vb.phase = 3
			warnPhase3:Show()
			bladeCount = 0
			if castEyebeam == true then
				local eyebeamTime = timerEyebeam:GetTime();
				timerLanding:Start(eyebeamTime+7)
				timerBladeCD:Start(eyebeamTime+10)
				timerFlameCrash:Start(eyebeamTime+18)
				timerNextParasite:Start(eyebeamTime+23)
				timerShearCD:Start(eyebeamTime+28)
				timerDrawSoul:Start(eyebeamTime+33)
				timerNextDemon:Start(eyebeamTime+67)
			elseif castBarrage == true then
				local barrageTime = timerBarrage:GetTime();
				timerLanding:Start(barrageTime+7)
				timerBladeCD:Start(barrageTime+10)
				timerFlameCrash:Start(barrageTime+18)
				timerNextParasite:Start(barrageTime+23)
				timerShearCD:Start(barrageTime+28)
				timerDrawSoul:Start(barrageTime+33)
				timerNextDemon:Start(barrageTime+67)
			else
				timerLanding:Start(7)
				timerBladeCD:Start(10)
				timerFlameCrash:Start(18)
				timerNextParasite:Start(23)
				timerShearCD:Start(28)
				timerDrawSoul:Start(33)
				timerNextDemon:Start(67)
			end
		end
	end
	if args.destName == Name then
		eyebeamTarget = 0
	end
end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.Pull or msg:find(L.Pull) then
		timerLongRPStart:Start()
		LongPullRP = true
		self:Schedule(18, illidariElites, self)
		timerElites:Start(44)
		timerFlameCrash:Start(54)
		timerShearCD:Start(64)
		timerDrawSoul:Start(69)
		timerBladeCD:Start(74)
		self:Schedule(5, Prepared, self)
	elseif msg == L.RealPull or msg:find(L.RealPull) and prepared == false or nil then
		timerShortRPStart:Start()
	elseif msg == L.Demon or msg:find(L.Demon) then
		warnDemonForm:Show()
		timerBladeCD:Cancel()
		timerFlameCrash:Cancel()
		timerParasite:Cancel()
		timerDrawSoul:Cancel()
		timerShearCD:Cancel()
		bladeCount = 0
	elseif msg == L.DemonWithinQuote or msg:find(L.DemonWithinQuote) then
		timerNextHuman:Start()
		timerChaosBurst:Start(10)
		timerShadowDemon:Start(30)
		if self.vb.phase == 3 then
			self:Schedule(60, humanForms, self)
		elseif self.vb.phase == 5 then
			self:Schedule(60, humanHatredForms, self)
		end
	elseif msg == L.Phase4 or msg:find(L.Phase4) then
		self.vb.phase = 4
		bladeCount = 0
		self:Unschedule(humanForms)
		timerBladeCD:Cancel()
		timerFlameCrash:Cancel()
		timerShearCD:Cancel()
		timerDrawSoul:Cancel()
		timerNextParasite:Cancel()
		timerNextHuman:Cancel()
		timerNextDemon:Cancel()
		timerP4RP:Start()
		warnPhase4:Schedule(33)
		self:Schedule(33, phase4Start, self)
	elseif msg == L.MaievTrap or msg:find(L.MaievTrap) then
		specWarnTrap:Show()
	elseif msg == L.Trapped1 or msg == L.Trapped2 or msg == L.Trapped3 then
		timerStun:Start()
		warnTrapped:Show()
	elseif msg == L.Phase5 or msg:find(L.Phase5) then
		if mod:IsDifficulty("heroic25") then
			self.vb.phase = 5
			warnPhase5:Schedule(46)
			timerP5RP:Start()
			self:ScheduleMethod(0,"CancelP5timers")
			self:ScheduleMethod(49, "StartP5timers")
		else
			timerDyingRP:Start()
		end
	end
end


function mod:UNIT_HEALTH(uId)
	if illidan == true then
	local cid = self:GetUnitCreatureId(uId)
	if warned_50demon == false and cid == 22917 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.55 then
		warned_50demon = true
		warnDemonSoon:Show()
	elseif warned_10demon == false and cid == 22917 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.15 then
		warned_10demon = true
		warnDemonSoon:Show()
	elseif warned_flame == false and cid == 22917 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.7 then
		warned_flame = true
		warnPhase2:Show()
		self.vb.phase = 2
		self:Unschedule(illidariElites)
		timerBladeCD:Cancel()
		timerFlameCrash:Cancel()
		timerShearCD:Cancel()
		timerDrawSoul:Cancel()
		timerElites:Cancel()
	end
end
end

function mod:UNIT_AURA(unit)
if illidan == true then
	if self.vb.phase == 2 and eyebeamTarget == 0 and UnitDebuff(unit, "Betrayer's Gaze") and DBM:AntiSpam(35) then
		eyebeamTarget = 1
		Name = UnitName(unit)
		if Name == UnitName("player") then
			specWarnEyebeam:Show()
			SendChatMessage("Eye Beam on "..UnitName("PLAYER").."!", "SAY")
		else
			warnEyebeamTarget:Show(Name)
 		end
		 timerEyebeam:Start(Name)
		self:SetIcon(Name, 6, 10)
		self:ScheduleMethod(10,"EyeBeamReset")
	end
	if UnitDebuff("Boss", "Struggle for Control") and DBM:AntiSpam(105, 3) then
		warnStruggle:Show()
		timerStruggling:Start()
		timerStruggle:Start()
		Struggled = true
	end
end
end