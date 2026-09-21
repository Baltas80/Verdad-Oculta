# Archive policy

The application uses five explicit content classifications:

- `public`: publishable to everyone.
- `memberArchive`: selected material available to active paid members.
- `restricted`: internal review only.
- `confidential`: protected investigative material.
- `protectedOriginal`: original intake material; never exposed through the member/public archive.

The classification is an authorization boundary, not merely a UI label. Every backend read must enforce it server-side.

Membership is not a substitute for authorization to protected material. Payment status alone must never produce a storage credential.
