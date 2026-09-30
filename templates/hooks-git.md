# Hooks git — receitas por stack

Objetivo igual em qualquer stack:

1. **pre-commit:** `scripts/check-no-secrets.sh` → lint/format nos arquivos staged → testes relacionados.
2. **commit-msg:** Conventional Commits.

## Node (husky + lint-staged + commitlint)

```bash
npm i -D husky lint-staged @commitlint/cli @commitlint/config-conventional
npx husky init
chmod +x scripts/check-no-secrets.sh
echo 'scripts/check-no-secrets.sh
npx lint-staged --concurrent false' > .husky/pre-commit
echo 'npx --no -- commitlint --edit $1' > .husky/commit-msg
echo "module.exports = { extends: ['@commitlint/config-conventional'] };" > commitlint.config.js
```

`.lintstagedrc.json`:
```json
{
  "*.{ts,tsx,js}": ["eslint --fix", "prettier --write", "jest --bail --findRelatedTests --passWithNoTests"],
  "*.{json,md,yml}": ["prettier --write"]
}
```

## Python (pre-commit)

`.pre-commit-config.yaml`:
```yaml
repos:
  - repo: local
    hooks:
      - id: no-secrets
        name: bloqueia segredos
        entry: scripts/check-no-secrets.sh
        language: script
        pass_filenames: false
  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.6.0
    hooks: [{ id: ruff, args: [--fix] }, { id: ruff-format }]
  - repo: https://github.com/compilerla/conventional-pre-commit
    rev: v3.4.0
    hooks: [{ id: conventional-pre-commit, stages: [commit-msg] }]
```
```bash
pip install pre-commit && pre-commit install --hook-type pre-commit --hook-type commit-msg
```

## Qualquer stack (lefthook)

`lefthook.yml`:
```yaml
pre-commit:
  commands:
    secrets: { run: scripts/check-no-secrets.sh }
    lint:    { glob: "*.{go,rs,ts,py}", run: "<linter> {staged_files}" }
commit-msg:
  commands:
    conventional: { run: "npx --no -- commitlint --edit {1}" }
```

## Verificação (evidência de que as travas funcionam)

```bash
echo "X=1" > .env.local && git add -f .env.local && git commit -m "test: x"   # deve BLOQUEAR
git commit --allow-empty -m "ajustes"                                          # deve REJEITAR
git reset -q HEAD .env.local; rm .env.local
```

Recomendado também: `gitleaks detect` uma vez no histórico, e no CI.
