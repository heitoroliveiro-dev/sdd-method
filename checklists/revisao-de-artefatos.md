# Checklist de revisão dos artefatos (seus gates humanos)

## spec.md (após specify/clarify)
- [ ] Nenhuma tecnologia mencionada
- [ ] User stories priorizadas, cada uma testável e valiosa sozinha
- [ ] FRs numerados, verificáveis, sem ambiguidade
- [ ] Success Criteria mensuráveis
- [ ] Edge cases listados
- [ ] Fora de escopo explícito
- [ ] Zero `[NEEDS CLARIFICATION]`
- [ ] Clarificações registradas com data e FR afetado

## plan.md e companheiros (após plan)
- [ ] Constitution Check: cada princípio com *como* é atendido
- [ ] Divergências de convenção registradas e justificadas
- [ ] Brownfield: consumidores atuais de tudo que muda foram listados
- [ ] Reaproveita mecanismos existentes em vez de criar paralelos
- [ ] `research.md` com alternativas descartadas e por quê
- [ ] `data-model.md` com migração up/down e efeito sobre dados existentes
- [ ] `contracts/` com códigos de erro e RBAC por rota
- [ ] `quickstart.md` com roteiros checáveis (ação → resultado esperado)
- [ ] Decisão arquitetural nova tem ADR
- [ ] Toda afirmação ("teste X existe", "arquivo Y já faz Z") é verdadeira

## tasks.md (após tasks)
- [ ] Toda tarefa tem caminho de arquivo e é pequena
- [ ] Foundational contém só o bloqueante real
- [ ] Todo FR aparece em pelo menos uma tarefa
- [ ] Lógica não trivial tem tarefa de teste antes da implementação
- [ ] Tarefas que dependem de ação humana/externa marcadas com ⚠️
- [ ] Checkpoints ao fim de cada fase
