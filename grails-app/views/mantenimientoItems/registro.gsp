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

<g:if test="${flash.message}">
    <div class="span12">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </div>
</g:if>

<div class="span12 btn-group" data-toggle="buttons-radio">
    <a href="#" id="btnMateriales" class="btn btn-info">
        <i class="fa fa-folder"></i>
        Materiales
    </a>
    <a href="#" id="btnMano" class="btn btn-info ">
        <i class="fa fa-user"></i>
        Mano de obra
    </a>
    <a href="#" id="btnEquipos" class="btn btn-info ">
        <i class="fa fa-box"></i>
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

    <div class="col-md-4 hidden" id="divSearchRes">
        <span id="spanSearchRes">
            5 resultados
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

<div id="tree" class="ui-corner-all"></div>
<div id="tree2" class="ui-corner-all hide"></div>
<div id="tree3" class="ui-corner-all hide"></div>


<script type="text/javascript">

    $("#btnMateriales").click(function () {
        $("#tree").removeClass("hide");
        $("#tree2").addClass("hide") ;
        $("#tree3").addClass("hide");
        $("#btnMateriales").addClass('active');
        $("#btnMano").removeClass('active');
        $("#btnEquipos").removeClass('active');
        $("#alerta1").removeClass('hide');
        $("#alerta2").addClass('hide');
        $("#alerta3").addClass('hide');

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
                        console.log("--> " + node.id);
                        return {
                            id    : node.id,
                            tipo  : 1
                        };
                    }
                }
            },
            contextmenu : {
                show_at_node : false,
                // items        : createContextMenu
            },
            state       : {
                key : "unidades",
                opened: false
            },
            %{--search      : {--}%
            %{--    fuzzy             : false,--}%
            %{--    show_only_matches : false,--}%
            %{--    ajax              : {--}%
            %{--        url     : "${createLink(action:'arbolSearch_ajax')}",--}%
            %{--        success : function (msg) {--}%
            %{--            var json = $.parseJSON(msg);--}%
            %{--            $.each(json, function (i, obj) {--}%
            %{--                $('#tree').jstree("open_node", obj);--}%
            %{--            });--}%
            %{--            setTimeout(function () {--}%
            %{--                searchRes = $(".jstree-search");--}%
            %{--                var cantRes = searchRes.length;--}%
            %{--                posSearchShow = 0;--}%
            %{--                $("#divSearchRes").removeClass("hidden");--}%
            %{--                $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);--}%
            %{--                scrollToSearchRes();--}%
            %{--            }, 300);--}%

            %{--        }--}%
            %{--    }--}%
            %{--},--}%
            types       : {
                root                : {
                    icon : "fa fa-sitemap text-info"
                }
            }
        });
    });

    $("#btnMano").click(function () {
        $("#tree").addClass("hide");
        $("#tree2").removeClass("hide") ;
        $("#tree3").addClass("hide");
        $("#btnMateriales").removeClass('active');
        $("#btnMano").addClass('active');
        $("#btnEquipos").removeClass('active');
        $("#alerta1").addClass('hide');
        $("#alerta2").removeClass('hide');
        $("#alerta3").addClass('hide');

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
                        console.log("--> " + node.id);
                        return {
                            id    : node.id,
                            tipo  : 2
                        };
                    }
                }
            },
            contextmenu : {
                show_at_node : false,
                // items        : createContextMenu
            },
            state       : {
                key : "unidades",
                opened: false
            },
            %{--search      : {--}%
            %{--    fuzzy             : false,--}%
            %{--    show_only_matches : false,--}%
            %{--    ajax              : {--}%
            %{--        url     : "${createLink(action:'arbolSearch_ajax')}",--}%
            %{--        success : function (msg) {--}%
            %{--            var json = $.parseJSON(msg);--}%
            %{--            $.each(json, function (i, obj) {--}%
            %{--                $('#tree').jstree("open_node", obj);--}%
            %{--            });--}%
            %{--            setTimeout(function () {--}%
            %{--                searchRes = $(".jstree-search");--}%
            %{--                var cantRes = searchRes.length;--}%
            %{--                posSearchShow = 0;--}%
            %{--                $("#divSearchRes").removeClass("hidden");--}%
            %{--                $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);--}%
            %{--                scrollToSearchRes();--}%
            %{--            }, 300);--}%

            %{--        }--}%
            %{--    }--}%
            %{--},--}%
            types       : {
                root                : {
                    icon : "fa fa-sitemap text-info"
                }
            }
        });
    });

    $("#btnEquipos").click(function () {
        $("#tree").addClass("hide");
        $("#tree2").addClass("hide") ;
        $("#tree3").removeClass("hide");
        $("#btnMateriales").removeClass('active');
        $("#btnMano").removeClass('active');
        $("#btnEquipos").addClass('active');
        $("#alerta1").addClass('hide');
        $("#alerta2").addClass('hide');
        $("#alerta3").removeClass('hide');

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
                        console.log("--> " + node.id);
                        return {
                            id    : node.id,
                            tipo  : 3
                        };
                    }
                }
            },
            contextmenu : {
                show_at_node : false,
                // items        : createContextMenu
            },
            state       : {
                key : "unidades",
                opened: false
            },
            %{--search      : {--}%
            %{--    fuzzy             : false,--}%
            %{--    show_only_matches : false,--}%
            %{--    ajax              : {--}%
            %{--        url     : "${createLink(action:'arbolSearch_ajax')}",--}%
            %{--        success : function (msg) {--}%
            %{--            var json = $.parseJSON(msg);--}%
            %{--            $.each(json, function (i, obj) {--}%
            %{--                $('#tree').jstree("open_node", obj);--}%
            %{--            });--}%
            %{--            setTimeout(function () {--}%
            %{--                searchRes = $(".jstree-search");--}%
            %{--                var cantRes = searchRes.length;--}%
            %{--                posSearchShow = 0;--}%
            %{--                $("#divSearchRes").removeClass("hidden");--}%
            %{--                $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);--}%
            %{--                scrollToSearchRes();--}%
            %{--            }, 300);--}%

            %{--        }--}%
            %{--    }--}%
            %{--},--}%
            types       : {
                root                : {
                    icon : "fa fa-sitemap text-info"
                }
            }
        });
    });


    // var searchRes = [];
    // var posSearchShow = 0;
    // var $treeContainer = $("#tree");
    //
    // function scrollToNode($scrollTo) {
    //     $treeContainer.jstree("deselect_all").jstree("select_node", $scrollTo).animate({
    //         scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
    //     });
    // }
    //
    // function scrollToRoot() {
    //     var $scrollTo = $("#root");
    //     scrollToNode($scrollTo);
    // }
    //
    // function scrollToSearchRes() {
    //     var $scrollTo = $(searchRes[posSearchShow]).parents("li").first();
    //     $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
    //     scrollToNode($scrollTo);
    // }

    %{--$(function () {--}%

    %{--    $treeContainer.on("loaded.jstree", function () {--}%
    %{--        $("#cargando").hide();--}%
    %{--        $("#tree").removeClass("hidden");--}%

    %{--    }).on("select_node.jstree", function (node, selected, event) {--}%
    %{--    }).jstree({--}%
    %{--        plugins     : ["types", "state", "contextmenu", "search"],--}%
    %{--        core        : {--}%
    %{--            multiple       : false,--}%
    %{--            check_callback : true,--}%
    %{--            themes         : {--}%
    %{--                variant : "small",--}%
    %{--                dots    : true,--}%
    %{--                stripes : true--}%
    %{--            },--}%
    %{--            data           : {--}%
    %{--                url   : '${createLink(action:"loadTreePart")}',--}%
    %{--                data  : function (node) {--}%
    %{--                    console.log("--> " + node.id);--}%
    %{--                    return {--}%
    %{--                        // id    : node.id,--}%
    %{--                        // id    :node.rel,--}%
    %{--                        id:1,--}%
    %{--                        --}%%{--sort  : "${params.sort?:'nombre'}",--}%
    %{--                        --}%%{--order : "${params.order?:'asc'}",--}%
    %{--                        tipo: "grupo_manoObra"--}%

    %{--                    };--}%
    %{--                }--}%
    %{--            }--}%
    %{--        },--}%
    %{--        contextmenu : {--}%
    %{--            show_at_node : false,--}%
    %{--            // items        : createContextMenu--}%
    %{--        },--}%
    %{--        state       : {--}%
    %{--            key : "unidades",--}%
    %{--            opened: false--}%
    %{--        },--}%
    %{--        search      : {--}%
    %{--            fuzzy             : false,--}%
    %{--            show_only_matches : false,--}%
    %{--            ajax              : {--}%
    %{--                url     : "${createLink(action:'arbolSearch_ajax')}",--}%
    %{--                success : function (msg) {--}%
    %{--                    var json = $.parseJSON(msg);--}%
    %{--                    $.each(json, function (i, obj) {--}%
    %{--                        $('#tree').jstree("open_node", obj);--}%
    %{--                    });--}%
    %{--                    setTimeout(function () {--}%
    %{--                        searchRes = $(".jstree-search");--}%
    %{--                        var cantRes = searchRes.length;--}%
    %{--                        posSearchShow = 0;--}%
    %{--                        $("#divSearchRes").removeClass("hidden");--}%
    %{--                        $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + cantRes);--}%
    %{--                        scrollToSearchRes();--}%
    %{--                    }, 300);--}%

    %{--                }--}%
    %{--            }--}%
    %{--        },--}%
    %{--        types       : {--}%
    %{--            root                : {--}%
    %{--                icon : "fa fa-sitemap text-info"--}%
    %{--            },--}%
    %{--            yachay              : {--}%
    %{--                icon : "fa fa-building text-info"--}%
    %{--            },--}%
    %{--            unidadPadreActivo   : {--}%
    %{--                icon : "fa fa-building-o text-info"--}%
    %{--            },--}%
    %{--            unidadPadreInactivo : {--}%
    %{--                icon : "fa fa-building-o text-muted"--}%
    %{--            },--}%
    %{--            unidadHijoActivo    : {--}%
    %{--                icon : "fa fa-home text-success"--}%
    %{--            },--}%
    %{--            unidadHijoInactivo  : {--}%
    %{--                icon : "fa fa-home text-muted"--}%
    %{--            },--}%
    %{--            usuarioActivo       : {--}%
    %{--                icon : "fa fa-user text-info"--}%
    %{--            },--}%
    %{--            usuarioInactivo     : {--}%
    %{--                icon : "fa fa-user text-muted"--}%
    %{--            }--}%
    %{--        }--}%
    %{--    });--}%

    %{--    $("#btnExpandAll").click(function () {--}%
    %{--        $treeContainer.jstree("open_all");--}%
    %{--        scrollToRoot();--}%
    %{--        return false;--}%
    %{--    });--}%

    %{--    $("#btnCollapseAll").click(function () {--}%
    %{--        $treeContainer.jstree("close_all");--}%
    %{--        scrollToRoot();--}%
    %{--        return false;--}%
    %{--    });--}%

    %{--    $('#btnSearchArbol').click(function () {--}%
    %{--        $treeContainer.jstree("open_all");--}%
    %{--        $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));--}%
    %{--        return false;--}%
    %{--    });--}%
    %{--    $("#searchArbol").keypress(function (ev) {--}%
    %{--        if (ev.keyCode === 13) {--}%
    %{--            $treeContainer.jstree("open_all");--}%
    %{--            $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));--}%
    %{--            return false;--}%
    %{--        }--}%
    %{--    });--}%

    %{--    $("#btnPrevSearch").click(function () {--}%
    %{--        if (posSearchShow > 0) {--}%
    %{--            posSearchShow--;--}%
    %{--        } else {--}%
    %{--            posSearchShow = searchRes.length - 1;--}%
    %{--        }--}%
    %{--        scrollToSearchRes();--}%
    %{--        return false;--}%
    %{--    });--}%

    %{--    $("#btnNextSearch").click(function () {--}%
    %{--        if (posSearchShow < searchRes.length - 1) {--}%
    %{--            posSearchShow++;--}%
    %{--        } else {--}%
    %{--            posSearchShow = 0;--}%
    %{--        }--}%
    %{--        scrollToSearchRes();--}%
    %{--        return false;--}%
    %{--    });--}%

    %{--    $("#btnClearSearch").click(function () {--}%
    %{--        $treeContainer.jstree("clear_search");--}%
    %{--        $("#searchArbol").val("");--}%
    %{--        posSearchShow = 0;--}%
    %{--        searchRes = [];--}%
    %{--        scrollToRoot();--}%
    %{--        $("#divSearchRes").addClass("hidden");--}%
    %{--        $("#spanSearchRes").text("");--}%
    %{--    });--}%

    %{--});--}%

    %{--$.jGrowl.defaults.closerTemplate = '<div>[ cerrar todo ]</div>';--}%

    %{--var btn = $("<a href='#' class='btn' id='btnSearch'><i class='icon-zoom-in'></i> Buscar</a>");--}%
    %{--var urlSp = "${resource(dir: 'images', file: 'spinner.gif')}";--}%
    %{--var sp = $('<span class="add-on" id="btnSearch"><img src="' + urlSp + '"/></span>');--}%

    %{--var current = "1";--}%

    %{--var icons = {--}%
    %{--    edit                     : "${resource(dir: 'images/tree', file: 'edit.png')}",--}%
    %{--    delete                   : "${resource(dir: 'images/tree', file: 'delete.gif')}",--}%
    %{--    info                     : "${resource(dir: 'images/tree', file: 'info.png')}",--}%
    %{--    copiar                   : "${resource(dir: 'images/tree', file: 'copiar.png')}",--}%

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
    %{--    item_consultoria : "${resource(dir: 'images/tree', file: 'item_manoObra.png')}"--}%
    %{--};--}%

    // function log(msg, error) {
    //     var sticky = false;
    //     var theme = "success";
    //     if (error) {
    //         sticky = true;
    //         theme = "error";
    //     }
    //     $.jGrowl(msg, {
    //         speed          : 'slow',
    //         sticky         : sticky,
    //         theme          : theme,
    //         closerTemplate : '<div>[ cerrar todos ]</div>',
    //         themeState     : ''
    //     });
    // }

    %{--function showInfo() {--}%
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
    %{--    }--}%

    %{--    $.ajax({--}%
    %{--        type    : "POST",--}%
    %{--        url     : url,--}%
    %{--        data    : {--}%
    %{--            id : nodeId--}%
    %{--        },--}%
    %{--        success : function (msg) {--}%
    %{--            $("#info").html(msg);--}%
    %{--        }--}%
    %{--    });--}%
    %{--}--}%

    //
    // function createUpdate(params) {
    //     var obj = {
    //         label            : params.label,
    //         separator_before : params.sepBefore, // Insert a separator before the item
    //         separator_after  : params.sepAfter, // Insert a separator after the item
    //         icon             : params.icon,
    //         action           : function (obj) {
    //             $.ajax({
    //                 type     : "POST",
    //                 url      : params.url,
    //                 data     : params.data,
    //                 success  : function (msg) {
    //                     var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
    //                     var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-ok"></i> Guardar</a>');
    //
    //                     btnSave.click(function () {
    //                         if ($("#frmSave").valid()) {
    //                             btnSave.replaceWith(spinner);
    //                             var url = $("#frmSave").attr("action");
    //                             $.ajax({
    //                                 type    : "POST",
    //                                 url     : url,
    //                                 data    : $("#frmSave").serialize(),
    //                                 success : function (msg) {
    //                                     var parts = msg.split("_");
    //                                     if (parts[0] == "OK") {
    //                                         if (params.action == "create") {
    //                                             if (params.open) {
    //                                                 $("#" + params.nodeStrId).removeClass("jstree-leaf").addClass("jstree-closed");
    //                                                 $('#tree').jstree("open_node", $("#" + params.nodeStrId));
    //                                             }
    //                                             $('#tree').jstree("create_node", $("#" + params.nodeStrId), params.where, {attr : {id : params.tipo + "_" + parts[2]}, data : parts[3]});
    //                                             $("#modal-tree").modal("hide");
    //                                             log(params.log + parts[3] + " creado correctamente");
    //                                         } else if (params.action == "update") {
    //                                             $("#tree").jstree('rename_node', $("#" + params.nodeStrId), parts[3]);
    //                                             $("#modal-tree").modal("hide");
    //                                             log(params.log + parts[3] + " editado correctamente");
    //                                             showInfo();
    //                                         }
    //                                     } else {
    //                                         $("#modal-tree").modal("hide");
    //                                         log("Ha ocurrido el siguiente error: " + parts[1], true);
    //                                     }
    //                                 }
    //                             });
    //                         }
    //                         return false;
    //                     });
    //                     if (params.action === "create") {
    //                         $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
    //                     } else if (params.action === "update") {
    //                         $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
    //                     }
    //                     $("#modalTitle").html(params.title);
    //                     $("#modalBody").html(msg);
    //                     $("#modalFooter").html("").append(btnOk).append(btnSave);
    //                     $("#modal-tree").modal("show");
    //                 },
    //                 complete : function () {
    //                     $('#modalBody').animate({scrollTop : $('#frmSave').offset().top}, 'slow');
    //
    //                 }
    //             });
    //         }
    //     };
    //     return obj;
    // }

    // function remove(params) {
    //     var obj = {
    //         label            : params.label,
    //         separator_before : params.sepBefore, // Insert a separator before the item
    //         separator_after  : params.sepAfter, // Insert a separator after the item
    //         icon             : params.icon,
    //         action           : function (obj) {
    //
    //             var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
    //             var btnSave = $('<a href="#"  class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');
    //             $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
    //             $("#modalTitle").html(params.title);
    //             $("#modalBody").html("<p>Está seguro de querer eliminar este " + params.confirm + "?</p>");
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
    //                         if (parts[0] === "OK") {
    //                             $("#tree").jstree('delete_node', $("#" + params.nodeStrId));
    //                             $("#modal-tree").modal("hide");
    //                             log(params.log + " eliminado correctamente");
    //                             if ($("#" + params.parentStrId).children("ul").children().size() === 0) {
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

    %{--    function createContextmenu(node) {--}%
    %{--        var parent = node.parent().parent();--}%

    %{--        var nodeStrId = node.attr("id");--}%
    %{--        var nodeText = $.trim(node.children("a").text());--}%

    %{--        var parentStrId = parent.attr("id");--}%
    %{--        var parentText = $.trim(parent.children("a").text());--}%

    %{--        var nodeRel = node.attr("rel");--}%
    %{--        var parts = nodeRel.split("_");--}%
    %{--        var nodeNivel = parts[0];--}%
    %{--        var nodeTipo = parts[1];--}%

    %{--        var parentRel = parent.attr("rel");--}%
    %{--        parts = nodeRel.split("_");--}%
    %{--        var parentNivel = parts[0];--}%
    %{--        var parentTipo = parts[1];--}%

    %{--        parts = nodeStrId.split("_");--}%
    %{--        var nodeId = parts[1];--}%

    %{--        parts = parentStrId.split("_");--}%
    %{--        var parentId = parts[1];--}%

    %{--        var nodeHasChildren = node.hasClass("hasChildren");--}%
    %{--        var cantChildren = node.children("ul").children().size();--}%
    %{--        nodeHasChildren = nodeHasChildren || cantChildren != 0;--}%

    %{--        var menuItems = {}, lbl = "", item = "";--}%

    %{--        switch (nodeTipo) {--}%
    %{--            case "material":--}%
    %{--                lbl = "o material";--}%
    %{--                item = "Material";--}%
    %{--                break;--}%
    %{--            case "manoObra":--}%
    %{--                lbl = "a mano de obra";--}%
    %{--                item = "Mano de obra";--}%
    %{--                break;--}%
    %{--            case "equipo":--}%
    %{--                lbl = "o equipo";--}%
    %{--                item = "Equipo";--}%
    %{--                break;--}%
    %{--        }--}%

    %{--//                console.log(nodeNivel);--}%

    %{--        switch (nodeNivel) {--}%
    %{--            case "grupo":--}%
    %{--                if (current === 2) {--}%
    %{--                    menuItems.crearHijo = createUpdate({--}%
    %{--                        action    : "create",--}%
    %{--                        label     : "Nuevo subgrupo",--}%
    %{--                        sepBefore : false,--}%
    %{--                        sepAfter  : false,--}%
    %{--                        icon      : icons["departamento_" + nodeTipo],--}%
    %{--                        url       : "${createLink(action:'formDp_ajax')}",--}%
    %{--                        data      : {--}%
    %{--                            subgrupo : nodeId--}%
    %{--                        },--}%
    %{--                        open      : true,--}%
    %{--                        nodeStrId : nodeStrId,--}%
    %{--                        where     : "first",--}%
    %{--                        tipo      : "dp",--}%
    %{--                        log       : "Subgrupo ",--}%
    %{--                        title     : "Nuevo subgrupo"--}%
    %{--                    });--}%
    %{--                } else {--}%
    %{--                    menuItems.crearHijo = createUpdate({--}%
    %{--                        action    : "create",--}%
    %{--                        label     : "Nuevo grupo",--}%
    %{--                        icon      : icons["subgrupo_" + nodeTipo],--}%
    %{--                        sepBefore : false,--}%
    %{--                        sepAfter  : false,--}%
    %{--                        url       : "${createLink(action:'formSg_ajax')}",--}%
    %{--                        data      : {--}%
    %{--                            grupo : nodeId--}%
    %{--                        },--}%
    %{--                        open      : false,--}%
    %{--                        nodeStrId : nodeStrId,--}%
    %{--                        where     : "first",--}%
    %{--                        tipo      : "sg",--}%
    %{--                        log       : "Grupo ",--}%
    %{--                        title     : "Nuevo grupo"--}%
    %{--                    });--}%
    %{--                }--}%
    %{--                break;--}%
    %{--            case "subgrupo":--}%
    %{--                menuItems.editar = createUpdate({--}%
    %{--                    action    : "update",--}%
    %{--                    label     : "Editar grupo",--}%
    %{--                    icon      : icons.edit,--}%
    %{--                    sepBefore : false,--}%
    %{--                    sepAfter  : false,--}%
    %{--                    url       : "${createLink(action:'formSg_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        grupo : parentId,--}%
    %{--                        id    : nodeId--}%
    %{--                    },--}%
    %{--                    open      : false,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    log       : "Grupo ",--}%
    %{--                    title     : "Editar grupo"--}%
    %{--                });--}%
    %{--                if (!nodeHasChildren) {--}%
    %{--                    menuItems.eliminar = remove({--}%
    %{--                        label       : "Eliminar grupo",--}%
    %{--                        sepBefore   : false,--}%
    %{--                        sepAfter    : false,--}%
    %{--                        icon        : icons.delete,--}%
    %{--                        title       : "Eliminar grupo",--}%
    %{--                        confirm     : "grupo",--}%
    %{--                        url         : "${createLink(action:'deleteSg_ajax')}",--}%
    %{--                        data        : {--}%
    %{--                            id : nodeId--}%
    %{--                        },--}%
    %{--                        nodeStrId   : nodeStrId,--}%
    %{--                        parentStrId : parentStrId,--}%
    %{--                        log         : "Grupo "--}%
    %{--                    });--}%
    %{--                }--}%
    %{--                menuItems.crearHermano = createUpdate({--}%
    %{--                    action    : "create",--}%
    %{--                    label     : "Nuevo grupo",--}%
    %{--                    icon      : icons[nodeRel],--}%
    %{--                    sepBefore : true,--}%
    %{--                    sepAfter  : true,--}%
    %{--                    url       : "${createLink(action:'formSg_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        grupo : parentId--}%
    %{--                    },--}%
    %{--                    open      : false,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    where     : "after",--}%
    %{--                    tipo      : "sg",--}%
    %{--                    log       : "Grupo ",--}%
    %{--                    title     : "Nuevo grupo"--}%
    %{--                });--}%
    %{--                menuItems.crearHijo = createUpdate({--}%
    %{--                    action    : "create",--}%
    %{--                    label     : "Nuevo subgrupo",--}%
    %{--                    sepBefore : false,--}%
    %{--                    sepAfter  : false,--}%
    %{--                    icon      : icons["departamento_" + nodeTipo],--}%
    %{--                    url       : "${createLink(action:'formDp_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        subgrupo : nodeId--}%
    %{--                    },--}%
    %{--                    open      : true,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    where     : "first",--}%
    %{--                    tipo      : "dp",--}%
    %{--                    log       : "Subgrupo ",--}%
    %{--                    title     : "Nuevo subgrupo"--}%
    %{--                });--}%
    %{--                break;--}%
    %{--            case "departamento":--}%

    %{--                menuItems.editar = createUpdate({--}%
    %{--                    action    : "update",--}%
    %{--                    label     : "Editar subgrupo",--}%
    %{--                    icon      : icons.edit,--}%
    %{--                    sepBefore : false,--}%
    %{--                    sepAfter  : false,--}%
    %{--                    url       : "${createLink(action:'formDp_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        subgrupo : parentId,--}%
    %{--                        id       : nodeId--}%
    %{--                    },--}%
    %{--                    open      : false,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    log       : "Subgrupo ",--}%
    %{--                    title     : "Editar subgrupo"--}%
    %{--                });--}%
    %{--                if (!nodeHasChildren) {--}%
    %{--                    menuItems.eliminar = remove({--}%
    %{--                        label       : "Eliminar subgrupo",--}%
    %{--                        sepBefore   : false,--}%
    %{--                        sepAfter    : false,--}%
    %{--                        icon        : icons.delete,--}%
    %{--                        title       : "Eliminar subgrupo",--}%
    %{--                        confirm     : "subgrupo",--}%
    %{--                        url         : "${createLink(action:'deleteDp_ajax')}",--}%
    %{--                        data        : {--}%
    %{--                            id : nodeId--}%
    %{--                        },--}%
    %{--                        nodeStrId   : nodeStrId,--}%
    %{--                        parentStrId : parentStrId,--}%
    %{--                        log         : "Subgrupo "--}%
    %{--                    });--}%
    %{--                }--}%
    %{--                menuItems.crearHermano = createUpdate({--}%
    %{--                    action    : "create",--}%
    %{--                    label     : "Nuevo subgrupo",--}%
    %{--                    sepBefore : true,--}%
    %{--                    sepAfter  : true,--}%
    %{--                    icon      : icons[nodeRel],--}%
    %{--                    url       : "${createLink(action:'formDp_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        subgrupo : parentId--}%
    %{--                    },--}%
    %{--                    open      : false,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    where     : "after",--}%
    %{--                    tipo      : "dp",--}%
    %{--                    log       : "Subgrupo ",--}%
    %{--                    title     : "Nuevo subgrupo"--}%
    %{--                });--}%
    %{--                menuItems.crearHijo = createUpdate({--}%
    %{--                    action    : "create",--}%
    %{--                    label     : "Nuev" + lbl,--}%
    %{--                    sepBefore : false,--}%
    %{--                    sepAfter  : false,--}%
    %{--                    icon      : icons["item_" + nodeTipo],--}%
    %{--                    url       : "${createLink(action:'formIt_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        departamento : nodeId,--}%
    %{--                        grupo        : current--}%
    %{--                    },--}%
    %{--                    open      : true,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    where     : "first",--}%
    %{--                    tipo      : "it",--}%
    %{--                    log       : item + " ",--}%
    %{--                    title     : "Nuevo " + item.toLowerCase()--}%
    %{--                });--}%
    %{--                break;--}%
    %{--            case "item":--}%
    %{--                menuItems.editar = createUpdate({--}%
    %{--                    action    : "update",--}%
    %{--                    label     : "Editar " + item.toLowerCase(),--}%
    %{--                    icon      : icons.edit,--}%
    %{--                    sepBefore : false,--}%
    %{--                    sepAfter  : false,--}%
    %{--                    url       : "${createLink(action:'formIt_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        departamento : parentId,--}%
    %{--                        id           : nodeId,--}%
    %{--                        grupo        : current--}%
    %{--                    },--}%
    %{--                    open      : false,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    log       : item + " ",--}%
    %{--                    title     : "Editar " + item.toLowerCase()--}%
    %{--                });--}%
    %{--                menuItems.info = {--}%
    %{--                    label            : "Información",--}%
    %{--                    separator_before : false, // Insert a separator before the item--}%
    %{--                    separator_after  : false, // Insert a separator after the item--}%
    %{--                    icon             : icons.info,--}%
    %{--                    action           : function (obj) {--}%
    %{--                        $.ajax({--}%
    %{--                            type    : "POST",--}%
    %{--                            url     : "${createLink(action: 'infoItems')}",--}%
    %{--                            data    : {--}%
    %{--                                id : nodeId--}%
    %{--                            },--}%
    %{--                            success : function (msg) {--}%
    %{--                                var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Aceptar</a>');--}%
    %{--                                $("#modalHeader").removeClass("btn-edit btn-show btn-delete");--}%

    %{--                                $("#modalTitle").html("Información del item");--}%
    %{--                                $("#modalBody").html(msg);--}%
    %{--                                $("#modalFooter").html("").append(btnOk);--}%
    %{--                                $("#modal-tree").modal("show");--}%
    %{--                            }--}%
    %{--                        });--}%
    %{--                    }--}%
    %{--                };--}%
    %{--                menuItems.copiar = {--}%
    %{--                    label            : "Copiar a oferentes",--}%
    %{--                    separator_before : false, // Insert a separator before the item--}%
    %{--                    separator_after  : false, // Insert a separator after the item--}%
    %{--                    icon             : icons.copiar,--}%
    %{--                    action           : function (obj) {--}%
    %{--                        $.ajax({--}%
    %{--                            type    : "POST",--}%
    %{--                            url     : "${createLink(action: 'copiarOferentes')}",--}%
    %{--                            data    : {--}%
    %{--                                id : nodeId--}%
    %{--                            },--}%
    %{--                            success : function (msg) {--}%
    %{--                                var p = msg.split("_");--}%
    %{--                                var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Aceptar</a>');--}%
    %{--                                $("#modalTitleSmall").html("Información");--}%
    %{--                                if (p[0] === "OK") {--}%
    %{--                                    $("#modalBodySmall").html("El item fue copiado a oferentes");--}%
    %{--                                } else {--}%
    %{--                                    $("#modalBodySmall").html(p[1]);--}%
    %{--                                }--}%
    %{--                                $("#modalFooterSmall").html("").append(btnOk);--}%
    %{--                                $("#modal-small").modal("show");--}%
    %{--                            }--}%
    %{--                        });--}%
    %{--                    }--}%
    %{--                };--}%
    %{--                if (!nodeHasChildren) {--}%
    %{--                    menuItems.eliminar = {--}%
    %{--                        label            : "Eliminar",--}%
    %{--                        separator_before : false, // Insert a separator before the item--}%
    %{--                        separator_after  : false, // Insert a separator after the item--}%
    %{--                        icon             : icons.delete,--}%
    %{--                        action           : function (obj) {--}%
    %{--                            $.ajax({--}%
    %{--                                type    : "POST",--}%
    %{--                                url     : "${createLink(action: 'infoItems')}",--}%
    %{--                                data    : {--}%
    %{--                                    id     : nodeId,--}%
    %{--                                    delete : 1--}%
    %{--                                },--}%
    %{--                                success : function (msg) {--}%
    %{--                                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Aceptar</a>');--}%
    %{--                                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete");--}%

    %{--                                    $("#modalTitle").html("Eliminar item");--}%
    %{--                                    $("#modalBody").html(msg);--}%
    %{--                                    $("#modalFooter").html("").append(btnOk);--}%
    %{--                                    $("#modal-tree").modal("show");--}%
    %{--                                }--}%
    %{--                            });--}%
    %{--                        }--}%
    %{--                    };--}%
    %{--                }--}%
    %{--                menuItems.crearHermano = createUpdate({--}%
    %{--                    action    : "create",--}%
    %{--                    label     : "Nuev" + lbl,--}%
    %{--                    sepBefore : true,--}%
    %{--                    sepAfter  : true,--}%
    %{--                    icon      : icons[nodeRel],--}%
    %{--                    url       : "${createLink(action:'formIt_ajax')}",--}%
    %{--                    data      : {--}%
    %{--                        departamento : parentId,--}%
    %{--                        grupo        : current--}%
    %{--                    },--}%
    %{--                    open      : false,--}%
    %{--                    nodeStrId : nodeStrId,--}%
    %{--                    where     : "after",--}%
    %{--                    tipo      : "it",--}%
    %{--                    log       : item + " ",--}%
    %{--                    title     : "Nuevo " + item--}%
    %{--                });--}%
    %{--                break;--}%
    %{--        }--}%

    %{--        return menuItems;--}%
    %{--    }--}%

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

    %{--    console.log('Carga árbol');--}%

    %{--    $("#tree").bind("loaded.jstree",--}%
    %{--        function (event, data) {--}%
    %{--            $("#cargando").addClass("hide");--}%
    %{--            $("#treeArea").addClass("show");--}%
    %{--        }).jstree({--}%
    %{--        "core"        : {--}%
    %{--            "initially_open" : [ id ]--}%
    %{--        },--}%
    %{--        "plugins"     : ["themes", "html_data", "json_data", "ui", "types", "contextmenu", "search", "crrm"/*, "dnd"/*, "wholerow"*/],--}%
    %{--        "html_data"   : {--}%
    %{--            "data" : "<ul type='root'>" + li + "</ul>",--}%
    %{--            "ajax" : {--}%
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
    %{--                    return {id : id, tipo : tipo}--}%
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
    %{--                "grupo_material"        : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.grupo_material--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "subgrupo_material" ]--}%
    %{--                },--}%
    %{--                "subgrupo_material"     : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.subgrupo_material--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "departamento_material" ]--}%
    %{--                },--}%
    %{--                "departamento_material" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.departamento_material--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "item_material" ]--}%
    %{--                },--}%
    %{--                "item_material"         : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.item_material--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "" ]--}%
    %{--                },--}%

    %{--                "grupo_manoObra"        : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.grupo_manoObra--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "departamento_manoObra" ]--}%
    %{--                },--}%
    %{--                "subgrupo_manoObra"     : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.subgrupo_manoObra--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "departamento_manoObra" ]--}%
    %{--                },--}%
    %{--                "departamento_manoObra" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.departamento_manoObra--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "item_manoObra" ]--}%
    %{--                },--}%
    %{--                "item_manoObra"         : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.item_manoObra--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "" ]--}%
    %{--                },--}%

    %{--                "grupo_equipo"        : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.grupo_equipo--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "subgrupo_equipo" ]--}%
    %{--                },--}%
    %{--                "subgrupo_equipo"     : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.subgrupo_equipo--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "departamento_equipo" ]--}%
    %{--                },--}%
    %{--                "departamento_equipo" : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.departamento_equipo--}%
    %{--                    },--}%
    %{--                    "valid_children" : [ "item_equipo" ]--}%
    %{--                },--}%
    %{--                "item_equipo"         : {--}%
    %{--                    "icon"           : {--}%
    %{--                        "image" : icons.item_equipo--}%
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
    %{--        $("#cantRes").html("<b>" + cant + "</b> resultado" + (cant === 1 ? "" : "s"));--}%
    %{--        if (cant > 0) {--}%
    %{--            var container = $('#tree'), scrollTo = $('.jstree-search').first();--}%
    %{--            container.animate({--}%
    %{--                scrollTop : scrollTo.offset().top - container.offset().top + container.scrollTop()--}%
    %{--            }, 2000);--}%
    %{--        }--}%
    %{--    }).bind("select_node.jstree", function (NODE, REF_NODE) {--}%
    %{--        showInfo();--}%
    %{--    })--}%
    %{--}--}%

    // function doSearch() {
    //     var val = $.trim($("#search").val());
    //     if (val !== "") {
    //         $("#btnSearch").replaceWith(sp);
    //         $("#tree").jstree("search", val);
    //     }
    // }
    //
    // $(function () {
    //
    //     $("#search").val("");
    //
    //     $(".toggle").click(function () {
    //         var tipo = $(this).attr("id");
    //         if (tipo !== current) {
    //             current = tipo;
    //             initTree(current);
    //         }
    //     });
    //
    //     initTree("1");
    //
    //     $("#btnSearch").click(function () {
    //         doSearch();
    //     });
    //
    //     $("#search").keyup(function (ev) {
    //         if (ev.keyCode === 13) {
    //             doSearch();
    //         }
    //     });
    //
    // });
</script>

</body>
</html>