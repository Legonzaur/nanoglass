/**
 * This is the Spyglass API wrapper for this mod.
 * Feel free to call functions in your own mods if required!
 * Try to be mindful of the backend however, as you'll potentially get ratelimited or blacklisted for abuse.
 * Controller: /
 */

global function SpyglassApi_MakeHttpRequest;

/**
 * Wraps NSHttpRequest() to setup special headers in a request, and capture responses for processing.
 * @param request The parameters to use for this request.
 * @param onSuccess The callback to execute if the request is successful.
 * @param onFailure The callback to execute if the request has failed.
 * @param withAuthorization Whether or not to require the Authorization header using the spyglass_api_token convar.
 * @returns Whether or not the request has been successfully started.
 */
bool function SpyglassApi_MakeHttpRequest(HttpRequest request, void functionref(HttpRequestResponse) onSuccess = null, void functionref(HttpRequestFailure) onFailure = null, bool withAuthorization = false)
{
    if (Spyglass_IsDisabled())
    {
        CodeWarning(format("[Spyglass] HTTP request to '%s' aborted, disabled to due error.", request.url));
        return false;
    }

    SpyglassApi_SetupHeaders(request);

    if (withAuthorization)
    {
        string token = Spyglass_GetApiToken();
        if (token.len() == 0)
        {
            printt(format("[Spyglass] Attempted to make authenticated API call to '%s', but we don't have any API token setup.", request.url));
            return false;
        }

        if (!("Authorization" in request.headers))
        {
            request.headers["Authorization"] <- [format("Bearer %s", token)];
        }
        else
        {
            request.headers["Authorization"] = [format("Bearer %s", token)];
        }
    }

    // Wrap the success callback to capture headers.
    void functionref(HttpRequestResponse) responseCapture = void function (HttpRequestResponse response) : (onSuccess)
    {
        if (response.statusCode == 200)
        {
            SpyglassApi_ParseVersionHeaders(response);
        }

        if (onSuccess != null)
        {
            onSuccess(response);
        }
    }

    return NSHttpRequest(request, responseCapture, onFailure);
}