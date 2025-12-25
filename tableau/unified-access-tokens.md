# Unified Access Tokens

## Benefits

* UATs support multiple concurrent sessions, as opposed to PATs.
* UATs enable JWT-based authentication for cloud administrators with the **TCM
  REST API**; and for users with both the **TCM REST API** and
  **Tableau REST API**.

## Gotcha

* JWT authentication using UATs and JWT authentication using Tableau connected
  apps are distinct authentication and authorization capabilities. Tableau
  connected apps are not supported in Tableau Cloud Manager.