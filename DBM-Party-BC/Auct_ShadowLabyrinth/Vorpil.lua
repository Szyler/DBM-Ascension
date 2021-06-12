local mod = DBM:NewMod("Vorpil", "DBM-Party-BC", 10)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 128 $"):sub(12, -3))

mod:SetCreatureID(18732)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_PERIODIC_DAMAGE"
)

local warnBanish				= mod:NewTargetAnnounce(38791, 3)
local warnNextBanish			= mod:NewNextTimer(20, 38791)
local warnDrawShadows			= mod:NewSpellAnnounce(45, 33563)
local warnNextDrawShadows		= mod:NewNextTimer(45, 33563)
local specWarnRoF				= mod:NewSpecialWarningRun(839363)
-- local warnNextRoF			= mod:NewNextTimer(45, 839363)
local warnNextSBVolley			= mod:NewNextTimer(20, 33841)

function mod:OnCombatStart(delay)
	warnNextDrawShadows:Start(45-delay)
	warnNextSBVolley:Start(10-delay)
end

function mod:SPELL_CAST_SUCCESS(args)
	-- if args.spellId == 33563 then
	-- 	warnTeleport:Show()
	-- 	timerTeleport:Start()
	if args.spellId == 38791 then
		warnBanish:Show(args.destName)
		warnNextBanish:Start()
	elseif args.spellId == 33841 then
		warnNextSBVolley:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(33563) then
		-- warnDrawShadows:Show()
		warnNextDrawShadows:Start()
	end
end

-- local RoFSpam = 0
function mod:SPELL_PERIODIC_DAMAGE(args)
	if args:IsSpellID(839363) then 
		-- if (GetTime() - RoFSpam) > 20 then
		-- 	warnNextRoF:Start()
		-- 	RoFSpam = GetTime()
		-- end
		if args:IsPlayer() then
			specWarnRoF:Show();
		end
	end
end

-- 38791 - Banish
-- 33563 - Draw Shadows
-- 839363 - Rain of Fire
-- 33841 - Shadow Bolt Volley