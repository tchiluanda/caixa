library(tidyverse)

dados_brutos_LimSq <- read.csv2("MJ_1_Mov_Lim_Saque.csv")

dados_brutos_LimSq %>%
  filter(ID_ANO_LANC == 2017) %>%
  group_by(ID_ANO_LANC, CO_ORGAO) %>%
  summarise(sum(as.numeric(as.character(SALDORITEMINFORMAO))))

# aqui deu ok!

dados_brutos_LimSq %>%
  filter(ID_DOCUMENTO == "SALDO INICIAL 2017") %>%
  group_by(ID_ANO_LANC, CO_ORGAO) %>%
  summarise(sum(as.numeric(as.character(SALDORITEMINFORMAO))))

# aqui tb

dados_brutos_LimSq %>%
  group_by(ID_ANO_LANC, CO_ORGAO) %>%
  summarise(valor = sum(as.numeric(as.character(SALDORITEMINFORMAO)))) %>%
  ungroup() %>%
  spread(ID_ANO_LANC, valor)

nrow(dados_brutos_LimSq)

dados_brutos_LimSq %>%
  filter(ID_ANO_LANC == 2018) %>%
  group_by(CO_ORGAO) %>%
  summarise(valor = sum(as.numeric(as.character(SALDORITEMINFORMAO))))


# pagamentos --------------------------------------------------------------

dados_brutos_Pag <- read.csv2("MJ_2_Mov_Pagamentos.csv")

dados_brutos_Pag %>%
  group_by(ID_ANO_LANC, CO_ORGAO) %>%
  summarise(valor = sum(as.numeric(as.character(SALDORITEMINFORMAO)))) %>%
  spread(ID_ANO_LANC, valor)


# liquidações -------------------------------------------------------------

dados_brutos_Obrig <- read.csv2("MJ_3_Mov_Obrigacoes.csv")

dados_brutos_Obrig %>%
  group_by(ID_ANO_LANC, CO_ORGAO) %>%
  summarise(valor = sum(as.numeric(as.character(SALDORITEMINFORMAO)))) %>%
  spread(ID_ANO_LANC, valor)


  
            