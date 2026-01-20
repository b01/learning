# AWS Lambda

## Handler Requirements

NOTE: Handlers for Lambdas with the Function URLs enabled work pretty much the
same, as far as I know, they do not have different requirements.

[Handler naming conventions] states that you can use any name for the handler.

For Go functions deployed using a .zip deployment package, the executable file
that contains your function code must be named bootstrap. In addition, the
bootstrap file must be at the root of the .zip file.

Function handler signatures can vary. They  can have 0-2 arguments. The first
input argument is the context. The seconds can be any type that can be used
with json.Unmarshal. The handlers return can have up to 2 arguments. If
only 1 then an error, if 2 the first can be any structure that can be used with
json.Marshal and has keys:
* statusCode - a required integer representing an HTTP status code.
* headers - optional map of strings, if none provided, then Content-Type
  defaults to plain text.
* body - optional string
* cookies - an array of cookie as strings.
* isBase64Encoded - bool value indicating if the body is base64 encoded.
  Typical for media types such as images.

NOTE: You MUST provide a status code, otherwise you will get an internal error.

NOTE: If you return the error argument, then function will fail and not return
a response.

Review [Valid handler signatures for Go handlers].
Also see:
* [Invoking Lambda function URLs]
    * [Request and response payloads] which contains example JSON.

---

[Handler naming conventions]: https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html#golang-handler-naming
[Valid handler signatures for Go handlers]: https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html#golang-handler-signatures
[Invoking Lambda function URLs]: https://docs.aws.amazon.com/lambda/latest/dg/urls-invocation.html
[Request and response payloads]: https://docs.aws.amazon.com/lambda/latest/dg/urls-invocation.html#urls-payloads