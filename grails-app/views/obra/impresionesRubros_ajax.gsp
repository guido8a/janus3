<div class="container">
    <div class="col-md-9 btn-group" style="margin-bottom: 10px">
        <a href="#" id="btnReporte" class="btn"><i class="fa fa-truck"></i>
            Con desglose de Trans.
        </a>
        <a href="#" id="btnReporteGeneral" class="btn"><i class="fa fa-print"></i>
            Sin desglose de Trans.
        </a>
        <a href="#" id="btnReporteVenceran" class="btn btn-success"><i class="fa fa-file-excel"></i>
            Exportar Rubros a Excel
        </a>
    </div>

    <div class="col-md-9 btn-group" style="margin-bottom: 10px">
        <a href="#" id="btnReporteVAEsinFecha" class="btn"><i class="fa fa-truck"></i>
            VAE con desglose de Trans (Sin fecha)
        </a>
        <a href="#" id="btnReporteVencidas" class="btn"><i class="fa fa-print"></i>
            VAE sin desglose de Trans.
        </a>
        <a href="#" id="btnExpVaeExcel" class="btn btn-success"><i class="fa fa-file-excel"></i>
            Exportar VAE a Excel
        </a>
    </div>
    <div class="col-md-9 btn-group" style="margin-bottom: 10px">
        <a href="#" id="btnIlustraciones" class="btn"><i class="fa fa-image"></i>
            Imprimir las Ilustraciones y las Especificaciones de los Rubros utilizados en la Obra
        </a>
    </div>
</div>

<script type="text/javascript">

    $("#btnReporte").click(function () {
        location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosTransporteRegistro')}?" + "&desglose=" + 1 + "&obra=" + '${obra?.id}';
    });

    $("#btnReporteGeneral").click(function () {
        location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosTransporteRegistro')}?" + "&desglose=" + 0 + "&obra=" + '${obra?.id}';
    });

    $("#btnReporteVenceran").click(function () {
        var url = "${createLink(controller:'reportesExcel', action:'imprimirRubrosExcel')}?obra=${obra?.id}&transporte=";
        url += "1";
        location.href = url;
    });

    $("#btnReporteDevueltas").click(function (){
        location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVaeRegistro')}?" + "&desglose=" + 1 + "&obra=" + '${obra?.id}';
    });

    $("#btnReporteVencidas").click(function ()  {
        location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVaeRegistro')}?" + "&desglose=" + 0 + "&obra=" + '${obra?.id}';
    });

    $("#btnReporteVAEsinFecha").click(function ()  {
        %{--location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVaeRegistro')}?" + "&desglose=" + 1 + "&obra=" + '${obra?.id}' + "&tipo=" + 1;--}%
        location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosVaeRegistro')}?" + "&desglose=" + 1 + "&obra=" + '${obra?.id}' + "&tipo=" + 1;
    });

    $("#btnExpVaeExcel").click(function () {
        var urlVaeEx = "${createLink(controller:'reportesExcel', action:'imprimirRubrosVaeExcel')}?obra=${obra?.id}&transporte=";
        urlVaeEx += "1";
        location.href = urlVaeEx;
    });

    $("#btnIlustraciones").click(function () {
        $.ajax({
            type: "POST",
            url: "${createLink(controller:'reportes2', action:'comprobarIlustracion')}",
            data: {
                id: '${obra?.id}',
                tipo: "ie"
            },
            success: function (msg) {
                console.log(msg);
                var parts = msg.split('*');

                if (parts[0] === 'SI') {
                    $("#divError").hide();
                    console.log("okkkk");
                    location.href = "${createLink(controller:'reportes2', action:'reporteRubroIlustracion')}?id=${obra?.id}&tipo=ie";
                } else {
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Archivo no encontrado" + '</strong>');
                }
            }
        });
    });

</script>

