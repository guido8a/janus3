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
    .cmplcss {
        color: #0c4c85;
    }
    </style>


</head>
Tabla de un rubro en el cronograma
<table class="table table-bordered table-condensed table-hover">
    <thead>
        <tr>
        <th rowspan="2" style="width:70px;">Código</th>

        <th rowspan="2" style="width:220px;">Rubro</th>
        <th rowspan="2" style="width:26px;">*</th>
        <th rowspan="2" style="width:60px;">Cantidad Unitario Total</th>
        <th rowspan="2" style="width:12px;">T.</th>
        <th class="P">13-04-2022 a 30-04-2022</th>
        <th class="P">01-05-2022 a 12-05-2022</th>
        <th class="P">13-05-2022 a 31-05-2022</th>
        <th class="P">01-06-2022 a 11-06-2022</th>
        <th class="P">12-06-2022 a 17-06-2022</th>
        <th class="S">18-06-2022 a 30-06-2022</th>
        <th class="P">01-07-2022 a 14-07-2022</th>
        <th class="P">15-07-2022 a 25-07-2022</th>
        <th class="P">26-07-2022 a 31-07-2022</th>
        <th class="P">01-08-2022 a 24-08-2022</th>
        <th class="P">25-08-2022 a 31-08-2022</th>
        <th class="P">01-09-2022 a 23-09-2022</th>
        <th rowspan="2">Total rubro</th>
        </tr>
        <tr>
        <th class="P click" data-periodo="1225">Periodo 1 (18 días)</th>
        <th class="P click" data-periodo="1226">Periodo 1 (12 días)</th>
        <th class="P click" data-periodo="1227">Periodo 2 (19 días)</th>
        <th class="P click" data-periodo="1228">Periodo 2 (11 días)</th>
        <th class="P click" data-periodo="1229">Periodo 3 (6 días)</th>
        <th class="S click" data-periodo="1376">Susp. 3 (13 días)</th>
        <th class="P click" data-periodo="1377">Periodo 3 (14 días)</th>
        <th class="P click" data-periodo="1378">Periodo 3 (11 días)</th>
        <th class="P click" data-periodo="1379">Periodo 4 (6 días)</th>
        <th class="P click" data-periodo="1380">Periodo 4 (24 días)</th>
        <th class="P click" data-periodo="1381">Periodo 5 (7 días)</th>
        <th class="P click" data-periodo="1382">Periodo 5 (23 días)</th>
        </tr>
    </thead>
    <tbody>
        <tr class="click item_row   rowSelected" data-vol="2773">
            <td class="codigo">C-002-005</td>
            <td class="" nombre="">EXCAVACION MANUAL DEL SUELO DE 0M ≤ H ≤ 2M SIN CLASIF.- INC. NIVELACION</td>
            <td class="unidad" style="text-align: center;">Subtt</td>
            <td class="num cantidad">681.61</td>
            <td>$</td>
            <td class="dol num P">408.97</td>
            <td class="dol num P">272.64</td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num S"></td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num P">
            <td class="dol num P">
            <td class="num dol total totalRubro">681.61
        </tr>
        <tr class="click item_prc  rowSelected"><td> </td>
        <td>Unidad: m3   </td>
        <td>P.U:</td>
        <td class="num precioU">7.75</td>
        <td>%</td>
        <td class="prct num P">60.00</td>
        <td class="prct num P">40.00</td>
        <td class="prct num P"></td>
        <td class="prct num P"></td>
        <td class="prct num P"></td>
        <td class="prct num S"></td>
        <td class="prct num P"></td>
        <td class="prct num P"></td>
        <td class="prct num P"></td>
        <td class="prct num P"></td>
        <td class="prct num P"></td>
        <td class="prct num P"></td>
        <td class="num prct total totalRubro">100.00</td>
        </tr>
        <tr class="click item_f  rowSelected"><td colspan="2"> </td>
        <td>Cant.</td>
        <td class="num subtotal">87.95A</td>
        <td>F</td>
        <td class="fis num P">52.77</td>
        <td class="fis num P">35.18</td>
        <td class="fis num P"></td>
        <td class="fis num P"></td>
        <td class="fis num P"></td>
        <td class="fis num S"></td>
        <td class="fis num P"></td>
        <td class="fis num P"></td>
        <td class="fis num P"></td>
        <td class="fis num P"></td>
        <td class="fis num P"></td>
        <td class="fis num P"></td>
        <td class="num fis total totalRubro">87.95</td>
        </tr>


        %{--mejora propuesta: generar datos en postgres incluyendo los <br> de cada columna --}%

        <tr class="click item_row   rowSelected" data-vol="2773">
            <td class="codigo">C-002-005
                <b>U: m3</b>
            </td>
            <td class="" nombre="">EXCAVACION MANUAL DEL SUELO DE 0M ≤ H ≤ 2M SIN CLASIF.- INC. NIVELACION</td>
            <td class="unidad" style="text-align: center;">Subtt<br>P.U.<br>Cant.</td>
            <td class="num cantidad">681.61<br>7.75</td>
            <td>$</td>
            <td class="dol num P">408.97</td>
            <td class="dol num P">272.64</td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num S"></td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num P"></td>
            <td class="dol num P">
            <td class="dol num P">
            <td class="num dol total totalRubro">681.61
        </tr>

    </tbody>
</table>
</html>