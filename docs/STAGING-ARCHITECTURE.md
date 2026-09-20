# Staging architecture

```text
Flutter client
     |
     | HTTPS / Tor boundary
     v
GlobaLeaks staging
     |
     +--> protected intake / correspondence
     |
     +--> quarantine boundary
               |
               v
        isolated analysis
               |
               v
        approved derivative
          /             \
       PUBLIC         MEMBER
```

The protected intake system is authoritative for whistleblower submissions. The publication/member systems must never become an alternate store for protected originals.

The first implementation slice is intentionally read-only at the custom application boundary. Submission and receipt operations remain disabled until the staging instance has been deployed and the security gate has been executed.

No real secrets or production endpoints belong in the repository.
