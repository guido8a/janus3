<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Registro y Mantenimiento de Precios</title>

    <asset:javascript src="/jstree-3.0.8/dist/jstree.min.js"/>
    <asset:stylesheet src="/jstree-3.0.8/dist/themes/default/style.min.css"/>

    <style>
    .hide {
        display: none;
    }

    .show {
        display: block;
    }
    </style>
</head>

<body>

<div class="span12 btn-group" >
    <a href="#" id="btnMateriales" class="btn btn-info">
        <i class="fa fa-box"></i>
        Materiales
    </a>
    <a href="#" id="btnMano" class="btn btn-info ">
        <i class="fa fa-user"></i>
        Mano de obra
    </a>
    <a href="#" id="btnEquipos" class="btn btn-info ">
        <i class="fa fa-briefcase"></i>
        Equipos
    </a>

    <div class="col-md-2">
        <div class="input-group input-group-sm">
            <g:textField name="searchArbol" class="form-control input-sm" placeholder="Buscador"/>
            <span class="input-group-btn">
                <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                    <i class="fa fa-search"></i>&nbsp;
                </a>
            </span>
        </div><!-- /input-group -->
    </div>

    <div class="col-md-2 hidden" id="divSearchRes">
        <span id="spanSearchRes">

        </span>

        <div class="btn-group">
            <a href="#" class="btn btn-xs btn-default" id="btnNextSearch" title="Siguiente">
                <i class="fa fa-chevron-down"></i>&nbsp;
            </a>
            <a href="#" class="btn btn-xs btn-default" id="btnPrevSearch" title="Anterior">
                <i class="fa fa-chevron-up"></i>&nbsp;
            </a>
            <a href="#" class="btn btn-xs btn-default" id="btnClearSearch" title="Limpiar búsqueda">
                <i class="fa fa-times-circle"></i>&nbsp;
            </a>
        </div>
    </div>

    <div class="col-md-1" style="margin-right: 10px">
        <div class="btn-group">
            <a href="#" class="btn btn-success" id="btnCollapseAll" title="Cerrar todos los nodos">
                <i class="fa fa-minus-square"></i> Cerrar todo&nbsp;
            </a>
        </div>
    </div>
    <span class="col-md-1">
        Fecha por
        defecto:
    </span>

    <span class="col-md-2">
        <input aria-label="" name="fechaPorDefecto" id='datetimepicker2' type='text' class="form-control" value="${ new Date().format("dd-MM-yyyy")}"/>
    </span>

    <div class="col-md-12 btn-group"  style="margin-bottom: 5px; margin-top: 10px">
        <a href="#" id="ignore" class="btn btn-warning btnTodosLugares" aria-pressed="true">
            <i class="fa fa-map"></i> Todos los lugares
        </a>
        <div class="btn-group">
              <g:select name="spFecha" from="${["all" : 'Todas las fechas', "=" : 'Fecha igual', "<=" : 'Hasta la fecha']}" optionKey="key" optionValue="value" class="form-control"/>
        </div>

        <span class="col-md-2 hide" id="divFecha">
            <input aria-label="" name="fecha" id='datetimepicker1' type='text' class="form-control" value="${new Date().format("dd-MM-yyyy")}"/>
        </span>

        <div class="btn-group">
            <a href="#" id="btnRefresh" class="btn btn-ajax"><i class="fa fa-sync"></i> Refrescar</a>
            <a href="#" id="btnReporte" class="btn btn-ajax">
                <i class="fa fa-print"></i> Reporte
            </a>
            <a href="#" id="btnItems" class="btn">
                <i class="fa fa-list-ul"></i> Items
            </a>
            <g:if test="${session.perfil.codigo == 'CSTO'}">
                <a href="#" id="btnMantenimientoPrecios" class="btn">
                    <i class="fa fa-money-bill"></i> Mantenimiento de precios
                </a>
                <a href="#" id="btnPreciosVolumen" class="btn">
                    <i class="fa fa-money-bill"></i> Precios por Volumen
                </a>
                <a href="#" id="btnRegistrar" class="btn">
                    <i class="fa fa-check"></i> Registrar
                </a>
            </g:if>
            <a href="#" id="btnReporteMinas" class="btn btn-success">
                <i class="fa fa-file-excel"></i> Reporte Minas
            </a>
        </div>
    </div>

</div>

<div id="cargando" class="text-center hide">
    <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Cargando...' width="64px" height="64px"/>
    <p>Cargando...Por favor espere</p>
</div>

<div class="row">
    <div id="alerta1" class="alert alert-info hide" style="margin-top: 5px">MATERIALES</div>
    <div id="alerta2" class="alert alert-warning hide" style="margin-top: 5px">MANO DE OBRA</div>
    <div id="alerta3" class="alert alert-success hide" style="margin-top: 5px">EQUIPOS</div>
</div>

<div id="tree" class="col-md-8 ui-corner-all" style="overflow: auto"></div>
<div id="tree2" class="col-md-8 ui-corner-all hide"></div>
<div id="tree3" class="col-md-8 ui-corner-all hide"></div>
<div id="info" class="col-md-4 ui-corner-all hide" style="border-style: groove; border-color: #0d7bdc"></div>

<div id="modal-tree">
    <div class="modal-body" id="modalBody">

    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>

<script type="text/javascript">

    var searchRes = [];
    var posSearchShow = 0;
    var tipoSeleccionado = 1;

    var $treeContainer = $("#tree");
    var $treeContainer2 = $("#tree2");
    var $treeContainer3 = $("#tree3");

    var todosLugares = false;
    var fechaSeleccionada = $("#datetimepicker1").val();


    $('#datetimepicker1, #datetimepicker2').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $('#datetimepicker1').on('dp.change', function(e){
        fechaSeleccionada = $("#datetimepicker1").val()
        showLugar.fecha = fechaSeleccionada
    });

    var showLugar = {
        all      : false,
        ignore   : false,
        fecha    : "all",
        // operador : ""
        operador : "all",
        tipo: false
    };

    $("#btnItems").click(function () {
       location.href="${createLink(controller: 'mantenimientoItems', action: 'registro')}"
    });

    $("#btnMantenimientoPrecios").click(function () {
        location.href="${createLink(controller: 'item', action: 'mantenimientoPrecios')}"
    })

    $("#btnPreciosVolumen").click(function () {
        location.href="${createLink(controller: 'item', action: 'precioVolumen')}"
    })

    $("#btnRegistrar").click(function () {
        location.href="${createLink(controller: 'item', action: 'registrarPrecios')}"
    });

    $("#ignore").click(function () {

        if($(this).hasClass('active')){
            $(this).removeClass("active");
            $(this).trigger('blur');
            showLugar.tipo = false;
            todosLugares = false;
        }else{
            $(this).addClass("active");
            showLugar.tipo = true;
            todosLugares = true;
        }

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
        $("#info").html("");
    });

    $("#spFecha").change(function () {
        var op = $(this).val();
        if(op === '=' || op === '<='){
            $("#divFecha").removeClass('hide');
            showLugar.fecha = fechaSeleccionada
        }else{
            showLugar.fecha = "all";
            $("#divFecha").addClass('hide');
        }
        showLugar.operador = op;
    });

    $("#btnRefresh").click(function (){
        if(tipoSeleccionado === 1){
            cargarMateriales();
            recargarMateriales();
        }else if(tipoSeleccionado === 2){
            cargarMano();
            recargaMano();
        }else if(tipoSeleccionado === 3) {
            cargarEquipo();
            recargaEquipo();
        }

        $("#info").html("");
    });

    $("#btnCollapseAll").click(function () {

        var $scrollTo = $("#root");

        if(tipoSeleccionado === 1){
            $("#tree").jstree("close_all");

            $("#tree").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
            tipoSeleccionado = 1;
            recargarMateriales();
        }else if(tipoSeleccionado === 2){
            $("#tree2").jstree("close_all");
            // var $scrollTo = $("#root");
            $("#tree2").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
            tipoSeleccionado = 2;
            recargaMano();
        }else{
            $("#tree3").jstree("close_all");
            // var $scrollTo = $("#root");
            $("#tree3").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
            tipoSeleccionado = 3;
            recargaEquipo();
        }

        $("#info").addClass('hide').html("");

        return false;
    });

    function scrollToNode($scrollTo) {
        if(tipoSeleccionado === 1){
            $("#tree").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
        }else if(tipoSeleccionado === 2){
            $("#tree2").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
        }else{
            $("#tree3").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
        }
    }

    function scrollToRoot() {
        var $scrollTo = $("#root");
        scrollToNode($scrollTo);
    }

    function scrollToSearchRes() {
        var $scrollTo = $(searchRes[posSearchShow]).parents("li").first();
        $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
        scrollToNode($scrollTo);
    }

    $('#btnSearchArbol').click(function () {
        // $treeContainer.jstree("open_all");
        if(tipoSeleccionado === 1){
            $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
        }else if(tipoSeleccionado === 2){
            $treeContainer2.jstree(true).search($.trim($("#searchArbol").val()));
        }else{
            $treeContainer3.jstree(true).search($.trim($("#searchArbol").val()));
        }

        if($("#searchArbol").val() !== ''){
            dialogoBuscar(tipoSeleccionado);
        }

        return false;
    });

    function dialogoBuscar(tipo){
        $.ajax({
            type    : "POST",
            url     :  "${createLink(controller: 'mantenimientoItems', action:'tablaBusqueda_ajax')}",
            data    : {
                criterio: $("#searchArbol").val(),
                tipo: tipo
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgShowB",
                    title   : "Búsqueda",
                    class   : "modal-lg",
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

    $("#searchArbol").keypress(function (ev) {
        if (ev.keyCode === 13) {
            // $treeContainer.jstree("open_all");
            if(tipoSeleccionado === 1){
                $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
            }else if(tipoSeleccionado === 2){
                $treeContainer2.jstree(true).search($.trim($("#searchArbol").val()));
            }else{
                $treeContainer3.jstree(true).search($.trim($("#searchArbol").val()));
            }
            return false;
        }
    });

    $("#btnPrevSearch").click(function () {
        if (posSearchShow > 0) {
            posSearchShow--;
        } else {
            posSearchShow = searchRes.length - 1;
        }
        scrollToSearchRes();
        return false;
    });

    $("#btnNextSearch").click(function () {
        if (posSearchShow < searchRes.length - 1) {
            posSearchShow++;
        } else {
            posSearchShow = 0;
        }
        scrollToSearchRes();
        return false;
    });

    $("#btnClearSearch").click(function () {
        limpiarBusqueda();
    });

    function limpiarBusqueda(){
        $treeContainer.jstree("clear_search");
        $treeContainer2.jstree("clear_search");
        $treeContainer3.jstree("clear_search");
        $("#searchArbol").val("");
        posSearchShow = 0;
        searchRes = [];
        $("#divSearchRes").addClass("hidden");
        $("#spanSearchRes").text("");
        $("#info").addClass('hide');
    }

    $("#btnMateriales").click(function () {
        tipoSeleccionado = 1;
        cargarMateriales();
        limpiarBusqueda();
        $("#divSearchRes").addClass("hidden")
    });

    function showInfo() {
        var node = $("#tree").jstree(true).get_selected();

        var nodeId = node.toString().split("_")[1];
        var nodeNivel = node.toString().split("_")[0];

        if(nodeNivel !== 'root' && nodeNivel !== 'lg'){
            cargarInfo(nodeNivel, nodeId);
        }else if(nodeNivel === 'lg'){
            cargarInfo(nodeNivel, nodeId, node.toString().split("_")[2]);
        }
    }

    function showInfo2() {
        var node = $("#tree2").jstree(true).get_selected();

        var nodeId = node.toString().split("_")[1];
        var nodeNivel = node.toString().split("_")[0];

        if(nodeNivel !== 'root' && nodeNivel !== 'lg'){
            cargarInfo(nodeNivel, nodeId);
        }else if(nodeNivel === 'lg'){
            cargarInfo(nodeNivel, nodeId, node.toString().split("_")[2]);
        }
    }

    function showInfo3() {
        var node = $("#tree3").jstree(true).get_selected();

        var nodeId = node.toString().split("_")[1];
        var nodeNivel = node.toString().split("_")[0];

        if(nodeNivel !== 'root' && nodeNivel !== 'lg'){
            cargarInfo(nodeNivel, nodeId);
        }else if(nodeNivel === 'lg'){
            cargarInfo(nodeNivel, nodeId, node.toString().split("_")[2]);
        }
    }

    function cargarInfo(nodeNivel, nodeId, itemId){
        var ca = cargarLoader("Cargando...");
        var url = ""
        switch (nodeNivel) {
            case "gp":
                url = "${createLink(action:'showGr_ajax')}";
                break;
            case "sg":
                url = "${createLink(action:'showSg_ajax')}";
                break;
            case "dp":
                url = "${createLink(action:'showDp_ajax')}";
                break;
            case "it":
                url = "${createLink(action:'showIt_ajax')}";
                break;
            case "lg":
                url = "${createLink(action:'showLg_ajax')}";
                break;
        }

        $.ajax({
            type    : "POST",
            url     : url,
            data    : {
                id : nodeId,
                item: itemId,
                all      : showLugar.all,
                ignore   : showLugar.ignore,
                fecha    : showLugar.fecha,
                operador : showLugar.operador
            },
            success : function (msg) {
                ca.modal("hide");
                $("#info").removeClass('hide').html(msg);
            }
        });
    }

    function recargarMateriales () {
        var $treeContainer = $("#tree");
        $treeContainer.removeClass("hide");
        $("#tree2").addClass("hide") ;
        $("#tree3").addClass("hide");
        $("#btnMateriales").addClass('active');
        $("#btnMano").removeClass('active');
        $("#btnEquipos").removeClass('active');
        $("#alerta1").removeClass('hide');
        $("#alerta2").addClass('hide');
        $("#alerta3").addClass('hide');
        $treeContainer.jstree("refresh")
    }

    function cargarMateriales() {
        $("#tree").removeClass("hide");
        $("#tree2").addClass("hide") ;
        $("#tree3").addClass("hide");
        $("#btnMateriales").addClass('active');
        $("#btnMano").removeClass('active');
        $("#btnEquipos").removeClass('active');
        $("#alerta1").removeClass('hide');
        $("#alerta2").addClass('hide');
        $("#alerta3").addClass('hide');
        $("#info").html("");

        $("#cargando").removeClass('hide');

        var $treeContainer = $("#tree");

        $treeContainer.on("loaded.jstree", function () {
            $("#cargando").hide();
            $("#tree").removeClass("hidden");

        }).on("select_node.jstree", function (node, selected, event) {
        }).jstree({
            plugins     : ["types", "state", "contextmenu", "search"],
            core        : {
                multiple       : false,
                check_callback : true,
                themes         : {
                    variant : "small",
                    dots    : true,
                    stripes : true
                },
                data           : {
                    url   : '${createLink(action:"loadTreePart_precios")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            tipo  : 1,
                            todos: todosLugares
                        };
                    }
                }
            },
            contextmenu : {
                show_at_node : false,
                items        : createContextMenu
            },
            state       : {
                key : "unidades",
                opened: false
            },
            search      : {
                fuzzy             : false,
                show_only_matches : false,
                ajax              : {
                    url     : "${createLink(action:'arbolSearch_ajax')}",
                    success : function (msg) {
                        var json = $.parseJSON(msg);
                        $.each(json, function (i, obj) {
                            $('#tree').jstree("open_node", obj);
                        });
                        setTimeout(function () {
                            searchRes = $(".jstree-search");
                            var cantRes = searchRes.length;
                            posSearchShow = 0;
                            $("#divSearchRes").removeClass("hidden");
                            $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                            scrollToSearchRes();
                        }, 300);
                    }
                }
            },
            types       : {
                root                : {
                    icon : "fa fa-sitemap text-info"
                }
            }
        }).bind("select_node.jstree", function (node, selected) {
            showInfo();
        });
    }

    function cargarMano () {
        $("#tree").addClass("hide");
        $("#tree2").removeClass("hide") ;
        $("#tree3").addClass("hide");
        $("#btnMateriales").removeClass('active');
        $("#btnMano").addClass('active');
        $("#btnEquipos").removeClass('active');
        $("#alerta1").addClass('hide');
        $("#alerta2").removeClass('hide');
        $("#alerta3").addClass('hide');
        $("#info").html("");
        $("#cargando").removeClass('hide');

        var $treeContainer = $("#tree2");

        $treeContainer.on("loaded.jstree", function () {
            $("#cargando").hide();
            $("#tree2").removeClass("hidden");

        }).on("select_node.jstree", function (node, selected, event) {
        }).jstree({
            plugins     : ["types", "state", "contextmenu", "search"],
            core        : {
                multiple       : false,
                check_callback : true,
                themes         : {
                    variant : "small",
                    dots    : true,
                    stripes : true
                },
                data           : {
                    url   : '${createLink(action:"loadTreePart_precios")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            tipo  : 2,
                            todos: todosLugares
                        };
                    }
                }
            },
            contextmenu : {
                show_at_node : false,
                items        : createContextMenu
            },
            state       : {
                key : "unidades",
                opened: false
            },
            search      : {
                fuzzy             : false,
                show_only_matches : false,
                ajax              : {
                    url     : "${createLink(action:'arbolSearch_ajax')}",
                    success : function (msg) {
                        var json = $.parseJSON(msg);
                        $.each(json, function (i, obj) {
                            $('#tree2').jstree("open_node", obj);
                        });
                        setTimeout(function () {
                            searchRes = $(".jstree-search");
                            var cantRes = searchRes.length;
                            posSearchShow = 0;
                            $("#divSearchRes").removeClass("hidden");
                            $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                            scrollToSearchRes();
                        }, 300);
                    }
                }
            },
            types       : {
                root                : {
                    icon : "fa fa-sitemap text-info"
                }
            }
        }).bind("select_node.jstree", function (node, selected) {
            showInfo2();
        });
    }

    $("#btnMano").click(function () {
        tipoSeleccionado = 2;
        cargarMano();
        limpiarBusqueda();
        $("#divSearchRes").addClass("hidden")
    });

    function recargaMano(){
        $("#tree").addClass("hide");
        $("#tree2").removeClass("hide") ;
        $("#tree3").addClass("hide");
        $("#btnMateriales").removeClass('active');
        $("#btnMano").addClass('active');
        $("#btnEquipos").removeClass('active');
        $("#alerta1").addClass('hide');
        $("#alerta2").removeClass('hide');
        $("#alerta3").addClass('hide');
        var $treeContainer = $("#tree2");
        $treeContainer.jstree("refresh")
    }

    $("#btnEquipos").click(function () {
        tipoSeleccionado = 3;
        cargarEquipo();
        limpiarBusqueda();
        $("#divSearchRes").addClass("hidden")
    });

    function cargarEquipo(){
        $("#tree").addClass("hide");
        $("#tree2").addClass("hide") ;
        $("#tree3").removeClass("hide");
        $("#btnMateriales").removeClass('active');
        $("#btnMano").removeClass('active');
        $("#btnEquipos").addClass('active');
        $("#alerta1").addClass('hide');
        $("#alerta2").addClass('hide');
        $("#alerta3").removeClass('hide');
        $("#info").html("");
        $("#cargando").removeClass('hide');

        var $treeContainer = $("#tree3");

        $treeContainer.on("loaded.jstree", function () {
            $("#cargando").hide();
            $("#tree3").removeClass("hidden");

        }).on("select_node.jstree", function (node, selected, event) {
        }).jstree({
            plugins     : ["types", "state", "contextmenu", "search"],
            core        : {
                multiple       : false,
                check_callback : true,
                themes         : {
                    variant : "small",
                    dots    : true,
                    stripes : true
                },
                data           : {
                    url   : '${createLink(action:"loadTreePart_precios")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            tipo  : 3,
                            todos: todosLugares
                        };
                    }
                }
            },
            contextmenu : {
                show_at_node : false,
                items        : createContextMenu
            },
            state       : {
                key : "unidades",
                opened: false
            },
            search      : {
                fuzzy             : false,
                show_only_matches : false,
                ajax              : {
                    url     : "${createLink(action:'arbolSearch_ajax')}",
                    success : function (msg) {
                        var json = $.parseJSON(msg);
                        $.each(json, function (i, obj) {
                            $('#tree3').jstree("open_node", obj);
                        });
                        setTimeout(function () {
                            searchRes = $(".jstree-search");
                            var cantRes = searchRes.length;
                            posSearchShow = 0;
                            $("#divSearchRes").removeClass("hidden");
                            $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);
                            scrollToSearchRes();
                        }, 300);

                    }
                }
            },
            types       : {
                root                : {
                    icon : "fa fa-sitemap text-info"
                }
            }
        }).bind("select_node.jstree", function (node, selected) {
            showInfo3();
        });
    }

    function recargaEquipo(){
        $("#tree").addClass("hide");
        $("#tree2").addClass("hide") ;
        $("#tree3").removeClass("hide");
        $("#btnMateriales").removeClass('active');
        $("#btnMano").removeClass('active');
        $("#btnEquipos").addClass('active');
        $("#alerta1").addClass('hide');
        $("#alerta2").addClass('hide');
        $("#alerta3").removeClass('hide');
        var $treeContainer = $("#tree3");
        $treeContainer.jstree("refresh")
    }

    function createContextMenu(node) {

        var nodeStrId = node.id;
        var $node = $("#" + nodeStrId);
        var nodeId = nodeStrId.split("_")[1];
        var parentId = $node.parent().parent().children()[1].id.split("_")[1];
        var nodeType = $node.data("jstree").type;
        var esRoot = nodeType === "root";
        var esPrincipal = nodeType === "principal";
        var esSubgrupo = nodeType.contains("subgrupo");
        var esDepartamento = nodeType.contains("departamento");
        var esItem = nodeType.contains("item");
        var esLugar = nodeType.contains("lugar");
        var tipoGrupo = $node.data("tipo");
        var nodeHasChildren = $node.hasClass("hasChildren");
        var abueloId = null;

        if(esDepartamento){
            abueloId = $node.parent().parent().parent().parent().children()[1].id.split("_")[1];
        }else{
            abueloId = parentId
        }

        var items = {};

        var nuevaLista = {
            label  : "Nueva Lista",
            icon   : "fa fa-underline text-success",
            action : function () {
                createEditLista(null, nodeId);
            }
        };

        var editarLista = {
            label  : "Editar lista",
            icon   : "fa fa-underline text-success",
            action : function () {
                createEditLista(nodeId, parentId);
            }
        };

        if (esItem) {
            if(!todosLugares){
                items.nuevaLista = nuevaLista
            }
        } else if(esLugar){
            if(!todosLugares){
                items.editarLista = editarLista
            }
        }
        return items;
    }

    function createEditLista(id, parentId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.grupo = parentId;
        $.ajax({
            type    : "POST",
            %{--url     : "${createLink( action:'formSg_ajax')}",--}%
            url     : "${createLink( action:'formLg_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditLT",
                    title : title + " lista",
                    class : "modal-lg",
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
                                return submitFormLista(parentId);
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

    function submitFormLista(tipo) {
        var $form = $("#frmSave");
        var $btn = $("#dlgCreateEditLT").find("#btnSave");
        if ($form.valid()) {
            var data = $form.serialize();
            $btn.replaceWith(spinner);
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'OK'){
                        log("Guardado correctamente", "success");
                        setTimeout(function () {
                            if(tipoSeleccionado === 1){
                                recargarMateriales();
                            }else if(tipoSeleccionado === 2){
                                recargaMano();
                            }else{
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

    $("#modal-tree").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        draggable: false,
        width: 600,
        height: 600,
        position: 'center',
        title: 'Formato de impresión'
    });

    $("#btnReporte").click(function () {
        var tipo = tipoSeleccionado == 1 ? 'materiales' : (tipoSeleccionado == 2 ? 'mano_obra' : 'equipos')
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'reportePreciosUI')}",
            data    : {
                grupo : tipoSeleccionado
            },
            success : function (msg) {
                var btnOk = $('<a href="#" data-dismiss="modal" class="btn ">Cancelar</a>');
                var btnSave = $('<a href="#"  class="btn btn-info"><i class="fa fa-print"></i> PDF </a>');
                var btnExcel = $('<a href="#" class="btn btnExcel btn-success" ><i class="fa fa-file-excel"></i> Excel</a>');

                btnSave.click(function () {
                    var data = "";
                    data += "orden=" + $(".orden.active").attr("id");
                    data += "&tipo=" + $(".tipo.active").attr("id");
                    data += "&lugar=" + $("#lugarRep").val();
                    data += "&fecha=" + $("#fechaRep").val();
                    data += "&grupo=" + tipoSeleccionado;
                    data += "&estado=" + $("#revisar").val();

                    $(".col.active").each(function () {
                        data += "&col=" + $(this).attr("id");
                    });

                    location.href = "${g.createLink(controller: 'reportes2', action: '_reportePrecios')}?" + data;
                });

                btnExcel.click(function () {
                    var fecha = $("#fechaRep").val();
                    var lugar = $("#lugarRep").val();
                    var grupo = tipoSeleccionado;
                    var estadoA = $("#revisar option:selected").val();

                    location.href = "${g.createLink(controller: 'reportesExcel2', action: 'reportePreciosExcel')}?fecha=" +
                        fecha + "&lugar=" + lugar + "&grupo=" + grupo + "&estado=" + estadoA;
                });

                btnOk.click(function () {
                    $("#modal-tree").dialog("close");
                });

                $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                $("#modalTitle").html("Formato de impresión");
                $("#modalBody").html(msg);
                $("#modalFooter").html("").append(btnOk).append(btnSave).append(btnExcel);
                $("#modal-tree").dialog("open");
            }
        });
    });

    $("#btnReporteMinas").click(function (){
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'impresionMinas_ajax')}",
            data    : {},
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgImprimirMinas",
                    title   : "Listas de Precios de materiales pétreos - minas (Excel)",
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
                            label     : "<i class='fa fa-file-excel'></i> Excel",
                            className : "btn-success",
                            callback  : function () {
                                %{--location.href="${createLink(controller: 'reportesExcel2', action: 'reporteExcelMinas')}?fecha=" + $("#fecha1").val() + "&lista=" + $("#lista option:selected").val();--}%
                                location.href="${createLink(controller: 'reportesExcel2', action: 'reporteExcelMinas')}?lista=" + $("#lista option:selected").val();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

</script>

</body>
</html>