# Staging backend configuration

The app defaults to local demo mode and contains no production endpoint.

To run a controlled staging build, provide the endpoint at build time:

```
flutter run \
  --dart-define=VO_BACKEND_MODE=staging \
  --dart-define=VO_STAGING_BASE_URL=https://staging.example
```

The client accepts only an HTTPS base URI without user credentials, query parameters or fragments.

The current integration is read-only: the Security screen can check `/api/health`. Submission, receipt authentication and correspondence remain blocked until the staging environment and security gates are verified.

Do not put secrets in `--dart-define`, source code, URLs or logs.
