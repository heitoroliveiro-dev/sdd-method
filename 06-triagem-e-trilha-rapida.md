# 06 — Triagem: SDD completo ou trilha rápida

SDD completo custa de uma a várias sessões. Usar para tudo é desperdício; não usar quando precisa é retrabalho. Toda demanda nova passa por esta triagem **antes** de qualquer código.

## Árvore de decisão

```
A mudança altera modelo de dados, contrato público, regra de negócio,
permissão (RBAC) ou isolamento de dados?
├── SIM → SDD completo
└── NÃO
    │
    Envolve mais de uma decisão com trade-off real, ou você não consegue
    descrever o "pronto" em uma frase checável?
    ├── SIM → SDD completo (ou pelo menos specify + clarify + plan)
    └── NÃO
        │
        É bug localizado (≈ 1 arquivo) ou CRUD/UI trivial seguindo padrão já existente?
        ├── SIM → Trilha rápida
        └── NÃO → na dúvida, SDD. O custo de errar pra cima é menor.
```

## Exemplos reais de triagem

| Demanda | Trilha | Por quê |
|---|---|---|
| Gestor não tem botão "Ativar" produto (endpoint já existe) | Rápida | Só UI, padrão existente, pronto é checável |
| Editar operador existente (nome/senha/perfil) | Rápida *com contrato atualizado* | CRUD no padrão já usado 3x; mas atualizou `contracts/operador.md` para não ficar mentindo |
| Coluna "Pronto" ordenada por mais recente | Rápida | Regra local, 1 serviço |
| Categorias de produto + roteamento à cozinha | SDD | Migração de dados, muda fluxo de status, afeta KDS e impressão |
| Paginação nas listagens | SDD | Endpoints consumidos por outras telas — pesquisa de consumidores obrigatória |
| Confirmação de pagamento + fechamento forçado | SDD | Regra de negócio + RBAC novo + auditoria |
| Observabilidade mínima (logs, health, filtro global de exceção) | SDD | Transversal; decisão sobre o que nunca logar |

## A trilha rápida (não é "sem processo")

1. Branch `fix/<nome>` ou `feat/<nome>`.
2. Plan mode: o agente descreve o que vai mudar e em quais arquivos. Você aprova.
3. **Teste que reproduz o bug antes do fix** (bug) ou teste da ação nova (feature pequena).
4. Implementa. Suíte + lint verdes.
5. Se algum contrato/doc existente descreve o comportamento, **atualize-o** no mesmo PR.
6. PR com evidência, marcando no template: "mudança trivial, SDD dispensado propositalmente".

A trilha rápida dispensa `spec.md`/`plan.md`/`tasks.md`. **Não** dispensa teste, evidência, lint, hooks, CI nem review do diff.

## Sinais de que uma "rápida" deveria ter sido SDD

- O diff passou de ~5 arquivos ou tocou camadas que você não esperava.
- Apareceu uma pergunta de produto no meio ("e se o pedido já foi pago?").
- Precisou de migration.
- Um guard/permissão novo entrou.

Quando acontecer: pare, descarte ou guarde o diff, e comece por `/speckit-specify`. Aproveite o que aprendeu como insumo da spec.

## Levantamento em lote (achados de uso real)

Quando alguém usa o sistema e levanta 15 itens de uma vez:
1. Registre **todos** em `ROADMAP.md § Pendências` com numeração (ex.: itens 1–15, B1–B14).
2. Triagem item a item com a árvore acima.
3. Rápidos: um PR por item (ou um PR por grupo coeso do mesmo padrão — ex.: "padroniza botões em 5 tabelas").
4. SDD: cada um vira feature numerada; referencie o item de origem na spec ("fecha o item B11").
5. Ao fechar, marque o item como resolvido citando o PR.
