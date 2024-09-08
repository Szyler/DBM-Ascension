local mod	= DBM:NewMod("Trash", "DBM-Sunwell")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5021 $"):sub(12, -3))
mod:SetCreatureID(25507)
mod:RegisterCombat("combat", 25507)

mod:RegisterEvents(
	"SPELL_CAST_START"
)

local warningFelLightning			= mod:NewTargetAnnounce(2145224, 3)
local timerFelLightning				= mod:NewTargetTimer(4, 2145224)
local timerNextFelLightning			= mod:NewNextTimer(10, 2145224)
local warnFelLightningYou 			= mod:NewSpecialWarningYou(2145224)

local warnElectroMagneticPulse		= mod:NewSpellAnnounce(2145228, 3)
local timerElectroMagneticPulse		= mod:NewCastTimer(6, 2145228)
local timerNextElectroMagneticPulse	= mod:NewNextTimer(45, 2145228)


function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2145224) then
		local target = nil
		target = mod:GetBossTarget(25507)
		if target == UnitName("player") then
			warnFelLightningYou:Show()
			SendChatMessage("Fel Lightning on "..UnitName("PLAYER")..", get away!", "YELL")
		else
			warningFelLightning:Show(target)
		end
		timerFelLightning:Start(target)
		self:SetIcon(target, 6, 4)
		timerNextFelLightning:Start()
	elseif args:IsSpellID(2145228) then
		warnElectroMagneticPulse:Show()
		timerElectroMagneticPulse:Start()
		timerNextElectroMagneticPulse:Start()
	end
end
