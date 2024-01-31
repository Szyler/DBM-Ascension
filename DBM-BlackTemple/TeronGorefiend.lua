local mod	= DBM:NewMod("TeronGorefiend", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22871)
mod:RegisterCombat("yell", DBM_GOREFIEND_YELL_PULL)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

function mod:OnCombatStart(delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(123123) then
		warningCurse:Show()
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

