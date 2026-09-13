# Secure mass-upload architecture

Verdad Oculta must support informants who submit large evidence sets without weakening confidentiality or malware controls.

## Upload model

A disclosure is a case. A case may contain multiple batches, and each batch may contain many files.

`Case -> Batch -> File -> Security analysis`

Uploads must support:

- multi-file and folder selection where the platform permits it;
- resumable and chunked transfer;
- pause/resume;
- retry of failed chunks rather than restarting the entire file;
- per-file and aggregate progress;
- duplicate detection by cryptographic hash;
- deterministic file identifiers independent of the informant identity.

## Security pipeline

Every object follows:

`receive -> hash -> quarantine -> type validation -> malware analysis -> structural analysis -> classification -> encrypted storage`

Files must not become available to investigators merely because upload completed.

## Archive safety

Archive processing must defend against:

- decompression bombs;
- excessive nesting;
- path traversal;
- archive format parser vulnerabilities;
- extreme file counts;
- oversized expanded output.

Archives are analyzed in an isolated processing environment with resource limits.

## Malware handling

The original upload remains encrypted and quarantined. Suspicious or malicious objects are denied to normal viewers. Where safe rendering is possible, investigators should receive a controlled representation rather than executing the original object.

Multiple independent detection layers may be used. No single scanner result is treated as an absolute guarantee of safety.

## Metadata minimization

The upload pipeline should remove or minimize unnecessary metadata before creating derived investigator copies where doing so does not destroy evidentiary value. The original evidence must remain preserved according to the case retention policy.

Metadata that could identify the informant must not be exposed to investigators merely because it was embedded in a file.

## Large evidence sets

The system must remain usable for thousands of files and multi-gigabyte media sets. Resource limits apply per request, per batch, and per case, with controlled quotas that do not reveal unnecessary information about the informant.

## Privacy

A large number of files must not create a proportional increase in identity data. Case, batch, file, and security records are separate from any optional contact information.

## Production gate

Actual malware scanning, sandboxing, object-storage isolation, chunk encryption, retention, and investigator access controls must be implemented and independently tested before real submissions are enabled.
