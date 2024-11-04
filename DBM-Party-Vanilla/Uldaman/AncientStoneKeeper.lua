local mod	= DBM:NewMod(470, "DBM-Party-Vanilla", 18, 239)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5018 $"):sub(12, -3))
mod:SetCreatureID(7206)

mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS"
)

local warningSandStorms				= mod:NewSpellAnnounce(10132, 2)

local timerSandStormsCD				= mod:NewAITimer(180, 10132, nil, nil, nil, 3)

function mod:OnCombatStart(delay)
	timerSandStormsCD:Start(1-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	--if args.spellId == 10132 or args.spellId == 10094 then
	if args.spellName == SandStorms then
		warningSandStorms:Show()
		timerSandStormsCD:Start()
	end
end
