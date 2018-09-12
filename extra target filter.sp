#pragma newdecls required
#pragma semicolon 1

#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>

//--------------------//

public Plugin myinfo = 
{
	name = "Some Additional Filters",
	author = "Cruze",
	description = "Adds new filters to commands:= @r,@rct,@rt,@admins,@!admins",
	version = "1.0",
	url = ""
}

public void OnPluginStart()
{
	AddMultiTargetFilter("@random", TargetRandom, "Random player", false);
	AddMultiTargetFilter("@r", TargetRandom, "Random player", false);
	AddMultiTargetFilter("@randomt", TargetRandomT, "Random player on T", false);
	AddMultiTargetFilter("@rt", TargetRandomT, "Random player on T", false);
	AddMultiTargetFilter("@randomct", TargetRandomCT, "Random player on CT", false);
	AddMultiTargetFilter("@rct", TargetRandomCT, "Random player on CT", false);
	AddMultiTargetFilter("@admins", Filter_Admins, "All Admins", false);
	AddMultiTargetFilter("@!admins", Filter_NotAdmins, "All Non-Admins", false);
}

public void OnPluginEnd()
{
	RemoveMultiTargetFilter("@random", TargetRandom);
	RemoveMultiTargetFilter("@r", TargetRandom);
	RemoveMultiTargetFilter("@randomt", TargetRandomT);
	RemoveMultiTargetFilter("@rt", TargetRandomT);
	RemoveMultiTargetFilter("@randomct", TargetRandomCT);
	RemoveMultiTargetFilter("@rct", TargetRandomCT);
	RemoveMultiTargetFilter("@admins", Filter_Admins);
	RemoveMultiTargetFilter("@!admins", Filter_NotAdmins);
}

public bool TargetRandom(const char[] pattern, Handle clients)
{
	if (GetClientCount() < 1) return false;
	int client;
	do
	{
		client = GetRandomInt(1, MaxClients);
	}
	while(!IsClientInGame(client));
	PushArrayCell(clients, client);
	return true;
}

public bool TargetRandomCT(const char[] pattern, Handle clients)
{
	if (GetTeamClientCount(view_as<int>(CS_TEAM_CT)) < 1) 
		return false;
	int client;
	do
	{
		client = GetRandomInt(1, MaxClients);
	}
	while(!IsClientInGame(client) || GetClientTeam(client) != CS_TEAM_CT);
	PushArrayCell(clients, client);
	return true;
}

public bool TargetRandomT(const char[] pattern, Handle clients)
{
	if (GetTeamClientCount(view_as<int>(CS_TEAM_T)) < 1) 
		return false;
	int client;
	do
	{
		client = GetRandomInt(1, MaxClients);
	}
	while(!IsClientInGame(client) || GetClientTeam(client) != CS_TEAM_T);
	PushArrayCell(clients, client);
	return true;
}
public bool Filter_Admins(char[] pattern, Handle clients)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsValidClient(i) && CheckCommandAccess(i, "sm_admin", ADMFLAG_GENERIC, true))
		{
			PushArrayCell(clients, i);
		}
	}
	return true;
}

public bool Filter_NotAdmins(char[] pattern, Handle clients)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(IsValidClient(i) && !CheckCommandAccess(i, "sm_admin", ADMFLAG_GENERIC, true))
		{
			PushArrayCell(clients, i);
		}
	}
	return true;
}

bool IsValidClient(int client, bool bIncludeBots = false)
{
	if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (!IsFakeClient(client) && !bIncludeBots))
	{
		return false;
	}
	return true;
}
