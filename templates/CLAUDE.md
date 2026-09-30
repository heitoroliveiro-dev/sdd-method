# CLAUDE.md — <PROJETO>

> Hub de contexto do projeto, lido pelo agente em toda sessão. **Máximo ~200 linhas e ~15 KB.** Este arquivo indexa, não duplica: detalhe vive em `docs/`, histórico em `CHANGELOG.md`, contrato de feature em `specs/`.

## O que é

<Uma frase: o que o produto resolve e pra quem.>
Fonte de verdade do produto: `docs/00-discovery/proposta-funcional.md`.

## Stack (imutável sem ADR)

- **Backend:** <linguagem/framework, modo estrito>
- **Banco:** <banco>
- **Frontend:** <framework> (ADR-000X)
- **Infra local:** <Docker/…>

Justificativa: `docs/01-architecture/adr/adr-0001-stack.md`.

## Regras imutáveis (hard constraints)

- NUNCA commitar segredos (`.env`, chaves, tokens). Variáveis de ambiente.
- NUNCA SQL cru concatenado — ORM/query builder parametrizado.
- NUNCA force push em `main`. NUNCA commit direto em `main` — branch (`feat/`, `fix/`, `chore/`) + PR.
- NUNCA apagar branch sem confirmação.
- Toda rota de mutação valida entrada e exige autenticação/autorização (exceções só as nomeadas na constituição).
- Menor privilégio por padrão.
- <Invariante de domínio crítico, ex.: nenhuma query cruza `tenant_id`.>
- Nenhuma feature não trivial sem o fluxo SDD (abaixo).

Constituição completa: `.specify/memory/constitution.md` — manter coerente com esta lista.

## Fluxo SDD (GitHub Spec Kit)

**Constitution → Specify → Clarify → Plan → Checklist → Tasks → Analyze → Implement**, depois review por subagente contra `plan.md`.

Não pular fase em feature não trivial. Bug de ~1 arquivo ou CRUD trivial no padrão existente: trilha rápida (plan mode + teste + evidência). Na dúvida, SDD.

## Definition of Done (todo merge)

- [ ] Testes passando; cobertura mínima de `docs/03-testing`
- [ ] Lint sem erros
- [ ] Nenhum segredo hardcoded
- [ ] Validação de entrada revisada nos pontos novos
- [ ] Doc atualizada (ADR/README/runbook/CHANGELOG/contrato)
- [ ] Review por subagente contra o `plan.md`
- [ ] Evidência anexada (output de teste, comando + retorno, screenshot)

## Verificação: evidência, não afirmação

Ao concluir, mostre evidência. Critérios checáveis ("curl retorna 429"), nunca interpretáveis ("código bem estruturado"). Proibido `skip`, assert removido ou teste afrouxado para passar. Todo bug corrigido ganha teste de regressão.

## Comandos

```
# dev:   <comando>
# test:  <comando>
# e2e:   <comando>
# lint:  <comando>
# build: <comando>
# migrate: <comando>
```

## Fase atual

- **Fase:** <ex.: F3 — ciclo de features>. **Feature ativa:** <specs/NNN-nome> (<status>).
- **Próximo:** <uma ação concreta>.
- Histórico completo: `docs/ROADMAP.md` e `CHANGELOG.md` (não duplicar aqui).

## Índice de documentação (carregar sob demanda)

| Preciso de... | Vá para |
|---|---|
| Como conduzo o projeto | `docs/PLAYBOOK-CONDUCAO.md` |
| O que/onde/quando documentar | `docs/GUIA-DOCUMENTACAO.md` |
| Fases, marcos, pendências | `docs/ROADMAP.md` |
| O que o produto é | `docs/00-discovery/proposta-funcional.md` |
| Decisões de arquitetura | `docs/01-architecture/adr/` |
| Modelagem de dados | `docs/01-architecture/modelagem-dados.md` |
| Segurança | `docs/02-security/` |
| Testes | `docs/03-testing/estrategia-testes.md` |
| Observabilidade | `docs/04-observability/` |
| Operação (deploy, backup) | `docs/05-runbooks/` |
| UI/UX | `docs/06-design/` |

## Papel do agente neste projeto

- Questionar ambiguidade antes de gerar código — pedido vago recebe pergunta.
- Não assumir comportamento de lib/framework — consultar doc oficial da versão em uso.
- Sinalizar overengineering, abstração desnecessária, desvio de SOLID/DRY/KISS.
- Antes de mexer em estrutura existente: explicar impacto, propor mudança pequena e reversível.
- Preservar padrões bons existentes; questionar os ruins com o porquê.
- Decisão com mais de um caminho: apresentar alternativas + recomendação; o humano decide.
