global function Spyglass_Init;

bool Spyglass_HasInitialized = false;

void function Spyglass_Init()
{
    nanoglassPrintt("Spyglass_Init() called.");
    AddCallback_OnClientConnected(OnClientConnected);
}

void function OnClientConnected(entity player)
{
    if (!IsValid(player) || !player.IsPlayer())
    {
        return;
    }

    SpyglassApi_QuerySanctionById(player.GetUID(), void function(Spyglass_SanctionSearchResult data) : (player) {
        if(data.ApiResult.Success == false) return
        if(!(player.GetUID() in data.Matches)) return
        foreach(sanction in data.Matches[player.GetUID()]){
            if(sanction.Type == Spyglass_InfractionType.Griefing ||
                sanction.Type == Spyglass_InfractionType.Exploiting ||
                sanction.Type == Spyglass_InfractionType.Cheating){
                    NSDisconnectPlayer(player, format("%s %s","Banned by Spyglass for", sanction.TypeReadable))
                    nanoglassPrintt(player.GetUID() + " was kicked for " + sanction.TypeReadable);
                }
        }
    })
}

void function nanoglassPrintt(string content) {
	printt(format("%s %s", "\x1b[38;2;255;255;255m[NANOGLASS]\x1b[0m", content))
}