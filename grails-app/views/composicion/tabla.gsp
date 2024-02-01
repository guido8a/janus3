<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <asset:javascript src="/jquery/plugins/DataTables-1.9.4/media/js/jquery.dataTables.min.js"/>
    <asset:javascript src="/jquery/plugins/jquery.livequery.js"/>
    <asset:javascript src="/jquery/plugins/box/js/jquery.luz.box.js"/>
    <asset:javascript src="/jquery/plugins/DataTables-1.9.4/media/css/jquery.dataTables.css"/>
    <asset:javascript src="/jquery/plugins/box/css/jquery.luz.box.css"/>

    <title>Composición de la obra</title>

    <style>
    .bordes2{
        border: 1px solid black;
        border-top: 1px solid black;
    }
    .active{
        color: #ffffff !important;
        background-color: #0A246A !important;
        font-weight: bold;
    }

    </style>


</head>

<body>
<div class="hoja">
%{--    <div class="tituloChevere"> ${obra?.descripcion}</div>--}%
    <div class="span12" style="color: #1a7031; font-size: 18px; margin-bottom: 10px">Valores para la obra: <strong>${obra?.descripcion}</strong> </div>

    <g:if test="${flash.message}">
        <div class="col-md-12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </g:if>

    <div class="btn-toolbar" style="margin-top: 15px;">
        <div class="btn-group">
            <a href="${g.createLink(controller: 'obra', action: 'registroObra', params: [obra: obra?.id])}" class="btn btn-primary"
               title="Regresar a la obra">
                <i class="fa fa-arrow-left"></i>
                Regresar Obra
            </a>
            <a href="${g.createLink(controller: 'variables', action: 'composicion', params: [id: obra?.id])}" class="btn btn-info"
               title="Regresar a la obra">
                <i class="fa fa-arrow-left"></i>
                Regresar Composición
            </a>
        </div>

        <div class="btn-group">
            <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id &&
                    duenoObra == 1 && obra?.estado != 'R')}">
                <a href="${g.createLink(action:'formArchivo', params: [id: obra?.id])}" class="btn btn-success" id="${obra.id}">
                    <i class="fa fa-upload"></i> Cargar Excel
                </a>
                <a href="#" class="btn recargarComp btn-info" title="Recargar Composición" id="${obra.id}">
                    <i class="fa fa-upload"></i>
                    Recargar Composición
                </a>
            </g:if>
        </div>

        <div class="btn-group" data-toggle="buttons-radio" style="margin-left: 80px">
            <a href="#" id="btnTodos" class="btn btn-info toggle pdf ${tipo.toString().contains(",") ? 'active' : ''} -1">
                <i class="fa fa-cogs"></i>
                Todos
            </a>
            <a href="#" id="btnMateriales" class="btn btn-info toggle pdf ${tipo.toString() == '[1]' ? 'active' : ''} 1">
                <i class="fa fa-briefcase"></i>
                Materiales
            </a>
            <a href="#" id="btnManoObra" class="btn btn-info toggle pdf ${tipo.toString() == '[2]' ? 'active' : ''} 2">
                <i class="fa fa-users"></i>
                Mano de obra
            </a>
            <a href="#" id="btnEquipos" class="btn btn-info toggle pdf ${tipo.toString() == '[3]' ? 'active' : ''} 3">
                <i class="fa fa-truck"></i>
                Equipos
            </a>
        </div>

    </div>

    <div class="borde_abajo" style="padding-left: 45px;position: relative; margin-top: 20px">
        <div class="col-md-12">
            <div class="col-md-1" style="margin-left: -17px; width: 100px;">
                <b>Código</b>
                <input type="text" style="width: 100px;;font-size: 10px" id="item_codigo" readonly="true">
                <input type="hidden" style="width: 60px" id="item_id">
                <g:hiddenField name="id_existente"/>
            </div>

            <div class="col-md-1" style="margin-top: 15px; margin-left: 5px; width: 80px">
                <a class="btn btn-xs btn-primary btn-ajax" href="#" rel="tooltip" title="Agregar Item" id="btnBuscarItem">
                    <i class="fa fa-search"></i> Buscar
                </a>
            </div>

            <div class="col-md-6" style="margin-left: -10px;">
                <b>Descripción</b>
                <input type="text" style="width: 520px;font-size: 10px" id="item_nombre" disabled="true">
            </div>

            <div class="col-md-2" style="margin-left: 0px; width: 60px;">
                <b>Unidad</b>
                <input type="text" style="width: 45px;text-align: right" id="item_unidad" value="" disabled="true">
            </div>

            <div class="col-md-2" style="margin-left: 0px; width: 100px;">
                <b>Cantidad</b>
                <input type="text" style="width: 95px;text-align: right" id="item_cantidad" value="">
            </div>

            <div class="col-md-2" style="margin-left: 10px;width: 100px;">
                <b>Precio</b>
                <input type="text" style="width: 95px;text-align: right" id="item_precio" value="" disabled="true">
            </div>

            <div class="col-md-1" style="padding-top:30px">
                <input type="hidden" value="" id="vol_id">
                <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1 && obra?.estado != 'R')}">
                    <a href="#" class="btn btn-xs btn-success" title="agregar" style="margin-top: -25px" id="item_agregar">
                        <i class="fa fa-plus"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-small btn-success hidden" title="Guardar" style="margin-top: -25px" id="guardarEdicion">
                        <i class="fa fa-save"></i>
                    </a>
                    <a href="#" class="btn btn-xs btn-small btn-warning hidden" title="Cancelar" style="margin-top: -25px" id="cancelar">
                        <i class="fa fa-ban"></i>
                    </a>
                </g:if>
            </div>
        </div>
    </div>


    <div class="body">
        <table class="table table-bordered table-condensed table-hover table-striped" id="tbl">
            <thead>
                <g:if test="${tipo.toString().contains(",") || tipo.toString() == '[1]'}">
                    <th>Código</th>
                    <th>Item</th>
                    <th>U</th>
                    <th>Cantidad</th>
                    <th>P. Unitario</th>
                    <th>Transporte</th>
                    <th>Costo</th>
                    <th>Total</th>
                    <g:if test="${tipo.toString().contains(",")}">
                        <th>Tipo</th>
                    </g:if>
                </g:if>
                <g:elseif test="${tipo.toString() == '[2]'}">
                    <th>Código</th>
                    <th>Mano de obra</th>
                    <th>U</th>
                    <th>Horas hombre</th>
                    <th>Sal. / hora</th>
                    <th>Total</th>
                </g:elseif>
                <g:elseif test="${tipo.toString() == '[3]'}">
                    <th>Código</th>
                    <th>Equipo</th>
                    <th>U</th>
                    <th width="100px">Cantidad</th>
                    <th>Tarifa</th>
                    <th>Costo</th>
                    <th>Total</th>
                </g:elseif>
                <th style="width: 75px">Acciones</th>

            </thead>
            <tbody>
            <g:set var="totalEquipo" value="${0}"/>
            <g:set var="totalMano" value="${0}"/>
            <g:set var="totalMaterial" value="${0}"/>
            <g:each in="${res}" var="r">
                <tr>
                    <td class="">${r.item.codigo}</td>
                    <td class="">${r.item.nombre}</td>
                    <td>${r.item.unidad.codigo}</td>
                    <td class="numero cantidad texto " iden="${r.id}" width="100px">
                        <g:formatNumber number="${r.cantidad}" minFractionDigits="2" maxFractionDigits="7" format="##,##0" locale="ec"/>
                    </td>
                    <g:if test="${tipo.toString() != '[2]'}">
                        <td class="numero ${r.id} ">
                            <g:formatNumber number="${r.precio}" minFractionDigits="3" maxFractionDigits="3" format="##,##0" locale="ec"/>
                        </td>
                    </g:if>
                    <g:if test="${tipo.toString().contains(",") || tipo.toString() == '[1]'}">
                        <td class="numero ${r.id} transporte">
                            <g:formatNumber number="${r.transporte}" minFractionDigits="4" maxFractionDigits="4" format="##,##0" locale="ec"/>
                        </td>
                    </g:if>
                    <td class="numero ${r.id} precio ${(tipo.toString() =='[2]')?'textoPrecio':''}" iden="${r.id}">
                        <g:formatNumber number="${r.transporte + r.precio}" minFractionDigits="4" maxFractionDigits="4" format="##,##0" locale="ec"/>
                    </td>
                    <td class="numero ${r.id} total">
                        <g:formatNumber number="${(r.transporte + r.precio) * r.cantidad}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/>

                        <g:if test="${r?.grupo.id == 1}">
                            <g:set var="totalMaterial" value="${totalMaterial + ((r.transporte + r.precio) * r.cantidad)}"/>

                        </g:if>
                        <g:elseif test="${r.grupo.id == 2}">
                            <g:set var="totalMano" value="${totalMano + ((r.transporte + r.precio) * r.cantidad)}"/>

                        </g:elseif>
                        <g:elseif test="${r.grupo.id == 3}">
                            <g:set var="totalEquipo" value="${totalEquipo + ((r.transporte + r.precio) * r.cantidad)}"/>
                        </g:elseif>

                    </td>
                    <g:if test="${tipo.toString().contains(",")}">
                        <td>${r?.grupo}</td>
                    </g:if>
                    <td style="text-align: center; width: 75px" class="col_delete">
                        <a class="btn btn-xs btn-success editarItem" href="#" rel="tooltip" title="Editar"
                           data-id="${r.id}" data-precio="${r.precio}" data-cant="${r.cantidad}"
                           data-uni="${r.item.unidad.codigo}" data-cod="${r.item.codigo}" data-nom="${r.item.nombre}" data-item="${r.item.id}">
                            <i class="fa fa-edit"></i>
                        </a>
                        <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar"
                           data-id="${r.id}">
                            <i class="fa fa-trash"></i>
                        </a>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>

        <div id="totales" style="width:100%;">
            <input type='text' id='txt' style='height:20px;width:110px;margin: 0px;padding: 0px;padding-right:2px;text-align: right !important;display: none;margin-left: 0px;margin-right: 0px;'>
            <table class="table table-bordered ta195ble-condensed pull-right" style="width: 40%;">
                <thead>
                <tr>
                    <th>Equipos</th>
                    <th>Mano de obra</th>
                    <th>Materiales</th>
                    <th>TOTAL DIRECTO</th>
                </tr>
                </thead>
                <tbody>
                <tr>
                    <td  style=" border: 1px solid black"class="numero"><g:formatNumber number="${totalEquipo}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                    <td style="border-top: 1px solid black;" class="numero bordes2"><g:formatNumber number="${totalMano}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                    <td style="border-top: 1px solid black;" class="numero bordes2"><g:formatNumber number="${totalMaterial}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                    <td style="border-top: 1px solid black;" class="numero bordes2"><g:formatNumber number="${totalEquipo + totalMano + totalMaterial}" minFractionDigits="2" maxFractionDigits="2" format="##,##0" locale="ec"/></td>
                </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<div class="modal grande hide fade" id="modal-rubro" style="overflow: hidden;">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle"></h3>
    </div>

    <div class="modal-body" id="modalBody">
        <bsc:buscador name="rubro.buscador.id" value="" accion="buscaRubro" controlador="composicion" campos="${campos}" label="Rubro" tipo="lista"/>
    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>

<div id="recargarDialog">
    <fieldset>
        <div class="span3" style="width:380px;">
            Está seguro de querer volver a cargar la composición de la obra:<div style="font-weight: bold;">${obra?.nombre} ?

        </div>
            <br>
            <span style="color: red">
                Este proceso elimina todos los datos de la composición actual.
            </span>

        </div>
    </fieldset>
</div>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 20px">
            <div class="col-md-2">Grupo</div>

            <div class="col-md-2">Buscar Por</div>

            <div class="col-md-2">Criterio</div>

            <div class="col-md-2">Ordenado por</div>
        </div>

        <div class="row-fluid" style="margin-left: 20px">
            <div class="col-md-2">
                <g:select name="buscarGrupo_name"  id="buscarGrupo" from="['1': 'Materiales', '2': 'Mano de Obra', '3': 'Equipos']"
                          style="width: 100%" optionKey="key" optionValue="value"/></div>

            <div class="col-md-2"><g:select name="buscarPor" class="buscarPor" from="${[1: 'Nombre', 2: 'Código']}"
                                         style="width: 100%" optionKey="key"
                                         optionValue="value"/></div>

            <div class="col-md-2">
                <g:textField name="criterio" class="criterio" style="width: 80%"/>
            </div>

            <div class="col-md-2">
                <g:select name="ordenar" class="ordenar" from="${[1: 'Nombre', 2: 'Código']}"
                          style="width: 100%" optionKey="key"
                          optionValue="value"/></div>

            <div class="col-md-2" style="margin-left: 60px"><button class="btn btn-info" id="btn-consultar"><i
                    class="icon-check"></i> Consultar
            </button></div>

        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTabla" style="height: 460px; overflow-y:auto; overflow-x: auto;">
        </div>
    </fieldset>
</div>


<script type="text/javascript">

    $("#guardarEdicion").click(function (){
        $("#dlgLoad").dialog("open");

        var id =  $("#id_existente").val();
        var item = $("#item_id").val();
        var cantidad = $("#item_cantidad").val();
        var obra = '${obra?.id}';

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'composicion', action: 'guardarEditado_ajax')}',
            data:{
                id: id,
                item: item,
                cantidad: cantidad,
                obra: obra
            },
            success: function (msg) {
                $("#dlgLoad").dialog("close");
                if(msg == 'ok'){
                    $.box({
                        imageClass: "box_info",
                        text: "Item actualizado correctamente",
                        title: "Alerta",
                        iconClose: false,
                        dialog: {
                            resizable: false,
                            draggable: false,
                            buttons: {
                                "Aceptar": function () {
                                    location.reload(true)
                                }
                            }
                        }
                    });
                }else{
                    if(msg == "er"){
                        caja("El item ya se encuentra agregado a la composición" ,"Error")
                    }else{
                        caja("Error al actualizar el item", "Error")
                        cancelar();
                    }
                }
            }
        })
    });

    function validarNumDec(ev) {
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
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
            ev.keyCode == 37 || ev.keyCode == 39 || ev.keyCode == 190 || ev.keyCode == 110);
    }

    $("#item_cantidad").keydown(function (ev) {
        return validarNumDec(ev)
    });

    $(".editarItem").click(function () {
        var id = $(this).data("id");
        var item = $(this).data("item");
        var precio = $(this).data("precio");
        var cantidad = $(this).data("cant");
        var unidad = $(this).data("uni");
        var codigo = $(this).data("cod");
        var nombre = $(this).data("nom");


        $("#id_existente").val(id);
        $("#item_id").val(item);
        $("#item_precio").val(precio);
        $("#item_cantidad").val(cantidad);
        $("#item_unidad").val(unidad);
        $("#item_nombre").val(nombre);
        $("#item_codigo").val(codigo);
        $("#cancelar").removeClass("hidden");
        $("#guardarEdicion").removeClass("hidden")
        $("#item_agregar").addClass("hidden")
    });

    $("#cancelar").click(function () {
        cancelar();
    });

    function cancelar(){
        $("#id_existente").val('');
        $("#item_id").val('');
        $("#item_precio").val('');
        $("#item_cantidad").val('');
        $("#item_unidad").val('');
        $("#item_nombre").val('');
        $("#item_codigo").val('');
        $("#cancelar").addClass("hidden");
        $("#guardarEdicion").addClass("hidden");
        $("#item_agregar").removeClass("hidden")
    }

    $(".borrarItem").click(function (){
        var id = $(this).data("id");

        bootbox.confirm({
            title: "Eliminar item",
            message: "Está seguro de querer eliminar este item de la composición? Esta acción no puede deshacerse",
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
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
                        url     : "${createLink(controller: 'composicion', action: 'borrarItem_ajax')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            if (msg === "ok") {
                                reset();
                                log("Item borrado correctamente", "success");
                            } else {
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al borrar el item" + '</strong>');
                            }
                        }
                    });
                }
            }
        });
    });

    function caja(texto, titulo){
        return $.box({
            imageClass: "box_info",
            text: texto,
            title: titulo,
            iconClose: false,
            dialog: {
                resizable: false,
                draggable: false,
                buttons: {
                    "Aceptar": function () {
                    }
                }
            }
        });
    }


    $("#btnBuscarItem").click(function () {
        $("#busqueda").dialog("open");
        $(".ui-dialog-titlebar-close").html("x");
        return false;
    });

    $("#busqueda").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 800,
        height: 500,
        position: 'center',
        title: 'Lista de items'
    });

    function busqueda() {
        var buscarPor = $("#buscarPor").val();
        var criterio = $(".criterio").val();
        var ordenar = $("#ordenar").val();
        var grupo = $("#buscarGrupo").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'composicion', action:'listaItem')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                ordenar: ordenar,
                grupo: grupo
            },
            success: function (msg) {
                $("#divTabla").html(msg);
            }
        });
    }

    $("#btn-consultar").click(function () {
        busqueda();
    });


    function precios(item) {
        var obra = ${obra.id}
            $.ajax({
                type    : "POST",
                url     : "${g.createLink(controller: 'composicion',action:'precios')}",
                data    : "obra=" + obra + "&item=" + item,
                success : function (msg) {
//                        console.log(msg)
                    var parts = msg.split(";")
                    $("#item_precio").val(parts[0])
                    $("#item_transporte").val(parts[1])
                }
            });
    }

    function updateTotal(celda) {
        if(celda.parent().hasClass("precio")){
            var val = celda.val()
            val = val.replace(",", "")
            var cant = celda.parent().parent().find(".cantidad").html()
            cant = cant.replace(",", "")
            celda.parent().parent().find(".total").html(number_format(cant * val, 2, ".", ""))
        }else{
            var val = celda.val()
            val = val.replace(",", "")
            var precio = celda.parent().parent().find(".precio").html()
            precio = precio.replace(",", "")
            celda.parent().parent().find(".total").html(number_format(precio * val, 2, ".", ""))
        }


    }

    $(function () {
        $('#tbl').dataTable({
            sScrollY        : "600px",
            bPaginate       : false,
            bScrollCollapse : true,
            bFilter         : false,
            bSort           : false,
            oLanguage       : {
                sZeroRecords : "No se encontraron datos",
                sInfo        : "",
                sInfoEmpty   : ""
            }
        });

//        $(".btn, .sp").click(function () {
//            console.log('clase', $(this).hasClass("active"))
//            if ($(this).hasClass("active")) {
//                return false;
//            }
//        });

        $("#item_codigo").dblclick(function () {
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
            $("#modalTitle").html("Lista de items");
            $("#modalFooter").html("").append(btnOk);
            $("#modal-rubro").modal("show");
            $("#buscarDialog").unbind("click")
            $("#buscarDialog").bind("click", enviar)

        });

        $("#btn-comp").click(function () {
            console.log('regresar')
            location.href = "${createLink(controller: 'variables', action: 'composicion', id: obra?.id)}"

        });

        $("#item_codigo").blur(function () {
//            ////
            if ($("#item_id").val() == "" && $("#item_codigo").val() != "") {
//                console.log($("#item_id").val())
                $.ajax({type : "POST", url : "${g.createLink(controller: 'composicion',action:'buscarRubroCodigo')}",
                    data     : "codigo=" + $("#item_codigo").val(),
                    success  : function (msg) {
//                        console.log("msg "+msg)
                        if (msg != "-1") {

                            var parts = msg.split("&&")
                            $("#item_id").val(parts[0])
                            precios(parts[0]);
                            $("#item_nombre").val(parts[2])
                        } else {
                            $("#item_id").val("")
                            $("#item_nombre").val("")
                        }
                    }
                });
            }
        });
        $("#item_codigo").keydown(function (ev) {

            if (ev.keyCode * 1 != 9 && (ev.keyCode * 1 < 37 || ev.keyCode * 1 > 40)) {

                $("#item_id").val("")
                $("#item_nombre").val("")
                $("#item_precio").val("")
                $("#item_transporte").val("")

            } else {
//                ////console.log("no reset")
            }

        });

        $("#item_agregar").click(function () {

            var cantidad = $("#item_cantidad").val()
            cantidad = str_replace(",", "", cantidad)
            var rubro = $("#item_id").val()
            if (isNaN(cantidad))
                cantidad = 0
            var msn = ""
            if (cantidad * 1 <= 0) {
                msn = "La cantidad debe ser un número positivo mayor a 0"
            }
            if (rubro * 1 < 1)
                msn = "seleccione un item"

            if (msn.length == 0) {
                var datos = "rubro=" + rubro + "&cantidad=" + cantidad + "&obra=${obra.id}"

                $.ajax({type : "POST", url : "${g.createLink(controller: 'composicion',action:'addItem')}",
                    data     : datos,
                    success  : function (msg) {
                        if (msg == "ok") {
                            window.location.reload(true)
                        } else {
                            $.box({
                                imageClass : "box_info",
                                text       : msg,
                                title      : "Error",
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

                    }
                });
            } else {
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

        $("#guardar").click(function () {
//            console.log("guardar")
            var data = "data="
            var data2="&data2="
            $(".changed").each(function () {
//                console.log($(this))
                var val = $(this).html()
                val = val.replace(",", "")
                if($(this).hasClass("cantidad"))
                    data += $(this).attr("iden") + "I" + val + "X"
                else
                    data2 += $(this).attr("iden") + "I" + val + "X"
            });
//            console.log(data)
            $.ajax({
                type    : "POST",
                url     : "${g.createLink(controller: 'composicion',action:'save')}",
                data    : data+data2,
                success : function (msg) {
                    if (msg == "ok")
                        window.location.reload(true)
                }
            });

        });

        $("#txt").keyup(function (event) {
//            console.log(event.which)
            if (event.which == 13) {
                updateTotal($(this))
                var valor = $(this).val()
//                console.log("eenter ",valor)
                $(this).val("")
                $(this).hide()
                var padre = $(this).parent()
                $("#totales").append($(this))
                padre.html(valor)
                padre.addClass("changed")
                if(padre.hasClass("precio"))
                    padre.addClass("textoPrecio")
                else
                    padre.addClass("texto")
            }
            if (event.which == 40) {
                updateTotal($(this))
                var valor = $(this).val()
                $(this).val("")
                $(this).hide()
                var padre = $(this).parent()
                $("#totales").append($(this))
                padre.html(valor)
                if(padre.hasClass("precio"))
                    padre.addClass("textoPrecio")
                else
                    padre.addClass("texto")
                padre.addClass("changed")
//                console.log(padre.parent(),padre.parent(),padre.parent().next())
                if(padre.hasClass("precio"))
                    padre.parent().next().find(".precio").click()
                else
                    padre.parent().next().find(".cantidad").click()
            }
            if (event.which == 38) {
                updateTotal($(this))
                var valor = $(this).val()
                $(this).val("")
                $(this).hide()
                var padre = $(this).parent()
                $("#totales").append($(this))
                padre.html(valor)
                padre.addClass("changed")
                if(padre.hasClass("precio"))
                    padre.addClass("textoPrecio")
                else
                    padre.addClass("texto")
//                console.log(padre.parent(),padre.parent(),padre.parent().next())
                if(padre.hasClass("precio"))
                    padre.parent().next().find(".precio").click()
                else
                    padre.parent().next().find(".cantidad").click()
            }

        })
        $("#txt").blur(function () {
//            console.log("blur")
            if ($("#txt").val() != "") {
                updateTotal($(this))
                var valor = $(this).val()
                $(this).val("")
                $(this).hide()
                var padre = $(this).parent()
                $("#totales").append($(this))
                padre.addClass("changed")
                padre.html(valor)
                if(padre.hasClass("precio"))
                    padre.addClass("textoPrecio")
                else
                    padre.addClass("texto")
            }
        })
        var txt = $("#txt")
        $(".cantidad").click(function () {
            if ($(this).hasClass("texto")) {
                txt.width($(this).innerWidth() - 25)
                var valor = $(this).html().trim()
                $(this).html("")
                txt.val(valor)
                $(this).append(txt)
                txt.show()
                $(this).removeClass("texto")
                txt.focus()
            }

        });
        <g:if test="${tipo=='2'}">
        $(".precio").click(function () {
            if ($(this).hasClass("textoPrecio")) {
                txt.width($(this).innerWidth() - 25)
                var valor = $(this).html().trim()
                $(this).html("")
                txt.val(valor)
                $(this).append(txt)
                txt.show()
                $(this).removeClass("textoPrecio")
                txt.focus()
            }

        });
        </g:if>

        %{--$("#imprimirPdf").click(function () {--}%

        %{--//                       console.log("-->" + $(".pdf.active").attr("class"))--}%
        %{--//                       console.log("-->" + $(".pdf.active").hasClass('2'))--}%

        %{--if($(".pdf.active").hasClass("1") == true){--}%

        %{--location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteComposicionMat',id: obra?.id)}?sp=${sub}"--}%
        %{--}else {--}%
        %{--}--}%
        %{--if($(".pdf.active").hasClass("2") == true){--}%
        %{--location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteComposicionMano',id: obra?.id)}?sp=${sub}"--}%
        %{--}else {--}%


        %{--}--}%
        %{--if($(".pdf.active").hasClass("3") == true){--}%
        %{--location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteComposicionEq',id: obra?.id)}?sp=${sub}"--}%

        %{--}else {--}%


        %{--}--}%
        %{--if($(".pdf.active").hasClass("-1") == true){--}%


        %{--location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteComposicion',id: obra?.id)}?sp=${sub}"--}%
        %{--}--}%
        %{--});--}%

        $("#recargarDialog").dialog({

            autoOpen  : false,
            resizable : false,
            modal     : true,
            draggable : false,
            width     : 500,
            height    : 260,
            position  : 'center',
            title     : 'Volver a cargar Composición',
            buttons   : {
                "Aceptar" : function () {
                    $("#dlgLoad").dialog("open");
                    $.ajax({
                        type    : "POST",
                        url     : "${g.createLink(action: 'recargar')}",
                        data    : "id=${obra?.id}",
                        success : function (msg) {
                            $("#dlgLoad").dialog("close");
                            location.reload(true)
                        }
                    });
//

                    $("#recargarDialog").dialog("close");
                },
                "Cancelar" : function () {
                    $("#recargarDialog").dialog("close");
                }
            }
        });

        $(".recargarComp").click(function () {
//            console.log("recargar")
            $("#recargarDialog").dialog("open")

        });

    });

    $("#btnTodos").click(function () {
        location.href = "${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id, tipo: -1])}"
    });

    $("#btnMateriales").click(function () {
        location.href = "${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id, tipo: 1])}"
    });

    $("#btnManoObra").click(function () {
        location.href = "${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id, tipo: 2])}"
    });

    $("#btnEquipos").click(function () {
        location.href = "${g.createLink(controller: 'composicion', action: 'tabla', params: [id: obra?.id, tipo: 3])}"
    });


</script>

</body>
</html>