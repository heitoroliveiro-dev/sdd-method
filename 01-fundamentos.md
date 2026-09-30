# 01 — Fundamentos

## 1. Por que SDD (e por que com IA)

Com um agente de IA escrevendo código, o gargalo deixa de ser **digitar** e passa a ser **decidir e verificar**. Sem estrutura, três coisas acontecem quase sempre:

1. **A IA decide por você.** Arquitetura, escopo, trade-offs — escolhidos em silêncio no meio de um diff de 800 linhas.
2. **O escopo cresce sozinho.** "Já que estava aqui, também fiz X."
3. **"Funciona" vira afirmação.** O agente diz que passou; ninguém viu o teste rodar. Pior: às vezes o teste foi "ajustado" para passar.

O SDD ataca os três colocando **texto revisável entre a ideia e o código**:

```
ideia ──► spec.md ──► plan.md ──► tasks.md ──► código ──► evidência
          (o quê/     (o como,    (passos       (contra    (teste,
           porquê)     decisões)   pequenos)     o plano)   comando, print)
            ▲            ▲            ▲                        │
            └── você revisa e aprova cada seta ◄───────────────┘
```

Revisar um `spec.md` de 2 páginas é muito mais barato que revisar o diff que nasceria de uma spec errada.

## 2. Quem decide o quê

| A IA pode fazer sozinha | Só você decide |
|---|---|
| Escrever código contra um plano aprovado | O que entra no escopo (e o que fica de fora) |
| Sugerir abordagens e trade-offs | Qual abordagem seguir quando há mais de uma |
| Rodar testes, lint, mostrar evidência | Decisões de arquitetura (viram ADR) |
| Refatorar dentro de uma tarefa definida | Trocar stack, lib, padrão estabelecido |
| Apontar bug e propor correção | Aceitar ou não mudança de estrutura |
| Gerar boilerplate | Priorizar o backlog |

**Sinais de que a IA tomou o volante:**
- Uma decisão de arquitetura apareceu sem alternativas apresentadas.
- O escopo cresceu no meio da tarefa.
- Você está aprovando código que não entende.
- Você não sabe dizer em uma frase o que a sessão de hoje entrega.

**Regra de ouro:** você precisa conseguir explicar cada decisão do projeto para outra pessoa. Se só a IA sabe por que algo é assim, você perdeu aquele pedaço.

## 3. As três alturas de visão

Perder-se num projeto é quase sempre confundir altitudes.

### Altura 1 — O Norte (raramente muda)
Uma frase que diz o que o produto resolve. No CigMenu: *"mata o papel e digitaliza o fluxo de pedido do restaurante, sem cobrar comissão por pedido."* É o filtro anti-escopo: tarefa que não serve ao Norte precisa justificar sua existência.

### Altura 2 — A Fase atual (muda a cada semanas)
Uma fase ativa por vez, registrada num lugar só (`CLAUDE.md` → "Fase atual", apontando pro `ROADMAP.md`). Exemplo de sequência:

```
[✓] Fase 0 — Discovery        (proposta funcional)
[✓] Fase 1 — Arquitetura      (ADRs, modelagem)
[ ] Fase 2 — Fundação técnica (scaffold, hooks, CI, auth)   ← aqui
[ ] Fase 3 — Ciclo de features (SDD por feature)
[ ] Fase 4 — CI/CD e deploy
[ ] Fase 5 — Operação
```

Com **marcos** entre elas — pontos de verdade com o usuário real (no CigMenu: "Marco 1 — um serviço no salão sem caderneta").

### Altura 3 — A tarefa de hoje (muda a cada sessão)
Antes de abrir o agente, complete:

> "Hoje eu vou entregar ______ e vou saber que terminei quando ______."

Se não consegue completar, **não comece a codar** — falta plano.

## 4. O loop de uma sessão

```
1. DEFINIR   → a frase da Altura 3. Uma tarefa, não cinco.
2. PLANEJAR  → feature não trivial: fluxo SDD. Bug/setup: plan mode direto.
3. EXECUTAR  → agente implementa contra o plano aprovado.
4. VERIFICAR → agente mostra EVIDÊNCIA. Você revisa a evidência.
5. ENTENDER  → você consegue explicar o que foi feito? Se não, pergunte.
6. COMMITAR  → commit coeso, hooks protegem, branch + PR.
7. REGISTRAR → CHANGELOG, ADR se mudou decisão, fase se virou.
```

**Nunca pule o passo 5.** É ele que impede você de virar passageiro.

## 5. Regras anti-overengineering

- **Uma tarefa por vez.** Terminou, commitou, pega a próxima.
- **"Precisamos disso hoje?"** Abstração "para o futuro" só se resolve problema real de agora.
- **O que está fora é tão importante quanto o que está dentro.** Toda spec e todo plano têm seção "fora de escopo".
- **Ideia nova no meio de uma tarefa vai pro backlog**, não pro diff atual.

## 6. Freios de mão — quando parar a IA

- Vai mexer em estrutura que já funciona → exija impacto, reversibilidade, rollback.
- Surgiu decisão com mais de um caminho → é ADR; ela apresenta opções, você escolhe.
- O diff ficou grande demais pra você ler inteiro → peça pra quebrar.
- Você está com pressa e tentado a aprovar sem ler → é exatamente aí que o bug entra.

## 7. SDD não é burocracia obrigatória

SDD custa tempo. Vale a pena quando o custo de errar a direção é maior que o custo de escrever a spec. Para bug de 1 arquivo ou CRUD trivial, **não use** — ver [06-triagem](06-triagem-e-trilha-rapida.md). Aplicar SDD completo num typo é o mesmo erro que pular SDD numa mudança de modelo de dados, só que no sentido oposto.
