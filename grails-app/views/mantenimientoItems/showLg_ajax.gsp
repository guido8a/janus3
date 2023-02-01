<legend>Precios de: ${item.nombre} (${item.unidad?.codigo?.trim()}) <br> Lista: ${lugarNombre}</legend>

<div style="height: 35px; width: 100%;">
    <div class="btn-group pull-left">
        <g:if test="${session.perfil.codigo in ['CSTO', 'RBRO']}">
            <a href="#" class="btn btn-primary" id="btnNew">
                <i class="fa fa-money-bill"></i>
                Nuevo Precio
            </a>
        %{--            <a href="#" class="btn btn-success btn-ajax" id="btnSave">--}%
        %{--                <i class="fa fa-save"></i>--}%
        %{--                Guardar--}%
        %{--            </a>--}%
            <g:if test="${item.departamento.subgrupo.grupoId == 2 || item.departamento.subgrupo.grupoId == 3}">
                <a href="#" class="btn btn-warning" id="btnCalc${item.departamento.subgrupo.grupoId}">
                    <i class="fa fa-gear"></i>
                    Calcular precio
                </a>
            </g:if>
        </g:if>
    </div>

    <g:if test="${item.departamento.subgrupo.grupoId == 2 || item.departamento.subgrupo.grupoId == 3}">
        <span style="margin-left: 10px;" id="spanRef">

        </span>
    </g:if>

    <g:if test="${item.departamento.subgrupo.grupoId == 2 || item.departamento.subgrupo.grupoId == 3}">
        <div class="btn-group pull-left">
            <a href="#" class="btn btn-primary" id="btnPrint" style="display: none; margin-left: 10px" data-id="${item.id}" data-nombre="${item.nombre}">
                <i class="fa fa-print"></i>
                Imprimir
            </a>
        </div>
    </g:if>
</div>

<div id="divTabla" style="height: 630px; width: 100%; overflow-x: hidden; overflow-y: auto;">
    <table class="table table-striped table-bordered table-hover table-condensed" id="tablaPrecios">
        <thead>
        <tr style="width: 100%">
            <g:if test="${lgar}">
                <th style="width: 35%">Lugar</th>
            </g:if>
            <th style="width: 20%">Fecha</th>
            <th class="precio" style="width: 19%">Precio</th>
            <th class="delete" style="width: 25%"></th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${precios}" var="precio" status="i">
            <tr style="width: 100%">
                <g:if test="${lgar}">
                    <td style="width: 35%">
                        ${precio.lugar.descripcion}
                    </td>
                </g:if>
                <td style="width: 20%">
                    <g:formatDate date="${precio.fecha}" format="dd-MM-yyyy"/>
                </td>

                <g:if test="${session.perfil.codigo == 'CSTO'}">
                    <td class="precio textRight " style="width: 19%" data-original="${precio.precioUnitario}" data-valor="${precio.precioUnitario}" id="${precio.id}" >
                        <g:formatNumber number="${precio.precioUnitario}" maxFractionDigits="5" minFractionDigits="5" format="##,#####0" locale='ec'/>
                    </td>
                %{--                    <td class="precio textRight ${precio.registrado != 'R' ? 'editable' : ''}" data-original="${precio.precioUnitario}" data-valor="${precio.precioUnitario}" id="${precio.id}">--}%
                %{--                        <g:formatNumber number="${precio.precioUnitario}" maxFractionDigits="5" minFractionDigits="5" format="##,#####0" locale='ec'/>--}%
                %{--                    </td>--}%

                    <td class="delete" style="width: 25%">
                        <g:if test="${precio?.registrado != 'R'}">
                            <a href="#" class="btn btn-info btn-xs btnEditar" title="Editar valor" data-id="${precio.id}">
                                <i class="fa fa-edit"></i>
                            </a>
                        </g:if>
                        <a href="#" class="btn btn-danger btn-xs ${precio.registrado != 'R' ? 'btnDelete' : 'btnDeleteReg'}" rel="tooltip" title="Eliminar" id="${precio.id}">
                            <i class="fa fa-trash"></i>
                        </a>
                        %{--                        <g:if test="${precio.registrado != 'R'}">--}%
                        %{--                            <a href="#" class="btn btn-danger btn-xs btnDelete" rel="tooltip" title="Eliminar" id="${precio.id}">--}%
                        %{--                                <i class="fa fa-trash"></i>--}%
                        %{--                            </a>--}%
                        %{--                        </g:if>--}%
                        %{--                        <g:else>--}%
                        %{--                            <a href="#" class="btn btn-danger btn-xs btnDeleteReg" rel="tooltip" title="Eliminar" id="${precio.id}">--}%
                        %{--                                <i class="fa fa-trash"></i>--}%
                        %{--                            </a>--}%
                        %{--                        </g:else>--}%
                    </td>
                </g:if>
                <g:else>
                    <td class="precio textRight" style="width: 19%" data-original="${precio.precioUnitario}" data-valor="${precio.precioUnitario}" id="${precio.id}">
                        <g:formatNumber number="${precio.precioUnitario}" maxFractionDigits="5" minFractionDigits="5" format="##,#####0" locale='ec'/>
                    </td>
                    <td class="delete" style="width: 25%">

                    </td>
                </g:else>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div class="modal hide fade" id="modal_lugar">
    <div class="modal-header" id="modal-header_lugar">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle_lugar"></h3>
    </div>

    <div class="modal-body" id="modalBody_lugar">
    </div>

    <div class="modal-footer" id="modalFooter_lugar">
    </div>
</div>

<div class="modal hide fade" id="modal-tree1">
    <div class="modal-header" id="modal-header-tree1">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle-tree1"></h3>
    </div>

    <div class="modal-body" id="modalBody-tree1">
    </div>

    <div class="modal-footer" id="modalFooter-tree1">
    </div>
</div>

<div class="modal big hide fade" id="modal-tree2">
    <div class="modal-header" id="modal-header-tree2">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle-tree2"></h3>
    </div>

    <div class="modal-body" id="modalBody-tree2" style="width: 970px;">
    </div>

    <div class="modal-footer" id="modalFooter-tree2">
    </div>
</div>

<div id="imprimirDialog">
    <fieldset>
        <div class="span3">
            Elija la fecha de validez del cálculo:
            <div class="span2" style="margin-top: 20px; margin-left: 50px">
                <elm:datepicker name="fechaCalculo" class="span24" id="fechaCalculoId" value="${new java.util.Date()}" style="width: 100px" minDate="new Date(${new Date().format('yyyy')},0,1)" maxDate="new Date(${new Date().format('yyyy')},11,31)"
                                readonly="true" />
            </div>
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            (ev.keyCode === 188 || ev.keyCode === 190 || ev.keyCode === 110) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    // $(".editable").first().addClass("selected");

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        createEditPrecio(id);
    });

    $("#btnNew").click(function () {
        createEditPrecio();
        %{--$.ajax({--}%
        %{--    type    : "POST",--}%
        %{--    url     : "${createLink(action:'formPrecio_ajax')}",--}%
        %{--    data    : {--}%
        %{--        item        : "${item.id}",--}%
        %{--        lugar       : "${lugarId}",--}%
        %{--        nombreLugar : "${lugarNombre}",--}%
        %{--        fecha       : "${fecha}",--}%
        %{--        all         : "${params.all}",--}%
        %{--        ignore      : "${params.ignore}"--}%
        %{--    },--}%
        %{--    success : function (msg) {--}%
        %{--        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');--}%
        %{--        var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-ok"></i> Guardar</a>');--}%

        %{--        btnSave.click(function () {--}%
        %{--            if ($("#frmSave").valid()) {--}%
        %{--                btnSave.replaceWith(spinner);--}%
        %{--            }--}%

        %{--            $.ajax({--}%
        %{--                type    : "POST",--}%
        %{--                url     : $("#frmSave").attr("action"),--}%
        %{--                data    : $("#frmSave").serialize(),--}%
        %{--                success : function (msg) {--}%
        %{--                    if (msg === "OK") {--}%
        %{--                        $("#modal-tree").modal("hide");--}%
        %{--                        var loading = $("<div></div>");--}%
        %{--                        loading.css({--}%
        %{--                            textAlign : "center",--}%
        %{--                            width     : "100%"--}%
        %{--                        });--}%
        %{--                        loading.append("Cargando....Por favor espere...<br/>").append(spinnerBg);--}%
        %{--                        $("#info").html(loading);--}%
        %{--                        $.ajax({--}%
        %{--                            type    : "POST",--}%
        %{--                            url     : "${createLink(action:'showLg_ajax')}",--}%
        %{--                            data    : {--}%
        %{--                                id       : "${params.id}",--}%
        %{--                                all      : "${params.all}",--}%
        %{--                                ignore   : "${params.ignore}",--}%
        %{--                                fecha    : "${params.fecha}",--}%
        %{--                                operador : "${params.operador}"--}%
        %{--                            },--}%
        %{--                            success : function (msg) {--}%
        %{--                                $("#info").html(msg);--}%
        %{--                            }--}%
        %{--                        });--}%
        %{--                    } else {--}%
        %{--                        var btnClose = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');--}%
        %{--                        $("#modalTitle").html("Error");--}%
        %{--                        $("#modalBody").html("Ha ocurrido un error al guardar");--}%
        %{--                        $("#modalFooter").html("").append(btnClose);--}%
        %{--                    }--}%
        %{--                }--}%
        %{--            });--}%

        %{--            return false;--}%
        %{--        });--}%

        %{--        $("#modalTitle").html("Crear Precio");--}%
        %{--        $("#modalBody").html(msg);--}%
        %{--        $("#modalFooter").html("").append(btnOk).append(btnSave);--}%
        %{--        $("#modal-tree").modal("show");--}%
        %{--        $("#fechaPrecio").val($("#fcDefecto").val())--}%
        %{--    }--}%
        %{--});--}%
        %{--return false;--}%
    });


    function createEditPrecio(precio) {
        var title = precio ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formPrecio_ajax')}",
            data    : {
                item        : "${item.id}",
                lugar       : "${lugarId}",
                nombreLugar : "${lugarNombre}",
                fecha       : "${fecha}",
                all         : "${params.all}",
                ignore      : "${params.ignore}",
                id: precio
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditP",
                    title : title + " precio",
                    // class : "modal-sm",
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
                                return submitFormPrecio();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitFormPrecio() {
        var $form = $("#frmSave");
        if ($form.valid()) {
            var data = $form.serialize();
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'OK'){
                        log(parts[1], "success");
                        setTimeout(function () {
                            if(tipoSeleccionado === 1){
                                cargarMateriales();
                                recargarMateriales();
                            }else if(tipoSeleccionado === 2){
                                cargarMano();
                                recargaMano();
                            }else{
                                cargarEquipo();
                                recargaEquipo();
                            }
                        }, 1000);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
        } else {
            return false;
        }
    }



    $("#btnSave").click(function () {
        $("#dlgLoad").dialog("open");
        var data = "";
        $(".editable").each(function () {
            var id = $(this).attr("id");
            var valor = $(this).data("valor");

            if (parseFloat(valor) > 0 && parseFloat($(this).data("original")) !== parseFloat(valor)) {
                if (data !== "") {
                    data += "&";
                }
                data += "item=" + id + "_" + valor;
            }
        });
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'actualizarPrecios_ajax')}",
            data    : data,
            success : function (msg) {
                $("#dlgLoad").dialog("close");
                var parts = msg.split("_");
                var ok = parts[0];
                var no = parts[1];
                doHighlight({elem : $(ok), clase : "ok"});
                doHighlight({elem : $(no), clase : "no"});
            }
        });
        return false;
    }); //btnSave

    $(".btnDelete").click(function () {
        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
        var btnSave = $('<a href="#"  class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

        var id = $(this).attr("id");
        btnSave.click(function () {
            btnSave.replaceWith(spinner);
            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'deletePrecio_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    if (msg === "OK") {
                        $("#modal-tree1").modal("hide");
                        log("Precio eliminado correctamente", false);
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(action:'showLg_ajax')}",
                            data    : {
                                id       : "${params.id}",
                                all      : "${params.all}",
                                ignore   : "${params.ignore}",
                                fecha    : "${params.fecha}",
                                operador : "${params.operador}"
                            },
                            success : function (msg) {
                                $("#info").html(msg);
                            }
                        });
                    } else {
                        $("#modal-tree1").modal("hide");
                        log(msg, true);
                    }
                }
            });
            return false;
        });

        $("#modalTitle-tree1").html("Confirmación");
        $("#modalBody-tree1").html("Está seguro de querer eliminar este precio?");
        $("#modalFooter-tree1").html("").append(btnOk).append(btnSave);
        $("#modal-tree1").modal("show");
        return false;
    });

    var valorSueldo;
    var id2;

    $("#btnCalc2").click(function () {

        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
        var btnCalc = $('<a href="#"  class="btn btn-success"><i class="icon-check"></i> Calcular</a>');
        var a = "${anioRef}";

        var $valor = $("<input type='number' placeholder='Sueldo " + (new Date().getFullYear()) + "'/> ");

        $valor.bind({
            keydown : function (ev) {
                var dec = 5;
                var val = $(this).val();
                if (ev.keyCode == 188 || ev.keyCode == 190 || ev.keyCode == 110) {
                    if (!dec) {
                        return false;
                    } else {
                        if (val.length == 0) {
                            $(this).val("0");
                        }
                        if (val.indexOf(".") > -1 || val.indexOf(",") > -1) {
                            return false;
                        }
                    }
                } else {
                    if (val.indexOf(".") > -1 || val.indexOf(",") > -1) {
                        if (dec) {
                            var parts = val.split(".");
                            var l = parts[1].length;
                            if (l >= dec) {
                                return false;
                            }
                        }
                    }
                }
                return validarNum(ev);
            }
        });

        btnCalc.click(function () {
            valorSueldo = $valor.val();

            $(this).replaceWith(spinner);

            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'calcPrecioRef_ajax')}",
                data    : {
                    precio : $valor.val()
                },
                success : function (msg) {
                    $("#modal-tree1").modal("hide");
                    $("#btnCalc").hide();
                    $("#spanRef").text("Precio ref: " + msg);
                    $("#btnPrint").show();

                }
            });

            return valorSueldo

        });

        var $p1 = $("<p>").html("Por favor ingrese el sueldo básico para el Obrero del año " + (new Date().getFullYear()));
        var $p2 = $("<p>").html($valor);
        var $div = $("<div>").append($p1).append($p2);

        $("#modalTitle-tree1").html("Cálculo del valor por Hora");
        $("#modalBody-tree1").html($div);
        $valor.focus();
        $("#modalFooter-tree1").html("").append(btnCancel).append(btnCalc);
        $("#modal-tree1").modal("show");

        return false;
    });

    $("#btnCalc3").click(function () {
        var btnCancel = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
        var btnCalc = $('<a href="#"  class="btn btn-success"><i class="icon-check"></i> Aceptar</a>');
        var a = "${anioRef}";

        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'calcPrecEq')}",
            data    : {
                item : ${item.id}
            },
            success : function (msg) {
                $("#modalTitle-tree2").html("Cálculo del valor por Hora de Equipos");
                $("#modalBody-tree2").html(msg);
                $("#modalFooter-tree2").html("").append(btnCancel).append(btnCalc);
                $("#modal-tree2").modal("show");
            }
        });

        btnCalc.click(function () {
            $("#modal-tree2").modal("hide");
            $("#btnCalc").hide();
            $("#spanRef").text("Precio ref: " + number_format(data.ch, 2, ".", ""));
        });

        return false;
    });

    $(".btnDeleteReg").click(function () {
        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
        var btnSave = $('<a href="#"  class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

        var $auto = $("<input type='password' placeholder='Autorización'/> ");

        var id = $(this).attr("id");
        btnSave.click(function () {
            var auto = $.trim($auto.val());
            if (auto !== "") {
                btnSave.replaceWith(spinner);
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action: 'deletePrecio_ajax')}",
                    data    : {
                        id   : id,
                        auto : $auto.val()
                    },
                    success : function (msg) {
                        if (msg === "OK") {
                            $("#modal-tree1").modal("hide");
                            log("Precio eliminado correctamente", false);
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(action:'showLg_ajax')}",
                                data    : {
                                    id       : "${params.id}",
                                    all      : "${params.all}",
                                    ignore   : "${params.ignore}",
                                    fecha    : "${params.fecha}",
                                    operador : "${params.operador}"
                                },
                                success : function (msg) {
                                    $("#info").html(msg);
                                }
                            });
                        } else {
                            $("#modal-tree1").modal("hide");
                            log(msg, true);
                        }
                    }
                });
            }
            return false;
        });

        var $p1 = $("<p>").html("Está seguro de querer eliminar este precio?");
        var $p2 = $("<p>").html("Este precio está registrado. Para eliminarlo necesita ingresar su clave de autorización.");
        var $p3 = $("<p>").html($auto);

        var $div = $("<div>").append($p1).append($p2).append($p3);

        $("#modalTitle-tree1").html("Confirmación");
        $("#modalBody-tree1").html($div);
        $("#modalFooter-tree1").html("").append(btnOk).append(btnSave);
        $("#modal-tree1").modal("show");
        return false;
    });

    $("#btnPrint").click(function () {
        $("#imprimirDialog").dialog("open");
    });

    $("#imprimirDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        dragable  : false,
        width     : 320,
        height    : 220,
        position  : 'center',
        title     : 'Elegir fecha de validez de cálculo',
        buttons   : {
            "Aceptar" : function () {
                console.log( $("#btnPrint").data("id"))
                location.href="${g.createLink(controller: 'reportes3',action: 'imprimirCalculoValor')}?valor=" + valorSueldo + "&fechaCalculo=" + $("#fechaCalculoId").val() + "&id=" +
                    $("#btnPrint").data("id")
                $("#imprimirDialog").dialog("close");

            },
            "Cancelar" : function () {

                $("#imprimirDialog").dialog("close");

            }
        }
    })

</script>