# Manual de Spec-Driven Development (SDD) com Claude Code + GitHub Spec Kit

> Manual genérico, aplicável a **qualquer projeto** (do zero ou já existente), destilado de um projeto real que rodou 18+ features por esse fluxo: o **CigMenu** (SaaS multi-tenant NestJS + React + Postgres). Tudo aqui foi usado de verdade — inclusive os erros, que viraram o capítulo de lições.

## A ideia em uma frase

**A IA executa e propõe; você decide e aprova.** O SDD é a estrutura que faz essa frase ser verdade na prática: cada feature nasce como texto (o quê e o porquê), vira plano (o como), vira tarefas pequenas, e só então vira código — com evidência de que funciona, não afirmação.

## Como ler este manual

| # | Arquivo | Quando ler |
|---|---|---|
| 01 | [Fundamentos](01-fundamentos.md) | Primeiro. O porquê, os papéis, as três alturas de visão |
| 02 | [Anatomia do repositório](02-anatomia-do-repositorio.md) | Para entender o que cada pasta/arquivo faz |
| 03 | [Implantação em projeto novo](03-implantacao-projeto-novo.md) | Greenfield: do `git init` à primeira feature |
| 04 | [Implantação em projeto existente](04-implantacao-projeto-existente.md) | Brownfield: adotar SDD em código que já roda |
| 05 | [O ciclo de uma feature](05-ciclo-da-feature.md) | Referência de cada fase (specify → implement) |
| 06 | [Triagem: SDD completo ou trilha rápida](06-triagem-e-trilha-rapida.md) | Toda vez que surgir uma demanda nova |
| 07 | [Qualidade e verificação](07-qualidade-e-verificacao.md) | DoD, evidência, review por subagente, hooks, CI |
| 08 | [Documentação viva](08-documentacao-viva.md) | ADR, CHANGELOG, roadmap, rastreamento de fase |
| 09 | [Armadilhas e lições reais](09-armadilhas-e-licoes.md) | Antes de começar, e de novo depois de 3 features |
| 10 | [Referência rápida (cola)](10-referencia-rapida.md) | Deixar aberto do lado |

Material para copiar:

- [`templates/`](templates/) — `CLAUDE.md`, constituição inicial, playbook, guia de documentação, roadmap, ADR, template de PR, CONTRIBUTING, estratégia de testes, receitas de hooks git (Node/Python/lefthook), hook do Claude Code, esqueleto de CI, scripts.
- [`checklists/`](checklists/) — início/fim de sessão, triagem, revisão dos artefatos (seus gates), Definition of Done.

## Caminho mínimo (se você só tem 30 minutos)

1. Leia `01-fundamentos.md` e `06-triagem-e-trilha-rapida.md`.
2. Siga `03` (projeto novo) ou `04` (projeto existente) até a seção "Primeira feature".
3. Copie `templates/CLAUDE.md` e `checklists/definition-of-done.md` pro projeto.
4. Rode a primeira feature com `10-referencia-rapida.md` aberto.

## Glossário curto

- **SDD** — Spec-Driven Development: a especificação é o artefato primário; código é derivado dela.
- **Spec Kit** — ferramenta open-source do GitHub (`github/spec-kit`) que instala os comandos `/speckit-*`, templates e scripts do fluxo.
- **Constituição** — princípios não negociáveis do projeto (`.specify/memory/constitution.md`), checados em todo `plan.md`.
- **Artefatos da feature** — `spec.md`, `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md`, `checklists/`, `tasks.md`, dentro de `specs/NNN-nome/`.
- **DoD** — Definition of Done: o checklist que toda entrega cumpre antes do merge.
- **Evidência** — output de teste, comando + retorno, screenshot. O oposto de "está funcionando".
