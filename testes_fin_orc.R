library(tidyverse)

# carga -------------------------------------------------------------------

pgtos_efetuados_detalhes <- read_delim("testes-fin-orc/pgtos_efetuados_detalhes.csv",
                                       ";", escape_double = FALSE, 
                                       col_types = cols(ID_FONTE_RECURSO = col_skip(),
                                                        ID_TP_DOC_CCOR = col_character()),
                                       trim_ws = TRUE)

pgtos_totais_detalhes <- read_delim("testes-fin-orc/pgtos_totais_detalhes.csv", 
                                    ";", escape_double = FALSE, trim_ws = TRUE)

vinculacoes <- read_delim("testes-fin-orc/vinculacoes.csv",
                          ";", escape_double = FALSE, col_types = cols(tipo_despesa = col_character()),
                          locale = locale(encoding = "WINDOWS-1252"),
                          trim_ws = TRUE)


# verifica diferenças -----------------------------------------------------

pag_efet <- pgtos_efetuados_detalhes %>%
  group_by(ID_DOCUMENTO) %>%
  summarise(valor = sum(SALDORCONTACONTBIL))

pag_tota <- pgtos_totais_detalhes %>%
  group_by(ID_DOCUMENTO) %>%
  summarise(valor_pgtos_totais = sum(SALDORITEMINFORMAO))

diferencas <- pag_tota %>%
  full_join(pag_efet) %>%
  mutate(dif = round(valor_pgtos_totais,2) - round(valor,2)) %>%
  filter(dif != 0)

# contagem de zerados, por curiosidade
pag_tota %>% filter(valor_pgtos_totais == 0) %>% count()
pag_efet %>% filter(valor == 0) %>% count()


# verifica vinculacoes x classificadores ----------------------------------

pag_orcam <- pgtos_totais_detalhes %>%
  group_by(ID_DOCUMENTO, CO_FONTE_RECURSO, ID_IN_RESULTADO_EOF, SN_EXCECAO_DECRETO) %>%
  summarise(valor_orcamento = sum(SALDORITEMINFORMAO)) %>%
  ungroup() %>%
  filter(valor_orcamento != 0) %>%
  group_by(ID_DOCUMENTO) %>%
  mutate(valor_doc_pgtos_totais = sum(valor_orcamento)) %>%
  ungroup() #%>%
  #filter(qde > 1) %>%
  #arrange(ID_DOCUMENTO)

pag_fin <- pgtos_efetuados_detalhes %>%
  group_by(ID_DOCUMENTO, CO_FONTE_RECURSO, ID_VINCULACAO_PAGAMENTO) %>%
  summarise(valor_financeiro = sum(SALDORCONTACONTBIL)) %>%
  filter(valor_financeiro != 0) %>%
  ungroup() %>%
  left_join(vinculacoes) %>%
  group_by(ID_DOCUMENTO) %>%
  mutate(valor_doc_pag_efet = sum(valor_financeiro)) %>%
  ungroup() %>%
  filter(!is.na(tipo_despesa))

tab_fin_orc <- pag_fin %>%
  full_join(pag_orcam)

tab_fin_orc %>% filter(tipo_despesa == "discricionárias" & ID_IN_RESULTADO_EOF == 1) %>% select(ID_DOCUMENTO)

sumario <- tab_fin_orc %>%
  group_by(tipo_despesa, ID_IN_RESULTADO_EOF, SN_EXCECAO_DECRETO) %>%
  summarise(vlr_fin     = round(sum(valor_financeiro),2),
            vlr_orc     = round(sum(valor_orcamento),2),
            vlr_doc_fin = round(sum(valor_doc_pag_efet),2),
            vlr_doc_orc = round(sum(valor_doc_pgtos_totais),2))
