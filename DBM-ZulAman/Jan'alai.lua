local mod	= DBM:NewMod("Janalai", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(23578)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"CHAT_MSG_MONSTER_YELL"
)


local warnAddsSoon		= mod:NewSoonAnnounce(43962, 3)

local warnFlame			= mod:NewSpecialWarningYou(2135924)
local specWarnAdds		= mod:NewSpecialWarningSpell(43962)
local specWarnBomb		= mod:NewSpecialWarningSpell(2135933)

local timerNextBomb		= mod:NewNextTimer(37, 2135933)--Cast bar?
local bombCast			= mod:NewCastTimer(7, 2135933)
local timerNextAdds		= mod:NewNextTimer(57, 43962)
local timerNextBreath	= mod:NewNextTimer(15,2135901)
local timerNextWhirl	= mod:NewNextTimer(32, 2135909)
local whirlCast			= mod:NewCastTimer(6, 2135909)

local berserkTimer		= mod:NewBerserkTimer(600)

local breathSpam = 0
local whirlSpam = 0
mod:SetUsedIcons(1)
mod:AddBoolOption("FlameIcon")

function mod:OnCombatStart(delay)
	timerNextAdds:Start(15)
	timerNextBomb:Start(30)
	timerNextBreath:Start(6)
	berserkTimer:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(43140) then
		self:BossTargetScanner(args.sourceGUID, "FlameTarget", 0.1, 8)
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2135901, 2135902, 2135903, 2135904) and GetTime() - breathSpam > 5 then
		breathSpam = GetTime()
		timerNextBreath:Start()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(2135924, 2135925, 2135926, 2135927) and args:IsPlayer() then
	warnFlame:Show()
	elseif args:IsSpellID(2135907) then
		timerNextWhirl:Start()
	elseif args:IsSpellID(2135909, 2135910, 2135911, 2135912) and GetTime() - whirlSpam >10 then
		whirlSpam= GetTime()
		whirlCast:Start()
		timerNextWhirl:Start(26)
	end
end
function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellAdds or msg:find(L.YellAdds) then
		specWarnAdds:Show()
		warnAddsSoon:Schedule(15)
		timerNextAdds:Start()
	elseif msg == L.YellBomb or msg:find(L.YellBomb) then
		local elapsed, total = timerNextBreath:GetTime();
		timerNextBreath:AddTime(7+(total-elapsed))
		specWarnBomb:Show()
		bombCast:Start()
		timerNextBomb:Start()
	end
end
