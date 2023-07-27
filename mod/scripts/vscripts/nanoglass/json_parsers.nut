globalize_all_functions

/**
 * Tries to parse the given key's value into a boolean from the provided table.
 * @param data The table to get the key's value from.
 * @param key The key to retrieve the value for.
 * @returns True if we parsed it successfully, false otherwise.
 */
bool function Spyglass_TryParseBool(table data, string key)
{
    if (!(key in data))
    {
        return false;
    }

    var value = data[key];
    if (typeof value == "bool")
    {
        return true;
    }

    return false;
}

/**
 * Tries to parse the given key's value into a string from the provided table.
 * @param data The table to get the key's value from.
 * @param key The key to retrieve the value for.
 * @returns True if we parsed it successfully, false otherwise.
 */
bool function Spyglass_TryParseString(table data, string key)
{
    if (!(key in data))
    {
        return false;
    }

    var value = data[key];
    if (typeof value == "string")
    {
        return true;
    }

    return false;
}

/**
 * Tries to parse the given key's value into an int from the provided table.
 * @param data The table to get the key's value from.
 * @param key The key to retrieve the value for.
 * @returns True if we parsed it successfully, false otherwise.
 */
bool function Spyglass_TryParseInt(table data, string key)
{
    if (!(key in data))
    {
        return false;
    }

    var value = data[key];
    if (typeof value == "int")
    {
        return true;
    }

    return false;
}

/**
 * Tries to parse the given key's value into a float from the provided table.
 * @param data The table to get the key's value from.
 * @param key The key to retrieve the value for.
 * @returns True if we parsed it successfully, false otherwise.
 */
bool function Spyglass_TryParseFloat(table data, string key)
{
    if (!(key in data))
    {
        return false;
    }

    var value = data[key];
    if (typeof value == "float")
    {
        return true;
    }

    return false;
}

/**
 * Tries to parse the given key's value into a table from the provided table.
 * @param data The table to get the key's value from.
 * @param key The key to retrieve the value for.
 * @returns True if we parsed it successfully, false otherwise.
 */
bool function Spyglass_TryParseTable(table data, string key)
{
    if (!(key in data))
    {
        return false;
    }

    var value = data[key];
    if (typeof value == "table")
    {
        return true;
    }

    return false;
}


/**
 * Tries to parse the given key's value into an array from the provided table.
 * @param data The table to get the key's value from.
 * @param key The key to retrieve the value for.
 * @returns True if we parsed it successfully, false otherwise.
 */
bool function Spyglass_TryParseArray(table data, string key)
{
    if (!(key in data))
    {
        return false;
    }

    var value = data[key];
    if (typeof value == "array")
    {
        return true;
    }

    return false;
}

/**
 * Tries to parse the given API response into a Spyglass_ApiResult struct.
 * @param response The decoded JSON response from the API.
 * @param outResult The parsed Spyglass_ApiResult struct on success.
 * @returns True if we've parsed the response successfully (check the ApiResult field first!).
 */
bool function Spyglass_TryParseApiResult(table response, Spyglass_ApiResult outResult)
{
    outResult.Success = false;
    outResult.Error = "Failed to parse API response into a Spyglass_ApiResult struct.";

    if (Spyglass_TryParseBool(response, "success"))
    {
        outResult.Success = expect bool(response["success"]);

        if (!outResult.Success)
        {
            if (Spyglass_TryParseString(response, "error"))
            {
                outResult.Error = expect string(response["error"]);
            }
            else
            {
                return false;
            }
        }

        return true;
    }

    return false;
}

/**
 * Tries to parse the given API response into a Spyglass_PlayerInfraction struct.
 * @param response The decoded JSON response from the API.
 * @param outInfraction The parsed Spyglass_PlayerInfraction struct on success.
 * @returns True if we've parsed the response successfully.
 */
bool function Spyglass_TryParsePlayerInfraction(table response, Spyglass_PlayerInfraction outInfraction)
{
    if (response.len() == 0)
    {
        return false;
    }

    bool success = Spyglass_TryParseInt(response, "id");
    success = success && Spyglass_TryParseString(response, "uniqueId");
    success = success && Spyglass_TryParseString(response, "issuerId");
    success = success && Spyglass_TryParseInt(response, "issuedAtTimestamp");
    success = success && Spyglass_TryParseString(response, "issuedAtReadable");
    success = success && Spyglass_TryParseString(response, "expiresAtReadable");
    success = success && Spyglass_TryParseString(response, "reason");
    success = success && Spyglass_TryParseInt(response, "type");
    success = success && Spyglass_TryParseString(response, "typeReadable");
    success = success && Spyglass_TryParseInt(response, "punishmentType");
    success = success && Spyglass_TryParseString(response, "punishmentReadable");

    if (success)
    {
        outInfraction.ID = expect int(response["id"]);
        outInfraction.UniqueId = expect string(response["uniqueId"]);

        if (Spyglass_TryParseTable(response, "owningPlayer"))
        {
            table owner = expect table(response["owningPlayer"]);
            Spyglass_PlayerInfo parsedOwner;

            if (Spyglass_TryParsePlayerInfo(owner, parsedOwner))
            {
                outInfraction.OwningPlayer = parsedOwner;
            }
        }

        outInfraction.IssuerId = expect string(response["issuerId"]);

        if (Spyglass_TryParseTable(response, "issuerInfo"))
        {
            table issuer = expect table(response["issuerInfo"]);
            Spyglass_PlayerInfo parsedIssuer;

            if (Spyglass_TryParsePlayerInfo(issuer, parsedIssuer))
            {
                outInfraction.IssuerInfo = parsedIssuer;
            }
        }

        outInfraction.IssuedAtTimestamp = expect int(response["issuedAtTimestamp"]);
        outInfraction.IssuedAtReadable = expect string(response["issuedAtReadable"]);

        if (Spyglass_TryParseInt(response, "expiresAtTimestamp"))
        {
            outInfraction.ExpiresAtTimestamp = expect int(response["expiresAtTimestamp"]);
        }
        else
        {
            outInfraction.ExpiresAtTimestamp = null;
        }

        outInfraction.ExpiresAtReadable = expect string(response["expiresAtReadable"]);
        outInfraction.Reason = expect string(response["reason"]);
        outInfraction.Type = expect int(response["type"]);
        outInfraction.TypeReadable = expect string(response["typeReadable"]);
        outInfraction.PunishmentType = expect int(response["punishmentType"]);
        outInfraction.PunishmentReadable = expect string(response["punishmentReadable"]);

        return true;
    }

    return false;
}

/**
 * Tries to parse the given API response into a Spyglass_SanctionSearchResult struct.
 * @param response The decoded JSON response from the API.
 * @param outResult The parsed Spyglass_SanctionSearchResult struct on success.
 * @returns True if we've parsed the response successfully.
 */
bool function Spyglass_TryParseSanctionSearchResult(table response, Spyglass_SanctionSearchResult outResult)
{
    outResult.ApiResult.Success = false;
    outResult.ApiResult.Error = "Failed to parse API response into a Spyglass_SanctionSearchResult struct.";

    if (response.len() == 0)
    {
        return false;
    }

    Spyglass_ApiResult parsedResult;
    if (!Spyglass_TryParseApiResult(response, parsedResult))
    {
        return false;
    }

    outResult.ApiResult.Success = parsedResult.Success;
    outResult.ApiResult.Error = parsedResult.Error;

    if (!outResult.ApiResult.Success)
    {
        return true;
    }

    outResult.UniqueIDs = [];
    outResult.Matches = {};
    outResult.Id = -1;

    if (Spyglass_TryParseArray(response, "uniqueIDs"))
    {
        foreach (var value in expect array(response["uniqueIDs"]))
        {
            if (typeof value == "string")
            {
                outResult.UniqueIDs.append(expect string(value));
            }
        }
    }
    else if (Spyglass_TryParseInt(response, "id"))
    {
        outResult.Id = expect int(response["id"]);
    }
    else
    {
        return false;
    }

    if (Spyglass_TryParseTable(response, "matches"))
    {
        table matches = expect table(response["matches"]);

        foreach (var key, var value in matches)
        {
            if (typeof key == "string" && typeof value == "array")
            {
                string uid = expect string(key);
                array values = expect array(value);

                outResult.Matches[uid] <- [];

                foreach (var infraction in values)
                {
                    Spyglass_PlayerInfraction outInfraction;
                    if (typeof infraction == "table" && Spyglass_TryParsePlayerInfraction(expect table(infraction), outInfraction))
                    {
                        outResult.Matches[uid].append(outInfraction);
                    }
                }
            }
        }
    }

    return true;
}