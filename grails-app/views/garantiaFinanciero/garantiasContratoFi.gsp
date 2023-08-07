<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Garantías def contrato: ${contrato?.codigo ?: ''}</title>

    <style type="text/css">
    .selected, .selected td {
        background : #B8D5DD !important;
    }

    .Renovada {
        background : #e5e5e5;
    }

    .Vigente {

    }

    .error {
        color : #aa1b17;
    }
    </style>

</head>

<body>

<div class="col-md-9 btn-group">
    <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-info btn-new" title="Regresar al contrato">
        <i class="fa fa-arrow-left"></i>
        Contrato
    </g:link>
</div>

<div style="border-bottom: 1px solid black;padding-left: 50px;margin-top: 50px;position: relative; min-height: 185px;">
    <p class="css-vertical-text">Contrato</p>

    <div class="linea" style="height: 150px;"></div>

    <div class="col-md-12" style="margin-top: 5px">

        <div class="col-md-2">
            N. contrato
            <span class="uneditable-input">${contrato?.codigo}</span>
        </div>

        <div class="col-md-2">
            Suscripción
            <span class="uneditable-input">${contrato?.fechaSubscripcion?.format("dd-MM-yyyy")}</span>
        </div>

        <div class="col-md-2">
            Tipo Contrato
            <span class="uneditable-input">${contrato?.tipoContrato?.descripcion}</span>
        </div>

        <div class="col-md-2">
            Monto
            <span class="uneditable-input">${contrato?.monto}</span>
        </div>

        <div class="col-md-2">
            Fecha Inicio
            <span class="uneditable-input">${contrato?.fechaInicio}</span>
        </div>
        <div class="col-md-2">
            Fecha Fin
            <span class="uneditable-input">${contrato?.fechaFin}</span>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 5px">
        <div class="col-md-12" >
            Proyecto
            <span class="uneditable-input" style="font-size: 10px" title="${contrato?.oferta?.concurso?.obra?.descripcion}">${contrato?.oferta?.concurso?.obra?.descripcion}</span>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 5px">
        <div class="col-md-3">
            Contratista
            <span class="uneditable-input">${contrato?.oferta?.proveedor?.nombre}</span>
        </div>

        <div class="col-md-3">
            Memo Distrib.
            <span class="uneditable-input">${contrato?.memo}</span>
        </div>

    </div>
</div> <!-- Contrato -->

<div style="margin-top: 10px">
%{--<div style="border-bottom: 1px solid black;padding-left: 50px;margin-top: 10px;position: relative; min-height: 150px;">--}%
%{--    <p class="css-vertical-text">Garantías</p>--}%

%{--    <div class="linea" style="height: 100px;"></div>--}%

    <table class="table table-bordered table-condensed table-hover table-stripped">
        <thead>
        <tr>
            <th style="width: 8%">N. Garantía</th>
            <th style="width: 20%">Concepto</th>
            <th style="width: 21%">Emisor</th>
            <th style="width: 11%">Tipo</th>
            <th style="width: 7%">Estado</th>
            <th style="width: 7%">Fecha</th>
            <th style="width: 7%">Fecha inicio</th>
            <th style="width: 7%">Fecha fin</th>
            <th style="width: 7%">Monto</th>
        </tr>
        </thead>
    </table>

    <div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
            <g:each in="${garantias}" var="garantia" status="i">
                <tr>
                    <td style="width: 8%">${garantia.numeroGarantia}</td>
                    <td style="width: 20%">${garantia.conceptoGarantia}</td>
                    <td style="width: 21%">${garantia.emisor}</td>
                    <td style="width: 11%">${garantia.tipoGarantia}</td>
                    <td style="width: 7%">${garantia.estado}</td>
                    <td style="width: 7%">${garantia.fechaGarantia?.format("dd-MM-yyyy")}</td>
                    <td style="width: 7%">${garantia.desde?.format("dd-MM-yyyy")}</td>
                    <td style="width: 7%">${garantia.hasta?.format("dd-MM-yyyy")}</td>
                    <td style="width: 7%; text-align: right">${garantia.monto}</td>
                </tr>
            </g:each>
        </table>
    </div>


</div> <!-- garantias -->

<script type="text/javascript">
</script>

</body>
</html>