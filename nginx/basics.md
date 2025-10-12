# Nginx

[location] directive

A location can either be defined by a prefix string, or by a regular expression.
* `=` - Define an exact match of URI and location.
* `~*` - Regular expressions for case-insensitive matching.
* `~` - Regular expressions for case-sensitive matching.

## Proxy Pass Notes

Figure 1-A

```nginx
    location /api/ {
       
        proxy_pass https://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
```

When using `location` with `proxy_pass` normally the part that matched the
location will be appended to the proxy_pass value of "https://backend" so that
it will become "https://backend/api/...". Appending anything to the _path_ part
of the proxy_pass value of "https://backend" will replace "/api/" so that the
backend only sees the replacement and follows
after /api/.

For example setting proxy_pass https://backend/ will replace "/api/" with "/"
and whatever followed after. So that "https://backend/api/schema.json" becomes
"https://backend/schema.json".


[error_page]

```nginx
# Random comment
server {
    charset     utf-8;
    http2       on;
    listen      8443 ssl;
    listen      [::]:8443 ssl default_server;
    root        /usr/share/nginx/html;
    server_name _;

    ssl_certificate           "/var/lib/nginx/pki/certs/server.crt";
    ssl_certificate_key       "/var/lib/nginx/pki/private/server.key";
    ssl_protocols             TLSv1.3;
    ssl_ciphers               HIGH:!aNULL:!MD5;
    ssl_prefer_server_ciphers on;

    location = /favicon.ico {
        return 204;
        access_log     off;
        log_not_found  off;
    }

    # For debugging 50x errors.
    location ~* /((\d+)x?)\.html$ {
        try_files /errors/$1.html /errors/$2.html =500;
    }

    error_page 404 /errors/404.html;
    error_page 500 502 503 504 = @500_errors;

    location @errors {
        internal;
        try_files $uri /errors/$uri.html /errors/50x.html =500;
    }

    # match "/" and return index.html
    location = / {
        try_files /index.html =404;
    }

    # match any request and return static content if it exists.
    location / {
        try_files $uri =404;
    }

    # Handle all dynamic content.
    location ~* /api/|\.html {
        # appending anything to the proxy_pass "https://backend" will replace
        # "/api/" so that the backend only sees the replacement and what follows
        # after /api/.
        # For example setting proxy_pass https://backend/ will replace "/api/"
        # with "/" and whatever followed after.
        proxy_pass https://backend:8443;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## Set a Cookie

Not sure how practical this is, but you can set a cookie when the browser
request a static content page.

To use this with a Lambda, you'd need to use something like a CloudFront Edge
function.

```nginx
server {
    # Case sensitive match begins with `~` and case-insensitive `~*` double
    # quotes help use literal spaces in the match.
    location ~* ^/p/([a-zA-Z0-9\s\-_]+)$ {
        # always return the index.html, which is the login page file URLs of:
        # /p/company%20name
        #see https://nginx.org/en/docs/http/ngx_http_core_module.html#try_files
        try_files $uri /index.html

        # Parse the company name out of the URI and set it as a cookie so
        # JavaScript can pick it up and set it in the form.
        add_header X-Partner $1;
        add_header Set-Cookie "partner=$1; Path=/; Domain=; Secure; SameSite=Strict; Expires=60;";
    }
}
```

---

[location]: https://nginx.org/en/docs/http/ngx_http_core_module.html#location
[error_page]: https://nginx.org/en/docs/http/ngx_http_core_module.html#error_page