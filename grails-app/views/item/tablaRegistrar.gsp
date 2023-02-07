<html>

<head>

    <asset:javascript src="/apli/tableHandler.js"/>
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
            <th>Precio</th>
            <th class="precioAL hidden">Precio Anterior</th>
            <th>Fecha</th>
            <th>Registrar
                <a href="#" class="btn " title="Todos" id="seleccionar"><i class="icon-check"></i>Todos</a>
        </tr>
        </thead>
        <tbody>
        <g:each in="${rubroPrecio}" var="rubro" status="i">
            <tr align="right">
                <td class="itemId" align="center" style="width: 150px;">
                    ${rubro?.item?.codigo}
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
                <td class="precioAnterior hidden" align="center" style="width: 105px">
                    0.00
                </td>
                <td class="fecha" align="center" style="width: 150px">
                    <g:formatDate date="${rubro?.fecha}" format="dd-MM-yyyy"/>
                </td>
                <td style="text-align: center;" class="chk">
                %{--${rubro?.registrado}--}%
                    <g:if test="${rubro?.registrado == 'R'}">
                        <i class="icon-ok"></i>
                    </g:if>
                    <g:else>
                        <input type="checkbox" class="chequear"/>
                    </g:else>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

    %{--            Total de registros visualizados: ${params.totalRows}<br/>--}%

    <script type="text/javascript">

        $(function () {

            $(".editable").first().addClass("selected");

            $("#dlgLoad").dialog("close");
        });

        $("#seleccionar").click(function(){
            $(".chequear")[0].checked ? $(".chequear").prop("checked", false) : $(".chequear").prop("checked", true);
        });
    </script>

</body>

</html>