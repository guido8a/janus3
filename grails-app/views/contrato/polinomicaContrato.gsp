<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">
    <style type="text/css">

    .formato {
        font-weight : bolder;
    }

    </style>

    <title>Formula Polinómica</title>
</head>

<body>

<div class="col-md-12" style="margin-bottom: 10px;">
    <div class="col-md-8 btn-group" role="navigation">
        <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-info btn-new" title="Regresar al contrato" style="margin-bottom: 10px">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>

        <div class="col-md-6">
            <g:select name="listaFormulas" id="existentes" from="${formulas}" optionValue="descripcion" optionKey="id"
                      style="margin-right: 1px" class="form-control"/>
        </div>

    </div>
</div>

<div style="min-height: 50px; margin-bottom: 10px">
    Contrato: <span style="font-size: 14px; font-weight: bold"> ${contrato.objeto} </span>
</div>

<div id="divTablaFP">
</div>

<script type="text/javascript">


    function cargarTabla(id) {
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'contrato',action:'tablaFormula_ajax')}",
            data: {
                id: id,
                cntr: ${contrato.id},
                editar: 'no'
            },
            success: function (msg) {
                $("#divTablaFP").html(msg);
            }
        });
    }

    $("#existentes").change(function () {
        var idFormula = $(this).val();
        cargarTabla(idFormula);
    });

    cargarTabla($("#existentes").val());



</script>
</body>
</html>