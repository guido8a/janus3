
<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Contratistas
    </title>
</head>

<body>

<div class="row-fluid">
    <div class="span12">
        <a href="#" class="btn btn-primary" id="regresar">
            <i class=" fa fa-arrow-left"></i>
            Regresar
        </a>

        <b>Buscar Por: </b>
        <g:select name="buscador" from="${['nmbr':'Nombre', '_ruc': 'Cédula', 'espe': 'Especialidad',]}" value="${params.buscador}"
                  optionKey="key" optionValue="value" id="buscador_cont" style="width: 150px"/>
        <b>Criterio: </b>
        <g:textField name="criterio" id="criterio_cont" style="width: 250px; margin-right: 10px" value="${params.criterio}"/>
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
            <th style="width: 10%;">
                Cédula/RUC
            </th>
            <th style="width: 10%;">
                Nombre
            </th>
            <th style="width: 10%;">
                Especialidad
            </th>
            <th style="width: 10%;">
                Contacto
            </th>
            <th style="width: 10%;">
                Dirección
            </th>
            <th style="width: 10%;">
                Teléfono
            </th>
            <th style="width: 10%;">
                Garante
            </th>
            <th style="width: 10%;">
                Fecha Cont.
            </th>
            <th style="width: 10%;">
                Fecha Contrato.
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
        location.href="${g.createLink(controller: 'reportes4', action:'reporteContratistas' )}?buscador=" + $("#buscador_cont").val() + "&criterio=" + $("#criterio_cont").val()
    });

    $("#excel").click(function () {
        location.href="${g.createLink(controller: 'reportesExcel', action:'reporteExcelContratistas' )}?buscador=" + $("#buscador_cont").val() + "&criterio=" + $("#criterio_cont").val()
    });

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var datos = "si=${"si"}&buscador=" + $("#buscador_cont").val() + "&criterio=" + $("#criterio_cont").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaContratistas')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    }

    $("#buscar").click(function(){
        cargarTabla();
    });

</script>
</body>
</html>

