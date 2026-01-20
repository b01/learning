# About

Things to know about dealing with Tableau.

When dealing with Authentication

* Fields in the post body are case-sensitive, so "Credentials" is different from "credentials" and would be considered an unknown field.
* Despite what the documentation says, you MUST set the "Accept" HTTP header to set the return type to JSON, otherwise you get XML.
* You MUST specify the correct Pod name when logging in, otherwise it may fail even if you use the correct username and password.
* When you enable MFA, currently the only way to login in is with a Personal Access Token (PAT).
* Tableau has an old-school auth system that allows you to login without having to use OIDC. It allows Tableau administrators to set up users and groups in Tableau and use that instead of LDAP or Active directory.

## Embedding API v3 interfaces

The Embedding API v3 provides a rich set of interfaces. See [About the Embedding API v3]

1. The top-level object is the Viz object.
2. You can create, or instantiate, a Viz object as either a TableauViz object (to embed a view) or a TableauAuthoringViz object (to embed a web authoring view).
3. From the Viz object, you can access all the workbooks, sheets, methods, and properties contained in the Viz object.
4. You can also embed a view or a web authoring view using the Tableau web components (<tableau-viz> and <tableau-authoring-viz>). Using a <tableau-viz> web component is the simplest way to embed a view into a page and to initialize the Embedding API.
5. To give clients access to their views that are not public you can make a "Connected App" and retrieve a JWT token, which needs to be set on the web component as an HTML attribute or usings JS to set its `token` property. They give examples of how to retrieve a token using code written in Python. It suggests you can make a backend API endpoint and use JS to retrieve the token. Storing it in a cookie seems to be the option of choice since the token will be needed for subsequent calls to the Embed API on the frontend.


### How To Implement

The following sites would provide a comprehensive understanding and a quick
primer of how to implement embedding with authentication as of 2025/02/04.

1. [About the Embedding API v3]
2. [Basic Embedding]
3. [Authentication and Embedded Views]
4. [Customize and Control Data Access Using User Attributes]
5. [Query User On Site] - get a user by their user ID.
6. [Pass the JWT to the Tableau web component]
7. [Configure Embedding Objects and Components]
8. [Embedding API]
9. [REST API and Resource Versions]
10. [Access Scopes for Connected Apps]
11. [Configure Connected Apps with Direct Trust]
12. [Troubleshoot Connected Apps - Direct Trust]
13. [Handling Errors in the REST API]

## Resources

* [IP addresses for Tableau Cloud]
* [Tableau Cloud tips: Extracts, live connections, & cloud data]

---

[About the Embedding API v3]: https://help.tableau.com/current/api/embedding_api/en-us/docs/embedding_api_about.html
[Basic Embedding]: https://help.tableau.com/current/api/embedding_api/en-us/docs/embedding_api_basic.html
[Authentication and Embedded Views]: https://help.tableau.com/current/api/embedding_api/en-us/docs/embedding_api_auth.html
[Customize and Control Data Access Using User Attributes]: https://help.tableau.com/current/api/embedding_api/en-us/docs/embedding_api_user_attributes.html
[Query User On Site]: https://help.tableau.com/current/api/rest_api/en-us/REST/rest_api_ref_users_and_groups.htm#query_user_on_site
[Configure Embedding Objects and Components]: https://help.tableau.com/current/api/embedding_api/en-us/docs/embedding_api_configure.html
[Embedding API]: https://help.tableau.com/current/api/embedding_api/en-us/reference/
[REST API and Resource Versions]: https://help.tableau.com/current/api/rest_api/en-us/REST/rest_api_concepts_versions.htm
[Access Scopes for Connected Apps]: https://help.tableau.com/current/online/en-us/connected_apps_scopes.htm
[Pass the JWT to the Tableau web component]: https://help.tableau.com/current/api/embedding_api/en-us/docs/embedding_api_auth.html#pass-the-jwt-to-the-tableau-web-component
[Troubleshoot Connected Apps - Direct Trust]: https://help.tableau.com/current/online/en-us/connected_apps_troubleshoot.htm
[Handling Errors in the REST API]: https://help.tableau.com/current/api/rest_api/en-us/REST/rest_api_concepts_errors.htm
[Configure Connected Apps with Direct Trust]: https://help.tableau.com/current/online/en-us/connected_apps_direct.htm
[IP addresses for Tableau Cloud]: https://help.tableau.com/current/online/en-us/to_keep_data_fresh.htm#ip-addresses-for-tableau-cloud
[Tableau Cloud tips: Extracts, live connections, & cloud data]: https://www.tableau.com/blog/tableau-cloud-tips-extracts-live-connections-cloud-data
