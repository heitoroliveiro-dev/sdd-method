<!--
Insumo para /speckit-constitution. Não copie direto para .specify/memory/:
entregue este texto ao comando, adaptado, e deixe-o gerar o arquivo oficial
(com Sync Impact Report e checagem dos templates).

Remova princípios que não se aplicam. Prefira 4–7 princípios fortes a 15 fracos.
Todo princípio: regra verificável + rationale.
-->

# <PROJETO> Constitution

## Core Principles

### I. <Invariante de dados crítico> (NON-NEGOTIABLE)
<Ex. multi-tenant: nenhuma query cruza `tenant_id`; toda rota que lê/escreve
dado tenant-scoped tem teste de integração provando que o tenant A não lê nem
escreve dado do tenant B.>

**Rationale**: <por que a falha é inaceitável e irremediável depois.>

### II. Sem SQL cru concatenado
Toda interação com o banco usa ORM/query builder parametrizado, inclusive em
migrations, seeds e scripts. Parâmetros dinâmicos de ordenação/filtro passam
por allowlist.

**Rationale**: elimina a classe inteira de injeção sem custo real de produtividade.

### III. Menor privilégio
Cada perfil acessa só o que sua função exige. Padrão é negar; acesso é liberado
explicitamente (guards/policies), nunca por omissão de checagem.

**Rationale**: reduz dano de credencial comprometida ou erro operacional.

### IV. Sem segredo hardcoded
Nenhuma credencial no repositório; `.env` fora do versionamento; segredo,
senha, token ou dado sensível nunca em log.

**Rationale**: segredo em histórico de git é irreversível na prática.

### V. TDD com testes não mascarados (NON-NEGOTIABLE)
Red → green → refactor na lógica de negócio não trivial. Proibido skip,
remoção de assert ou alteração de teste com o único propósito de fazê-lo
passar. Teste falhou → conserta o código. Todo bug corrigido ganha teste de
regressão que o reproduz antes do fix.

**Rationale**: mascarar teste destrói a rede de segurança — falha já observada
em agentes de IA.

### VI. Definition of Done com evidência
Nada é concluído por afirmação. Critérios checáveis; evidência anexada
(output de teste, comando + retorno, screenshot). Todo diff de feature passa
por review de subagente contra o `plan.md`.

**Rationale**: revisar evidência é mais rápido e confiável que confiar em
quem implementou — inclusive um agente.

## Restrições adicionais de domínio
- **Validação de entrada**: toda mutação valida via DTO/schema; rotas públicas
  só nos casos nomeados aqui: <liste>.
- <Regra de domínio 1, ex.: status derivado, nunca digitado.>
- <Regra de domínio 2, ex.: falha de integração externa nunca bloqueia o fluxo principal.>
- <Requisito não funcional tratado como requisito, ex.: atualização em ≤ 2s.>

## Fluxo de desenvolvimento
Feature não trivial: Constitution → Specify → Clarify → Plan → Checklist →
Tasks → Analyze → Implement. Trilha rápida só para bug de ~1 arquivo ou CRUD
trivial. Mudança de arquitetura ou modelo de dados sempre passa por plan com
seção de verificação explícita.

## Governance
Esta constituição prevalece sobre convenções que a contradigam. Emendas exigem
registro do que mudou e por quê, atualização de versão e checagem de impacto
em `.specify/templates/`, `CLAUDE.md` e `plan.md` de features em andamento.

Versionamento: MAJOR = remover/afrouxar princípio; MINOR = princípio novo ou
expansão material; PATCH = redação.

Complexidade que viole um princípio exige justificativa no `plan.md`
(Complexity Tracking), não só no código.

**Version**: 1.0.0 | **Ratified**: AAAA-MM-DD | **Last Amended**: AAAA-MM-DD
