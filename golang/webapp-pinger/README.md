# WebApp Pinger

Ping another web application and display its response.

Originally this has been designed to test the network policy feature of a
Kubernetes cluster.

1. Build a Go app (this app) to display a form on a home page to ping another
   application at a FQDN or IP (v4 or v6) address.
   1. Make sure its safe for webapp-pinger to call itself.
   2. `/ping` should also return the calling server info along with the `/pong`
      server info. This can be useful if you a playing with ALB in Kubernetes
      to see what IP is returning (so include the client IP).
2. Containerize the application and test.
3. Deploy the application to 2 different nodes in the cluster.
4. Deploy a network policy to block all traffic within the namespace.
5. Add a policy to allow only pods with a specific label to communicate.
6. Publish `b01/learning-golang:webapp-pinger-dev` image.

## Running the application

1. Build it: `go build ./golang/webapp-pinger`
2. Run it with an argument to pass in a relative directory that tells it
   where the static files live:
   ```shell
   ./webapp-pinger.exe ./golang/webapp-pinger/public
   ```

## How does ping work

1. Webapp-pinger gets a request on `/ping`
2. `/ping` calls `/pong` which should return server info or an error.