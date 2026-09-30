# 08 — Documentação viva

> Documente a decisão e o porquê. O código já diz o quê.

## 1. Camadas e gatilhos

| Camada | Onde | Responde | Gatilho |
|---|---|---|---|
| Norte / produto | `docs/00-discovery/` | O que é, pra quem | Fase 0; revisa se o produto mudar |
| Decisões | `docs/01-architecture/adr/` | Por que assim | **No momento da decisão, antes de implementar** |
| Modelo de dados | `docs/01-architecture/modelagem-dados.md` | Estrutura do dado | Toda mudança de schema |
| Segurança / testes / observabilidade | `docs/02–04` | Regras e estratégias | Ao decidir; revisa por fase |
| Runbooks | `docs/05-runbooks/` | Como operar | **Antes** de precisar em produção |
| Design | `docs/06-design/` | Regras de UI | Antes de construir tela |
| Feature | `specs/NNN/` | Contrato da feature | Fluxo SDD |
| Roadmap | `docs/ROADMAP.md` | O que, em que ordem, o que falta | Fase/marco muda; pendência descoberta |
| Histórico | `CHANGELOG.md` | O que mudou | Todo merge relevante |
| Código | docstring / comentário | Porquês locais | Mesmo commit do código |
| Fase atual | `CLAUDE.md` | Onde estou | Virou de fase |

**Regra única:** documentação faz parte do DoD. Tarefa sem doc atualizada está "quase pronta", não pronta.

## 2. ADR

Quando: decisão com mais de um caminho e custo de reverter. Teste: *"alguém pode perguntar daqui a 6 meses 'por que raios foi feito assim?'"* → ADR agora.

Formato (`templates/adr-template.md`): Contexto → Decisão → **Alternativas consideradas** → Consequências (positivas, negativas, riscos).

- Alternativas são a parte mais importante: provam que houve escolha.
- **Nunca reescreva ADR antigo.** Crie um novo que marca o anterior como "substituído por ADR-XXXX". Exemplo real: deploy decidido para uma VPS, revisto para PaaS no meio do planejamento → ADR novo, histórico preservado.
- Pendências de ADR podem ficar abertas por fases (ex.: "ADR-0003 reservado") — não invente numeração para esconder lacuna.

## 3. Comentários no código

- Nome bom > comentário.
- Comente a **armadilha**, não a mecânica: "não trocar a ordem — pagamento confirmado antes de disparar notificação".
- **Referência cruzada** a requisitos: `// FR-012 (spec 018): snapshot, nunca leitura ao vivo`. Liga código à intenção e facilita o review.

## 4. Rastreamento de fase — mantenha CURTO

O `CLAUDE.md` deve ter uma seção "Fase atual" com **poucas linhas**: fase ativa, próxima ação, link para o `ROADMAP.md`. O detalhe de cada feature concluída vai para:
- `CHANGELOG.md` (o que mudou),
- `specs/NNN/` (o porquê e o como),
- descrição do PR (evidência).

> Lição real (ver `09`): no CigMenu, o `CLAUDE.md` tinha a regra "abaixo de 200 linhas", respeitou a contagem de linhas, mas cada linha de "Rastreamento de fase" virou um parágrafo de 3.000 caracteres — o arquivo chegou a ~60 KB, repetindo o que já estava em spec, PR e ROADMAP. Isso consome contexto em toda sessão e degrada o seguimento de instruções. **Limite por tamanho, não só por linhas**, e não duplique.

## 5. ROADMAP.md

Seções recomendadas:
- **Onde estou agora** (curto, sempre atualizado).
- **Etapas até o produto final** — tabela: etapa, entrega, dependência, "pronto quando".
- **Marcos** — pontos de verdade com o usuário real.
- **Pendências antes do próximo marco** — numeradas, com status e PR que resolveu.
- **Pendências técnicas** — achados de revisão, priorizados (P1, P2...).
- **Pendências fora do código** — hardware, aprovação externa, acesso a conta, decisão de plano pago. Marque com `⚠️` e diga **o que desbloqueia**; não deixe parecer tarefa esquecida.
- **Backlog futuro (fora do MVP)** — ideias adiadas com o motivo.

## 6. Memória do agente

O Claude Code tem memória persistente por projeto. Use para o que **não** está no repositório:
- Preferências e correções suas ("navegação por perfil: cozinha só vê KDS").
- Decisões de produto ainda não implementadas ("roteamento futuro /admin decidido, não feito").
- Coisas que parecem bug mas são intencionais ("workflow X desligado de propósito até upgrade de plano").

Não salve na memória o que o código, git ou `CLAUDE.md` já registram.

## 7. IA escrevendo documentação

- **Bom:** "documente esta função a partir do código"; "formate minhas notas neste template de ADR".
- **Perigoso:** "escreva o ADR dessa decisão" — ela inventa contexto e alternativas.
- Leia toda doc gerada com a régua do código: afirmação que você não decidiu ou que não é verdade é ficção.
- **Doc desatualizada é pior que ausente.** Se não vai manter, não escreva.
