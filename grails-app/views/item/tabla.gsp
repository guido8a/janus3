<html>

<head>

    <style type="text/css">
    .alineacion {
        text-align : right !important
    }

    </style>

</head>

<body>

<div id="tabla">

    <table class="table table-bordered table-striped table-hover table-condensed" id="tablaPrecios">
        <thead style="background-color:#0074cc;">
        <tr>
            <th>Item</th>
            <th>Nombre del Item</th>
            <th>U</th>
            <th style="width:120px;">Precio</th>
            <th style="width:80px;">Copiar</th>
            <th class=" precioAL hidden">Precio Anterior</th>
            <th>Fecha</th>
        </tr>
        </thead>
        <tbody>

        <g:each in="${rubroPrecio}" var="rubro" status="i">
            <tr align="right">
                <td class="itemId" align="center" style="width: 150px;">
                    ${rubro?.item?.codigo} ${rubro?.id}
                </td>
                <td class="itemNombre" align="center">
                    ${rubro?.item?.nombre}
                </td>
                <td class="unidad" align="center" style="width: 150px">
                    ${rubro?.item?.unidad?.descripcion}
                </td>
                <td class="editable alineacion" id="${rubro?.id}"
                    data-original="${rubro?.precioUnitario}" data-valor="${rubro?.precioUnitario}"
                    style="width:150px"><g:formatNumber number="${rubro?.precioUnitario}" minFractionDigits="5" maxFractionDigits="5" format="##,#####0" locale="ec"/>
                </td>
                <td style="text-align: center;" class="chk">
                    <input type="checkbox"/>
                </td>
                <td class="precioAnterior hidden" align="center" style="width: 105px">
                    0.00
                </td>
                <td class="fecha" align="center" style="width: 150px">
                    <g:formatDate date="${rubro?.fecha}" format="dd-MM-yyyy"/>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

    <strong>Total de registros visualizados: ${params.totalRows}<br/></strong>

    %{--MAX: ${params.max}<br/>--}%
    %{--OFFSET: ${params.offset}<br/>--}%
    %{--PAG: ${params.pag}<br/>--}%
    %{--TOTAL ROWS: ${params.totalRows}<br/>--}%
    %{--TOTAL PAGS: ${params.totalPags}<br/>--}%
    %{--1st PAG: ${params.first}<br/>--}%
    %{--LAST: ${params.last}<br/>--}%
    %{--tipo: ${params.tipo}--}%

    <div>

        <g:if test="${params.totalPags == 0}">
            <div class="alert alert-error">
                <h4 style="margin-left: 450px">No existen datos!!</h4>
                <div style="margin-left: 420px">
                    Ingrese los parámetros de búsqueda!
                </div>
            </div>
        </g:if>

        <g:else>
            <div style="margin-bottom: 40px; text-align: center">
                <div style="font-weight: bold">
                    Página: ${params.pag} de <g:formatNumber number="${params.totalPags}" minFractionDigits="0"/>
                </div>

                <ul class="pagination">
                    <li class="${params.pag == 1 ? 'disabled' : ''}">
                        <a href="${1}" class="num ">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                    </li>
                    <g:if test="${params.pag - params.first > 0}">
                        <li class="">
                            <a href="${params.pag - 1}" class="num">
                                <i class="fas fa-angle-left"></i>
                            </a>
                        </li>
                    </g:if>
                    <g:else>
                        <li class="disabled">
                            <a href="#">
                                <i class="fas fa-angle-left"></i>
                            </a>
                        </li>
                    </g:else>
                    <g:if test="${params.first > 1}">
                        <li class="disabled puntos">
                            <a href="#">...</a>
                        </li>
                    </g:if>

                    <g:each in="${0..params.last - params.first}" var="p">
                        <li class="${params.first + p == params.pag ? 'active' : ''}">
                            <a href="${params.first + p}" class="num">${params.first + p}</a>
                        </li>
                    </g:each>

                    <g:if test="${params.last < params.totalPags}">
                        <li class="disabled puntos">
                            <a href="#">...</a>
                        </li>
                    </g:if>
                    <g:if test="${params.last - params.pag > 0}">
                        <li class="">
                            <a href="${params.pag + 1}" class="num">
                                <i class="fas fa-angle-right"></i>
                            </a>
                        </li>
                    </g:if>
                    <g:else>
                        <li class="disabled">
                            <a href="#">
                                <i class="fas fa-angle-right"></i>
                            </a>
                        </li>
                    </g:else>
                    <li class="${params.pag == params.totalPags ? 'disabled' : ''}">
                        <a href="${params.totalPags}" class="num">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </li>
                </ul>
            </div>
        </g:else>
    </div>

    <asset:javascript src="/apli/tableHandler.js"/>

    <script type="text/javascript">

        function enviar(pag) {

            var reg = "RN";

            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'tabla')}",
                data    : {
                    lgar  : "${params.lgar}",
                    fecha : "${params.fecha}",
                    todos : "${params.todos}",
                    tipo  : "${params.tipo}",
                    reg   : reg,
                    max   : 20,
                    pag   : pag
                },
                success : function (msg) {
                    $("#divTabla").html(msg);
                    $("#dlgLoad").dialog("close");
                }
            });
        }

        $(function () {

            $(".editable").first().addClass("selected");

            $(".num").click(function () {
                $("#dlgLoad").dialog("open");

                var num = $(this).attr("href");
                enviar(num);
                return false;
            });

            $("#dlgLoad").dialog("close");
        });

    </script>

</body>

</html>