local mod	= DBM:NewMod("LurkerBelow", "DBM-Serpentshrine")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 183 $"):sub(12, -3))
mod:SetCreatureID(21216)
mod:RegisterCombat("combat", 21216)

mod:RegisterEvents(
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"SPELL_DAMAGE",
	"SPELL_MISSED",
	"SPELL_AURA_APPLIED"
)

local warnSubmerge		= mod:NewAnnounce("WarnSubmerge", 2, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local warnEmerge		= mod:NewAnnounce("WarnEmerge", 1, "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local warnWhirl			= mod:NewSpellAnnounce(37363, 2)
local warnFocusedFire	= mod:NewTargetAnnounce(351300, 2)

local specWarnSpout		= mod:NewSpecialWarningSpell(37433)

local timerSubmerge		= mod:NewTimer(135, "TimerSubmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendBurrow.blp")
local timerEmerge		= mod:NewTimer(60, "TimerEmerge", "Interface\\AddOns\\DBM-Core\\textures\\CryptFiendUnBurrow.blp")
local timerNextSpout	= mod:NewNextTimer(70, 37433) --heroic: 351337, Mythic:351338
local timerSpout		= mod:NewBuffActiveTimer(22, 37433)
local timerNextWhirl	= mod:NewNextTimer(20, 37363) --Whirl has 20s next timer, but pushed back by other casts. Need "GetTimer" to push it back (see maiden/mag)
local timerGeyser		= mod:NewNextTimer(20, 37478) --heroic: 351335, Mythic:351336

function mod:OnCombatStart(delay)
	submerged = false
	timerNextWhirl:Start(6-delay)
	timerNextSpout:Start(32-delay)
	timerSubmerge:Start(60-delay)
	timerGeyser:Start(10)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(7731) then
		DBM:AddMsg("Fishing applied - Pull inc")
	elseif args:IsSpellID(351300) then
		warnFocusedFire:Show(args.destName)
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
		timerSubmerge:Stop()
		timerNextSpout:Stop()
		timerGeyser:Stop()
		timerNextWhirl:Stop(0)
	elseif msg:find(L.EmoteBreath) then
		timerNextWhirl:Start(25)
		specWarnSpout:Show()
		timerSpout:Start()
		timerNextSpout:Start()
	end
end

function mod:SPELL_DAMAGE(args)
	if args:IsSpellID(37478, 351335, 351336) then
		timerGeyser:Start()
	elseif args:IsSpellID(37363) then
		timerNextWhirl:Start()
	end
end

function mod:SPELL_MISSED(args)
	if args:IsSpellID(37478, 351335, 351336) then
		timerGeyser:Start()
	elseif args:IsSpellID(37363) then
		timerNextWhirl:Start()
	end
end
