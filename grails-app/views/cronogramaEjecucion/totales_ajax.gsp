<table class="table table-bordered table-condensed table-hover table-striped">
    <tbody>
    <tr class="pie">
        <td class="valor" style="text-align: right; font-weight: bold; width: 600px">TOTAL PARCIAL</td>
        <td class="valor" style="text-align: right; font-weight: bold; width: 80px">${suma}</td>
        <g:each in="${totales}" var="tot" status="i">
            <td class="totales" style="width: 110px">${raw(tot)}</td>
        </g:each>
        <td style="width: 120px"></td>
    </tr>
    <tr class="pie2">
        <td class="valor" colspan="1" style="text-align: right; font-weight: bold">TOTAL ACUMULADO</td>
        <td style="width: 50px"></td>
        <g:each in="${total_ac}" var="tot" status="i">
            <td class="totales">${raw(tot)}</td>
        </g:each>
        <td style="width: 120px"></td>
    </tr>
    <tr class="pie">
        <td class="valor" colspan="1" style="text-align: right; font-weight: bold">% TOTAL PARCIAL</td>
        <td colspan="1"></td>
        <g:each in="${ttpc}" var="tot" status="i">
            <td class="totales">${raw(tot)}</td>
        </g:each>
        <td style="width: 120px"></td>
    </tr>
    <tr class="pie2">
        <td class="valor" colspan="1" style="text-align: right; font-weight: bold">% TOTAL ACUMULADO</td>
        <td colspan="1"></td>
        <g:each in="${ttpa}" var="tot" status="i">
            <td class="totales">${raw(tot)}</td>
        </g:each>
        <td style="width: 120px"></td>
    </tr>
    </tbody>
</table>