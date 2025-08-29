# Bridge

Provides a way to import data, in an automated fashion, into your Tableau
Cloud environment.

By installing an agent, on your on-premisses servers, that initiates a secure
(TLS enabled), bidirectional communication using a WebSocket (wss://)
connection.

Is optimized for users that perform the following functions in an organization:

1. Site admins - Are users who have the "Site Administrator" or
   "Site Administrator Creator" role on Tableau Cloud. They should review
   the [Plan Your Bridge Deployment] documentation. Only site admins can add
   new pools, add clients to a pool, remove clients from a pool, and monitor
   clients in a pool.
2. and data source owners.
3. Content Owners - Are users who have the "Creator" or "Explorer" (can
   publish) role on Tableau Cloud. They typically use Bridge to facilitate
   the live and extract connections between Tableau Cloud and private network
   data.

## Hardware Recommendations

The following table shows hardware guidelines for virtual environments running
Bridge. These guidelines are based on the number of concurrent refreshes you
need each client to be able to run in parallel.

| Refreshes running in parallel per client | <= 5   | <= 10  |
|------------------------------------------|--------|--------|
| vCPU                                     | 4      | 8      |
| RAM                                      | 16 GB  | 32 GB  |
| NVMe SSD                                 | 150 GB | 300 GB |

## Authentication

There are two primary authentication points for Bridge:
* Tableau Cloud
* and private network data.

### Connecting To Tableau Cloud

1. A users Tableau Cloud credentials are entered through the Bridge client.
2. After authorization, a token is returned by Tableau Cloud.
3. The token is stored on the computer where the client is running using the
   credentials manager of the Windows operating system.

If the client is shut down, or the Exit option on the Windows task bar is used,
you are required to re-login and provide credentials. This creates a new
refresh token which is saved to the Windows credentials store.

Bridge uses the token to perform various tasks such as downloading the refresh
schedule information for an extract.

### Connecting To Private Network Data

The client supports domain-based security (Active Directory) and
username/password credentials to access data.

For Live connections and Extracts connections that use refresh schedules,
database credentials are sent at the time of the request and use a TLS 1.2
connection.

## Changes to private network firewall

The Bridge client requires no in-bound changes to the private network firewall
since it only makes outbound connections to Tableau Cloud. Only out-bound
allowance is needed for port 443 and protocols for wss/https.

## Access to private network data

For data sources with live connections or virtual connections:
1. The client establishes a persistent connection to a Tableau Bridge service,
   which is the part of the client that resides on Tableau Cloud, using secure
   WebSockets (wss://).
2. The client then waits for a response from Tableau Cloud
3. Then initiating a live query to the private network data.
4. The client passes the query to the private network data. 
5. then returns the private network data using the same persistent connection.

For data sources with extract connections that use refresh schedules, the client
1. establishes a persistent connection to a Tableau Bridge service using secure
   WebSockets (wss://).
2. Then waits for a request from Tableau Cloud for new refresh schedules.
3. When the client receives the requests, it then contacts Tableau Cloud using
   a secure connection (https://) for the data source (.tds) files.
4. Then the client connects to the private network data using the embedded
   credentials that are included in the job request.
5. The client creates an extract of the data
6. and then republishes the extract to Tableau Cloud.

NOTE: Steps 2-6 can be occurring in parallel to allow multiple refresh requests
to happen.

To ensure that your data is transmitted to Tableau Cloud only, we recommend
implementing domain-based filtering on outbound connections (forward proxy
filtering) from the Bridge client. See [Forward proxy filtering].

The following list contains some domain names that Bridge uses for outbound
connections:

* `* .online.tableau.com`
* `*.compute-1.amazonaws.com` - Amazon VPC's public DNS hostname for the
   us-east-1 region.
* `*.compute.amazonaws.com` - Amazon VPC's public DNS hostname for all other
  regions.

## Timeout limits

Live queries have a timeout limit of 15 minutes. This limit is not configurable.
Refreshes have a default timeout limit of 24 hours and is configurable by the
client. For more information, see Change the Bridge Client Settings.

## Note about refresh jobs

The Jobs page can show you the completed, in progress, pending, canceled, and
suspended all Bridge refresh jobs that use Bridge refresh schedules.

For troubleshooting Bridge errors you see on the Jobs page, see
[Troubleshoot pooling].

## Connection Types

You cannot specify the bridge connections in your data sources, they are
selected automatically by Tableau Cloud bases on network parameters.

### Live Connections

Are enabled through pooling. During the publishing process, of the data source
or virtual connection, is when Bridge is detected automatically. Users see the
option to publish the data source with a live connection during the publishing
process. This option is available when live connections are supported for
relational or cloud databases accessible only from inside the network.

To get started, users publish a data source to Tableau Cloud, and select the
option to maintain a live connection. Or, publish a workbook, then specify a
live connection.

### Extract Connections

Users can set up refresh schedules for data sources or virtual connections.
For more information, see [Set Up a Bridge Refresh Schedule].

## Setting up Tableau Bridge for the First Time or Upgrading

There are a set of recommendations and best practices:

* To use Bridge on Linux you must create a customized Docker image, install the RPM package, and then run Bridge from inside the container image.  see [Install Bridge for Linux for Containers].
* Review [Windows deployment] if you plan to use that OS.
* Before you start deploying the container, create a Personal Access Token (PAT). The PAT is required to log in to the agent. Tableau Cloud supports 104 PATs per user. We recommend that you use one PAT token per client.

## Ensure clients can connect to the site

In order for Bridge to work with your site, you must allow clients to
authenticate to the site.

1. Sign in to Tableau Cloud using your site admin credentials and go to the
   **Settings** page.

2. Click the Authentication tab and validate that the Let clients automatically
   connect to this Tableau Cloud site check box under the Connected Clients 
   heading is selected. For more information about this check box, see Access
   Sites from Connected Clients.

Note: If enabled, the connected clients option must be enabled to support
multi-factor authentication with Tableau authentication.

## Configure Pools

Pooling allows **load balanced** data freshness tasks for data sources and
virtual connections, that connect to private network data.

The purpose of a pool is to distribute (or load balance) data freshness tasks
among the available clients in a pool whose **access is scoped to a domain
within your private network**.

Pools map to domains
* giving you the ability to dedicate pools to specific data refreshes;
* and maintaining security by restricting access to protected domains in your
  private network.

Pooling support does not extend to data sources that use Bridge (legacy)
schedules. To avoid legacy scheduling, then use Tableau CLoud UI to schedule
task.

See [Specify a domain for a pool].

A pool requires a domain to be specified through the **Private Network
Allowlist**, because it enables Bridge to access to data in the private network.

The max number of domains on the allowlist and pools in your organization may
not exceed 100.

For private network allowlist, the domains should correspond to private network
locations of databases and file shares, which you must also make accessible to
Bridge agent running on-prem.


### Domain names

The domain names you specify in an allowlist are the server names used
in the data source connection or virtual connection.

Note: When accessing workbooks which connect to published data sources, do
not use `*.tableau.com` in the Private Network Allowlist.

If you see errors in your Jobs such as **errorID=NO_POOLED_AGENTS_ASSIGNED**,
it can mean that you have not added the connetion/server name to the **Private
Network Allowlist**.

## Resources

1. [Use Bridge to Keep Data Fresh]
2. [Plan Your Bridge Deployment]
3. [Set Up a Bridge Refresh Schedule]
4. [Bridge Downloads]
5. [Install Bridge for Linux for Containers]
6. [Bridge Site Capacity]
7. [About multi-factor authentication and Tableau Cloud]
8. [Configure Pools]
9. [Connectivity with Bridge]
10. [Tableau Cloud Site Capacity]

---

[Use Bridge to Keep Data Fresh]: https://help.tableau.com/current/online/en-us/qs_refresh_local_data.htm
[Plan Your Bridge Deployment]: https://help.tableau.com/current/online/en-us/to_bridge_scale.htm
[Set Up a Bridge Refresh Schedule]: https://help.tableau.com/current/online/en-us/to_sync_schedule.htm
[Bridge Downloads]: https://www.tableau.com/support/releases/bridge
[Install Bridge]: https://help.tableau.com/current/online/en-us/to_bridge_install.htm#database-drivers
[Install Bridge for Linux for Containers]: https://help.tableau.com/current/online/en-us/to_bridge_linux_install.htm
[Windows deployment]: https://help.tableau.com/current/online/en-us/to_bridge_scale.htm#windows-deployment
[Bridge Site Capacity]: https://help.tableau.com/current/online/en-us/to_bridge_site_capacity.htm
[About multi-factor authentication and Tableau Cloud]: https://help.tableau.com/current/online/en-us/security_auth.htm#mfa_requirement
[Specify a domain for a pool]: https://help.tableau.com/current/online/en-us/to_enable_bridge_live_connections.htm#step-3-specify-a-domain-for-a-pool
[Forward proxy filtering]: https://help.tableau.com/current/online/en-us/to_bridge_security.htm#forward-proxy-filtering
[Troubleshoot pooling]: https://help.tableau.com/current/online/en-us/to_enable_bridge_live_connections.htm#troubleshoot-pooling
[Configure Pools]: https://help.tableau.com/current/online/en-us/to_enable_bridge_live_connections.htm
[Connectivity with Bridge]: https://help.tableau.com/current/online/en-us/to_sync_local_data.htm
[Tableau Cloud Site Capacity]: https://help.tableau.com/current/online/en-us/to_site_capacity.htm#concurrent-jobs-capacity
