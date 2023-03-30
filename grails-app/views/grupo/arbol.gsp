<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Grupos de Rubros</title>
    <asset:javascript src="/jstree-3.0.8/dist/jstree.min.js"/>
    <asset:stylesheet src="/jstree-3.0.8/dist/themes/default/style.min.css"/>
</head>

<body>

<div class="col-md-12 btn-group" style="margin-bottom: 10px" >

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

    <div class="col-md-1" >
        <div class="btn-group">
            <a href="#" class="btn btn-success" id="btnCollapseAll" title="Cerrar todos los nodos">
                <i class="fa fa-minus-square"></i> Cerrar todo&nbsp;
            </a>
        </div>
    </div>

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

</div>

<div id="cargando" class="text-center hide">
    <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Cargando...' width="64px" height="64px"/>
    <p>Cargando...Por favor espere</p>
</div>

<div id="tree" class="col-md-8 ui-corner-all hide" style="overflow: auto"></div>
<div id="info" class="col-md-4 ui-corner-all hide" style="border-style: groove; border-color: #0d7bdc"></div>

<script type="text/javascript">

    var searchRes = [];
    var posSearchShow = 0;
    var $treeContainer = $("#tree");

    $("#btnCollapseAll").click(function () {
        $("#tree").jstree("close_all");
        var $scrollTo = $("#root");
        $("#tree").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
            scrollTop : $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
        });
        recargarArbol();

        $("#info").addClass('hide');
        $("#info").html('');

        return false;
    });

    function recargarArbol () {
        $("#tree").removeClass("hide");
        var $treeContainer = $("#tree");
        $treeContainer.jstree("refresh")
    }

    function showInfo() {
        var node = $("#tree").jstree(true).get_selected();

        var nodeId = node.toString().split("_")[1];
        var nodeNivel = node.toString().split("_")[0];

        if(nodeNivel !== 'root'){
            cargarInfo(nodeNivel, nodeId);
        }
    }

    function cargarInfo(nodeNivel, nodeId){
        switch (nodeNivel) {
            case "gr":
                url = "${createLink(action:'showGr_ajax')}";
                break;
            case "sg":
                url = "${createLink(action:'showSg_ajax')}";
                break;
            case "dp":
                url = "${createLink(action:'showDp_ajax')}";
                break;
            case "rb":
                url = "${createLink(action:'showRb_ajax')}";
                break;
        }

        $.ajax({
            type    : "POST",
            url     : url,
            data    : {
                id : nodeId
            },
            success : function (msg) {
                $("#info").removeClass('hide').html(msg);
            }
        });
    }

    function imprimirRubrosGrupo(id, tipo) {
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'imprimirRubros_ajax')}",
            data    : {
                id: id,
                tipo: tipo
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgImprimir",
                    title   : "Variables de transporte para el grupo",
                    class : "modal-lg",
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
    } //createEdit

    function createContextMenu(node) {

        var nodeStrId = node.id;
        var $node = $("#" + nodeStrId);
        var nodeId = nodeStrId.split("_")[1];
        var tipo = nodeStrId.split("_")[0];
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

        var editarSolicitante = {
            label  : "Editar solicitante",
            icon   : "fa fa-parking text-success",
            action : function () {
                createEditSolicitante(nodeId);
            }
        };

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

        var imprimirGrupo = {
            label  : "Imprimir rubros del grupo",
            icon   : "fa fa-print text-warning",
            action : function () {
                imprimirRubrosGrupo(nodeId, tipo)
            }
        };

        var imprimirSubGrupo = {
            label  : "Imprimir rubros del subgrupo",
            icon   : "fa fa-print text-warning",
            action : function () {
                imprimirRubrosGrupo(nodeId, tipo)
            }
        };

        var imprimirCapitulo = {
            label  : "Imprimir capítulo",
            icon   : "fa fa-print text-warning",
            action : function () {
                imprimirRubrosGrupo(nodeId, tipo)
            }
        };

        var imprimirRubro = {
            label  : "Imprimir rubro",
            icon   : "fa fa-print text-warning",
            action : function () {
                imprimirRubrosGrupo(nodeId, tipo)
            }
        };

        var borrarGrupo = {
            label            : "Borrar Grupo",
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
                                        recargarArbol();
                                        $("#info").addClass('hide').html('');
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

        var borrarSolicitante = {
            label            : "Eliminar solicitante",
            icon             : "fa fa-trash text-danger",
            separator_before : true,
            action           : function () {
                bootbox.confirm({
                    title: "Eliminar solicitante",
                    message: "Está seguro de borrar este solicitante? Esta acción no puede deshacerse.",
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
                                url: '${createLink(action: 'deleteGr_ajax')}',
                                data:{
                                    id: nodeId
                                },
                                success: function (msg) {
                                    dialog.modal('hide');
                                    if(msg === 'OK'){
                                        log("Solicitante borrado correctamente","success");
                                        recargarArbol();
                                        $("#info").addClass('hide').html('');
                                    }else{
                                        log("Error al borrar el solicitante", "error")
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
                    title: "Eliminar item",
                    message: "Está seguro de borrar este registro? Esta acción no puede deshacerse.",
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
                                        log("Borrado correctamente","success");
                                        recargarArbol();
                                        $("#info").addClass('hide').html('');
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

        if (esRoot) {
        } else if (esPrincipal) {
            items.editarSolicitante = editarSolicitante;
            if(tipoGrupo !== 2){
                items.nuevoGrupo = nuevoGrupo;
            }
            items.imprimirGrupo = imprimirGrupo;
            if(!nodeHasChildren){
                items.borrarSolicitante = borrarSolicitante;
            }
        } else if (esSubgrupo) {
            if(tipoGrupo !== 2){
                items.editarGrupo = editarGrupo;
            }
            items.nuevoSubgrupo = nuevoSubgrupo;
            items.imprimirSubgrupo = imprimirSubGrupo;
            if(!nodeHasChildren){
                items.borrarGrupo = borrarGrupo;
            }
        } else if (esDepartamento) {
            items.editarSubgrupo = editarSubgrupo;
            items.imprimirCapitulo = imprimirCapitulo;
            if(!nodeHasChildren){
                items.borrarSubgrupo = borrarSubgrupo;
            }

        } else if (esItem) {
            items.imprimirRubro = imprimirRubro;
        }
        return items;
    }

    function createEditSolicitante(id) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formGr_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditGP",
                    title : title + " solicitante",
                    // class : "modal-lg",
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
                                return submitForm();
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

    function submitForm() {
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
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        recargarArbol();
                        showInfo();
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
            url     : "${createLink( action:'formSg_gr_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditGP",
                    title : title + " grupo",
                    // class : "modal-lg",
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
                                return submitForm();
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

    function createEditSubgrupo(id, parentId, abueloId) {
        var title = id ? "Editar" : "Crear";
        var data = id ? {id : id} : {};
        if (parentId) {
            data.subgrupo = parentId;
        }
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formDp_gr_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditDP",
                    title : title + " subgrupo",
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
                                return submitForm();
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

    cargarArbol();

    function cargarArbol() {
        var $treeContainer = $("#tree");
        $treeContainer.removeClass("hide");
        $("#info").html("");
        $("#cargando").removeClass('hide');

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
                    url   : '${createLink(action:"loadTree")}',
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

    function scrollToNode($scrollTo) {
        $("#tree").jstree("deselect_all").jstree("select_node", $scrollTo).animate({
            scrollTop: $scrollTo.offset().top - $treeContainer.offset().top + $treeContainer.scrollTop() - 50
        });
    }

    function scrollToSearchRes() {
        var $scrollTo = $(searchRes[posSearchShow]).parents("li").first();
        $("#spanSearchRes").text("Resultado " + (posSearchShow + 1) + " de " + searchRes.length);
        scrollToNode($scrollTo);
    }

    $('#btnSearchArbol').click(function () {
        // $treeContainer.jstree("open_all");
        $treeContainer.jstree(true).search($.trim($("#searchArbol").val()));
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
        $("#searchArbol").val("");
        posSearchShow = 0;
        searchRes = [];
        $("#divSearchRes").addClass("hidden");
        $("#spanSearchRes").text("");
        $("#info").addClass('hide');
    }

</script>
</body>
</html>