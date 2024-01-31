local mod	= DBM:NewMod("Akama", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(23421)
mod:RegisterCombat("combat", 22841)
-- Akama:SetMinCombatTime(60)

mod:RegisterEvents(
	"UNIT_DIED"
)

function mod:OnCombatStart()
end


function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(123123) then
		warningCurse:Show()
	end
end

-- local channelersDown = 0
-- local sorcerersDown = 0
-- channelersDown = 0
-- sorcerersDown = 0


-- function Akama:OnEvent(event, arg1)
-- 	if event == "UNIT_DIED" then
-- 		if arg1.destName == DBM_AKAMA_MOB_CHANNELER then
-- 			self:SendSync("Channeler")
-- 		elseif arg1.destName == DBM_AKAMA_MOB_SORCERER then
-- 			self:SendSync("Sorcerer")
-- 		end
-- 	end
-- end

-- function Akama:OnSync(msg)
-- 	if msg == "Channeler" then
-- 		channelersDown = channelersDown + 1
-- 		self:Announce(DBM_AKAMA_WARN_CHANNELER_DOWN:format(channelersDown), 2)
-- 	elseif msg == "Sorcerer" then
-- 		sorcerersDown = sorcerersDown + 1
-- 		self:Announce(DBM_AKAMA_WARN_SORCERER_DOWN:format(sorcerersDown), 2)
-- 	end
-- end

