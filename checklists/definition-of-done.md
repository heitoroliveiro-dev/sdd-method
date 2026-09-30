# Definition of Done

## Toda entrega (SDD ou trilha rápida)

- [ ] Testes automatizados passando — output anexado com contagem
- [ ] Nenhum teste pulado, removido ou afrouxado (contagem antes/depois conferida)
- [ ] Bug corrigido tem teste de regressão que falhava antes
- [ ] Lint sem erros
- [ ] Build passa
- [ ] Nenhum segredo hardcoded; nada sensível em log
- [ ] Validação de entrada nos pontos novos (schema/DTO, IDs, allowlist de ordenação/filtro)
- [ ] Autenticação/autorização correta, com teste de perfil negado
- [ ] Invariante crítico do domínio com teste (ex.: isolamento entre tenants)
- [ ] Doc/contrato que descreve o comportamento foi atualizado
- [ ] Nada fora do escopo alterado
- [ ] CI verde

## Adicional para feature SDD

- [ ] Todos os FRs da spec implementados, cada um com teste que o prova
- [ ] Edge cases da spec cobertos
- [ ] `tasks.md` 100% `[X]` (ou pendências ⚠️ explicitadas)
- [ ] `/speckit-analyze` rodou antes da implementação; CRITICAL/HIGH resolvidos
- [ ] Review por subagente contra `plan.md` feito; achados corrigidos e suíte re-executada
- [ ] Roteiros do `quickstart.md` validados ao vivo, com evidência
- [ ] Artefatos refletem o código final (plan/research atualizados se o design mudou)
- [ ] ADR criado para decisão arquitetural nova
- [ ] Migração testada contra dados realistas (up e down)
- [ ] CHANGELOG + fase/ROADMAP atualizados após o merge
