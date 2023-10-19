<%@ page import="janus.ejecucion.ValorIndice" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Valores de Índices</title>
</head>

<body>
<div class="btn-toolbar " style="margin-bottom: 10px">
    <div class="btn-group col-md-12">
        <div class="col-md-2">
            <a href="${g.createLink(action: 'editarIndices')}" class="btn btn-info" title="Regresar">
                <i class="fa fa-arrow-left"></i>
                Editar Valores
            </a>
        </div>

        <div class="col-md-2">
            <g:select id="anio" name="anio" from="${janus.pac.Anio.list([sort: 'anio', order:'desc'])}" optionKey="id" optionValue="anio" class="form-control"  value="${anio}" />
        </div>
        <div class="col-md-2">
            <a id="consultar" href="#" class="btn btn-success" title="Consultar" >
                <i class="fa fa-search"></i>Consultar
            </a>
        </div>
    </div>
</div>

<div>
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 30%">Índice</th>
            <th style="width: 5.8%">Enero</th>
            <th style="width: 5.8%">Febrero</th>
            <th style="width: 5.8%">Marzo</th>
            <th style="width: 5.8%">Abril</th>
            <th style="width: 5.8%">Mayo</th>
            <th style="width: 5.8%">Junio</th>
            <th style="width: 5.8%">Julio</th>
            <th style="width: 5.8%">Agosto</th>
            <th style="width: 5.8%">Septiembre</th>
            <th style="width: 5.8%">Octubre</th>
            <th style="width: 5.8%">Noviembre</th>
            <th style="width: 5.8%">Diciembre</th>
        </thead>
    </table>
</div>


<div id="tablaIndices"></div>


<script type="text/javascript">

    cargarValoresIndices();

    $("#consultar").click(function () {
        cargarValoresIndices()
    });

    function cargarValoresIndices () {
        var v = cargarLoader("Cargando...");
        $.ajax({
            type: 'POST',
            url: "${createLink(controller: 'indice', action: 'tablaValorIndices_ajax')}",
            data:{
                anio: $("#anio option:selected").val()
            },
            success: function (msg){
                v.modal("hide");
                $("#tablaIndices").html(msg)
            }
        })
    }

</script>
</body>
</html>