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

    SpyglassApi_QuerySanctionById(player.GetUID(), void functionref(Spyglass_SanctionSearchResult) {
        
    })
}