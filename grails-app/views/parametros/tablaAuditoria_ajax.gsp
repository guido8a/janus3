<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr style="width: 100%">
        <th style="width: 4%">Id</th>
        <th style="width: 6%">Usuario</th>
        <th style="width: 15%">Anterior</th>
        <th style="width: 18%">Actual</th>
        <th style="width: 10%">Fecha</th>
        <th style="width: 8%">IP</th>
        <th style="width: 6%">Registro</th>
        <th style="width: 15%">Dominio</th>
        <th style="width: 11%">Campo</th>
        <th style="width: 7%">Operación</th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 530px; overflow-y: auto;float: right;">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%; table-layout: fixed;">
        <g:each in="${data}" var="dt" status="i">
            <tr style="width: 100%">
                  <td style="width: 4%">${dt?.audt__id}</td>
                  <td style="width: 6%">${dt?.usrologn}</td>
                  <td style="width: 15%">${dt?.audtantr}</td>
                  <td style="width: 18%">${dt?.audtactl}</td>
                  <td style="width: 10%">${dt?.audtfcha?.format("dd-MM-yyyy HH:mm")}</td>
                  <td style="width: 8%">${dt?.audtdrip}</td>
                  <td style="width: 6%">${dt?.audtrgid}</td>
                  <td style="width: 15%;">${dt?.audtdomn}</td>
                  <td style="width: 11%">${dt?.audtcmpo}</td>
                  <td style="width: 7%">${dt?.audtoprc}</td>
            </tr>
        </g:each>
    </table>
</div>

