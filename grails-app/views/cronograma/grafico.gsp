<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Gráficos de avance</title>

        <asset:javascript src="/apli/Chart.js"/>
        %{--<asset:javascript src="/jquery/plugins/jqplot/plugins/jqplot.canvasTextRenderer.min.js"/>--}%
        %{--<asset:javascript src="/jquery/plugins/jqplot/plugins/jqplot.canvasAxisLabelRenderer.min.js"/>--}%
        %{--<asset:javascript src="/jquery/plugins/jqplot/plugins/jqplot.highlighter.min.js"/>--}%
        %{--<asset:javascript src="/jquery/plugins/jqplot/jquery.jqplot.min.css"/>--}%


        %{--<script language="javascript" type="text/javascript" src="${resource(dir: 'js/jquery/plugins/jqplot', file: 'jquery.jqplot.min.js')}"></script>--}%
        %{--<link rel="stylesheet" type="text/css" href="${resource(dir: 'js/jquery/plugins/jqplot', file: 'jquery.jqplot.min.css')}"/>--}%

        %{--<script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/jqplot/plugins', file: 'jqplot.canvasTextRenderer.min.js')}"></script>--}%
        %{--<script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/jqplot/plugins', file: 'jqplot.canvasAxisLabelRenderer.min.js')}"></script>--}%
        %{--<script type="text/javascript" src="${resource(dir: 'js/jquery/plugins/jqplot/plugins', file: 'jqplot.highlighter.min.js')}"></script>--}%

        <style type="text/css">

        .grafico{
            border-style: solid;
            border-color: #606060;
            border-width: 1px;
            width: 47%;
            float: left;
            text-align: center;
            height: 420px;
            border-radius: 8px;
            margin: 10px;
        }
        .bajo {
            margin-bottom: 20px;
        }
        .centrado{
            text-align: center;
        }

        .legend {
            width: 50%;
            position: absolute;
            top: 100px;
            right: 20px;
            /*color: @light;*/
            /*font-family: @family;*/
            font-variant: small-caps;
            font-size: 14px;
        }

        </style>


    </head>

    <body>
        <div class="btn-toolbar">
            <div class="btn-group">
                <g:link action="cronogramaObra" id="${obra.id}" params="[subpre: params.subpre]" class="btn">
                    <i class="fa fa-arrow-left"></i>
                    Cronograma
                </g:link>
            </div>

        </div>

        <div id="grafEco" class="graf" style="margin-top: 15px;"></div>

        <div id="grafFis" class="graf"></div>



    <div class="chart-container grafico" id="chart-area" hidden>
    %{--<div class="chart-container grafico" id="chart-area">--}%
        <h3 id="titulo"></h3>
        <div id="subTitulo" style="font-size: 14px"></div>
        <div id="graf">
            <canvas id="clases" style="margin-top: 30px"></canvas>
        </div>
    </div>

    <div class="chart-container grafico" id="chart-area2" hidden>
        <h3 id="titulo2"></h3>
        <div id="subTitulo2" style="font-size: 14px"></div>
        <div id="graf2">
            <canvas id="clases2" style="margin-top: 30px"></canvas>
        </div>
    </div>


<script type="text/javascript">

    var canvas = $("#clases");
    var myChart;

    $(function () {
        openLoader("Graficando...");

        $("#chart-area").removeClass('hidden')

        var valores = "${data}".split("_");
        var valores2 = "${datapcnt}".split("_");
        var meses = "${mes}".split("_");
//        var val = valores.map( n => parseFloat(n) );
        console.log('data', valores)
        $("#titulo").html("Avance Económico ($)")
        $("#titulo2").html("Avance Físico (%)")
        $("#subTitulo").html("Obra: ${obra.nombre}")
        $("#subTitulo2").html("Obra: ${obra.nombre}")
        $("#clases").remove();
//        $("#r1").remove();
//        $("#r2").remove();
//        $("#c1").remove();
//        $("#dc1").remove();
//        $("#c2").remove();
//        $("#dc2").remove();
//        $("#c3").remove();
//        $("#dc3").remove();
        $("#chart-area").removeAttr('hidden')
        $("#chart-area2").removeAttr('hidden')


        /* se crea dinámicamente el canvas y la función "click" */
        $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');
        $('#graf2').append('<canvas id="clases2" style="margin-top: 30px"></canvas>');

//        $('#datosRc').append('<tr><td class= "centrado" id="r1">' + valores[4] +
//            '</td><td class= "centrado" id="r2">' + valores[5] + '</td></tr>');
//
//        $('#divDatos').append('<tr><td class= "centrado" id="c1">A</td><td class= "centrado" id="dc1">' +
//            valores[0] + '</td></tr><tr><td class= "centrado" id="c2">B</td><td class= "centrado" id="dc2">' +
//            valores[1] + '</td></tr><tr><td class= "centrado" id="c3">C</td><td class= "centrado" id="dc3">' +
//            valores[2] + '</td></tr>');

        $("#clases").off();
        canvas = $("#clases")
        var chartData = {
            type: 'line',
            data: {
                labels: meses,
                datasets: [
                    {
                        label: ["Acumulado"],
                        borderColor: ['#40d6d8'],
                        data: valores
                    }
                ]
            },
            options: {
                legend: {
                    display: false,
                    labels: {
                        fontColor: 'rgb(20, 80, 100)',
                        fontSize: 14
                    }
                },
            }
        };

        $("#clases2").off();
        canvas2 = $("#clases2")
        var chartData2 = {
            type: 'line',
            data: {
                labels: meses,
                datasets: [
                    {
                        label: ["Acumulado (%)"],
                        borderColor: ['#8086d8'],
                        data: valores2
                    }
                ]
            },
            options: {
                legend: {
                    display: false,
                    labels: {
                        fontColor: 'rgb(20, 80, 100)',
                        fontSize: 14
                    }
                },
            }
        };

        myChart = new Chart(canvas, chartData, 1);
        myChart2 = new Chart(canvas2, chartData2, 1);

    });


</script>
    </body>
</html>