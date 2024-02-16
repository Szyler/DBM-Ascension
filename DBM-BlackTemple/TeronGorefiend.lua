local mod	= DBM:NewMod("TeronGorefiend", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22871)
mod:RegisterCombat("yell", DBM_GOREFIEND_YELL_PULL)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

local warningWitherAndRot		= mod:NewSpellAnnounce(2143286, 3)
local warningGraspingDeath		= mod:NewSpellAnnounce(2143282, 3)
local warnShadowOfDeath			= mod:NewSpellAnnounce(2143264, 2)
local warnSoulReaper			= mod:NewSpellAnnounce(2143272, 2)

local timerNextWitherAndRot		= mod:NewNextTimer(30, 2143286)
local timerNextGraspingDeath	= mod:NewNextTimer(30, 2143282)
local timerNextShadowofDeath	= mod:NewNextTimer(30, 2143264)
local timerSoulReaper			= mod:NewNextTimer(20, 2143271)

--Shadow of death has different timer for everyone.  First person to expire has to run out.
--Would like to add warnings for Teron's soul shards, tracked in a stacking buff on the boss.  Spell id 2143255

function mod:OnCombatStart(delay)
	timerNextWitherAndRot:Start(15-delay)
	timerNextGraspingDeath:Start(30-delay)
	timerNextShadowofDeath:Start(10-delay)
	timerSoulReaper:Start(20-delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2143286, 2143287, 2143288, 2143289) and DBM:AntiSpam(10) then
		warningWitherAndRot:Show()
		timerNextWitherAndRot:Start()
	elseif args:IsSpellID(2143282, 2143283, 2143284, 2143285) and DBM:AntiSpam(10) then
		warningGraspingDeath:Show()
		timerNextGraspingDeath:Start()
	elseif args:IsSpellID(2143264) then
		warnShadowOfDeath:Show()
		timerNextShadowofDeath:Start()
	elseif args:IsSpellID(2143271, 2143272, 2143273, 2143274) then
		warnSoulReaper:Show()
		timerSoulReaper:Start()
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

