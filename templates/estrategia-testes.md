# Estratégia de Testes — <PROJETO>

> O objetivo não é cobertura por cobertura — é rede de segurança para refatorar sem medo e provar que a regra de negócio funciona.

## Pirâmide

- **Unitários (maioria):** regra de negócio pura. Prioridade: <liste as 3–5 regras mais críticas do domínio>. Regras complexas extraídas para funções puras.
- **Integração / e2e de API (meio):** rota + banco real efêmero. Obrigatório para: <invariante de dados>, RBAC por perfil, códigos de erro do contrato.
- **E2E de UI (poucos):** fluxos críticos ponta a ponta. Complementado pelos roteiros de `quickstart.md` de cada feature.

## Ferramentas

| Camada | Ferramenta |
|---|---|
| Unit backend | <ex.: Jest / pytest / go test> |
| Integração | <ex.: Supertest + Testcontainers> |
| Frontend | <ex.: Vitest + Testing Library> |
| E2E UI | <ex.: Playwright> |

## Cobertura mínima (gate no CI)

| Camada | Mínimo |
|---|---|
| Serviços de domínio | <ex.: 80% linhas> |
| Geral | <ex.: 60%> |

## Regras

1. Nenhum teste mascarado: proibido skip, `.only`, assert removido, expectativa afrouxada.
2. Todo bug corrigido ganha teste que falha antes do fix.
3. Comportamento crítico tem pelo menos um teste pelo caminho real de dados (mock só na borda de rede).
4. Toda ação de UI tem teste de interação → efeito, não só de estado.
5. Não remover teste existente sem justificativa explícita no PR.
6. Critério de sucesso checável: "retorna 429 ao exceder limite", não "está robusto".

## Fixtures

- Factories para cada entidade.
- <Se multi-tenant: helper que cria 2 tenants e autentica em cada um, usado em todo teste de isolamento.>
- Banco de teste: container efêmero por execução; nunca banco compartilhado.
