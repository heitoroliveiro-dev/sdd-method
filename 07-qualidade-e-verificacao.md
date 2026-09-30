# 07 — Qualidade e verificação

## 1. Evidência, não afirmação

> Nenhuma tarefa é concluída por afirmação. Critério de sucesso é **checável**.

| Interpretável (proibido) | Checável (exigido) |
|---|---|
| "Está funcionando" | "`npm test`: 358 passed, 0 failed" (output colado) |
| "Código bem estruturado" | "Lint: 0 erros" |
| "Isolamento garantido" | "e2e `tenant A lê recurso de B → 404` passa" |
| "Rate limit implementado" | "16ª requisição em 1 min → 429" |
| "Tela ajustada" | Screenshot nos dois temas |

**Formas aceitas de evidência:** output de teste; comando + retorno; screenshot/GIF; contagem de testes antes/depois. Revisar evidência é mais rápido que re-rodar — e mais confiável que confiar na palavra de quem implementou, **inclusive quando é um agente**.

## 2. Definition of Done (todo merge)

Ver `checklists/definition-of-done.md`. Base:

- [ ] Testes automatizados passando; cobertura dentro do mínimo definido
- [ ] Lint sem erros
- [ ] Nenhum segredo hardcoded
- [ ] Validação de entrada revisada nos pontos novos (DTO/schema + auth)
- [ ] Invariantes do domínio intactas (ex.: isolamento multi-tenant com teste)
- [ ] Doc atualizada (ADR / README / runbook / CHANGELOG / contrato)
- [ ] Review por subagente contra o `plan.md` (features SDD)
- [ ] Evidência anexada no PR
- [ ] Nada fora do escopo alterado

## 3. Testes

### Pirâmide
- **Unitários (maioria):** regra de negócio pura. Extraia regras para **funções puras** sempre que possível — ficam testáveis e reaproveitáveis (ex.: `calcularTotalItens()`, `calcularAtrasado()`, `proximoCriterio()`).
- **Integração/e2e de API (meio):** rota + banco real (Testcontainers ou equivalente). É aqui que se prova **isolamento, RBAC e códigos de erro**.
- **E2E de UI (topo, poucos):** fluxos críticos ponta a ponta. Complementado pela validação ao vivo do `quickstart.md`.

### Regras invioláveis
1. **Nenhum teste mascarado.** Proibido `skip`, `xit`, `.only` esquecido, assert removido, expectativa afrouxada para passar. Teste falhou → conserta o código.
2. **Todo bug corrigido ganha teste de regressão que falha antes do fix.**
3. **Todo invariante crítico tem teste que o prova** — não "confia no framework".
4. **Não apague testes existentes** ao criar novos (aconteceu; o review pegou).

### O perigo dos mocks
Achado real: um teste de componente mockava o hook de dados já filtrado, então o branch "mesa inativa aparece em vermelho" tinha teste verde — mas o hook real removia as mesas inativas *antes* do componente rodar. Em produção, o branch nunca executava.

**Regra:** para cada comportamento crítico, pelo menos um teste precisa passar pelo **caminho real de dados** (hook real + API mockada na borda de rede, ou e2e). Mock no ponto mais externo possível.

### Teste de ação, não só de estado
"Botão está habilitado" não prova que o botão faz algo. Para toda ação nova de UI: clique → verifique a chamada/efeito.

## 4. Camadas de trava (do mais fraco ao mais forte)

| Camada | Garante | Pode ser ignorada? |
|---|---|---|
| `CLAUDE.md` | Contexto e regras (conselho) | Sim — o agente pode esquecer |
| Hook do Claude Code (`UserPromptSubmit`) | Reforço das regras a cada prompt | Não é ignorado, mas ainda é conselho |
| Constituição + Constitution Check | Todo plano responde a cada princípio | Só se você aprovar plano sem ler |
| Pre-commit (segredos, lint-staged, testes relacionados) | Nada entra sem passar | Só com `--no-verify` (proibido) |
| commit-msg (commitlint) | Histórico legível | Idem |
| CI obrigatório + branch protection | Nada chega em `main` quebrado | Não |

Quando uma regra "advisory" for violada, **promova-a** para uma camada mais forte.

## 5. Review por subagente

Detalhe em `05-ciclo-da-feature.md §8`. Pontos-chave:
- **Contexto limpo** — não é o mesmo agente que implementou revisando a si mesmo.
- Revisa **contra o plano**, não "no geral".
- Verifica **afirmações** dos artefatos ("o plano diz que existe teste X — existe?").
- Se o subagente falhar (limite, erro), faça o review você mesmo com o mesmo checklist e registre isso.
- Rodadas múltiplas são normais em features grandes (uma por bloco de user stories).

## 6. CI

Um job por check, todos obrigatórios na branch protection:
`lint` · `test` (unit) · `test-e2e` · `build` — para cada app (backend/frontend).

Deploy só a partir de `main`, depois dos checks. Health check do deploy precisa testar **o que importa** — ver lição sobre banco vazio em `09`.

## 7. Segurança no dia a dia

- Validação de entrada em toda rota de mutação (DTO + whitelist + `forbidNonWhitelisted` ou equivalente).
- Parâmetros de ordenação/filtro dinâmicos via **allowlist** — nunca coluna livre interpolada em query.
- IDs de rota validados (ex.: `ParseUUIDPipe`).
- Rota pública só por decisão explícita da constituição — e com as mesmas regras de negócio de uma autenticada.
- Log nunca contém segredo, senha, token, dado de cartão, telefone completo, `request.body` inteiro.
- Erro inesperado: **logado** antes de virar mensagem genérica (engolir exceção sem log torna bug real invisível).
