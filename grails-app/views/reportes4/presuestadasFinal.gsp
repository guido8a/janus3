<%@ page import="janus.Grupo" %>

<%
    def reportesServ = grailsApplication.classLoader.loadClass('utilitarios.reportesService').newInstance()
%>

<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Obras Presupuestadas
    </title>
    <asset:javascript src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.js"/>
    <asset:stylesheet src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.css"/>
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
                    optionKey="campo" optionValue="nombre" optionClass="operador" id="buscador_con" style="width: 240px" />
        <b>Operación:</b>
        <span id="selOpt"></span>
        <b style="margin-left: 20px">Criterio: </b>
        <g:textField name="criterio" style="width: 160px; margin-right: 10px" value="${params.criterio}" id="criterio_con"/>
        <a href="#" class="btn btn-success" id="buscar">
            <i class=" fa fa-search"></i>
            Buscar
        </a>
        <a href="#" class="btn btn-info" id="imprimir" >
            <i class=" fa fa-print"></i>
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
            <th style="width: 80px;">
                Código
            </th>
            <th style="width: 280px;">
                Nombre
            </th>
            <th style="width: 120px;">
                Tipo
            </th>
            <th style="width: 80px">
                Fecha Reg
            </th>
            <th style="width: 270px">
                Cantón-Parroquia-Comunidad
            </th>
            <th style="width: 100px">
                Valor
            </th>
            <th style="width: 200px">
                Elaborado
            </th>
            <th style="width: 70px">
                Doc.Referencia
            </th>
            <th style="width: 80px">
                Estado
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
        var  datos = "si=${"si"}&buscador=" + $("#buscador_reg1").val() + "&estado=" + $("#estado_reg1").val()
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'reportes4',action:'tablaPresupuestadas')}",
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

