<!doctype html>
<html>
<head>
    <meta name="layout" content="main">

    <asset:javascript src="/jquery/plugins/box/js/jquery.luz.box.js"/>
    <asset:javascript src="/jquery/plugins/box/css/jquery.luz.box.css"/>
    <asset:stylesheet src="/apli/cronograma.css"/>

    <title>Cronograma</title>

    <style type="text/css">

    .fila {
        margin-top: 5px;
    }
    .espacio {
        margin-left: 10px;
        margin-right: 10px;
    }
    </style>
</head>

<body>
<g:set var="meses" value="${obra.plazoEjecucionMeses + (obra.plazoEjecucionDias > 0 ? 1 : 0)}"/>
<g:set var="plazoOk" value="${detalle.findAll { it.dias > 0 }.size() > 0}"/>
<g:set var="matrizOk" value="${tieneMatriz}"/>
<g:set var="sum" value="${0}"/>

<legend>CRONOGRAMA DE LA OBRA: ${obra.nombre?.toUpperCase()} (${meses} mes${meses == 1 ? "" : "es"})</legend>

<div class="btn-toolbar">
    <div class="btn-group">
        <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}"
           class="btn btn-primary btn-new" id="atras" title="Regresar a la obra">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
        <g:if test="${meses > 0 && plazoOk && matrizOk && (obra.estado != 'R' || obra.codigo.contains('OF'))}">
            <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1) || obra?.id == null }">
                <a href="#" class="btn disabled" id="btnDeleteRubro">
                    <i class="fa fa-minus"></i>
                    Eliminar Rubro
                </a>
                <a href="#" class="btn" id="btnDeleteCronograma">
                    <i class="fa fa-trash"></i>
                    Eliminar Cronograma
                </a>

            </g:if>
        </g:if>
    </div>

    <g:if test="${meses > 0 && plazoOk && matrizOk}">
        <div class="btn-group">
            <a href="#" class="btn" id="btnGrafico">
                <i class="fas fa-chart-line"></i>
                Gráficos de avance
            </a>
            <a href="#" id="btnReporte" class="btn"><i class="fa fa-print"></i> Imprimir</a>
            <a href="#" class="btn btn-print btnExcel" data-id="${obra?.id}">
                <i class="fa fa-table"></i> Excel
            </a>
        </div>
    </g:if>
</div>

<g:if test="${matrizOk}">

    <g:if test="${meses > 0 && plazoOk}">

        <div style="margin-bottom: 5px; margin-top: 15px">
            Subpresupuesto: <g:select name="subpresupuesto" from="${subpres}" optionKey="id" optionValue="descripcion"
                                      style="width: 400px;font-size: 10px" id="subpres" value="${subpre}"
                                      noSelection="['-1': 'TODOS']"/>
            <a href="#" class="btn" style="margin-top: -10px;" id="btnSubpre">Cambiar</a>
            <g:if test="${obra.estado != 'R' || obra.codigo.contains('OF')}">
                <a href="#" class="btn" style="margin-top: -10px;" id="btnDesmarcar">Desmarcar todo</a>
                <a href="#" class="btn" style="margin-top: -10px;" id="btnRutaOn"><i class="fa fa-check"></i> Marcar ruta crítica
                </a>
                <a href="#" class="btn" style="margin-top: -10px;" id="btnRutaOff"><i class="fa fa-check"></i> Desmarcar ruta crítica
                </a>
            </g:if>
        </div>

        <div>
            La ruta crítica se muestra con los rubros marcados en amarillo
        </div>

        <div class="divTabla">
            <table class="table table-bordered table-condensed table-hover">
                <thead>
                <tr>
                    <th class="num">
                        #
                    </th>
                    <th class="codigo">
                        Código
                    </th>
                    <th class="nombre">
                        Rubro
                    </th>
                    <th class="unidad">
                        Unidad
                    </th>
                    <th class="cantidad">
                        Cantidad
                    </th>
                    <th class="precioU">
                        Unitario
                    </th>
                    <th class="subtotal">
                        C.Total
                    </th>
                    <th class="dias">
                        Días
                    </th>
                    <th class="tiny">
                        T.
                    </th>
                    <g:each in="${0..meses - 1}" var="i">
                        <th class="meses">
                            Periodo ${i + 1}
                        </th>
                    </g:each>
                    <th class="totalRubro">
                        Total Rubro
                    </th>
                </tr>
                </thead>
                <tbody id="tabla_material">

                <g:each in="${detalle}" var="vol" status="s">
                    <g:set var="cronos" value="${janus.Cronograma.findAllByVolumenObra(vol)}"/>


                    <tr class="item_row ${vol.rutaCritica == 'S' ? 'rutaCritica' : ''} ${vol.id}" id="${vol.id}" data-id="${vol.id}">
                        <td class="codigo">
                            ${vol.orden}
                        </td>
                        <td class="codigo">
                            ${vol.item.codigo}
                        </td>
                        <td class="nombre">
                            ${vol.item.nombre}
                        </td>
                        <td style="text-align: center" class="unidad">
                            ${vol.item.unidad.codigo}
                        </td>
                        <td class="num cantidad" data-valor="${vol.cantidad}">
                            <g:formatNumber number="${vol.cantidad}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                        </td>
                        <td class="num precioU" data-valor="${precios[vol.id.toString()]}">
                            <g:formatNumber number="${pcun[vol.id.toString()]}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                        </td>
                        <g:set var="parcial" value="${precios[vol.id.toString()]}"/>
                        <td class="num subtotal" data-valor="${parcial}">
                            <g:formatNumber number="${parcial}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                            <g:set var="sum" value="${sum + parcial}"/>
                        </td>
                        <td style="text-align: center" class="dias">
                            <span style="color:#008"><g:formatNumber number="${vol.dias}" maxFractionDigits="2" minFractionDigits="2" locale="ec"/></span>
                        </td>
                        <td class="tiny">
                            $
                        </td>
                        <g:each in="${0..meses - 1}" var="i">
                            <g:set var="prec" value="${cronos.find { it.periodo == i + 1 }}"/>
                            <td class="dol mes meses num mes${i + 1} rubro${vol.id}" data-mes="${i + 1}" data-rubro="${vol.id}" data-valor="0"
                                data-tipo="dol" data-val="${prec?.precio ?: 0}" data-id="${prec?.id ?: ''}">
                                <g:formatNumber number="${prec?.precio}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                            </td>
                        </g:each>
                        <td class="num rubro${vol.id} dol total totalRubro">
                            <span>
                            </span> $
                        </td>
                    </tr>

                    <tr class="item_prc ${vol.rutaCritica == 'S' ? 'rutaCritica' : ''} ${vol.id}" data-id="${vol.id}">
                        <td colspan="8">
                            &nbsp
                        </td>
                        <td>
                            %
                        </td>
                        <g:each in="${0..meses - 1}" var="i">
                            <g:set var="porc" value="${cronos.find { it.periodo == i + 1 }}"/>
                            <td class="prct mes num mes${i + 1} rubro${vol.id}" data-mes="${i + 1}" data-rubro="${vol.id}" data-valor="0"
                                data-tipo="prct" data-val="${porc?.porcentaje ?: 0}" data-id="${porc?.id ?: ''}">
                                <g:formatNumber number="${porc?.porcentaje}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                            </td>
                        </g:each>
                        <td class="num rubro${vol.id} prct total totalRubro">
                            <span>
                            </span> %
                        </td>
                    </tr>

                    <tr class="item_f ${vol.rutaCritica == 'S' ? 'rutaCritica' : ''} ${vol.id}" data-id="${vol.id}">
                        <td colspan="8">
                            &nbsp
                        </td>
                        <td>
                            F
                        </td>
                        <g:each in="${0..meses - 1}" var="i">
                            <g:set var="cant" value="${cronos.find { it.periodo == i + 1 }}"/>
                            <td class="fis mes num mes${i + 1} rubro${vol.id}" data-mes="${i + 1}" data-rubro="${vol.id}" data-valor="0"
                                data-tipo="fis" data-val="${cant?.cantidad ?: 0}" data-id="${cant?.id ?: ''}">
                                <g:formatNumber number="${cant?.cantidad}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                            </td>
                        </g:each>
                        <td class="num rubro${vol.id} fis total totalRubro">
                            <span>
                            </span> F
                        </td>
                    </tr>

                </g:each>
                </tbody>
                <tfoot>
                <tr>
                    <td></td>
                    <td colspan="4">TOTAL PARCIAL</td>
                    <td class="num">
                        <g:formatNumber number="${sum}" format="##,##0" minFractionDigits="2" maxFractionDigits="2" locale="ec"/>
                    </td>
                    <td></td>
                    <td>T</td>
                    <g:each in="${0..meses - 1}" var="i">
                        <td class="num mes${i + 1} totalParcial total" data-mes="${i + 1}" data-valor="0">
                        </td>
                    </g:each>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="4">TOTAL ACUMULADO</td>
                    <td></td>
                    <td></td>
                    <td>T</td>
                    <g:each in="${0..meses - 1}" var="i">
                        <td class="num mes${i + 1} totalAcumulado total" data-mes="${i + 1}" data-valor="0">
                            0.00
                        </td>
                    </g:each>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="4">% PARCIAL</td>
                    <td></td>
                    <td></td>
                    <td>T</td>
                    <g:each in="${0..meses - 1}" var="i">
                        <td class="num mes${i + 1} prctParcial total" data-mes="${i + 1}" data-valor="0">
                            0.00
                        </td>
                    </g:each>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td colspan="4">% ACUMULADO</td>
                    <td></td>
                    <td></td>
                    <td>T</td>
                    <g:each in="${0..meses - 1}" var="i">
                        <td class="num mes${i + 1} prctAcumulado total" data-mes="${i + 1}" data-valor="0">
                            0.00
                        </td>
                    </g:each>
                    <td></td>
                </tr>
                </tfoot>
            </table>
        </div>
    </g:if>
    <g:else>
        <g:if test="${meses == 0}">
            <div class="alert alert-error">
                <i class="icon-warning-sign icon-2x pull-left"></i>
                <h4>Error</h4>
                La obra tiene una planificación de 0 meses...Por favor corrija esto para continuar con el cronograma.
            </div>
        </g:if>
        <g:elseif test="${!plazoOk}">
            <div class="alert alert-error" style="border-style: solid; border-width: 1px; border-color: #0A246A; margin-top: 5px">
                <i class="icon-warning-sign icon-2x pull-left"></i>
                <h4>Error</h4>
                <p style="font-size: 14px">
                    No se ha calculado el plazo de la obra.
                </p>
                <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1)}">
                    <p>
                        <g:link controller="obra" action="calculaPlazo" id="${obra.id}" class="btn btn-danger"><i class="fa fa-cog"></i> Calcular</g:link>
                    </p>
                </g:if>
            </div>
        </g:elseif>
    </g:else>
</g:if>
<g:else>
    <div class="alert alert-error" style="font-size: 14px">
        <i class="icon-warning-sign icon-2x pull-left"></i>
        <p>No se ha generado la matriz de la fórmula polinómica.</p>
        <i class="icon-warning-sign icon-2x pull-left"></i>
        <p>Si la obra se encuentra <strong>registrada</strong>, Por favor vuelva a generar la matriz de la FP para visualizar el cronograma
        </p>
    </div>
</g:else>

<div id="modal-cronograma">

    <div class="modal-body" id="modalBody">
        <form class="form-horizontal" id="frmRubro">
            <div class="row" style="padding: 5px; background-color: #e0e0e0; margin-bottom: 10px; margin-top: -10px; border-radius: 10px">
            <div class="fila col-md-12">
                <div class="col-md-2">
                        Rubro N.
                </div>
                <div class="col-md-8">
                    <span aria-labelledby="num-label" id="spanCodigo"></span>
                </div>
            </div>

            <div class="fila col-md-12">
                <div class="col-md-2">
                    Descripción
                </div>
                <div class="col-md-8">
                    <span aria-labelledby="desc-label" id="spanDesc"></span>
                </div>
            </div>

            <div class="fila col-md-12">
                <div class="col-md-2">
                        Cantidad
                </div>

                <div class="col-md-8">
                    <span aria-labelledby="cant-label" id="spanCant"></span>
                </div>
            </div>

            <div class="fila col-md-12">
                <div class="col-md-2">
                        Precio
                </div>

                <div class="col-md-8">
                    <span aria-labelledby="precio-label" id="spanPrecio"></span>
                </div>
            </div>

            <div class="fila col-md-12">
                <div class="col-md-2">
                        Subtotal
                </div>

                <div class="col-md-8">
                    <span aria-labelledby="st-label" id="spanSubtotal"></span>
                </div>
            </div>
            </div>
        </form>

        <div id="divRubro" class="well" style="font-size: 16px">
            Múltiples rubros
        </div>

        <table class="form-check form-check-inline" style="padding: 5px; background-color: #e0e0e0; margin-bottom: 10px; margin-top: -10px; border-radius: 8px">
            <div class="fila" style="margin-bottom: 10px;">
                <div class="col-md-3">
                    Periodos
                </div>
                <div class="col-md-8">
                    <input id="periodosDesde" class="spinner"/><span class="espacio">al</span>
                    <input id="periodosHasta" class="spinner" value="${meses}"/>
                </div>
            </div>

            <table class="col-md-12 fila" style="margin-top: 10px">
                <table>
                    <tr>
                        <td style="width: 30px; padding: 10px"><input type="radio" class="radio cant" name="tipo" id="rd_cant" value="cant" checked=""/></td>
                        <td style="width: 80px"><label for="rd_cant">Cantidad</label></td>
                        <td style="width: 250px"><input type="text" class="input-mini tf" id="tf_cant"/>
                            <span class="spUnidad"></span>
                            de
                            <span id="spCant"></span>
                        <span class="spUnidad"></span></td>
                    </tr>
                </table>
                <table>
                    <tr>
                    <td style="width: 30px; padding: 10px"><input type="radio" class="radio prct" name="tipo" id="rd_prct" value="prct"/></td>
                    <td style="width: 80px"><label for="rd_precio">Porcentaje</label></td>
                    <td style="width: 250px"><input type="text" class="input-mini tf" id="tf_prct"/>% de<span id="spPrct"></span>%</td>
                    </tr>
                </table>
                <table>
                    <tr>
                        <td style="width: 30px; padding: 10px"><input type="radio" class="radio precio" name="tipo" id="rd_precio" value="prct"/></td>
                        <td style="width: 80px"><label for="rd_precio">Precio</label></td>
                        <td style="width: 250px"><input type="text" class="input-mini tf" id="tf_precio"/>$
                    de <span id="spPrecio"></span>$</td>
                    </tr>
                </table>
            %{--</div>--}%
        </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>


<div class="modal longModal tallModal fade hide " id="modal-graf">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle-graf"></h3>
    </div>

    <div class="modal-body" id="modalBody-graf">
        <div class="graf" id="graf"></div>
    </div>

    <div class="modal-footer" id="modalFooter-graf">
    </div>
</div>


<script type="text/javascript">


    function log(msg) {
    }

    function updateTotales() {

        $("#tabla_material").children("tr").each(function () {
            var rubro = $(this).data("id");

            var totalFilaDol = 0;
            var totalFilaPrct = 0;
            var totalFilaFis = 0;

            var $totalFilaDol = $(".total.dol" + ".rubro" + rubro);
            var $totalFilaPrct = $(".total.prct" + ".rubro" + rubro);
            var $totalFilaFis = $(".total.fis" + ".rubro" + rubro);

            //calcular los totales de la fila: del rubro
            if ($(this).hasClass("item_row")) {
                $(".dol.rubro" + rubro).not(".total").each(function () {
                    var val = parseFloat($(this).data("val"));
                    if (val && !isNaN(val)) {
                        totalFilaDol += val;
                    }
                });
                $totalFilaDol.data("val", totalFilaDol).children("span").first().text(number_format(totalFilaDol, 2, ".", ","));
            } else if ($(this).hasClass("item_prc")) {
                $(".prct.rubro" + rubro).not(".total").each(function () {
                    var val = parseFloat($(this).data("val"));
                    if (val && !isNaN(val)) {
                        totalFilaPrct += val;
                    }
                });
                $totalFilaPrct.data("val", totalFilaPrct).children("span").first().text(number_format(totalFilaPrct, 2, ".", ","));
            } else if ($(this).hasClass("item_f")) {
                $(".fis.rubro" + rubro).not(".total").each(function () {
                    var val = parseFloat($(this).data("val"));
                    if (val && !isNaN(val)) {
                        totalFilaFis += val;
                    }
                });
                $totalFilaFis.data("val", totalFilaFis).children("span").first().text(number_format(totalFilaFis, 2, ".", ","));
            }
        });

        //calcular los totales de la columna: del mes
        var totAcum = 0;
        for (var i = 0; i < parseInt("${meses}") + 1; i++) {
            var $totalParcial = $(".totalParcial.mes" + i);
            var $totalAcumulado = $(".totalAcumulado.mes" + i);
            var $prctParcial = $(".prctParcial.mes" + i);
            var $prctAcumulado = $(".prctAcumulado.mes" + i);
            //total: .dol
            var tot = 0;
            $(".dol.mes" + i).not(".total").each(function () {
                var val = parseFloat($(this).data("val"));
                if (val && !isNaN(val)) {
                    tot += val;
                    totAcum += val;
                }
            });

            var prc = tot * 100 / parseFloat("${sum}");
            $(".total.mes" + i + ".totalParcial").text(number_format(tot, 2, ".", ",")).data("val", tot);
            $(".total.mes" + i + ".prctParcial").text(number_format(prc, 2, ".", ",")).data("val", prc);

            var prcAcum = totAcum * 100 / parseFloat("${sum}");
//                    ////console.log($(".total.mes" + i + ".totalAcumulado"), totAcum, $(".total.mes" + i + ".prctAcumulado"), prcAcum);
            $(".total.mes" + i + ".totalAcumulado").text(number_format(totAcum, 2, ".", ",")).data("val", totAcum);
            $(".total.mes" + i + ".prctAcumulado").text(number_format(prcAcum, 2, ".", ",")).data("val", prcAcum);
        }
    }

    function validar() {
        var periodoIni = $.trim($("#periodosDesde").val());
        var periodoFin = $.trim($("#periodosHasta").val());

        var $cant = $("#tf_cant");
        var $prct = $("#tf_prct");
        var $prec = $("#tf_precio");

        var cant = $.trim($cant.val());
        var prct = $.trim($prct.val());
        var prec = $.trim($prec.val());

        if (periodoIni == "") {
            log("Ingrese el periodo inicial");
            return false;
        }
        if (periodoFin === "") {
            log("Ingrese el periodo final");
            return false;
        }
        if (cant === "") {
            log("Ingrese la cantidad, porcentaje o precio");
            return false;
        }
        if (prct === "") {
            log("Ingrese el porcentaje, cantidad o precio");
            return false;
        }
        if (prec === "") {
            log("Ingrese el precio, cantidad o porcentaje");
            return false;
        }

        var maxCant = $cant.attr("max");
        var maxPrct = $prct.attr("max");
        var maxPrec = $prec.attr("max");

        try {
            periodoIni = parseFloat(periodoIni);
            periodoFin = parseFloat(periodoFin);

            if (periodoFin < periodoIni) {
                log("El periodo inicial debe ser inferior al periodo final");
                return false;
            }

            cant = parseFloat(cant);
            prct = parseFloat(prct);
            maxCant = parseFloat(maxCant);
            maxPrct = parseFloat(maxPrct);
            maxPrec = parseFloat(maxPrec);

            if (cant > maxCant) {
                log("La cantidad debe ser menor que " + maxCant);
                return false;
            }
            if (prct > maxPrct) {
                log("El porcentaje debe ser menor que " + maxPrct);
                return false;
            }
            if (prec > maxPrec) {
                log("El precio debe ser menor que " + maxPrec);
                return false;
            }

        } catch (e) {
            return false;
        }
        return true;
    }

    function validar2() {
        var periodoIni = $.trim($("#periodosDesde").val());
        var periodoFin = $.trim($("#periodosHasta").val());

        var $prct = $("#tf_prct");

        var prct = $.trim($prct.val());

        if (periodoIni == "") {
            log("Ingrese el periodo inicial");
            return false;
        }
        if (periodoFin == "") {
            log("Ingrese el periodo final");
            return false;
        }
        if (prct == "") {
            log("Ingrese el porcentaje, cantidad o precio");
            return false;
        }

        var maxPrct = $prct.attr("max");

        try {
            periodoIni = parseFloat(periodoIni);
            periodoFin = parseFloat(periodoFin);

            if (periodoFin < periodoIni) {
                log("El periodo inicial debe ser inferior al periodo final");
                return false;
            }

            prct = parseFloat(prct);
            maxPrct = parseFloat(maxPrct);

            if (prct > maxPrct) {
                log("El porcentaje debe ser menor que " + maxPrct);
                return false;
            }

        } catch (e) {
            return false;
        }
        return true;
    }

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         */
//        ////console.log(ev.keyCode);
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) || (ev.keyCode >= 96 && ev.keyCode <= 105) || ev.keyCode == 190 || ev.keyCode == 110 || ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9);
    }

    function getSelected() {
        var selected = $(".item_row").filter(".rowSelected");
        return selected;
    }

    $(function () {

        $("#subpres").val(${subpre});

        updateTotales();

        $("#btnDesmarcar").click(function () {
            $(".rowSelected").removeClass("rowSelected");
        });

        $("#btnSubpre").click(function () {
            $.box({
                imageClass : "box_info",
                text       : "Cargando... Por favor espere...",
                title      : "Cargando",
                iconClose  : false,
                dialog     : {
                    resizable     : false,
                    draggable     : false,
                    closeOnEscape : false,
                    buttons       : false
                }
            });
            location.href = "${createLink(action: 'cronogramaObra')}/${obra.id}?subpre=" + $("#subpres").val();
        });

        <g:if test="${obra.estado!='R' || obra.codigo.contains('OF')}">
        $("#tabla_material").children("tr").click(function () {

            if ($(this).hasClass("rowSelected")) {
                $(this).removeClass("rowSelected");
                if ($(this).hasClass("item_row")) {
                    $(this).next().removeClass("rowSelected").next().removeClass("rowSelected");
                } else if ($(this).hasClass("item_prc")) {
                    $(this).next().removeClass("rowSelected");
                    $(this).prev().removeClass("rowSelected");
                } else if ($(this).hasClass("item_f")) {
                    $(this).prev().removeClass("rowSelected").prev().removeClass("rowSelected");
                }
            } else {
                $(this).addClass("rowSelected");
                if ($(this).hasClass("item_row")) {
                    $(this).next().addClass("rowSelected").next().addClass("rowSelected");
                } else if ($(this).hasClass("item_prc")) {
                    $(this).next().addClass("rowSelected");
                    $(this).prev().addClass("rowSelected");
                } else if ($(this).hasClass("item_f")) {
                    $(this).prev().addClass("rowSelected").prev().addClass("rowSelected");
                }
            }

            var sel = getSelected();
//            console.log('selecc:', sel.length)
            if (sel.length == 0) {
                $("#btnLimpiarRubro, #btnDeleteRubro").addClass("disabled");
            } else {
                $("#btnLimpiarRubro, #btnDeleteRubro").removeClass("disabled");
            }
        });
        </g:if>

        $(".spinner").spinner({
            min : 1,
            max :${meses}//,
        }).keydown(function () {
            return false;
        });

        $(".disabled").click(function () {
            return false;
        });

        $(".tf").keydown(function (ev) {
            return validarNum(ev);
        }).focus(function () {
            var id = $(this).attr("id");
            var parts = id.split("_");
            $("#rd_" + parts[1]).attr("checked", true);
        });

        $("#tf_cant").keyup(function (ev) {
            if (validarNum(ev)) {
                var val = $.trim($(this).val());
                if (val == "") {
                    $("#tf_prct").val("");
                    $("#tf_precio").val("");
                } else {
                    try {
                        val = parseFloat(val);
                        var max = parseFloat($(this).data("max"));
                        if (val > max) {
                            val = max;
                        }
                        var $precio = $("#tf_precio");
                        var total = parseFloat($(this).data("total"));
                        var prct = (val * 100) / total;
                        var dol = $precio.data("max") * (prct / 100);
                        $("#tf_prct").val(number_format(prct, 2, ".", "")).data("val", prct);
                        $precio.val(number_format(dol, 2, ".", "")).data("val", dol);
                        if (ev.keyCode != 110 && ev.keyCode != 190) {
                            $("#tf_cant").val(val).data("val", val);
                        }
                    } catch (e) {
//                                ////console.log(e);
                    }
                }
            }
        });
        $("#tf_prct").keyup(function (ev) {
            if (validarNum(ev)) {
                var prct = $.trim($(this).val());
                if (prct == "") {
                    $("#tf_cant").val("");
                    $("#tf_precio").val("");
                } else {
                    var $sel = getSelected();
                    if ($sel.length == 1) {
                        try {
                            prct = parseFloat(prct);
                            var max = parseFloat($(this).data("max"));
                            if (prct > max) {
                                prct = max;
                            }
                            var $precio = $("#tf_precio");
                            var $cant = $("#tf_cant");
                            var total = parseFloat($cant.data("total"));
                            var val = (prct / 100) * total;
                            var dol = $precio.data("total") * (prct / 100);
                            $cant.val(number_format(val, 2, ".", "")).data("val", val);
                            $precio.val(number_format(dol, 2, ".", "")).data("val", dol);
                            if (ev.keyCode != 110 && ev.keyCode != 190) {
                                $("#tf_prct").val(prct).data("val", prct);
                            }
                        } catch (e) {
                        }
                    } //if $sel.lenght = 1
                    else {
                        try {
                            prct = parseFloat(prct);
                            if (prct > 100) {
                                prct = 100;
                            }
                            if (ev.keyCode != 110 && ev.keyCode != 190) {
                                $("#tf_prct").val(prct).data("val", prct);
                                $("#tf_cant").val("").data("val", null);
                                $("#tf_precio").val("").data("val", null);
                            }
                        } catch (e) {
                        }
                    } //$sel.lenght > 1
                }
            }
        });
        $("#tf_precio").keyup(function (ev) {
            if (validarNum(ev)) {
                var dol = $.trim($(this).val());
                if (dol == "") {
                    $("#tf_prct").val("");
                    $("#tf_cant").val("");
                } else {
                    try {
                        dol = parseFloat(dol);
                        var max = parseFloat($(this).data("max"));
                        if (dol > max) {
                            dol = max;
                        }
                        var $cant = $("#tf_cant");
                        var total = parseFloat($(this).data("total"));
                        var totalCant = parseFloat($cant.data("total"));
                        var prct = (dol * 100) / total;
                        var cant = dol * totalCant / total;

                        $("#tf_prct").val(number_format(prct, 2, ".", "")).data("val", prct);
                        $cant.val(number_format(cant, 2, ".", "")).data("val", cant);
                        if (ev.keyCode != 110 && ev.keyCode != 190) {
                            $("#tf_precio").val(dol).data("val", dol);
                        }
                    } catch (e) {
                    }
                }
            }
        });

        $("#modal-cronograma").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 600,
            height: 400,
            position: 'center',
            title: 'Registro del Cronograma'
        });


        function clickOne($celda) {
            var $tr = $celda.parents("tr");
            if ($tr.hasClass("item_prc")) {
                $tr = $tr.prev();
            } else if ($tr.hasClass("item_f")) {
                $tr = $tr.prev().prev();
            }

            var mes = $celda.data("mes");
            var tipo = $celda.data("tipo");
            var valor = $celda.data("valor");
            var rubro = $celda.data("rubro");

            $("#periodosDesde").val(mes);
            $("#periodosHasta").val("${meses}");

            $("#divRubro").hide();
            $("#frmRubro").show();

            $("#rd_cant,#tf_cant,#rd_precio,#tf_precio").removeAttr("disabled");
            $("#rd_cant").attr("checked", true);

            var codigo = $.trim($tr.find(".codigo").text());
            var desc = $.trim($tr.find(".nombre").text());
            var cant = $.trim($tr.find(".cantidad").data("valor"));
            var precio = $.trim($tr.find(".precioU").data("valor"));
            var subtotal = $.trim($tr.find(".subtotal").data("valor"));
            var unidad = $.trim($tr.find(".unidad").text());

            var dolAsignado = $.trim($(".dol.rubro" + rubro).children("span").text());
            var prctAsignado = $.trim($(".prct.rubro" + rubro).children("span").text());
            var fAsignado = $.trim($(".fis.rubro" + rubro).children("span").text());

            dolAsignado = dolAsignado.replace(",", "");
            prctAsignado = prctAsignado.replace(",", "");
            fAsignado = fAsignado.replace(",", "");

            var dolRestante = parseFloat(subtotal) - parseFloat(dolAsignado);
            var prctRestante = 100 - parseFloat(prctAsignado);
            var cantRestante = parseFloat(cant) - parseFloat(fAsignado);

            dolRestante = parseFloat(number_format(dolRestante, 2, ".", ""));
            prctRestante = parseFloat(number_format(prctRestante, 2, ".", ""));
            cantRestante = parseFloat(number_format(cantRestante, 2, ".", ""));

            $("#spCant").text(cantRestante);
            $("#spPrct").html(prctRestante);
            $("#spPrecio").text(number_format(dolRestante, 2, ".", ","));

            $("#tf_cant").data({
                max   : cantRestante,
                total : cant
            }).val("");
            $("#tf_prct").data({
                max   : prctRestante,
                total : 100
            }).val("");
            $("#tf_precio").data({
                max   : dolRestante,
                total : subtotal
            }).val("");

            $("#spanCodigo").text(codigo);
            $("#spanDesc").text(desc);
            $("#spanCant").text(number_format(cant, 2, ".", ",") + " " + unidad);
            $("#spanPrecio").text(number_format(precio, 2, ".", ",") + " $");
            $("#spanSubtotal").text(number_format(subtotal, 2, ".", ",") + " $");
            $(".spUnidad").text(unidad);

            var $btnCancel = $('<a href="#" class="btn">Cerrar</a>');
            var $btnOk = $('<a href="#" class="btn btn-success">Aceptar</a>');

            $btnCancel.click(function () {
                $("#modal-cronograma").dialog("close");
            });
            
            $btnOk.click(function () {
                if (validar()) {
                    $btnOk.replaceWith(spinner);

                    var dataAjax = "";

                    var periodoIni = parseInt($("#periodosDesde").val());
                    var periodoFin = parseInt($("#periodosHasta").val());

                    var cant = $("#tf_cant").data("val");
                    var prct = $("#tf_prct").data("val");

                    var d, i, dol;

                    if (periodoIni == periodoFin) {
                        dol = subtotal * (prct / 100);
                        $(".dol.mes" + periodoIni + ".rubro" + rubro).text(number_format(dol, 2, ".", ",")).data("val", dol);
                        $(".prct.mes" + periodoIni + ".rubro" + rubro).text(number_format(prct, 2, ".", ",")).data("val", prct);
                        $(".fis.mes" + periodoIni + ".rubro" + rubro).text(number_format(cant, 2, ".", ",")).data("val", cant);
                        dataAjax += "&crono=" + rubro + "_" + periodoIni + "_" + dol + "_" + prct + "_" + cant;
                    } else {
                        var meses = periodoFin - periodoIni + 1;
                        dol = subtotal * (prct / 100);
                        var dolCalc = dol, prctCalc = prct, cantCalc = cant


                        dol = Math.round((dol / meses) * 100) / 100;
                        prct = Math.round((prct / meses) * 100) / 100;
                        cant = Math.round((cant / meses) * 100) / 100;

                        for (i = periodoIni; i <= periodoFin; i++) {
                            if (i == periodoFin) {
                                dol = dolCalc;
                                prct = prctCalc;
                                cant = cantCalc;
                            }
                            dolCalc -= dol;
                            prctCalc -= prct;
                            cantCalc -= cant;
                            $(".dol.mes" + i + ".rubro" + rubro).text(number_format(dol, 2, ".", ",")).data("val", dol);
                            $(".prct.mes" + i + ".rubro" + rubro).text(number_format(prct, 2, ".", ",")).data("val", prct);
                            $(".fis.mes" + i + ".rubro" + rubro).text(number_format(cant, 2, ".", ",")).data("val", cant);

                            dataAjax += "&crono=" + rubro + "_" + i + "_" + dol + "_" + prct + "_" + cant + "&";
                        }
                    }
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'saveCrono_ajax')}",
                        data    : dataAjax,
                        success : function (msg) {
                            var parts = msg.split("_");
                            if (parts[0] == "OK") {
                                parts = parts[1].split(";");
                                for (i = 0; i < parts.length; i++) {
                                    var p = parts[i].split(":");
                                    var mes = p[0];
                                    var id = p[1];
                                    $(".dol.mes" + mes + ".rubro" + rubro).data("id", id);
                                    $(".prct.mes" + mes + ".rubro" + rubro).data("id", id);
                                    $(".fis.mes" + mes + ".rubro" + rubro).data("id", id);
                                }
                                updateTotales();
                                $("#modal-cronograma").dialog("close");
                            } else {
                            }
                            $(".rowSelected").removeClass("rowSelected");
                        }
                    });
                }
                return false;
            });

            $("#modalTitle").html("Registro del Cronograma");
            <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1) || obra?.id == null }">
            $("#modalFooter").html("").append($btnCancel).append($btnOk);
            </g:if>
            <g:else>
            $("#modalFooter").html("").append($btnCancel);
            </g:else>
            $("#modal-cronograma").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        }

        function modificarRuta(tipo) {
            var data = "";
            var $selected = $(".rowSelected");
            $selected.each(function () {
                var id = $(this).data("id");
                if (data.indexOf(id) == -1) {
                    if (data != "") {
                        data += "&";
                    }
                    data += "row=" + id;
                }
            });
            data += "&ruta=" + tipo;
            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'rutaCritica')}",
                data    : data,
                success : function (msg) {
                    var parts = msg.split("_");
                    var ok = parts[0];
                    var no = parts[1];
                    if (ok != "") {
                        ok = ok.split(",");
                    }
                    if (no != "") {
                        no = no.split(",");
                    }
                    for (var i = 0; i < ok.length; i++) {
                        if (tipo == "S") {
                            $("." + ok[i]).removeClass("selectedRow").addClass("rutaCritica");
                        } else {
                            $("." + ok[i]).removeClass("selectedRow").removeClass("rutaCritica");
                        }
                    }
                    for (var i = 0; i < no.length; i++) {
                        $("." + no[i]).removeClass("selectedRow").addClass("error");
                    }
                }
            });
        }

        <g:if test="${obra.estado!='R' || obra.codigo.contains('OF')}">
        $("#btnRutaOn").click(function () {
            modificarRuta("S");
            return false;
        });
        $("#btnRutaOff").click(function () {
            modificarRuta("N");
            return false;
        });

        $(".mes").dblclick(function () {
            var $sel = getSelected();
            var $celda = $(this);
            console.log('dbl:', $sel.length)
            if ($sel.length == 1) {
                clickOne($celda);
            } else {
                if ($sel.length > 1) {
                    var mes = $celda.data("mes");
                    $("#rd_cant,#tf_cant,#rd_precio,#tf_precio").attr("disabled", "true");
                    $("#periodosDesde").val(mes);
                    $("#periodosHasta").val("${meses}");
                    $("#rd_prct").attr("checked", true);

                    $("#frmRubro").hide();
                    $("#divRubro").show();

                    $("#tf_prct").data({
                        max   : 100,
                        total : 100
                    }).val("");

                    $("#spCant").text("");
                    $("#spPrecio").text("");
                    $("#spPrct").text(100);

                    var $btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
                    var  $btnOk = $('<a href="#" class="btn btn-success">Aceptar</a>');

                    $btnOk.click(function () {
                        if (validar2()) {
                            $btnOk.replaceWith(spinner);

                            $(".item_row.rowSelected").each(function () {
                                var id = $(this).data("id");
                                $.ajax({
                                    async   : false,
                                    type    : "POST",
                                    url     : "${createLink(action:'deleteRubro_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        $(".mes.rubro" + id).text("").data("val", 0);
                                        updateTotales();
                                    }
                                });
                            });

                            var dataAjax = "";

                            var periodoIni = parseInt($("#periodosDesde").val());
                            var periodoFin = parseInt($("#periodosHasta").val());

                            var prct = $("#tf_prct").data("val");

                            $sel.each(function () {
                                var $tr = $(this);

                                var rubro = $tr.data("id");

                                var cantTot = $tr.find(".cantidad").data("valor");
                                var precTot = $tr.find(".subtotal").data("valor");

                                var cantCal = cantTot * (prct / 100);
                                var precCal = precTot * (prct / 100);

                                if (periodoIni == periodoFin) {
                                    $(".dol.mes" + periodoIni + ".rubro" + rubro).text(number_format(precCal, 2, ".", ",")).data("val", precCal);
                                    $(".prct.mes" + periodoIni + ".rubro" + rubro).text(number_format(prct, 2, ".", ",")).data("val", prct);
                                    $(".fis.mes" + periodoIni + ".rubro" + rubro).text(number_format(cantCal, 2, ".", ",")).data("val", cantCal);
                                    dataAjax += "&crono=" + rubro + "_" + periodoIni + "_" + precCal + "_" + prct + "_" + cantCal;
                                } else {
                                    var meses = periodoFin - periodoIni + 1;

                                    var pr = Math.round((prct / meses) * 100) / 100;
                                    var cn = Math.round((cantCal / meses) * 100) / 100;
                                    var pe = Math.round((precCal / meses) * 100) / 100;

                                    var prRest = prct, cnRest = cantCal, peRest = precCal;

                                    for (var i = periodoIni; i <= periodoFin; i++) {
                                        if (i == periodoFin) {
                                            pr = prRest;
                                            cn = cnRest;
                                            pe = peRest;
                                        }
                                        prRest -= pr;
                                        cnRest -= cn;
                                        peRest -= pe;

                                        $(".dol.mes" + i + ".rubro" + rubro).text(number_format(pe, 2, ".", ",")).data("val", pe);
                                        $(".prct.mes" + i + ".rubro" + rubro).text(number_format(pr, 2, ".", ",")).data("val", pr);
                                        $(".fis.mes" + i + ".rubro" + rubro).text(number_format(cn, 2, ".", ",")).data("val", cn);

                                        dataAjax += "&crono=" + rubro + "_" + i + "_" + pe + "_" + pr + "_" + cn + "&";
                                    }
                                }
                            });

                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'saveCrono_ajax')}",
                                data    : dataAjax,
                                success : function (msg) {
                                    var parts = msg.split("_");
                                    if (parts[0] == "OK") {
                                        parts = parts[1].split(";");
                                        for (var i = 0; i < parts.length; i++) {
                                            var p = parts[i].split(":");
                                            var mes = p[0];
                                            var id = p[1];
                                            var rubro = p[2];
                                            $(".dol.mes" + mes + ".rubro" + rubro).data("id", id);
                                            $(".prct.mes" + mes + ".rubro" + rubro).data("id", id);
                                            $(".fis.mes" + mes + ".rubro" + rubro).data("id", id);
                                        }
                                        updateTotales();
                                        $("#modal-cronograma").dialog("close");

                                        $(".rowSelected").removeClass("rowSelected");

                                    } else {
//                                                ////console.log("ERROR");
                                    }
                                }
                            });
                        } //if validar
                    });

                    %{--</g:if>--}%

                    $("#modalTitle").html("Registro del Cronograma");
                    <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1) || obra?.id == null }">
                    $("#modalFooter").html("").append($btnCancel).append($btnOk);
                    </g:if>
                    <g:else>
                    $("#modalFooter").html("").append($btnCancel);
                    </g:else>
                    $("#modal-cronograma").dialog("open");
                    $(".ui-dialog-titlebar-close").html("x")
                }
            }

        }); //fin dblclick


        $("#btnDeleteRubro").click(function () {
            $.box({
                imageClass : "box_info",
                text       : "Se eliminarán los rubros marcados, continuar?<br/>Los datos serán eliminados inmediatamente, y no se puede deshacer.",
                title      : "Confirmación",
                iconClose  : false,
                dialog     : {
                    resizable : false,
                    draggable : false,
                    buttons   : {
                        "Aceptar"  : function () {

                            $(".item_row.rowSelected").each(function () {
                                var id = $(this).data("id");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'deleteRubro_ajax')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        $(".mes.rubro" + id).text("").data("val", 0);
                                        updateTotales();
                                    }
                                });
                            });

                        },
                        "Cancelar" : function () {
                        }
                    }
                }
            });
        });

        $("#btnDeleteCronograma").click(function () {
            $.box({
                imageClass : "box_info",
                text       : "Se eliminará todo el cronograma, desea continuar?<br/>Los datos serán eliminados inmediatamente, y no se puede deshacer.",
                title      : "Confirmación",
                iconClose  : false,
                dialog     : {
                    resizable : false,
                    draggable : false,
                    buttons   : {
                        "Aceptar"  : function () {
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'deleteCronograma_ajax')}",
                                data    : {
                                    obra : ${obra.id}
                                },
                                success : function (msg) {
//                                            ////console.log("Data Saved: " + msg);
                                    $(".mes").text("").data("val", 0);
                                    updateTotales();
                                }
                            });
                        },
                        "Cancelar" : function () {
                        }
                    }
                }
            });
        });
        </g:if>
        $("#btnReporte").click(function () {
            location.href = "${createLink(controller: 'reportes2', action:'reporteCronogramaPdf', id:obra.id, params:[tipo:'obra'])}";
            return false;
        });

        $(".btnExcel").click(function () {
            $("#dlgLoad").dialog("open");
            location.href = "${g.createLink(controller: 'reportes6' ,action: 'reporteExcelCronograma',id: obra?.id, params:[tipo:'obra'])}";
            setTimeout(function () {
                $("#dlgLoad").dialog("close");
            }, 3000);
        });

        $("#btnGrafico").click(function () {
            var d = "obra=${obra.id}";
            d += "&sbpr=${subpre}";

            var url = "${createLink(action: 'grafico')}?" + d;
            location.href = url;

            return false;
        });


    })
    ;

</script>

</body>
</html>