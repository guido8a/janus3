
<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Garantías
    </title>
</head>

<body>

<div class="col-md-12" style="margin-bottom: 10px">

    <a href="#" class="btn btn-primary col-md-1" id="regresar">
        <i class=" fa fa-arrow-left"></i>
        Regresar
    </a>

    <div class="col-md-3">
        <b>Buscar Por: </b>
        <g:select name="buscador" from="${['contrato':'N° Contrato', 'cdgo': 'Garantía', 'nmrv': 'Renovación', 'tpgr': 'Tipo de Garantía', 'tdgr': 'Documento',
                                           'aseguradora':'Aseguradora', 'cont': 'Contratista', 'etdo':'Estado', 'mnto': 'Monto', 'mnda':'Moneda', 'fcin': 'Emisión', 'fcfn': 'Vencimiento',
                                           'dias':'Días']}" value="${params.buscador}"
                  optionKey="key" optionValue="value" id="buscador_gar" style="width: 150px"/>
    </div>

    <div class="col-md-4 hide" id="divFecha">
        <b>Fecha: </b>
        <input aria-label="" name="fecha_gar" id='fecha_gar' type='text' class="input-small" value="${params.fecha?.format("dd-MM-yyyy")}" />
    </div>
    <div class="col-md-4" id="divCriterio">
        <b>Criterio: </b>
        <g:textField name="criterio" id="criterio_gar" value="${params.criterio}" style="width: 250px;"/>
    </div>

    <div>
        <a href="#" class="btn btn-success" id="buscar">
            <i class="fa fa-search"></i>
            Buscar
        </a>
        <a href="#" class="btn btn-info" id="imprimir" >
            <i class="fa fa-print"></i>
            Imprimir
        </a>
        <a href="#" class="btn btn-success" id="excel" >
            <i class="fa fa-file-excel"></i>
            Excel
        </a>
    </div>

</div>

<div style="margin-top: 15px; min-height: 300px">
    <table class="table table-bordered table-hover table-condensed" style="width: 100%; background-color: #a39e9e">
        <thead>
        <tr>

            <th style="width: 9%;">
                N° Contrato
            </th>
            <th style="width: 9%;">
                N° Garantía
            </th>
            <th style="width: 11%">
                Tipo de Garantía
            </th>
            <th style="width: 7%">
                Documento
            </th>
            <th style="width: 19%">
                Aseguradora
            </th>
            <th style="width: 17%">
                Contratista
            </th>
            <th style="width: 7%">
                Monto
            </th>
            <th style="width: 8%">
                Emisión
            </th>
            <th style="width: 8%">
                Vencimiento
            </th>
            <th style="width: 5%">
                Días
            </th>
        </tr>
        </thead>
    </table>
    <div id="detalle">
    </div>
</div>


<script type="text/javascript">

    $("#buscar").click(function(){
        cargarTabla();
    });

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'reportes', action: 'index')}"
    });

    $("#imprimir").click(function () {
        location.href="${g.createLink(controller: 'reportes4', action:'reporteGarantias' )}?buscador=" + $("#buscador_gar").val() + "&criterio=" + $("#criterio_gar").val()
    });

    $("#excel").click(function () {
        location.href="${g.createLink(controller: 'reportesExcel', action:'reporteExcelGarantias' )}?buscador=" + $("#buscador_gar").val() + "&criterio=" + $("#criterio_gar").val()
    });

    $("#buscador_gar").change(function () {
        var seleccionado = $(this).val();
        if( ['fcin','fcfn'].includes(seleccionado)){
            $("#divFecha").removeClass("hide");
            $("#divCriterio").addClass("hide");
        }else{
            $("#divCriterio").removeClass("hide");
            $("#divFecha").addClass("hide");
            $("#fecha_gar").val('')
        }
    });

    $('#fecha_gar').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var datos = "si=${"si"}&buscador=" + $("#buscador_gar").val() + "&criterio=" + $("#criterio_gar").val() + "&fecha=" + $("#fecha_gar").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaGarantias')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    }

</script>
</body>
</html>

