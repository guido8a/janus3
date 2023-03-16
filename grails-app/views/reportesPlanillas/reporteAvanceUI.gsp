
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Informe de avance</title>

    <style type="text/css">
    .tabla {
        border-collapse : collapse;
    }

    .tabla td {
        vertical-align : middle;
        padding        : 9px 9px 0 9px;
    }
    </style>
</head>

<body>

<g:if test="${flash.message}">
    <div class="row">
        <div class="span12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </div>
</g:if>
<div class="row">
    <div class="span9 btn-group" role="navigation">
        <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-info" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
        <g:if test="${planillaObras.size() > 0}">
            <span style="margin-left: 20px">
                <a href="#" id="btnAdicionales" class="btn btn-info"><i class='icon icon-print'></i> Imprimir informe de Obras Adicionales</a>
            </span>
        </g:if>
    </div>
</div>

<fieldset>
    <legend>
        Planillas de Avance de Obra
        <g:select name="plnl" from="${planillas}" optionKey="id" style="width: 600px;"/>
        <a href="#" id="btnVer" class="btn btn-info" style="margin-bottom:9px;" ><i class="fa fa-search"></i>
            Ver informe
        </a>
    </legend>
</fieldset>

<fieldset class="hide" id="fsTextos">
    <div id="divTextos"></div>
</fieldset>

<script type="text/javascript">
    $(function () {

        $("#btnAdicionales").click(function () {
            location.href = "${createLink(action:'reporteObrasAdicionales', id:contrato.id, params:[contrato: contrato.id])}";
            return false;
        });

        $("#btnVer").click(function () {
            $.ajax({
                type: 'POST',
                url: "${createLink(controller: 'reportesPlanillas', action: 'tablaAvance')}",
                data:{
                    id: '${contrato?.id}',
                    plnl : $("#plnl").val()
                },
                success: function (msg) {
                    $("#divTextos").html(msg);
                    $("#fsTextos").removeClass('hide');
                }
            })

        });
    });
</script>

</body>
</html>