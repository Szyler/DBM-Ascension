--[[
	********************************************************************
	********************************************************************
	Help Constants at top
	
	Help functions:
	DBM_GetGroupNr(name)
	DBM_GetRaidId(name)
	DBM_GetClass(name)
	DBM_GetRank(name)
	DBM_GetSmoothColor(percent)
	DBM_GetTextClassColor(class)
	DBM_GetColorText(r,g,b)
	DBM_StringIcon(icon)
	DBM_StringTexture(texture)
	DBM_GetTextReactionColor(reaction)
	DBM_GetRealBossName(boss)
	DBM_GetMarkNameFromNumber(marknr)
	DBM_round(tal)
	DBM_UnitHealthPercent(unitid,CountOneHpAsZero = false)
	DBM_UnitPowerPercent(unitid)
	DBM_PlaySoundFile(file)
	DBM_UnitClassification(uid)
	DBM_BoostPlaySound(file,boost,duration);
	DBM_CheckForBuff(buffname, unit)
	DBM_CheckForDebuff(buffname, unit)
	DBM_GetBuffText(buffindex, unit)
	DBM_GetDeBuffText(buffindex, unit)
	DBM_band(mask,...) bitands all args with mask and return true or false
	DBM_bor(b1,...) bitors all args
	DBM_linebreakStr(str,b,tryspace) tryspace if try to break the line at spaces isntead
	DBM_SetTrue(varname)
	DBM_SetFalse(varname)
	DBM_SearchBags(itemname)
	DBM_SplitItemToEmptySlots(bag,item,stacksize)
	DBM_FormatMoney(money)
	DBM_FlagsColor(flags)
	DBM_CPUWarning()
	DBM_NoneEnglish()
	DBM_CreateExtraMenuFrames(nrFrames,nrButtons)
	
	Sync functions:
	DBM_GetPlayerMapPosition(uid)

	********************************************************************
	********************************************************************
]]--

DBM_c_w = "|cFFFFFFFF";
DBM_c_r = "|cFFFF0000";
DBM_c_g = "|cFF00FF00";
DBM_c_dg = "|cFF007F00";
DBM_c_b = "|cFF0000FF";
DBM_c_lb = "|cFF66AAFF";
DBM_c_t = "|cFF00FFFF";
DBM_c_y = "|cFFFFFF00";
DBM_c_purple = "|cFFFF00FF";
DBM_c_p = "|cFF8888CC";
DBM_c_v = "|cFF4444CC";
DBM_c_tt = "|cFFFED100";
DBM_c_bronze = "|cFFFF8800";
DBM_c_black = "|cFF000000";
DBM_c_grey = "|cFFB4B4B4";
DBM_c_pink = "|cFFFFA3B1";
DBM_c_ = "|r"; DBM_c = "|r";
DBM_ICONS = "Interface\\Icons\\";
DBM_FONT_TVCENMT = "Interface\\AddOns\\AscensionBuffFrames\\Fonts\\Tw_Cen_MT_Bold.ttf";
DBM_FONT_DBM = "Interface\\AddOns\\AscensionBuffFrames\\Fonts\\DBM.ttf";
DBM_TEXTURE_BANTOBAR = "Interface\\AddOns\\AscensionBuffFrames\\Textures\\BantoBar";

function DBM_GetGroupNr(name)
	local i,n,g;
	for i=1,GetNumRaidMembers() do
		n,_,g = GetRaidRosterInfo(i);
		if(n==name) then
			return g;
		end
	end
	return false;
end

function DBM_GetRaidId(name)
	local i,n;
	for i=1,GetNumRaidMembers() do
		n = GetRaidRosterInfo(i);
		if(string.lower(n)==string.lower(name)) then
			return i;
		end
	end
	return false;
end

function DBM_GetClass(name)
	local i,n,c;
	for i=1,GetNumRaidMembers() do
		n,_,_,_,c = GetRaidRosterInfo(i);
		if(n==name) then
			return c;
		end
	end
	return "";
end

function DBM_GetRank(name)
	local i,n,c;
	for i=1,GetNumRaidMembers() do
		n,c = GetRaidRosterInfo(i);
		if(n==name) then
			return c;
		end
	end
	return false;
end

function DBM_GetSmoothColor(percent)
	local r, g, b;
	if(percent > 0.5) then
		r = (1.0 - percent) * 2;
		g = 1.0;
	else
		r = 1.0;
		g = percent * 2;
	end
	b = 0.0;
	return r,g,b;
end

function DBM_GetTextClassColor(class)
	local color = RAID_CLASS_COLORS[string.gsub(string.upper(class)," ","")];
	if(color) then
		local colorText = ("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255);
		return colorText;
	end
	return "|cFFFFFFFF";
end

function DBM_GetColorText(r,g,b)
	local colorText = ("|cff%.2x%.2x%.2x"):format(r*255,g*255,b*255);
	return colorText;
end

function DBM_StringIcon(icon)
	return DBM_StringTexture(DBM_ICONS..icon)
end

function DBM_StringTexture(texture)
	return "|T"..texture..":0|t";
end

function DBM_GetTextReactionColor(reaction)
	if(reaction<4) then
		return DBM_c_r;
	elseif(reaction==4) then
		return DBM_c_y;
	else
		return DBM_c_g;
	end
end

function DBM_GetRealBossName(boss)
	local n;
	if(DBM_BOSS_DATA[boss].realname) then
		n = DBM_BOSS_DATA[boss].realname;
	else
		n = boss;
	end
	return n;
end

function DBM_GetMarkNameFromNumber(marknr)
	if(marknr==1) then
		return "star";
	elseif(marknr==2) then
		return "circle";
	elseif(marknr==3) then
		return "diamond";
	elseif(marknr==4) then
		return "triangle";
	elseif(marknr==5) then
		return "moon";
	elseif(marknr==6) then
		return "square";
	elseif(marknr==7) then
		return "cross";
	elseif(marknr==8) then
		return "skull";
	end
end

function DBM_round(tal)
	if (tal < 0) then
		return math.ceil(tal-0.5)
	else
		return math.floor(tal+0.5)
	end
end

function DBM_UnitHealthPercent(unit,CountOneHpAsZero)
	if(UnitExists(unit)) then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100;
		if(CountOneHpAsZero and UnitHealth(unit)==1) then
			return 0;
		elseif(hp == 0) then
			return 0;
		elseif(hp < 1) then
			return 1;
		else
			return math.floor(hp);
		end
	else
		return 0;
	end
end

function DBM_UnitPowerPercent(unitid)
	if(UnitExists(unitid)) then
		return math.floor(UnitPower(unitid) / UnitPowerMax(unitid) * 100);
	else
		return 0;
	end
end

function DBM_PlaySoundFile(file)
	if(DBM_GetS("SoundWarnings")) then
		PlaySoundFile(file);
	end
end

function DBM_UnitClassification(uid)
	local c = UnitClassification(uid);
	local name = UnitName(uid);
	
	if(DBM_ZONE and (name == "Captain Qeez" or name == "Captain Tuubid" or name == "Captain Xurrem" or name == "Major Pakkon" or name =="Colonel Zerran" or name == "Major Yeggeth" or name == "Captain Drenn")) then
		return "worldboss";
	end
	if(DBM_ZONE and c=="elite" and UnitLevel(uid)==-1) then
		return "worldboss";
	end
	return c;
end

function DBM_BoostPlaySound(file,boost,duration)
	local savemaster = GetCVar("Sound_MasterVolume");

	DBM_debug("Boosting Master Volume to: "..savemaster + boost);
	SetCVar("Sound_MasterVolume",savemaster + boost);
	
	DBM_PlaySoundFile(file);

	DBM_Delay(duration,function()
		DBM_debug("Restoring Master to: "..savemaster);
		SetCVar("Sound_MasterVolume",savemaster);
	end);
end

function DBM_CheckForBuff(buffname, unit)
	if (not unit) then unit = "player"; end if (not UnitExists(unit)) then return; end
	local name = UnitBuff(unit,buffname);
	if(name) then
		return true;
	end
	return false;
end

function DBM_CheckForDebuff(buffname, unit)
	if (not unit) then unit = "player"; end if (not UnitExists(unit)) then return; end
	local name = UnitDebuff(unit,buffname);
	if(name) then
		return true;
	end
	return false;
end

function DBM_GetBuffText(buffindex, unit)
	if (not unit) then unit = "player"; end if (not UnitExists(unit)) then return nil; end
	AscensionBuffFrames_TTTextLeft2:SetText();
	AscensionBuffFrames_TT:SetUnitBuff(unit, buffindex);
	return AscensionBuffFrames_TTTextLeft2:GetText();
end

function DBM_GetDeBuffText(buffindex, unit)
	if (not unit) then unit = "player"; end if (not UnitExists(unit)) then return nil; end
	AscensionBuffFrames_TTTextLeft2:SetText();
	AscensionBuffFrames_TT:SetUnitDeBuff(unit, buffindex);
	return AscensionBuffFrames_TTTextLeft2:GetText();
end


function DBM_band(mask,...)
	args = {...};
	local i;
	for i=1,#args do
		if(bit.band(mask,args[i]) == 0) then
			return false;
		end
	end
	return true;
end
function DBM_bor(b1,...)
	args = {...};
	local i;
	for i=1,#args do
		b1 = bit.bor(b1,args[i]);
	end
	return b1;
end

function DBM_linebreakStr(str,b,tryspace)
	local l = {};
	local t;
	while(string.len(str) > 0) do
		if(tryspace) then
			if(string.len(str) <= b) then
				--if the full line fits, just take it all
				l[#l+1] = str;
				break;
			end
			t = string.find(string.reverse(string.sub(str,1,b+1))," ",1,true);
			if(not t) then
				--just break the line
				l[#l+1] = string.sub(str,1,b);
				str = string.sub(str,b+1);
			else
				--break the line and remove the space
				l[#l+1] = string.sub(str,1,b-(t-1));
				str = string.sub(str,b+2-(t-1));
			end
		else
			l[#l+1] = string.sub(str,1,b);
			str = string.sub(str,b+1);
		end
	end
	return table.concat(l,"\n");
end

function DBM_SetTrue(varname)
	_G[varname] = true;
end

function DBM_SetFalse(varname)
	_G[varname] = false;
end

function DBM_SearchBags(itemname)
	local bag,slot;
	for bag=0,NUM_BAG_SLOTS do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot) and string.find(GetContainerItemLink(bag,slot), itemname)) then
				return bag,slot;
			end
		end
	end
	
	return false,false;
end

function DBM_SplitItemToEmptySlots(bag,item,stacksize)
	local valid = GetContainerItemLink(bag,item);
	if(valid and stacksize > 0) then
		local _,itemcount,locked = GetContainerItemInfo(bag,item);
		--it not locked searchbags for free slots
		if(not locked) then
			local sbag,sslot;
			for sbag=0,NUM_BAG_SLOTS do
				for sslot=1,GetContainerNumSlots(sbag) do
					if(GetContainerItemLink(sbag,sslot)==nil) then
						--free slot found split stack into this slot
						if(itemcount > stacksize) then
							SplitContainerItem(bag,item,stacksize);
							itemcount = itemcount - stacksize;
							--find correct bag to click
							for i=1, NUM_CONTAINER_FRAMES do
								local bagframe = getglobal("ContainerFrame"..i);
								if ( bagframe:IsShown() and bagframe:GetID() == sbag ) then
									--bag found, now find slot
									for j=1, GetContainerNumSlots(sbag) do
										local slotframe = getglobal(bagframe:GetName().."Item"..j);
										if(slotframe:GetID()==sslot) then
											--found correct slot, click it
											slotframe:Click();
											DBM_Delay(0.6,DBM_SplitItemToEmptySlots,bag,item,stacksize);
											return;
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function DBM_FormatMoney(money)
	local SILVER = "|cFFC0C0C0";
	local COPPER = "|cFFCC9900";
	local GOLD = "|cFFFFFF66";
	local WHITE = "|cFFFFFFFF";
	local c,s,g;
	local retstr = "";
	g = floor(money/10000);
	s = mod(floor(money/100),100);
	c = mod(money,100);
	
	if(g>0) then
		retstr = retstr..WHITE..g..GOLD.." Gold";
	end
	if(s>0) then
		if ( retstr ~= "" ) then retstr = retstr .. " " end;
		retstr = retstr..WHITE..s..SILVER.." Silver";
	end
	if(c>0) then
		if ( retstr ~= "" ) then retstr = retstr .. " " end;
		retstr = retstr..WHITE..c..COPPER.." Copper";
	end
	return retstr;
end

function DBM_FlagsColor(flags)
	if(DBM_band(flags,COMBATLOG_OBJECT_REACTION_HOSTILE) ) then
		return "|cFFFF0000";
	elseif(DBM_band(flags,COMBATLOG_OBJECT_REACTION_NEUTRAL) ) then
		return "|cFFFFFF00";
	elseif(DBM_band(flags,COMBATLOG_OBJECT_REACTION_FRIENDLY) ) then
		return "|cFF00FF00";
	end
end

function DBM_StripNames(name)
	name = string.gsub(name,"%'","");
	name = string.gsub(name," ","_");
	return name;
end

function DBM_NoneEnglish()
	if(GetLocale() ~= "enUS") then
		DBM_printc("AscensionBuffFramess text parsing is made for the english client only, so some features may not work for you.");
	end
end

function DBM_CPUWarning()
	if(GetCVar("scriptProfile")=="1") then
		DBM_printc("|cFFFFFFFFWarning|cFF8888CC CPU Profileing is on, this may have a huge performance impact on gameplay");
		DBM_printc("If this is unintentional you can disable it by typing /DBMcpuoff");
	end
end

function DBM_CPUPOff()
	if(GetCVar("scriptProfile")~="0") then
		SetCVar("scriptProfile", "0");
		ReloadUI();
	end
end

function DBM_CreateExtraMenuFrames(nrFrames,nrButtons)
	--[[
	for i=UIDROPDOWNMENU_MAXLEVELS+1,nrFrames do
		UIDropDownMenu_CreateFrames(i, 0);
	end]]--
	
	--[[
	local i,j;
	for i=3,nrFrames do
		--first check if frame exists
		if(not getglobal("DropDownList"..i)) then
			--Create the frame
			local frame = CreateFrame("Button","DropDownList"..i,UIParent,"UIDropDownListTemplate");
			frame:SetToplevel(true);
			frame:SetID(i);
			frame:SetFrameStrata("FULLSCREEN_DIALOG");
			frame:Hide();
		end
		--now add extra buttons if they dont exists
		for j=9,nrButtons do
			if(not getglobal("DropDownList"..i.."Button"..j)) then
				local frame = CreateFrame("Button","DropDownList"..i.."Button"..j,getglobal("DropDownList"..i),"UIDropDownMenuButtonTemplate");
				frame:SetID(j);
			end
		end
	end]]--
end

--[[
	********************************************************************
	********************************************************************
	Sync Functions
	********************************************************************
	********************************************************************
]]--

--[[ ********************************
		Position Sync
	 ********************************]]--

local pos_sync_table = {};
local pos_last_asked_sync = {};
local pos_send_my_until = 0;
local pos_dont_send_to_fast = 0;

local function send_position_sync()
	SetMapToCurrentZone();
	local x,y = GetPlayerMapPosition("player");
	local zone = GetRealZoneText();
	DBM_send_mess("MYPOS "..x.."@"..y.."@"..zone);
end

function DBM_PositionSync_OnUpdate()
	--runs 20 times each second
	if(pos_send_my_until > GetTime()) then
		--dont send to fast
		if(pos_dont_send_to_fast + 1 > GetTime()) then
			return;
		end
		pos_dont_send_to_fast = GetTime();
		--send
		send_position_sync();
	end
end

function DBM_PositionSyncRequest_Recive(msg,from)
	if(msg==DBM_YOU) then
		pos_send_my_until = GetTime()+8;
	end
end

function DBM_PositionSync_Recive(msg,from)
	local found,_,x,y,zone = string.find(msg,"(.+)@(.+)@(.+)");
	if(found) then
		pos_sync_table[from] = {
			x = tonumber(x),
			y = tonumber(y),
			zone = zone,
		};
	end
end

function DBM_GetPlayerMapPosition(uid)
	if(UnitExists(uid)) then
		--fix your own coords
		SetMapToCurrentZone();
		--get coords
		local x,y = GetPlayerMapPosition(uid);
		--if we got coords from blizz UI just pass them
		if(x+y > 0) then
			return x,y;
		end
		--get coords from sync
		local name = UnitName(uid);
		--check if we should ask for new sync
		if(not pos_last_asked_sync[name]) then pos_last_asked_sync[name] = 0; end --to be failsafe
		if(pos_last_asked_sync[name]+5 < GetTime()) then
			pos_last_asked_sync[name] = GetTime();
			DBM_send_mess("REQUESTPOS "..name);
		end
		--okay no fetch from table
		if(not pos_sync_table[name]) then
			--not updated yet or no DBM
			return 0,0;
		end
		--check if we are in same zone
		if(GetRealZoneText()==pos_sync_table[name].zone) then
			return pos_sync_table[name].x,pos_sync_table[name].y;
		else
			return 0,0;
		end
	end
	return GetPlayerMapPosition(uid);
end