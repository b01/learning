# API

## Authentication  via Connected APP

This section discusses how to authorize REST API access using a Connected App.
For more information see [Use Tableau Connected Apps for Application
Integration].

Follow these steps to set thing up so that you can begin making HTTP request
to access the REST API.

1. Create a connected app using one of the following methods:
   * [Configure Connected Apps with Direct Trust]
   * [Configure Connected Apps with OAuth 2.0 Trust]
2. Make a Personal Access Token (or PAT from here on), which is also required.
   It will serve ass the account used to access the API. For managing PATs, see
   [Site settings for personal access tokens].
   ![Personal Access Token (PAT) Settings](/tableau/pat-settings.png)
3. Generate a valid JWT—at runtime from your application, configured with the
   scopes you have included, see details at [Configure the JWT].
4. Make a [Sign In request] from your application using the JWT to return a
   Tableau credentials token and site ID (LUID)
   ```http request
   ### Auth with JWT via XML
   POST https://us-west-2b.online.tableau.com/api/3.16/auth/signin
   Content-Type: application/xml

   <tsRequest>
     <credentials jwt="{{jwt}}">
       <site contentUrl="{{contentUrl}}" />
     </credentials>
   </tsRequest>

   ```
5. Use the Tableau access token in subsequent requests—in subsequent REST API calls, use 1) the Tableau credentials token as the X-Tableau-Auth(Link opens in a new window) header value and 2) the site ID (LUID) in the request URI

## Connected Apps JWT

Signing in with a JSON Web Token (JWT), from a connected app

__added in Tableau Cloud June 2022 (API v3.16)__

[Connected apps JWT]

---

[Sign In request]: https://help.tableau.com/current/api/rest_api/en-us/REST/rest_api_ref_authentication.htm#sign_in

[Configure Connected Apps with Direct Trust]: https://help.tableau.com/current/online/en-us/connected_apps_direct.htm
[Configure Connected Apps with OAuth 2.0 Trust]: https://help.tableau.com/current/online/en-us/connected_apps_eas.htm
[Configure the JWT]: https://help.tableau.com/current/online/en-us/connected_apps_direct.htm#step-3-configure-the-jwt
[Connected apps JWT]: https://help.tableau.com/current/api/rest_api/en-us/REST/rest_api_ref_authentication.htm#connected-apps-jwt
[connected app]: https://help.tableau.com/current/online/en-us/connected_apps.htm
[Site settings for personal access tokens]: https://help.tableau.com/current/online/en-us/security_personal_access_tokens.htm?source=productlink#site-settings-for-personal-access-tokens
[Use Tableau Connected Apps for Application Integration]: https://help.tableau.com/current/online/en-us/connected_apps.htm?source=productlink