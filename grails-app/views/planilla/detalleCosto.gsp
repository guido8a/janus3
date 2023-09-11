<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">

    <title>Detalle de planilla</title>

    <style type="text/css">
    th {
        vertical-align : middle !important;
    }

    tbody th {
        background : #5E8E9B !important;
    }

    td {
        vertical-align : middle !important;
    }

    .num {
        text-align : right !important;
        width      : 60px;
    }

    .borderLeft {
        border-left : #5E8E9B double 3px !important;
    }

    .borderTop {
        border-top : #5E8E9B double 3px !important;
    }

    .ok, .ok td {
        background : #6DBA64 !important;
    }
    </style>
</head>

<body>

<div class="row" style="margin-bottom: 10px;">
    <div class="span9 btn-group" role="navigation">
        <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-primary btn-new" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
        <g:link controller="planilla" action="list" params="[id: contrato?.id]" class="btn btn-info btn-new" title="Regresar a las planillas del contrato">
            <i class="fa fa-arrow-left"></i>
            Planillas
        </g:link>
    </div>

    <div class="span3" id="busqueda-Planilla"></div>
</div>

<elm:headerPlanilla planilla="${planilla}"/>

<g:if test="${editable}">
    <div id="divError" class="alert alert-error hide">

    </div>
    <table class="table table-bordered table-condensed ">
        <thead>
        <tr>
            <th>Factura N.</th>
            <th>Descripción del rubro</th>
            <th>Unidad</th>
            <th>Cantidad</th>
            <th>Valor sin IVA</th>
            <th>
                Valor con IVA<br/>
                (${iva}%)
            </th>
            <th id="thIndirectos" data-indi="${indirectos}">
                % de indirectos ${contrato?.indirectos}<br/>
            </th>
            <th>Valor total</th>
            <th style="width: 110px;">
                <a href="#" id="btnReset" class="btn">Nuevo</a>
            </th>
        </tr>
        </thead>
        <tbody>
        <tr id="trRubro">
            <td id="tdFactura">
                <input type="text" id="txtFactura" class="input-small int" style="width: 100px;"/>
            </td>
            <td id="tdRubro">
                <input type="text" id="txtRubro" class="input-xlarge" style="width: 200px;"/>
            </td>
            <td id="tdUnidad">
                <g:select class="input-mini" name="selUnidad" from="${janus.Unidad.list([sort: 'descripcion'])}" optionKey="id" optionValue="codigo"/>
            </td>
            <td id="tdCantidad">
                <input type="text" id="txtCantidad" class="input-small number"/>
            </td>
            <td id="tdValor">
                <input type="text" id="txtValor" class="input-small number"/>
            </td>
            <td id="tdValorIva">
                <input type="text" id="txtValorIva" class="input-small number"/>
            </td>
            <td id="tdIndirectos">
                <input type="text" id="txtIndirectos" class="input-small number"/>
            </td>
            <td id="tdTotal" class="num bold" style="font-size: 14px;">
                0.00
            </td>
            <td>
                <a href="#" class="btn btn-success " id="btnAdd">
                    Agregar
                </a>
                <a href="#" class="btn btn-primary hide" id="btnSave">
                  Guardar
                </a>
            </td>
        </tr>
        </tbody>
    </table>
</g:if>

<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width: 80px;">Factura N.</th>
        <th>Descripción del rubro</th>
        <th style="width: 70px;">U.</th>
        <th style="width: 70px;">Cantidad</th>
        <th style="width: 100px;">Valor sin IVA</th>
        <th style="width: 100px;">Valor con IVA</th>
        <th style="width: 100px;">% de indirectos</th>
        <th style="width: 100px;">Valor total</th>
        <g:if test="${editable}">
            <th style="width: 120px;"></th>
        </g:if>
    </tr>
    </thead>
    <tbody id="tbRubros">

    </tbody>
    <tfoot>
    <tr>
        <th colspan="7">TOTAL</th>
        <td id="tdTotalFinal" class="num bold" data-max="${max}" data-val= ${0}>0.00</td>
        <g:if test="${editable}">
            <td></td>
        </g:if>
    </tr>
    </tfoot>
</table>

<script type="text/javascript">

    var iva = ${iva}/100;
    var anterior = 0;

    function initRows() {
        var rows1 = '${detalles}';
        var rows = JSON.parse(rows1.replace(/&quot;/g,'"'));

        for (var i = 0; i < rows.length; i++) {
            var data = rows[i];
            addRow(data, false);
        }
        updateTotal();
    }

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode == 190 || ev.keyCode == 110 ||
            ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
            ev.keyCode == 37 || ev.keyCode == 39);
    }

    function validarInt(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         109        -> - teclado numerico
         173        -> - teclado
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            (ev.keyCode >= 109 && ev.keyCode <= 173) ||
            ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
            ev.keyCode == 37 || ev.keyCode == 39);
    }

    function numero($item, val) {
        if ($item.is("input")) {
            if (val != 0 && val != "" && !isNaN(val)) {
                $item.val(number_format(val, 2, ".", ",")).data("valor", val);
            } else {
                $item.val("").data("valor", 0);
            }
        } else {
            if (val != 0 && val != "" && !isNaN(val)) {
                $item.text(number_format(val, 2, ".", ",")).data("valor", val);
            } else {
                $item.text("").data("valor", 0);
            }
        }
    }

    function reset() {
        $("#txtRubro, #txtFactura, .number").val("");
        $("#indirectos").val(${indirectos});

        $("#tdTotal").text("0.00");
        $("#trRubro").removeData();
        $("#btnSave").addClass('hide');
        $("#btnAdd").removeClass('hide');
    }

    function updateVal(tipo) {
        var indi = ${contrato?.indirectos?:21}/100;
        var valorNoIva = parseFloat($.trim($("#txtValor").val()));
        var valorIva = valorNoIva + (valorNoIva * iva);
        var valorIndi = (valorNoIva * indi);

        if (tipo === 1 || 3) {
            $("#txtIndirectos").val(number_format(valorIndi, 2, ".", "")).data("default", number_format(valorIndi, 2, ".", ""));
        }
        if (tipo === 2 || 3) {
            $("#txtValorIva").val(number_format(valorIva, 2, ".", "")).data("default", number_format(valorIva, 2, ".", ""));
        }
    }

    function check($elm) {
        var error = false;
        if ($elm.attr("id") === "txtValor") {
            updateVal(3);
        }
        var str = "";
        $("#txtValorIva, #txtIndirectos").each(function () {
            var valor = parseFloat($.trim($(this).val()));
            var def = parseFloat($(this).data("default"));
            var dif = Math.abs(parseFloat(valor).toFixed(2) - parseFloat(def).toFixed(2)).toFixed(2);

            if (dif > 0.1) {
                str += "<p class='errorP'>No puede ingresar un valor con una diferencia de más de diez centavos de " + number_format(def, 2, ".", "") + "</p>";
                error = true;
            }
        });

        if (error) {
            $("#tdTotal").text("0.00").data("val", 0);
            $("#divError").html(str).show();
        }

        var factura = $.trim($("#txtFactura").val());
        var rubro = $.trim($("#txtRubro").val());
        var unidadId = $("#selUnidad").val();
        var unidadText = $("#selUnidad option:selected").text();
        var cantidad = parseFloat($.trim($("#txtCantidad").val()));
        var valor = parseFloat($.trim($("#txtValor").val()));
        var valorIva = parseFloat($.trim($("#txtValorIva").val()));
        var valorIndi = parseFloat($.trim($("#txtIndirectos").val()));
        var total = 0;
        if (!error && valor != "" && valorIva != "" && valorIndi != "" && !isNaN(valor) && !isNaN(valorIva) && !isNaN(valorIndi)) {
            total = valor + valorIndi;
            total = total.toFixed(2);
            $("#tdTotal").text(number_format(valor + valorIndi, 2, ".", "")).data("val", valor + valorIndi);
        }

        if (!error && factura != "" && rubro != "" && valor != "" && valorIva != "" && valorIndi != "" && !isNaN(valor) && !isNaN(valorIva) && !isNaN(valorIndi)) {
            var rubro = {
                "planilla.id"   :${planilla.id},
                factura         : factura,
                rubro           : rubro,
                "unidad.id"     : unidadId,
                cantidad        : cantidad,
                unidadText      : unidadText,
                monto           : valor,
                montoIva        : valorIva,
                montoIndirectos : valorIndi,
                indirectos      : $("#thIndirectos").data("indi"),
                total           : total
            };
            $("#trRubro").data(rubro);
            return true;
        }
        return false;
    }

    function noDuplicados(data) {
        var msg = "";
        $("#tbRubros").children("tr").each(function () {
            var trData = $(this).data();
            if (trData.rubro === data.rubro) {
                msg += "<li>El rubro " + trData.rubro + " ya ha sido ingresado. Si necesita hacer cambios modifique el item ingresado.</li>";
            }
        });
        if (msg !== "") {

            var b = bootbox.dialog({
                id      : "dlgCreateEdit",
                title   :"Errores",
                message : "Se han encontrado los siguientes errores: <ul>" + msg + "</ul>",
                buttons : {
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-primary",
                        callback  : function () {
                        }
                    }
                } //buttons
            }); //dialog
            return false;
        }
        return true;
    }

    function loadData(data) {
        var $tr = $("#trRubro");
        $tr.data(data);
        $("#txtFactura").val(data.factura);
        $("#txtRubro").val(data.rubro);
        $("#selUnidad").val(data["unidad.id"]);
        $("#txtValor").val(data.monto);
        $("#txtCantidad").val(data.cantidad);
        $("#txtValorIva").val(data.montoIva);
        $("#txtIndirectos").val(data.montoIndirectos);
        $("#tdTotal").text(number_format(data.total, 2, ".", ","));
        $("#btnAdd").addClass('hide');
        $("#btnSave").removeClass('hide');
        anterior = data.total
    }

    function updateRow(data) {
        $("#tbRubros").children("tr").each(function () {
            var idAct = $(this).data("id");
            if (idAct === data.id) {
                $(this).remove();
                addRow(data, true);
            }
        });
        updateTotal();
    }

    function updateTotal() {
        var total = 0;
        $("#tbRubros").children("tr").each(function () {
            var tot = parseFloat($(this).data("total"));
            total += tot;
        });
        $("#tdTotalFinal").text(number_format(total, 2, ".", ",")).data("valor", total);
    }

    function addRow(data, highlight) {

        var $tr = $("<tr></tr>").data(data);

        $("<td>" + data.factura + "</td>").appendTo($tr);
        $("<td>" + data.rubro + "</td>").appendTo($tr);
        $("<td>" + data.unidadText + "</td>").appendTo($tr);
        $("<td class='num'>" + number_format(data.cantidad, 2, ".", ",") + "</td>").appendTo($tr);
        $("<td class='num'>" + number_format(data.monto, 2, ".", ",") + "</td>").appendTo($tr);
        $("<td class='num'>" + number_format(data.montoIva, 2, ".", ",") + "</td>").appendTo($tr);
        $("<td class='num'>" + number_format(data.montoIndirectos, 2, ".", ",") + "</td>").appendTo($tr);
        $("<td class='num'>" + number_format(data.total, 2, ".", ",") + "</td>").appendTo($tr);

        if (${editable}) {
            var $tdBtn = $("<td>");
            var $btnEdit = $("<a href='#' class='btn btn-primary btn-xs' style='margin-left: 10px;' title='Editar'><i class='fa fa-edit'></i></a>").appendTo($tdBtn);
            var $btnDelete = $("<a href='#' class='btn btn-danger btn-xs' style='margin-left: 10px;' title='Eliminar'><i class='fa fa-trash'></i></a>").appendTo($tdBtn);

            $btnDelete.click(function () {
                bootbox.confirm({
                    title: "Eliminar",
                    message: "Está seguro de eliminar el rubro " + data.rubro + "? Esta acción no se puede deshacer.",
                    buttons: {
                        cancel: {
                            label: '<i class="fa fa-times"></i> Cancelar',
                            className: 'btn btn-primary'
                        },
                        confirm: {
                            label: '<i class="fa fa-trash"></i> Borrar',
                            className: 'btn btn-danger'
                        }
                    },
                    callback: function (result) {
                        if(result){
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'deleteDetalleCosto')}",
                                data    : {
                                    id : data.id
                                },
                                success : function (msg) {
                                    $tr.remove();
                                    updateTotal();
                                }
                            });
                        }
                    }
                });
            });

            $btnEdit.click(function () {
                loadData(data);
            });

            $tdBtn.appendTo($tr);
        }

        $("#tbRubros").prepend($tr);
        if (highlight) {
            $tr.addClass("ok", 2000, function () {
                $tr.removeClass("ok", 2000);
            });
        }
    }

    reset();
    initRows();

    $("#btnReset").click(function () {
        reset();
    });

    $(".int").bind({
        keydown : function (ev) {
            return validarInt(ev);
        } //keydown
    });

    $("#txtFactura, #txtRubro").keyup(function () {
        check($(this));
    });
    $("#selUnidad").change(function () {
        check($(this));
    });
    $("#indirectos").change(function () {
        $("#thIndirectos").data("indi", $(this).val());
        updateVal(1);
        check($(this));
    });

    $(".number").bind({
        keydown : function (ev) {
            // esta parte valida el punto: si empieza con punto le pone un 0 delante, si ya hay un punto lo ignora
            if (ev.keyCode === 190 || ev.keyCode === 110) {
                var val = $(this).val();
                if (val.length == 0) {
                    $(this).val("0");
                }
                return val.indexOf(".") === -1;
            } else {
                // esta parte valida q sean solo numeros, punto, tab, backspace, delete o flechas izq/der
                return validarNum(ev);
            }
        }, //keydown
        keyup   : function () {
            $("#divError").hide();
            var val = $(this).val();
            // esta parte valida q no ingrese mas de 2 decimales
            var parts = val.split(".");
            if (parts.length > 1) {
                if (parts[1].length > 2) {
                    parts[1] = parts[1].substring(0, 2);
                    val = parts[0] + "." + parts[1];
                    $(this).val(val);
                }
            }
            // esta parte hace los calculos
            check($(this));
        }
    });

    $("#btnSave").click(function () {
        $(this).hide().after(spinner);
        var $tr = $("#trRubro");
        var data = $tr.data();
        var $tdTotal = $("#tdTotalFinal");
        var max = parseFloat($tdTotal.data("max"));
        var tot = parseFloat($tdTotal.data("valor"));
        var val = parseFloat(data.total) + parseFloat(tot) - parseFloat(anterior);
        var respaldo;

        if(max < 0.1) {
            respaldo = "No se ha subido documento de respaldo de obras adicionales"
        } else {
            respaldo = max + "El valor total de las planillas de Costo + porcentaje " +
                "superaría el valor permitido (${formatNumber(number: max, maxFractionDigits: 2, minFractionDigits: 2, format: '##,##0', locale:'ec')})"
        }

        if (val <= max) {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'addDetalleCosto')}",
                data    : data,
                success : function (msg) {
                    var parts = msg.split("_");
                    if (parts[0] === "OK") {
                        updateRow(data);
                        reset();
                        spinner.remove();
                        location.reload();
                    }
                }
            });
        } else {
            $("#btnSave").removeClass('hide');
            spinner.remove();

            bootbox.dialog({
                id      : "dlgAlerta",
                title   :"Errores",
                message : respaldo,
                buttons : {
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-primary",
                        callback  : function () {
                        }
                    }
                } //buttons
            }); //dialog
        }
        return false;
    });

    $("#btnAdd").click(function () {
        if (check($(this))) {
            $(this).hide().after(spinner);
            var $tr = $("#trRubro");
            var data = $tr.data();
            var $tdTotal = $("#tdTotalFinal");
            var max = parseFloat($tdTotal.data("max"));
            var tot = parseFloat($tdTotal.data("valor"));
            var val = parseFloat(data.total) + parseFloat(tot);
            var respaldo = "";

            if(max < 0.001) {
                respaldo = "No se ha subido documento de respaldo de obras adicionales"
            } else {
                respaldo =  max + "El valor total de las planillas de Costo + porcentaje superaría el valor permitido " +
                    "(${formatNumber(number: max, maxFractionDigits: 2, minFractionDigits: 2, format: '##,##0', locale:'ec')}) "
            }

            if (val <= max) {
                if (noDuplicados(data)) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'addDetalleCosto')}",
                        data    : data,
                        success : function (msg) {
                            var parts = msg.split("_");
                            if (parts[0] === "OK") {
                                data.id = parts[1];
                                addRow(data, true);
                                reset();
                                spinner.remove();
                                $("#btnAdd").removeClass('hide');
                                updateTotal();
                                location.reload();
                            } else {
                                bootbox.dialog({
                                    id      : "dlgAlerta2",
                                    title   :"Errores",
                                    message : parts[1],
                                    buttons : {
                                        cancelar : {
                                            label     : "Cancelar",
                                            className : "btn-primary",
                                            callback  : function () {
                                            }
                                        }
                                    } //buttons
                                }); //dialog
                            }
                        }
                    });
                }
            } else {
                $("#btnAdd").removeClass('hide');
                spinner.remove();

                bootbox.dialog({
                    id      : "dlgAlerta",
                    title   :"Errores",
                    message : respaldo,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Por favor complete todos los campos para agregar un rubro." + '</strong>');
        }
        return false;
    });
</script>
</body>
</html>