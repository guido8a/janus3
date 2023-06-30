<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="mainMatriz">


    %{--<link href="${resource(dir: 'js/jquery/plugins/box/css', file: 'jquery.luz.box.css')}" rel="stylesheet">--}%
    %{--<script src="${resource(dir: 'js/jquery/plugins/box/js', file: 'jquery.luz.box.js')}"></script>--}%

    %{--<script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>--}%
    %{--<script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'custom-methods.js')}"></script>--}%
    %{--<script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>--}%

    %{--<script src="${resource(dir: 'js/jquery/i18n', file: 'jquery.ui.datepicker-es.js')}"></script>--}%

    %{--<link href="${resource(dir: 'css', file: 'cronograma.css')}" rel="stylesheet">--}%
    <title>Cronograma ejecución</title>

    <style type="text/css">
    .valor {
        color: #093760;
    }
    .valor2 {
        color: #093760;
        text-align: right;
        font-weight: bold;
        /*background-color: #d8dddf;*/
    }
    .suspension {
        background-color: #ffffff !important;
        color: #444 !important;
        font-weight: normal !important;
    }
    .numero {
        width: 80px;
        text-align: right;
    }
    .totales {
        width: 80px;
        text-align: right;
        font-weight: bold;
    }
    .pie {
        background-color: #ddd;
    }
    .pie2 {
        background-color: #f0f0f0;
    }
    </style>


</head>
<table class="table table-bordered table-condensed table-hover">
    <thead>
    <tr>
        <th rowspan="2" style="width:70px;">Código</th>
        <th rowspan="2" style="width:220px;">Rubro</th>
        <th rowspan="2" style="width:26px;">*</th>
        <th rowspan="2" style="width:60px;">Cantidad Unitario Total</th>
        <th rowspan="2" style="width:12px;">T.</th>
        <g:each in="${titulo1}" var="t">
            <th class="${t[1] == 'S' ? 'suspension' : ''}">${t[0]}</th>
        </g:each>
        <th rowspan="2">Total rubro</th>
    </tr>
    <tr>
        <g:each in="${titulo2}" var="t">
            <th class="${t[1] == 'S' ? 'suspension' : ''}">${raw(t[0])}</th>
        </g:each>
    </tr>
    </thead>

    <tbody>
        <g:each in="${rubros}" var="rubro">
            <tr class="click item_row   rowSelected" data-vol="${rubro[1]}" data-vocr="${rubro[0]}">
                <g:each in="${rubro}" var="val" status="i">
                    <g:if test="${i > 0}">
                    <g:if test="${i == 3}">
                        <td class="valor2">${raw(val)}</td>
                    </g:if>
                    <g:else>
                    <g:if test="${i<5}">
                        <td class="valor">${raw(val)}</td>
                    </g:if>
                    <g:else>
                        <td class="numero">${raw(val)}</td>
                    </g:else>
                    </g:else>
                    </g:if>
                </g:each>
            </tr>
        </g:each>

        <tr class="pie">
            <td class="valor" colspan="3" style="text-align: right; font-weight: bold">TOTAL PARCIAL</td>
            <td class="valor" colspan="2" style="text-align: right; font-weight: bold">${suma}</td>
            <g:each in="${totales}" var="tot" status="i">
                <td class="totales">${raw(tot)}</td>
            </g:each>
        </tr>
        <tr class="pie2">
            <td class="valor" colspan="3" style="text-align: right; font-weight: bold">TOTAL ACUMULADO</td>
            <td colspan="2"></td>
            <g:each in="${total_ac}" var="tot" status="i">
                <td class="totales">${raw(tot)}</td>
            </g:each>
        </tr>
        <tr class="pie">
            <td class="valor" colspan="3" style="text-align: right; font-weight: bold">% TOTAL PARCIAL</td>
            <td colspan="2"></td>
            <g:each in="${ttpc}" var="tot" status="i">
                <td class="totales">${raw(tot)}</td>
            </g:each>
        </tr>
        <tr class="pie2">
            <td class="valor" colspan="3" style="text-align: right; font-weight: bold">% TOTAL ACUMULADO</td>
            <td colspan="2"></td>
            <g:each in="${ttpa}" var="tot" status="i">
                <td class="totales">${raw(tot)}</td>
            </g:each>
        </tr>

    </tbody>
</table>
</html>