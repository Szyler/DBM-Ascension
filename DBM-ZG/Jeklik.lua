local mod	= DBM:NewMod("Jeklik", "DBM-ZG", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 132 $"):sub(12, -3))
mod:SetCreatureID(14517)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS"
	-- ,
	-- "SPELL_AURA_APPLIED",
	-- "SPELL_AURA_REMOVED"
)

local warnSonicBurst	= mod:NewSpellAnnounce(23918)
local warnScreech		= mod:NewSpellAnnounce(6605)
-- local warnPain			= mod:NewTargetAnnounce(23952)
local warnHeal			= mod:NewCastAnnounce(23954, 4)
local warnPhase			= mod:NewPhaseAnnounce(2)
local warnCharge		= mod:NewSpellAnnounce(340040)

local timerSonicBurst	= mod:NewBuffActiveTimer(6, 23918)
local timerSonicBurstCD	= mod:NewCDTimer(20, 23918)
local timerScreech		= mod:NewBuffActiveTimer(4, 6605)
local timerScreechCD	= mod:NewCDTimer(20, 6605)
-- local timerPain			= mod:NewTargetTimer(18, 23952)
local timerHeal			= mod:NewCastTimer(4, 23954)
local timerHealCD		= mod:NewCDTimer(20, 23954)
local timerChargeCD		= mod:NewCDTimer(20, 340040)


--- Ascended
local warnConcoc		= mod:NewTargetAnnounce(350381)
local TimerConcoc		= mod:NewTargetTimer(6, 350381)


function mod:OnCombatStart(delay)
	timerHealCD:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(23954,340020) then
		timerHeal:Start()
		timerHealCD:Start()
		warnHeal:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(23918) then
		timerSonicBurst:Start()
		timerSonicBurstCD:Start()
		warnSonicBurst:Show()
	elseif args:IsSpellID(6605, 350368) and self:IsInCombat() then
		timerScreech:Start()
		timerScreechCD:Start()
		warnScreech:Show()
	elseif args:IsSpellID(340040) and args:GetSrcCreatureID(14517) then
		warnCharge:Show() 
		timerChargeCD:Start()
	elseif args:IsSpellID(340040) and args:GetSrcCreatureID(14965) then
		warnConcoc:Show(args.destName)
		TimerConcoc:Show(args.destName)
		if args.destName == UnitName("player") then
			SendChatMessage("Unstable Concoction on me!", "YELL")
		end
	end
end

function mod:SPELL_AURA_APPLIED(args)
	-- if args:IsSpellID(23952) then
	-- 	timerPain:Start(args.destName)
	-- 	warnPain:Show(args.destName)
	-- end
	if args:IsSpellID(340500) then
		warnPhase:Show()
	end
end

-- function mod:SPELL_AURA_REMOVED(args)
-- 	if args:IsSpellID(23952) then
-- 		timerPain:Cancel(args.destName)
-- 	end
-- end