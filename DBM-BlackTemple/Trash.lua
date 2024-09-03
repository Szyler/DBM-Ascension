local mod	= DBM:NewMod("Trash", "DBM-BlackTemple")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5019 $"):sub(12, -3))
mod:SetCreatureID(22879)
mod:RegisterCombat("combat", 22879)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED"
)

local warningIgnorePain			= mod:NewTargetAnnounce(2142343, 3)
local timerIgnorePain			= mod:NewBuffActiveTimer(8, 2142343)

local warningJealousy			= mod:NewTargetAnnounce(2142255, 3)
local specWarnYouJealousy		= mod:NewSpecialWarningYou(2142255)
local timerJealousy				= mod:NewTargetTimer(10, 2142255)

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2142343) then
		warningIgnorePain:Show(args.destName)
        timerIgnorePain:Start(args.destName)
	elseif args:IsSpellID(2142255) and args.amount and (args.amount % 5 or args.amount > 10) then
		warningJealousy:Show(args.destName)
		timerJealousy:Start(args.destName)
		if args:IsPlayer() then
			specWarnYouJealousy:Show()
		end
	end
end

mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED -- Hack to include applied_dose as well without more code