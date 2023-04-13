<div class="" style="width: 99.7%;height: 600px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-striped table-hover" style="width: 100%">
        <g:each in="${obras}" var="obra" status="j">
            <tr class="obra_row">
                <td style="width: 10%;">${obra.obracdgo}</td>
                <td style="width: 21%;font-size: 10px ">${obra.obranmbr}</td>
                <td style="width: 13%;">${obra.tpobdscr}</td>
                <td style="width: 8%;"><g:formatDate date="${obra.obrafcha}" format="dd-MM-yyyy"/></td>
                <td style="width: 15%;font-size: 10px">${obra.cntnnmbr} - ${obra.parrnmbr} - ${obra.cmndnmbr}</td>
                <td style="width: 9%; text-align: right">${obra.cntrmnto}</td>
                <td style="width: 11%;">${obra.dptodscr}</td>
                <td style="width: 11%;">${obra.cntrcdgo}</td>
            </tr>
        </g:each>
    </table>
</div>
