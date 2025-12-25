# Personal Access Tokens

PATs

## Impersonating user using PAT

This ONLY works with Tableau Server according to the documentation as of writing
on 12/25/2025.

Signing in with server administrator's PAT to impersonate a user (Tableau Server only):

```xml
<tsRequest>
<credentials personalAccessTokenName="personal-access-token-name"
    personalAccessTokenSecret="personal-access-token-secret" >
	  <site contentUrl="content-url" />
	  <user id="user-to-impersonate" />
  </credentials>
</tsRequest>
```

## Gotcha

* PATs are automatically revoked when a user's authentication method is changed.
* Users cannot request concurrent Tableau Cloud sessions with a PAT. Signing in
  again with the same PAT, whether at the same site or a different site, will
  terminate the previous session and result in an authentication error.
* Personal access tokens (PATs) expire if not used after 15 consecutive days,
  otherwise their expiration depends on the PAT's site setting in Tableau Cloud.
* As a site admin, you can configure PATs, the changes that you make apply only
  to new PATs.
* PATs can be configured to expire 1 through 365 days.
* Site admins can't create PATs for users. Your users must create their own
  PATs.
* Users with accounts on Tableau Cloud can create, manage, and revoke PATs on
  the **My Account Settings page** (unless the site admins only allow a
  select group of users or non-at all). A user can have up to 104 PATs.
* If you have Tableau Cloud with Advanced Management, you can use
  **Activity Log** to monitor PATs usage.
* A site admin can revoke a user's PAT.