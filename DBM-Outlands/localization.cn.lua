-- ------------------------------------------- --
--   Deadly Boss Mods - Chinese localization   --
--    by Diablohu<白银之手> @ 二区-轻风之语    --
--              www.dreamgen.cn                --
--                 12/7/2007                   --
-- ------------------------------------------- --

if (GetLocale() == "zhCN") then


-- LordKazzak
	DBM_KAZZAK_NAME				= "末日领主卡扎克";
	DBM_KAZZAK_DESCRIPTION		= "警报激怒、卡扎克的印记和扭曲反射";
	DBM_KAZZAK_OPTION_1			= "警报激怒";
	DBM_KAZZAK_OPTION_2			= "警报扭曲反射";
	DBM_KAZZAK_OPTION_3			= "警报卡扎克的印记";
	DBM_KAZZAK_OPTION_4			= "添加标注";
	DBM_KAZZAK_OPTION_5			= "密语玩家";

	DBM_KAZZAK_TWISTED			= "([^%s]+)受([^%s]+)扭曲反射效果的影响。";
	DBM_KAZZAK_MARK				= "([^%s]+)受([^%s]+)卡扎克的印记效果的影响。";
	DBM_KAZZAK_YELL_PULL		= "所有的凡人都将灭亡!";
	DBM_KAZZAK_YELL_PULL2		= "军团将会征服一切！";
	DBM_KAZZAK_EMOTE_ENRAGE		= "%s变得愤怒了！";

	DBM_KAZZAK_SUP_SEC			= "*** %s秒后激怒 ***";
	DBM_KAZZAK_SUP_SOON			= "*** 即将激怒 ***";
	DBM_KAZZAK_TWISTED_WARN		= "*** 扭曲反射 -> >%s< ***";
	DBM_KAZZAK_MARK_WARN		= "*** 卡扎克的印记 -> >%s< ***";
	DBM_KAZZAK_WARN_ENRAGE		= "*** 激怒 ***";
	DBM_KAZZAK_MARK_SPEC_WARN	= "你变成了炸弹！";
	
	DBM_SBT["Enrage"]			= "激怒";
	DBM_SBT["Mark of Kazzak"]	= "卡扎克的印记";


-- Doomwalker
	DBM_DOOMW_NAME			= "末日行者";
	DBM_DOOMW_DESCRIPTION	= "警报地震术";
	DBM_DOOMW_OPTION_1		= "显示距离框体";
	DBM_DOOMW_OPTION_2		= "警报地震术";
	DBM_DOOMW_OPTION_3		= "警报泛滥";

	DBM_DOOMW_CAST_QUAKE	= "受到了地震术效果的影响";
	DBM_DOOMW_CAST_CHARGE	= "末日行者开始施放泛滥。";
	DBM_DOOMW_EMOTE_ENRAGE	= "%s变得愤怒了！";

	DBM_DOOMW_QUAKE_WARN	= "*** 地震术 ***";
	DBM_DOOMW_QUAKE_SOON	= "*** 地震术 - 即将施放 ***";
	DBM_DOOMW_CHARGE		= "*** 泛滥 ***";
	DBM_DOOMW_CHARGE_SOON	= "*** 泛滥 - 即将施放 ***";
	DBM_DOOMW_WARN_ENRAGE	= "*** 激怒 ***";
	
	DBM_SBT["Overrun Cooldown"]		= "泛滥冷却";
	DBM_SBT["Earthquake Cooldown"]	= "地震术冷却";
	DBM_SBT["Earthquake"]			= "地震术";
	

end
