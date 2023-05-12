<div id="modal-transporte2" style="overflow: hidden;">

    <div class="col-md-12">

        <div class="col-md-2">
            Lista de precios: MO y Equipos
        </div>

        <div class="col-md-3">
            <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=6')}" optionKey="id"
                      optionValue="descripcion" id="ciudad" class="form-control"/>
        </div>

        <div class="col-md-1">
            Fecha
        </div>

        <div class="col-md-2">
            <input aria-label="" name="item.fecha" id="fecha_precios2" type='text' class="form-control" value="${new java.util.Date()?.format("dd-MM-yyyy HH:mm")}" />
        </div>

        <div class="col-md-2" >
            % costos indirectos
        </div>

        <div class="col-md-1">
            <input type="text" class="form-control" style="width: 100px" id="costo_indi2" value="22.5">
        </div>
    </div>
    <hr style="margin: 5px 0 10px 0;"/>

    <div class="col-md-12" style="margin-top: 10px">
        <div class="col-md-3">
            Volquete
            <g:select name="volquetes" from="${volquetes2}" optionKey="id" optionValue="nombre" id="cmb_vol2" class="form-control" noSelection="${['-1': 'Seleccione']}" value="${aux.volquete.id}"/>
        </div>

        <div class="col-md-2">
            Costo
            <input type="text" class="form-control" style="text-align: right" disabled="" id="costo_volqueta2">
        </div>

        <div class="col-md-4">
            Chofer
            <g:select name="volquetes" from="${choferes}" optionKey="id" optionValue="nombre" id="cmb_chof2" class="form-control" noSelection="${['-1': 'Seleccione']}" value="${aux.chofer.id}"/>
        </div>

        <div class="col-md-2">
            Costo
            <input type="text" class="form-control" style="text-align: right" disabled="" id="costo_chofer2">
        </div>
    </div>

    <div class="col-md-12" style="border-top: 1px solid black; margin-top: 10px; margin-bottom: 10px">
        <div class="col-md-6" style="text-align: center">
            <b>Distancia peso</b>
        </div>

        <div class="col-md-5" style="text-align: center">
            <b>Distancia volumen</b>
        </div>
    </div>

    <div class="col-md-12">
        <div class="col-md-1">
            Cantón
        </div>
        <div class="col-md-2">
            <input type="text" class="form-control" style="width: 100px;" id="dist_p1g" value="10.00">
        </div>
        <div class="col-md-3"></div>
        <div class="col-md-3">
            Materiales Petreos Hormigones
        </div>
        <div class="col-md-2">
            <input type="text" class="form-control" style="width: 100px;" id="dist_v1g" value="20.00">
        </div>
    </div>

    <div class="col-md-12">
        <div class="col-md-1">
            Especial
        </div>
        <div class="col-md-2">
            <input type="text" class="form-control" style="width: 100px;" id="dist_p2g" value="10.00">
        </div>
        <div class="col-md-3"></div>
        <div class="col-md-3">
            Materiales Mejoramiento
        </div>

        <div class="col-md-2">
            <input type="text" class="form-control" style="width: 100px;" id="dist_v2g" value="20.00">
        </div>
    </div>

    <div class="col-md-12">
        <div class="col-md-6">
        </div>
        <div class="col-md-3">
            Materiales Carpeta Asfáltica
        </div>

        <div class="col-md-2">
            <input type="text" class="form-control" style="width: 100px;" id="dist_v3g" value="20.00">
        </div>
    </div>

    <div class="col-md-12" style="border-top: 1px solid black;margin-bottom: 10px; margin-top: 10px; text-align: center">
        <b>Listas de precios</b>
    </div>

    <div class="col-md-12">
        <div class="col-md-1">
            Cantón
        </div>
        <div class="col-md-4">
            <g:select name="item.ciudad.id" class="form-control" from="${janus.Lugar.findAll('from Lugar  where tipoLista=1')}" optionKey="id" optionValue="descripcion" id="lista_1g"/>
        </div>
        <div class="col-md-2">
            Petreos Hormigones
        </div>
        <div class="col-md-5">
            <g:select name="item.ciudad.id" class="form-control" from="${janus.Lugar.findAll('from Lugar  where tipoLista=3')}" optionKey="id" optionValue="descripcion" id="lista_3g"/>
        </div>
    </div>

    <div class="col-md-12">
        <div class="col-md-1">
            Especial
        </div>
        <div class="col-md-4">
            <g:select name="item.ciudad.id" class="form-control" from="${janus.Lugar.findAll('from Lugar  where tipoLista=2')}" optionKey="id" optionValue="descripcion" id="lista_2g"/>
        </div>
        <div class="col-md-2">
            Mejoramiento
        </div>
        <div class="col-md-5">
            <g:select name="item.ciudad.id" class="form-control" from="${janus.Lugar.findAll('from Lugar  where tipoLista=4')}" optionKey="id" optionValue="descripcion" id="lista_4g"/>
        </div>
    </div>

    <div class="col-md-12">
        <div class="col-md-5"></div>

        <div class="col-md-2">
            Carpeta Asfáltica
        </div>

        <div class="col-md-5">
            <g:select name="item.ciudad.id" class="form-control" from="${janus.Lugar.findAll('from Lugar  where tipoLista=5')}" optionKey="id" optionValue="descripcion" id="lista_5g"/>
        </div>
    </div>

    <div class="col-md-12" style="text-align: right; margin-top: 20px">
        <g:hiddenField name="nodeId" val=""/>
        <g:hiddenField name="nodeGrupo" val=""/>

        <g:if test="${id.split("_")[0] == 'gr'}">
            <a href= "#" data-dismiss="modal" class="btn btn-primary" id="imp_consolidado" data-transporte="true"><i class="fa fa-print"></i> Consolidado</a>
            <a href= "#" data-dismiss="modal" class="btn btn-success" id="imp_consolidado_excel" data-transporte="true"><i class="fa fa-file-excel"></i> Consolidado Excel</a>
        </g:if>
        <g:else>
            <a href= "#" data-dismiss="modal" class="btn btn-primary" id="print_totales" data-transporte="true"><i class="fa fa-print"></i> Consolidado</a>
            <a href="#" data-dismiss="modal" class="btn btn-info btnPrint" data-transporte="si"><i class="fa fa-truck"></i> Con transporte</a>
            <a href="#" data-dismiss="modal" class="btn btn-primary btnPrint" data-transporte="no"><i class="fa fa-print"></i> Sin transporte</a>
            <a href="#" data-dismiss="modal" class="btn btn-info btnPrintVae" data-transporte="si"><i class="fa fa-truck"></i> VAE con transporte</a>
            <a href="#" data-dismiss="modal" class="btn btn-primary btnPrintVae" data-transporte="no"><i class="fa fa-print"></i> VAE sin transporte</a>
        </g:else>
    </div>
</div>

<script type="text/javascript">

    $('#fecha_precios2').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    function getPrecios($cmb, $txt, $fcha) {
        if ($cmb.val() !== "-1") {
            var datos = "fecha=" + $fcha.val() + "&ciudad=" + $("#ciudad").val() + "&ids=" + $cmb.val();
            $.ajax({
                type    : "POST",
                url     : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                data    : datos,
                success : function (msg) {
                    var precios = msg.split("&");
                    for (var i = 0; i < precios.length; i++) {
                        var parts = precios[i].split(";");
                        if (parts.length > 1) {
                            $txt.val(parts[1].trim());
                        }
                    }
                }
            });
        } else {
            $txt.val("0.00");
        }
    }

    $("#fecha_precios2").change(function(){
        $("#cmb_vol2").change();
        $("#cmb_chof2").change();
    });

    $("#cmb_vol2").change(function () {
        getPrecios($("#cmb_vol2"), $("#costo_volqueta2"), $("#fecha_precios2"));
    });

    $("#cmb_chof2").change(function () {
        getPrecios($("#cmb_chof2"), $("#costo_chofer2"), $("#fecha_precios2"));
    });

    getPrecios($("#cmb_chof2"), $("#costo_chofer2"), $("#fecha_precios2"));
    getPrecios($("#cmb_vol2"), $("#costo_volqueta2"), $("#fecha_precios2"));

    $(".btnPrint").click(function () {

        var dsp0 = $("#dist_p1g").val();
        var dsp1 = $("#dist_p2g").val();
        var dsv0 = $("#dist_v1g").val();
        var dsv1 = $("#dist_v2g").val();
        var dsv2 = $("#dist_v3g").val();
        var listas = $("#lista_1g").val() + "," + $("#lista_2g").val() + "," + $("#lista_3g").val() + "," + $("#lista_4g").val() + "," + $("#lista_5g").val() + "," + $("#ciudad").val();
        var volqueta = $("#costo_volqueta2").val();
        var chofer = $("#costo_chofer2").val();
        var trans = $(this).data("transporte");
        var nodeId = '${id}';

        var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 +
            "&dsv2=" + dsv2 + "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios2").val() +
            "&id=" + nodeId + "&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof2").val() +
            "&volq=" + $("#cmb_vol2").val() + "&indi=" + $("#costo_indi2").val() + "&trans=" + trans;
        location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosTransporteGrupo')}?" + datos;

        return false;
    });

    $(".btnPrintVae").click(function () {
        var dsp0 = $("#dist_p1g").val();
        var dsp1 = $("#dist_p2g").val();
        var dsv0 = $("#dist_v1g").val();
        var dsv1 = $("#dist_v2g").val();
        var dsv2 = $("#dist_v3g").val();
        var listas = $("#lista_1g").val() + "," + $("#lista_2g").val() + "," + $("#lista_3g").val() + "," + $("#lista_4g").val() + "," + $("#lista_5g").val() + "," + $("#ciudad").val();
        var volqueta = $("#costo_volqueta2").val();
        var chofer = $("#costo_chofer2").val();
        var trans = $(this).data("transporte");
        var nodeId = '${id}';

        var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1
            + "&dsv2=" + dsv2 + "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios2").val()
            + "&id=" + nodeId + "&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof2").val()
            + "&volq=" + $("#cmb_vol2").val() + "&indi=" + $("#costo_indi2").val() + "&trans=" + trans;
        location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosVaeGrupo')}?" + datos;

        return false;
    });

    $("#print_totales").click(function () {
        var dsp0 = $("#dist_p1g").val();
        var dsp1 = $("#dist_p2g").val();
        var dsv0 = $("#dist_v1g").val();
        var dsv1 = $("#dist_v2g").val();
        var dsv2 = $("#dist_v3g").val();
        var listas = $("#lista_1g").val() + "," + $("#lista_2g").val() + "," + $("#lista_3g").val() + "," + $("#lista_4g").val() + "," + $("#lista_5g").val() + "," + $("#ciudad").val();
        var volqueta = $("#costo_volqueta2").val();
        var chofer = $("#costo_chofer2").val();
        var trans = $(this).data("transporte");
        var nodeId = '${id}';
        var principal = false;

        var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2 +
            "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios2").val() + "&id=" + nodeId +
            "&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof2").val() +
            "&volq=" + $("#cmb_vol2").val() + "&indi=" + $("#costo_indi2").val() + "&principal=" + principal +"&trans=" + trans;
        location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosConsolidadoGrupo')}?" + datos;

        return false;
    });

    $("#imp_consolidado").click(function () {
        var dsp0 = $("#dist_p1g").val();
        var dsp1 = $("#dist_p2g").val();
        var dsv0 = $("#dist_v1g").val();
        var dsv1 = $("#dist_v2g").val();
        var dsv2 = $("#dist_v3g").val();
        var lista1 = $("#lista_1g").val();
        var lista2 = $("#lista_2g").val();
        var lista3 = $("#lista_3g").val();
        var lista4 = $("#lista_4g").val();
        var lista5 = $("#lista_5g").val();
        var lista6 = $("#ciudad").val();
        var volqueta = $("#costo_volqueta2").val();
        var chofer = $("#costo_chofer2").val();
        var trans = $(this).data("transporte");
        var nodeId = '${id}';
        var principal = true;

        var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2 +
            "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios2").val() + "&id=" + nodeId +
            "&lugar=" + $("#ciudad").val() + "&lista1=" + lista1 + "&lista2=" + lista2 + "&lista3=" + lista3 +
            "&lista4=" + lista4 + "&lista5=" + lista5 + "&lista6=" + lista6 + "&principal=" + principal
            + "&chof=" + $("#cmb_chof2").val() +
            "&volq=" + $("#cmb_vol2").val() + "&indi=" + $("#costo_indi2").val() + "&trans=" + trans;
        location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosConsolidadoGrupo2')}?" + datos;

        return false;
    });

    $("#imp_consolidado_excel").click(function () {

        var dsp0 = $("#dist_p1g").val();
        var dsp1 = $("#dist_p2g").val();
        var dsv0 = $("#dist_v1g").val();
        var dsv1 = $("#dist_v2g").val();
        var dsv2 = $("#dist_v3g").val();
        var lista1 = $("#lista_1g").val();
        var lista2 = $("#lista_2g").val();
        var lista3 = $("#lista_3g").val();
        var lista4 = $("#lista_4g").val();
        var lista5 = $("#lista_5g").val();
        var lista6 = $("#ciudad").val();
        var volqueta = $("#costo_volqueta2").val();
        var chofer = $("#costo_chofer2").val();
        var trans = $(this).data("transporte");
        var nodeId = '${id}';
        var principal = true;

        var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2 +
            "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios2").val() + "&id=" + nodeId +
            "&lugar=" + $("#ciudad").val() + "&lista1=" + lista1 + "&lista2=" + lista2 + "&lista3=" + lista3 +
            "&lista4=" + lista4 + "&lista5=" + lista5 + "&lista6=" + lista6 + "&principal=" + principal
            + "&chof=" + $("#cmb_chof2").val() +
            "&volq=" + $("#cmb_vol2").val() + "&indi=" + $("#costo_indi2").val() + "&trans=" + trans;
        location.href = "${g.createLink(controller: 'reportesExcel2',action: 'consolidadoExcel')}?" + datos;
        return false;
    });

</script>