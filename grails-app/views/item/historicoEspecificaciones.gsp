
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Histórico de especificaciones del rubro</title>

</head>

<body>

<div class="col-md-12">
    <fieldset class="borde" style="border-radius: 4px; margin-bottom: 10px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <span class="col-md-1">
                    <label class="control-label text-info">Nombre del Rubro</label>
                </span>
                <span class="col-md-5">
                    <g:textField name="criterio" id="criterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-2">
                <button class="btn btn-info" id="btnBuscar"><i class="fa fa-search"></i></button>
                <button class="btn btn-warning" id="btnLimpiar" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaHistorico" >
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    $("#btnLimpiar").click(function () {
        $("#criterio").val('');
        cargarTabla();
    });

    $("#btnBuscar").click(function () {
        cargarTabla();
    });

    cargarTabla();

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var criterio = $("#criterio").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'item',action:'tablaHistorico_ajax')}",
            data     : {
                criterio:criterio
            },
            success  : function (msg) {
                $("#divTablaHistorico").html(msg);
                d.modal("hide");
            }
        });
    }

    $("#criterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            cargarTabla();
            return false;
        }
        return true;
    });

</script>

</body>
</html>