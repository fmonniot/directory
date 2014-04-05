## 2.1.0 (2014-02-07)

Bugfixes:

  - Fix pagination in public API
  - Change DISI LDAP address

Features:

  - Improve tests quality
  - Inline image in CSS
  - Add administration backend
    - Listing people
    - Filter pending people (waiting to be desindexed)
    - Dashboard with charts (can be clickable)
    - New administrator on invite
    - Creation of arbitrary person (presence in LDAP not required)

Backward compatibility issue:

  - You will have to regenerate elasticsearch indices (name have changed)
