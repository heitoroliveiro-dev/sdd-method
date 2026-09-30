# 10 — Referência rápida

## Instalação

```bash
# projeto novo (dentro do repo clonado vazio)
uvx --from git+https://github.com/github/spec-kit.git specify init . --ai claude
# projeto existente
uvx --from git+https://github.com/github/spec-kit.git specify init --here --ai claude
# depois: reiniciar o Claude Code
```

## Comandos

| Comando | Faz | Seu gate |
|---|---|---|
| `/speckit-constitution` | Cria/emenda princípios | Regra verificável + rationale + versão |
| `/speckit-specify <descrição>` | `spec.md` (o quê/porquê) | Sem tecnologia; stories independentes; FRs checáveis |
| `/speckit-clarify` | ≤5 perguntas → `## Clarifications` | Decisões são suas |
| `/speckit-plan` | plan, research, data-model, contracts, quickstart | Constitution Check real; alternativas; consumidores do que muda |
| `/speckit-checklist <foco>` | "Testes unitários para o texto" | Gaps corrigidos na spec |
| `/speckit-tasks` | `tasks.md` por fase/story | Pequenas, com arquivo, teste antes |
| `/speckit-analyze` | Consistência cruzada (read-only) | Corrigir CRITICAL/HIGH nos artefatos |
| `/speckit-implement` | Executa as tarefas | Revisar por checkpoint |
| `/speckit-converge` | Acrescenta tarefas faltantes vs. código | Ao retomar feature divergente |
| `/speckit-taskstoissues` | Tarefas → GitHub issues | Opcional |

(Versões antigas do Spec Kit usam ponto: `/speckit.specify`.)

## Fluxo de uma feature

```
git checkout -b feat/NNN-nome
/speckit-specify → /speckit-clarify → /speckit-plan → /speckit-checklist
→ /speckit-tasks → /speckit-analyze → /speckit-implement
→ review por subagente contra plan.md → validação ao vivo (quickstart.md)
→ PR com evidência → CI verde → merge → CHANGELOG + fase + ADR
```

## Trilha rápida

```
git checkout -b fix/nome → plan mode → teste que reproduz → fix
→ suíte + lint → atualiza contrato/doc se existir → PR com evidência
```

## Triagem em 3 perguntas

1. Muda dado, contrato, regra de negócio, permissão ou isolamento? → **SDD**
2. Tem trade-off real ou "pronto" não cabe numa frase checável? → **SDD**
3. É ~1 arquivo / padrão existente? → **Rápida**. Na dúvida → SDD.

## Frase da sessão

> "Hoje eu entrego ______ e sei que terminei quando ______."

## Prompt de review por subagente

```
Revise o diff desta branch contra specs/NNN/plan.md, spec.md e tasks.md.
Reporte com arquivo:linha e severidade:
1. Todo FR tem implementação E teste.
2. Toda afirmação do plan.md sobre testes/arquivos é verdadeira.
3. Cada princípio da constituição é atendido no código.
4. Edge cases da spec têm teste.
5. Arquivos tocados fora do escopo do plano.
6. Testes pré-existentes removidos, pulados ou afrouxados.
Não corrija; só reporte.
```

## Freios de mão

- Decisão com >1 caminho → ADR, você escolhe.
- Diff grande demais pra ler → quebrar.
- Plano errado descoberto na implementação → parar, atualizar artefatos, decidir.
- Escopo cresceu → backlog.
- Pressa → revisar mais devagar.
