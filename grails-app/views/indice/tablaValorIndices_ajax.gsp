<div class="row-fluid"  style="width: 99.7%;height: 500px;overflow-y: auto;float: right; margin-top: -20px">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:each in="${datos}" var="val" status="j">
            <tr class="item_row">
                <td style="width: 29%">${val.indcdscr}</td>
                <td style="width: 5.8%;text-align: right">${val.enero ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.febrero ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.marzo ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.abril ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.mayo ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.junio ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.julio ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.agosto ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.septiembre ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.octubre ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.noviembre ?: ''}</td>
                <td style="width: 5.8%;text-align: right">${val.diciembre ?: ''}</td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>