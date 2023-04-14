<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:if test="${params.buscador != 'undefined'}">
            <g:each in="${res}" var="aseg" status="j">
                <tr class="obra_row" id="${aseg.id}">
                    <td style="width: 30%;">${aseg.nombre}</td>
                    <td style="width: 8%;">${aseg.tipoaseguradora}</td>
                    <td style="width: 8%;">${aseg.telefono}</td>
                    <td style="width: 16%;">${aseg.direccion}</td>
                    <td style="width: 10%;">${aseg.observaciones}</td>
                    <td style="width: 10%;">${aseg.contacto}</td>
                    <td style="width: 8%;"><g:formatDate date="${aseg.fecha}" format="dd-MM-yyyy"/></td>
                </tr>
            </g:each>
        </g:if>
    </table>
</div>