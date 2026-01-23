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
* `statusCode` - a required integer representing an HTTP status code.
* `headers` - optional map of strings, if none provided, then Content-Type
  defaults to plain text.
* `body` - optional string
* `cookies` - an array of cookie as strings. Note, I tried setting cookies in
  the header, and AWS Lambda just ignored them. If they are present in the
  header, where they belong, Lambda will do nothing with them. It's a wierd
  AWS thing.
* `isBase64Encoded` - bool value indicating if the body is base64 encoded.
  Typical for media types such as images.

NOTE: You MUST provide a status code, otherwise you will get an internal error.

NOTE: If you return the error argument, then function will fail and not return
a response.

NOTE: When returning an HTTP response, it does not use cookies set in the
header map, instead cookies should be returned as their own string array on
the response object.

Review [Valid handler signatures for Go handlers].
Also see:
* [Invoking Lambda function URLs]
    * [Request and response payloads] which contains example JSON.
      * [Request payload format]
      * [Response payload format]

## Gotcha/Pitfalls To Avoid

* Only return an error when you want the function to fail. Otherwise, you can
  return a response with the appropriate HTTP response code and just log the
  error, which will then go to cloudwatch.
* All errors logged to stdout will go to cloudwatch.
* A Lambda cloudwatch log stream MUST be named to a specific format, and it MUST
  have the required permissions on the lambda execution role; or else logs will
  not show up.

## Types of Metrics

* Invocation metrics
* Performance metrics
* Concurrency metrics
* Asynchronous invocation metrics
* Event source mapping metrics

### Metric Details

* **Invocations** – The number of times that your function code is invoked.
* Errors – The number of invocations that result in a function error.
* adLetterErrors – For asynchronous invocation, the number of times that Lambda attempts to send an event to a
  dead-letter queue (DLQ) but fails.
* DestinationDeliveryFailures – For asynchronous invocation and supported event source mappings, the number of times
  that Lambda attempts to send an event to a destination but fails.
* Throttles – The number of invocation requests that are throttled.
* OversizedRecordCount – For Amazon DocumentDB event sources, the number of events your function receives from
  your change stream that are over 6 MB in size.
* ProvisionedConcurrencyInvocations – The number of times that your function code is invoked using
  provisioned concurrency.
* ProvisionedConcurrencySpilloverInvocations – The number of times that your function code is invoked using
  standard concurrency when all provisioned concurrency is in use.
* RecursiveInvocationsDropped – The number of times that Lambda has stopped invocation of your function because
  it has detected that your function is part of an infinite recursive loop.
* Performance metrics
    * Duration – The amount of time that your function code spends processing an event.
    * PostRuntimeExtensionsDuration – The cumulative amount of time that the runtime spends running code for
      extensions after the function code has completed.
    * IteratorAge – For DynamoDB, Kinesis, and Amazon DocumentDB event sources, the age of the last record in the event in milliseconds.
* Concurrency metrics
    * ConcurrentExecutions – The number of function instances that are processing events.

## Lambda destination

With Destinations, you  can send asynchronous function execution results to a destination resource without writing
code. A function execution result includes version, timestamp, request context, request payload, response context,
and response payload. For each execution status (i.e. Success and Failure), you can choose one destination from
four options: another Lambda function, an SNS topic, an SQS standard queue, or EventBridge.

## Amazon API Gateway Lambda proxy Integration

A simple, powerful, and nimble mechanism to build an API with a setup of a single API method. The Lambda proxy
integration allows the client to call a single Lambda function in the backend. The function accesses many
resources or features of other AWS services, including calling other Lambda functions.

In Lambda proxy integration, when a client submits an API request, API Gateway passes to the integrated Lambda
function the raw request as-is, except that the order of the request parameters is not preserved. This request
data includes the request headers, query string parameters, URL path variables, payload, and API configuration data.

This solution provides a front end that can listen for HTTP GET requests and then proxy them to the Lambda
function and is the simplest option to implement and also the most cost-effective.

---

[Handler naming conventions]: https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html#golang-handler-naming
[Valid handler signatures for Go handlers]: https://docs.aws.amazon.com/lambda/latest/dg/golang-handler.html#golang-handler-signatures
[Invoking Lambda function URLs]: https://docs.aws.amazon.com/lambda/latest/dg/urls-invocation.html
[Request and response payloads]: https://docs.aws.amazon.com/lambda/latest/dg/urls-invocation.html#urls-payloads
[Request payload format]: https://docs.aws.amazon.com/lambda/latest/dg/urls-invocation.html#urls-request-payload
[Response payload format]: https://docs.aws.amazon.com/lambda/latest/dg/urls-invocation.html#urls-response-payload
