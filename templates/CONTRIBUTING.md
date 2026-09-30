# Contribuindo com <PROJETO>

## Branches

- `main` — sempre deployável. Protegida: PR obrigatório, CI obrigatório, sem force push.
- `feat/NNN-nome` — feature SDD (mesmo número da pasta `specs/NNN-nome/`).
- `feat/<nome>` / `fix/<nome>` — trilha rápida.
- `chore/<nome>` — tooling, dependências, docs.

## Commits

Conventional Commits, validado no `commit-msg`:

```
<tipo>: <descrição no imperativo, minúsculo, sem ponto final>
```

Tipos: `build`, `chore`, `ci`, `docs`, `feat`, `fix`, `perf`, `refactor`, `revert`, `style`, `test`.

## Hooks

1. **pre-commit:** bloqueia `.env`/segredo staged → lint + format nos arquivos staged → testes relacionados.
2. **commit-msg:** Conventional Commits.

Hook falhou? Conserte o problema. **Nunca** `--no-verify`.

## Fluxo

- Feature não trivial: SDD completo (ver `CLAUDE.md`).
- Bug de ~1 arquivo / CRUD trivial: trilha rápida (plan mode + teste + evidência).

## Definition of Done

Ver `CLAUDE.md` e o template de PR. Evidência anexada é obrigatória.
