## Quick orientation for AI coding agents

This repository defines the RAMSES HTTP API surface using Microsoft TypeSpec (Typespec). The canonical API entrypoint is `src/main.tsp`. Models and shared types live under `src/models/*.tsp`. Response wrappers and errors are in `src/responses/`.

Key facts you need immediately:

- Language / tooling: TypeSpec ("tsp" CLI). Node >= 20, pnpm for package management. See `package.json` for scripts.
- Common dev commands (run these, they are authoritative):
  - `pnpm install` — install deps
  - `pnpm compile` — compile `src/main.tsp` to the OpenAPI spec
  - `pnpm dev` (or `pnpm start`) — `tsp compile` in watch mode for rapid iteration
  - `pnpm format` — run `tsp format` (prettier plugin configured)

Repository conventions and patterns (do not deviate):

- API surface: `src/main.tsp` defines interfaces annotated with `@route`, `@tag` and grouped by logical areas (e.g. `/order-manager`, `/mes/*`). When adding endpoints, add or extend interfaces here.
- Models: shared models live in `src/models/models.tsp` and per-concept files (e.g. `machine-centers.tsp`, `order-tasks.tsp`). Add new model files under `src/models/` and import them from `src/main.tsp` (the project explicitly imports many model files there).
- Response & error patterns: response aliases are centralized in `src/responses/responses.tsp` (e.g. `PaginatedResponse<T>`, `CreatedResponse<T>`). Error models live in `src/responses/errors.tsp` (e.g. `NotFoundError`, `ValidationError`). Use these aliases and error models when declaring operation return types.
- Versioning: The project uses an enum `Versions` and the file-level `@versioned(Versions)` annotation (see `src/models/models.tsp`). When you add a new API version, update the `Versions` enum and ensure `@added`/`@visibility` attributes are used per TypeSpec conventions.
- Encoding & visibility: Date/time fields often use `@encode(DateTimeKnownEncoding.rfc3339)` / `utcDateTime`. Some fields use `@visibility("read")` — preserve these when refactoring models.
- Streaming/multipart: File uploads and streamed CSV/ZIP responses are modeled explicitly (see multipart definitions in `src/main.tsp` and `StreamedCsvResponse` / `StreamedZipResponse` in `src/models/models.tsp`). Follow those examples for binary or streamed responses.

Where compiled artifacts land:

- The TypeSpec output is emitted to `tsp-output/openapi3/` (files include `openapi.v1.yaml`, `openapi.dev.yaml`). Do not edit those generated files directly.

Integration notes (discoverable):

- Dependencies: `@typespec/*` packages are used. The repo relies on the TypeSpec compiler to produce OpenAPI; CI or downstream services consume the YAML under `tsp-output/openapi3/`.
- External integrations (patterns): multipart upload endpoints (`@header contentType: "multipart/form-data"`) and streamed endpoints (CSV/ZIP) indicate the API is used by clients that upload large files or download archives — preserve headers and content-disposition when modifying these paths.

Precise examples you can follow

- Add a new endpoint: extend `src/main.tsp` with an `@route`/`@tag` interface and return a typed alias from `src/responses/responses.tsp`. Example: existing `@route("/mes/machine-centers")` and `PaginatedResponse<MachineCenterWithScanners>`.
- Add a model: create `src/models/my-model.tsp`, define `model MyModel { ... }`, then import it from `src/main.tsp` alongside other `import "./models/.."` lines.

Rules for edits and PRs from AI agents

- Never change `tsp-output` generated files in a feature PR.
- Keep TypeSpec-specific annotations intact (`@encode`, `@visibility`, `@versioned`, `@service`, `@route`, `@tag`). They are semantically meaningful for the compiler.
- Preserve response alias usage. If you need a new alias, add it to `src/responses/responses.tsp` rather than duplicating similar shapes inline.

If anything is ambiguous, point to these files first: `src/main.tsp`, `src/models/models.tsp`, `src/responses/responses.tsp`, `tspconfig.yaml`, and `package.json`.

If you'd like any section expanded or examples added, tell me which area (models, routes, responses or build) and I'll update the file.
