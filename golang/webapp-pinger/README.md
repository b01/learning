# WebApp Pinger

Ping another web application and display its response.

Originally this has been designed to test the network policy feature of a
Kubernetes cluster.

1. Build a go app (this app) to display a form on a home page to ping another
   application at a FQDN or IP (v4 or v6) address.
2. Containerize the application and publish the image.
3. Deploy the application to 2 different nodes in the cluster.
4. Deploy a network policy to block all traffic within the namespace.
5. Add a policy to allow only pods with a specific label to communicate.