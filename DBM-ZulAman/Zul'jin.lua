local mod	= DBM:NewMod("ZulJin", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision("$Revision: 5015 $"):sub(12, -3)
mod:SetCreatureID(23863)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_SUCCESS",
	"CHAT_MSG_MONSTER_YELL"
)

local warnThrow			= mod:NewTargetAnnounce(43093, 3)
local warnParalyze		= mod:NewSpellAnnounce(43095, 4)
local warnParalyzeSoon	= mod:NewPreWarnAnnounce(43095, 5, 3)
local warnClaw			= mod:NewTargetAnnounce(43150, 3)
local warnFlame			= mod:NewSpellAnnounce(43213, 3)
local warnPhase			= mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2)

local specWarnParalyze	= mod:NewSpecialWarningDispel(43095)

local timerParalyzeCD	= mod:NewCDTimer(27, 43095, nil, nil, nil, 3, nil, DBM_CORE_L.MAGIC_ICON)

mod.vb.phase = 1

function mod:OnCombatStart(delay)
	self.vb.phase = 1
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(43093) then
		warnThrow:Show(args.destName)
	elseif args:IsSpellID(43150) then
		warnClaw:Show(args.destName)
	elseif args:IsSpellID(43213) then
		warnFlame:Show()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(43095) then
		warnParalyzeSoon:Schedule(22)
		if self.Options.SpecWarn43095dispel and self:CheckDispelFilter() then
			specWarnParalyze:Show(DBM_CORE_L.ALLIES)
		else
			warnParalyze:Show()
		end
		timerParalyzeCD:Start()
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellPhase2 or msg:find(L.YellPhase2) then
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(2))
		self.vb.phase = 2
	elseif msg == L.YellPhase3 or msg:find(L.YellPhase3) then
		warnParalyzeSoon:Cancel()
		timerParalyzeCD:Cancel()
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(3))
		self.vb.phase = 3
	elseif msg == L.YellPhase4 or msg:find(L.YellPhase4) then
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(4))
		self.vb.phase = 4
	elseif msg == L.YellPhase5 or msg:find(L.YellPhase5) then
		warnPhase:Show(DBM_CORE_L.AUTO_ANNOUNCE_TEXTS.stage:format(5))
		self.vb.phase = 5
	end
end
