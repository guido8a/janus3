<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Registro y Mantenimiento de Items</title>

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

    <div class="col-md-1" style="float: right">
        <div class="btn-group">
            <a href="#" class="btn btn-success" id="btnCollapseAll" title="Cerrar todos los nodos">
                <i class="fa fa-minus-square"></i> Cerrar todo&nbsp;
            </a>
        </div>
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

        if($("#searchArbol").val() !== ''){
            dialogoBuscar(tipoSeleccionado);
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

            if($("#searchArbol").val() !== ''){
                dialogoBuscar(tipoSeleccionado);
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
        $("#info").html("")

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
                            tipo  : 1
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
                    url   : '${createLink(action:"loadTreePart_nuevo")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            tipo  : 2
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
                    url   : '${createLink(action:"loadTreePart_nuevo")}',
                    data  : function (node) {
                        return {
                            id    : node.id,
                            tipo  : 3
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
        var tipoGrupo = $node.data("tipo");
        var nodeHasChildren = $node.hasClass("hasChildren");
        var abueloId = null;

        if(esDepartamento){
            abueloId = $node.parent().parent().parent().parent().children()[1].id.split("_")[1];
        }else{
            abueloId = parentId
        }

        var items = {};

        var nuevoGrupo = {
            label  : "Nuevo grupo",
            icon   : "fa fa-copyright text-info",
            action : function () {
                createEditGrupo(null, nodeId);
            }
        };

        var editarGrupo = {
            label  : "Editar grupo",
            icon   : "fa fa-copyright text-info",
            action : function () {
                createEditGrupo(nodeId, parentId);
            }
        };

        var nuevoSubgrupo = {
            label  : "Nuevo subgrupo",
            icon   : "fa fa-registered text-danger",
            action : function () {
                createEditSubgrupo(null, nodeId, abueloId);
            }
        };

        var editarSubgrupo = {
            label  : "Editar subgrupo",
            icon   : "fa fa-registered text-danger",
            action : function () {
                createEditSubgrupo(nodeId, parentId, abueloId);
            }
        };

        var nuevoMaterial = {
            label  : "Nuevo material",
            icon   : "fa fa-info-circle text-warning",
            action : function () {
                createEditItem(null, nodeId);
            }
        };

        var nuevaManoObra = {
            label  : "Nueva mano de obra",
            icon   : "fa fa-info-circle text-warning",
            action : function () {
                createEditItem(null, nodeId);
            }
        };

        var nuevoEquipo = {
            label  : "Nuevo equipo",
            icon   : "fa fa-info-circle text-warning",
            action : function () {
                createEditItem(null, nodeId);
            }
        };

        var editarMaterial = {
            label  : "Editar material",
            icon   : "fa fa-info-circle text-warning",
            action : function () {
                createEditItem(nodeId, parentId);
            }
        };

        var editarManoObra = {
            label  : "Editar mano de obra",
            icon   : "fa fa-info-circle text-warning",
            action : function () {
                createEditItem(nodeId, parentId);
            }
        };

        var editarEquipo = {
            label  : "Editar equipo",
            icon   : "fa fa-info-circle text-warning",
            action : function () {
                createEditItem(nodeId, parentId);
            }
        };

        var verItem = {
            label            : "Ver información del Item",
            icon             : "fa fa-laptop text-info",
            separator_before : true,
            action           : function () {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'infoItems')}",
                    data    : {
                        id : nodeId
                    },
                    success : function (msg) {
                        bootbox.dialog({
                            title   : "Ver información del Item",
                            message : msg,
                            class : 'modal-lg',
                            buttons : {
                                ok : {
                                    label     : "Aceptar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                }
                            }
                        });
                    }
                });
            }
        };

        var borrarGrupo = {
            label            : "Eliminar Grupo",
            icon             : "fa fa-trash text-danger",
            separator_before : true,
            action           : function () {
                bootbox.confirm({
                    title: "Eliminar Grupo",
                    message: "Está seguro de borrar este grupo? Esta acción no puede deshacerse.",
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
                        if(result){
                            var dialog = cargarLoader("Borrando...");
                            $.ajax({
                                type: 'POST',
                                url: '${createLink(action: 'deleteSg_ajax')}',
                                data:{
                                    id: nodeId
                                },
                                success: function (msg) {
                                    dialog.modal('hide');
                                    if(msg === 'OK'){
                                        log("Grupo borrado correctamente","success");
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
                                        log("Error al borrar el grupo", "error")
                                    }
                                }
                            });
                        }
                    }
                });
            }
        };

        var borrarSubgrupo = {
            label            : "Eliminar subgrupo",
            icon             : "fa fa-trash text-danger",
            separator_before : true,
            action           : function () {
                bootbox.confirm({
                    title: "Eliminar subgrupo",
                    message: "Está seguro de borrar este subgrupo? Esta acción no puede deshacerse.",
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
                        if(result){
                            var dialog = cargarLoader("Borrando...");
                            $.ajax({
                                type: 'POST',
                                url: '${createLink(action: 'deleteDp_ajax')}',
                                data:{
                                    id: nodeId
                                },
                                success: function (msg) {
                                    dialog.modal('hide');
                                    if(msg === 'OK'){
                                        log("Subgrupo borrado correctamente","success");
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
                                        log("Error al borrar el Subgrupo", "error")
                                    }
                                }
                            });
                        }
                    }
                });
            }
        };

        var borrarItem = {
            label            : "Eliminar item",
            icon             : "fa fa-trash text-danger",
            separator_before : true,
            action           : function () {
                bootbox.confirm({
                    title: "Eliminar item",
                    message: "Está seguro de borrar este item? Esta acción no puede deshacerse.",
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
                        if(result){
                            var dialog = cargarLoader("Borrando...");
                            $.ajax({
                                type: 'POST',
                                url: '${createLink(action: 'deleteIt_ajax')}',
                                data:{
                                    id: nodeId
                                },
                                success: function (msg) {
                                    dialog.modal('hide');
                                    if(msg === 'OK'){
                                        log("Borrado correctamente","success");
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
                                        log("Error al borrar", "error")
                                    }
                                }
                            });
                        }
                    }
                });
            }
        };

        var copiarOferentes = {
            label            : "Copiar a oferentes",
            icon             : "fa fa-file text-success",
            separator_before : true,
            action           : function () {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'copiarOferentes')}",
                    data    : {
                        id : nodeId
                    },
                    success : function (msg) {
                        var parts =  msg.split("_");
                        if(parts[0] === 'OK'){
                            log("Item copiado a oferentes","success")
                        }else{
                            log("Error al copiar el item a oferentes","error")
                        }
                    }
                });
            }
        };


        if (esRoot) {
        } else if (esPrincipal) {
            if(tipoGrupo !== 2){
                items.nuevoGrupo = nuevoGrupo;
            }
        } else if (esSubgrupo) {
            if(tipoGrupo !== 2){
                items.editarGrupo = editarGrupo;
            }
            items.nuevoSubgrupo = nuevoSubgrupo;
            if(!nodeHasChildren){
                items.borrarGrupo = borrarGrupo;
            }
        } else if (esDepartamento) {
            items.editarSubgrupo = editarSubgrupo;
            if(tipoGrupo === 1){
                items.nuevoMaterial= nuevoMaterial;
            }else if(tipoGrupo === 2){
                items.nuevaManoObra= nuevaManoObra;
            }else if(tipoGrupo === 3){
                items.nuevoEquipo= nuevoEquipo;
            }
            if(!nodeHasChildren){
                items.borrarSubgrupo = borrarSubgrupo;
            }

        } else if (esItem) {
            items.verItem = verItem;
            if(tipoGrupo === 1){
                items.editarMaterial= editarMaterial;
            }else if(tipoGrupo === 2){
                items.editarManoObra= editarManoObra;
            }else if(tipoGrupo === 3){
                items.editarEquipo= editarEquipo;
            }
            items.copiarOferentes = copiarOferentes;
            if(!nodeHasChildren){
                items.borrarItem = borrarItem;
            }
        }
        return items;
    }

    function createEditSubgrupo(id, parentId, abueloId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        if (parentId) {
            data.subgrupo = parentId;
        }
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formDp_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditDP",
                    title : title + " subgrupo",
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
                                return submitFormSubgrupo(abueloId);
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

    function submitFormSubgrupo(tipo) {
        var $form = $("#frmSave");
        var $btn = $("#dlgCreateEditDP").find("#btnSave");
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

    function createEditGrupo(id, parentId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        data.grupo = parentId;
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formSg_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditGP",
                    title : title + " grupo",
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
                                return submitFormGrupo(parentId);
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

    function submitFormGrupo(tipo) {
        var $form = $("#frmSave");
        var $btn = $("#dlgCreateEditGP").find("#btnSave");
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

    function createEditItem(id, parentId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        if (parentId) {
            data.departamento = parentId;
        }

        data.grupo = tipoSeleccionado;

        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formIt_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditIT",
                    title : title + " item",
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
                                return submitFormItem();
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

    function submitFormItem() {
        var $form = $("#frmSave");
        var $btn = $("#dlgCreateEditIT").find("#btnSave");
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
                            if(parts[2] === '1'){
                                recargarMateriales();
                            }else if(parts[2] === '2'){
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