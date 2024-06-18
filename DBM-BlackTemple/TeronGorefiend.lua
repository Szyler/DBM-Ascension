local mod	= DBM:NewMod("TeronGorefiend", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22871)
mod:RegisterCombat("yell", L.DBM_GOREFIEND_YELL_PULL)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_PERIODIC_DAMAGE",
	"UNIT_AURA"
)

local warningWitherAndRot		= mod:NewSpellAnnounce(2143286, 3)
local warningGraspingDeath		= mod:NewSpellAnnounce(2143282, 3)
local specWarnWitherAndRot		= mod:NewSpecialWarningYou(2143282)
local warnShadowOfDeath			= mod:NewSpellAnnounce(2143264, 2)
local warnSoulReaper			= mod:NewSpellAnnounce(2143272, 2)

local timerNextWitherAndRot		= mod:NewNextTimer(30, 2143286)
local timerNextGraspingDeath	= mod:NewNextTimer(30, 2143282)
local timerNextShadowofDeath	= mod:NewNextTimer(30, 2143264)
local timerTargetShadowofDeaths	= mod:NewTargetTimer(37, 2143264)
local timerTargetShadowofDeath	= mod:NewTargetTimer(37, 2143264)
local timerTargetShadowofDeath2	= mod:NewTargetTimer(75, 2143264)
local timerTargetShadowofDeath3	= mod:NewTargetTimer(75, 2143264)
local timerTargetShadowofDeath4	= mod:NewTargetTimer(75, 2143264)
local timerTargetShadowofDeath5	= mod:NewTargetTimer(75, 2143264)
local timerTargetShadowofDeath6	= mod:NewTargetTimer(75, 2143264)
local timerTargetShadowofDeath7	= mod:NewTargetTimer(75, 2143264)
local timerTargetShadowofDeath8	= mod:NewTargetTimer(75, 2143264)
local timerTargetShadowofDeath9	= mod:NewTargetTimer(75, 2143264)
local timerTargetShadowofDeath10= mod:NewTargetTimer(75, 2143264)
local timerSoulReaper			= mod:NewNextTimer(20, 2143271)

--Shadow of death has different timer for everyone.  First person to expire has to run out.
--Would like to add warnings for Teron's soul shards, tracked in a stacking buff on the boss.  Spell id 2143255

-- local shadowOfDeathName = GetSpellInfo(2143282)


function mod:WitherAndRot()
	self:UnscheduleMethod("WitherAndRot")
	warningWitherAndRot:Show()
	timerNextWitherAndRot:Start()
	self:ScheduleMethod(30, "WitherAndRot")
end

function mod:OnCombatStart(delay)
	timerNextShadowofDeath:Start(10-delay)
	timerNextGraspingDeath:Start(15-delay)
	timerSoulReaper:Start(20-delay)
	self:ScheduleMethod(15, "WitherAndRot")
	timerNextGraspingDeath:Start(30-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2143286, 2143287, 2143288, 2143289) and DBM:AntiSpam(1) then
		if args:IsPlayer() then
			specWarnWitherAndRot:Show()
		end
	elseif args:IsSpellID(2143282, 2143283, 2143284, 2143285) and DBM:AntiSpam(1) then
		warningGraspingDeath:Show()
		timerNextGraspingDeath:Start()
	elseif args:IsSpellID(2143264, 2143258, 2143259)  then --and DBM:AntiSpam()
		warnShadowOfDeath:Show()
		-- timerNextShadowofDeath:Start()
		-- timerTargetShadowofDeaths:Start()
	elseif args:IsSpellID(2143271, 2143272, 2143273, 2143274) then
		warnSoulReaper:Show()
		timerSoulReaper:Start()
	end
end

function mod:SPELL_PERIODIC_DAMAGE(args)
	if args:IsSpellID(2143286, 2143287, 2143288, 2143289) and DBM:AntiSpam(1) then
		if args:IsPlayer() then
			specWarnWitherAndRot:Show()
		end
	end
end

--name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId 
-- = UnitAura("unit", index or "name"[, "rank"[, "filter"]])

function mod:UNIT_AURA(unit)
	
	local spellName, _, _, _, _, duration, expires, _, _, _, spellId = UnitDebuff(unit, "Shadow of Death")
	if spellName == "Shadow of Death" then
		if not spellId or not expires then return end
		local name = UnitName(unit)
		if (not name) then return end
		expires = expires - GetTime()
		if expires > 0 then
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath2:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath3:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath4:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath5:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath6:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath7:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath8:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath9:Start(expires, name)
		elseif DBM:AntiSpam(500) then
			timerTargetShadowofDeath10:Start(expires, name)
		end
	end
end

--Gorefiend:AddOption("WarnIncinerate", false, DBM_GOREFIEND_OPTION_INCINERATE)

--Gorefiend:AddBarOption("Vengeful Spirit: (.*)")
--Gorefiend:AddBarOption("Shadow of Death: (.*)")

-- function Gorefiend:OnEvent(event, arg1)
-- 	if event == "SPELL_AURA_APPLIED" then
-- 		if arg1.spellId == 40251 then
-- 			if arg1.destName == UnitName("player") then
-- 				self:AddSpecialWarning(DBM_GOREFIEND_SPECWARN_SOD)
-- 			end
-- 			self:SendSync("SoD"..tostring(arg1.destName))
-- 		elseif arg1.spellId == 40239 then
-- 			self:SendSync("Inc"..tostring(arg1.destName))
-- 		end
-- 	elseif event == "Ghost" and arg1 then
-- 		self:StartStatusBarTimer(60, "Vengeful Spirit: "..tostring(arg1), "Interface\\Icons\\Spell_Shadow_DemonicTactics")
-- 	end
-- end

-- function Gorefiend:OnSync(msg)
-- 	if msg:sub(0, 3) == "SoD" then
-- 		msg = msg:sub(4)
-- 		self:Announce(DBM_GOREFIEND_WARN_SOD:format(msg), 3)
-- 		self:StartStatusBarTimer(55, "Shadow of Death: "..msg, "Interface\\Icons\\Spell_Arcane_PrismaticCloak")
-- 		self:ScheduleSelf(55, "Ghost", msg)
-- 	elseif msg:sub(0, 3) == "Inc" then
-- 		msg = msg:sub(4)
-- 		if self.Options.WarnIncinerate then
-- 			self:Announce(DBM_GOREFIEND_WARN_INCINERATE:format(msg), 2)
-- 		end
-- 	end
-- end

