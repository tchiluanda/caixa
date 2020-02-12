// captura referencias a elementos da página
const $grafico_container = d3.select('#anexos');
const $svgs     = $grafico_container.selectAll("svg");

// margem geral
const PAD = 40;

// captures the container's width
// and uses it as the svg width
// -> learnt that with @codenberg
const w = $grafico_container.node().offsetWidth;
console.log("Largura do container: ", w);

// defines h and the number of itens in the rank
//  based on the width

const h = 200;
//const w_grafico = w < 400 ? w : 400;



// configures svg dimensions
$svgs      
  .attr('width', w)
  .attr('height', h);

// formatação valores
    
const localeBrasil = {
    "decimal": ",",
    "thousands": ".",
    "grouping": [3],
    "currency": ["R$", ""]};

const formataBR = d3.formatDefaultLocale(localeBrasil).format(",.0f");

const formata_vlr_tooltip = function(val){
    return "R$ "+formataBR(val/1e6)+" mi"
}

// function to process the data

d3.csv("orc_fin.csv").then(function(dados) {
    //console.table(dados);

    // lista orgaos
    const orgaos = d3.map(dados, d => d.cod_orgao + " - " + d.nom_orgao)
    const lista_unica_orgaos = d3.map(orgaos, d => d).keys();
    const meses = ["JAN","FEV","MAR","ABR","MAI","JUN","JUL","AGO","SET","OUT","NOV","DEZ"]
    
    // popular os <select>

    const $menu_orgao = d3.select("#menu-orgao");
    const $menu_mes = d3.select("#menu-mes");

    const $menu_orgao_options = $menu_orgao
      .selectAll("option.js-populados")
      .data(lista_unica_orgaos)
      .enter()
      .append("option")
      .classed("js-populados", true)
      .property("value", d => d)
      .text(d => d);

    const $menu_mes_options = $menu_mes
      .selectAll("option.js-populados")
      .data(meses)
      .enter()
      .append("option")
      .classed("js-populados", true)
      .property("value", d => d)
      .text(d => d);

    // desenhar o grafico


    const draw_mes = function(cod_orgao, mes, anexo) {
      const dados_filtrados = dados.filter(
        d => d.cod_orgao == cod_orgao & 
             d.mes == mes &
             d.Anexo == anexo);

      console.log(dados_filtrados);

      // maximos
      const max_lim_pag = d3.max(dados_filtrados, d => +d.lim_pag);
      const max_pago_lim_sq = d3.max(dados_filtrados, d => +d.pg_mes + +d.lim_sq_sd);
      const max_pago_liq_pg = d3.max(dados_filtrados, d => +d.pg_mes + +d.liq_a_pg_sd);

      console.log("maximos", [max_lim_pag, max_pago_lim_sq, max_pago_liq_pg]);

      const max_geral = d3.max([max_lim_pag, max_pago_lim_sq, max_pago_liq_pg]);

      console.log(max_geral);

      const scale_x = d3.scaleLinear()
        .domain([0, max_geral])
        .range([PAD, w_grafico-PAD]);


      const $rect1 = $svg.selectAll("rect.rect1").data(dados_filtrados);
      $rect1.enter().append("rect")
       .attr("x", PAD)
       .attr("y", PAD)
       .attr("width", function(d) {console.log("hi", +d.lim_pag); return(scale_x(+d.lim_pag))})
       .attr("height", 10)
       .attr("fill", "teal");

      const $rect2 = $svg.selectAll("rect.rect2").data(dados_filtrados);
       $rect2.enter().append("rect")
        .attr("x", PAD)
        .attr("y", PAD * 2)
        .attr("width", d => scale_x(+d.pg_mes))
        .attr("height", 10)
        .attr("fill", "limegreen");   
        
      const $rect3 = $svg.selectAll("rect.rect3").data(dados_filtrados);
        $rect3.enter().append("rect")
         .attr("x", d => PAD + scale_x(+d.pg_mes))
         .attr("y", PAD * 2)
         .attr("width", d => scale_x(+d.lim_sq_sd))
         .attr("height", 10)
         .attr("fill", "firebrick");  
    }

    draw_mes("20000", "2", "Anexo II")

    //console.log(lista_unica_orgaos);

})
