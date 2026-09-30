# 05 — O ciclo de uma feature

Ordem oficial:

```
Constitution → Specify → Clarify → Plan → Checklist → Tasks → Analyze → Implement
                                                                         │
                          Review por subagente contra plan.md ◄──────────┘
                                         │
                          Validação ao vivo (quickstart.md) → PR com evidência → merge → registro
```

A constituição roda uma vez no início do projeto (e em emendas). As outras fases rodam **por feature**.

Para cada fase: **entrada**, **saída**, **o que você revisa** (seu gate) e **erros comuns**.

---

## 0. Antes de começar: branch e frase da sessão

```bash
git checkout main && git pull
git checkout -b feat/NNN-nome-curto
```

E a frase: *"Hoje eu entrego a spec de X e sei que terminei quando o spec.md não tiver nenhum `[NEEDS CLARIFICATION]`."* Uma feature raramente cabe numa sessão — tudo bem; cada sessão fecha uma ou mais fases.

---

## 1. `/speckit-specify` — o QUÊ e o PORQUÊ

**Entrada:** descrição em linguagem natural. Quanto mais contexto de negócio, melhor: quem sofre, qual a dor, de onde veio (ex.: "item B11 do ROADMAP", "relato do cliente-piloto na visita de 18/08").

**Saída:** `specs/NNN-nome/spec.md` + `checklists/requirements.md` (qualidade da spec), e a pasta registrada em `.specify/feature.json`.

Estrutura do `spec.md`:
- **User Stories priorizadas (P1, P2, P3)**, cada uma com *Why this priority*, *Independent Test* e *Acceptance Scenarios* (Given/When/Then).
- **Edge Cases.**
- **Functional Requirements** numerados (`FR-001`...) — serão citados em plano, tarefas, testes e código.
- **Key Entities** (se houver dado).
- **Success Criteria** mensuráveis (`SC-001`...).
- **Assumptions.**

**Você revisa:**
- [ ] Zero tecnologia (nada de "endpoint", "tabela", "React"). Se aparecer, é vazamento de plano.
- [ ] Cada user story é **testável sozinha** e entrega valor sozinha.
- [ ] Cada FR é verificável ("o sistema recusa X quando Y"), não vago ("o sistema deve ser rápido").
- [ ] Fora de escopo está claro.

**Erros comuns:** spec que é um plano disfarçado; user story que só faz sentido junto com outra; critério de sucesso interpretável.

---

## 2. `/speckit-clarify` — resolver ambiguidade ANTES de planejar

**Entrada:** o `spec.md`.
**Saída:** até ~5 perguntas direcionadas; as respostas entram no `spec.md` em `## Clarifications / ### Session AAAA-MM-DD`, com referência ao FR afetado.

Exemplo real:
> **Pedido 100% fora da cozinha** → **Nasce pronto para servir**: pula o preparo, aparece direto na fila de saída. (FR-010, FR-011)

**Você revisa:** as respostas são **suas decisões de produto**. Se a IA ofereceu uma opção "(Recomendada)", avalie — não aceite por inércia.

**Não pule** mesmo quando "parece tudo claro". Toda pergunta respondida aqui é um retrabalho a menos no código.

---

## 3. `/speckit-plan` — o COMO

**Entrada:** `spec.md` clarificada + constituição + código existente.
**Saída:**
- `plan.md` — Summary, Technical Context, **Constitution Check** (tabela princípio × como o plano atende), Project Structure, Complexity Tracking (exceções justificadas).
- `research.md` — cada decisão técnica com **alternativas descartadas e por quê**.
- `data-model.md` — entidades, campos, índices, **migração** (up/down).
- `contracts/` — contratos de API/eventos (request, response, códigos de erro, RBAC).
- `quickstart.md` — **roteiros de validação** checáveis ("Roteiro 2: criar X como perfil Y → esperado: 403").

**Você revisa (o gate mais importante do fluxo):**
- [ ] **Constitution Check** preenchido princípio por princípio, com *como* é atendido — não só "✅".
- [ ] Toda divergência de convenção do projeto está registrada e justificada ("Convenção divergente: remoção física em vez de soft-delete, porque nada histórico referencia esta entidade").
- [ ] Em código existente: há um **"achado central da pesquisa"** — quem consome o que vai mudar?
- [ ] Reuso: o plano reaproveita mecanismos existentes em vez de criar paralelos? (Ex.: override de permissão por método em vez de módulo novo.)
- [ ] Decisão arquitetural nova → vira ADR.
- [ ] Fora de escopo explícito.

**Erros comuns:** Constitution Check genérico; `research.md` sem alternativas; plano afirmando que um teste existe sem que exista (ver `09`).

---

## 4. `/speckit-checklist` — "testes unitários para o texto"

**Entrada:** um foco (ex.: "requisitos", "segurança", "UX", "API").
**Saída:** `checklists/<foco>.md` com perguntas que testam se a spec está **completa, clara, consistente e mensurável** — não se o código funciona.

Exemplo real de gap pego aqui: "o motivo do fechamento forçado tem tamanho máximo?" → virou FR com teto de 280 chars, e revelou que um DTO antigo aceitava motivo só-de-espaços.

**Você revisa:** cada item marcado como gap vira correção **no `spec.md`**, não no código.

---

## 5. `/speckit-tasks` — quebrar em passos pequenos

**Saída:** `tasks.md`, formato `- [ ] T012 [P] [US1] Descrição com caminho de arquivo`:
- `[P]` = paralelizável (arquivos diferentes, sem dependência).
- `[US1]` = user story a que pertence.
- Fases: **Setup → Foundational (bloqueante) → uma fase por user story (P1 primeiro = MVP) → Polish**.
- **Checkpoint** ao fim de cada fase: o que precisa estar verdadeiro.
- Testes **antes** da implementação dentro de cada story (TDD).

**Você revisa:**
- [ ] Tarefas têm caminho de arquivo e são pequenas (uma sessão curta cada).
- [ ] A fase Foundational contém só o que *realmente* bloqueia (ex.: a migration indivisível).
- [ ] Cada FR aparece em pelo menos uma tarefa, e cada tarefa de lógica não trivial tem tarefa de teste.
- [ ] Tarefas que dependem de ação humana/externa estão marcadas (ex.: `⚠️` — "precisa de acesso ao painel X").

---

## 6. `/speckit-analyze` — consistência cruzada ANTES de codar

**Entrada:** `spec.md` + `plan.md` + `tasks.md` + constituição.
**Saída:** relatório (não altera arquivos) com achados por severidade: CRITICAL / HIGH / MEDIUM / LOW — cobertura de FR, contradições, termos inconsistentes, violações de constituição.

Achados reais que ele pegou antes de virar bug:
- **CRITICAL:** isolamento multi-tenant sem teste para uma tabela nova, embora o `plan.md` afirmasse que existia.
- **CRITICAL:** design aprovado (checkout público sem login) contradizia o texto da constituição → emenda da constituição (v1.0.1 → v1.1.0).
- **HIGH:** código de erro 404 vs. 409 inconsistente entre spec e contrato.
- **Duplicação de regra:** mesma regra de UI prevista em 4 telas → extraída para uma função pura.

**Você decide** o que corrigir. Correções vão **nos artefatos** (spec/plan/tasks/constituição), e o analyze roda de novo se a mudança foi grande.

> **Não pule o analyze ao retomar uma feature de outra sessão.** Foi justamente nas features "retomadas com plan/tasks prontos" que ele deixou de rodar — e é onde mais faz falta, porque o contexto foi perdido.

---

## 7. `/speckit-implement` — executar contra o plano

**Comportamento esperado do agente:**
- Segue `tasks.md` fase a fase, marcando `[X]` ao concluir.
- TDD na lógica não trivial: teste vermelho → implementação → verde.
- **Nunca** `skip`, assert removido ou teste afrouxado para passar.
- Para no checkpoint de cada fase e mostra evidência (output de teste).

**Você faz:**
- Revisa por checkpoint, não só no fim.
- Se a implementação revelar que o **plano estava errado**, pare: atualize `research.md`/`plan.md`/`tasks.md` primeiro, decida, depois continue. Exemplo real: o plano lia um dado "ao vivo" por join, o que violava o requisito de não-retroatividade; a correção (gravar snapshot no item) foi decidida com o usuário e **registrada no research.md §7** antes de seguir.
- Achou bug fora do escopo? Anote em `ROADMAP.md`, não corrija no mesmo diff (a menos que seja consequência direta de um FR — e então registre isso).

---

## 8. Review por subagente contra o `plan.md`

Depois de implementar, antes do PR. Um agente **com contexto limpo** revisa o diff contra os artefatos. Prompt-base:

```
Revise o diff desta branch contra specs/NNN-nome/plan.md, spec.md e tasks.md.
Verifique e reporte com arquivo:linha:
1. Todo FR da spec tem implementação E teste que o prova.
2. Toda afirmação do plan.md sobre testes/arquivos é verdadeira (o teste citado existe?).
3. Constitution Check: cada princípio é de fato atendido no código.
4. Edge cases da spec têm teste.
5. Nada fora do escopo foi alterado (liste arquivos tocados que não estão no plano).
6. Nenhum teste pré-existente foi apagado, pulado ou afrouxado.
Não corrija nada; só reporte achados com severidade.
```

Achados reais desta etapa: testes pré-existentes apagados por engano ao criar os novos; RBAC de leitura divergindo de um FR; auditoria fora do `try/catch`, podendo quebrar o fluxo principal; plano citando teste unitário que não existia. **Todo achado vira correção + suíte re-executada verde.**

Complementar (opcional, pós-PR): `/code-review high` — review independente focado em bugs, sem olhar o plano.

---

## 9. Validação ao vivo (`quickstart.md`)

Testes automatizados não pegam tudo. Rode os roteiros do `quickstart.md` contra o sistema **rodando de verdade** (API por `curl`, UI por navegador — no Claude Code, via Claude in Chrome), e capture evidência (comando + retorno, screenshot).

Cuidados aprendidos:
- **Confirme que o ambiente roda o código novo** (modo watch/rebuild). Um build antigo em execução gera falsos negativos convincentes.
- Use **contas/dados de teste** e reverta alterações em dados reais.
- Bug encontrado aqui → teste de regressão **antes** do fix.

---

## 10. PR, merge e registro

- PR pelo template (`templates/pull_request_template.md`), com **evidência colada**: contagem de testes, output, screenshots.
- CI verde é pré-requisito do merge (branch protection).
- Após merge: `CHANGELOG.md`, fase no `CLAUDE.md`/`ROADMAP.md`, ADR se houve decisão nova, pendências descobertas registradas.

---

## Mapa de artefatos × fase

| Artefato | Criado em | Atualizado em |
|---|---|---|
| `spec.md` | specify | clarify, checklist, analyze |
| `checklists/*.md` | specify, checklist | — |
| `plan.md`, `research.md`, `data-model.md`, `contracts/`, `quickstart.md` | plan | analyze, implement (se o plano mudar), review |
| `tasks.md` | tasks | analyze, implement (`[X]`), converge |
| `constitution.md` | constitution | emendas (raras, versionadas) |
