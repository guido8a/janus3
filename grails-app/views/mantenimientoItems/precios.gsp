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

<div class="span12 btn-group" data-toggle="buttons-radio">
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

    <div class="col-md-4">
        <div class="input-group input-group-sm">
            <g:textField name="searchArbol" class="form-control input-sm" placeholder="Buscador"/>
            <span class="input-group-btn">
                <a href="#" id="btnSearchArbol" class="btn btn-sm btn-info">
                    <i class="fa fa-search"></i>&nbsp;
                </a>
            </span>
        </div><!-- /input-group -->
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
%{--        <input aria-label="" name="fecha" id='datetimepicker2' type='text' class="form-control" value="${ new Date().format("dd-MM-yyyy")}"/>--}%
        <input aria-label="" name="fechaPorDefecto" id='datetimepicker2' type='text' class="form-control" value="${ new Date().format("dd-MM-yyyy")}"/>
    </span>

    <div class="col-md-4 hidden" id="divSearchRes">
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

    <div class="col-md-12 btn-group" data-toggle="buttons-radio" style="margin-bottom: 5px; margin-top: 10px">
        <a href="#" id="ignore" class="btn btn-warning btnTodosLugares" aria-pressed="true">
            <i class="fa fa-map"></i> Todos los lugares
        </a>
        <div class="btn-group">
            %{--            <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">--}%
            %{--                <span id="spFecha">--}%
            %{--                    <i class="fa fa-calendar"></i>  Todas las fechas--}%
            %{--                </span>--}%
            %{--                <span class="caret"></span>--}%
            %{--            </a>--}%
            %{--            <ul class="dropdown-menu">--}%
            %{--                <li>--}%
            %{--                    <a href="#" class="fecha" data-operador="all" data-fecha='false'>--}%
            %{--                        Todas las fechas--}%
            %{--                    </a>--}%
            %{--                </li>--}%
            %{--                <li>--}%
            %{--                    <a href="#" class="fecha" data-operador="=" data-fecha='true'>--}%
            %{--                        Fecha igual--}%
            %{--                    </a>--}%
            %{--                </li>--}%
            %{--                <li>--}%
            %{--                    <a href="#" class="fecha" data-operador="<=" data-fecha='true'>--}%
            %{--                        Hasta la fecha--}%
            %{--                    </a>--}%
            %{--                </li>--}%
            %{--            </ul>--}%
            <g:select name="spFecha" from="${["all" : 'Todas las fechas', "=" : 'Fecha igual', "<=" : 'Hasta la fecha']}" optionKey="key" optionValue="value" class="form-control"/>
        </div>

        <span class="col-md-2 hide" id="divFecha">
            <input aria-label="" name="fecha" id='datetimepicker1' type='text' class="form-control" value="${new Date().format("dd-MM-yyyy")}"/>
            %{--            <elm:datepicker name="fecha" class="input-small" onClose="cambiaFecha" yearRange="${(new Date().format('yyyy').toInteger() - 40).toString() + ':' + new Date().format('yyyy')}"/>--}%
        </span>

        <div class="btn-group">
            <a href="#" id="btnRefresh" class="btn btn-ajax"><i class="fa fa-sync"></i> Refrescar</a>
            <a href="#" id="btnReporte" class="btn btn-ajax">
                <i class="fa fa-print"></i> Reporte
            </a>
            <g:link action="registro" class="btn">
                <i class="fa fa-list-ul"></i> Items
            </g:link>
            <g:if test="${session.perfil.codigo == 'CSTO'}">
                <g:link controller="item" action="mantenimientoPrecios" class="btn">
                    <i class="fa fa-money-bill"></i> Mantenimiento de precios
                </g:link>
                <g:link controller="item" action="precioVolumen" class="btn">
                    <i class="fa fa-money-bill"></i> Precios por Volumen
                </g:link>
                <g:link controller="item" action="registrarPrecios" class="btn">
                    <i class="fa fa-check"></i> Registrar
                </g:link>
            </g:if>
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

    $(".btnTodosLugares").click(function () {

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

        // var tipo = $(this).attr("id");
        // if(!$(this).hasClass("active")) {
        //     showLugar.tipo = true;
        // } else {
        //     showLugar.tipo = false;
        // }
        // initTree(current);
        $("#info").html("");
    });



    $("#spFecha").change(function () {
        var op = $(this).val();
        if(op === '=' || op === '<='){
            $("#divFecha").removeClass('hide');
            // var hoy = $("#datetimepicker1").val();
            // if(!hoy){
            //     hoy = new Date()
            // }
            // showLugar.fecha = hoy
            showLugar.fecha = fechaSeleccionada
        }else{
            showLugar.fecha = "all";
            $("#divFecha").addClass('hide');
        }
        showLugar.operador = op;
    });

    // $(".fecha").click(function () {
    //     var op = $(this).data("operador");
    //     var text = $.trim($(this).text());
    //     var fecha = $(this).data("fecha");
    //
    //     $("#spFecha").text(text);
    //
    //     if (fecha) {
    //         $("#divFecha").removeClass('hide');
    //         var hoy = $("#fecha").val();
    //         if(!hoy){
    //             hoy = new Date().format("dd-MM-yyyy")
    //         }
    //         showLugar.fecha = hoy
    //         // var hoy = $("#fecha").datepicker("getDate");
    //         // if (!hoy) {
    //         //     hoy = new Date();
    //         //     $("#fecha").datepicker("setDate", hoy);
    //         // }
    //         // showLugar.fecha = hoy.getDate() + "-" + (hoy.getMonth() + 1) + "-" + hoy.getFullYear();
    //     } else {
    //         showLugar.fecha = "all";
    //         $("#divFecha").addClass('hide');
    //     }
    //     showLugar.operador = op;
    // });

    // function cambiaFecha(dateText, inst) {
    //     console.log("Fecha " + dateText + inst)
    //     showLugar.fecha = dateText;
    // }

    $("#btnRefresh").click(function (){
        if(tipoSeleccionado === 1){
            showInfo();
        }else if(tipoSeleccionado === 2){
            showInfo2();
        }else{
            showInfo3();
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
        return false;
    });

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
            label  : "Editar lsita",
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
            url     : "${createLink( action:'formSg_ajax')}",
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
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        setTimeout(function () {
                            if(tipo === '1'){
                                recargarMateriales();
                            }else if(tipo === '2'){
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

</script>

</body>
</html>