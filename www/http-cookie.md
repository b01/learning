# HTTP Cookie

Setting HTTP cookies can be tricky because they are simple but the docs are way
too long. And today we just don't have the patience. So TLDR.

1. You set a cookie in an HTTP response using the `Set-Cookie` header, that's
   it, that is the only way.
2. When you update an HTTP cookie, just set all the values you set before,
   updating any previous values to what you want. Yes just overwrite it. That
   is the fool-proof way in any language.
3. To delete a cookie, set `Expire` to a datetime in the past, and `Max-Age` to
   `-1`; set the value to an empty string to scrub the data.
4. Setting the `Domain` attribute:
   1. Leave it blank to login it down to a specific site.
   2. You should only set it to same domain that is responding to the HTTP
      request, doing so
      1. Make it available to that domain for use.
      2. Allows it to be shared among all subdomains.
      3. Use this when you want to share it among multiple domains, for example:
         to allow `example.com` and `www.example.com` to share cookies, set
         the HTTP cookie `Domain` to "example.com".
5. Set `Expire` to a date of format `Tue, 29 Oct 2024 16:56:32 GMT`.
6. Set `Max-Age` to seconds in the future, so 600 for 10 minutes.
7. `Max-Age` beats (has precedence over) Expire date. So if cookie has an
   `Expire` date that is a year in the future, and a `Max-Age` of 600 (seconds,
   aka 10 minutes) in the future, the cookie will be deleted in 10 minutes.
8. Set `HttpOnly` to keep the browser from letting JavaScript modify the cookie.
   This is great if you store session IDs in cookies.
9. Set `Secure` to true, just because you should.
10. Set `Path` to `/` to have it available to the entire site. Anything else
    makes the cookie available to only that specific endpoint. Which can be a
    security measure if you can make good use of it.
    NOTE: If you don't deal cookies too often, this can be a pain point. Setting
    it to a specific path (endpoint) can make it seem like your cookies are not
    being set on other pages. When you're not sure, then check the `Path` value
    and make sure it has a value for the page(s) you want to read it at.
11. Set `SameSite` to `Strict` unless you know what your doing otherwise.