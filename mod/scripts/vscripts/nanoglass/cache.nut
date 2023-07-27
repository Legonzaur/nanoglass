/**
 * This file holds globals and functions to access them.
 * Loaded first so all other files can access these when required.
 */
global function Nanoglass_CachePlayers;
global function Spyglass_GetConVarStringArray;
global function Nanoglass_GetAllowedPlayers;
global function Nanoglass_GetBannedPlayers;


table<string, number> Nanoglass_Allowed = {};
table<string, number> Nanoglass_Banned = {};

/** Caches the currently connected players in a convar, in order to keep them connected after map change. */
void function Nanoglass_CachePlayers()
{
    string cache = "";

    foreach (entity player in Spyglass_GetAllPlayers())
    {
        if (IsValid(player) && player.IsPlayer() && Spyglass_IsConnected(player.GetUID()))
        {
            cache = format("%s%s,", cache, player.GetUID());
        }
    }

    SetConVarString("spyglass_cache_connected_players", cache);
}

table<string, number> Nanoglass_GetAllowedPlayers(){
    return Nanoglass_Allowed
}

table<string, number> Nanoglass_GetBannedPlayers(){
    return Nanoglass_Banned
}

/** Splits the value of the given string convar into an array, using commas as a separator. */
array<string> function Spyglass_GetConVarStringArray(string cvarName)
{
    string clean = strip(GetConVarString(cvarName));
    return split(clean, ",");
}