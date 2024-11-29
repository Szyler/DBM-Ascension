local mod	= DBM:NewMod(422, "DBM-Party-Vanilla", 7, 231)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7800)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warningKnockAway			= mod:NewSpellAnnounce(10101, 2)
local warningActivateBomb		= mod:NewSpellAnnounce(11518, 2)

local timerKnockAwayCD			= mod:NewCDTimer(180, 10101)

function mod:OnCombatStart(delay)
	timerKnockAwayCD:Start(1-delay)
end

-- local BombOne, BombTwo, BombThree, BombFour, BombFive, BombSix = DBM:GetSpellInfo(11518), DBM:GetSpellInfo(11521), DBM:GetSpellInfo(11798), DBM:GetSpellInfo(11524), DBM:GetSpellInfo(11526), DBM:GetSpellInfo(11527)
function mod:SPELL_CAST_SUCESS(args)
	if args:IsSpellID(10101, 11130) then
		warningKnockAway:Show()
		timerKnockAwayCD:Start()
	elseif (spellId == 11518 or spellId == 11521 or spellId == 11798 or spellId == 11524 or spellId == 11526 or spellId == 11527) and self:AntiSpam(3, 1) then
		warningActivateBomb:Show()
	end
end
