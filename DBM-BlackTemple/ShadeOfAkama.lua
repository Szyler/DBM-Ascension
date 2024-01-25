local mod	= DBM:NewMod("Akama", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

Akama.Version		= "1.0"
Akama.Author		= "Tandanu"

local channelersDown = 0
local sorcerersDown = 0

Akama:SetCreatureID(23421)
Akama:RegisterCombat("combat", 22841)
Akama:SetMinCombatTime(60)

Akama:RegisterEvents(
	"UNIT_DIED"
)

function Akama:OnCombatStart()
	channelersDown = 0
	sorcerersDown = 0
end

function Akama:OnEvent(event, arg1)
	if event == "UNIT_DIED" then
		if arg1.destName == DBM_AKAMA_MOB_CHANNELER then
			self:SendSync("Channeler")
		elseif arg1.destName == DBM_AKAMA_MOB_SORCERER then
			self:SendSync("Sorcerer")
		end
	end
end

function Akama:OnSync(msg)
	if msg == "Channeler" then
		channelersDown = channelersDown + 1
		self:Announce(DBM_AKAMA_WARN_CHANNELER_DOWN:format(channelersDown), 2)
	elseif msg == "Sorcerer" then
		sorcerersDown = sorcerersDown + 1
		self:Announce(DBM_AKAMA_WARN_SORCERER_DOWN:format(sorcerersDown), 2)
	end
end

