library(tidyverse)
library(readxl)

# carga dados fin ---------------------------------------------------------

anexo2_fin <- read_excel("testes-fin-orc/dados_acompanhamento/acompanhamento_decreto_AnexoII_fin.xlsx",
                         skip = 5) %>%
  mutate(Anexo = "Anexo II")

anexo3_fin <- read_excel("testes-fin-orc/dados_acompanhamento/acompanhamento_decreto_AnexoIII_fin.xlsx",
                         skip = 5) %>%
  mutate(Anexo = "Anexo III")

anexo4_fin <- read_excel("testes-fin-orc/dados_acompanhamento/acompanhamento_decreto_AnexoIV_fin.xlsx",
                         skip = 5) %>%
  mutate(Anexo = "Anexo IV")

anexo5_fin <- read_excel("testes-fin-orc/dados_acompanhamento/acompanhamento_decreto_AnexoV_fin.xlsx",
                         skip = 5) %>%
  mutate(Anexo = "Anexo V")

fin <- bind_rows(anexo2_fin, anexo3_fin, anexo4_fin, anexo5_fin)


# carga dados orc ---------------------------------------------------------

anexo2_orc <- read_excel("testes-fin-orc/dados_acompanhamento/acompanhamento_decreto_AnexoII_orc.xlsx",
                         skip = 8) %>%
  mutate(Anexo = "Anexo II")

anexo3_orc <- read_excel("testes-fin-orc/dados_acompanhamento/acompanhamento_decreto_AnexoIII_orc.xlsx",
                         skip = 8) %>%
  mutate(Anexo = "Anexo III")

anexo4_orc <- read_excel("testes-fin-orc/dados_acompanhamento/acompanhamento_decreto_AnexoIV_orc.xlsx",
                         skip = 8) %>%
  mutate(Anexo = "Anexo IV")

anexo5_orc <- read_excel("testes-fin-orc/dados_acompanhamento/acompanhamento_decreto_AnexoV_orc.xlsx",
                         skip = 8) %>%
  mutate(Anexo = "Anexo V")

orc <- bind_rows(anexo2_orc, anexo3_orc, anexo4_orc, anexo5_orc)

# carga limite pagamento --------------------------------------------------

lim_pag <- read_excel("testes-fin-orc/dados_acompanhamento/limites_pag.xlsx") %>%
  gather(-Anexo, -cod_orgao, -nome_orgao, key = mes, value = lim_pag) %>%
  mutate(cod_orgao = as.character(cod_orgao),
         mes = as.numeric(mes))


# tratamento --------------------------------------------------------------

meses <- c("JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ")

orc_fin <- full_join(orc, fin)

dados <- orc_fin %>%
  rename(cod_orgao = `Órgão UGE - Órgão Máximo Código`,
         nom_orgao = `Órgão UGE - Órgão Máximo Nome`,
         mes_texto = `Mês Lançamento`) %>%
  mutate(mes_3 = str_sub(mes_texto, 1, 3),
         mes   = ifelse(mes_3 == "000", 0, match(mes_3, meses)),
         ano   = str_sub(mes_texto, 5, 8)) %>%
  filter(!(mes_3 %in% c("013", "014"))) %>%
  arrange(Anexo, cod_orgao, ano, mes) %>%
  mutate_if(is.numeric, .funs = ~replace_na(., 0)) %>%
  group_by(Anexo, cod_orgao) %>%
  mutate(cred_sd = cumsum(`CREDITO DISPONIVEL`)/1000,
         a_liq_sd = cumsum(`DESPESAS EMPENHADAS A LIQUIDAR` + `RESTOS A PAGAR NAO PROCESSADOS A LIQUIDAR`)/1000,
         liq_a_pg_sd = cumsum(`VALORES LIQUIDADOS A PAGAR (EXERCICIO + RP)`)/1000,
         pg_sd = cumsum(`PAGAMENTOS TOTAIS (EXERCICIO E RAP)`)/1000,
         lim_sq_sd = cumsum(`Movim. Líquido - R$ (Conta Contábil)`)/1000,
         pg_mes = `PAGAMENTOS TOTAIS (EXERCICIO E RAP)`/1000) %>%
  ungroup() %>%
  filter(mes != 0) %>%
  select(Anexo, cod_orgao, nom_orgao, mes, ano, pg_mes, lim_sq_sd, pg_sd, cred_sd, a_liq_sd, liq_a_pg_sd) %>%
  left_join(lim_pag) %>%
  filter(!is.na(nome_orgao))

write.csv(dados, file = "orc_fin.csv", fileEncoding = "UTF-8")

# dados_org1 <- dados %>% filter(cod_orgao == "30000", mes == 4)



