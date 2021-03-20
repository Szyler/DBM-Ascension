----------Shattrath----------
local mod	= DBM:NewMod("Shattrath", "DBM-ShattrathTest")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(37611)
mod:RegisterCombat("combat")
mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_REMOVED",
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REFRESH",
	"CHAT_MSG_MONSTER_YELL",
	"CHAT_MSG_MONSTER_EMOTE",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_HEALTH",
	"PLAYER_ALIVE"
)

-----START DEFINES-----
	local WarnAbyssal		= mod:NewSpellAnnounce(30511, 2)
	local WarnHeal			= mod:NewCastAnnounce(30528, 2, nil, false)
	local timerHeal			= mod:NewCastTimer(2, 30528)
	local timerNextQuake	= mod:NewNextTimer(12,85026)
	local timerNovaSoon		= mod:NewTimer(4, "Interrupt with Cubes soon!", 30616)
	local timerTerminate		= mod:NewTargetTimer(10, 85082)
	local specWarnConflag	= mod:NewSpecialWarningMove(6117)

-----PHASE 3-----
	local warnPhase3		= mod:NewPhaseAnnounce(3, 3)
	local firedPhase3Soon
	local firedPhase3 
-----Misc-----
	local phase
	local pullTime = 0
-----END DEFINES-----

function mod:OnCombatStart(delay)
	pullTime = GetTime()
	firedPhase3Soon = false
	firedPhase3 = false
	phase = 1
	timerNextQuake:Start()
end

function mod:phase2()
-----PHASE 2-----
	timerPhase2:Cancel()
	warnPhase2Soon:Cancel()
	self:UnscheduleMethod("phase2")
	warnPhase2:Show()
	phase = 2
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(6117) and args:IsPlayer() then
		specWarnConflag:Show()
		timerNovaSoon:Start()
	elseif args:IsSpellID(978700) and args:IsPlayer() then
		WarnAbyssal:Show()
		timerHeal:Start()
	elseif args:IsSpellID(28176) and args:IsPlayer() then
		WarnHeal:Show()
		timerTerminate:Start()
	elseif args:IsSpellID(5384) and args:IsPlayer() then
		self:Stop();
	end
end

function mod:SPELL_AURA_REFRESH(args)
	if args:IsSpellID(6117) and args:IsPlayer() then
		specWarnConflag:Show()
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(30511) then
		WarnAbyssal:Show()
		timerNovaSoon:Start()
		timerNova:Schedule(4)
		timerNextQuake:Start()
	end
end

if GetTime() - pullTime > 5 then
	function mod:UNIT_HEALTH(uId)
		if not firedPhase3Soon and self:GetUnitCreatureId(uId) == 17257 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.35 then
			firedPhase3Soon = true
			warnPhase3Soon:Show()
		elseif not firedPhase3 and self:GetUnitCreatureId(uId) == 17257 and UnitHealth(uId) / UnitHealthMax(uId) <= 0.30 then
			firedPhase3 = true
			warnPhase3:Show()
			phase = 3
		end
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(30205) then
		mod:phase2()
	end
end

---DBM GLOBAL FUNCTIONS-----
function mod:OnCombatEnd(wipe)
	self:Stop();
end

function mod:PLAYER_ALIVE()
	if UnitIsDeadOrGhost("PLAYER") and self.Options.ResetOnRelease then
		self:Stop();
	end
end
-----DBM GLOBAL FUNCTIONS-----