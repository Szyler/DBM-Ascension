local mod	= DBM:NewMod("Akama", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(23421)
mod:RegisterCombat("combat", 22841)
-- Akama:SetMinCombatTime(60)

mod:RegisterEvents(
	"UNIT_DIED",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED"
)

local timerNextAdds		= mod:NewNextTimer(35, 2142516)

function mod:OnCombatStart()
	timerNextAdds:Start(5-delay)
	self:ScheduleMethod(5-delay, "NewAdds")
end

function mod:OnCombatEnd()
	DBM.RangeCheck:Hide()
end

function mod:NewAdds()
	self:UnscheduleMethod("NewAdds")
	timerNextAdds:Start()
	self:ScheduleMethod(35, "NewAdds")
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2143282, 2143283, 2143284, 2143285) then
		warningWitherAndRot:Show()
		timerNextWitherAndRot:Start()
	elseif args:IsSpellID(2142505, 2142506, 2142507, 2142508) then
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

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2143282, 2143283, 2143284, 2143285) then
		warningWitherAndRot:Show()
		timerNextWitherAndRot:Start()
	elseif args:IsSpellID(2142505, 2142506, 2142507, 2142508) then
		warningGraspingDeath:Show()
		timerNextGraspingDeath:Start()
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

