
<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:if test="${params.buscador != 'undefined'}">
            <g:each in="${res}" var="cont" status="j">
                <tr class="obra_row" id="${cont.id}">
                    <td style="width: 10%;">${cont.ruc}</td>
                    <td style="width: 10%;">${cont.nombre}</td>
                    <td style="width: 10%;">${cont.especialidad}</td>
                    <td style="width: 10%;">${cont.nombrecon + " " + cont.apellidocon} </td>
                    <td style="width: 10%;">${cont.direccion}</td>
                    <td style="width: 10%;">${cont.telefono}</td>
                    <td style="width: 10%;">${cont.garante}</td>
                    <td style="width: 10%;"><g:formatDate date="${cont.fecha}" format="dd-MM-yyyy"/></td>
                    <td style="width: 10%;"><g:formatDate date="${cont.fechacontrato}" format="dd-MM-yyyy"/></td>
                </tr>
            </g:each>
        </g:if>
    </table>
</div>
