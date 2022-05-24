# Changelog

## v0.3.1 (2022-05-24)

### Bug Fixes

- campos numéricos e de datas em `ExDatacube.Veiculos.Veiculo` não estavam sendo propriamente convertidos para `String.t()` ou `Date.t()`.

## v0.3.0 (2022-05-24)

### Enhancements

- logo atualizado;
- inclusão do campo `comunicado_venda` no tipo `ExDatacube.Veiculos.Veiculo`;

### Bug Fixes

- alguns campos na pesquisa nacional não estavam sendo carregados corretamente em função de divergências nos nomes retornados pela api;

### Breaking Changes

- contrato da API no retorno de erros atualizado cobrindo todos os retornos possíveis da API;

## v0.1.0 (2022-05-18)

- release inicial;