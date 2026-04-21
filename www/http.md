# HTTP

## Date header

The HTTP Date request and response header contains the date and time at which the message originated.

It is forbidden in the Request header.

Also, HTTP cookies use this date for the Expire attribute.

### Syntax

```text
Date: <day-name>, <day> <month> <year> <hour>:<minute>:<second> GMT
```

### Example

```http request
HTTP/1.1 200
Content-Type: text/html
Date: Tue, 29 Oct 2024 16:56:32 GMT
```

**Source:** [Date header]

---

[Date header]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Date