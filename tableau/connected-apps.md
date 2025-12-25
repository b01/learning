# Connected Apps

Connected apps allow you to establish a connections to Tableau allowing
application integration.

The benefits is that you now have a secret that does not expire and is NOT
tied to a single user. However, you are still limited to user permissions
since you use their email as the means to impersonate them, though the
documentation does not call it impersonation.

A downside to using a connected app is that not all API endpoints work
with it. For example, at the time of writing, Listing personal access tokens
are not allowed with a Connected App. It does not say this directly, but there
is no JWT scope for that endpoint, which infers it.

## Gotcha

You cannot use a Connected Apps with the TCM REST API either, severely limiting
what you app can do.