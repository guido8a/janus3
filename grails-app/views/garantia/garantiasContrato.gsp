<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Garantías contrato</title>

    <style type="text/css">
    .selected, .selected td {
        background : #B8D5DD !important;
    }

    .Renovada {
        background : #e5e5e5;
    }

    .Vigente {

    }

    .error {
        color : #aa1b17;
    }
    </style>

</head>

<body>

<div class="col-md-9 btn-group">
    <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-info btn-new" title="Regresar al contrato">
        <i class="fa fa-arrow-left"></i>
        Contrato
    </g:link>
    <a href="#" id="btnReporte" class="btn"><i class="fa fa-print"></i>
        Reporte
    </a>
    <a href="#" id="btnReporteGeneral" class="btn"><i class="fa fa-print"></i>
        Reporte General Garantías
    </a>
    <a href="#" id="btnReporteVenceran" class="btn"><i class="fa fa-print"></i>
        Reporte Grt. que vencerán
    </a>
    <a href="#" id="btnReporteDevueltas" class="btn"><i class="fa fa-print"></i>
        Reporte Grt. Devueltas
    </a>
    <a href="#" id="btnReporteVencidas" class="btn"><i class="fa fa-print"></i>
        Reporte Grt. Vencidas
    </a>
</div>

<div style="border-bottom: 1px solid black;padding-left: 50px;margin-top: 50px;position: relative; min-height: 150px;">
    <p class="css-vertical-text">Contrato</p>

    <div class="linea" style="height: 100px;"></div>

    <div class="col-md-12" style="margin-top: 5px">
        <div class="col-md-1">
            N. contrato
        </div>
        <div class="col-md-2">
            <span class="uneditable-input">${contrato?.codigo}</span>
        </div>
        <div class="col-md-1">
            Suscripción
        </div>
        <div class="col-md-2">
            <span class="uneditable-input">${contrato?.fechaSubscripcion?.format("dd-MM-yyyy")}</span>
        </div>
        <div class="col-md-1">
            Tipo Contrato
        </div>
        <div class="col-md-2">
            <span class="uneditable-input">${contrato?.tipoContrato?.descripcion}</span>
        </div>
        <div class="col-md-1">
            Monto
        </div>
        <div class="col-md-2">
            <span class="uneditable-input">${contrato?.monto}</span>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 5px">
        <div class="col-md-1">
            Proyecto
        </div>
        <div class="col-md-8">
            <span class="uneditable-input">${contrato?.oferta?.concurso?.obra?.descripcion}</span>
        </div>
        <div class="col-md-1">
            Fecha Inicio
        </div>
        <div class="col-md-2">
            <span class="uneditable-input">${contrato?.fechaInicio}</span>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 5px">
        <div class="col-md-1">
            Contratista
        </div>

        <div class="col-md-5">
            <span class="uneditable-input">${contrato?.oferta?.proveedor?.nombre}</span>
        </div>

        <div class="col-md-1">
            Memo Distrib.
        </div>

        <div class="col-md-2">
            <span class="uneditable-input">${contrato?.memo}</span>
        </div>

        <div class="col-md-1">
            Fecha Fin
        </div>

        <div class="col-md-2">
            <span class="uneditable-input">${contrato?.fechaFin}</span>
        </div>
    </div>
</div> <!-- Contrato -->

<form id="frmGarantia">
    <div style="border-bottom: 1px solid black;padding-left: 50px;margin-top: 10px;min-height: 160px;position: relative;">
        <p class="css-vertical-text">Garantía</p>

        <div class="linea" style="height: 100px;"></div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="col-md-1">
                Tipo
            </div>

            <div class="col-md-3">
                <g:select name="tipoGarantia" from="${janus.pac.TipoGarantia.list([sort: 'descripcion'])}" class="required" optionKey="id" optionValue="descripcion"/>
            </div>

            <div class="col-md-1">
                N. Garantía
            </div>

            <div class="col-md-2">
                <g:textField name="codigo" class="required allCaps"/>
            </div>

            <div class="col-md-2">
                Grnt. Original
            </div>

            <div class="col-md-2">
                <g:textField name="padre" class="allCaps" readonly="true"/>
            </div>
        </div>

        <div class="col-md-12">
            <div class="col-md-1">
                Aseguradora
            </div>

            <div class="col-md-3">
                <g:textField name="aseguradoraTxt" class=" required" readonly=""/>
                <g:hiddenField name="aseguradora" id="aseguradora" class="required"/>
                <a href="#" class="btn btn-xs btn-info" title="Buscar aseguradora" style="margin-top: -5px" id="btnBuscadorASG">
                    <i class="fa fa-search"></i>
                </a>
            </div>

            <div class="col-md-1">
                Documento
            </div>

            <div class="col-md-2">
                <g:select name="tipoDocumentoGarantia" from="${janus.pac.TipoDocumentoGarantia.list([sort: 'descripcion'])}" class="required" optionKey="id" optionValue="descripcion"/>
            </div>

            <div class="col-md-2">
                Monto
            </div>

            <div class="col-md-3 input-append">
                <g:textField name="monto" class="required number"/>
                <div class="btn-group" >
                    <button class="btn btn-xs dropdown-toggle" data-toggle="dropdown">
                        <span id="monedaSelected" data-id="${janus.pac.Moneda.findByCodigo("USD")?.id}" data-nombre="${janus.pac.Moneda.findByCodigo("USD")?.codigo}">
                            ${janus.pac.Moneda.findByCodigo("USD")?.codigo}
                        </span>
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu">
                        <g:each in="${janus.pac.Moneda.list([sort: 'codigo'])}" var="moneda">
                            <li id="mn-${moneda.id}" data-id="${moneda.id}" data-nombre="${moneda.codigo}" class="monedas ${moneda.codigo == 'USD' ? 'selected' : ''}">
                                <a>
                                    <g:if test="${moneda.codigo == 'USD'}">
                                        <i class="fa fa-money-bill" id="marcaMoneda"></i>
                                    </g:if>
                                    ${moneda.codigo}
                                </a>
                            </li>
                        </g:each>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 5px">
            <div class="col-md-1">
                Observaciones
            </div>
            <div class="col-md-10">
                <g:textField name="observaciones" class="form-control"/>
            </div>
        </div>

        <div class="col-md-12">
            <div class="col-md-1">
                Emisión
            </div>

            <div class="col-md-3">
                <input aria-label="" name="fechaInicio" id='fechaInicio' type='text' class="input-small required"  />
            </div>

            <div class="col-md-1">
                Vencimiento
            </div>

            <div class="col-md-2">
                <input aria-label="" name="fechaFinalizacion" id='fechaFinalizacion' type='text' class="input-small required"  />
            </div>

            <div class="col-md-2" >
                Días
            </div>

            <div class="col-md-1">
                <g:textField name="diasGarantizados" class="form-control required" readonly="true"/>
            </div>

            <div class="col-md-2">
                <div class="btn-toolbar" id="btnsAdd">
                    <div class="btn-group">
                        <a href="#" id="btnAdd" class="btn btn-success" rel="tooltip" title="Agregar">
                            <i class="fa fa-plus"></i>
                        </a>
                    </div>
                </div>

                <div class="btn-toolbar hide" id="btnsEdit">
                    <div class="btn-group">
                        <a href="#" id="btnNew" class="btn btn-xs btn-info" rel="tooltip" title="Nuevo">
                            <i class="fa fa-file"></i>
                        </a>
                        <g:hiddenField name="id"/>
                        <a href="#" id="btnSave" class="btn btn-xs btn-success" rel="tooltip" title="Guardar">
                            <i class="fa fa-save"></i>
                        </a>
                        <a href="#" id="btnRenew" class="btn btn-xs" rel="tooltip" title="Renovar">
                            <i class="fa fa-retweet"></i>
                        </a>
                        <a href="#" id="btnDelete" class="btn btn-xs btn-danger" rel="tooltip" title="Eliminar">
                            <i class="fa fa-trash"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div> <!-- nueva garantia -->
</form>

<div style="border-bottom: 1px solid black;padding-left: 50px;margin-top: 10px;position: relative; min-height: 150px;">
    <p class="css-vertical-text">Garantías</p>

    <div class="linea" style="height: 100px;"></div>

    <table class="table table-bordered table-condensed table-hover table-stripped">
        <thead>
        <tr>
            <th>Tipo</th>
            <th>N. Garantía</th>
            <th>Aseguradora</th>
            <th>Documento</th>
            <th>Estado</th>
            <th>Emisión</th>
            <th>Vencimiento</th>
            <th>Monto</th>
            <th style="width: 65px;">Acciones</th>
        </tr>
        </thead>
        <tbody id="tbGarantias">
        </tbody>
    </table>

</div> <!-- garantias -->


<div class="modal grandote hide fade" id="modal-busqueda" style="overflow: hidden">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">x</button>

        <h3 id="modalTitle_busqueda">Aseguradoras</h3>
    </div>

    <div class="modal-body" id="modalBody">
        <bsc:buscador name="aseguradoras" value="" accion="buscaAseguradora" controlador="garantia" campos="${campos}" label="Garantía" tipo="lista"/>
    </div>

    <div class="modal-footer" id="modalFooter_busqueda">

    </div>

</div>



<div class="modal large hide fade" id="modal-presupuesto">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle-presupuesto"></h3>
    </div>

    <div class="modal-body" id="modalBody-presupuesto">
    </div>

    <div class="modal-footer" id="modalFooter-presupuesto">
    </div>
</div>


<script type="text/javascript">

    var bcpp;

    $('#fechaInicio, #fechaFinalizacion').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        widgetPositioning: {
            horizontal: "left",
            vertical: "top"
        },
        icons: {
        }
    });

    var $frm = $("#frmGarantia"), $monedaSelected = $("#monedaSelected"), $body = $("#tbGarantias");

    $("#fechaInicio, #fechaFinalizacion").on("dp.change" , function () {
        ff();
    });

    function ff () {
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'garantia', action: 'verificarFecha_ajax')}',
            data:{
                fecha1: $("#fechaInicio").val(),
                fecha2: $("#fechaFinalizacion").val()
            },
            success: function (msg){
                $("#diasGarantizados").val(msg);
            }
        })
    }

    $("#btnBuscadorASG").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'garantia', action:'buscadorAseguradora_ajax')}",
            data    : {},
            success : function (msg) {
                bcpp = bootbox.dialog({
                    id      : "dlgBuscarASG",
                    title   : "Buscar Aseguradora",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    function cerrarBuscadorASG(){
        bcpp.modal("hide")
    }

    function rowsIniciales() {
        var g = <elm:poneHtml textoHtml='${garantias}'/>
        for (var i = 0; i < g.length; i++) {
            addRow(g[i], "last");
        }
    }

    function reset() {
        $(".selected").removeClass("selected");
        $frm.find("input").val("");
        $("#tipoGarantia option:first").attr('selected', 'selected');
        $("#tipoDocumentoGarantia option:first").attr('selected', 'selected');
    }

    function loadForm(data) {
        $.each(data, function (k, v) {
            if (k === "moneda") {
                var id = v;
                var $s = $("#mn-" + id);
                var nombre = $s.data("nombre");
                $monedaSelected.data({id : id, nombre : nombre}).text(nombre);
                $s.children("a").prepend($("#marcaMoneda"));
            } else {
                $("#" + k).val(v);
            }
        });
    }

    function botones(tipo) {
        var $add = $("#btnsAdd"), $edit = $("#btnsEdit");
        switch (tipo.toLowerCase()) {
            case "edit":
                $add.addClass('hide');
                $edit.removeClass('hide');
                break;
            case "create":
                reset();
                $edit.addClass('hide');
                $add.removeClass('hide');
                break;
        }
    }


    function clicks($tr) {
        $tr.dblclick(function (ev) {
            if ($(this).hasClass("1") || $(this).hasClass("2")) {
                padreCod = $tr.data("codigo");
                $(".selected").removeClass("selected");
                $(this).addClass("selected");
                loadForm($(this).data());
                botones("edit");
            }
        });
    }

    function updateRow(data) {
        var $tr = $("#" + data.id);
        $.each(data, function (k, v) {
            if (k === "monto") {
                $tr.find(".monto").text(number_format(data.monto, 2, ".", ",") + " " + data.monedaTxt)
            } else {
                $tr.find("." + k).text(v);
            }
        });
        botonesRow(data.estadoCdgo, data.id, $tr.find(".acciones"));
        $tr.attr("title", data.observaciones);
    }

    function cambiarEstado(id, estado, title) {
        bootbox.prompt({
            size: 'small',
            title: title,
            callback: function(result) {
                if(result){
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'cambiarEstado')}",
                        data    : {
                            id     : id,
                            estado : estado,
                            obs    : result
                        },
                        success : function (msg) {
                            if (msg !== "NO") {
                                updateRow($.parseJSON(msg));
                            }
                        }
                    });
                }
            }
        });
    }

    function botonesRow(estado, id, $td) {
        $td.empty();
        switch (estado) {
            case "1": // Vigente
                var $devolver = $("<a href='#' class='btn btn-xs btn-warning' title='Devolver'><i class='fa fa-reply'></i></a>");
                var $pedirCobro = $("<a href='#' class='btn btn-xs btn-success' title='Pedir Cobro'><i class='fa fa-check'></i></a>");

                $devolver.click(function () {
                    cambiarEstado(id, 3, "Devolver garantía");
                });
                $pedirCobro.click(function () {
                    cambiarEstado(id, 2, "Pedir cobro de garantía");
                });

                $td.append($devolver).append($pedirCobro);
                break;
            case "2": // Pedido de cobro
                var $efectivizar = $("<a href='#' class='btn btn-xs btn-success' title='Efectivizar'><i class='fa fa-archive'></i></a>");
                $efectivizar.click(function () {
                    cambiarEstado(id, 4, "Efectivizar garantía");
                });
                $td.append($efectivizar);
                break;
            case  "3" : // Devuelta
                break;
            case "4" : //Efectivizada
                break;
            case "5" : //Renovada
                break;
        }
    }

    function addRow(data, position) {
        var $tr = $("<tr></tr>").data(data).attr("id", data.id).addClass(data.estadoTxt).addClass(data.estadoCdgo).attr('etdo',data.estadoTxt);
        //Tipo  #   aseguradora     docu        estado      emision     vencimiento     monto
        var $tipo = $("<td class='tipoGarantiaTxt'></td>").text(data.tipoGarantiaTxt);
        var $num = $("<td class='codigo'></td>").text(data.codigo);
        var $aseguradora = $("<td class='aseguradoraTxt'></td>").text(data.aseguradoraTxt);
        var $doc = $("<td class='tipoDocumentoGarantiaTxt'></td>").text(data.tipoDocumentoGarantiaTxt);
        var $estado = $("<td class='estadoTxt'></td>").text(data.estadoTxt);
        var $emision = $("<td class='fechaInicio'></td>").text(data.fechaInicio);
        var $vencimiento = $("<td class='fechaFinalizacion'></td>").text(data.fechaFinalizacion);
        var $monto = $("<td class='monto'></td>").text(number_format(data.monto, 2, ".", ",") + " " + data.monedaTxt);

        var $acc = $("<td class='acciones'></td>");
        botonesRow(data.estadoCdgo, data.id, $acc);

        $tr.append($tipo).append($num).append($aseguradora).append($doc).append($estado).append($emision).append($vencimiento).append($monto).append($acc);

        $tr.attr("title", data.observaciones);
        clicks($tr);
        switch (position.toLowerCase()) {
            case "first":
                $body.prepend($tr);
                break;
            case "last":
                $body.append($tr);
                break;
            case "selected":
                var $padre = $("tr.selected");
                $padre.after($tr);
                break;
        }
        reset();
    }
    var padreCod;
    $(function () {
        rowsIniciales();

        $('[rel=tooltip]').tooltip();

        $(".monedas").click(function () {
            var id = $(this).data("id");
            var nombre = $(this).data("nombre");
            $monedaSelected.data({id : id, nombre : nombre}).text(nombre);
            $(this).children("a").prepend($("#marcaMoneda"));
        });

        $("#aseguradoraTxt").focus(function () {
            $("#modal-busqueda").modal("show");
        });

        $("#btnReporte").click(function () {
            location.href="${createLink(controller: 'reportes', action: '_garantiasContrato')}/${contrato?.id}";
        });

        $("#btnReporteGeneral").click(function () {
            location.href = "${createLink(controller: 'reportes3',action: 'reporteGarantias')}"
        });

        $("#btnReporteVenceran").click(function () {
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'garantia', action: 'fechas_ajax')}",
                success: function (msg) {

                    var b = bootbox.dialog({
                        id      : "dlgImprimir",
                        title   : "Garantías que vencerán para el período",
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
                                label     : "<i class='fa fa-print'></i> Imprimir",
                                className : "btn-success",
                                callback  : function () {
                                    location.href = "${g.createLink(controller: 'reportes3', action:'reporteGarantiasVenceran' )}?desde=" + $("#fechaDesde").val() + "&hasta=" + $("#fechaHasta").val()
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                }
            });
            return false;
        });

        $("#btnReporteDevueltas").click(function () {
            location.href = "${g.createLink(controller: 'reportes3', action:'reporteGarantiasDevueltas')}"
        });

        $("#btnReporteVencidas").click(function () {
            location.href = "${g.createLink(controller: 'reportes3', action:'reporteGarantiasVencidas')}"
        });

        $frm.validate();

        $("#btnAdd, #btnSave, #btnRenew").click(function () {
            var btn = $(this).attr("id");
            if (btn === "btnRenew") {
                $("#tipoGarantia").val($("tr.selected").data("tipoGarantia"));
            }
            if ($frm.valid()) {
                var data = {
                    contrato                 : ${contrato?.id},
                    tipoGarantiaTxt          : $("#tipoGarantia option:selected").text(),
                    tipoGarantia             : $("#tipoGarantia").val(),
                    codigo                   : $("#codigo").val(),
                    aseguradoraTxt           : $("#aseguradoraTxt").val(),
                    aseguradora              : $("#aseguradora").val(),
                    tipoDocumentoGarantiaTxt : $("#tipoDocumentoGarantia option:selected").text(),
                    tipoDocumentoGarantia    : $("#tipoDocumentoGarantia").val(),
                    monto                    : $("#monto").val(),
                    monedaTxt                : $monedaSelected.data("nombre"),
                    moneda                   : $monedaSelected.data("id"),
                    fechaInicio              : $("#fechaInicio").val(),
                    fechaFinalizacion        : $("#fechaFinalizacion").val(),
                    diasGarantizados         : $("#diasGarantizados").val(),
                    estado                   : 1,
                    estadoTxt                : 'Vigente',
                    estadoCdgo               : 1,
                    tipo                     : "add",
                    observaciones            : $("#observaciones").val()
                };
                var continua = true;
                if (btn === "btnAdd") {
                    $body.children("tr").each(function () {
//                                console.log('..etdo......', $(this).attr("etdo").toString())
                        if ($(this).data("tipoGarantia").toString() === data.tipoGarantia.toString() &&
                            $(this).attr("etdo").toString() === "Vigente" ) {
                            continua = false;
                        }
                    });
                } else if (btn === "btnEdit") {
                    data.id = $("#id").val();
                    data.tipo = "edit";
                } else if (btn === "btnRenew") {
                    data.id = $("#id").val();
                    data.tipo = "renew";
                    data.padre = padreCod;
                }
                if (continua) {
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'addGarantiaContrato')}",
                        data    : data,
                        success : function (msg) {
                            var parts = msg.split("_");
                            if (parts[0] === "OK") {
                                if (btn === "btnAdd") {
                                    data.id = parts[1];
                                    addRow(data, "first");
                                } else if (btn === "btnEdit") {
                                    updateRow(data);
                                } else if (btn === "btnRenew") {
                                    $("tr.selected").addClass("Renovada").data({
                                        estadoTxt : "Renovada",
                                        estado    : 6
                                    }).find(".estadoTxt").text("Renovada");

                                    data.id = parts[1];
                                    addRow(data, "selected");
                                    botones("create");
                                }
                                reset();
                            } else {
                            }
                        }
                    });
                } else {
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Solamente puede ingresar una garantía de cada tipo" + '</strong>');
                }
            }
        }); //btn add / save / renew

        $("#btnNew").click(function () {
            botones("create");
        }); //btn new

        $("#btnDelete").click(function () {

            bootbox.confirm({
                title: "Alerta",
                message: "Está seguro de querer eliminar esta garantía? Esta acción no puede deshacerse",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Salir',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-trash"></i> Borrar',
                        className: 'btn-danger'
                    }
                },
                callback: function (result) {
                    if (result) {
                        $.ajax({
                            type    : "POST",
                            url     : "${createLink(action:'deleteGarantia')}",
                            data    : {
                                id : $("tr.selected").attr("id")
                            },
                            success : function (msg) {
                                if (msg === "OK") {
                                    $("tr.selected").remove();
                                    reset();
                                   log("Garantía borrada correctamente", "success");
                                } else {
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg + '</strong>');
                                }
                            }
                        });
                    }
                }
            });
        }); //btn delete
    });
</script>

</body>
</html>