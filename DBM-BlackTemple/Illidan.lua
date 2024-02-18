local mod	= DBM:NewMod("Illidan", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22917)
mod:RegisterCombat("yell", L.DBM_ILLIDAN_YELL_PULL)
-- Illidan:SetMinCombatTime(20)


mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"SPELL_DAMAGE",
	"UNIT_DIED",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_SPELLCAST_START"
)

local timerCombatStart				= mod:NewTimer(3, "TimerCombatStart", 2457)

local warnChaosBlast           		= mod:NewSpellAnnounce(2144802, 2)
local warnFlameCrash           		= mod:NewSpellAnnounce(2144720, 2)
local warnFlameCrashDot        		= mod:NewSpellAnnounce(2144720, 3)
local warnForceNova            		= mod:NewSpellAnnounce(2144724, 2)
local warnShear                		= mod:NewSpellAnnounce(2144718, 2)
local warnDrawSoul             		= mod:NewSpellAnnounce(2144737, 2)
local warnFelFireBlast         		= mod:NewSpellAnnounce(2144829, 2)
local warnUnharnessedBlade     		= mod:NewSpellAnnounce(2144742, 2)

local yellUnharnessedBlade			= mod:NewFadesYell(2144742)

local timerChaosBlast          		= mod:NewCastTimer(2, 2144802)
local timerChaosBlastDebuff    		= mod:NewBuffActiveTimer(6, 2144802)
local timerNextFlameCrash      		= mod:NewNextTimer(30, 2144720)
local timerFlameCrash          		= mod:NewCastTimer(2, 2144720)
local timerNextForceNova       		= mod:NewNextTimer(25, 2144724)
local timerNextShear           		= mod:NewNextTimer(25, 2144718)
local timerNextDrawSoul        		= mod:NewNextTimer(30, 2144737)
local timerFelFireBlast        		= mod:NewCastTimer(2, 2144802)
local timerNextFelFireBlast    		= mod:NewNextTimer(20, 2144829)
local timerFelFireBlast2       		= mod:NewCastTimer(2, 2144802)
local timerNextFelFireBlast2   		= mod:NewNextTimer(20, 2144829)
local timerNextUnharnessedBlade   	= mod:NewNextTimer(30, 2144742)

function mod:OnCombatStart(delay)
	if self.Options.RangeCheck then
		DBM.RangeCheck:Show(15)
	end
	timerCombatStart:Start(3)
	timerNextForceNova:Start(18-delay)
	timerNextShear:Start(28-delay)
	timerNextDrawSoul:Start(33-delay)
	timerNextUnharnessedBlade:Start(38)
end

function mod:UnharnessedBlade()
	local target = nil
	target = mod:GetBossTarget(22917)
	if target == UnitName("player") then
		yellUnharnessedBlade:Countdown(3,3)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2144840) then
		if timerFelFireBlast:IsStarted() or timerNextFelFireBlast:IsStarted() then
			timerFelFireBlast2:Start()
			timerNextFelFireBlast2:Start(20)
		else
			timerFelFireBlast:Start()
			timerNextFelFireBlast:Start(20)
		end
		warnFelFireBlast:Show()
	elseif args:IsSpellID(2144802,2144803,2144804,2144805) then
		warnChaosBlast:Show()
		timerChaosBlast:Start()
	elseif args:IsSpellID(2144715,2144716,2144717,2144718) then
		warnShear:Show()
		timerNextShear:Start()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2144737,2144738,2144739,2144740) then
		warnDrawSoul:Show()
		timerNextDrawSoul:Start()
	elseif args:IsSpellID(2144720,2144721,2144722,2144723) then
		timerNextFlameCrash:Start()
		warnFlameCrash:Show()
		timerFlameCrash:Start()
	elseif args:IsSpellID(2144829,2144830,2144831,2144832) then
		warnFelFireBlast:Show()
		timerNextFelFireBlast:Start()
	elseif args:IsSpellID(2144742) then
		self:ScheduleMethod(0.2, "UnharnessedBlade")
		warnUnharnessedBlade:Show()
		timerNextUnharnessedBlade:Start()
	elseif args:IsSpellID(2144715,2144716,2144717,2144718) then
		warnShear:Show()
		timerNextShear:Start()
	elseif args:IsSpellID(2144802,2144803,2144804,2144805) then
		warnChaosBlast:Show()
		timerChaosBlast:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2144802,2144803,2144804,2144805) then
		timerChaosBlastDebuff:Start()
	elseif args:IsSpellID(2144720,2144721,2144722,2144723) then
		if args:IsPlayer() then
			warnFlameCrashDot:Show()
		end
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2144724,2144725,2144726,2144727) and DBM:AntiSpam(15)  then
		warnForceNova:Show()
		timerNextForceNova:Start()
	end
end

function mod:OnCombatEnd()
	DBM.RangeCheck:Hide()
end

-- if self.Options.RangeCheck then
-- 	DBM_Gui_DistanceFrame_Hide()
-- end
-- phase2 = nil
-- phase4 = nil

-- local flameTargets = {}
-- local flamesDown = 0
-- local flameBursts = 0
-- local demonTargets = {}
-- local phase2
-- local warnedDemons
-- local phase4


--Illidan:AddOption("RangeCheck", true, DBM_ILLIDAN_OPTION_RANGECHECK)
--Illidan:AddOption("WarnPhases", true, DBM_ILLIDAN_OPTION_PHASES)
----Illidan:AddOption("WarnShearCast", false, DBM_ILLIDAN_OPTION_SHEARCAST)
----Illidan:AddOption("WarnShear", true, DBM_ILLIDAN_OPTION_SHEAR)
--Illidan:AddOption("WarnShadowfiend", true, DBM_ILLIDAN_OPTION_SHADOWFIEND)
--Illidan:AddOption("IconShadowfiend", true, DBM_ILLIDAN_OPTION_ICONFIEND)
--Illidan:AddOption("WarnBarrage", true, DBM_ILLIDAN_OPTION_BARRAGE)
--Illidan:AddOption("WarnBarrageSoon", true, DBM_ILLIDAN_OPTION_BARRAGE_SOON)
--Illidan:AddOption("WarnEyeBeam", true, DBM_ILLIDAN_OPTION_EYEBEAM)
----Illidan:AddOption("WarnEyeBeamSoon", false, DBM_ILLIDAN_OPTION_EYEBEAMSOON) -- inaccurate!
--Illidan:AddOption("WarnFlames", true, DBM_ILLIDAN_OPTION_FLAMES)
--Illidan:AddOption("WarnDemonForm", true, DBM_ILLIDAN_OPTION_DEMONFORM)
--Illidan:AddOption("WarnFlameBursts", true, DBM_ILLIDAN_OPTION_FLAMEBURST)
--Illidan:AddOption("WarnShadowDemons", true, DBM_ILLIDAN_OPTION_SHADOWDEMONS)

--Illidan:AddBarOption("Enrage")
--Illidan:AddBarOption("Illidan Stormrage")
----Illidan:AddBarOption("Shear: (.*)")
--Illidan:AddBarOption("Shadowfiend: (.*)")
--Illidan:AddBarOption("Next Dark Barrage")
--Illidan:AddBarOption("Dark Barrage: (.*)")
--Illidan:AddBarOption("Flames: (.*)", false)
--Illidan:AddBarOption("Demon Phase")
--Illidan:AddBarOption("Normal Phase")
--Illidan:AddBarOption("Shadow Demons")
--Illidan:AddBarOption("Next Flame Burst")

-- flameTargets = {}
-- demonTargets = {}
-- flamesDown = 0
-- flameBursts = 0
-- phase2 = nil
-- phase4 = nil
-- delay = (delay or 0) - 7 - 33 -- 7 = time until combat starts and 33 because the timer will stop while illidan is switching from phase 1->2, 2->3 and 3->4; according to my combatlogs this should be quite accurate
-- self:StartStatusBarTimer(1500 - delay, "Enrage", "Interface\\Icons\\Spell_Shadow_UnholyFrenzy");	
-- self:ScheduleAnnounce(900 - delay, DBM_GENERIC_ENRAGE_WARN:format(10, DBM_MIN), 1)
-- self:ScheduleAnnounce(1200 - delay, DBM_GENERIC_ENRAGE_WARN:format(5, DBM_MIN), 1)
-- self:ScheduleAnnounce(1320 - delay, DBM_GENERIC_ENRAGE_WARN:format(3, DBM_MIN), 1)
-- self:ScheduleAnnounce(1440 - delay, DBM_GENERIC_ENRAGE_WARN:format(1, DBM_MIN), 2)
-- self:ScheduleAnnounce(1470 - delay, DBM_GENERIC_ENRAGE_WARN:format(30, DBM_SEC), 3)
-- self:ScheduleAnnounce(1490 - delay, DBM_GENERIC_ENRAGE_WARN:format(10, DBM_SEC), 4)

-- function Illidan:OnEvent(event, args)
-- 	if event == "CHAT_MSG_MONSTER_YELL" then
-- 		if args == DBM_ILLIDAN_YELL_EYEBEAM then
-- 			self:SendSync("EyeBeam")
-- 		elseif args == DBM_ILLIDAN_YELL_DEMONFORM then
-- 			self:SendSync("DemonForm")
-- 		elseif args == DBM_ILLIDAN_YELL_PHASE4 then
-- 			self:SendSync("Phase4")
-- 		elseif args == DBM_ILLIDAN_YELL_START then
-- 			self:StartStatusBarTimer(36.6, "Illidan Stormrage", "Interface\\Icons\\INV_Weapon_ShortBlade_07")
-- 		end
-- 	elseif event == "SPELL_AURA_APPLIED" then
-- 		if args.spellId == 40647 then
-- 			self:SendSync("Prison")
-- --		elseif args.spellId == 41032 then
-- --			self:SendSync("Shear"..tostring(args.destName))
-- 		elseif args.spellId == 41917 or args.spellId == 41914 then
-- 			self:SendSync("Shadowfiend"..tostring(args.destName))
-- 		elseif args.spellId == 40585 then
-- 			self:SendSync("DarkBarrage"..tostring(args.destName))
-- 		elseif args.spellId == 40932 then
-- 			self:SendSync("Flames"..tostring(args.destName))
-- 		elseif args.spellId == 41083 then
-- 			self:SendSync("ShadowDems"..tostring(args.destName))
-- 		elseif args.spellId == 40683 then -- ??
-- 			self:SendSync("P4Enrage")
-- 		elseif args.spellId == 40695 then
-- 			self:SendSync("Caged")
-- 		end
-- 	elseif event == "SPELL_CAST_SUCCESS" then
-- 		if args.spellId == 39855 then
-- 			self:SendSync("Phase2")
-- 		end
-- 	elseif event == "WarnAF" then
-- 		local msg = ""
-- 		for i, v in ipairs(flameTargets) do
-- 			msg = msg..">"..v.."<, "
-- 		end
-- 		msg = msg:sub(0, -3)
-- 		flameTargets = {}
-- 		if self.Options.WarnFlames then
-- 			self:Announce(DBM_ILLIDAN_WARN_FLAMES:format(msg), 3)
-- 		end
-- 	elseif event == "WarnSD" and not warnedDemons then
-- 		local msg = ""
-- 		for i, v in ipairs(demonTargets) do
-- 			msg = msg..">"..v.."<, "
-- 		end
-- 		msg = msg:sub(0, -3)
-- 		demonTargets = {}
-- 		if self.Options.WarnShadowDemons then
-- 			self:Announce(DBM_ILLIDAN_WARN_SHADOWDEMSON:format(msg), 4)
-- 		end
-- 		warnedDemons = true
-- 	elseif event == "UNIT_DIED" then
-- 		if args.destName == DBM_ILLIDAN_MOB_FLAME then
-- 			self:SendSync("FlameDown")
-- 		end
-- 	elseif event == "SPELL_DAMAGE" then
-- 		if args.spellId == 41131 then
-- 			self:SendSync("Flameburst")
-- 		end
-- --	elseif event == "SPELL_CAST_START" then
-- --		if args.spellId == 41032 then
-- --			self:SendSync("CastShear")
-- --		end
-- 	end
-- end

-- function Illidan:GetBossHP()
-- 	if phase2 then
-- 		return DBM_ILLIDAN_STATUSMSG_PHASE2
-- 	end
-- end

-- function Illidan:OnSync(msg)
-- 	if msg:sub(0, 5) == "Shear" then
-- --		msg = msg:sub(6)
-- --		if self.Options.WarnShear then
-- --			self:Announce(DBM_ILLIDAN_WARN_SHEAR:format(msg), 1)
-- --		end
-- --		self:StartStatusBarTimer(7, "Shear: "..msg, "Interface\\Icons\\Spell_Shadow_FocusedPower")
-- 	elseif msg == "CastShear" then
-- --		if self.Options.WarnShearCast then
-- --			self:Announce(DBM_ILLIDAN_WARN_CASTSHEAR, 1)
-- --		end
-- 	elseif msg:sub(0, 11) == "Shadowfiend" then
-- 		msg = msg:sub(12)
-- 		if msg == UnitName("player") then
-- 			self:AddSpecialWarning(DBM_ILLIDAN_SELFWARN_SHADOWFIEND)
-- 		end
-- 		if self.Options.WarnShadowfiend then
-- 			self:Announce(DBM_ILLIDAN_WARN_SHADOWFIEND:format(msg), 2)
-- 		end
-- 		if self.Options.IconShadowfiend then
-- 			self:SetIcon(msg, 10)
-- 		end
-- 		self:StartStatusBarTimer(10, "Shadowfiend: "..msg, "Interface\\Icons\\Spell_Shadow_Shadowfiend")
-- 	elseif msg:sub(0, 11) == "DarkBarrage" then
-- 		msg = msg:sub(12)
-- 		if self.Options.WarnBarrage then
-- 			self:Announce(DBM_ILLIDAN_WARN_BARRAGE:format(msg), 2)
-- 		end
-- 		if self.Options.WarnBarrageSoon then
-- 			self:ScheduleAnnounce(42, DBM_ILLIDAN_WARN_BARRAGE_SOON, 1)
-- 		end
-- 		self:EndStatusBarTimer("Next Dark Barrage") -- synced timers may only overwrite timers that are about to expire - the barrage timer seems to be quite inaccurate...so send a end timer command before.
-- 		self:StartStatusBarTimer(44, "Next Dark Barrage", "Interface\\Icons\\Spell_Shadow_PainSpike")
-- 		self:StartStatusBarTimer(10, "Dark Barrage: "..msg, "Interface\\Icons\\Spell_Shadow_PainSpike")
-- 	elseif msg == "EyeBeam" then
-- 		if self.Options.WarnEyeBeam then
-- 			self:Announce(DBM_ILLIDAN_WARN_EYEBEAM, 3)
-- 		end
-- --		if self.Options.WarnEyeBeamSoon then -- inaccurate!
-- --			self:ScheduleAnnounce(32, DBM_ILLIDAN_WARN_EYEBEAM_SOON, 2)
-- --		end
-- --		self:StartStatusBarTimer(35, "Next Eye Blast", "Interface\\Icons\\Spell_Shadow_SiphonMana")
-- 	elseif msg:sub(0, 6) == "Flames" then
-- 		msg = msg:sub(7)
-- 		self:StartStatusBarTimer(60, "Flames: "..msg, "Interface\\Icons\\Spell_Fire_BlueImmolation")
-- 		if msg == UnitName("player") then
-- 			self:AddSpecialWarning(DBM_ILLIDAN_SELFWARN_SHADOW)
-- 		end
-- 		table.insert(flameTargets, msg)
-- 		self:UnScheduleEvent("WarnAF")
-- 		self:ScheduleEvent(1, "WarnAF")
-- 	elseif msg == "Phase2" then
-- 		if self.Options.WarnPhases then
-- 			self:Announce(DBM_ILLIDAN_WARN_PHASE2, 4)
-- 		end
-- 		if self.Options.WarnBarrageSoon then
-- 			self:ScheduleAnnounce(76, DBM_ILLIDAN_WARN_BARRAGE_SOON, 1)
-- 		end
-- 		self:StartStatusBarTimer(81, "Next Dark Barrage", "Interface\\Icons\\Spell_Shadow_PainSpike")
-- 		phase2 = true
-- 		flamesDown = 0
-- 	elseif msg == "Phase3" then
-- 		if self.Options.WarnPhases then
-- 			self:Announce(DBM_ILLIDAN_WARN_PHASE3, 4)
-- 		end
-- 		if self.Options.RangeCheck then
-- 			DBM_Gui_DistanceFrame_Show()
-- 		end
-- 		phase2 = nil
-- 		self:StartStatusBarTimer(76, "Demon Phase", "Interface\\Icons\\Spell_Shadow_Metamorphosis")
-- 		if self.Options.WarnDemonForm then
-- 			self:ScheduleAnnounce(66, DBM_ILLIDAN_WARN_DEMONPHASE_SOON, 3)
-- 		end
-- 		self:EndStatusBarTimer("Next Dark Barrage")
-- 		self:UnScheduleAnnounce(DBM_ILLIDAN_WARN_BARRAGE_SOON, 1)
-- 	elseif msg == "Phase4" then
-- 		if self.Options.WarnPhases then
-- 			self:Announce(DBM_ILLIDAN_WARN_PHASE4, 4)
-- 		end
-- 		self:EndStatusBarTimer("Demon Phase")
-- 		self:EndStatusBarTimer("Normal Phase")
-- 		self:UnScheduleAnnounce(DBM_ILLIDAN_WARN_DEMONPHASE_SOON)
-- 		self:UnScheduleAnnounce(DBM_ILLIDAN_WARN_NORMALPHASE_SOON)
-- 		self:StartStatusBarTimer(92, "Demon Phase", "Interface\\Icons\\Spell_Shadow_Metamorphosis")
-- 		if self.Options.WarnDemonForm then
-- 			self:ScheduleAnnounce(82, DBM_ILLIDAN_WARN_DEMONPHASE_SOON, 3)
-- 		end
		
-- 		self:StartStatusBarTimer(71.5, "Enrage2", "Interface\\Icons\\Ability_Warrior_EndlessRage")
-- 		self:ScheduleAnnounce(66.5, DBM_ILLIDAN_WARN_P4ENRAGE_SOON, 3)
		
-- 		phase4 = true
-- 	elseif msg == "DemonForm" then
-- 		flameBursts = 0
-- 		if self.Options.WarnDemonForm then
-- 			self:Announce(DBM_ILLIDAN_WARN_PHASE_DEMON, 4)
-- 		end
-- 		self:StartStatusBarTimer(74, "Normal Phase", "Interface\\Icons\\INV_Weapon_ShortBlade_07")
-- 		self:StartStatusBarTimer(34, "Shadow Demons", "Interface\\Icons\\Spell_Shadow_SoulLeech_3")
-- 		self:StartStatusBarTimer(20, "Next Flame Burst", "Interface\\Icons\\Spell_Fire_BlueRainOfFire")
-- 		if self.Options.WarnDemonForm then
-- 			self:ScheduleAnnounce(64, DBM_ILLIDAN_WARN_NORMALPHASE_SOON, 2)
-- 		end
-- 		if self.Options.WarnShadowDemons then
-- 			self:ScheduleAnnounce(29, DBM_ILLIDAN_WARN_SHADOWDEMSSOON, 2)
-- 		end
-- 		if self.Options.WarnFlameBursts then
-- 			self:ScheduleAnnounce(15, DBM_ILLIDAN_WARN_FLAMEBURST_SOON, 1)
-- 		end
-- 		self:ScheduleMethod(74, "SendSync", "NormalForm")
-- 		warnedDemons = nil
-- 	elseif msg == "NormalForm" then
-- 		if self.Options.WarnDemonForm then
-- 			self:Announce(DBM_ILLIDAN_WARN_PHASE_NORMAL, 4)
-- 		end
-- 		self:StartStatusBarTimer(60, "Demon Phase", "Interface\\Icons\\Spell_Shadow_Metamorphosis")
-- 		if self.Options.WarnDemonForm then
-- 			self:ScheduleAnnounce(50, DBM_ILLIDAN_WARN_DEMONPHASE_SOON, 3)
-- 		end
-- 		if phase4 then
-- 			self:StartStatusBarTimer(40, "Enrage2", "Interface\\Icons\\Ability_Warrior_EndlessRage")
-- 			self:ScheduleAnnounce(35, DBM_ILLIDAN_WARN_P4ENRAGE_SOON, 3)
-- 		end
-- 	elseif msg == "FlameDown" then
-- 		flamesDown = flamesDown + 1
-- 		if flamesDown >= 2 then
-- 			self:SendSync("Phase3")
-- 		end
-- 	elseif msg == "Flameburst" then
-- 		flameBursts = flameBursts + 1
-- 		if flameBursts < 3 then
-- 			self:StartStatusBarTimer(19.5, "Next Flame Burst", "Interface\\Icons\\Spell_Fire_BlueRainOfFire")
-- 			if self.Options.WarnFlameBursts then
-- 				self:ScheduleAnnounce(14.5, DBM_ILLIDAN_WARN_FLAMEBURST_SOON, 1)
-- 			end
-- 		end
-- 		if self.Options.WarnFlameBursts then
-- 			self:Announce(DBM_ILLIDAN_WARN_FLAMEBURST:format(flameBursts), 3)
-- 		end
-- 	elseif msg:sub(0, 10) == "ShadowDems" then
-- 		msg = msg:sub(11)
-- 		if msg == UnitName("player") then
-- 			self:AddSpecialWarning(DBM_ILLIDAN_SELFWARN_DEMONS)
-- 		end
-- 		table.insert(demonTargets, msg)
-- 		self:UnScheduleEvent("WarnSD")
-- 		if #demonTargets == 4 then
-- 			self:OnEvent("WarnSD")
-- 		else
-- 			self:ScheduleEvent(1, "WarnSD")
-- 		end
-- 	elseif msg == "Prison" then
-- 		self:Announce(DBM_ILLIDAN_WARN_PRISON)
-- 		self:StartStatusBarTimer(30, "Shadow Prison", "Interface\\Icons\\Spell_Shadow_SealOfKings")
-- 	elseif msg == "P4Enrage" then
-- 		self:Announce(DBM_ILLIDAN_WARN_P4ENRAGE_NOW, 4)
-- 	elseif msg == "Caged" then
-- 		self:Announce(DBM_ILLIDAN_WARN_CAGED, 1)
-- 		self:StartStatusBarTimer(15, "Caged", 40695)
-- 	end
-- end

