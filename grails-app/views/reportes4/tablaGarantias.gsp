<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:each in="${res}" var="cont" status="j">
            <tr class="obra_row" id="${cont.id}">
                <td style="width: 9%;">${cont.codigocontrato}</td>
                <td style="width: 6%;">${cont.codigo}</td>
                <td style="width: 12%;">${cont.tipogarantia}</td>
                <td style="width: 7%;">${cont.documento} </td>
                <td style="width: 20%;">${cont.aseguradora}</td>
                <td style="width: 17%;">${cont.contratista}</td>
                <td style="width: 7%;">${cont.monto}</td>
                <td style="width: 8%;"><g:formatDate date="${cont.emision}" format="dd-MM-yyyy"/></td>
                <td style="width: 8%;"><g:formatDate date="${cont.vencimiento}" format="dd-MM-yyyy"/></td>
                <td style="width: 5%;">${cont.dias}</td>
            </tr>
        </g:each>
    </table>
</div>

