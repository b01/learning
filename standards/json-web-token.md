# JSON Web Token

## Preface

JWT for short are how we are exchanging information on the Internet currently,
mainly for authorization. I'm finding other good uses for it as weil, like
storing the unique ID in an HTTP cookie, where only the application has the
key/pair to encrypt and decode them. Making my cookies even more secure.

Unfortunately with every vendor I find inconsistencies. Thankfully there is a
standard for it at [RFC 7519 - JSON Web Token (JWT)], and for each type of JWT:
* [RFC 7516 - JSON Web Encryption (JWE)]
* [RFC 7515 - JSON Web Signature (JWS)]

When developing with multiple systems, I can't stress enough how important good
documentation can help in many ways. And RFCs are some of the best there is,
though it may take some getting used to reading at that level. Its worth the
churn reduction and ROI you get from doing so. so I've been addressing more RFCs
directly, like I did when I began so many years ago.

Building JWTs according to the examples out there should be easy. It is the
libraries that I find to be barrier. More specifically their API. I have found
it is usually the most popular/default lib for a language that is the most
difficult to comprehend and cumbersome to implement. I hypothesize that is the
reason for the sheer number of libraries there are for working with JWTs in each
language. Which you can see here: https://jwt.io/libraries

To make matters worse, I've built my own. The only justification for my library
is that I try to make the API intuitive. The code you need to write should allow
you to copy and paste pseudocode examples you see on the web, and with minimal
change, have them work with my library. So it is as if what you read actually
works in code as well. Making transitioning from learning/reading to coding
smooth.

## Validating a JWT

This was a confusing thing to me initially. But TLDR, you validate a token
by deconstructing it and comparing the values.
Follow steps mentioned in the [RFC Section 7.2 - Validating a JWT].
1. Check the number of periods to determine if the JWT is type JWE or JWS.
2. Split the token by period "." and use the first part as the header.
3. Decode the header using Base64 URL decoding (NOT standard).
4. Verify the header is valid JSON by decoding it as JSON.
5. Verify the header has only fields your app expects, or that are documented
   for a provider/vendor that built the JWT. verify there is at lead the "alg" key, if not then
   the "typ" key should eb something other than "JWT" and your app knows how to
   handle tha kind of token. This doc assumes `typ` is "JWT" and `alg` is
   required here. sign/encrypt it.
6. Determine if it is a JWS or JWT by counting the number of periods in the
   token. See [Distinguishing between JWS and JWE Objects].

You can use the Claim Value of the `alg` Claim Name in the JOSE Header to get
the algorithm used to sign a JWS the In the case of a secret/signature
for a JWS token, you use the secret, PEM key, to build the signature and comepare
it to the signature. or the like to see if that was
use to make the signature somewhat of the
reverse to

To understand how to validate a JWT of JWS type that uses the RS256 algorithm,
please read [A.2.2.  Validating] of  [A.2 Example JWS Using RSASSA-PKCS1-v1_5 SHA-256]

In order to do it with the Kohirens JSON Web Token library, the code looks like:
```go
package main

import (
   "fmt"
   "github.com/kohirens/json-web-token"
)

func main() {
   header := jwt.ClaimSet{// JOSE Header
      "alg": "RS256",
   }
   payload := jwt.ClaimSet{// Payload example
      "admin": true,
      "iat":   1516239022,
      "name":  "John Doe",
      "sub":   "1234567890",
   }

   // Build a JWT using an RSA private key in PEM format.
   token, _ := jwt.BuildJWS(header, payload, load("jwtRS256.key"))

   // Validate a token.
   info, e1 := jwt.Validate([]byte(token),  load("jwtRS256.key.pub"), []string{"iat", "sub"})
   if e1 != nil {
      fmt.Println(e1.Error())
      return
   }}

   // Output: the token is a valid JWS token
   fmt.Printf("the token is a valid %v token\n", info.Type)
}

```
---

[RFC 7519 - JSON Web Token (JWT)]: https://datatracker.ietf.org/doc/html/rfc7519
[RFC 7516 - JSON Web Encryption (JWE)]: https://www.rfc-editor.org/rfc/rfc7516
[RFC 7515 - JSON Web Signature (JWS)]: https://www.rfc-editor.org/rfc/rfc7515
[RFC Section 7.2 - Validating a JWT]: https://datatracker.ietf.org/doc/html/rfc7519#section-7.2
[Distinguishing between JWS and JWE Objects]: https://www.rfc-editor.org/rfc/rfc7516.html#section-9
[A.2.2.  Validating]: https://www.rfc-editor.org/rfc/rfc7515.html#appendix-A.2.2
[A.2 Example JWS Using RSASSA-PKCS1-v1_5 SHA-256]: https://www.rfc-editor.org/rfc/rfc7515.html#appendix-A.2