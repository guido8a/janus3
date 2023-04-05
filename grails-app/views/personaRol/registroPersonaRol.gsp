
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Registro Rol</title>
</head>

<body>

<div class="col-md-12 btn-group" style="margin-bottom: 10px">
    <button class="btn btnRegresar btn-info" id="regresar"><i class="fa fa-arrow-left"></i> Regresar</button>
</div>

<div class="col-md-12">
    <div class="col-md-6" style="font-weight: bold">Dirección:
    <g:select name="departamento" class="departamento form-control" from="${janus.Direccion.list([sort: 'nombre'])}" optionValue="nombre"
              optionKey="id"  noSelection="['-1': 'Seleccione la dirección...']"/>
    </div>

    <div class="col-md-3" id="filaPersonas"></div>
</div>

<div class="col-md-12">
    <div class="col-md-3" id="funcionDiv" style="margin-top: 10px;">
        <div class="span2" style="margin-left: -1px; font-weight: bold">Nueva Función:</div>
        <g:select name="funcion" from="${funciones}" optionValue="descripcion" optionKey="id" class="form-control"/>
    </div>
    <div class="col-md-1" style="margin-top: 26px;">
        <button class="btn btnAdicionar btn-success" id="adicionar"><i class="fa fa-plus"></i> Adicionar</button>
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

<script type="text/javascript">

    $("#adicionar").click(function () {

        var idPersona = $(".persona").val();
        var idAcicionar = $("#funcion option:selected").val();

            $.ajax({
                type: "POST",
                url: "${g.createLink(controller: "personaRol", action: 'grabarFuncion')}",
                data: {
                    id: idPersona,
                    rol: idAcicionar
                },
                success: function (msg) {
                    var parts = msg.split("_");
                    if(parts[0] === 'OK'){
                        log(parts[1],"success");
                        cargarFuncion();
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    }
                }
            });
    });

    $("#regresar").click(function () {
        location.href = "${createLink(controller: 'persona', action: 'list')}";
    });

    function loadPersonas(idDep) {
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'personaRol', action:'getPersonas')}",
            data: {
                id: idDep
            },
            success: function (msg) {
                $("#filaPersonas").html(msg);
            }
        });
    }

    $("#departamento").change(function () {
        var valor = $(this).val();
        if (valor !== -1) {
            loadPersonas(valor);
        }
    });
</script>
</body>
</html>