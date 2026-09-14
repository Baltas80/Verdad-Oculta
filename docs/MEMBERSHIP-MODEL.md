# Verdad Oculta — Membership & Funding Model

## Status

Design baseline. This document defines the product model only. It does not authorize production payments, access to confidential submissions, or publication of sensitive material.

## Mission

Verdad Oculta is an independent platform for the protected submission, preservation, disclosure and public/archive access of information, documents and testimonies that contributors want to reveal.

The platform does not require a predetermined interpretation of a submission. A submission may concern UAP, NHI, anomalous phenomena, secret programs, historical files, testimony, technology, or another subject. Verdad Oculta does not sell a source's identity or confidential material.

## Access model

### Free — Public Archive

- Publicly released cases and files.
- Published testimonies.
- Public archive search.
- Public investigations and updates.
- Anonymous submission capability, subject to the security gates defined elsewhere in the repository.

### Member — Archive Access — €4.99/month (provisional)

- Everything in Free.
- Selected material placed in the Member Archive before or instead of general publication.
- Expanded dossiers and supporting documents selected for members.
- Early access to selected releases.
- Advanced archive search when implemented.

Membership does not provide access to source identity, raw confidential submissions, private communications, or material whose disclosure could endanger a contributor.

### Investigator — Extended Archive — €9.99/month (provisional)

- Everything in Member.
- Larger selected dossiers.
- Cross-referenced archive material and extended case indexes when implemented.
- Additional research-oriented archive tools when implemented.

This tier does not provide privileged access to source identities or protected confidential material.

### Supporter — Cause & Defense — €24.99/month (provisional)

- Everything in Investigator.
- Recognition as a supporter where the user explicitly opts in and disclosure is legally/privacy appropriate.
- Primary purpose: financially support security, infrastructure, research, expert review and legal defense.

The higher payment does not purchase stronger editorial influence or confidential access.

## Legal Defense Fund

Verdad Oculta may provide a separate contribution mechanism dedicated to security and legal defense. Contributions must not be represented as purchasing a specific publication, case outcome, source identity, or privileged disclosure.

The final legal, tax, payment-provider and donor-privacy structure must be reviewed before activation.

## Non-negotiable rules

1. No payment buys a confidential leak.
2. No payment reveals a contributor's identity.
3. No payment grants access to identifying metadata or private source communications.
4. No member can require publication, suppression, alteration or withdrawal of a case through payment.
5. Membership does not determine whether a claim is UAP, NHI, extraterrestrial, conventional, fraudulent or otherwise.
6. A submission and its eventual publication are separate decisions.
7. Confidential source material remains protected regardless of membership status.
8. Access control is enforced server-side; the client must never be the authority for paid access.
9. Sensitive archive content must be encrypted at rest and in transit and must follow the project's approved key-management protocol before production.
10. No analytics, advertising SDKs or unnecessary third-party data sharing may be introduced into protected submission flows.

## Content classification

- **CONFIDENTIAL** — source-protected material; restricted to authorized internal handling.
- **RESTRICTED** — material not suitable for public/member release yet.
- **MEMBER ARCHIVE** — selected material approved for authenticated members.
- **PUBLIC** — material approved for general publication.

Membership must never downgrade CONFIDENTIAL material to MEMBER ARCHIVE merely because a user pays.

## Product principle

> Members finance Verdad Oculta; they do not buy the truth.

The platform's objective is to make it possible for people to reveal information safely while building a sustainable archive and funding the security, legal and operational capacity required to protect that mission.

## Security gate

No real membership payment, member-only sensitive archive, or real anonymous submission is production-ready until the repository's security implementation gate is satisfied. OWASP MASVS requires secure storage, strong cryptography and key management, secure network communication and privacy controls; these requirements are particularly relevant because Verdad Oculta handles potentially identifying and highly sensitive submissions. See `docs/MASVS-BASELINE.md` and `docs/SECURITY-IMPLEMENTATION-GATE.md`.

## Implementation order

1. Product/access model.
2. Legal and privacy review.
3. Account/authentication and server-side authorization design.
4. Payment provider selection and legal/tax review.
5. Archive classification and access-control model.
6. Encryption and key lifecycle implementation and independent review.
7. Security testing and platform validation.
8. Only then activate real payments and member-only sensitive content.
