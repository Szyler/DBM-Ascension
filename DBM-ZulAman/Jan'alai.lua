local mod	= DBM:NewMod("Janalai", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(23578)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"CHAT_MSG_MONSTER_YELL"
)

local warnFlame			= mod:NewTargetAnnounce(43140, 3)
local warnAddsSoon		= mod:NewSoonAnnounce(43962, 3)

local specWarnAdds		= mod:NewSpecialWarningSpell(43962)
local specWarnBomb		= mod:NewSpecialWarningSpell(42630)
local specWarnBreath	= mod:NewSpecialWarningYou(43140)
local yellFlamebreath	= mod:NewYell(43140)

local timerBomb			= mod:NewCastTimer(12, 42630)--Cast bar?
local timerAdds			= mod:NewNextTimer(92, 43962)

local berserkTimer		= mod:NewBerserkTimer(600)

mod:SetUsedIcons(1)
mod:AddBoolOption("FlameIcon")

function mod:FlameTarget(targetname, uId)
	if not targetname then return end
	if targetname == UnitName("player") then
		specWarnBreath:Show()
		yellFlamebreath:Yell()
	else
		warnFlame:Show(targetname)
	end
	if self.Options.FlameIcon then
		self:SetIcon(targetname, 1, 1)
	end
end

function mod:OnCombatStart(delay)
	timerAdds:Start(10)
	berserkTimer:Start(-delay)
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(43140) then
		self:BossTargetScanner(args.sourceGUID, "FlameTarget", 0.1, 8)
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellAdds or msg:find(L.YellAdds) then
		specWarnAdds:Show()
		warnAddsSoon:Schedule(82)
		timerAdds:Start()
	elseif msg == L.YellBomb or msg:find(L.YellBomb) then
		specWarnBomb:Show()
		timerBomb:Start()
	end
end
