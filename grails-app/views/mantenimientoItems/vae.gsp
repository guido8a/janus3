
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Valores VAE de Items</title>

    <asset:javascript src="/jstree-3.0.8/dist/jstree.min.js"/>
    <asset:stylesheet src="/jstree-3.0.8/dist/themes/default/style.min.css"/>

</head>

<body>

%{--        <div class="span12 btn-group" data-toggle="buttons-radio" style="margin-left:0px; height: 35px; width: 360px">--}%
%{--            <a href="#" id="1" class="btn btn-info toggle active" data-reporte="materiales">--}%
%{--                <i class="icon-folder-open-alt"></i>--}%
%{--                Materiales <!--grpo--><!--sbgr -> Grupo--><!--dprt -> Subgrupo--><!--item-->--}%
%{--            </a>--}%
%{--            <a href="#" id="2" class="btn btn-info toggle" data-reporte="mano_obra">--}%
%{--                <i class="icon-user"></i>--}%
%{--                Mano de obra--}%
%{--            </a>--}%
%{--            <a href="#" id="3" class="btn btn-info toggle" data-reporte="equipos">--}%
%{--                <i class="icon-truck"></i>--}%
%{--                Equipos--}%
%{--            </a>--}%
%{--        </div>--}%
%{--            <form class="form-search" style="width: 740px; float: left; display: inline">--}%
%{--                <div class="input-append">--}%
%{--                    <input type="text" class="input-medium search-query" id="search"/>--}%
%{--                    <a href='#' class='btn' id="btnSearch"><i class='icon-zoom-in'></i> Buscar</a>--}%
%{--                </div>--}%
%{--                <span id="cantRes"></span>--}%
%{--                <input type="button" class="btn" value="Cerrar todo" onclick="$('#tree').jstree('close_all');" style="margin-left: 10px;">--}%

%{--                <span style="font-size: 12px; margin-left: 10px; ">Fecha por Defecto:</span>--}%
%{--                <span style="width: 120px; margin: 5px;">--}%
%{--                    <elm:datepicker name="fecha" id="fcDefecto" class="datepicker required" style="width: 90px"--}%
%{--                        maxDate="'+1y'" value="${new Date()}"/>--}%
%{--                </span>--}%
%{--                <a href="#" id="ev" class="btn btn-info btnExcelVae" >--}%
%{--                    <i class="icon-print"></i>--}%
%{--                    VAE--}%
%{--                </a>--}%
%{--            </form>--}%



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

    <div class="col-md-3">
        <div class="input-group input-group-sm">
            <g:textField name="searchArbol" class="form-control input-sm" placeholder="Buscador"/>
            <span class="input-group-btn">
                <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                    <i class="fa fa-search"></i>&nbsp;
                </a>
            </span>
        </div><!-- /input-group -->
    </div>

    <div class="col-md-1" style="margin-right: 20px">
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

    <div class="col-md-3 hidden" id="divSearchRes">
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

    <div class="col-md-1">
        <a href="#" class="btn btn-info btnExcelVae" title="Imprimir VAE">
            <i class="fa fa-file-excel"></i>&nbsp;VAE
        </a>
    </div>

</div>

<div id="cargando" class="text-center hide">
    <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Cargando...' width="64px" height="64px"/>
    <p>Cargando...Por favor espere</p>
</div>

<div id="alerta1" class="alert alert-info hide" style="margin-top: 5px">MATERIALES</div>
<div id="alerta2" class="alert alert-warning hide" style="margin-top: 5px">MANO DE OBRA</div>
<div id="alerta3" class="alert alert-success hide" style="margin-top: 5px">EQUIPOS</div>

<div id="tree" class="col-md-8 ui-corner-all" style="overflow: auto"></div>
<div id="tree2" class="col-md-8 ui-corner-all hide"></div>
<div id="tree3" class="col-md-8 ui-corner-all hide"></div>
<div id="info" class="col-md-4 ui-corner-all hide" style="border-style: groove; border-color: #0d7bdc"></div>

<script type="text/javascript">

    var searchRes = [];
    var posSearchShow = 0;
    var tipoSeleccionado = 1;

    var $treeContainer = $("#tree");
    var $treeContainer2 = $("#tree2");
    var $treeContainer3 = $("#tree3");

    $('#datetimepicker1, #datetimepicker2').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#btnCollapseAll").click(function () {

        if(tipoSeleccionado === 1){
            $("#tree").jstree("close_all");
            var $scrollTo = $("#root");
            $("#tree").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
            tipoSeleccionado = 1;
            recargarMateriales();
        }else if(tipoSeleccionado === 2){
            $("#tree2").jstree("close_all");
            var $scrollTo = $("#root");
            $("#tree2").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
            tipoSeleccionado = 2;
            recargaMano();
        }else{
            $("#tree3").jstree("close_all");
            var $scrollTo = $("#root");
            $("#tree3").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
                scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
            });
            tipoSeleccionado = 3;
            recargaEquipo();
        }

        $("#info").addClass('hide');
        $("#info").html('');

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
        return false;
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

    function showInfo() {
        var node = $("#tree").jstree(true).get_selected();

        var nodeId = node.toString().split("_")[1];
        var nodeNivel = node.toString().split("_")[0];

        if(nodeNivel !== 'root'){
            cargarInfo(nodeNivel, nodeId);
        }
    }

    function showInfo2() {
        var node = $("#tree2").jstree(true).get_selected();

        var nodeId = node.toString().split("_")[1];
        var nodeNivel = node.toString().split("_")[0];

        if(nodeNivel !== 'root'){
            cargarInfo(nodeNivel, nodeId);
        }
    }

    function showInfo3() {
        var node = $("#tree3").jstree(true).get_selected();

        var nodeId = node.toString().split("_")[1];
        var nodeNivel = node.toString().split("_")[0];

        if(nodeNivel !== 'root'){
            cargarInfo(nodeNivel, nodeId);
        }
    }

    function cargarInfo(nodeNivel, nodeId){
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
            case "vae":
                url = "${createLink(action:'showVa_ajax')}";
                break;
        }

        $.ajax({
            type    : "POST",
            url     : url,
            data    : {
                id : nodeId
            },
            success : function (msg) {
                $("#info").removeClass('hide');
                $("#info").html(msg);
            }
        });
    }

    function recargarMateriales () {
        $("#tree").removeClass("hide");
        $("#tree2").addClass("hide") ;
        $("#tree3").addClass("hide");
        $("#btnMateriales").addClass('active');
        $("#btnMano").removeClass('active');
        $("#btnEquipos").removeClass('active');
        $("#alerta1").removeClass('hide');
        $("#alerta2").addClass('hide');
        $("#alerta3").addClass('hide');
        var $treeContainer = $("#tree");
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
        // $("#info").addClass('hide');
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
                    url   : '${createLink(action:"loadTreePart_nuevo")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            tipo  : 1,
                            vae : true
                        };
                    }
                }
            },
            // contextmenu : {
            //     show_at_node : false,
            //     items        : createContextMenu
            // },
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

    $("#btnMateriales").click(function () {
        tipoSeleccionado = 1;
        cargarMateriales();
        limpiarBusqueda();
        $("#divSearchRes").addClass("hidden")
    });


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
        // $("#info").addClass('hide');
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
                    url   : '${createLink(action:"loadTreePart_nuevo")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            tipo  : 2,
                            vae : true
                        };
                    }
                }
            },
            // contextmenu : {
            //     show_at_node : false,
            //     items        : createContextMenu
            // },
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
        // $("#info").addClass('hide');
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
                    url   : '${createLink(action:"loadTreePart_nuevo")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            tipo  : 3,
                            vae : true
                        };
                    }
                }
            },
            // contextmenu : {
            //     show_at_node : false,
            //     items        : createContextMenu
            // },
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


    $(".btnExcelVae").click(function () {
        var fecha = $("#datetimepicker2").val();
        location.href="${g.createLink(controller: 'reportes4', action:'reporteExcelItemsVae' )}?fecha=" + fecha
    });


    // $.jGrowl.defaults.closerTemplate = '<div>[ cerrar todo ]</div>';

    %{--var btn = $("<a href='#' class='btn' id='btnSearch'><i class='icon-zoom-in'></i> Buscar</a>");--}%
    %{--var urlSp = "${resource(dir: 'images', file: 'spinner.gif')}";--}%
    %{--var sp = $('<span class="add-on" id="btnSearch"><img src="' + urlSp + '"/></span>');--}%

    %{--var current = "1";--}%
    %{--var showLugar = {--}%
    %{--    all      : false,--}%
    %{--    ignore   : false,--}%
    %{--    fecha    : "all",--}%
    %{--    operador : ""--}%
    %{--};--}%

    %{--var icons = {--}%
    %{--    edit                     : "${resource(dir: 'images/tree', file: 'edit.png')}",--}%
    %{--    delete                   : "${resource(dir: 'images/tree', file: 'delete.gif')}",--}%
    %{--    info                     : "${resource(dir: 'images/tree', file: 'info.png')}",--}%

    %{--    grupo_material           : "${resource(dir: 'images/tree', file: 'carpeta2.png')}",--}%
    %{--    grupo_manoObra           : "${resource(dir: 'images/tree', file: 'carpeta5.png')}",--}%
    %{--    grupo_equipo             : "${resource(dir: 'images/tree', file: 'carpeta6.png')}",--}%
    %{--    grupo_consultoria        : "${resource(dir: 'images/tree', file: 'carpeta5.png')}",--}%

    %{--    subgrupo_material        : "${resource(dir: 'images/tree', file: 'carpeta.png')}",--}%
    %{--    subgrupo_manoObra        : "${resource(dir: 'images/tree', file: 'subgrupo_manoObra.png')}",--}%
    %{--    subgrupo_equipo          : "${resource(dir: 'images/tree', file: 'item_equipo.png')}",--}%
    %{--    subgrupo_consultoria     : "${resource(dir: 'images/tree', file: 'subgrupo_manoObra.png')}",--}%

    %{--    departamento_material    : "${resource(dir: 'images/tree', file: 'carpeta3.png')}",--}%
    %{--    departamento_manoObra    : "${resource(dir: 'images/tree', file: 'departamento_manoObra.png')}",--}%
    %{--    departamento_equipo      : "${resource(dir: 'images/tree', file: 'departamento_equipo.png')}",--}%
    %{--    departamento_consultoria : "${resource(dir: 'images/tree', file: 'departamento_manoObra.png')}",--}%

    %{--    item_material    : "${resource(dir: 'images/tree', file: 'item_material.png')}",--}%
    %{--    item_manoObra    : "${resource(dir: 'images/tree', file: 'item_manoObra.png')}",--}%
    %{--    item_equipo      : "${resource(dir: 'images/tree', file: 'item_material.png')}",--}%
    %{--    item_consultoria : "${resource(dir: 'images/tree', file: 'item_manoObra.png')}",--}%

    %{--    lugar     : "${resource(dir: 'images/tree', file: 'lugar_c.png')}",--}%
    %{--    lugar_c   : "${resource(dir: 'images/tree', file: 'lugar_c.png')}",--}%
    %{--    lugar_v   : "${resource(dir: 'images/tree', file: 'lugar_v.png')}",--}%
    %{--    lugar_all : "${resource(dir: 'images/tree', file: 'lugar_all.png')}",--}%

    %{--    vae : "${resource(dir: 'images/tree', file: 'lugar_all.png')}"--}%
    %{--};--}%

    function cambiaFecha(dateText, inst) {
        showLugar.fecha = dateText;
    }


//
//     function createUpdate(params) {
//         var obj = {
//             label            : params.label,
//             separator_before : params.sepBefore, // Insert a separator before the item
//             separator_after  : params.sepAfter, // Insert a separator after the item
//             icon             : params.icon,
//             action           : function (obj) {
//                 $.ajax({
//                     type    : "POST",
//                     url     : params.url,
//                     data    : params.data,
//                     success : function (msg) {
//                         var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
//                         var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-ok"></i> Guardar</a>');
//
//                         btnSave.click(function () {
//                             if ($("#frmSave").valid()) {
//                                 btnSave.replaceWith(spinner);
//                                 var url = $("#frmSave").attr("action");
//                                 $.ajax({
//                                     type    : "POST",
//                                     url     : url,
//                                     data    : $("#frmSave").serialize(),
//                                     success : function (msg) {
//                                         var parts = msg.split("_");
//                                         if (parts[0] == "OK") {
//                                             if (params.action == "create") {
//                                                 if (params.tipo == "lg") {
//                                                     initTree(current);
//                                                 } else {
//                                                     if (params.open) {
//                                                         $("#" + params.nodeStrId).removeClass("jstree-leaf").addClass("jstree-closed");
//                                                         $('#tree').jstree("open_node", $("#" + params.nodeStrId));
//                                                     }
//                                                     var config = {attr : {id : params.tipo + "_" + parts[2]}, data : parts[3]};
//                                                     if (parts.length > 4) {
//                                                         config.attr.rel = "lugar_" + parts[4];
//                                                     }
//                                                     $('#tree').jstree("create_node", $("#" + params.nodeStrId), params.where, config);
//                                                 }
//                                                 $("#modal-tree").modal("hide");
//                                                 log(params.log + parts[3] + " creado correctamente");
//                                             } else if (params.action == "update") {
//                                                 $("#tree").jstree('rename_node', $("#" + params.nodeStrId), parts[3]);
//                                                 if (parts.length > 4) {
//                                                     $("#" + params.nodeStrId).attr("rel", "lugar_" + parts[4]);
//                                                 }
//                                                 $("#modal-tree").modal("hide");
//                                                 log(params.log + parts[3] + " editado correctamente");
//                                             }
//                                         } else {
//                                             $("#modal-tree").modal("hide");
//                                             log("Ha ocurrido el siguiente error: " + parts[1], true);
//                                         }
//                                     }
//                                 });
//                             }
// //                                            $("#frmSave").submit();
//                             return false;
//                         });
//                         if (params.action == "create") {
//                             $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
//                         } else if (params.action == "update") {
//                             $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
//                         }
//                         $("#modalTitle").html(params.title);
//                         $("#modalBody").html(msg);
//                         $("#modalFooter").html("").append(btnOk).append(btnSave);
//                         $("#modal-tree").modal("show");
//                     }
//                 });
//             }
//         };
//         return obj;
//     }

    // function remove(params) {
    //     var letraConfirm = "e", letraDelete = "o", interrogacion = "?";
    //     if (params.confirm == "lista") {
    //         letraConfirm = "a";
    //         letraDelete = "a";
    //     }
    //     if (params.extraConfirm) {
    //         interrogacion = "";
    //     }
    //     var obj = {
    //         label            : params.label,
    //         separator_before : params.sepBefore, // Insert a separator before the item
    //         separator_after  : params.sepAfter, // Insert a separator after the item
    //         icon             : params.icon,
    //         _disabled        : params.disabled,
    //         action           : function (obj) {
    //
    //             var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
    //             var btnSave = $('<a href="#"  class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');
    //             $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
    //             $("#modalTitle").html(params.title);
    //             $("#modalBody").html("<p>Está seguro de querer eliminar est" + letraConfirm + " " + params.confirm + params.extraConfirm + interrogacion + "</p>");
    //             $("#modalFooter").html("").append(btnOk).append(btnSave);
    //             $("#modal-tree").modal("show");
    //
    //             btnSave.click(function () {
    //                 btnSave.replaceWith(spinner);
    //                 $.ajax({
    //                     type    : "POST",
    //                     url     : params.url,
    //                     data    : params.data,
    //                     success : function (msg) {
    //                         var parts = msg.split("_");
    //                         if (parts[0] == "OK") {
    //                             $("#tree").jstree('delete_node', $("#" + params.nodeStrId));
    //                             $("#modal-tree").modal("hide");
    //                             log(params.log + " eliminad" + letraDelete + " correctamente");
    //                             if ($("#" + params.parentStrId).children("ul").children().size() == 0) {
    //                                 $("#" + params.parentStrId).removeClass("hasChildren");
    //                             }
    //                         } else {
    //                             $("#modal-tree").modal("hide");
    //                             log("Ha ocurrido un error al eliminar", true);
    //                         }
    //                     }
    //                 });
    //                 return false;
    //             });
    //         }
    //     };
    //     return obj;
    // }

    %{--function createContextmenu(node) {--}%
    %{--    var parent = node.parent().parent();--}%

    %{--    var nodeStrId = node.attr("id");--}%
    %{--    var nodeText = $.trim(node.children("a").text());--}%

    %{--    var parentStrId = parent.attr("id");--}%
    %{--    var parentText = $.trim(parent.children("a").text());--}%

    %{--    var nodeRel = node.attr("rel");--}%
    %{--    var parts = nodeRel.split("_");--}%
    %{--    var nodeNivel = parts[0];--}%
    %{--    var nodeTipo = parts[1];--}%

    %{--    var parentRel = parent.attr("rel");--}%
    %{--    parts = nodeRel.split("_");--}%
    %{--    var parentNivel = parts[0];--}%
    %{--    var parentTipo = parts[1];--}%

    %{--    parts = nodeStrId.split("_");--}%
    %{--    var nodeId = parts[1];--}%
    %{--    if (parts.length == 3) {--}%
    %{--        nodeId = parts[2];--}%
    %{--    }--}%

    %{--    parts = parentStrId.split("_");--}%
    %{--    var parentId = parts[1];--}%

    %{--    var nodeHasChildren = node.hasClass("hasChildren");--}%
    %{--    var cantChildren = node.children("ul").children().size();--}%
    %{--    nodeHasChildren = nodeHasChildren || cantChildren != 0;--}%

    %{--    var menuItems = {}, lbl = "", item = "";--}%

    %{--    switch (nodeTipo) {--}%
    %{--        case "material":--}%
    %{--            lbl = "o material";--}%
    %{--            item = "Material";--}%
    %{--            break;--}%
    %{--        case "manoObra":--}%
    %{--            lbl = "a mano de obra";--}%
    %{--            item = "Mano de obra";--}%
    %{--            break;--}%
    %{--        case "equipo":--}%
    %{--            lbl = "o equipo";--}%
    %{--            item = "Equipo";--}%
    %{--            break;--}%
    %{--        case "C":--}%
    %{--            break;--}%
    %{--        case "V":--}%
    %{--            break;--}%
    %{--    }--}%


    %{--    switch (nodeNivel) {--}%
    %{--        case "item":--}%
    %{--            if (!nodeHasChildren && cantChildren == 0) {--}%
    %{--                menuItems.crearHijo = createUpdate({--}%
    %{--                    action    : "create",--}%
    %{--                    label     : "Registro del VAE",--}%
    %{--                    sepBefore : true,--}%
    %{--                    sepAfter  : false,--}%
    %{--                    icon      : icons.vae,--}%
    %{--                    url       : "${createLink(action:'formVa_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        item: nodeId,--}%
    %{--                        fechaVae : $('#fcDefecto').val()--}%
    %{--                    },--}%
    %{--                    open      : true,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    where     : "first",--}%
    %{--                    tipo      : "vae",--}%
    %{--                    log       : "VAE",--}%
    %{--                    title     : "Registro del VAE"--}%
    %{--                });--}%
    %{--            }--}%
    %{--            break;--}%
    %{--    }--}%

    %{--    return menuItems;--}%
    %{--}--}%

    %{--function initTree(tipo) {--}%
    %{--    var id, rel, label;--}%
    %{--    var li = "";--}%
    %{--    switch (tipo) {--}%
    %{--        case "1":--}%
    %{--            id = "materiales_1";--}%
    %{--            rel = "grupo_material";--}%
    %{--            label = "Materiales";--}%
    %{--            li = "<li id='" + id + "' class='root hasChildren jstree-closed' rel='" + rel + "' ><a href='#' class='label_arbol'>" + label + "</a></li>";--}%
    %{--            break;--}%
    %{--        case "2":--}%
    %{--            $.ajax({--}%
    %{--                type    : "POST",--}%
    %{--                async   : false,--}%
    %{--                url     : "${createLink(action:'loadMO')}",--}%
    %{--                success : function (msg) {--}%
    %{--                    var p = msg.split("*");--}%
    %{--                    li = p[0];--}%
    %{--                    id = p[1];--}%
    %{--                }--}%
    %{--            });--}%
    %{--            break;--}%
    %{--        case "3":--}%
    %{--            id = "equipos_3";--}%
    %{--            rel = "grupo_equipo";--}%
    %{--            label = "Equipos";--}%
    %{--            li = "<li id='" + id + "' class='root hasChildren jstree-closed' rel='" + rel + "' ><a href='#' class='label_arbol'>" + label + "</a></li>";--}%
    %{--            break;--}%
    %{--    }--}%
    %{--    $("#tree").bind("loaded.jstree",--}%
    %{--        function (event, data) {--}%
    %{--            $("#loading").hide();--}%
    %{--            $("#treeArea").show();--}%
    %{--        }).jstree({--}%
    %{--        "core"        : {--}%
    %{--            "initially_open" : [ id ]--}%
    %{--        },--}%
    %{--        "plugins"     : ["themes", "html_data", "json_data", "ui", "types", "contextmenu", "search", "cookies", "crrm"/*, "wholerow"*/],--}%
    %{--        "html_data"   : {--}%
    %{--            "data" : "<ul type='root'>" + li + "</ul>",--}%
    %{--            "ajax" : {--}%
    %{--                "type"  : "POST",--}%
    %{--                "url"   : "${createLink(action: 'loadTreePart')}",--}%
    %{--                "data"  : function (n) {--}%
    %{--                    var obj = $(n);--}%
    %{--                    var id = obj.attr("id");--}%
    %{--                    var parts = id.split("_");--}%
    %{--                    id = 0;--}%
    %{--                    if (parts.length > 1) {--}%
    %{--                        id = parts[1]--}%
    %{--                    }--}%
    %{--                    var tipo = obj.attr("rel");--}%
    %{--                    return {--}%
    %{--                        id      : id,--}%
    %{--                        tipo    : tipo,--}%
    %{--                        vae     : true,--}%
    %{--                        all     : showLugar.all,--}%
    %{--                        ignore  : showLugar.ignore--}%
    %{--                    }--}%
    %{--                },--}%
    %{--                success : function (data) {--}%
    %{--                },--}%
    %{--                error   : function (data) {--}%
    %{--                }--}%
    %{--            }--}%
    %{--        },--}%
    %{--        "types"       : {--}%
    %{--            "valid_children" : [ "grupo_material", "grupo_manoObra", "grupo_equipo"  ],--}%
    %{--            "types"          : {--}%
    %{--                "grupo_material" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.grupo_material--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "subgrupo_material" ]--}%
    %{--                },--}%
    %{--                "grupo_manoObra" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.grupo_manoObra--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "subgrupo_manoObra" ]--}%
    %{--                },--}%
    %{--                "grupo_equipo"   : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.grupo_equipo--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "subgrupo_equipo" ]--}%
    %{--                },--}%

    %{--                "subgrupo_manoObra" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.subgrupo_manoObra--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "departamento_manoObra" ]--}%
    %{--                },--}%
    %{--                "subgrupo_material" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.subgrupo_material--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "departamento_material" ]--}%
    %{--                },--}%
    %{--                "subgrupo_equipo"   : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.subgrupo_equipo--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "departamento_equipo" ]--}%
    %{--                },--}%

    %{--                "departamento_manoObra" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.departamento_manoObra--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "item_manoObra" ]--}%
    %{--                },--}%
    %{--                "departamento_material" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.departamento_material--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "item_material" ]--}%
    %{--                },--}%
    %{--                "departamento_equipo"   : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.departamento_equipo--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "item_equipo" ]--}%
    %{--                },--}%

    %{--                "item_manoObra" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.item_manoObra--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "lugar_c", "lugar_v", "lugar_all" ]--}%
    %{--                },--}%
    %{--                "item_material" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.item_material--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "lugar_c", "lugar_v", "lugar_all" ]--}%
    %{--                },--}%
    %{--                "item_equipo"   : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.item_equipo--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "lugar_c", "lugar_v", "lugar_all" ]--}%
    %{--                },--}%

    %{--                "lugar"     : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.lugar--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "" ]--}%
    %{--                },--}%
    %{--                "lugar_c"   : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.lugar_c--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "" ]--}%
    %{--                },--}%
    %{--                "lugar_v"   : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.lugar_v--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "" ]--}%
    %{--                },--}%
    %{--                "lugar_all" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.lugar_all--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "" ]--}%
    %{--                },--}%
    %{--                "vae": {--}%
    %{--                    "icon" : {--}%
    %{--                        "image" : icons.vae--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "" ]--}%
    %{--                }--}%
    %{--            }--}%
    %{--        },--}%
    %{--        "themes"      : {--}%
    %{--            "theme" : "default"--}%
    %{--        },--}%
    %{--        "search"      : {--}%
    %{--            "case_insensitive" : true,--}%
    %{--            "ajax"             : {--}%
    %{--                "type"   : "POST",--}%
    %{--                "url"    : "${createLink(action:'searchTree_ajax')}",--}%
    %{--                "data"   : function () {--}%
    %{--                    return { search : this.data.search.str, tipo : current }--}%
    %{--                },--}%
    %{--                complete : function () {--}%
    %{--                    $("#btnSearch").replaceWith(btn);--}%
    %{--                    btn.click(function () {--}%
    %{--                        doSearch();--}%
    %{--                    });--}%
    %{--                }--}%
    %{--            }--}%
    %{--        },--}%
    %{--        "contextmenu" : {--}%
    %{--            select_node : true,--}%
    %{--            "items"     : createContextmenu--}%
    %{--        }, //contextmenu--}%
    %{--        "ui"          : {--}%
    %{--            "select_limit" : 1--}%
    %{--        }--}%
    %{--    }).bind("search.jstree",function (e, data) {--}%
    %{--        var cant = data.rslt.nodes.length;--}%
    %{--        var search = data.rslt.str;--}%
    %{--        $("#cantRes").html("<b>" + cant + "</b> res.");--}%
    %{--        if (cant > 0) {--}%
    %{--            var container = $('#tree'), scrollTo = $('.jstree-search').first();--}%
    %{--            container.animate({--}%
    %{--                scrollTop : scrollTo.offset().top - container.offset().top + container.scrollTop()--}%
    %{--            }, 2000);--}%
    %{--        }--}%
    %{--    }).bind("select_node.jstree", function (NODE, REF_NODE) {--}%
    %{--        refresh();--}%
    %{--    });--}%
    %{--}--}%

    %{--function refresh() {--}%
    %{--    var loading = $("<div></div>");--}%
    %{--    loading.css({--}%
    %{--        textAlign : "center",--}%
    %{--        width     : "100%"--}%
    %{--    });--}%
    %{--    loading.append("Cargando....Por favor espere...<br/>").append(spinnerBg);--}%
    %{--    $("#info").html(loading);--}%
    %{--    var node = $.jstree._focused().get_selected();--}%
    %{--    var parent = node.parent().parent();--}%

    %{--    var nodeStrId = node.attr("id");--}%
    %{--    var nodeText = $.trim(node.children("a").text());--}%

    %{--    var nodeRel = node.attr("rel");--}%
    %{--    var parts = nodeRel.split("_");--}%
    %{--    var nodeNivel = parts[0];--}%
    %{--    var nodeTipo = parts[1];--}%

    %{--    parts = nodeStrId.split("_");--}%
    %{--    var nodeId = parts[1];--}%

    %{--    var url = "";--}%

    %{--    switch (nodeNivel) {--}%
    %{--        case "grupo":--}%
    %{--            url = "${createLink(action:'showGr_ajax')}";--}%
    %{--            if (nodeTipo == "manoObra") {--}%
    %{--                url = "${createLink(action:'showSg_ajax')}";--}%
    %{--            }--}%
    %{--            break;--}%
    %{--        case "subgrupo":--}%
    %{--            url = "${createLink(action:'showSg_ajax')}";--}%
    %{--            break;--}%
    %{--        case "departamento":--}%
    %{--            url = "${createLink(action:'showDp_ajax')}";--}%
    %{--            break;--}%
    %{--        case "item":--}%
    %{--            url = "${createLink(action:'showIt_ajax')}";--}%
    %{--            break;--}%
    %{--        case "lugar":--}%
    %{--            url = "${createLink(action:'showLg_ajax')}";--}%
    %{--            nodeId = parts[1] + "_" + parts[2];--}%
    %{--            break;--}%
    %{--        case "vae":--}%
    %{--            url = "${createLink(action:'showVa_ajax')}";--}%
    %{--            nodeId = parts[1] + "_" + parts[2];--}%
    %{--            break;--}%
    %{--    }--}%

    %{--    if (url != "") {--}%
    %{--        $.ajax({--}%
    %{--            type    : "POST",--}%
    %{--            url     : url,--}%
    %{--            data    : {--}%
    %{--                id       : nodeId,--}%
    %{--                all      : showLugar.all,--}%
    %{--                ignore   : showLugar.ignore,--}%
    %{--                fecha    : showLugar.fecha,--}%
    %{--                operador : showLugar.operador--}%
    %{--            },--}%
    %{--            success : function (msg) {--}%
    %{--                $("#info").html(msg);--}%
    %{--            }--}%
    %{--        });--}%
    %{--    }--}%
    %{--}--}%

    // function doSearch() {
    //     var val = $.trim($("#search").val());
    //     if (val != "") {
    //         $("#btnSearch").replaceWith(sp);
    //         $("#tree").jstree("search", val);
    //     }
    // }

    $(function () {

        // $(".modal").draggable({
        //     handle : $(".modal-header"),
        //     cancel : '.btn, input, select'
        // });
        //
        // $("#search").val("");
        //
        // $(".toggle").click(function () {
        //     var tipo = $(this).attr("id");
        //     if (tipo != current) {
        //         current = tipo;
        //         initTree(current);
        //         $("#info").html("");
        //     }
        // });
        // $(".toggleTipo").click(function () {
        //     var tipo = $(this).attr("id");
        //     if (!$(this).hasClass("active")) {
        //         showLugar[tipo] = true;
        //     } else {
        //         showLugar[tipo] = false;
        //     }
        //     initTree(current);
        //     $("#info").html("");
        // });

        // $(".fecha").click(function () {
        //     var op = $(this).data("operador");
        //     var text = $.trim($(this).text());
        //     var fecha = $(this).data("fecha");
        //
        //     $("#spFecha").text(text);
        //
        //     if (fecha) {
        //         $("#divFecha").show();
        //         var hoy = $("#fecha").datepicker("getDate");
        //         if (!hoy) {
        //             hoy = new Date();
        //             $("#fecha").datepicker("setDate", hoy);
        //         }
        //         showLugar.fecha = hoy.getDate() + "-" + (hoy.getMonth() + 1) + "-" + hoy.getFullYear();
        //     } else {
        //         showLugar.fecha = "all";
        //         $("#divFecha").hide();
        //     }
        //     showLugar.operador = op;
        // });

        // initTree("1");
        // $("#info").html("");
        //
        // $("#btnRefresh").click(function () {
        //     refresh();
        // });
        //
        // $("#btnSearch").click(function () {
        //     doSearch();
        // });

        $("#btnReporte").click(function () {
            var tipo = $.trim($("#" + current).data("reporte")).toLowerCase();
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'reportePreciosUI')}",
                data    : {
                    grupo : current
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success" data-dismiss="modal"><i class="icon-print"></i> Ver</a>');
                    var btnExcel = $('<a href="#" class="btn btnExcel" data-dismiss="modal"><i class="icon-table"></i> Excel</a>');

                    btnSave.click(function () {
                        var data = "";
                        data += "orden=" + $(".orden.active").attr("id");
                        data += "Wtipo=" + $(".tipo.active").attr("id");
                        data += "Wlugar=" + $("#lugarRep").val();
                        data += "Wfecha=" + $("#fechaRep").val();
                        data += "Wgrupo=" + current;

                        $(".col.active").each(function () {
                            data += "Wcol=" + $(this).attr("id");
                        });

                        var actionUrl = "${createLink(controller:'pdf',action:'pdfLink')}?filename=Reporte_costos_" + tipo + ".pdf&url=${createLink(controller: 'reportes2', action: 'reportePrecios')}";
                        location.href = actionUrl + "?" + data;

                        var wait = $("<div style='text-align: center;'> Estamos procesando su reporte......Por favor espere......</div>");
                        wait.prepend(spinnerBg);

                        var btnClose = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');

                        $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                        $("#modalTitle").html("Procesando");
                        $("#modalBody").html(wait);
                        $("#modalBody").close();
                        $("#modalFooter").html("").append(btnClose);

                        $.modal.close();

                        return false;
                    });

                    btnExcel.click(function () {

                        var fecha = $("#fechaRep").val();
                        var lugar = $("#lugarRep").val();
                        var grupo = current;

                        location.href = "${g.createLink(controller: 'reportes2', action: 'reportePreciosExcel')}?fecha=" + fecha + "&lugar=" + lugar + "&grupo=" + grupo;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                    $("#modalTitle").html("Formato de impresión");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk).append(btnSave).append(btnExcel);
                    $("#modal-tree").modal("show");
                }
            });
        });

        // $("#search").keyup(function (ev) {
        //     if (ev.keyCode == 13) {
        //         doSearch();
        //     }
        // });

        %{--var cache = {};--}%
        %{--$("#search").autocomplete({--}%
        %{--    minLength : 3,--}%
        %{--    source    : function (request, response) {--}%
        %{--        var term = request.term;--}%
        %{--        if (term in cache) {--}%
        %{--            response(cache[ term ]);--}%
        %{--            return;--}%
        %{--        }--}%

        %{--        $.ajax({--}%
        %{--            type     : "POST",--}%
        %{--            dataType : 'json',--}%
        %{--            url      : "${createLink(action: 'search_ajax')}",--}%
        %{--            data     : {--}%
        %{--                search : term,--}%
        %{--                tipo   : current--}%
        %{--            },--}%
        %{--            success  : function (data) {--}%
        %{--                cache[ term ] = data;--}%
        %{--                response(data);--}%
        %{--            }--}%
        %{--        });--}%

        %{--    }--}%
        %{--});--}%

    });


</script>

</body>
</html>
