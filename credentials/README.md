# credentials/

One folder for every local secret, so there is a single obvious place for them
and a single entry in `.gitignore`.

## Rules

1. **Nothing real is committed here.** Only this `README.md`, the `.gitignore`
   and the `*.example` templates are tracked. Every other file is ignored.
2. Copy an `*.example` file to the name without `.example` and fill in values:
   - `backend-local.env.example` → `backend-local.env`
   - `frontend-local.env.example` → `frontend-local.env`
3. Never paste a real value into a tracked file, a commit message, a chat
   message or a document. Names and locations only.

## Which option, and why

- **Local development:** the ignored files in this folder.
- **CI/CD (preferred):** store secrets in the pipeline's secret store and inject
  them as environment variables. The app reads env vars, not files.
- **Production (preferred):** a managed secret manager (e.g. Vault, AWS Secrets
  Manager, Azure Key Vault). The `credentials/` folder is a dev convenience, not
  a production store.

The folder exists because it was requested. The safer default — and the one the
build rules prefer — is that secrets live **outside** the repo and are injected
at run time.
