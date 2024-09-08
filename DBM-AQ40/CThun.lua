local mod	= DBM:NewMod("CThun", "DBM-AQ40", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(15727, 15589)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_SUMMON",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_DIED",
	"PLAYER_ALIVE",
	"SPELL_PERIODIC_DAMAGE",
	"SPELL_PERIODIC_HEAL",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_APPLIED_DOSE",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
)



----------Pre-warnings----------
local prewarnEyeTentacleShadow		= mod:NewAnnounce("Eye Tentacles: Shadow Soon", 3, 4500000)
local prewarnEyeTentacleFire		= mod:NewAnnounce("Eye Tentacles: Fire Soon", 3, 4500054)
local prewarnEyeTentacleNature		= mod:NewAnnounce("Eye Tentacles: Nature Soon", 3, 4500061)
local prewarnLookAway				= mod:NewAnnounce("Look Away Soon", 3, 4500009)
local prewarnDarkGlare				= mod:NewAnnounce("Dark Glare Soon", 3, 26029)
local prewarnManipulator			= mod:NewAnnounce("Manipulator Tentacle Soon", 3, 4500067)
local prewarnDevastator				= mod:NewAnnounce("Devastator Tentacle Soon", 3, 4500007)
local prewarnMalignant				= mod:NewAnnounce("Malignant Tentacle Soon", 3, 4500053)
local prewarnGiantEye				= mod:NewAnnounce("Giant Eye Tentacle Soon", 3, 4500060)
local prewarnGiantClaw				= mod:NewAnnounce("Giant Claw Tentacle Soon", 3, 6524)
local prewarnStomach				= mod:NewAnnounce("Stomach Phase Soon", 3, 26476)
----------Warnings----------
local warnEyeTentacleShadow			= mod:NewAnnounce("Eye Tentacles Spawned: Shadow", 2, 4500000)
local warnEyeTentacleFire			= mod:NewAnnounce("Eye Tentacles Spawned: Fire", 2, 4500054)
local warnEyeTentacleNature			= mod:NewAnnounce("Eye Tentacles Spawned: Nature", 2, 4500061)
local warnDarkGlare					= mod:NewTargetAnnounce(26029, 4)
local warnEldritch					= mod:NewSpellAnnounce(4500009, 4)
local warnManipulator				= mod:NewAnnounce("Manipulator Tentacle Spawned", 2, 4500067)
local warnDevastator				= mod:NewAnnounce("Devastator Tentacle Spawned", 2, 4500007)
local warnMalignant					= mod:NewAnnounce("Malignant Tentacle Spawned", 2, 4500053)
local warnGiantEyeTentacle			= mod:NewAnnounce("Giant Eye Tentacle Spawned", 2, 4500060)
local warnGiantClawTentacle			= mod:NewAnnounce("Giant Claw Tentacle Spawned", 2, 6524)
local warnWeakened					= mod:NewAnnounce("C'thun is Weakened!", 4, 25383)
local warnStomach					= mod:NewAnnounce("Stomach Phase Now", 2, 26476)
local warnPhase2					= mod:NewPhaseAnnounce(2)
local warnLesserEldritch			= mod:NewSpellAnnounce(2117084, 4)
local specWarnLesserEldritch		= mod:NewSpecialWarningYou(2117084, 4)
local SpecWarnDevSmash				= mod:NewSpecialWarning("Devastating Smash!",2117076, 4)

----------Timers----------
local timerDarkGlareCD				= mod:NewCDTimer(89, 26029)
local timerDarkGlare				= mod:NewTimer(33, "Dark Glare: Time Remaining", 26029)
local timerEldritch					= mod:NewTimer(5, "LOOK AWAY", 4500009)
local timerEldritchCD				= mod:NewCDTimer(30, 4500009)
local timerEyeTentacleShadow		= mod:NewTimer(45, "Eye Tentacles: Shadow", 4500000)
local timerEyeTentacleFire			= mod:NewTimer(45, "Eye Tentacles: Fire", 4500054)
local timerEyeTentacleNature		= mod:NewTimer(45, "Eye Tentacles: Nature", 4500061)
local timerStomach					= mod:NewTimer(41, "Enter Stomach", 26476)
local timerGiantEyeTentacle			= mod:NewTimer(44, "Giant Eye Tentacle", 4500060)
local timerGiantClawTentacle 		= mod:NewTimer(14, "Giant Claw Tentacle", 6524)
local timerWeakened					= mod:NewTimer(30, "Weakened: Time Remaining", 25383)
local timerManipulator				= mod:NewTimer(15, "Manipulator Tentacle", 4500067)
local timerDevastator				= mod:NewTimer(15, "Devastator Tentacle", 4500007)
local timerMalignant				= mod:NewTimer(15, "Malignant Tentacle", 4500053)
local timerLesserEldritch			= mod:NewCastTimer(3, 2117084)
local timerNextEyeTent				= mod:NewTimer(45, "Next Eye Tentacle", 4500000)
local timerIntoStomach				= mod:NewTimer(10, "From Beneath You it Devours", 2117117)

----------Misc----------
mod:AddBoolOption("RangeFrame", true)
local etent
local lasttent
local phase
local miniadd
local eldfixglare

----------JuniorStuff----------
local specWarnEradicate		= mod:NewSpecialWarning("Eradicate damage too high!", nil, "Special warning when taking >1000 damage from Eradicate", true) -- 4500054
local specWarnConsume		= mod:NewSpecialWarning("Consume healing too high!", nil, "Special warning when healing >4000 from Consume Essence", true) -- 4500061
local specWarnMiasma		= mod:NewSpecialWarningMove(4500001, true, "Special warning when standing in Miasma", true)
local warnMalignantGrasp	= mod:NewAnnounce("%s Grabbed!", 4, nil, nil, "Announce when someone within 28 yards is grabbed by a Malignant Tentacle")
local specWarnRevelations	= mod:NewSpecialWarning("Look Away", nil, "Special warning for Eldritch Revelations cast") --4500009)
local specWarnSensoryOverload	= mod:NewSpecialWarningYou(4500068)
local specWarnDigestiveAcid	= mod:NewSpecialWarningStack(26476, nil, 4) --(mod.Options.NumAcidStacks or 4))
local SpecwarnStomach 		= mod:NewSpecialWarningYou(2117117, 4)
----------PreWarning Functions----------
function mod:preShadow()
	prewarnEyeTentacleShadow:Show()
end
function mod:preFire()
	prewarnEyeTentacleFire:Show()
end
function mod:preNature()
	prewarnEyeTentacleNature:Show()
end
function mod:preStomach()
	prewarnStomach:Show()
end
function mod:preGiantClaw()
	prewarnGiantClaw:Show()
end
function mod:preGiantEye()
	prewarnGiantEye:Show()
end
function mod:preGlare()
	prewarnDarkGlare:Show()
end
function mod:preFear()
	if phase == 1 then
		prewarnLookAway:Show()
	end
end
function mod:preManipulator()
	prewarnManipulator:Show()
end
function mod:preDevastator()
	prewarnDevastator:Show()
end
function mod:preMalignant()
	prewarnMalignant:Show()
end

----------Alert Functions----------
function mod:LesserEldritch()
	local target = nil
	target = mod:GetBossTarget(15334)
	local myName = UnitName("player")
	if target == myName then
		specWarnLesserEldritch:Show()
		SendChatMessage("Lesser Eldritch on "..UnitName("PLAYER").."!", "Say")
	else
		warnLesserEldritch:Show(target)
	end
	timerLesserEldritch:Start(target)
end

function mod:alertShadow()
	warnEyeTentacleShadow:Show()
	etent = 2
	lasttent = 1
end
function mod:alertFire()
	warnEyeTentacleFire:Show()
	etent = 3
	lasttent = 2
end
function mod:alertNature()
	warnEyeTentacleNature:Show()
	etent = 1
	lasttent = 3
end
function mod:alertStomach()
	warnStomach:Show()
end
function mod:alertGiantClaw()
	warnGiantClawTentacle:Show()
end
function mod:alertGiantEye()
	warnGiantEyeTentacle:Show()
end
function mod:alertGlare()
	warnDarkGlare:Show()
end
function mod:alertFear()
	if phase == 1 then
		warnEldritch:Show()
	end
end
function mod:alertManipulator()
	warnManipulator:Show()
end
function mod:alertDevastator()
	warnDevastator:Show()
end
function mod:alertMalignant()
	warnMalignant:Show()
end

----------Real Functions----------

function mod:OnCombatStart(delay)
	phase = 1 
	self.vb.phase = 1
	etent = 0
	lasttent = 0
	miniadd = 1
	eldfixglare = 1
	timerNextEyeTent:Start(45)
	self:ScheduleMethod(0-delay, "eldFearInitial")
	self:ScheduleMethod(0-delay, "darkGlareInitial")
	self:ScheduleMethod(48-delay, "firstEyeTentacle")
	
--	self:ScheduleMethod(0-delay, "miniAddInitial")
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(13)
	end
end

--function mod:miniAddInitial()
--	local timer14 = 10
--	timerDevastator:Start(timer14)
--	miniadd = 2
--	self:ScheduleMethod(timer14-5, "warnDevastator")
--	self:ScheduleMethod(timer14, "alertDevastator")
--	self:ScheduleMethod(timer14, "miniAdd")
--end

--function mod:miniAdd()
--	local timer15 = 15
--end

function mod:firstEyeTentacle()
	local timer0 = 43
	if etent == 1 then
		timerEyeTentacleShadow:Start(42)
		self:ScheduleMethod(39, "preShadow")
		self:ScheduleMethod(42, "alertShadow")
		etent = 2
		lasttent = 3
	elseif etent == 2 then
		timerEyeTentacleFire:Start(42)
		self:ScheduleMethod(39, "preFire")
		self:ScheduleMethod(42, "alertFire")
		etent = 3
		lasttent = 1
	elseif etent == 3 then
		timerEyeTentacleNature:Start(42)
		self:ScheduleMethod(39, "preNature")
		self:ScheduleMethod(42, "alertNature")
		etent = 1
		lasttent = 2
	elseif etent == 0 then
		timerNextEyeTent:Start(42)
	end
	self:ScheduleMethod(42, "eyeTentacle")
end

function mod:eyeTentacle()
	local timer1 = 44
	if etent == 1 then
		timerEyeTentacleShadow:Start(44.5)
		self:ScheduleMethod(40, "preShadow")
		self:ScheduleMethod(44.5, "alertShadow")
	elseif etent == 2 then
		timerEyeTentacleFire:Start(44.5)
		self:ScheduleMethod(40, "preFire")
		self:ScheduleMethod(44.5, "alertFire")
	elseif etent == 3 then
		timerEyeTentacleNature:Start(44.5)
		self:ScheduleMethod(40, "preNature")
		self:ScheduleMethod(44.5, "alertNature")
	elseif etent == 0 then
		timerNextEyeTent:Start(44.5)
	end
	self:ScheduleMethod(45, "eyeTentacle")
end

function mod:p2eyeTentacle()
	local timer2 = 15
	if etent == 1 then
		timerEyeTentacleShadow:Start(15)
		self:ScheduleMethod(11, "preShadow")
		self:ScheduleMethod(15, "alertShadow")
	elseif etent == 2 then
		timerEyeTentacleFire:Start(15)
		self:ScheduleMethod(11, "preFire")
		self:ScheduleMethod(15, "alertFire")
	elseif etent == 3 then
		timerEyeTentacleNature:Start(15)
		self:ScheduleMethod(11, "preNature")
		self:ScheduleMethod(15, "alertNature")
	elseif etent == 0 then
		timerNextEyeTent:Start(15)
	end
	self:ScheduleMethod(16, "eyeTentacle")
end

function mod:darkGlareInitial()
	timerDarkGlareCD:Start(55)
	self:ScheduleMethod(50, "preGlare")
	self:ScheduleMethod(55, "darkGlare")
end

function mod:darkGlare()
	timerDarkGlareCD:Start(89)
	self:ScheduleMethod(84, "preGlare")
	self:ScheduleMethod(89, "alertGlare")
	self:ScheduleMethod(89,"darkGlare")
end

function mod:eldFearInitial()
	if phase == 1 then
		local timer13 = 30
		timerEldritchCD:Start(timer13)
		self:ScheduleMethod(timer13-5, "preFear")
		self:ScheduleMethod(timer13, "alertFear")
	end
end

function mod:eldFear()
	if phase == 1 then
		local timer12 = 30
		if eldfixglare == 1 then 
			timerEldritch:Start()
		elseif eldfixglare == 2 then
			self:ScheduleMethod(timer12-5, "eldFearGlareFix")
		end
		timerEldritchCD:Start(30)
		self:ScheduleMethod(25, "preFear")
		self:ScheduleMethod(30, "alertFear")
	end
end

function mod:eldFearGlareFix()
	eldfixglare = 1
end

function mod:enterStomach()
	self:UnscheduleMethod("enterStomach")
	timerStomach:Start(41)
	self:ScheduleMethod(41, "enterStomach")
end

function mod:clawTentacleInitial()
	local timer3 = 14
	timerGiantClawTentacle:Start(timer3)
	self:ScheduleMethod(timer3-5, "preGiantClaw")
	self:ScheduleMethod(timer3, "alertGiantClaw")
	self:ScheduleMethod(timer3, "clawTentacle")
end

function mod:clawTentacleWeaknessFix()
	local timer5 = 10
	timerGiantClawTentacle:Start(timer5)
	self:ScheduleMethod(timer5-5, "preGiantClaw")
	self:ScheduleMethod(timer5, "alertGiantClaw")
	self:ScheduleMethod(timer5, "clawTentacle")
end

function mod:clawTentacle()
	local timer6 = 60
	timerGiantClawTentacle:Start(timer6)
	self:ScheduleMethod(timer6-5, "preGiantClaw")
	self:ScheduleMethod(timer6, "alertGiantClaw")
	self:ScheduleMethod(timer6, "clawTentacle")
end

function mod:geyeTentacleInitial()
	local timer7 = 44
	timerGiantEyeTentacle:Start(timer7)
	self:ScheduleMethod(timer7-5, "preGiantEye")
	self:ScheduleMethod(timer7, "alertGiantEye")
	self:ScheduleMethod(timer7, "geyeTentacle")
end

function mod:geyeTentacleWeaknessFix()
	local timer8 = 40
	timerGiantEyeTentacle:Start(timer8)
	self:ScheduleMethod(timer8-5, "preGiantEye")
	self:ScheduleMethod(timer8, "alertGiantEye")
	self:ScheduleMethod(timer8, "geyeTentacle")
end

function mod:geyeTentacle()
	local timer9 = 60
	timerGiantEyeTentacle:Start(timer9)
	self:ScheduleMethod(timer9-5, "preGiantEye")
	self:ScheduleMethod(timer9, "alertGiantEye")
	self:ScheduleMethod(timer9, "geyeTentacle")
end

function mod:fixWeaknessTimers()
	self:UnscheduleMethod("eyeTentacle")
	self:UnscheduleMethod("clawTentacle")
	self:UnscheduleMethod("geyeTentacle")
	self:UnscheduleMethod("preShadow")
	self:UnscheduleMethod("preFire")
	self:UnscheduleMethod("preNature")
	self:ScheduleMethod(0, "clawTentacleWeaknessFix")
	self:ScheduleMethod(0, "geyeTentacleWeaknessFix")
	timerStomach:Start(15)
	self:ScheduleMethod(15, "enterStomach")
	self:ScheduleMethod(0, "p2eyeTentacle")
end

function mod:phaseTwo()
	warnPhase2:Show()
	self.vb.phase = 2
	if lasttent == 1 then
		etent = 2
	elseif lasttent == 2 then
		etent = 3
	elseif lasttent == 3 then
		etent = 1
	end
	timerStomach:Start(20)
	self:ScheduleMethod(6, "eyeTentacle")
	self:ScheduleMethod(20, "enterStomach")
	self:ScheduleMethod(0, "clawTentacleInitial")
	self:ScheduleMethod(0, "geyeTentacleInitial")
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 15589 and phase == 1 then
		phase = 2
		timerEldritch:Stop()
		timerEldritchCD:Stop()
		timerDarkGlare:Stop()
		timerDarkGlareCD:Stop()
		timerEyeTentacleFire:Stop()
		timerEyeTentacleNature:Stop()
		timerEyeTentacleShadow:Stop()
		self:UnscheduleMethod("eyeTentacle")
		self:UnscheduleMethod("preShadow")
		self:UnscheduleMethod("preFire")
		self:UnscheduleMethod("preNature")
		self:UnscheduleMethod("alertShadow")
		self:UnscheduleMethod("alertFire")
		self:UnscheduleMethod("alertNature")
		self:UnscheduleMethod("eldFear")
		self:UnscheduleMethod("eldFearInitial")
		self:UnscheduleMethod("preFear")
		self:UnscheduleMethod("alertFear")
		self:UnscheduleMethod("darkGlare")
		self:UnscheduleMethod("darkGlareInitial")
		self:UnscheduleMethod("preGlare")
		self:UnscheduleMethod("alertGlare")
		self:UnscheduleMethod("firstEyeTentacle")
		self:ScheduleMethod(0, "phaseTwo")
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg)
	if msg:find(L.Eldritch) or msg == L.Eldritch then
		self:ScheduleMethod(0, "eldFear")
		specWarnRevelations:Show();
	end
	if msg == L.EmoteGlare or msg:find(L.EmoteGlare) then
		eldfixglare = 2
		timerEldritchCD:Stop()
		self:UnscheduleMethod("eldFearInitial")
		self:UnscheduleMethod("eldFear")
		self:UnscheduleMethod("preFear")
		self:UnscheduleMethod("alertFear")
		self:ScheduleMethod(0, "darkGlare")
		self:ScheduleMethod(37.5, "eldFear")
	end
	--if msg == L.EmoteWeakend or msg:find(L.Weakened) then
	--	timerWeakened:Start()
	--	warnWeakened:Show()
	--	timerGiantClawTentacle:Stop()
	--	timerGiantEyeTentacle:Stop()
	--	timerStomach:Stop()
	--	timerEyeTentacleFire:Stop()
	--	timerEyeTentacleNature:Stop()
	--	timerEyeTentacleShadow:Stop()
	--	self:UnscheduleMethod("enterStomach")
	--	self:UnscheduleMethod("stomachWeaknessFix")
	--	self:UnscheduleMethod("preStomach")
	--	self:UnscheduleMethod("alertStomach")
	--	self:UnscheduleMethod("clawTentacleInitial")
	--	self:UnscheduleMethod("clawTentacleWeaknessFix")
	--	self:UnscheduleMethod("clawTentacle")
	--	self:UnscheduleMethod("preGiantClaw")
	--	self:UnscheduleMethod("alertGiantClaw")
	--	self:UnscheduleMethod("geyeTentacle")
	--	self:UnscheduleMethod("geyeTentacleInitial")
	--	self:UnscheduleMethod("geyeTentacleWeaknessFix")
	--	self:UnscheduleMethod("preGiantEye")
	--	self:UnscheduleMethod("alertGiantEye")
	--	self:UnscheduleMethod("eyeTentacle")
	--	self:UnscheduleMethod("preShadow")
	--	self:UnscheduleMethod("alertShadow")
	--	self:UnscheduleMethod("preFire")
	--	self:UnscheduleMethod("alertFire")
	--	self:UnscheduleMethod("preNature")
	--	self:UnscheduleMethod("alertNature")
	--end
	--if msg == L.EmoteRestored or msg:find(L.EmoteRestored) then
	--	self:ScheduleMethod(0, "fixweaknessTimers")
	--end
end

function mod:SPELL_PERIODIC_DAMAGE(args)
	if args:IsSpellID(2117055,2117056,2117057,2117058) then -- Eradicate (Eye Tentacles)
		if args:IsPlayer() and (((args.amount or 0) + (args.resisted or 0) + (args.absorbed or 0)) > 1000) then
			specWarnEradicate:Show();
		end
	end
end

function mod:SPELL_PERIODIC_HEAL(args)
	if args:IsSpellID(2117060,2117061,2117062,2117063) then -- Consume Essence
		if args:IsPlayerSource() and ((args.amount or 0) > 4000) then
			specWarnConsume:Show();
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
    if (args:IsSpellID(2117107)) and args.destName == "C'Thun" then
		timerWeakened:Stop()
		timerGiantClawTentacle:Stop()
		timerGiantEyeTentacle:Stop()
		timerStomach:Stop()
		timerEyeTentacleFire:Stop()
		timerEyeTentacleNature:Stop()
		timerEyeTentacleShadow:Stop()
		self:UnscheduleMethod("fixWeaknessTimers")
        self:ScheduleMethod(0, "fixWeaknessTimers")
    end
end


function mod:SPELL_AURA_APPLIED(args) -- Weakened phase (C'Thun and tentacles)
	if args:IsSpellID(2117107) then
		timerWeakened:Start()
		warnWeakened:Show()
		timerGiantClawTentacle:Stop()
		timerGiantEyeTentacle:Stop()
		timerStomach:Stop()
		timerEyeTentacleFire:Stop()
		timerEyeTentacleNature:Stop()
		timerEyeTentacleShadow:Stop()
		self:UnscheduleMethod("eyeTentacle")
		self:UnscheduleMethod("p2eyeTentacle")
		self:UnscheduleMethod("preShadow")
		self:UnscheduleMethod("alertShadow")
		self:UnscheduleMethod("preFire")
		self:UnscheduleMethod("alertFire")
		self:UnscheduleMethod("preNature")
		self:UnscheduleMethod("alertNature")
		self:UnscheduleMethod("enterStomach")
		self:UnscheduleMethod("stomachWeaknessFix")
		self:UnscheduleMethod("preStomach")
		self:UnscheduleMethod("alertStomach")
		self:UnscheduleMethod("clawTentacleInitial")
		self:UnscheduleMethod("clawTentacleWeaknessFix")
		self:UnscheduleMethod("clawTentacle")
		self:UnscheduleMethod("preGiantClaw")
		self:UnscheduleMethod("alertGiantClaw")
		self:UnscheduleMethod("geyeTentacle")
		self:UnscheduleMethod("geyeTentacleInitial")
		self:UnscheduleMethod("geyeTentacleWeaknessFix")
		self:UnscheduleMethod("preGiantEye")
		self:UnscheduleMethod("alertGiantEye")
		self:ScheduleMethod(30, "fixweaknessTimers")
	end
	if args:IsSpellID(2117074) then -- Malignant Grasp (Malignant Tentacle)
		if args.destName then
			if (not args:IsPlayer()) then
				local uId = DBM:GetRaidUnitId(args.destName)
				if uId then
					local inRange = CheckInteractDistance(uId, 4)
					if inRange then
						warnMalignantGrasp:Show(args.destName);
					end
				else
					warnMalignantGrasp:Show(args.destName);
				end
			end
		end
	end
	if args:IsSpellID(2117054) then -- Miasma (Eye Tentacles)
		if args:IsPlayer() then
			specWarnMiasma:Show();
		end
	end
	if args:IsSpellID(2117117) then -- (From beneath it devours you)
		if args:IsPlayer() then
			SpecwarnStomach:Show()
			SendChatMessage(""..UnitName("PLAYER").."is being sent to the stomach", "Say")
			else
				warnStomach:Show(args.destName);
			end
		end
end

function mod:SPELL_AURA_APPLIED_DOSE(args)
	if args:IsSpellID(26476) then -- Digestive Acid (Stomach)
		if args:IsPlayer() and ((args.amount or 1) >= 4) then --(self.Options.NumAcidStacks or 4)) then
			specWarnDigestiveAcid:Show(args.amount);
		end
	elseif args:IsSpellID(4500001) then -- Miasma (Eye Tentacles)
		if args:IsPlayer() then
			specWarnMiasma:Show();
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(4500068) then
		local targetname = self:GetBossTarget(26180) -- self:GetBossTarget(157252)
		if targetname and (targetname == UnitName("PLAYER")) then
			specWarnSensoryOverload:Show();
		end
	end
	if args:IsSpellID(2117084) then
		self:ScheduleMethod(0.2, "LesserEldritch")
	end
	if args:IsSpellID(2117009) then
		timerDarkGlare:Start()
		warnDarkGlare:Show()
	end
	if args:IsSpellID(2117076) and args.UnitName == "Giant Claw Tentacle" then
		SpecWarnDevSmash:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2117055,2117056,2117057,2117058) and etent == 0 then
		etent = 3
	end
	if args:IsSpellID(2117060,2117061,2117062,2117063) and etent == 0 then
		etent = 1
	end
	if args:IsSpellID(2117050) and etent == 0 then
		etent = 2
	end
end
