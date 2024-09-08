local mod	= DBM:NewMod("Najentus", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22887)
mod:RegisterCombat("yell", L.DBM_NAJENTUS_YELL_PULL)

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local warningShield			= mod:NewSpellAnnounce(2142521, 3)
local warningDischarge		= mod:NewSpellAnnounce(2142504, 3)
local specWarnYouDischarge	= mod:NewSpecialWarningYou(2142504)
local warningPuddle			= mod:NewSpellAnnounce(2142594, 3)
local warnSpine				= mod:NewTargetAnnounce(2142516, 2)
local warnOozeDot			= mod:NewSpellAnnounce(2142564, 2)
local specWarnDampFeet		= mod:NewSpecialWarning("Move out of the water!", 2142550)

local warnIntermission		= mod:NewAnnounce("Intermission phase",3)

local timerNextShield		= mod:NewNextTimer(80, 2142521)
local timerNextDischarge	= mod:NewNextTimer(20, 2142504)
local timerTargetSpine		= mod:NewTargetTimer(30, 2142516)
local timerNextSpine		= mod:NewNextTimer(30, 2142516)

local timerNextAdds			= mod:NewNextTimer(15, 2142574)

local yellDischarge			= mod:NewFadesYell(2142504)

local naj = false

mod:AddBoolOption("SpineYellOpt")
mod:AddBoolOption("DischargeYellOpt")
mod:AddBoolOption("SpineIconsOpt")
mod:AddBoolOption("RangeCheck")

local spineWreathIcon = 8

function mod:OnCombatStart(delay)
	naj = true
	timerNextAdds:Start(10-delay)
	self:ScheduleMethod(10-delay, "NewAdds")
	timerNextDischarge:Start(10-delay)
	spineWreathIcon = 8
end

function mod:OnCombatEnd()
	DBM.RangeCheck:Hide()
	self:UnscheduleMethod("NewAdds")
	naj = false
end

function mod:NewAdds()
	self:UnscheduleMethod("NewAdds")
	timerNextAdds:Start()
	self:ScheduleMethod(15, "NewAdds")
end

function mod:SPELL_AURA_APPLIED(args)
	if naj == true then
	if args:IsSpellID(2142521) then
		warningShield:Show()
		timerNextShield:Start()
		timerNextSpine:Start(10)
	elseif args:IsSpellID(2142504) then
		if args:IsPlayer() then
			if self.Options.DischargeYellOpt then
				SendChatMessage(L.SayDischargeFade, "SAY")
				yellDischarge:Countdown(8, 5)
			end
			specWarnYouDischarge:Show()
			if self.Options.RangeCheck then
				DBM.RangeCheck:Show(15)
			end
		end
		if DBM:AntiSpam() then
			warningDischarge:Show()
			timerNextDischarge:Start()
		end
	elseif args:IsSpellID(2142516, 2142517, 2142518, 2142519) then
		if args:IsPlayer() and self.Options.SpineYellOpt then
			SendChatMessage(L.SpineYell, "YELL")
		else
		warnSpine:Show(args.destName)
		end
		timerNextSpine:Start()
		timerTargetSpine:Start(args.destName)
		if self.Options.SpineIconsOpt then
			self:SetIcon(args.destName, spineWreathIcon, 20)
			spineWreathIcon = spineWreathIcon - 1
		end
	elseif args:IsSpellID(2142526) then
		warnIntermission:Show()
		timerNextShield:Stop()
		timerNextSpine:Stop()
	elseif args:IsSpellID(2142594,2142595,2142596,2142597) or args:IsSpellID(2142560, 21425601,2142562,2142563) then
		if args:IsPlayer() then
			warningPuddle:Show()
		end
	elseif args:IsSpellID(2142564, 2142565, 2142566, 2142567) then
		if args:IsPlayer() then
			warnOozeDot:Show()
		end
	elseif args:IsSpellID(2142550, 2142551) then
		if args:IsPlayer() then
			specWarnDampFeet:Show()
		end
	end
end
end

function mod:SPELL_AURA_REMOVED(args)
	if naj == true then
	if args:IsSpellID(2142516, 2142517, 2142518, 2142519) then
		timerTargetSpine:Stop()
		if self.Options.SpineIconsOpt then
			spineWreathIcon = spineWreathIcon + 1
		end
	elseif args:IsSpellID(2142504) then
		if args:IsPlayer() then
			if self.Options.RangeCheck then
				DBM.RangeCheck:Hide()
			end
		end
	end
end
end


--Najentus:AddOption("RangeCheck", true, DBM_NAJENTUS_OPTION_RANGECHECK)
--Najentus:AddOption("Icon", false, DBM_NAJENTUS_OPTION_ICON)

--Najentus:AddBarOption("Enrage")
--Najentus:AddBarOption("Next Tidal Shield")

-- self:StartStatusBarTimer(480 - delay, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
-- self:ScheduleSelf(180 - delay, "EnrageWarn", 300)
-- self:ScheduleSelf(360 - delay, "EnrageWarn", 120)
-- self:ScheduleSelf(420 - delay, "EnrageWarn", 60)
-- self:ScheduleSelf(450 - delay, "EnrageWarn", 30)
-- self:ScheduleSelf(470 - delay, "EnrageWarn", 10)	
-- self:StartStatusBarTimer(60 - delay, "Next Tidal Shield", "Interface\\Icons\\Spell_Nature_CrystalBall")
-- self:ScheduleSelf(50 - delay, "ShieldWarn")

-- function Najentus:OnEvent(event, arg1)
-- 	if event == "SPELL_AURA_APPLIED" then
-- 		if arg1.spellId == 39837 then
-- 			self:SendSync("Spine"..tostring(arg1.destName))
-- 		elseif arg1.spellId == 39872 then
-- 			self:SendSync("Shield")
-- 		end
-- 	elseif event == "SPELL_AURA_REMOVED" then
-- 		if arg1.spellId == 39872 then
-- 			self:SendSync("FadeShield")
-- 		end
-- 	elseif event == "EnrageWarn" and type(arg1) == "number" then
-- 		if arg1 >= 60 then
-- 			self:Announce(string.format(DBM_NAJENTUS_WARN_ENRAGE, (arg1/60), DBM_MIN), 1)
-- 		else
-- 			self:Announce(string.format(DBM_NAJENTUS_WARN_ENRAGE, arg1, DBM_SEC), 3)
-- 		end
-- 	elseif event == "ShieldWarn" then
-- 		self:Announce(DBM_NAJENTUS_WARN_SHIELD_SOON, 1)
-- 	end
-- end

-- function Najentus:OnSync(msg)
-- 	if msg:sub(0, 5) == "Spine" then
-- 		msg = msg:sub(6)
-- 		self:Announce(DBM_NAJENTUS_WARN_SPINE:format(msg), 2)
-- 		if self.Options.Icon then
-- 			self:SetIcon(msg, 15)
-- 		end
-- 	elseif msg == "Shield" then
-- 		self:Announce(DBM_NAJENTUS_WARN_SHIELD, 3)
-- 		self:ScheduleSelf(48, "ShieldWarn")
-- 		self:StartStatusBarTimer(58, "Next Tidal Shield", "Interface\\Icons\\Spell_Nature_CrystalBall")
-- 	end
-- end

