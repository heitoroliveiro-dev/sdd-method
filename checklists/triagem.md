# Checklist de triagem (demanda nova)

Responda na ordem. O primeiro "sim" decide.

- [ ] Altera modelo de dados / exige migration? → **SDD**
- [ ] Altera contrato público (API, evento, formato de arquivo) consumido por outros? → **SDD**
- [ ] Altera regra de negócio ou fluxo de status? → **SDD**
- [ ] Altera permissão, autenticação ou isolamento de dados? → **SDD**
- [ ] Tem mais de um caminho com trade-off real? → **SDD** (+ ADR se arquitetural)
- [ ] O "pronto" não cabe numa frase checável? → **SDD**
- [ ] É bug localizado (~1 arquivo) ou CRUD/UI no padrão já existente? → **Trilha rápida**
- [ ] Nenhuma das anteriores / dúvida → **SDD**

## Registrar

- Origem: <uso real / cliente / revisão técnica / bug em produção>
- Item no ROADMAP: <#>
- Trilha: <SDD `specs/NNN-...` | rápida `fix/...`>
- Fora do código? <hardware / aprovação externa / plano pago → marcar ⚠️>
