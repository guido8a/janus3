
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Asignar Director</title>
</head>

<body>

<div class="col-md-12 btn-group" style="margin-bottom: 10px">
    <button class="btn btnRegresar btn-info" ><i class="fa fa-arrow-left"></i> Regresar</button>
</div>

<div class="col-md-12">
    <div class="col-md-6" style="font-weight: bold">Dirección:
    <g:select name="direccion" class="departamento form-control" from="${janus.Direccion.list([sort: 'nombre'])}" optionValue="nombre"
              optionKey="id"  noSelection="['-1': 'Seleccione la dirección...']"/>
    </div>

    <div class="col-md-3" id="personasSel"></div>
</div>

<div class="col-md-12">
    <div class="col-md-3" id="funcionDiv" style="margin-top: 10px;">
        <div class="span2" style="margin-left: -1px; font-weight: bold">Asignar Función:</div>
        <g:select name="funcion" from="${janus.Funcion?.findAllByCodigo('D')}" optionValue="descripcion" optionKey="id" class="form-control"/>
    </div>
    <div class="col-md-1" style="margin-top: 26px;">
        <button class="btn btn-success" id="btnAdicionar"><i class="fa fa-plus"></i> Asignar</button>
    </div>
</div>

<div class="col-md-6" style="margin-top: 20px">
    <table class="table table-bordered table-striped table-hover table-condensed " id="tablaFuncion">
        <thead>
        <tr>
            <th style="width: 50px">N°</th>
            <th style="width: 250px">Función</th>
            <th style="width: 20px"><i class="fa fa-trash"></i></th>
        </tr>
        </thead>

        <tbody id="funcionPersona">

        </tbody>
    </table>
</div>


<div class="span6">
    <div class="span12" id="directorSel"></div>
    <div class="span12" id="confirmacion"></div>
</div>


<script type="text/javascript">

    $("#btnAdicionar").click(function () {
        var idDireccion = $("#direccion option:selected").val();
        var idPersona = $(".persona option:selected").val();

        $.ajax({
            type: 'POST',
            url: "${createLink(controller: "asignarDirector", action: 'grabarFuncion')}",
            data:{
                id: idPersona,
                direccion: idDireccion
            },
            success: function(msg){
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cargarFuncion();
                    cargarMensaje();
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                }
            }
        })
    });

    $(".btnRegresar").click(function () {
        location.href = "${createLink(controller: 'persona', action: 'list')}";
    });

    function cargarPersonas() {
        var idDep = $("#direccion").val();
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'asignarDirector', action:'getSeleccionados')}",
            data: {
                id: idDep
            },
            success: function (msg) {
                $("#personasSel").html(msg);
            }
        });
    }

    function cargarMensaje () {
        var idDep = $("#direccion").val();
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'asignarDirector', action:'mensaje')}",
            data: {
                id: idDep
            },
            success: function (msg) {
                $("#confirmacion").html(msg);
            }
        });
    }

    $("#direccion").change(function () {
        var valor = $(this).val();
        if (valor !== -1) {
            cargarPersonas();
        }
    });

</script>

</body>
</html>