# Generics

## Declare a type constraint

1. declare a type constraint as an interface
2. Add any type implementing the interface.
3. Use the interface as the type when defining a generic function.

For example

```go
package main

import "fmt"

type Number interface {
    int64 | float64
}

// SumNumbers sums the values of map m. It supports both integers
// and floats as map values.
func SumNumbers[K comparable, V Number](m map[K]V) V {
	var s V
	for _, v := range m {
		s += v
	}
	return s
}

func main() {
	fmt.Printf("Generic Sums with Constraint: %v and %v\n",
		SumNumbers(ints),
		SumNumbers(floats))
}
```


## Cast to a type

You can cast any type to a concrete type as long as you know it satisfies that
type. an interface to any type as long as it satisfies some requirements.

```go
package main

import (
	"crypto"
	"crypto/hmac"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"errors"
	"fmt"
)

func loadPubKey(publicKeyPem []byte) *rsa.PublicKey, error {

	block, _ := pem.Decode(publicKeyPem)
	if block == nil || block.Type != "PUBLIC KEY" {
		return nil, fmt.Errorf("failed to decode public key")
	}
	
	//...
	
	// PKCS#8 This method returns a type of any, which just the empty interface.
	// Not much we can do with that.
	iPublicKey, e3 := x509.ParsePKIXPublicKey(block.Bytes)
	if e3 != nil {
		return nil, fmt.Errorf("invalid signature: %v", e3.Error())
	}

    // So let's cast this to a type we can use.
	key, ok := iPublicKey.(*rsa.PublicKey)
	if !ok {
		return nil, fmt.Errorf("invalid public key")
	}
}

func main()  {
	loadPubKey([]byte("public RSA key in PEM format"))
}
```
---

[Tutorial: Getting started with generics]: https://go.dev/doc/tutorial/generics