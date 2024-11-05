local mod	= DBM:NewMod("EdwinVanCleef", "DBM-Party-Vanilla", 5)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(639)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warningThrash					= mod:NewSpellAnnounce(3391, 3)
local warningAllies					= mod:NewSpellAnnounce(5200, 3)

local timerTrashD					= mod:NewCDTimer(180, 3391)

function mod:OnCombatStart(delay)
	timerTrashD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 5200 and self:AntiSpam(3, 1) then
		warningAllies:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(3391) then
		warningThrash:Show()
		timerTrashD:Start()
	end
end
