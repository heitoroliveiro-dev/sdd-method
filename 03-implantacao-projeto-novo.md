# 03 — Implantação em projeto novo (greenfield)

Ordem importa. Cada etapa tem um **critério de pronto checável**.

## Etapa 0 — Pré-requisitos

- `git`, runtime da stack (ex.: `node` LTS, `python`, `go`), `docker` se houver banco.
- `uv` (para rodar o Spec Kit sem instalar globalmente): https://docs.astral.sh/uv/
- Claude Code instalado.
- Repositório vazio criado no GitHub.

## Etapa 1 — Discovery (Fase 0): o Norte antes do código

Escreva `docs/00-discovery/proposta-funcional.md` **antes** de qualquer comando. Conteúdo mínimo:

1. Problema e para quem (persona real, se possível um cliente-piloto).
2. O Norte em uma frase.
3. Requisitos funcionais numerados (`RF-01.1`, `RF-01.2`...) — o código vai citá-los.
4. Requisitos não funcionais numerados (`RNF-01: status atualiza em ≤ 2s`).
5. **Fora do v1** — lista explícita.
6. Prioridade de entrega (o que gera valor primeiro).

> A IA pode formatar e fazer perguntas, mas o *porquê* sai da sua cabeça. Se ela inventar requisito que você não pediu, corte.

**Pronto quando:** você consegue ler a lista "fora do v1" e dizer "não" a uma ideia sem culpa.

## Etapa 2 — Criar o repo e instalar o Spec Kit

```bash
git clone git@github.com:<voce>/<projeto>.git && cd <projeto>
uvx --from git+https://github.com/github/spec-kit.git specify init . --ai claude
```

Isso cria `.specify/` (templates, scripts, constituição vazia) e os comandos do agente em `.claude/skills/speckit-*` (versões recentes) ou `.claude/commands/` (versões antigas). **Reinicie o Claude Code** depois, senão os comandos não aparecem.

Verifique:
```bash
ls .specify/templates .claude/skills 2>/dev/null || ls .claude/commands
```

> Nome dos comandos: versões recentes usam hífen (`/speckit-specify`); antigas usam ponto (`/speckit.specify`). Mesmo comando. Consulte `.specify/integration.json` → `invoke_separator`.

**Pronto quando:** digitar `/speckit` no Claude Code lista os comandos.

## Etapa 3 — Aplicar o kit de contexto (o que o Spec Kit não gera)

Copie deste manual (`templates/`) e adapte:

| De | Para | Adaptar |
|---|---|---|
| `templates/CLAUDE.md` | `CLAUDE.md` | Nome, stack, regras imutáveis, comandos de build |
| `templates/PLAYBOOK-CONDUCAO.md` | `docs/` | O Norte do projeto |
| `templates/GUIA-DOCUMENTACAO.md` | `docs/` | Quase nada |
| `templates/ROADMAP.md` | `docs/` | Fases e marcos do seu produto |
| `templates/adr-template.md` | `docs/01-architecture/adr/` | — |
| `templates/estrategia-testes.md` | `docs/03-testing/` | Ferramentas, cobertura |
| `templates/CONTRIBUTING.md` | raiz | Nomes de branch, comandos |
| `templates/pull_request_template.md` | `.github/` | Itens de DoD específicos |
| `templates/scripts/*` | `scripts/` | `chmod +x` |
| — | `CHANGELOG.md` | Criar vazio no formato Keep a Changelog |

**Pronto quando:** `CLAUDE.md` tem < 200 linhas e responde "o que é, stack, regras, fase atual, onde está o resto".

## Etapa 4 — Constituição

No Claude Code:

```
/speckit-constitution
```

Entregue como insumo as regras imutáveis do seu `CLAUDE.md` + riscos específicos do domínio. Use `templates/constitution-inicial.md` como ponto de partida. Bons princípios têm três coisas:

1. **Regra verificável** ("toda rota tenant-scoped tem teste de integração que prova isolamento"), não desejo ("o código deve ser seguro").
2. **Rationale** — por que existe; é o que permite julgar casos de borda depois.
3. Marcação **NON-NEGOTIABLE** só no que realmente é (2–3 no máximo).

**Pronto quando:** `.specify/memory/constitution.md` tem versão `1.0.0`, data de ratificação, e cada princípio tem rationale.

## Etapa 5 — Arquitetura (Fase 1): ADRs antes de scaffold

Para cada decisão com mais de um caminho e custo de reverter, um ADR (`docs/01-architecture/adr/adr-000N-*.md`):
- ADR-0001 stack (sempre).
- Isolamento de dados / multi-tenancy, autenticação, tempo real, provedor externo relevante, frontend, deploy.

Modelagem de dados inicial em `docs/01-architecture/modelagem-dados.md`.

**Pronto quando:** todo ADR crítico está "aceito" com alternativas registradas.

## Etapa 6 — Fundação técnica (Fase 2): as travas determinísticas

Nesta ordem:

1. **Scaffold** da stack (consultar a doc oficial da ferramenta na hora — não confiar em memória do agente).
2. **Lint + formatter.**
3. **Hooks git** (`husky` + `lint-staged` + `commitlint` em JS; `pre-commit` em Python; `lefthook` em qualquer stack):
   - pre-commit: `scripts/check-no-secrets.sh` → lint/format nos arquivos staged → testes relacionados.
   - commit-msg: Conventional Commits.
4. **Hook do Claude Code** (lembrete de regras a cada prompt) — ver `templates/claude-settings.json`.
5. **CI** (`templates/ci.yml`): lint, unit, integração/e2e, build — um job por check.
6. **Branch protection** em `main`: PR obrigatório + checks do CI obrigatórios + sem force push.
7. **Fundações transversais** que toda feature vai usar: conexão de banco + migrations, auth/RBAC, isolamento (se multi-tenant), com **teste de integração provando isolamento** desde já.

> Isso pode (e deve) passar pelo SDD também — "fundação" é feature não trivial. No CigMenu foi a F2.

**Pronto quando:** um commit com `.env` é bloqueado; um commit com mensagem "ajustes" é rejeitado; um PR com teste vermelho não consegue ser mergeado.

## Etapa 7 — Primeira feature

Escolha a feature que entrega o primeiro valor real (a prioridade 1 da proposta funcional), crie a branch e rode o ciclo completo descrito em [05-ciclo-da-feature](05-ciclo-da-feature.md):

```
/speckit-specify → /speckit-clarify → /speckit-plan → /speckit-checklist
→ /speckit-tasks → /speckit-analyze → /speckit-implement
→ review por subagente contra plan.md → PR com evidência
```

Na primeira feature, **leia cada artefato gerado com calma**. É aqui que você calibra: se o `spec.md` veio com tecnologia dentro, corrija; se o `plan.md` não tem "fora de escopo", peça. A qualidade das features seguintes depende do padrão que você aceitar agora.

**Pronto quando:** PR mergeado com evidência anexada, `CHANGELOG` atualizado, fase atualizada no `CLAUDE.md`.
