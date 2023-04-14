
<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:if test="${params.buscador != 'undefined'}">
            <g:each in="${res}" var="cont" status="j">
                <tr class="obra_row" id="${cont.id}">
                    <td style="width: 7%;">${cont.codigo}</td>
                    <td style="width: 7%;"><g:formatDate date="${cont.fechasu}" format="dd-MM-yyyy"/></td>
                    <td style="width: 7%;">${cont.concurso}</td>
                    <td style="width: 7%;">${cont.obracodigo}</td>
                    <td style="width: 18%; font-size: 10px">${cont.obranombre} </td>
                    <td style="width: 8%; font-size: 10px" >${cont.tipoobra}</td>
                    <td style="width: 8%; font-size: 10px">${cont.tipocontrato}</td>
                    <td style="width: 8%;">${cont.monto}</td>
                    <td style="width: 4%;">${cont.porcentaje}</td>
                    <td style="width: 6%;">${cont.anticipo}</td>
                    <td style="width: 8%; font-size: 10px" >${cont.nombrecontra}</td>
                    <td style="width: 7%;"><g:formatDate date="${cont.fechainicio}" format="dd-MM-yyyy"/></td>
                    <td style="width: 8%;"><g:formatDate date="${cont.fechafin}" format="dd-MM-yyyy"/></td>
                </tr>
            </g:each>
        </g:if>
    </table>
</div>