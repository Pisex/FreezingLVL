#pragma newdecls required
#pragma semicolon 1

#include <FirePlayersStats>
#include <sourcemod>
#include <clientprefs>

Handle
	g_hCookie;

int g_bEnable[MAXPLAYERS+1];

public void OnPluginStart()
{
    g_hCookie = RegClientCookie("FPS_Stoping_Points", "FPS_Stoping_Points", CookieAccess_Private);
    if (FPS_StatsLoad()) FPS_OnFPSStatsLoaded();
}

public void OnClientPostAdminCheck(int iClient)
{
    char sResult[8];
    GetClientCookie(iClient,g_hCookie,sResult,sizeof sResult);
    g_bEnable[iClient] = StringToInt(sResult);
}

public void FPS_OnFPSStatsLoaded()
{
    FPS_AddFeature("FPS_Stoping", FPS_ADVANCED_MENU, OnItemSelect, OnItemDisplay);
}

public bool OnItemSelect(int iClient)
{
    g_bEnable[iClient] = !g_bEnable[iClient];
    return true;
}

public bool OnItemDisplay(int iClient, char[] szDisplay, int iMaxLength)
{
    FormatEx(szDisplay, iMaxLength, "%s", (!g_bEnable[iClient]) ? "Заморозка опыта [Выключено]" : "Заморозка опыта [Включено]");
    return true;
}

public Action FPS_OnPointsChangePre(int iAttacker, int iVictim, Event hEvent, float &fPointsAttacker, float &fPointsVictim)
{
    bool bBool;
    if(g_bEnable[iAttacker])
    {
        fPointsAttacker = 0.0;
        bBool = true;
    }
    if(g_bEnable[iVictim])
    {
        fPointsVictim = 0.0;
        bBool = true;
    }
    if(bBool) return Plugin_Changed;
    return Plugin_Continue;
}

public void OnClientDisconnect(int iClient)
{
    char sResult[8];
    IntToString(g_bEnable[iClient],sResult,sizeof sResult);
    SetClientCookie(iClient,g_hCookie,sResult);
}