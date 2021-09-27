local mod	= DBM:NewMod("Golemagg", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(11988)--, 11672
mod:RegisterCombat("combat", 11988)

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"UNIT_HEALTH",
	"SPELL_PERIODIC_DAMAGE"
)

mod:AddBoolOption(L.CaveinYellOpt)
local CaveInSpam = 0

local warnTrust			= mod:NewSpellAnnounce(20553)
local warnCaveIn		= mod:NewSpellAnnounce(350098)

local warnP2Soon		= mod:NewAnnounce("WarnP2Soon")
local warnP2			= mod:NewPhaseAnnounce(2)

local timerNextCaveIn	= mod:NewNextTimer(45, 350098)

local prewarn_p2

function mod:OnCombatStart(delay)
	timerNextCaveIn:Start(32-delay)
	prewarn_p2 = false
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(20553) then
		warnTrust:Show()
	elseif args:IsSpellID(350098, 975009) then
		if args:IsPlayer() then
			warnCaveIn:Show()
			if self.Options.CaveinYellOpt then
				SendChatMessage(L.CaveinYell, "YELL")
			end
		end
		if GetTime() > CaveInSpam then
			CaveInSpam = GetTime()
			timerNextCaveIn:Start()
		end
	end
end

function mod:SPELL_PERIODIC_DAMAGE(args)
	if args:IsSpellID(350098, 975009) then
		if args:IsPlayer() then
			warnCaveIn:Show()
			if self.Options.CaveinYellOpt then
				SendChatMessage(L.CaveinYell, "YELL")
			end
		end
	end
end

function mod:UNIT_HEALTH(uId)
	if UnitHealth(uId) / UnitHealthMax(uId) <= 0.10 and self:GetUnitCreatureId(uId) == 11099 and not prewarn_P2 then
		warnP2Soon:Show()
		prewarn_P2 = true
	end
end