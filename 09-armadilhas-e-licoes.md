# 09 — Armadilhas e lições reais

Tudo abaixo aconteceu no CigMenu. Cada item: **o que aconteceu → por que → regra que ficou.**

## Sobre os artefatos

### 1. O plano afirmava um teste que não existia
`plan.md` dizia "teste de isolamento para a tabela nova — ✅". Não havia teste. Em outra feature, `plan.md`/`tasks.md` citavam um teste unitário que só existia como cobertura e2e.
**Por quê:** o agente escreve o plano descrevendo a intenção como fato.
**Regra:** afirmação de artefato é hipótese até ser verificada. O `/speckit-analyze` e o review por subagente devem **checar a existência** de todo teste/arquivo citado.

### 2. O plano estava errado — e a correção quase foi só no código
O plano lia um atributo "ao vivo" via join para decidir se um item ia à cozinha. Isso violava o próprio requisito de não-retroatividade nos dois sentidos (desligar a categoria sumia com itens já na fila).
**Regra:** quando a implementação revela erro de design, **pare, decida com o humano, registre em `research.md`**, atualize `plan.md`/`tasks.md` — e só então continue. Artefato que não reflete o código real é pior que nenhum.

### 3. Constituição desatualizada em relação a uma decisão de produto
Feature aprovada: checkout público sem login. Constituição: "toda mutação exige autenticação". O analyze marcou CRITICAL.
**Regra:** nem sempre o código cede. Se a decisão de produto é deliberada, **emende a constituição** (versão MINOR, Sync Impact Report, rationale) e espelhe no `CLAUDE.md` no mesmo commit. Nunca deixe os dois se contradizerem.

### 4. RBAC copiado do "molde" em vez do requisito
Módulo novo copiado de um similar que liberava leitura para todos os perfis; a spec nova tinha FR explícito negando leitura.
**Regra:** "moldado em X" copia estrutura, não regras. Todo guard é conferido contra os FRs da spec atual.

## Sobre testes

### 5. Mock que escondia o bug
Teste mockava o hook já filtrado; o componente tratava "inativo" certo, mas o hook real removia inativos antes. Branch nunca executava em produção.
**Regra:** comportamento crítico precisa de pelo menos um teste pelo caminho real de dados.

### 6. Testes existentes apagados ao criar novos
Ao reescrever o arquivo de spec de um serviço para adicionar casos, os testes antigos sumiram.
**Regra:** o review compara contagem de testes antes/depois e lista testes removidos. Remoção só com justificativa explícita.

### 7. "Botão habilitado" não é "botão funciona"
Várias telas testavam só enabled/disabled.
**Regra:** toda ação de UI tem teste de clique → efeito.

### 8. Falha pré-existente confundida com regressão
Uma suíte e2e já falhava em `main` antes da feature.
**Regra:** antes de começar, registre o estado da suíte na `main`. Falha pré-existente vira pendência própria, não é "consertada" dentro de outra feature — nem ignorada em silêncio.

## Sobre ambiente e produção

### 9. Build antigo rodando = falso negativo convincente
O backend local rodava `node dist/main` compilado dias antes. Toda validação ao vivo retornava 400 porque o DTO antigo rejeitava os parâmetros novos.
**Regra:** antes de validação ao vivo, confirme que o processo roda o código atual (modo watch, rebuild, hash/versão no health).

### 10. Health check verde com banco vazio
Nada no pipeline rodava migrations em produção. `/health` só checava se a conexão abria → deploy "saudável", toda rota real quebrava.
**Regra:** migrations rodam no boot/deploy de forma idempotente, e o deploy só é promovido se isso passar. Health check deve refletir a capacidade real de servir.

### 11. Mudança de config de build moveu o entrypoint
Uma pasta `scripts/` nova entrou na raiz de compilação e `dist/main.js` virou `dist/src/main.js` — o `CMD` quebrou em silêncio.
**Regra:** validar a **imagem de produção** localmente (build + run + health) quando mexer em build, Dockerfile ou config de compilação.

### 12. Pendência externa confundida com esquecimento
Backup automático exigia plano pago; impressora física só no cliente; templates de WhatsApp dependiam de aprovação externa.
**Regra:** marque como `⚠️ bloqueada por <X>`, diga o que desbloqueia, e siga — não bloqueie o resto do roadmap nem finja que está feito.

## Sobre processo

### 13. `CLAUDE.md` inchado
Regra "abaixo de 200 linhas" cumprida na contagem, violada no espírito: ~60 KB de histórico de fase, duplicando spec/PR/CHANGELOG/ROADMAP.
**Regra:** `CLAUDE.md` indexa, não duplica. Fase atual em poucas linhas. Revise o tamanho em bytes periodicamente.

### 14. Analyze pulado ao retomar sessão
Features retomadas "com plan/tasks já prontos" não passaram pelo analyze.
**Regra:** retomou feature em sessão nova → rode `/speckit-analyze` (e `/speckit-converge` se já houver código).

### 15. Overengineering pego no ato
Mutations invalidavam duas chaves de cache quando a invalidação por prefixo já cobria ambas.
**Regra:** pergunte ao agente "o que muda observavelmente se removermos isto?". Se nada, remova.

### 16. Refactor oportunista recusado conscientemente
Review sugeriu extrair hook compartilhado de 4 páginas. Decisão: não, porque misturaria um refactor antigo com o escopo da feature.
**Regra:** achado válido fora de escopo → registre como pendência. "Não corrigir agora, de propósito" é uma resposta legítima — desde que registrada.

### 17. PRs agrupados por velocidade
Três pacotes (hotfixes de UI + componente novo + feature SDD) acumularam sem commit e foram num PR único.
**Regra:** é uma troca aceitável **se decidida pelo humano e registrada**, mas custa rastreabilidade e revisão. Padrão: um PR por feature/fix.

### 18. Conflito real de merge entre features paralelas
Várias branches paralelas (CI, observabilidade, hardening, frontend) tinham código duplicado (dois `/health`, CORS em dois lugares).
**Regra:** ao paralelizar features, defina a ordem de merge (a que traz a branch protection/CI primeiro) e sincronize cada branch com a `main` nova antes do merge.

## Sobre a relação com a IA

- **O que deu certo:** o agente perguntar antes de assumir; apresentar alternativas com recomendação; parar no checkpoint; mostrar output de teste; o analyze e o review pegarem problemas reais em quase toda feature.
- **O que exigiu vigilância:** afirmações não verificadas nos artefatos; tendência a "moldar" em código existente sem reler requisitos; crescer escopo com "já que estou aqui".
- **O multiplicador:** cada lição acima virou uma regra em constituição, checklist, hook ou template. O processo melhora porque os erros viram trava.
