# Projeto Caixa

A ideia deste projeto é analisar o comportamento do caixa e das obrigações financeiras dos órgãos federais, com a finalidade de fornecer informações para a gestão da programação financeira por parte do Tesouro Nacional, além de dentificar oportunidades de melhorias nesse processo.

Vamos elencar aqui alguns aspectos, ou componentes, importantes do projeto, sem uma ordem específica.

### É preciso de início conhecer o perfil das despesas e receitas orçamentárias desses órgãos.

Vamos começar com um perfil das despesas do Ministério da Justiça (que já tem um excelente sistema de acompanhamento das despesas).

Para chamar a atenção, vamos usar um diagrama de bolhas em D3 semelhante [ao do Jim Vallandingham](https://vallandingham.me/bubble_charts_with_d3v4.html).

### Tentar compatibilizar as informações orçamentárias (classificações como função, subfunção, ação, grupo de despesa, indicadores orçamentários etc.) com as informações financeiras (vinculação de pagamento, essencialmente). 

Como fazer isso diretamente a partir do Siafi?

Algumas ideias, a serem testadas:

* analisar as despesas pagas, pelos classificadores, pelo número da nota de empenho e pelo número do documento de pagamento; e relacionar documento de pagamento x nota de empenho x vinculação de pagamento pelo campo "inscrição" do documento de pagamento.

* analisar as despesas pagas, pelos classificadores, pelo número da nota de empenho e pelo número do documento de pagamento; e tentar compatibilizar com as informações dos pagamentos efetuados, por vinculação de pagamento e número do documento de pegamento.

### Analisar os saldos diários do caixa (detalhados por vinculações) e das obrigações financeiras (detalhados por classificações orçamentárias).

Semelhante ao que foi feito [aqui](https://github.com/TesouroNacional/puddles-puddles), só que melhor.

