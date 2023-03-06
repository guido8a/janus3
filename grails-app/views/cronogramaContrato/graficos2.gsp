<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Gráficos de avance</title>

    <asset:javascript src="/apli/Chart.js"/>

    <style>
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

    </style>

</head>

<body>
<div class="btn-toolbar">
    <div class="btn-group">
        <g:link action="nuevoCronograma" id="${contrato?.id}" class="btn btn-info">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
    </div>
</div>

<div id="grafEco" class="graf" style="margin-top: 15px;"></div>

<div id="grafFis" class="graf"></div>


<div class="chart-container grafico" id="chart-area" hidden>
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

        $("#chart-area").removeClass('hidden');

        var valores = "${data}".split("_");
        var valores2 = "${datapcnt}".split("_");
        var meses = "${mes}".split("_");
        console.log('data', valores);
        $("#titulo").html("Avance Económico ($)");
        $("#titulo2").html("Avance Físico (%)");
        $("#subTitulo").html("Obra: ${obra.nombre}");
        $("#subTitulo2").html("Obra: ${obra.nombre}");
        $("#clases").remove();
        $("#chart-area").removeAttr('hidden');
        $("#chart-area2").removeAttr('hidden');

        $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');
        $('#graf2').append('<canvas id="clases2" style="margin-top: 30px"></canvas>');

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
                }
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
                }
            }
        };

        myChart = new Chart(canvas, chartData, 1);
        myChart2 = new Chart(canvas2, chartData2, 1);

    });

</script>
</body>
</html>