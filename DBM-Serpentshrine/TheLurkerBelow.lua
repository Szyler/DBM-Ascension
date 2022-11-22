local mod	= DBM:NewMod("LurkerBelow", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21217)
mod:RegisterCombat("combat", 21217)

mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"SPELL_AURA_APPLIED",
	"SPELL_CAST_START",
	"SPELL_DAMAGE",
	"SPELL_MISSED"
)

local warnSubmerge		= mod:NewAnnounce("WarnSubmerge", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local warnEmerge		= mod:NewAnnounce("WarnEmerge", 1, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local warnWhirl			= mod:NewSpellAnnounce(2137605, 2)
local warnFocusedFire	= mod:NewTargetAnnounce(2137622, 2)

local warnFocusedYou	= mod:NewSpecialWarningYou(2137622)
local specWarnSpout		= mod:NewSpecialWarningSpell(2137607)

local timerSubmerge		= mod:NewTimer(135, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local timerEmerge		= mod:NewTimer(60, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local timerNextSpout	= mod:NewNextTimer(70, 2137607) 
local timerSpout		= mod:NewBuffActiveTimer(22, 2137607)
local timerNextWhirl	= mod:NewNextTimer(20, 2137605) --Whirl has 20s next timer, but pushed back by other casts. Need "GetTimer" to push it back (see maiden/mag)
local timerGeyser		= mod:NewNextTimer(20, 2137611) 

--Ascended mechanics:
local timerTentacle		= mod:NewNextTimer(10, 26391) 
local warnSmash			= mod:NewSpecialWarningSpell(2137626)

function mod:OnCombatStart(delay)
	submerged = false
	timerNextWhirl:Start(6-delay)
	timerNextSpout:Start(32-delay)
	timerSubmerge:Start(60-delay)
	timerGeyser:Start(10)
end

function mod:SPELL_AURA_APPLIED(args)
	-- if args:IsSpellID(7731) then
	-- 	DBM:AddMsg("Fishing applied - Pull inc")
	-- else
	if args:IsSpellID(2137622) then
		if args.destName == UnitName("player") then
			warnFocusedYou:Show()
		else
			warnFocusedFire:Show(args.destName)
		end
	end
end

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, src)
	if src == L.name and not self:IsInCombat() then
		DBM:StartCombat(self, 0)
	elseif msg:find(L.EmoteEmerge) then
		timerEmerge:Stop()
		timerSubmerge:Start()
		timerNextSpout:Start(8)
		timerNextWhirl:Start(6)
		timerGeyser:Start(30)
	elseif msg:find(L.EmoteSubmerge) then
		timerEmerge:Start()
		timerTentacle:Start()
		timerSubmerge:Stop()
		timerNextSpout:Stop()
		timerGeyser:Stop()
		timerNextWhirl:Stop()
	elseif msg:find(L.EmoteBreath) then
		timerNextWhirl:Start(25)
		specWarnSpout:Show()
		timerSpout:Start()
		timerNextSpout:Start()
		if timerGeyser:GetTime() < 25 then
			timerGeyser:Stop()
		end
	end
end

function mod:SPELL_CAST_START(args)
	if args:IsSpellID(2137626) then
		warnSmash:Show()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(2137611, 2137612, 2137613, 2137614) then
		timerGeyser:Start()
	elseif args:IsSpellID(2137605) then
		timerNextWhirl:Start()
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(2137611, 2137612, 2137613, 2137614) then
		timerGeyser:Start()
	elseif args:IsSpellID(2137605) then
		timerNextWhirl:Start()
	end
end
