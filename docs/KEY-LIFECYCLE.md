# Verdad Oculta — Key Lifecycle

## Status
Design gate. No production key-management implementation is approved yet.

## Objective
Define how cryptographic keys are generated, protected, used, rotated, revoked, recovered and destroyed without creating a new informant-identity record.

## Security domains

Keys are separated by security domain:

- **Case content key:** unique to each disclosure case and used only for that case's protected content.
- **Transport/session keys:** ephemeral protocol material used for authenticated communication; never reused as case-content keys.
- **Device protection key:** platform-backed key used to protect local application secrets. It is not itself used to encrypt case content sent to the service.
- **Investigation/service keys:** held by the receiving service under controlled access; their private material must never be embedded in the client package.

## Required lifecycle

1. **Generation** — cryptographically random generation using an approved maintained implementation and platform CSPRNG facilities.
2. **Binding** — associate the case key with a non-identifying case reference and cryptographic context, never with informant identity.
3. **Protection** — protect locally held key material using the platform secure keystore where supported. Android Keystore and Apple Keychain/Secure Enclave are the reference mechanisms for mobile platforms.
4. **Use** — use a case key only inside the approved case-encryption protocol. Never reuse it as a global application key.
5. **Rotation** — rotate protocol/session material according to the selected protocol. Large encrypted streams may additionally use the selected library's authenticated rekey mechanism.
6. **Revocation** — compromised or invalidated key material must be marked unusable without requiring disclosure of informant identity.
7. **Recovery** — recovery must be explicitly designed. There must be no hidden recovery key, hardcoded master key, or silent server-side plaintext recovery path.
8. **Destruction** — destroy local key material and temporary plaintext according to a defined lifecycle, while preserving only the minimum information needed to maintain the case state.

## Case-key distribution

The final protocol must define how the receiving service obtains the ability to decrypt a case without giving the client a long-lived service private key. Candidate designs include authenticated public-key encryption/key wrapping or an established hybrid-encryption protocol. The final choice requires a threat-model review before implementation.

## Failure rules

- Missing or invalid key material: abort.
- Authentication/tag verification failure: abort and do not release plaintext.
- Secure-storage failure: abort rather than fall back to ordinary files/preferences.
- Protocol/version mismatch: abort rather than downgrade.
- Recovery unavailable: report a non-sensitive failure; never silently create a weaker recovery path.

## Privacy constraints

Key identifiers, case references and operational metadata must not contain names, email addresses, phone numbers, filenames or other unnecessary identity information.

The system must not use a single global symmetric key for all cases.

## Verification gates

Before production:

- protocol selected and reviewed;
- exact algorithms and library versions pinned;
- platform keystore behaviour verified on every supported mobile platform;
- negative tests cover wrong keys, tampered ciphertext, truncated ciphertext, replay/version mismatch and unavailable secure storage;
- recovery and revocation threat model reviewed;
- independent cryptographic/security review completed.

## References

- OWASP MASVS-CRYPTO-1 and MASVS-CRYPTO-2.
- OWASP MASVS-STORAGE-1 and MASVS-STORAGE-2.
- Platform secure-keystore documentation.
- The selected maintained cryptographic library's official documentation.
