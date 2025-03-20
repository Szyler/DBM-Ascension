local mod	= DBM:NewMod("Curator", "DBM-Karazhan")
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 163 $"):sub(12, -3))
mod:SetCreatureID(15691)
--mod:RegisterCombat("yell", L.DBM_CURA_YELL_PULL)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"CHAT_MSG_MONSTER_YELL",
	"UNIT_HEALTH"
)

local warnEvoSoon			= mod:NewPreWarnAnnounce(2131004, 10, 2)
local warnEvo				= mod:NewSpellAnnounce(2131004, 3)
local warnArcaneInfusion	= mod:NewSpellAnnounce(30403, 3)
local warnTerminate			= mod:NewTargetAnnounce(2131007, 3)
local specWarnTerminate		= mod:NewSpecialWarning(L.TerminationTarget); --,1,2131008, 2131009, 2131010, 2131011)
local warnBreakCrystal		= mod:NewAnnounce(L.BreakCrystalWarning, 2);

local timerTerminate		= mod:NewTargetTimer(10, 2131007)
local timerTerminateCD		= mod:NewCDTimer(15, 2131007) --15 seconds??
local timerEvo				= mod:NewBuffActiveTimer(20, 2131004)
local timerNextEvo			= mod:NewNextTimer(125, 2131004)
local timerNextHateful		= mod:NewNextTimer(6, 2131003)--, mod:IsTank() or mod:IsHealer())
local timerNextHatefulHc	= mod:NewNextTimer(6, 85267)--, mod:IsTank() or mod:IsHealer())

local berserkTimer			= mod:NewBerserkTimer(720)
local isCurator 			= false

mod:SetUsedIcons(5, 6, 7)
local terminateIcon = 5;
mod:AddBoolOption(L.CuratorIcon)
mod:AddBoolOption("RangeFrame", true)

local iconText = {
	[5] = "{Moon}",
	[6] = "{Square}",
	[7] = "{Cross}",
};

local iconText2 = {
	[5] = "(MOON)",
	[6] = "(SQUARE)",
	[7] = "(CROSS)",
};

function mod:OnCombatStart(delay)
	timerTerminateCD:Start(30-delay)
	berserkTimer:Start(-delay)
	timerNextEvo:Start(105-delay)
	warnEvoSoon:Schedule(100-delay)
	warnBreakCrystal:Schedule((105-35)-delay);
	if self.Options.RangeFrame then
		DBM.RangeCheck:Show(10)
	end
	isCurator = true
	terminateIcon = 5;
	self.vb.phase = 1;
end

function mod:OnCombatEnd()
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(30403) then
		warnArcaneInfusion:Show()
		timerNextEvo:Stop()
		timerEvo:Stop()
		self.vb.phase = 2
		--warnBreakCrystal:Cancel();
	elseif args:IsSpellID(2131007) then
		if self.Options.CuratorIcon then
			terminateIcon = (terminateIcon <= ((mod:IsDifficulty("heroic25") and 5) or (mod:IsDifficulty("heroic10") and 6) or 7)) and 7 or (terminateIcon - 1);
			self:SetIcon(args.destName, terminateIcon, 10)
		end
		warnTerminate:Show(args.destName)
		timerTerminate:Start(args.destName)
		timerTerminateCD:Start()
		if args:IsPlayer() then
			local myIconText = self.Options.CuratorIcon and iconText[terminateIcon] or "";
			local myIconText2 = self.Options.CuratorIcon and iconText2[terminateIcon] or "";
			specWarnTerminate:Show(myIconText2);
			SendChatMessage(L.YellTermination:format(myIconText,args.destName,myIconText),"YELL");
		end
	end
end

function mod:CHAT_MSG_MONSTER_YELL(msg)
	if msg == L.DBM_CURA_YELL_OOM then
		warnEvoSoon:Cancel()
		warnEvo:Show()
		timerNextEvo:Start()
		timerEvo:Start()
		warnEvoSoon:Schedule(120);
		warnBreakCrystal:Cancel();
		warnBreakCrystal:Schedule(125-30);
	end
end

function mod:SPELL_DAMAGE(args)
	-----Hateful Strike-----
	if args:IsSpellID(2131003) then
		if self.vb.phase == 2 then 
			timerNextHateful:Start()
		else
			timerNextHateful:Start(4)
		end
	elseif args:IsSpellID(85267) then
		if self.vb.phase == 2 then 
			timerNextHatefulHc:Start()
		else
			timerNextHatefulHc:Start(4)
		end
	end
end