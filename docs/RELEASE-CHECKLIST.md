# Verdad Oculta — release checklist

## Functional

- [x] Local demo flow
- [x] Reveal workflow
- [x] Local submission list
- [x] Security status screen
- [x] Explicit staging configuration
- [x] Membership content boundary
- [x] Public/member archive model
- [ ] Real staging submission
- [ ] Receipt authentication
- [ ] Anonymous correspondence
- [ ] Attachment upload to staging
- [ ] Quarantine and isolated file analysis
- [ ] Publication approval workflow
- [ ] Admin console
- [ ] Donation flow
- [ ] Payment provider integration

## Security release gates

- [ ] No production endpoint in client defaults
- [ ] No receipt/report data in logs or analytics
- [ ] Protected originals inaccessible to public/member paths
- [ ] Membership cannot authorize protected originals
- [ ] Attachment isolation verified
- [ ] Negative authorization tests pass
- [ ] Backup/retention/deletion policy verified
- [ ] Production threat model reviewed
- [ ] Legal/privacy review completed for deployment jurisdiction

The app is not production-ready until all mandatory unchecked gates are closed.
