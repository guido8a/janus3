<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Copiar Rubros
    </title>
</head>

<body>


<div class="col-md-12">
    <a href="#" class="btn btn-info" id="regresar">
        <i class="fa fa-arrow-left"></i>
        Regresar
    </a>
</div>

<div class="btn-group" style="margin-left: 0px; margin-top: 20px">
    <div class="col-md-6">
        <b>Subpresupuesto de origen:</b>
        <g:select name="subpresupuestoOrg" from="${subPres}" class="form-control" optionKey="${{it.id}}" optionValue="${{it.descripcion}}"
                  noSelection="['' : 'TODOS']"
                  style="width: 300px;font-size: 10px;" id="subPres_desc" />
    </div>
    <div class="col-md-6">
        <b>Subpresupuesto de destino:</b>
        <g:select name="subpresupuestoDes" from="${janus.SubPresupuesto.list([order: 'descipcion'])}" class="form-control" optionKey="${{it.id}}" optionValue="${{it.descripcion}}"
                  style="width: 300px;font-size: 10px;" id="subPres_destino"
                  noSelection="['' : ' - Seleccione un subpresupuesto - ']" />
    </div>
</div>
<div class="col-md-6" style="margin-top: 20px; margin-bottom: 10px">
    <a href="#" class="btn  btn-info" id="copiar_todos">
        <i class="fa fa-list"></i>
        Copiar Todos los Rubros
    </a>
    <a href="#" class="btn  btn-success" id="copiar_sel">
        <i class="fa fa-check"></i>
        Copiar rubros seleccionados
    </a>
</div>

<table class="table table-bordered table-striped table-condensed table-hover" id="tabla" style="margin-top: 10px">
    <thead>
    <tr>
        <th style="width: 5%;">
            *
        </th>
        <th style="width: 5%;">
            #
        </th>
        <th style="width: 20%;">
            Subpresupuesto
        </th>
        <th style="width: 7%;">
            Código
        </th>
        <th style="width: 50px;">
            Rubro
        </th>
        <th style="width: 5%" class="col_unidad">
            Unidad
        </th>
        <th style="width: 8%">
            Cantidad
        </th>
    </tr>
    </thead>
</table>


<div style="width: 99.7%;height: 600px;overflow-y: auto;float: right; margin-top: -20px" id="detalle"></div>

<script type="text/javascript">

    cargarTabla();

    $("#regresar").click(function () {
        location.href = "${g.createLink(controller: 'volumenObra', action: 'volObra', id: obra?.id)}"
    });

    $("#subPres_desc").change(function () {
        cargarTabla();
    });

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var subOrigen = $("#subPres_desc option:selected").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'volumenObra',action:'tablaCopiarRubro')}",
            data     : {
                obra: '${obra?.id}',
                sub: subOrigen
            },
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg)
            }
        });
    }


    $("#copiar_sel").click(function () {
        copiar();
    });


</script>
</body>
</html>