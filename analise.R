library(tidyverse)

dados_brutos <- read.csv2("MJ_1_Mov_Lim_Saque.csv")

dados_brutos %>%
  filter(ID_ANO_LANC == 2017) %>%
  group_by(ID_ANO_LANC, CO_ORGAO) %>%
  summarise(sum(as.numeric(as.character(SALDORITEMINFORMAO))))

# aqui deu ok!

dados_brutos %>%
  filter(ID_DOCUMENTO == "SALDO INICIAL 2017") %>%
  group_by(ID_ANO_LANC, CO_ORGAO) %>%
  summarise(sum(as.numeric(as.character(SALDORITEMINFORMAO))))

# aqui tb

dados_brutos %>%
  group_by(ID_ANO_LANC, CO_ORGAO) %>%
  summarise(valor = sum(as.numeric(as.character(SALDORITEMINFORMAO)))) %>%
  ungroup() %>%
  spread(ID_ANO_LANC, valor)

nrow(dados_brutos)

dados_brutos %>%
  filter(ID_ANO_LANC == 2018) %>%
  group_by(CO_ORGAO) %>%
  summarise(valor = sum(as.numeric(as.character(SALDORITEMINFORMAO))))
            