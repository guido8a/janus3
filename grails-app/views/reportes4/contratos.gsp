
<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Contratos
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
        <g:select name="buscador" from="${['cdgo':'N° Contrato', 'memo': 'Memo', 'fcsb': 'Fecha Suscrip', 'tipo': 'Tipo Contrato', 'cncr': 'Concurso',
                                           'obra':'Obra', 'nmbr': 'Nombre', 'cntn':'Cantón', 'parr': 'Parroquia', 'clas':'Clase', 'mnto': 'Monto', 'cont': 'Contratista',
                                           'tppz':'Tipo Plazo', 'inic':'Fecha Inicio', 'fin':'Fecha Fin']}" value="${params.buscador}"
                  optionKey="key" optionValue="value" id="buscador_tra" style="width: 150px"/>
    </div>

    <div class="col-md-4 hide" id="divFecha">
        <b>Fecha: </b>
        <input aria-label="" name="fecha_tra" id='fecha_tra' type='text' class="input-small" value="${params.fecha?.format("dd-MM-yyyy")}" />
    </div>
    <div class="col-md-4" id="divCriterio">
        <b>Criterio: </b>
        <g:textField name="criterio" id="criterio_tra" value="${params.criterio}" style="width: 250px;"/>
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

            <th style="width: 7%;">
                N° Contrato
            </th>
            <th style="width: 7%;">
                Fecha Suscripción
            </th>
            <th style="width: 7%;">
                Concurso
            </th>
            <th style="width: 7%;">
                Código Obra
            </th>
            <th style="width: 18%;">
                Nombre de la Obra
            </th>
            <th style="width: 7%;">
                Clase de Obra
            </th>
            <th style="width: 7%;">
                Tipo de Contrato
            </th>
            <th style="width: 7%;">
                Monto
            </th>
            <th style="width: 4%;">
                %
            </th>
            <th style="width: 6%;">
                Anticipo
            </th>
            <th style="width: 8%;">
                Contratista
            </th>
            <th style="width: 7%;">
                Fecha Inicio
            </th>
            <th style="width: 7%;">
                Fecha Fin
            </th>
        </tr>
        </thead>
    </table>
    <div id="detalle">
    </div>
</div>

<script type="text/javascript">

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'reportes', action: 'index')}"
    });

    $("#imprimir").click(function () {
        location.href="${g.createLink(controller: 'reportes4', action:'reporteContratos' )}?buscador=" + $("#buscador_tra").val() + "&criterio=" + $("#criterio_tra").val()
    });

    $("#excel").click(function () {
        location.href="${g.createLink(controller: 'reportesExcel', action:'reporteExcelContratos' )}?buscador=" + $("#buscador_tra").val() + "&criterio=" + $("#criterio_tra").val()
    });

    $("#buscador_tra").change(function () {
        var seleccionado = $(this).val();
        if( ['fcsb','inic','fin'].includes(seleccionado)){
            $("#divFecha").removeClass("hide");
            $("#divCriterio").addClass("hide");
        }else{
            $("#divCriterio").removeClass("hide");
            $("#divFecha").addClass("hide");
            $("#fecha_tra").val('');
        }
    });

    $('#fecha_tra').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var datos = "si=${"si"}&buscador=" + $("#buscador_tra").val() + "&criterio=" + $("#criterio_tra").val() + "&fecha=" + $("#fecha_tra").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaContratos')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    }

    $("#buscar").click(function(){
        cargarTabla();
    })

</script>
</body>
</html>
