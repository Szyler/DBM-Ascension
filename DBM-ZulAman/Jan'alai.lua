local mod	= DBM:NewMod("Janalai", "DBM-ZulAman")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 5015 $"):sub(12, -3))
mod:SetCreatureID(23578)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_CAST_START",
	"SPELL_CAST_SUCCESS",
	"SPELL_AURA_APPLIED",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"CHAT_MSG_MONSTER_YELL"
)


local warnAddsSoon			= mod:NewSoonAnnounce(43962, 3)

local warnFlame				= mod:NewSpecialWarningRun(2135924)
local specWarnAdds			= mod:NewSpecialWarningSpell(43962)
local specWarnBomb			= mod:NewSpecialWarningSpell(2135933)

local timerNextBomb			= mod:NewNextTimer(37, 2135933)--Cast bar?
local bombCast				= mod:NewCastTimer(7, 2135933)
local timerNextAdds			= mod:NewNextTimer(57, 43962)
local timerNextBreath		= mod:NewNextTimer(15, 2135901)
local timerNextFlameWhirl	= mod:NewNextTimer(32, 2135908)
local flameWhirlCast		= mod:NewCastTimer(6, 2135908)
local timerNextPillar		= mod:NewNextTimer(20, 2135923) --2135923, 2135924, 2135925, 2135926, 2135927

local WarnAddsCount			= mod:NewAnnounce(L.Hatchlings, 2, 85178) --2135905, 2135906, 2135918
local specWarnAllAdds		= mod:NewSpecialWarningSpell(2135906)
local timerAllAdds			= mod:NewNextTimer(6, 2135906)

local berserkTimer			= mod:NewBerserkTimer(600)
local pillarTimer = 0
local hatchlingsAlive = 0
local hathclingsSpawned = 0

mod:SetUsedIcons(1)
mod:AddBoolOption("FlameIcon")

function mod:OnCombatStart(delay)
	timerNextAdds:Start(20)
	timerNextBomb:Start(30)
	timerNextBreath:Start(5)
	berserkTimer:Start(-delay)
	pillarTimer = 15
	hatchlingsAlive = 0
	hathclingsSpawned = 0
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2135900) then
		timerNextBreath:Start()
	elseif args:IsSpellID(2135918) then
		hatchlingsAlive = hatchlingsAlive + 1
		hathclingsSpawned = hathclingsSpawned + 1
		if hatchlingsAlive % 5 == 0 then
			WarnAddsCount:Show(hatchlingsAlive or 5) --(args.amount or 5)	
		end
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(2135908) then
		timerNextFlameWhirl:Start()
		flameWhirlCast:Start()
	elseif args:IsSpellID(2135905) then
		specWarnAllAdds:Show()
		timerAllAdds:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(2135905) then
		hatchlingsAlive = hatchlingsAlive + (40 - hathclingsSpawned) -- Spawns remaining number + lets you know how many
		if hatchlingsAlive >= 5 then
			WarnAddsCount:Show(hatchlingsAlive or 5)
		end
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2135924, 2135925, 2135926, 2135927) and args:IsPlayer() then
		warnFlame:Show()
	elseif args:IsSpellID(2135924, 2135925, 2135926, 2135927) then
		if AntiSpam(pillarTimer-0.1, 1) then -- Antispam at 20-0.1 seconds to not have other people walking into the pillar change the next timer.
			pillarTimer = ((pillarTimer + 5) <= 20) and 20 or 15 -- Alternates between 20 and 15. If pillartimer + 5 is 20, then 20 otherwise (ie. if 20+5 is not 20, then) 15
			timerNextPillar:Start(pillarTimer) --
		end
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(2135924, 2135925, 2135926, 2135927) then
		if AntiSpam(pillarTimer-0.1, 1) then -- Antispam at 20-0.1 seconds to not have other people walking into the pillar change the next timer. AntiSpam(x,1) means Antispam ID1, so this would be the same antispam timer as the Spell_damage one.
			pillarTimer = ((pillarTimer + 5) <= 20) and 20 or 15 -- Alternates between 20 and 15. If pillartimer + 5 is 20, then 20 otherwise (ie. if 20+5 is not 20, then) 15
			timerNextPillar:Start(pillarTimer) --
		end
	end
end

function mod:UNIT_DIED(args)
	if args.destName == "Amani Dragonhawk Hatchling" then
		hatchlingsAlive = hatchlingsAlive <= 1 and 0 or hatchlingsAlive - 1
	end
end

-- function mod:SPELL_AURA_APPLIED(args)
-- 	if args:IsSpellID(2135924, 2135925, 2135926, 2135927) and args:IsPlayer() then -- This is not an aura on you
-- 	warnFlame:Show()
-- 	end
-- end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.YellAdds or msg:find(L.YellAdds) then
		specWarnAdds:Show()
		warnAddsSoon:Schedule(15)
		timerNextAdds:Start()
	elseif msg == L.YellBomb or msg:find(L.YellBomb) then
		--local elapsed, total = timerNextBreath:GetTime();
		timerNextBreath:AddTime(7)
		specWarnBomb:Show()
		bombCast:Start()
		timerNextBomb:Start()
	end
end
