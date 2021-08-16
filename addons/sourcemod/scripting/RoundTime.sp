#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "RoundTime",
	author = "BotoX",
	description = "Change roundtime instantly and remove limit.",
	version = "1.0",
	url = ""
}

ConVar g_CVar_mp_roundtime;

public void OnPluginStart()
{
	g_CVar_mp_roundtime = FindConVar("mp_roundtime");
	g_CVar_mp_roundtime.SetBounds(ConVarBound_Upper, true, 546.0); // empirically determined
	g_CVar_mp_roundtime.AddChangeHook(OnConVarChanged);
}

public void OnConVarChanged(ConVar convar, const char[] oldValue, const char[] newValue)
{
	GameRules_SetProp("m_iRoundTime", StringToInt(newValue) * 60);
}
