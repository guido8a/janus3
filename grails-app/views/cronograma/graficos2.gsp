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
            height: 540px;
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
                    <i class="icon-caret-left"></i>
                    Cronograma
                </g:link>
            </div>

            <div class="row text-info" style="text-align: center">
                <div class="btn btn-info graficar">
                    <i class="fa fa-pie-chart"></i> Graficar
                </div>
            </div>
        </div>

        <div id="grafEco" class="graf" style="margin-top: 15px;"></div>

        <div id="grafFis" class="graf"></div>



    <div class="chart-container grafico" id="chart-area" hidden>
    %{--<div class="chart-container grafico" id="chart-area">--}%
        <h3 id="titulo"></h3>
        <div id="graf">
            <canvas id="clases" style="margin-top: 30px"></canvas>
        </div>

        <div id="tabla" style="margin-left: 20%; margin-top: 10px; width: 60%; height: 124px; border-style: solid; border-width: 1px; border-color: #888">
            <table class="table table-condensed table-bordered table-striped table-hover" style="width: 100%">
                <thead>
                <tr>
                    <th class="centrado" rowspan="2" style="width: 40%">Clase</th>
                    <th class="centrado" rowspan="2" style="width: 40%">Valor</th>
                </tr>
                </thead>

                <tbody id="divDatos">
                </tbody>
            </table>
        </div>

        <div style="margin-top: 10px">
            <a href="#" class="btn btn-info" id="imprimirClases">
                <i class="fa fa-line-chart"></i> Imprimir
            </a>
        </div>
    </div>



<script type="text/javascript">

            var canvas = $("#clases");
            var myChart;

            $(function() {
                console.log( "ready!" );
                $(".graficar").click();
            });

            $(".graficar").click(function () {

                openLoader("Graficando...");

                var prdo = $("#periodoId").val();
                var univ = $("#universidadId").val();
                var facl = $("#facultad").val();
//                var escl = $("#escuelaId option:selected").val();
                var escl = 1;

                if(escl != null){
                    $("#chart-area").removeClass('hidden')
//                    $("#chart-area2").removeClass('hidden')
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'cronograma', action: 'clasificar')}',
                        data: {facl: facl, prdo: prdo, univ: univ, escl: escl},
                        success: function (msg) {

                            closeLoader();

                            var valores = msg.split("_")
                            $("#titulo").html(valores[3])
                            $("#titulo2").html(valores[6])
                            $("#clases").remove();
                            $("#r1").remove();
                            $("#r2").remove();
                            $("#c1").remove(); $("#dc1").remove();
                            $("#c2").remove(); $("#dc2").remove();
                            $("#c3").remove(); $("#dc3").remove();
                            $("#chart-area").removeAttr('hidden')

                            /* se crea dinámicamente el canvas y la función "click" */
                            $('#graf').append('<canvas id="clases" style="margin-top: 30px"></canvas>');

                            $('#datosRc').append('<tr><td class= "centrado" id="r1">' + valores[4] +
                                '</td><td class= "centrado" id="r2">' + valores[5]+ '</td></tr>');

                            $('#divDatos').append('<tr><td class= "centrado" id="c1">A</td><td class= "centrado" id="dc1">' +
                                valores[0] + '</td></tr><tr><td class= "centrado" id="c2">B</td><td class= "centrado" id="dc2">' +
                                valores[1]+ '</td></tr><tr><td class= "centrado" id="c3">C</td><td class= "centrado" id="dc3">' +
                                valores[2]+ '</td></tr>');

                            $("#clases").off();

                            canvas = $("#clases")

                            var chartData = {
//                                type: 'bar',
                                type: 'line',
                                data: {
                                    labels: ['Período 1', 'Períodop 2', 'Período 3'],
                                    datasets: [
                                        {
                                            label: ["Acumulado"],
//                                            backgroundColor: ['#009608', '#ffa900', '#cc2902'],
                                            borderColor: ['#40d648', '#ffe940', '#fc6942'],
                                            borderWidth: [3,3,3],
                                            data: [valores[0], valores[1], valores[2]]
                                        }
                                    ]
                                },
                                options: {
                                    legend: { display: false,
                                        labels: {
                                            fontColor: 'rgb(20, 80, 100)',
                                            fontSize: 14
                                        }
                                    }
                                }
                            };

                            myChart = new Chart(canvas, chartData, 1);

                        }


                    });
                }else{
                    closeLoader();
                    $("#chart-area").addClass('hidden');
                    $("#chart-area2").addClass('hidden');
                    log("Seleccione una carrera","info")
                }


            });

        </script>
    </body>
</html>