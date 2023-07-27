global function Spyglass_Init;

bool Spyglass_HasInitialized = false;

void function Spyglass_Init()
{
    printt("[Nanoglass] Spyglass_Init() called.");
    AddCallback_OnClientConnected(OnClientConnected);
}

void function OnClientConnected(entity player)
{
    if (!IsValid(player) || !player.IsPlayer())
    {
        return;
    }

    SpyglassApi_QuerySanctionById(player.GetUID(), void function(Spyglass_SanctionSearchResult data) {
        if(data.Success == false) return
        if(!(player.GetUID() in data.Matches)) return
        foreach(sanction in data.Matches[player.GetUID()]){
            if(sanction.PunishmentType == )
        }
    })
}