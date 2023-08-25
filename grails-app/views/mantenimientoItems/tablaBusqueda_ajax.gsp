<%@ page import="janus.Departamento" %>
<div class="container-fluid">
    <table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
        <thead>
        <tr>
            <th style="width: 30%">Subgrupo</th>
            <th style="width: 30%">Departamento </th>
            <th style="width: 40%">Item</th>
        </tr>
        </thead>
    </table>

    <div class="" style="width: 99.7%; height: 400px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-condensed table-hover " style="width: 100%; table-layout:fixed">
            <tbody>
            <g:each in="${res}" status="j" var="item">
                <tr>
                    <td style="width: 30% ">${janus.DepartamentoItem.get(item.dprt__id)?.subgrupo?.codigo + " - " + janus.DepartamentoItem.get(item.dprt__id)?.subgrupo?.descripcion}</td>
                    <td style="width: 30% ">${janus.DepartamentoItem.get(item.dprt__id)?.codigo + " - "+ janus.DepartamentoItem.get(item.dprt__id)?.descripcion}</td>
                    <td style="width: 40% ">${item.itemnmbr}</td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</div>