#pragma newdecls required
#pragma semicolon 1

#include <lvl_ranks>
#include <sourcemod>
#include <clientprefs>

Handle
	g_hCookie;

int g_bEnable[MAXPLAYERS+1];

public void OnPluginStart()
{
    if(LR_IsLoaded()) LR_OnCoreIsReady();
    g_hCookie = RegClientCookie("LR_Stoping_Points", "LR_Stoping_Points", CookieAccess_Private);
}

public void OnClientPostAdminCheck(int iClient)
{
    char sResult[8];
    GetClientCookie(iClient,g_hCookie,sResult,sizeof sResult);
    g_bEnable[iClient] = StringToInt(sResult);
}

public void LR_OnCoreIsReady()
{
    LR_Hook(LR_OnExpChangedPre, CallBack_OnExpChangedPre);
    LR_MenuHook(LR_SettingMenu, LR_OnMenuCreated, LR_OnMenuItemSelected);
}

public Action CallBack_OnExpChangedPre(int iClient, int &iExp)
{
    if(g_bEnable[iClient])
    {
        iExp = 0;
        return Plugin_Changed;
    }
    return Plugin_Continue;
}

void LR_OnMenuCreated(LR_MenuType OnMenuCreated, int iClient, Menu hMenu)
{
	hMenu.AddItem("Stoping", (!g_bEnable[iClient]) ? "Заморозка опыта [Выключено]" : "Заморозка опыта [Включено]");
}

void LR_OnMenuItemSelected(LR_MenuType OnMenuCreated, int iClient, const char[] sInfo)
{
	if(!strcmp(sInfo, "Stoping"))
	{
		g_bEnable[iClient] = !g_bEnable[iClient];
		LR_ShowMenu(iClient, LR_SettingMenu);
	}
}

public void OnClientDisconnect(int iClient)
{
    char sResult[8];
    IntToString(g_bEnable[iClient],sResult,sizeof sResult);
    SetClientCookie(iClient,g_hCookie,sResult);
}