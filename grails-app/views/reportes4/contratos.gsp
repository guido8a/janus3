
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


<div class="row-fluid">
    <div class="span12">
        <a href="#" class="btn btn-primary" id="regresar">
            <i class=" fa fa-arrow-left"></i>
            Regresar
        </a>

        <b>Buscar Por: </b>
        <g:select name="buscador" from="${['cdgo':'N° Contrato', 'memo': 'Memo', 'fcsb': 'Fecha Suscrip', 'tipo': 'Tipo Contrato', 'cncr': 'Concurso',
                                           'obra':'Obra', 'nmbr': 'Nombre', 'cntn':'Cantón', 'parr': 'Parroquia', 'clas':'Clase', 'mnto': 'Monto', 'cont': 'Contratista',
                                           'tppz':'Tipo Plazo', 'inic':'Fecha Inicio', 'fin':'Fecha Fin']}" value="${params.buscador}"
                  optionKey="key" optionValue="value" id="buscador_tra" style="width: 150px"/>
        <b>Fecha: </b>

        <g:set var="fechas" value="${['fcsb','inic','fin']}" />

        <g:if test="${fechas.contains(params.buscador)}">
            <elm:datepicker name="fecha" id="fecha_tra" value="${params.fecha}"/>
            <b>Criterio: </b>
            <g:textField name="criterio" id="criterio_tra" readonly="readonly" style="width: 250px; margin-right: 10px" value="${params.criterio}"/>
        </g:if>
        <g:else>

            <elm:datepicker name="fecha" id="fecha_tra" disabled="disabled" value="${params.fecha}"/>
            <b>Criterio: </b>
            <g:textField name="criterio" id="criterio_tra" style="width: 250px; margin-right: 10px" value="${params.criterio}"/>

        </g:else>
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


<div style="width: 99.7%;height: 600px;overflow-y: auto;float: right;" id="detalle"></div>


<script type="text/javascript">

    cargarTabla();

    function cargarTabla() {
        var datos = "si=${"si"}&buscador=" + $("#buscador_tra").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaContratos')}",
            data     : datos,
            success  : function (msg) {
                $("#detalle").html(msg)
            }
        });
    }

</script>
</body>
</html>

