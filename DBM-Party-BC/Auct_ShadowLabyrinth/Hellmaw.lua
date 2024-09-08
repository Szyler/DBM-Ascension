local mod = DBM:NewMod("Hellmaw", "DBM-Party-BC", 10)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))

mod:SetCreatureID(18731)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED"
)

local warnFear      			= mod:NewSpellAnnounce(33547)
local timerNextFear     		= mod:NewNextTimer(25, 33547)
local warningAcid				= mod:NewTargetAnnounce(33551, 2)
local timerNextAcid     		= mod:NewNextTimer(60, 33547)

local enrageTimer				= mod:NewBerserkTimer(180)


function mod:OnCombatStart(delay)
	timerNextFear:Start(10-delay)
	timerNextAcid:Start(5-delay)
	if mod:IsDifficulty("heroic5") then
        enrageTimer:Start(-delay)
    end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 33547 then
		warnFear:Show()
		timerNextFear:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(33551) then
		warningAcid:Show(args.destName)
	end
end

-- 33551 - Corrosive Acid