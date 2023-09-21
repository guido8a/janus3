
<div id="tabs" style="width: 700px; height: 700px; text-align: center">

    <ul>
        <li><a href="#tab-formulaPolinomica">Fórmula Polinómica</a></li>
        <li><a href="#tab-cuadrillaTipo">Cuadrilla Tipo</a></li>

    </ul>

    <div id="tab-formulaPolinomica" class="tab">

        <div class="formula">

            <fieldset class="borde">
                <legend>Fórmula Polinómica</legend>

                <table class="table table-bordered table-striped table-hover table-condensed" id="tablaPoliContrato">
                    <thead>
                    <tr style="width: 100%">
                        <th style="width: 10%; text-align: center">Coeficiente</th>
                        <th style="width: 65%">Nombre del Indice (INEC)</th>
                        <th style="width: ${editar != 'no' ? '15%' : '25%'}">Valor</th>
                        <g:if test="${editar != 'no'}">
                            <th style="width: 15%">Editar</th>
                        </g:if>
                    </tr>
                    </thead>
                    <tbody id="bodyPoliContrato">
                    <g:set var="tot" value="${0}"/>
                    <g:each in="${ps}" var="i">
                        <tr>
                            <td>${i?.numero}</td>
                            <td>${i?.indice?.descripcion}</td>
                            <g:if test="${i.indice.id == 143}">
                                <td class="editable" data-tipo="p" data-id="${i.id}" id="${i.id}" data-original="${i.valor}" data-valor="${i.valor}" style="text-align: right; width: 40px">
                                    ${g.formatNumber(number: i?.valor, minFractionDigits: 3, maxFractionDigits: 3)}
                                </td>
                            </g:if>
                            <g:else>
                                <td data-tipo="p" data-valor="${i.valor}"style="text-align: right; width: 40px">
                                    ${g.formatNumber(number: i?.valor, minFractionDigits: 3, maxFractionDigits: 3)}
                                </td>
                            </g:else>
                            <g:if test="${editar != 'no'}">
                                <td style="text-align: center">
                                    <g:if test="${i.indice.id != 143}">
                                        <a href="#" data-id="${i.id}" class="btn btn-xs btn-success btnEditarIndice" title="Editar índice">
                                            <i class="fa fa-edit"></i>
                                        </a>
                                    </g:if>
                                </td>
                            </g:if>

                            <g:set var="tot" value="${tot + i.valor}"/>
                        </tr>
                    </g:each>
                    </tbody>
                    <tfoot>
                    <tr>
                        <th colspan="2">TOTAL</th>
                        <th class="total p" style="text-align: right; ">${g.formatNumber(number: tot, maxFractionDigits: 3, minFractionDigits: 3)}</th>
                        <th></th>
                    </tr>
                    </tfoot>
                </table>
            </fieldset>
        </div>
    </div>

    <div id="tab-cuadrillaTipo" class="tab">
        <fieldset class="borde">
            <legend>Cuadrilla Tipo</legend>

            <table class="table table-bordered table-striped table-hover table-condensed" id="tablaCuadrilla">
                <thead>
                <tr style="width: 100%">
                    <th style="width: 10%; text-align: center">Coeficiente</th>
                    <th style="width: 65%">Nombre del Indice (INEC)</th>
                    <th style="width: ${editar != 'no' ? '15%' : '25%'}">Valor</th>
                    <g:if test="${editar != 'no'}">
                        <th style="width: 15%">Editar</th>
                    </g:if>
                </tr>
                </thead>
                <tbody id="bodyCuadrilla">
                <g:set var="tot" value="${0}"/>
                <g:each in="${cuadrilla}" var="i">
                    <tr>
                        <td>${i?.numero}</td>
                        <td>${i?.indice?.descripcion}</td>
                        <td data-tipo="c" data-id="${i.id}" id="${i.id}" data-original="${i.valor}" data-valor="${i.valor}" style="text-align: right; width: 40px">
                            ${g.formatNumber(number: i?.valor, minFractionDigits: 3, maxFractionDigits: 3)}
                        </td>
                        <g:if test="${editar != 'no'}">
                            <td style="text-align: center">
                                <a href="#" data-id="${i.id}" class="btn btn-xs btn-success btnEditarIndiceCuadrilla" title="Editar índice">
                                    <i class="fa fa-edit"></i>
                                </a>
                            </td>
                        </g:if>
                        <g:set var="tot" value="${tot + i.valor}"/>
                    </tr>
                </g:each>
                </tbody>
                <tfoot>
                <tr>
                    <th colspan="2">TOTAL</th>
                    <th class="total c" style="text-align: right; ">${g.formatNumber(number: tot, maxFractionDigits: 3, minFractionDigits: 3)}</th>
                    <th></th>
                </tr>
                </tfoot>
            </table>
        </fieldset>
    </div>
</div>

%{--<div class="modal hide fade mediumModal" id="modal-var" style="overflow: hidden">--}%
%{--    <div class="modal-header btn-primary">--}%
%{--        <button type="button" class="close" data-dismiss="modal">x</button>--}%

%{--        <h3 id="modal_tittle_var">--}%

%{--        </h3>--}%

%{--    </div>--}%

%{--    <div class="modal-body" id="modal_body_var">--}%

%{--    </div>--}%

%{--    <div class="modal-footer" id="modal_footer_var">--}%

%{--    </div>--}%

%{--</div>--}%

<script type="text/javascript">

    $(".btnEditarIndiceCuadrilla").click(function () {
        var id = $(this).data("id");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'contrato', action: 'editarIndiceC_ajax')}",
            data    : {
                id : id
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditIC",
                    title   : "Editar índice cuadrilla",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                var indiceNuevo = $("#indice").val();
                                var valorNuevo = $("#valor").val();
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'guardarNuevoIndice')}",
                                    data    : {
                                        id   : id,
                                        indice: indiceNuevo,
                                        valor: valorNuevo
                                    },
                                    success : function (msg) {
                                        $("#modal-var").modal("hide");
                                        if(msg === 'ok'){
                                            log("Guardado correctamente","success");
                                            cargarTabla('${fp?.id}');
                                        }else{
                                            bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + "Error al guardar el Indice")
                                        }
                                    }
                                });
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        });
        return false;
    });

    $(".btnEditarIndice").click(function () {
        var id = $(this).data("id");

        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'contrato', action: 'editarIndice_ajax')}",
            data    : {
                id : id
            },
            success : function (msg) {
                var i = bootbox.dialog({
                    id      : "dlgCreateEditI",
                    title   : "Editar índice",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                var indiceNuevo = $("#indice").val();
                                var valorNuevo = $("#valor").val();
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(action:'guardarNuevoIndice')}",
                                    data    : {
                                        id   : id,
                                        indice: indiceNuevo,
                                        valor: valorNuevo
                                    },
                                    success : function (msg) {
                                        $("#modal-var").modal("hide");
                                        if(msg === 'ok'){
                                            log("Guardado correctamente","success");
                                            cargarTabla('${fp?.id}');
                                        }else{
                                            bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + "Error al guardar el Indice")
                                        }
                                    }
                                });
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            }
        });
        return false;
    });

    // decimales = 3;
    // tabla = $(".table");
    //
    // beforeDoEdit = function (sel, tf) {
    //     var tipo = sel.data("tipo");
    //     tf.data("tipo", tipo);
    // };
    //
    // textFieldBinds = {
    //     keyup : function () {
    //         var tipo = $(this).data("tipo");
    //         var td = $(this).parents("td");
    //         var val = $(this).val();
    //         var thTot = $("th." + tipo);
    //         var tds = $(".editable[data-tipo=" + tipo + "]").not(td);
    //
    //         var tot = parseFloat(val);
    //         tds.each(function () {
    //             tot += parseFloat($(this).data("valor"));
    //         });
    //         thTot.text(tot);
    //     }
    // };
    //
    // $(".editable").first().addClass("selected");

    %{--$("#btnSave").click(function () {--}%
    %{--    var str = "";--}%
    %{--    $(".editable").each(function () {--}%
    %{--        var td = $(this);--}%
    %{--        var id = td.data("id");--}%
    %{--        var valor = parseFloat(td.data("valor"));--}%
    %{--        var orig = parseFloat(td.data("original"));--}%

    %{--        if (valor !== orig) {--}%
    %{--            if (str !== "") {--}%
    %{--                str += "&";--}%
    %{--            }--}%
    %{--            str += "valor=" + id + "_" + valor;--}%
    %{--        }--}%
    %{--    });--}%
    %{--    if (str !== "") {--}%
    %{--        $.ajax({--}%
    %{--            type    : "POST",--}%
    %{--            url     : "${createLink(action:'saveCambiosPolinomica')}",--}%
    %{--            data    : str,--}%
    %{--            success : function (msg) {--}%
    %{--                var parts = msg.split("_");--}%
    %{--                var ok = parts[0];--}%
    %{--                var no = parts[1];--}%
    %{--                doHighlight({elem : $(ok), clase : "ok"});--}%
    %{--                doHighlight({elem : $(no), clase : "no"});--}%
    %{--                location.reload();--}%
    %{--            }--}%
    %{--        });--}%
    %{--    }--}%
    %{--    return false;--}%
    %{--});--}%

    $("#tabs").tabs({
        heightStyle : "fill",
        activate    : function (event, ui) {
            ui.newPanel.find(".editable").first().addClass("selected");
        }
    });

</script>