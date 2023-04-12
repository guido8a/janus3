<%@ page import="janus.Grupo" %>

<%
    def reportesServ = grailsApplication.classLoader.loadClass('utilitarios.reportesService').newInstance()
%>

<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Obras Ingresadas
    </title>
    <asset:javascript src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.js"/>
    <asset:stylesheet src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.css"/>
    <style>
    .letra{
        font-size: 10px;
    }
    </style>

</head>

<body>

<div class="row-fluid">
    <div class="span12">
        <a href="#" class="btn btn-primary" id="regresar">
            <i class=" fa fa-arrow-left"></i>
            Regresar
        </a>
        <b>Buscar Por:</b>
        <elm:select name="buscador" from = "${reportesServ.obrasPresupuestadas()}" value="${params.buscador}"
                    optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con" style="width: 200px" />
        <b>Operación:</b>
        <span id="selOpt"></span>
        <b style="margin-left: 20px">Criterio: </b>
        <g:textField name="criterio" style="width: 160px; margin-right: 10px" value="${params.criterio ?: ''}" id="criterio_con"/>
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
                Código
            </th>
            <th style="width: 25%;">
                Nombre
            </th>
            <th style="width: 13%;">
                Tipo
            </th>
            <th style="width: 8%">
                Fecha Reg
            </th>
            <th style="width: 21%">
                Cantón-Parroquia-Comunidad
            </th>
            <th style="width: 9%">
                Valor
            </th>
            <th style="width: 16%">
                Elaborado
            </th>
            <th style="width: 11%">
                Doc.Referencia
            </th>
            <th style="width: 9%">
                Estado
            </th>
            <th style="width: 1%">
            </th>
        </tr>
        </thead>
    </table>
    <div id="detalle">
    </div>
</div>


<script type="text/javascript">

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var datos = "si=${"si"}&buscador=" + $("#buscador_reg1").val() + "&estado=" + $("#estado_reg1").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaRegistradas')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg);
            }
        });
    }

</script>
</body>
</html>

