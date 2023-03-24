<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Planillas y Pagos</title>
</head>
<body>
<div class="row">
    <div class="col-md-12">
        <h1>
            Planillas y Pagos
        </h1>
    </div>
    <div class=" col-md-12 alert alert-info" style="font-size: 16px;">
        Detalle de planillas odenado por fecha de ingreso.
    </div>
</div>
<div class="row" style="margin-top:15px">
    <div class="col-md-12">
        <table class="table table-hover table-bordered table-striped">
            <thead>
            <tr>
                <th style="width: 10%;">Contrato</th>
                <th style="width: 22%;">Contratista</th>
                <th style="width: 12%;">Tipo</th>
                <th style="width: 8%;">Ingreso</th>
                <th style="width: 8%;">Presentación</th>
                <th style="width: 10%;">Valor</th>
                <th style="width: 10%;">Memorando<br/> pedido de pago</th>
                <th style="width: 10%;">Fecha <br/>Mem. pedido</th>
                <th style="width: 10%;">Fecha de acreditación</th>
            </tr>
            </thead>

        </table>
    </div>
</div>

<div class="row-fluid"  style="width: 99.7%;height: 500px;overflow-y: auto;float: right; margin-top: -20px">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:each in="${planillas}" var="p" status="i">
            <tr>
                <td style="width: 10%;">${p.contrato?.codigo}</td>
                <td style="width: 22%;">${p.contrato?.oferta?.proveedor?.nombre}</td>
                <td style="width: 12%;">${p.tipoPlanilla?.nombre}</td>
                <td style="width: 8%;">${p.fechaIngreso?.format("dd-MM-yyyy")}</td>
                <td style="width: 8%;">${p.fechaPresentacion?.format("dd-MM-yyyy")}</td>
                <td style="width: 10%;">
                    <g:formatNumber number="${p.valor}" type="currency"/>
                </td>
                <td style="width: 10%;">${p.memoPedidoPagoPlanilla}</td>
                <td style="width: 10%; text-align: center">${p.fechaMemoPedidoPagoPlanilla?.format("dd-MM-yyyy")}</td>
                <td style="width: 10%; text-align: center">${p.fechaPago?.format("dd-MM-yyyy")}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>


</body>
</html>