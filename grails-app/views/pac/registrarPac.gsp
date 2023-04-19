<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        P.A.C.
    </title>
    <style type="text/css">
    td {
        font-size : 10px !important;
    }

    th {
        font-size : 11px !important;
    }
    </style>
</head>

<body>
<div class="col-md-12">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            <elm:poneHtml textoHtml="${flash.message}"/>
        </div>
    </g:if>
</div>

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 1px;">
    <div class="borde_abajo" style="padding-left: 45px;position: relative; height: 200px; border-bottom: solid;
    border-width: 1px">
        <p class="css-vertical-text">P.A.C.</p>

        <div class="linea" style="height: 98%;"></div>

        <div class="row" style="margin-left: 1px">
            <div class="col-md-1">
                <b>Año:</b>
                <g:select name="anio" from="${janus.pac.Anio.list([sort: 'anio'])}" id="item_anio" optionValue="anio" optionKey="id" value="${actual.id}" style="width: 80px;font-size: 14px; font-weight: bold "/>
            </div>

            <div class="col-md-3">
                <b>Partida presupuestaria:</b>
                <input type="text" style="width: 170px;font-size: 12px" id="item_presupuesto" readonly >
                <input type="hidden" id="item_prsp">
                <a href="#" class="btn btn-xs btn-info" title="Buscar presupuesto" style="margin-top: -5px" id="btnBuscarPresupuesto">
                    <i class="fa fa-search"></i>
                </a>
                <a href="#" class="btn btn-xs btn-warning" title="Crear nueva partida" style="margin-top: -5px" id="item_agregar_prsp">
                    <i class="fa fa-edit"></i>
                </a>
            </div>

            <div class="col-md-2">
                <b>Techo:</b>
                <input type="text" id="techo" disabled="" style="width: 120px;;text-align: right" class="form-control">
            </div>

            <div class="col-md-2">
                <b>Comprometido:</b>
                <input type="text" id="usado" disabled="" style="width: 120px;;text-align: right" class="form-control">
            </div>

            <div class="col-md-2">
                <b>Disponible:</b>
                <input type="text" id="disponible" disabled="" style="width: 120px;text-align: right" class="form-control">
            </div>
        </div>

        <div class="row" style="margin-left: 1px">
            <div class="col-md-4">
                <b>Requirente:</b>
                <input type="text" id="item_req" style="width: 250px; font-size: 12px;">
            </div>

            <div class="col-md-3">
                <b>Memorando:</b>
                <input class="allCaps" type="text" id="item_memo" style="width: 156px; font-size: 12px;">
            </div>

            <div class="col-md-4">
                <b>Coordinación:</b>
                <input type="hidden" id="item_id">
                <g:select name="presupuesto.id" from="${janus.Departamento.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" style="width: 250px;;font-size: 12px" id="item_depto"/>
            </div>
        </div>

        <div class="row" style="margin-left: 0px">
            <div class="col-md-4">
                <b>Tipo procedimiento:</b>
                <g:select name="tipoProcedimiento.id" from="${janus.pac.TipoProcedimiento.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" style="width: 213px;;font-size: 12px" id="item_tipoProc"/>
            </div>

            <div class="col-md-4">
                <b>Código C.P.:</b>
                <input type="text" style="width: 154px;font-size: 12px" id="item_codigo" readonly>
                <input type="hidden" id="item_cpac">
                <a href="#" class="btn btn-xs btn-info" title="buscar código CP" style="margin-top: -5px" id="btnBuscadorCPC">
                    <i class="fa fa-search"></i>
                </a>
            </div>

            <div class="col-md-4">
                <b>Tipo compra:</b>
                <g:select name="tipo" from="${janus.pac.TipoCompra.list([sort: 'descripcion'])}" optionKey="id" optionValue="descripcion" style="width: 120px;;font-size: 12px; margin-left: 6px;" id="item_tipo"/>
            </div>
        </div>

        <div class="row" style="margin-left: 1px">
            <div class="col-md-4" style="width: 400px;">
                <b>Descripción:</b>
                <input type="text" style="width: 400px;font-size: 12px" id="item_desc">
            </div>
            <div class="col-md-2">
                <b>Cantidad:</b>
                <input type="text" style="width: 100px;text-align: right" id="item_cantidad" value="1">
            </div>

            <div class="col-md-2" style="margin-left: -40px;">
                <b>Costo unitario:</b>
                <input type="text" style="width: 123px;text-align: right" id="item_precio" value="1">
            </div>

            <div class="col-md-1" style="margin-left: -10px;">
                <b>Unidad:</b>
                <g:select name="unidad.id" from="${janus.pac.UnidadIncop.list()}" id="item_unidad" optionKey="id" optionValue="codigo" style="width: 60px;font-size: 12px"/>
            </div>

            <div class="col-md-2">
                <b>Cuatrimestre:</b>

                <div class="btn-group" data-toggle="buttons-checkbox">
                    <button type="button" id="item_c1" class="btn btn-xs btn-info" style="font-size: 14px; width: 40px"> C.1</button>
                    <button type="button" id="item_c2" class="btn btn-xs btn-info" style="font-size: 14px; width: 40px"> C.2</button>
                    <button type="button" id="item_c3" class="btn btn-xs btn-info" style="font-size: 14px; width: 40px"> C.3</button>
                </div>
            </div>

            <div class="col-md-1" style="margin-left: -30px;padding-top:20px; width:100px;">
                <input type="hidden" value="" id="vol_id">
                <a href="#" class="btn btn-xs btn-success" title="Agregar" style="margin-top: -10px" id="item_agregar">
                    <i class="fa fa-plus"></i>
                </a>
                <g:link action="formUploadPac" class="btn btn-xs" title="Subir Excel" style="margin-top: -10px" id="btnUpload">
                    <i class="fa fa-upload"></i>
                </g:link>
            </div>
        </div>
    </div>

    <div class="borde_abajo" style="position: relative;float: left;width: 100%;padding-left: 45px">
        <p class="css-vertical-text">Detalle</p>

        <div class="linea" style="height: 98%;"></div>

        <div style="width: 99.7%;height: 580px;overflow-y: auto;float: right;" id="detalle"></div>
    </div>
</div>

<script type="text/javascript">

    var bcpc;
    var bcpp;

    $("#btnBuscadorCPC").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'mantenimientoItems', action:'buscadorCPC')}",
            data    : {
                tipo: 1
            },
            success : function (msg) {
                bcpc = bootbox.dialog({
                    id      : "dlgBuscarCPC",
                    title   : "Buscar Código Compras Públicas",
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

    $("#item_presupuesto").dblclick(function () {
        buscarPresupuesto();
    });

    $("#btnBuscarPresupuesto").click(function () {
        buscarPresupuesto();
    });

    function buscarPresupuesto (){
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'pac', action:'buscadorPartida_ajax')}",
            data    : {},
            success : function (msg) {
                bcpp = bootbox.dialog({
                    id      : "dlgBuscarCPC",
                    title   : "Buscar Partida Presupuestaria",
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
    }

    function cerrarBuscadorCPC(){
        bcpc.modal("hide")
    }

    function cerrarBuscadorPP(){
        bcpp.modal("hide")
    }

    function cargarTecho() {
        if ($("#item_prsp").val() * 1 > 0) {
            $.ajax({
                type : "POST",
                url : "${g.createLink(controller: 'pac',action:'cargarTecho')}",
                data     : "id=" + $("#item_prsp").val() + "&anio=" + $("#item_anio").val() + "&pac_id=" + $("#item_id").val(),
                success  : function (msg) {
                    var parts = msg.split(";");
                    $("#techo").val(number_format(parts[0], 2, ".", ""));
                    $("#usado").val(number_format(parts[1], 2, ".", ""));
                    var dis = parts[0] - parts[1];
                    if ($("#item_id").val() * 1 > 1) {
                        var act = $("#item_cantidad").val() * $("#item_precio").val();
                        if (isNaN(act) || act === "")
                            act = 0;
                        dis += act
                    }
                    $("#disponible").val(number_format(dis, 2, ".", ""))
                }
            });
        }
    }

    function enviarPrsp() {
        var data = "";
        $("#buscarDialog").hide();
        $("#spinner").show();
        $(".crit").each(function () {
            data += "&campos=" + $(this).attr("campo");
            data += "&operadores=" + $(this).attr("operador");
            data += "&criterios=" + $(this).attr("criterio");
        });
        if (data.length < 2) {
            data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" + $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
        }
        data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'pac',action:'buscaPrsp')}",
            data     : data,
            success  : function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });
    }

    function cargarTabla() {
        var datos = "";
        if ($("#item_depto").val() * 1 > 0) {
            datos = "dpto=" + $("#item_depto").val() + "&anio=" + $("#item_anio").val()
        } else {
            datos = "anio=" + $("#item_anio").val()
        }
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'pac',action:'tabla')}",
            data     : datos,
            success  : function (msg) {
                $("#detalle").html(msg)
            }
        });
    }

    $(function () {

        $("#item_agregar_prsp").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'form_ajax', controller:'presupuesto')}",
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEdit",
                        title   : "Registrar PAC",
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
                                    return submitFormNuevoPAC();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                }
            });
            return false;
        });

        function submitFormNuevoPAC() {
            var $form = $("#frmSave-presupuestoInstance");
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
                        if(parts[0] === 'ok'){
                            log(parts[1], "success");
                            $("#item_prsp").val(parts[2]);
                            $("#item_presupuesto").val(parts[3]);
                            $("#item_presupuesto").attr("title", parts[4]);
                            cargarTecho()
                        }else{
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al cambiar la cantidad" + '</strong>');
                            return false;
                        }
                    }
                });
            } else {
                return false;
            }
        }

        cargarTabla();

        $("#item_agregar").click(function () {
            var dpto = $("#item_depto").val();
            var anio = $("#item_anio").val();
            var prsp = $("#item_prsp").val();
            var cpac = $("#item_cpac").val();
            var tipo = $("#item_tipo").val();
            var desc = $("#item_desc").val();
            var cant = $("#item_cantidad").val();
            var req = $("#item_req").val();
            var memo = $("#item_memo").val();
            var tipoP = $("#item_tipoProc").val();
            cant = str_replace(",", "", cant);
            if (isNaN(cant))
                cant = 0;
            var costo = $("#item_precio").val();
            var costoAnt = $("#item_precio").attr("valAnt");
            costo = str_replace(",", "", costo);
            if (isNaN(costo))
                costo = 0;
            costoAnt = str_replace(",", "", costoAnt);
            if (isNaN(costoAnt))
                costoAnt = 0;
            costoAnt = costoAnt * 1;
            var unidad = $("#item_unidad").val();
            var c1 = $("#item_c1");
            var c2 = $("#item_c2");
            var c3 = $("#item_c3");
            if (c1.hasClass("active"))
                c1 = "S";
            else
                c1 = "";
            if (c2.hasClass("active"))
                c2 = "S";
            else
                c2 = "";
            if (c3.hasClass("active"))
                c3 = "S";
            else
                c3 = "";
            var msg = "";
            if (req.trim() === "") {
                msg += "<br>Error: Ingrese el nombre de la "  + '<strong>' + "persona requiriente" + '</strong>'
            }
            if (memo.trim() === "") {
                msg += "<br>Error: Ingrese el numero del " + '<strong>' +  "memorando de referencia" + '</strong>'
            }
            if (costo * 1 === 0 || cant * 1 === 0) {
                msg += "<br>Error: El costo y la cantidad deben ser números " + '<strong>' + "positivos" + '</strong>'
            }
            if (desc.trim() === "") {
                msg += "<br>Error: Ingrese una " + '<strong>' + "descripción" + '</strong>'
            }
            if (prsp * 1 < 1) {
                msg += "<br>Error: Escoja una partida presupuestaria"
            }
            if (cpac * 1 < 1) {
                msg += "<br>Error en el Código CP: Escoja un código de compras públicas " + '<strong>' + "(CPC) válido" + '</strong>'
            }
            var disponible = $("#disponible").val();
            if (disponible === "" || isNaN(disponible))
                disponible = 0;
            else
                disponible = disponible * 1;

            if (costo * cant > disponible + costoAnt) {
                msg += "<br>Error: El valor total del P.A.C. (costo*cantidad) $" + (costo * cant) + " no se puede ser superior a: $" + (disponible + costoAnt)
            }
            if (msg !== "") {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg + '</strong>');
            } else {
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'pac', action:'regPac')}",
                    data     : {
                        "departamento.id"      : dpto,
                        "anio.id"              : anio,
                        "presupuesto.id"       : prsp,
                        "cpp.id"               : cpac,
                        "tipoCompra.id"        : tipo,
                        "descripcion"          : desc,
                        "cantidad"             : cant,
                        "costo"                : costo,
                        "unidad.id"            : unidad,
                        "requiriente"          : req,
                        "memo"                 : memo,
                        "tipoProcedimiento.id" : tipoP,
                        c1                     : c1,
                        c2                     : c2,
                        c3                     : c3,
                        id                     : $("#item_id").val()
                    },
                    success  : function (msg) {
                        $("#item_id").val("");
                        $("#item_cpac").val("");
                        $("#item_tipo").val();
                        $("#item_desc").val("");
                        $("#item_cantidad").val("1");
                        $("#item_precio").val("1");
                        $("#item_unidad").val();
                        $("#item_c1").removeClass("active");
                        $("#item_c2").removeClass("active");
                        $("#item_c3").removeClass("active");
                        $("#item_codigo").val("").attr("title", "");
                        $("#item_presupuesto").val("").attr("title", "");
                        $("#item_prsp").val("");
                        $("#item_req").val("");
                        $("#item_memo").val("");
                        $("#techo").val("");
                        $("#usado").val("");
                        $("#disponible").val("");
                        cargarTabla()
                    }
                });
            }

        });

        $("#item_depto").change(function () {
            cargarTabla()
        });

        $("#item_anio").change(function () {
            cargarTabla();
            cargarTecho();
        })
    });
</script>
</body>
</html>