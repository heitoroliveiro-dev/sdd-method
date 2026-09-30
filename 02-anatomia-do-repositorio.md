# 02 — Anatomia do repositório

Estrutura-alvo de um projeto com SDD. Nem tudo nasce no dia 1 (ver `03`/`04` para a ordem), mas é para cá que o repositório converge.

```
projeto/
├── CLAUDE.md                     # hub de contexto lido pelo agente em TODA sessão (curto!)
├── CHANGELOG.md                  # o que mudou e quando (Keep a Changelog)
├── CONTRIBUTING.md               # branches, commits, hooks, DoD
├── README.md                     # como rodar o projeto
│
├── .specify/                     # ← gerado pelo Spec Kit (`specify init`)
│   ├── memory/constitution.md    #   princípios não negociáveis (versionados)
│   ├── templates/                #   spec/plan/tasks/checklist/constitution templates
│   ├── scripts/bash/             #   create-new-feature.sh, setup-plan.sh, check-prerequisites.sh...
│   ├── feature.json              #   feature ativa ({"feature_directory": "specs/018-..."})
│   └── init-options.json         #   opções do init (ai, numeração, script)
│
├── .claude/
│   ├── skills/speckit-*/         # ← comandos /speckit-* (gerados pelo Spec Kit)
│   └── settings.json             #   hooks do Claude Code (ex.: lembrete de regras a cada prompt)
│
├── specs/                        # uma pasta por feature, numerada
│   └── 018-categorias-produto/
│       ├── spec.md               #   O QUÊ e PORQUÊ (sem tecnologia)
│       ├── checklists/           #   "testes unitários para o texto" da spec
│       ├── plan.md               #   O COMO + Constitution Check
│       ├── research.md           #   decisões técnicas e alternativas descartadas
│       ├── data-model.md         #   entidades, campos, migrações
│       ├── contracts/            #   contratos de API/eventos
│       ├── quickstart.md         #   roteiros de validação manual, checáveis
│       └── tasks.md              #   tarefas pequenas, ordenadas, com [X] ao concluir
│
├── docs/
│   ├── PLAYBOOK-CONDUCAO.md      # como VOCÊ conduz o projeto (não é sobre código)
│   ├── GUIA-DOCUMENTACAO.md      # o que/onde/quando documentar
│   ├── ROADMAP.md                # fases, marcos, pendências, backlog futuro
│   ├── 00-discovery/             # proposta funcional (fonte de verdade do produto)
│   ├── 01-architecture/adr/      # ADRs numerados + template
│   ├── 01-architecture/modelagem-dados.md
│   ├── 02-security/              # estratégia de segurança
│   ├── 03-testing/               # estratégia de testes + cobertura mínima
│   ├── 04-observability/         # logs, métricas, alertas
│   ├── 05-runbooks/              # deploy, backup/restore, provisionamento
│   └── 06-design/                # diretrizes de UI/UX
│
├── scripts/
│   ├── check-no-secrets.sh       # usado pelo pre-commit
│   └── context-reminder.sh       # usado pelo hook UserPromptSubmit do Claude Code
│
├── .husky/                       # pre-commit (segredos + lint-staged) e commit-msg (commitlint)
└── .github/
    ├── pull_request_template.md  # DoD + campo de evidência
    └── workflows/ci.yml          # lint/test/e2e/build como checks obrigatórios
```

## Papel de cada peça (e quem lê)

| Peça | Quem lê | Natureza | Por que existe |
|---|---|---|---|
| `CLAUDE.md` | Agente, toda sessão | **Advisory** (a IA pode esquecer) | Contexto mínimo: o que é, stack, regras, fase atual, índice |
| `constitution.md` | Comandos `/speckit-*` (gate do plan) | **Advisory, mas checado** | Princípios que todo plano precisa atender explicitamente |
| Hooks git (`.husky`) | Git | **Determinístico** | O que *não pode* falhar: segredos, lint, formato de commit |
| Hook do Claude Code | Harness | Determinístico (injeção) | Reforço das regras a cada prompt |
| CI | GitHub | **Determinístico + bloqueante** | Branch protection exige checks verdes |
| `specs/NNN/` | Você + agente | Contrato da feature | Rastreabilidade: requisito → plano → tarefa → teste |
| `docs/` | Sob demanda | Satélites | Detalhe que não cabe no `CLAUDE.md` |

### Regra de ouro da camada de regras

> **Regra que precisa ser garantida vai em hook ou CI, não só no `CLAUDE.md`.**

O `CLAUDE.md` é conselho; o hook é lei. Quando uma regra do `CLAUDE.md` for ignorada uma vez, a correção durável é movê-la para um mecanismo determinístico (pre-commit, CI, lint rule, teste).

### `CLAUDE.md` vs. `constitution.md`

São complementares e precisam ficar coerentes:
- **`constitution.md`**: princípios com *rationale*, versionamento semântico, lido pelos comandos SDD. Muda raramente e sempre com emenda registrada.
- **`CLAUDE.md`**: resumo operacional, lido em toda sessão. Espelha as regras imutáveis em uma linha cada, e aponta para os satélites.

Se você emendar a constituição, atualize a linha correspondente do `CLAUDE.md` **no mesmo commit**.

### Numeração de features

`specs/001-...`, `002-...` — sequencial (`"feature_numbering": "sequential"` no init). A branch segue o mesmo nome: `feat/018-categorias-produto`. Isso liga branch ↔ pasta ↔ PR sem esforço.
