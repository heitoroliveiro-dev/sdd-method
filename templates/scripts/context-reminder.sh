#!/usr/bin/env bash
# Hook UserPromptSubmit do Claude Code: injeta um lembrete curto das regras a cada prompt.
# É reforço, não fonte — a fonte é o CLAUDE.md e a constituição. Mantenha < 10 linhas.
cat << 'MSG'
[LEMBRETE DO PROJETO — <PROJETO>]
- Stack: <resumo em uma linha>. Invariante crítico: <ex.: nenhuma query cruza tenant_id>.
- Regras imutáveis: sem segredo commitado; sem SQL concatenado; sem commit direto/force push em main; toda mutação valida entrada e exige auth; menor privilégio.
- Fluxo SDD: specify -> clarify -> plan -> checklist -> tasks -> analyze -> implement. Não pular fase em feature não trivial; bug de 1 arquivo / CRUD trivial pode ir direto.
- DoD: testes + lint + sem segredo + validação + doc + review por subagente contra plan.md + EVIDÊNCIA (não afirmação).
MSG
exit 0
