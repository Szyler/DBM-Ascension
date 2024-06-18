local mod	= DBM:NewMod("Shahraz", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22947)
mod:RegisterCombat("yell", L.DBM_SHAHRAZ_YELL_PULL)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"UNIT_HEALTH"
)

local warningFatalAttraction	= mod:NewSpellAnnounce(2144012, 3)
-- local warningThoughts			= mod:NewSpellAnnounce(2144033, 3)
local warningBossRunning		= mod:NewSpellAnnounce(2144050, 3)
local warningBossRunning1		= mod:NewSoonAnnounce(2144050, 3)
local warningBossRunning2		= mod:NewSoonAnnounce(2144050, 3)

local timerNextFatalAttraction	= mod:NewNextTimer(30, 2144012)
local timerNextForcedThoughts	= mod:NewNextTimer(40, 2144035)
-- local timerNextBeam				= mod:NewNextTimer(30, 2144017)

--Sinful
local warningSinfulBeam			= mod:NewSpellAnnounce(2144017, 3)
local warningSinfulThoughts		= mod:NewSpellAnnounce(2144033, 3)
local timerNextSinfulBeam		= mod:NewNextTimer(50, 2144017)
local timerCastSinfulBeam		= mod:NewCastTimer(3, 2144017)
local timerSinfulThoughts		= mod:NewBuffActiveTimer(300, 2144033)

--Sinister
local warningSinisterBeam		= mod:NewSpellAnnounce(2144021, 3)
local warningSinisterThoughts	= mod:NewSpellAnnounce(2144034, 3)
local timerNextSinisterBeam		= mod:NewNextTimer(50, 2144021)
local timerSinisterThoughts		= mod:NewBuffActiveTimer(300, 2144034)

--Vile
local warningVileBeam			= mod:NewSpellAnnounce(2144025, 3)
local warningVileThoughts		= mod:NewSpellAnnounce(2144035, 3)
local timerNextVileBeam			= mod:NewNextTimer(50, 2144025)
local timerVileThoughts			= mod:NewBuffActiveTimer(300, 2144035)

--Wicked
local warningWickedBeam			= mod:NewSpellAnnounce(2144029, 3)
local warningWickedThoughts		= mod:NewSpellAnnounce(2144036, 3)
local timerNextWickedBeam		= mod:NewNextTimer(50, 2144029)
local timerWickedThoughts		= mod:NewBuffActiveTimer(300, 2144036)



local warningShahrazAvian		= mod:NewAnnounce(L.ShahrazAvian, 2, 2144004)
local warningShahrazFila		= mod:NewAnnounce(L.ShahrazFila, 2, 2144003)
local warningShahrazMater		= mod:NewAnnounce(L.ShahrazMater, 2, 2144001)
local warningWiShahrazVirgo		= mod:NewAnnounce(L.ShahrazVirgo, 2, 2144096)

--Ascended
local warningALittleChat		= mod:NewSpellAnnounce(2144007, 3)
local timerCastALittleChat		= mod:NewCastTimer(4, 2144007)
local timerNextALittleChat		= mod:NewNextTimer(49, 2144007)

--local
local isMother		=	false
local below20		=   false
local below10		=   false

function mod:OnCombatStart(delay)
	timerNextForcedThoughts:Start(15-delay)
	timerNextFatalAttraction:Start(35-delay)
	timerNextALittleChat:Start(20-delay)
	self:ScheduleMethod(15-delay, "NewThoughts")
	below20		=   false
	below10		=   false
	isMother	=	true
end

function mod:OnCombatEnd()
	DBM.RangeCheck:Hide()
	self:UnscheduleMethod("NewThoughts")
end

function mod:NewThoughts()
	self:UnscheduleMethod("NewThoughts")
	timerNextForcedThoughts:Start()
	self:ScheduleMethod(40, "NewThoughts")
end

function mod:SPELL_AURA_APPLIED(args)

	if args:IsSpellID(2144050, 2144051) then
		warningBossRunning:Show()
		timerSinfulThoughts:Stop()
		timerSinisterThoughts:Stop()
		timerVileThoughts:Stop()
		timerWickedThoughts:Stop()
		timerNextForcedThoughts:Stop()

		timerNextFatalAttraction:Stop()

		timerNextSinfulBeam:Stop()
		timerNextSinisterBeam:Stop()
		timerNextVileBeam:Stop()
		timerNextWickedBeam:Stop()
	elseif args:IsSpellID(2144001) and args.amount and args.amount >= 8 and args.amount % 2 == 0 and DBM:AntiSpam(5, 1) then
		warningShahrazMater:Show()
	elseif args:IsSpellID(2144003) and args.amount and args.amount >= 8 and args.amount % 2 == 0 and DBM:AntiSpam(5, 1) then
		warningShahrazFila:Show()
	elseif args:IsSpellID(2144004) and args.amount and args.amount >= 8 and args.amount % 2 == 0 and DBM:AntiSpam(5, 1) then
		warningShahrazAvian:Show()
	elseif args:IsSpellID(2144096) and args.amount and args.amount >= 8 and args.amount % 2 == 0 and DBM:AntiSpam(5, 1) then
		warningWiShahrazVirgo:Show()
	elseif args:IsSpellID(2144007) then
		warningALittleChat:Show()
		timerNextALittleChat:Start()
		timerCastALittleChat:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2144017) or args:IsSpellID(2144018) or args:IsSpellID(2144019) or args:IsSpellID(2144020) and DBM:AntiSpam() then
		warningSinfulBeam:Show()
		timerCastSinfulBeam:Start()
		timerNextSinfulBeam:Start()
		if args:IsPlayer() then
			warningSinfulThoughts:Show()
			timerSinfulThoughts:Start()
			timerSinisterThoughts:Stop()
			timerVileThoughts:Stop()
			timerWickedThoughts:Stop()
		end
	elseif args:IsSpellID(2144021) or args:IsSpellID(2144022) or args:IsSpellID(2144023) or args:IsSpellID(2144024) and DBM:AntiSpam() then
		warningSinisterBeam:Show()
		timerNextSinisterBeam:Start()
		if args:IsPlayer() then
			warningSinisterThoughts:Show()
			timerSinfulThoughts:Stop()
			timerSinisterThoughts:Start()
			timerVileThoughts:Stop()
			timerWickedThoughts:Stop()
		end
	elseif args:IsSpellID(2144025) or args:IsSpellID(2144026) or args:IsSpellID(2144027) or args:IsSpellID(2144028) and DBM:AntiSpam() then
		warningVileBeam:Show()
		timerNextVileBeam:Start()
		if args:IsPlayer() then
			warningSinfulThoughts:Show()
			timerSinfulThoughts:Stop()
			timerSinisterThoughts:Stop()
			timerVileThoughts:Start()
			timerWickedThoughts:Stop()
		end
	elseif args:IsSpellID(2144029) or args:IsSpellID(2144030) or args:IsSpellID(2144031) or args:IsSpellID(2144032) and DBM:AntiSpam() then
		warningWickedBeam:Show()	
		timerNextWickedBeam:Start()
		if args:IsPlayer() then
			warningWickedThoughts:Show()
			timerSinfulThoughts:Stop()
			timerSinisterThoughts:Stop()
			timerVileThoughts:Stop()
			timerWickedThoughts:Start()
		end
	elseif args:IsSpellID(2144012) and DBM:AntiSpam(15) then
		warningFatalAttraction:Show()
		timerNextFatalAttraction:Start()
	end
end

function mod:UNIT_HEALTH(unit)
	if isMother and (not below20 and not below10) and (mod:GetUnitCreatureId(unit) == 22947) then
		local hp = (math.max(0,UnitHealth(unit)) / math.max(1, UnitHealthMax(unit))) * 100;
		if (hp <= 23) and (below20 == false) then
			warningBossRunning1:Show()
			below20 = true
			timerNextFatalAttraction:Stop()
			timerSinfulThoughts:Stop()
			timerSinisterThoughts:Stop()
			timerVileThoughts:Stop()
			timerWickedThoughts:Stop()
		elseif (hp <= 13) and (below10 == false) then
			warningBossRunning2:Show()
			below10 = true
        end
    end
end

--Shahraz:AddOption("WarnBeam", false, DBM_SHAHRAZ_OPTION_BEAM)
--Shahraz:AddOption("WarnBeamSoon", false, DBM_SHAHRAZ_OPTION_BEAM_SOON)
--Shahraz:AddOption("WhisperFA", false, DBM_SEND_WHISPER)

--Shahraz:AddBarOption("Enrage")
--Shahraz:AddBarOption("Next Beam", false)

-- local fa = {}
-- local icon = 8


-- self:StartStatusBarTimer(600 - delay, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy")
-- self:ScheduleSelf(300 - delay, "EnrageWarn", 300)
-- self:ScheduleSelf(480 - delay, "EnrageWarn", 120)
-- self:ScheduleSelf(540 - delay, "EnrageWarn", 60)
-- self:ScheduleSelf(570 - delay, "EnrageWarn", 30)
-- self:ScheduleSelf(590 - delay, "EnrageWarn", 10)

-- fa = {}
-- icon = 8

-- function Shahraz:OnEvent(event, arg1)
-- 	if event == "SPELL_AURA_APPLIED" then
-- 		if arg1.spellId == 41001 then
-- 			self:SendSync("FA"..tostring(arg1.destName))
-- 		elseif arg1.spellId == 40860 then
-- 			self:SendSync("BeamVile")
-- 		end
-- 	elseif event == "SPELL_DAMAGE" then
-- 		if arg1.spellId == 40859 then
-- 			self:SendSync("BeamSinister")
-- 		elseif arg1.spellId == 40827 then
-- 			self:SendSync("BeamSinful")
-- 		elseif arg1.spellId == 40861 then
-- 			self:SendSync("BeamWicked")
-- 		end
-- 	elseif event == "EnrageWarn" and type(arg1) == "number" then
-- 		if arg1 >= 60 then
-- 			self:Announce(string.format(DBM_SHAHRAZ_WARN_ENRAGE, (arg1/60), DBM_MIN), 1)
-- 		else
-- 			self:Announce(string.format(DBM_SHAHRAZ_WARN_ENRAGE, arg1, DBM_SEC), 3)
-- 		end
-- 	elseif event == "WarnFA" then
-- 		local msg = ""
-- 		for i, v in ipairs(fa) do
-- 			msg = msg..">"..v.."<, "
-- 		end
-- 		msg = msg:sub(0, -3)
-- 		fa = {}
-- 		self:Announce(DBM_SHAHRAZ_WARN_FA:format(msg), 4)
-- 		icon = 8
-- 	elseif event == "WarnBeam" then
-- 		if self.Options.WarnBeamSoon then
-- 			self:Announce(DBM_SHAHRAZ_WARN_BEAM_SOON, 1)
-- 		end
-- 	end
-- end

-- function Shahraz:OnSync(msg)
-- 	if msg:sub(0, 2) == "FA" then
-- 		msg = msg:sub(3)
-- 		table.insert(fa, msg)
-- 		if self.Options.Announce and DBM.Rank >= 1 then
-- 			if self.Options.WhisperFA then
-- 				self:SendHiddenWhisper(DBM_SHAHRAZ_WHISPER_FA, msg)
-- 			end
-- 			self:SetIcon(msg, 7.5, icon)
-- 			icon = icon - 1
-- 		end
-- 		if msg == UnitName("player") then
-- 			self:AddSpecialWarning(DBM_SHAHRAZ_SPECWARN_FA)
-- 		end
-- 		self:UnScheduleSelf("WarnFA")
-- 		if #fa == 3 then
-- 			self:OnEvent("WarnFA")
-- 		else
-- 			self:ScheduleSelf(1, "WarnFA")
-- 		end
-- 	elseif msg:sub(0, 4) == "Beam" then
-- 		if self.Options.WarnBeam then
-- 			msg = msg:sub(5)
-- 			if msg == "Vile" then
-- 				self:Announce(DBM_SHAHRAZ_WARN_BEAM_VILE, 2)
-- 			elseif msg == "Sinister" then
-- 				self:Announce(DBM_SHAHRAZ_WARN_BEAM_SINISTER, 2)
-- 			elseif msg == "Sinful" then
-- 				self:Announce(DBM_SHAHRAZ_WARN_BEAM_SINFUL, 2)
-- 			elseif msg == "Wicked" then
-- 				self:Announce(DBM_SHAHRAZ_WARN_BEAM_WICKED, 2)
-- 			end
-- 		end
-- 		self:ScheduleSelf(6, "WarnBeam")
-- 		self:StartStatusBarTimer(9, "Next Beam", "Interface\\Icons\\Spell_Shadow_ShadowBolt")
-- 	end
-- end

