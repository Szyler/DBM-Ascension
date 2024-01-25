local mod	= DBM:NewMod("Najentus", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22887)
mod:RegisterCombat("yell", DBM_NAJENTUS_YELL_PULL)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

function mod:OnCombatStart(delay)	
	
	if self.Options.RangeCheck then
		DBM_Gui_DistanceFrame_Show()
	end
end

function mod:OnCombatEnd()
	if self.Options.RangeCheck then
		DBM_Gui_DistanceFrame_Hide()
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

