<%@ page import="utilitarios.reportesService" %>

<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:each in="${data}" var="obra" status="j">
            <tr class="obra_row" >
                <td style="width: 7%;">${obra.cncrcdgo}</td>
                <td style="width: 7%;"><g:formatDate date="${obra.cncrfcad}" format="dd-MM-yyyy"/></td>
                <td style="width: 28%; font-size: 10px">${obra.cncrobjt}</td>
                <td style="width: 26%; font-size: 10px">${obra.obranmbr}</td>
                <td style="width: 10%;">${obra.obracdgo}</td>
                <td style="width: 7%;">${obra.cncrprrf}</td>
                <td style="width: 5%;">${obra.cncretdo}</td>
                <td style="width: 9%;">${obra.cncrnmct}</td>
            </tr>
        </g:each>
    </table>
</div>

