<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Volúmenes de obra
    </title>

    <asset:javascript src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.js"/>
    <asset:stylesheet src="/jquery/plugins/jQuery-contextMenu-gh-pages/src/jquery.contextMenu.css"/>

    <style type="text/css">
    .boton {
        padding: 2px 6px;
        margin-top: -10px
    }

    </style>
</head>

<body>
<div class="col-md-12" id="mensaje">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </g:if>
</div>

<div class="col-md-12 hide" style="margin-bottom: 10px;" id="divError">
    <div class="alert alert-error" role="status">
        <a class="close" data-dismiss="alert" href="#">×</a>
        <span id="spanError"></span>
    </div>
</div>

<div class="col-md-12 hide" style="margin-bottom: 10px;" id="divOk">
    <div class="alert alert-success" role="status">
        <a class="close" data-dismiss="alert" href="#">×</a>
        <span id="spanOk"></span>
    </div>
</div>

<div class="alert alert-info" style="font-size: 14px;">
    Volúmenes de la obra: ${obra.nombre + " (" + obra.codigo + ")"}
    <input type="hidden" id="override" value="0">
</div>
<div style="height: 25px; margin-bottom:10px; border-bottom: 1px solid rgba(148, 148, 148, 1);">
    <div class="col-md-2" style="margin-left: 150px;">
        <b>Memo:</b> ${obra?.memoCantidadObra}
    </div>
    <div class="col-md-3">
        <b>Ubicación:</b> ${obra?.parroquia?.nombre}
    </div>

    <div class="col-md-2">
        <b style="">Dist. peso:</b> ${obra?.distanciaPeso}
    </div>

    <div class="col-md-2" style="margin-left: -40px;">
        <b>Dist. volúmen:</b> ${obra?.distanciaVolumen}
    </div>

</div>

<div class="row">
    <div class="col-md-12 btn-group" role="navigation" style="margin-left: 35px;">
        <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}"
           class="btn btn-info btn-new" id="atras" title="Regresar a la obra">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
        <a href="#" class="btn btn-ajax btn-new" id="calcular" title="Calcular precios">
            <i class="fa fa-table"></i>
            Calcular
        </a>
        <a href="#" class="btn btn-ajax btn-new" id="reporteGrupos" title="Reporte Grupos/Subgrupos" style="display: none">
            <i class="fa fa-print"></i>
            Reporte Grupos/Subgrupos
        </a>
    </div>
</div>

<g:if test="${obra.valor > vmc}">
    <div style="margin-top: 10px;" id="tx-aviso">
        <div class="alert alert-warning" style="font-weight: bold; font-size: 13px;">
            <i class="icon icon-info-sign icon-2x pull-left"></i>
            <p>
                El presupuesto supera el límite de menor cuantía según lo registrado,
                por lo que no es obligatoria la elaboración de la fórmula polinómica ni cuadrilla tipo
                para registrar esta obra.
            </p>
            <g:if test="${obra.valor >= valorLicitacion}">
                <i class="icon icon-info-sign icon-2x pull-left"></i>
                <p>El presupuesto corresponde a una Licitación por lo que es obligatorio presentar el VAE.</p>
            </g:if>
        </div>
    </div>
</g:if>

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 20px;margin-left: 0px">
    <div class="borde_abajo" style="padding-left: 5px;position: relative; height: 92px">

        <div class="row-fluid" style="margin-left: 0px">
            <div class="col-md-3" style="width: 135px; ">
                <b>Tipo de Obra:</b><g:select name="grupos" id="grupos" from="${grupoFiltrado}" optionKey="id" optionValue="descripcion"
                                              style="margin-left: 0px; width: 130px; font-size: 11px" value="${janus.Grupo.findByDireccion(obra.departamento.direccion)?.id}"/>

            </div>

            <div class="row-fluid" style="margin-left: 0px">
                <div class="col-md-4" style="width: 450px">
                    <b>Crear Subpresupuesto / Ingresar Rubros:</b>
                    <span id="sp">
                        <span id="div_cmb_sub">
                            <g:select name="subpresupuesto" from="${subpreFiltrado}" optionKey="id" optionValue="descripcion"
                                      id="subPres"/>
                        </span>
                    </span>

                    <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
                        <a href="#" class="btn btn-success boton" id="btnCrearSP" title="Crear subpresupuesto" style="margin-top: -10px;">
                            <i class="fa fa-plus"></i>
                        </a>
                        <a href="#" class="btn btn-danger boton" id="btnBorrarSP" title="Borrar subpresupuesto" style="margin-top: -10px;">
                            <i class="fa fa-minus"></i>
                        </a>
                        <a href="#" class="btn boton btn-success" id="btnEditarSP" title="Editar subpresupuesto" style="margin-top: -10px;">
                            <i class="fa fa-edit"></i>
                        </a>
                    </g:if>
                </div>

                <div class="col-md-2">
                    <b>Código</b>
                    <input type="text" style="font-size: 10px" id="item_codigo" class="allCaps">
                    <input type="hidden" id="item_id">
                </div>

                <div class="col-md-3" style="margin-left: 1px;">
                    <b>Rubro</b>
                    <input type="text" style="width: 300px;font-size: 10px" id="item_nombre" readonly="">
                </div>

                <div class="col-md-12" role="main" style="margin-top: 20px;margin-left: -10px">
                    <div class="col-md-6" style="margin-left: 0px; width: 720px;">
                        <b>Descripción:</b>
                        <input type="text" style="width: 620px" id="item_descripcion" value="">
                    </div>
                    <div class="col-md-3" style="margin-left: 0px; width: 180px;" id="lbl_cntd">
                        <b>Cantidad:</b>
                        <input type="text" style="width: 90px;text-align: right" id="item_cantidad" value="">
                    </div>

                    <div class="col-md-1" style="margin-left: -10px; width: 120px;">
                        <b>Orden:</b>
                        <input type="text" style="width: 50px;text-align: right" id="item_orden"
                               value="${(volumenes?.size() > 0) ? volumenes.size() + 1 : 1}">
                    </div>

                    <div class="col-md-1" style="margin-left: -20px;margin-top:-5px; width: 85px;">
                        <input type="hidden" value="" id="vol_id">
                        <g:if test="${obra?.estado != 'R' && duenoObra == 1}">
                            <a href="#" class="btn btn-xs btn-primary" title="Agregar" id="item_agregar">
                                <i class="fa fa-plus"></i></a>
                            <a href="#" class="btn btn-xs btn-danger" title="Limpiar" id="item_limpiar">
                                <i class="fa fa-ban"></i></a>
                        </g:if>
                    </div>
                </div>
            </div>
        </div>

        <div style="margin-bottom:10px; border-bottom: 2px solid rgba(148, 148, 148, 1); height: 100px">
            &nbsp;&nbsp;&nbsp;
        </div>

        <div class="borde_abajo" style="position: relative;float: left;width: 100%;padding-left: 45px">
            <p class="css-vertical-text">Composición</p>

            <div class="linea" style="height: 98%;"></div>

            <div style="width: 99.7%;height: 600px;overflow-y: auto;float: right;" id="detalle"></div>

            <div style="width: 99.7%;height: 30px;overflow-y: auto;float: right;text-align: right" id="total">
                <b>TOTAL:</b>

                <div id="divTotal" style="width: 150px;float: right;height: 30px;font-weight: bold;font-size: 12px;margin-right: 20px"></div>
            </div>
        </div>
    </div>


    <div id="modal-SubPresupuesto">
        <div id="modalBody-sp">
        </div>

        <div class="modal-footer" id="modalFooter-sp">
        </div>
    </div>

    <div id="borrarSPDialog">
        <div class="col-md-12">
            Está seguro que desea borrar el subpresupuesto?
        </div>
    </div>

    <div id="listaRbro" style="overflow: hidden">
        <fieldset class="borde" style="border-radius: 4px">
            <div class="row-fluid" style="margin-left: 20px">
%{--                <div class="col-md-2">--}%
%{--                    Tipo--}%
%{--                    <g:select name="buscarTipo" class="buscarPor col-md-12" from="${listaRbro}" optionKey="key"--}%
%{--                              optionValue="value"/>--}%
%{--                </div>--}%
                <div class="col-md-2">
                    Buscar Por
                    <g:select name="buscarPor" class="buscarPor col-md-12" from="${listaItems}" optionKey="key"
                              optionValue="value"/>
                </div>
                <div class="col-md-2">Criterio
                <g:textField name="buscarCriterio" id="criterioCriterio" style="width: 80%"/>
                </div>
                <div class="col-md-2">Ordenado por
%{--                <g:select name="ordenar" class="ordenar" from="${listaRbro}" style="width: 100%" optionKey="key"--}%
%{--                          optionValue="value"/>--}%
                <g:select name="ordenar" class="ordenar" from="${listaItems}" style="width: 100%" optionKey="key"
                          optionValue="value"/>
                </div>
                <div class="col-md-2" style="margin-top: 6px">
                    <button class="btn btn-info" id="cnsl-rubros"><i class="fa fa-search"></i> Consultar
                    </button>
                </div>
            </div>
        </fieldset>
        <fieldset class="borde" style="border-radius: 4px">
            <div id="divTablaRbro" style="height: 460px; overflow: auto">
            </div>
        </fieldset>
    </div>

</div>

<script type="text/javascript">

    var aviso = false;  //aviso de TR...

    $("#tx-aviso").click(function () {
        var $btnOrig = $(this).addClass("hidden");
    });

    function loading(div) {
        y = 0;
        $("#" + div).html("<div class='tituloChevere' id='loading'>Sistema Janus - Cargando, Espere por favor</div>")
        var interval = setInterval(function () {
            if (y === 30) {
                $("#detalle").html("<div class='tituloChevere' id='loading'>Cargando, Espere por favor</div>")
                y = 0
            }
            $("#loading").append(".");
            y++
        }, 500);
        return interval
    }

    function cargarTabla() {
        var d = cargarLoader("Cargando...");
        var datos = "";
        if ($("#subPres_desc").val() * 1 > 0) {
            datos = "obra=${obra.id}&sub=" + $("#subPres_desc").val() + "&ord=" + 1
        } else {
            datos = "obra=${obra.id}&ord=" + 1
        }
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'volumenObra', action:'tabla')}",
            data     : datos,
            success  : function (msg) {
                d.modal("hide");
                $("#detalle").html(msg);
                $("#reporteGrupos").show()
            }
        });
    }
    $(function () {
        $("#grupos").change(function () {
            $.ajax({
                type    : "POST",
                url : "${g.createLink(controller: 'volumenObra',action:'cargarSubpres')}",
                data    : "grupo=" + $("#grupos").val(),
                success : function (msg) {
                    $("#div_cmb_sub").html(msg)
                }
            });
        });

        cargarTabla();
        $("#vol_id").val("");
        $("#calcular").click(function () {
            if ($(this).hasClass("active")) {
                $(this).removeClass("active");
                $(".col_delete").show();
                $(".col_precio").hide();
                $(".col_total").hide();
                $("#divTotal").html("")
            } else {
                $(this).addClass("active");
                $(".col_delete").hide();
                $(".col_precio").show();
                $(".col_total").show();
                var total = 0;

                $(".total").each(function () {
                    total += parseFloat(str_replace(",", "", $(this).html()))
                });

                if ($("#subPres_desc").val() === "-1") {
                    $.ajax({
                        type    : "POST",
                        url : "${g.createLink(controller: 'volumenObra', action:'setMontoObra')}",
                        data    : "obra=${obra?.id}&monto=" + total,
                        success : function (msg) {
                        }
                    });
                }
                $("#divTotal").html(number_format(total, 4, ".", ","))
            }
        });

        $("#listaRbro").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 1000,
            height: 500,
            position: 'center',
            title: 'Rubros'
        });

        $("#item_codigo").dblclick(function () {
            $("#listaRbro").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        });

        $("#cnsl-rubros").click(function () {
            buscaRubros();
        });

        function buscaRubros() {
            var buscarPor = $("#buscarPor").val();
            // var tipo = $("#buscarTipo").val();
            var criterio = $("#criterioCriterio").val();
            var ordenar = $("#ordenar").val();
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'volumenObra', action:'listaRubros')}",
                data: {
                    buscarPor: buscarPor,
                    // buscarTipo: tipo,
                    criterio: criterio,
                    ordenar: ordenar
                },
                success: function (msg) {
                    $("#divTablaRbro").html(msg);
                }
            });
        }

        $("#criterioCriterio").keydown(function (ev) {
            if (ev.keyCode === 13) {
                ev.preventDefault();
                buscaRubros();
                return false;
            }
        });

        $("#reporteGrupos").click(function () {
            location.href = "${g.createLink(controller: 'reportes',action: 'reporteSubgrupos',id: obra?.id)}"
        });

        $("#item_codigo").blur(function () {
            if ($("#item_id").val() === "" && $("#item_codigo").val() !== "") {
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'volumenObra',action:'buscarRubroCodigo')}",
                    data     : "codigo=" + $("#item_codigo").val(),
                    success  : function (msg) {
                        if (msg !== "-1") {
                            var parts = msg.split("&&");
                            $("#item_id").val(parts[0]);
                            $("#item_nombre").val(parts[2])
                        } else {
                            $("#item_id").val("");
                            $("#item_nombre").val("")
                        }
                    }
                });
            }
        });

        $("#item_codigo").keydown(function (ev) {
            if (ev.keyCode * 1 !== 9 && (ev.keyCode * 1 < 37 || ev.keyCode * 1 > 40)) {
                $("#item_id").val("");
                $("#item_nombre").val("")
            } else {
            }
        });

        $("#modal-SubPresupuesto").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 600,
            height: 300,
            position: 'center',
            title: 'Crear Sub Presupuesto'
        });

        $("#btnCrearSP").click(function () {
            var $btnOrig = $(this).clone(true);

            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:"subPresupuesto",action:'form_ajax')}?obra=" + ${obra?.id},
                success : function (msg) {
                    $("#modalBody-sp").html(msg);

                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    var $frm = $("#frmSave-SubPresupuesto");

                    btnSave.click(function () {
                        spinner.replaceWith($btnOrig);
                        if ($frm.valid()) {
                            btnSave.replaceWith(spinner);
                        }
                        var data = $frm.serialize();

                        $.ajax({
                            type    : "POST",
                            url     : $frm.attr("action"),
                            data    : data,
                            success : function (msg) {
                                var p = msg.split("_");
                                var alerta;

                                console.log('retorna', msg);
                                if (msg !== "NO") {
                                    alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                    alerta += p[1];
                                    alerta += '</div>';
                                    $("#modal-SubPresupuesto").dialog("close");
                                    $("#div_cmb_sub").html(p[2])
                                }
                                else {
                                    alerta = '<div class="alert alert-error" role="status">' +
                                        '<a class="close" data-dismiss="alert" href="#">×</a>';
                                    alerta += p[1];
                                    alerta += '</div>';
                                }
                                $("#mensaje").html(alerta);
                            }
                        });

                        return false;
                    });

                    btnOk.click(function () {
                        spinner.replaceWith($btnOrig);
                        $("#modal-SubPresupuesto").dialog("close");
                    });

                    $("#modalHeader-sp").removeClass("btn-edit btn-show btn-delete");
                    $("#modalFooter-sp").html("").append(btnOk).append(btnSave);
                    $("#modal-SubPresupuesto").dialog("open");
                    $(".ui-dialog-titlebar-close").html("x");
                    $("#volob").val("1");
                }
            });
            return false;
        });

        $("#btnBorrarSP").click(function () {
            $("#borrarSPDialog").dialog("open")
        });

        $("#btnEditarSP").click(function () {
            var $btnOrig = $(this).clone(true);

            var idSp = $("#subPres").val();
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:"subPresupuesto",action:'form_ajax')}",
                data    : {
                    id : idSp
                },
                success : function (msg) {
                    $("#modalBody-sp").html(msg);

                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');
                    var $frm = $("#frmSave-SubPresupuesto");

                    btnSave.click(function () {
                        spinner.replaceWith($btnOrig);
                        if ($frm.valid()) {
                            btnSave.replaceWith(spinner);
                        }
                        var data = $frm.serialize();

                        $.ajax({
                            type    : "POST",
                            url     : $frm.attr("action"),
                            data    : data,
                            success : function (msg) {

                                var p = msg.split("_");
                                var alerta;

                                if (msg !== "NO") {
                                    $("#modal-SubPresupuesto").dialog("close");

                                    alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                    alerta += p[1];
                                    alerta += '</div>';
                                    $("#modal-SubPresupuesto").dialog("close");
                                    $("#div_cmb_sub").html(p[2])

                                } else {
                                    alerta = '<div class="alert alert-error" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                    alerta += p[1];
                                    alerta += '</div>';
                                }
                                $("#mensaje").html(alerta);
                            }
                        });
                        return false;
                    });

                    btnOk.click(function () {
                        spinner.replaceWith($btnOrig);
                        $("#modal-SubPresupuesto").dialog("close");
                    });

                    $("#modalHeader-sp").removeClass("btn-edit btn-show btn-delete");
                    $("#modalTitle-sp").html("Editar Sub Presupuesto");
                    $("#modalFooter-sp").html("").append(btnOk).append(btnSave);
                    $("#modal-SubPresupuesto").dialog("open");

                    $("#volob").val("1");
                }
            });
            return false;

        });

        $("#borrarSPDialog").dialog({

            autoOpen  : false,
            resizable : false,
            modal     : true,
            draggable : false,
            width     : 350,
            height    : 180,
            position  : 'center',
            title     : 'Borrar Subpresupuesto',
            buttons   : {
                "Aceptar"  : function () {

                    var id = $("#subPres").val();

                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller:"subPresupuesto",action:'delete2')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var p = msg.split("_");
                            var alerta;
                            if (msg !== "NO") {

                                alerta = '<div class="alert alert-success" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                alerta += p[1];
                                alerta += '</div>';

                                $("#div_cmb_sub").html(p[2])
                            } else {
                                alerta = '<div class="alert alert-error" role="status"><a class="close" data-dismiss="alert" href="#">×</a>';
                                alerta += p[1];
                                alerta += '</div>';
                            }
                            $("#mensaje").html(alerta);
                        }
                    });
                    $("#borrarSPDialog").dialog("close");
                },
                "Cancelar" : function () {
                    $("#borrarSPDialog").dialog("close");
                }
            }
        });

        $("#item_limpiar").click(function () {
            $("#vol_id").val("");
            $("#item_codigo").val("");
            $("#item_id").val("");
            $("#item_nombre").val("");
            $("#item_cantidad").val("");
            $("#item_descripcion").val("");
            $("#item_orden").val($("#item_orden").val() * 1 + 1);
            $("#override").val("0")
        });

        $("#item_agregar").click(function () {
            var d = cargarLoader("Guardando...");
            $("#calcular").removeClass("active");
            $(".col_delete").show();
            $(".col_precio").hide();
            $(".col_total").hide();
            $("#divTotal").html("");

            var cantidad = $("#item_cantidad").val();
            cantidad = str_replace(",", "", cantidad);
            var orden = $("#item_orden").val();
            var rubro = $("#item_id").val();
            var cod = $("#item_codigo").val();
            var sub = $("#subPres").val();
            var dscr = $("#item_descripcion").val();
            if (isNaN(cantidad))
                cantidad = 0;
            if (isNaN(orden))
                orden = 0;
            var msn = "";
            if (cantidad * 1 < 0.00001 || orden * 1 < 1) {
                msn = "La cantidad  y el orden deben ser números positivos mayores a 0"
            }
            if (rubro * 1 < 1)
                msn = "seleccione un rubro";

            if (msn.length === 0) {
                var datos = "rubro=" + rubro + "&cantidad=" + cantidad + "&orden=" + orden + "&sub=" + sub +
                    "&obra=${obra.id}" + "&cod=" + cod + "&ord=" + '1&override=' + $("#override").val() +
                    "&dscr=" + dscr;
                if ($("#vol_id").val() * 1 > 0)
                    datos += "&id=" + $("#vol_id").val();
                $.ajax({type : "POST", url : "${g.createLink(controller: 'volumenObra',action:'addItem')}",
                    data     : datos,
                    success  : function (msg) {
                    d.modal("hide");
                        if (msg !== "error") {
                            $("#detalle").html(msg)
                            $("#vol_id").val("")
                            $("#item_codigo").val("")
                            $("#item_id").val("")
                            $("#item_nombre").val("")
                            $("#item_cantidad").val("")
                            $("#item_descripcion").val("")
                            $("#item_orden").val($("#item_orden").val() * 1 + 1)
                            $("#override").val("0")
                        } else {
                            if (confirm("El item ya existe dentro del volumen de obra. Desea incrementar la cantidad?")) {
                                $("#override").val("1")
                                $("#item_agregar").click()
                            } else {
                                $("#vol_id").val("")
                                $("#item_codigo").val("")
                                $("#item_id").val("")
                                $("#item_nombre").val("")
                                $("#item_cantidad").val("")
                                $("#item_orden").val($("#item_orden").val() * 1 + 1)
                            }
                        }
                    }
                });
            } else {
                d.modal("hide");
                $.box({
                    imageClass : "box_info",
                    text       : msn,
                    title      : "Alerta",
                    iconClose  : false,
                    dialog     : {
                        resizable : false,
                        draggable : false,
                        buttons   : {
                            "Aceptar" : function () {
                            }
                        },
                        width     : 500
                    }
                });
            }

        });

        $(document).ready(function () {
            $("#grupos").trigger("change");
        });

        function alerta(titl, mnsj)
        {
            $("<div></div>").html(mnsj).dialog({
                title: titl,
                resizable: false,
                modal: true,
                buttons: {
                    "Aceptar": function()
                    {
                        $( this ).dialog( "close" );
                    }
                }
            });
        }

        $("#item_cantidad").focus(function () {
            if (($("#item_nombre").val()) && ($("#item_codigo").val().substr(0, 2) == 'TR') && !aviso) {
                aviso = true;
                alerta("Rubro para transporte", "Debe registrar la distancia de desalojo en Variables de " +
                    "la obra, en la sección Transporte Especial");
            }
        });
    });
</script>
</body>
</html>