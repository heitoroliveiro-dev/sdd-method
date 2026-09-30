# 04 — Implantação em projeto existente (brownfield)

Adotar SDD em código que já roda é diferente: o código **é** a especificação atual, e ela nunca foi escrita. O erro clássico é tentar documentar tudo retroativamente. Não faça. **Documente o suficiente para a próxima mudança ser segura, e deixe o resto crescer por demanda.**

## Princípio: travas primeiro, documentação por demanda

```
Semana 1: diagnóstico + CLAUDE.md + travas determinísticas + constituição
Depois:   toda feature NOVA passa pelo SDD; o legado só ganha spec quando for tocado
```

## Etapa 1 — Diagnóstico (1 sessão, só leitura)

Peça ao agente um levantamento **sem alterar nada** (plan mode ou pedido explícito de "somente leitura"):

- Stack real (versões), como rodar, como testar, como fazer deploy.
- Estrutura de módulos e fronteiras.
- O que existe de teste (e se roda verde hoje — rode e cole o output).
- O que existe de lint/hook/CI.
- Riscos visíveis: segredo commitado, SQL concatenado, rota sem auth, ausência de isolamento, ausência de log/health.

Você revisa e corrige o levantamento. **Resultado:** um rascunho de `docs/01-architecture/README.md` (visão atual) e uma lista de riscos — que vai para `docs/ROADMAP.md § Pendências técnicas`, priorizada.

> Não corrija nada ainda. Diagnóstico e correção misturados viram um diff gigante que ninguém consegue revisar.

## Etapa 2 — Estabelecer a linha de base verde

Antes de qualquer SDD: **a suíte existente precisa rodar e você precisa saber o estado dela.**

- Se passa: ótimo, é a rede de segurança.
- Se falha: registre quais falham (e por quê, se souber) numa pendência. **Não "conserte" testes pulando ou apagando asserts** — isso é exatamente o que a constituição vai proibir.
- Se não há testes: a primeira pendência técnica é criar testes de caracterização nos fluxos críticos (o que o sistema faz hoje, certo ou errado).

## Etapa 3 — Instalar o Spec Kit no repo existente

```bash
cd projeto-existente
git checkout -b chore/adota-sdd
uvx --from git+https://github.com/github/spec-kit.git specify init --here --ai claude
```

Revise o diff: o init só deve adicionar `.specify/` e `.claude/skills/` (ou `commands/`). Se tocou em algo seu, reverta aquele arquivo.

## Etapa 4 — `CLAUDE.md` descrevendo o que É (não o que deveria ser)

Use `templates/CLAUDE.md`, mas preencha com a realidade:
- Stack **real**, comandos **reais** de build/test/lint.
- Convenções que o código já segue (nomes, camadas, padrão de erro) — "preservar padrões bons existentes".
- Padrões ruins conhecidos, marcados como tal ("não replicar X em código novo; ver pendência P3").
- Fase atual: "adoção de SDD; legado sem specs".

## Etapa 5 — Constituição a partir do que dói

Em brownfield, a constituição não nasce de ideal — nasce dos riscos do diagnóstico e dos incidentes que já aconteceram. Pergunta-guia: *"que erro, se acontecer de novo, é inaceitável?"*

Comece pequena (3–5 princípios). Todo princípio precisa ser **cumprível por código novo a partir de hoje** — não declare "100% de cobertura" num projeto com 10%. Declare "todo código novo ou tocado ganha teste" e "todo bug corrigido ganha teste de regressão".

## Etapa 6 — Travas determinísticas incrementais

Mesmo conteúdo da Etapa 6 do greenfield, com uma adaptação importante:

- **Lint:** se ligar a regra estrita quebra 2.000 arquivos, aplique só nos arquivos staged (`lint-staged`) — código tocado melhora, o resto fica como está.
- **CI:** comece com os checks que passam hoje como obrigatórios; adicione os outros quando ficarem verdes.
- **Segredos:** rode o `check-no-secrets.sh` (ou `gitleaks`) contra o histórico uma vez. Achou algo? Rotacione a credencial — apagar do histórico não basta.

## Etapa 7 — Primeira feature nova via SDD

A primeira spec num brownfield tem uma diferença: o `/speckit-plan` precisa de uma **Phase 0 de pesquisa no código existente** ("Achado central da pesquisa" — no CigMenu isso salvou features inteiras). Instrua explicitamente:

> "Antes de desenhar, liste todos os consumidores atuais de cada endpoint/função/tabela que o plano vai tocar."

Exemplo real: uma feature de paginação ia quebrar 4 telas que consumiam a lista inteira. A pesquisa achou isso antes do código, e a solução virou paginação **opt-in** (sem o parâmetro, o endpoint devolve o mesmo de antes).

## Etapa 8 — Legado ganha spec por demanda

Quando uma mudança tocar um módulo legado sem spec:
- Mudança **pequena** → trilha rápida (ver `06`), com teste de regressão.
- Mudança **grande** → spec nova só da *mudança*, com seção "Comportamento atual (verificado)" descrevendo o que o código faz hoje, citando arquivos. Não reescreva a spec do módulo inteiro.

Útil: `/speckit-converge` compara o código com spec/plan/tasks e acrescenta tarefas faltantes — bom para retomar uma feature cuja implementação divergiu dos artefatos.

## Anti-padrões específicos de brownfield

| Anti-padrão | Por que é ruim | Em vez disso |
|---|---|---|
| "Vamos documentar o sistema inteiro primeiro" | Nunca termina; fica desatualizado antes de acabar | Spec por demanda |
| Refatorar o legado "para ficar no padrão SDD" | Diff enorme, sem valor de usuário, risco alto | Refatore só o que a feature toca |
| Constituição idealista | Violada no primeiro dia → vira letra morta | Princípios cumpríveis por código novo |
| Ligar todos os checks do CI como obrigatórios de uma vez | PRs travados, time contorna | Ligar incrementalmente |
