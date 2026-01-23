# Provider Authoring

Writing a Terraform provider can be a great way to add custom functionality
you may be missing. Here are a few pointers to aid along your journey to
writing you own provider.

NOTE: The string that you supply to main for the hostname/namespace/provider
      does not make sense. What should this value be.

1. If you've never written a Provider, go through the tutorial
[Providers Plugin Framework] first.
2. Set a `dev_overrides` block in a configuration file called `.terraformrc`
    ```shell
    provider_installation {

     dev_overrides {
         "hashicorp.com/edu/exampletime" = "<PATH>"
     }

     # For all other providers, install them directly from their origin provider
     # registries as normal. If you omit this, Terraform will _only_ use
     # the dev_overrides block, and so no other providers will be available.
     direct {}
    }
    ```
3. Install provider and verify with: `go install .`
4. You want to clean out the chache often, even restart your machine if your
   own Windows:
   ```shell
   go clean -cache
   go build .
   go install .
   ```

## Implement A Data Source

### Schema

This is NOT as easy as making a Go type or encoding JSON. Unfortunately, you
will have to manually map various types from the "types" library to JSON. It's
simple for scalars like int or string, but more tricky for complex types like
list and maps.

`Computed` - In Terraform provider schema, the computed flag indicates that the
attribute's value is determined by the provider, not the user, and is typically
calculated or retrieved at runtime, such as a resource ID or creation timestamp.

## Implement automated testing

Notes from this tutorial.

We are going to focus just on a datasource for now.

1. Make a new test file, there is a naming convention you should be aware of:
`data_source_<provider-name>_<module_name>.go`
2. Import the go `testing` and the Terraform helper framework:
    ```golang
    import (
        "testing"
        "github.com/hashicorp/terraform-plugin-testing/helper/resource"
    )
    ```
3. Construct a new test function:
    ```golang
    func TestAccShDataSource(t *testing.T) {
        resource.Test(t, resource.TestCase{
            ProtoV6ProviderFactories: testAccProtoV6ProviderFactories,
            Steps: []resource.TestStep{
                {
                    Config: providerConfig + `data "sh_vars" "test" {}`,
                },
            },
        }
    }
    ```

## Implement A Function

Provider functions are types that implement the function.Function interface from
the plugin framework.

The Function interface requires:

1. A Metadata method that sets the function name. Unlike resources and data sources, function names do not start with the provider name.
2. A Definition method that defines the parameters, return value, and documentation for the function.
3. A Run method that executes the function code.
4. Create a new internal/provider/function_<name>.go file.

---

[Providers Plugin Framework]: https://developer.hashicorp.com/terraform/tutorials/providers-plugin-framework