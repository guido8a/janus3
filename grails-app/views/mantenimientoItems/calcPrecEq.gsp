<style type="text/css">
th, td {
    text-align     : center;
    vertical-align : middle;
    padding        : 3px;
    font-size      : 12px;
}

h4 {
    font-size : 15px;
}

.calculos {
    height     : 270px;
    width      : 880px;
    overflow-x : hidden;
    overflow-y : auto;
}

.totalParcial, .totalParcial td, .totalParcial th {
    background : #ADADAD;
}

.totalFinal, .totalFinal td, .totalFinal th {
    background : #6E6E77;
    color      : #f5f5f0;
}

.totalParcial, .totalParcial td, .totalParcial th, .totalFinal, .totalFinal td, .totalFinal th {
    font-weight : bold;
}

.num {
    text-align : right;
}

.st-title {
    width     : 150px;
    font-size : 12px;
}

.st-cod {
    width     : 33px;
    font-size : 12px;
}

.st-total {
    width     : 50px;
    font-size : 12px;
}

.campo01 {
    width : 30px;
}

.campo02 {
    width : 40px;
}

.campo03 {
    width : 60px;
}

.campo04 {
    width : 70px;
}

.ui-front {
    z-index : 1100 !important;
}

</style>

<div class="col-md-12" style="width: 880px;">

    <div class="row" style="margin-top: -10px">
        <h4>Datos del equipo</h4>
    </div>

    <div class="row" style="margin-top: 5px">
        <div class="col-md-8">
            <table style="width: 360px">
                <tr class="totalFinal">
                    <th>Costo total de la hora</th>
                    <td class="tdCh num dol" data-dec="2"></td>
                </tr>
            </table>
        </div>
        <div class="col-md-3" style="margin-bottom: 5px; float: right">
            <a href="#" class="btn btn-info" id="btnImprimir">
                <i class="fa fa-print"></i>
                Imprimir
            </a>
        </div>
    </div>

</div>

<div>
    <table border="1" style="width: 880px">
        <thead>
        <tr>
            <th style="width: 150px">Equipo</th>
            <th style="width: 50px">Potencia</th>
            <th style="width: 100px">Valor Eq. Nuevo</th>
            <th>Llantas</th>
            <th colspan="3">Vida Económica (h)</th>
            <th colspan="3">Horas al año (h)</th>
            <th colspan="3">Vida llantas al año (h)</th>
        </tr>
        <tr>
            <th>&nbsp;</th>
            <th>(HP)</th>
            <th>$</th>
            <th>$</th>
            <th>Baja</th>
            <th>Alta</th>
            <th>Prom</th>
            <th>Baja</th>
            <th>Alta</th>
            <th>Prom</th>
            <th>Baja</th>
            <th>Alta</th>
            <th>Prom</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>${item.nombre}</td>
            <td>
                <g:textField type="number" class="campo01 calcular" name="hp"/>
            </td>
            <td>
                <div class="input-append">
                    <g:textField class="campo03 calcular" name="vc" type="text"/>
                    <span class="add-on">$</span>
                </div>
            </td>
            <td>
                <div class="input-append">
                    <g:textField class="campo02 calcular" name="vll" type="text"/>
                    <span class="add-on">$</span>
                </div>
            </td>
            <td>
                <g:textField type="number" class="campo02 calcular prom" data-prom="hv" name="hvb"/>
            </td>
            <td>
                <g:textField type="number" class="campo02 calcular prom" data-prom="hv" name="hva"/>
            </td>
            <td id="hv" class="num campo02">
            </td>
            <td>
                <g:textField type="number" class="campo02 calcular prom" data-prom="ha" name="hab"/>
            </td>
            <td>
                <g:textField type="number" class="campo02 calcular prom" data-prom="ha" name="haa"/>
            </td>
            <td id="ha" class="num campo02">
            </td>
            <td>
                <g:textField type="number" class="campo02 calcular prom" data-prom="hll" name="hllb"/>
            </td>
            <td>
                <g:textField type="number" class="campo02 calcular prom" data-prom="hll" name="hlla"/>
            </td>
            <td id="hll" class="num campo02">
            </td>
        </tr>
        </tbody>
    </table>
</div>

<h4>Valores anuales</h4>

    <table border="1" style="width: 880px; table-layout: fixed">
        <thead>
        <tr style="background-color: #bba; width: 100%">
            <th style="width: 10%">Año</th>
            <th style="width: 12%">Seguro</th>
            <th style="width: 12%">Tasa interés anual</th>
            <th style="width: 16%">Factor costo respuestos  </br> y reparaciones</th>
            <th style="width: 12%">Costo diesel</th>
            <th style="width: 12%">Costo lubricantes</th>
            <th style="width: 12%">Costo grasa</th>
%{--            <th style="width: 14%">Modificar valores anuales</th>--}%
        </tr>
        </thead>
        <tbody>
        <tr style="background-color: #e0e0d8" >
            <td style="width: 10%">${valoresAnuales.anio}</td>
            <td style="width: 12%">
                <g:textField style="width: 80%" type="number" class="input-mini calcular" name="cs" value="${g.formatNumber(number: valoresAnuales.seguro, minFractionDigits: 0, maxFractionDigits: 3, locale: 'ec')}"/>
            </td>
            <td style="width: 12%">
                <div class="input-append">
                    <g:textField style="width: 80%" type="number" class="input-mini calcular" name="ci" value="${g.formatNumber(number: valoresAnuales.tasaInteresAnual, minFractionDigits: 0, maxFractionDigits: 3, locale: 'ec')}"/>
                    <span class="add-on">%</span>
                </div>
            </td>
            <td style="width: 16%">
                <g:textField style="width: 80%" type="number" class="input-mini calcular" name="k" value="${g.formatNumber(number: valoresAnuales.factorCostoRepuestosReparaciones, minFractionDigits: 0, maxFractionDigits: 3, locale: 'ec')}"/>
            </td>
            <td style="width: 12%">
                <g:textField style="width: 80%" type="number" class="input-mini calcular" name="di" value="${g.formatNumber(number: valoresAnuales.costoDiesel, minFractionDigits: 0, maxFractionDigits: 3, locale: 'ec')}"/>
            </td>
            <td style="width: 12%">
                <g:textField style="width: 80%" type="number" class="input-mini calcular" name="ac" value="${g.formatNumber(number: valoresAnuales.costoLubricante, minFractionDigits: 0, maxFractionDigits: 3, locale: 'ec')}"/>
            </td>
            <td style="width: 12%">
                <g:textField style="width: 80%" type="number" class="input-mini calcular" name="gr" value="${g.formatNumber(number: valoresAnuales.costoGrasa, minFractionDigits: 0, maxFractionDigits: 3, locale: 'ec')}"/>
            </td>
%{--            <td style="width: 14%">--}%
%{--                <a href="#" class="btn btn-sm btn-primary" id="btnSaveValoresAnuales"><i class="fa fa-cog"></i></a>--}%
%{--            </td>--}%
        </tr>
        </tbody>
    </table>

<h4>Cálculo del costo de la hora</h4>

<div class="calculos">
    <div class="row">
        <div class="col-md-3" style="width:240px;">
            <table border="1" width="240px;">
                <tr>
                    <th class="st-title">Valor comercial equipo</th>
                    <td class="tdVc num dol st-total" data-dec="2"></td>
                </tr>
                <tr>
                    <th class="st-title">Precio de las llantas nuevas</th>
                    <td class="tdVll num dol st-total" data-dec="2"></td>
                </tr>
                <tr>
                    <th class="st-title">Valor adquisición equipo</th>
                    <td class="tdVa num dol st-total" data-dec="2"></td>
                </tr>
                <tr>
                    <th class="st-title">Años de vida</th>
                    <td class="tdAv num st-total" data-dec="5"></td>
                </tr>
                <tr>
                    <th class="st-title">Valor de rescate</th>
                    <td class="tdVr num dol st-total" data-dec="2"></td>
                </tr>
                <tr class="totalParcial">
                    <th class="st-title">Depreciación del equipo</th>
                    <td class="tdD num dol st-total" data-dec="2"></td>
                </tr>
            </table>
        </div>

        <div class="col-md-3" style="width:280px; margin-left: 10px;">
            <table border="1" width="280px;">
                <tr>
                    <th class="st-title">Costo del dinero</th>
                    <td class="tdCi num st-total" data-dec="2"></td>
                </tr>
                <tr>
                    <th class="st-title">Factor de recuperación del capital</th>
                    <td class="tdFrc num st-total" data-dec="5"></td>
                </tr>
                <tr class="totalParcial">
                    <th class="st-title">Intereses</th>
                    <td class="tdI num st-total" data-dec="5"></td>
                </tr>
            </table>
        </div>

        <div class="col-md-2" style="width:150px; margin-left: 10px;">
            <table border="1">
                <tr>
                    <th class="st-title">Seguros</th>
                    <td class="tdCs num st-total" data-dec="4"></td>
                </tr>
                <tr class="totalParcial">
                    <th class="st-title">Costo de seguros</th>
                    <td class="tdS num st-total" data-dec="5"></td>
                </tr>
            </table>

            <div class="col-md-2" style="width: 150px; margin-top: 10px">
                <table border="1">
                    <tr class="totalParcial">
                        <th class="st-title">Matrícula</th>
                        <td class="tdM num st-total" data-dec="5"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="col-md-2" style="height: 110px; width:200px; margin-left: 10px;">
            <table border="1">
                <tr>
                    <th class="st-title">Factor de costo de respuestos reparaciones</th>
                    <td class="tdK num st-total" data-dec="2"></td>
                </tr>
                <tr class="totalParcial">
                    <th class="st-title">Costo de repuestos</th>
                    <td class="tdR num st-total" data-dec="5"></td>
                </tr>
            </table>
        </div>
        <div class="col-md-3" style="width: 280px; margin-left: 10px;">
            <table border="1" width="280px;">
                <tr>
                    <th class="st-title">Costo diesel - combustibles</th>
                    <td class="tdDi num st-total" data-dec="2" width="50px;"></td>
                </tr>
                <tr class="totalParcial">
                    <th class="st-title">Costo diesel</th>
                    <td class="tdCd num st-total" data-dec="5"></td>
                </tr>
            </table>
        </div>

        <div class="col-md-3" style="width: 150px; margin-left: 10px;">
            <table border="1">
                <tr class="totalParcial">
                    <th class="st-title">Costo M.O. reparaciones</th>
                    <td class="tdMor num st-total" data-dec="5"></td>
                </tr>
            </table>
        </div>

        <div class="col-md-3" style="width: 200px; margin-left: 10px;">
            <table border="1">
                <tr>
                    <th class="st-title">Aceite lubricante</th>
                    <td class="tdAc num st-total" data-dec="2"></td>
                </tr>
                <tr class="totalParcial">
                    <th class="st-title">Costo lubricante</th>
                    <td class="tdCl num st-total" data-dec="5"></td>
                </tr>
            </table>
        </div>
    </div>

    <div class="row" style="margin-top: 10px;">
        <div class="col-md-2" style="width: 240px;">
            <table border="1" width="240px;">
                <tr>
                    <th class="st-title">Grasa</th>
                    <td class="tdGr num st-total" data-dec="2"></td>
                </tr>
                <tr class="totalParcial">
                    <th class="st-title">Costo grasa</th>
                    <td class="tdCg num st-total" data-dec="5"></td>
                </tr>
            </table>
        </div>

        <div class="col-md-3" style="width: 320px; margin-left: 10px;">
            <table border="1" width="320px">
                <tr>
                    <th class="st-title" width="270px;">Precio de las llantas</th>
                    <td class="tdVll num st-total" data-dec="2" width="50px;"></td>
                </tr>
                <tr>
                    <th class="st-title">Horas de vida útil de las llantas</th>
                    <td class="tdHll num st-total" data-dec="2"></td>
                </tr>
                <tr class="totalParcial">
                    <th class="st-title">Costo horario por llantas</th>
                    <td class="tdCll num st-total" data-dec="5"></td>
                </tr>
            </table>
        </div>
    </div>
</div>

<script type="text/javascript">

    var data = {
        vc   : 0,
        vll  : 0,
        va   : 0,
        av   : 0,
        vr   : 0,
        d    : 0,
        ci   : ${valoresAnuales.tasaInteresAnual/100},
        frc  : 0,
        i    : 0,
        s    : 0,
        cs   : ${valoresAnuales.seguro/100},
        m    : 0,
        k    : ${valoresAnuales.factorCostoRepuestosReparaciones},
        r    : 0,
        mor  : 0,
        di   : ${valoresAnuales.costoDiesel},
        cd   : 0,
        ac   : ${valoresAnuales.costoLubricante},
        cl   : 0,
        gr   : ${valoresAnuales.costoGrasa},
        cg   : 0,
        ch   : 0,
        cll  : 0,
        hp   : 0,
        hvb  : 0,
        hva  : 0,
        hv   : 0,
        hab  : 0,
        haa  : 0,
        ha   : 0,
        hllb : 0,
        hlla : 0,
        hll  : 0
    };

    calc();

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    function calc() {

        data.va = data.vc - data.vll;

        data.av = data.hv / data.ha;
        data.vr = 72.47 / (Math.pow(data.av, 0.32)) * data.va / 100;
        data.d = (data.va - data.vr) / data.hv;

        data.frc = 1 / data.av + (data.av + 1) / (2 * data.av) * data.ci;
        data.i = data.va * data.frc * data.ci / data.hv;

        data.s = (data.va + data.vr) * data.cs / (2 * data.ha);

        data.m = 0.001 * (data.va - data.vr) * data.av / data.hv;

        data.r = 0.7425 * data.d * data.k;

        data.mor = 0.23 * data.d * data.k;

        data.cd = 0.04 * data.di * data.hp;

        data.cl = 0.00035 * data.ac * data.hp;

        data.cg = 0.001 * data.gr * data.hp;
        if (data.hll > 0) {
            data.cll = data.vll / data.hll;
        } else {
            data.cll = 0;
        }
        data.ch = data.d + data.i + data.s + data.m + data.r + data.mor + data.cd + data.cl + data.cg + data.cll;
        $.each(data, function (d, i) {
            if (i !== 0 || d === 'hll' || d === 'cll') {
                var td = $(".td" + d.capitalize());
                if (td) {
                    var dec = parseInt(td.data("dec"));
                    var t = number_format(i, dec, ".", ",");
                    if (td.hasClass("dol")) {
                        t = "$" + t
                    }
                    td.text(t);
                }
            }
        });

        return data
    }

    $(".calcular").bind({
        keydown : function (ev) {
            var dec = 2;
            var val = $(this).val();
            if (ev.keyCode === 188 || ev.keyCode === 190 || ev.keyCode === 110) {   // 188 -> , (coma), 190 -> . (punto) teclado, 110 -> . (punto) teclado numerico
                if (!dec) {
                    return false;
                } else {
                    if (val.length === 0) {
                        $(this).val("0");
                    }
                    if (val.indexOf(".") > -1 || val.indexOf(",") > -1) {
                        return false;
                    }
                }
            } else {
//                if (val.indexOf(".") > -1 || val.indexOf(",") > -1) {
//                    if (dec) {
//                        console.log(val);
//                        var parts = val.split(".");
//                        var l = parts[1].length;
//                        if (l >= dec) {
//                            if(ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 || ev.keyCode == 37|| ev.keyCode == 39) {   // 8 -> backspace, 46 -> delete, 9 -> tab, 37 -> flecha izq, 39 -> flecha der
//                                return true;
//                            }
//                            if(val.startsWith(".")) {
//                                return true;
//                            }
//                            return false;
//                        }
//                    }
//                } else {
                return validarNum(ev);
//                }
            }
        },
        keyup   : function () {
            var dec = 2;
            var val = $(this).val();
            var parts = val.split(".");
            var newVal=val;
            if(parts.length > 1) {
                if(parts[1].length > dec) {
                    newVal=parts[0]+"."+parts[1].substr(0,dec);
                } else if(parts[1].length > 0) {
                    newVal=parts[0]+"."+parts[1];
                }
            }
            if(newVal.startsWith(".")) {
                newVal = "0"+newVal;
            }
            $(this).val(newVal);

            var name = $(this).attr("name");
            data[name] = parseFloat($(this).val());
            if (name == "ci") {
                data[name] = parseFloat($(this).val()) / 100;
            }
            if ($(this).hasClass("prom")) {
                var prom = $(this).data("prom");

                var b = $("#" + prom + "b").val();
                var a = $("#" + prom + "a").val();

                if (a != "" && b != "") {
                    a = parseFloat(a);
                    b = parseFloat(b);
                    var m = (a + b) / 2;
                    data[prom] = m;
                    $("#" + prom).text(number_format(m, 2, ".", ""));
                }
            }
            calc();
        }
    });

    $("#btnImprimir").click(function () {
        if (!data.ch || !data.hp || !data.vc || !data.hvb || !data.hva || !data.hab || !data.haa) {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Debe llenar todos los datos de la forma antes de imprimir el reporte" + '</strong>');
        } else {
            location.href = "${g.createLink(controller: 'reportes3',action: 'imprimirValorHoraEquipos', id: item.id)}?potencia=" + data.hp + "&vc=" + data.vc + "&veb=" + data.hvb +
                "&vea=" + data.hva + "&vep=" + data.hv + "&hb=" + data.hab + "&ha=" + data.haa + "&hp=" + data.hp + "&vlb=" + data.hllb + "&vla=" + data.hlla + "&vlp=" + data.hll + "&ch=" + data.ch +
                "&av=" + data.av + "&vr=" + data.vr + "&d=" + data.d + "&i=" + data.i + "&frc=" + data.frc + "&cs=" + data.cs + "&s=" + data.s + "&m=" + data.m + "&va=" + data.va + "&ci=" + data.ci +
                "&k=" + data.k + "&r=" + data.r + "&mor=" + data.mor + "&di=" + data.di + "&cd=" + data.cd +
                "&ac=" + data.ac + "&cl=" + data.cl + "&gr=" + data.gr + "&cg=" + data.cg + "&vll=" + data.vll +
                "&hll=" + data.hll + "&cll=" + data.cll
        }
    });

</script>