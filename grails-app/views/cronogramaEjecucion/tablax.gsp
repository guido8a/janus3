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
        color: #0c4c85;
    }
    .numero {
        width: 80px;
        text-align: right;
    }
    </style>


</head>
<table class="table table-bordered table-condensed table-hover">
    <thead>
    <tr>
        <th rowspan="2" style="width:70px;">Código</th>
        <th rowspan="2" style="width:420px;">Rubro</th>
        <th rowspan="2" style="width:26px;">*</th>
        <th rowspan="2" style="width:60px;">Cantidad Unitario Total</th>
        <th rowspan="2" style="width:12px;">T.</th>
        <g:each in="${titulo1}" var="t">
            <th>${t}</th>
        </g:each>
        <th rowspan="2">Total rubro</th>
    </tr>
    <tr>
        <g:each in="${titulo2}" var="t">
            <th>${t}</th>
        </g:each>
    </tr>
    </thead>

    <tbody>
        <g:each in="${rubros}" var="rubro">

            <tr class="click item_row   rowSelected" data-vol="2773">
                <g:each in="${rubro}" var="val" status="i">
                    <g:if test="${i<5}">
                        <td class="valor">${raw(val)}</td>
                    </g:if>
                    <g:else>
                        <td class="numero">${raw(val)}</td>
                    </g:else>
                </g:each>
            </tr>
        </g:each>


    </tbody>
</table>
</html>