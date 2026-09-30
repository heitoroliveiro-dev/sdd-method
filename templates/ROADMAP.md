# Roadmap — <PROJETO>

> Mantenha "Onde estou agora" curto e sempre verdadeiro. Detalhe de cada entrega vive em `specs/`, no PR e no `CHANGELOG.md` — não aqui.

## Onde estou agora

**Fase atual:** <Fx — nome> · **Próximo marco:** <Marco N — nome>
**Próxima ação:** <uma frase>
**Bloqueios:** <ou "nenhum">

## O Norte

<Uma frase.>

## Etapas até o produto final

| # | Etapa | O que entrega | Depende de | Pronto quando | Status |
|---|---|---|---|---|---|
| F0 | Discovery | Proposta funcional, fora-do-v1 | — | Norte + requisitos numerados | ✓ |
| F1 | Arquitetura | ADRs críticos, modelagem | F0 | Todo ADR crítico aceito | |
| F2 | Fundação técnica | Scaffold, hooks, CI, auth, <invariante> com teste | F1 | App sobe, CI verde, isolamento provado | |
| F3.1 | <Feature 1> | … | F2 | <critério checável> | |
| ⭐ M1 | **<Marco 1>** | <valor real para o usuário> | F3.x | <evento verificável com usuário real> | |
| F4 | CI/CD + deploy | Pipeline, deploy, rollback, backup | F3.x | Deploy com rollback provado | |
| ⭐ M2 | **<Marco 2 — produção>** | | M1, F4 | | |

## Pendências antes do próximo marco

| # | Item | Origem | Triagem (rápida/SDD) | Status / PR |
|---|---|---|---|---|
| 1 | | uso real AAAA-MM-DD | | |

## Pendências técnicas (achados de revisão)

| Prioridade | Achado | Risco | Status / PR |
|---|---|---|---|
| P1 | | | |

## Pendências fora do código (⚠️)

| Item | Bloqueado por | O que desbloqueia | Impede o quê |
|---|---|---|---|
| | acesso a hardware / aprovação externa / plano pago | | nada adiante / Marco N |

## Backlog futuro (fora do escopo atual)

- <Ideia> — adiada porque <motivo>; reavaliar quando <gatilho>.
