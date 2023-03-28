<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Grupos de Rubros</title>

    %{--    <g:if test="${janus.Parametros.findByEmpresaLike(message(code: 'ambiente2'))}">--}%
    %{--        <link href="${resource(dir: 'css', file: 'treeV2.css')}" rel="stylesheet"/>--}%
    %{--    </g:if>--}%
    %{--    <g:else>--}%
    .
    %{--        <link href="${resource(dir: 'css', file: 'tree.css')}" rel="stylesheet"/>--}%
    %{--    </g:else>--}%

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

<div class="modal longModal hide fade" id="modal-tree">
    <div class="modal-header" id="modalHeader">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle"></h3>
    </div>

    <div class="modal-body" id="modalBody">
    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>

<div class="modal large hide fade " id="modal-transporte" style="overflow: hidden;">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modal_trans_title">
            Variables de transporte
        </h3>
    </div>

    <div class="modal-body" id="modal_trans_body">
        <div class="row-fluid">

            <div class="span2">
                Lista de precios: MO y Equipos
            </div>

            <div class="span3">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=6')}" optionKey="id"
                          optionValue="descripcion" id="ciudad" style="width: 170px"/>
            </div>

            <div class="span1">
                Fecha
            </div>

            <div class="span2">
                <elm:datepicker name="item.fecha" class="" style="width: 90px;" id="fecha_precios" value="${new java.util.Date()}" format="dd-MM-yyyy"/>
            </div>

            <div class="span2" style="width: 120px;">
                % costos indirectos
            </div>

            <div class="span1">
                <input type="text" style="width: 30px;" id="costo_indi" value="22.5">
            </div>
        </div>
        <hr style="margin: 5px 0 10px 0;"/>

        <div class="row-fluid">
            <div class="span1">
                Volquete
            </div>

            <div class="span3" style="margin-left: 10px;">
                <g:select style="width: 165px;" name="volquetes" from="${volquetes2}" optionKey="id" optionValue="nombre" id="cmb_vol" noSelection="${['-1': 'Seleccione']}" value="${aux.volquete.id}"/>
            </div>

            <div class="span1" style="width: 35px; margin-left: 5px;">
                Costo
            </div>

            <div class="span1" style="margin-left: 5px; width: 90px;">
                <input type="text" style="width: 69px;text-align: right" disabled="" id="costo_volqueta">
            </div>

            <div class="span1" style="margin-left: 5px;">
                Chofer
            </div>

            <div class="span3" style="margin-left: 5px;">
                <g:select style="width: 165px;" name="volquetes" from="${choferes}" optionKey="id" optionValue="nombre" id="cmb_chof" noSelection="${['-1': 'Seleccione']}" value="${aux.chofer.id}"/>
            </div>

            <div class="span1" style="width: 35px;margin-left: 5px;">
                Costo
            </div>

            <div class="span1" style="margin-left: 5px; width: 90px;">
                <input type="text" style="width: 69px;text-align: right" disabled="" id="costo_chofer">
            </div>
        </div>

        <div class="row-fluid" style="border-bottom: 1px solid black;margin-bottom: 10px">
            <div class="span6">
                <b>Distancia peso</b>
            </div>

            <div class="span5" style="margin-left: 30px;">
                <b>Distancia volumen</b>
            </div>
        </div>

        <div class="row-fluid">
            <div class="span2">
                Canton
            </div>

            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_p1" value="10.00">
            </div>

            <div class="span4">
                Materiales Petreos Hormigones
            </div>

            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_v1" value="20.00">
            </div>

        </div>

        <div class="row-fluid">
            <div class="span2">
                Especial
            </div>

            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_p2" value="10.00">
            </div>

            <div class="span4">
                Materiales Mejoramiento
            </div>

            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_v2" value="20.00">
            </div>
        </div>

        <div class="row-fluid">
            <div class="span5">

            </div>

            <div class="span4">
                Materiales Carpeta Asfáltica
            </div>

            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_v3" value="20.00">
            </div>
        </div>

        <div class="row-fluid" style="border-bottom: 1px solid black;margin-bottom: 10px">
            <div class="span6">
                <b>Listas de precios</b>
            </div>
        </div>

        <div class="row-fluid">
            <div class="span1">
                Cantón
            </div>

            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=1')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_1"/>
            </div>

            <div class="span3">
                Petreos Hormigones
            </div>

            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=3')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_3"/>
            </div>
        </div>

        <div class="row-fluid">
            <div class="span1">
                Especial
            </div>

            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=2')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_2"/>
            </div>

            <div class="span3">
                Mejoramiento
            </div>

            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=4')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_4"/>
            </div>
        </div>

        <div class="row-fluid">
            <div class="span5"></div>

            <div class="span3">
                Carpeta Asfáltica
            </div>

            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=5')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_5"/>
            </div>
        </div>
    </div>

    <div class="modal-footer" id="modal_trans_footer">
        <g:hiddenField name="nodeId" val=""/>
        <g:hiddenField name="nodeGrupo" val=""/>
        <a href= "#" data-dismiss="modal" class="btn btn-primary" id="print_totales" data-transporte="true"><i class="icon-print"></i> Consolidado</a>
        <a href="#" data-dismiss="modal" class="btn btn-primary btnPrint" data-transporte="si"><i class="icon-print"></i> Con </br>transporte</a>
        <a href="#" data-dismiss="modal" class="btn btn-primary btnPrint" data-transporte="no"><i class="icon-print"></i> Sin </br>transporte</a>
        <a href="#" data-dismiss="modal" class="btn btn-primary btnPrintVae" data-transporte="si"><i class="icon-print"></i> VAE con </br>transporte</a>
        <a href="#" data-dismiss="modal" class="btn btn-primary btnPrintVae" data-transporte="no"><i class="icon-print"></i> VAE sin </br>transporte</a>
        <a href="#" data-dismiss="modal" class="btn" id="btnCancel">Cancelar</a>
    </div>
</div>



%{--<div class="modal large hide fade " id="modal-transporte2" style="overflow: hidden;">--}%
%{--    <div class="modal-header btn-primary">--}%
%{--        <button type="button" class="close" data-dismiss="modal">×</button>--}%

%{--        <h3 id="modal_trans_title2">--}%
%{--            Variables de transporte para el Grupo--}%
%{--        </h3>--}%
%{--    </div>--}%

%{--    <div class="modal-body" id="modal_trans_body2">--}%
%{--        <div class="row-fluid">--}%

%{--            <div class="span2">--}%
%{--                Lista de precios: MO y Equipos--}%
%{--            </div>--}%

%{--            <div class="span3">--}%
%{--                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=6')}" optionKey="id"--}%
%{--                          optionValue="descripcion" id="ciudad" style="width: 170px"/>--}%
%{--            </div>--}%

%{--            <div class="span1">--}%
%{--                Fecha--}%
%{--            </div>--}%

%{--            <div class="span2">--}%
%{--                <elm:datepicker name="item.fecha" class="" style="width: 90px;" id="fecha_precios2" value="${new java.util.Date()}"--}%
%{--                                format="dd-MM-yyyy"/>--}%
%{--            </div>--}%

%{--            <div class="span2" style="width: 120px;">--}%
%{--                % costos indirectos--}%
%{--            </div>--}%

%{--            <div class="span1">--}%
%{--                <input type="text" style="width: 30px;" id="costo_indi2" value="22.5">--}%
%{--            </div>--}%
%{--        </div>--}%
%{--        <hr style="margin: 5px 0 10px 0;"/>--}%

%{--        <div class="row-fluid">--}%
%{--            <div class="span1">--}%
%{--                Volquete--}%
%{--            </div>--}%

%{--            <div class="span3" style="margin-left: 10px;">--}%
%{--                <g:select style="width: 165px;" name="volquetes" from="${volquetes2}" optionKey="id" optionValue="nombre" id="cmb_vol2" noSelection="${['-1': 'Seleccione']}" value="${aux.volquete.id}"/>--}%
%{--            </div>--}%

%{--            <div class="span1" style="width: 35px; margin-left: 5px;">--}%
%{--                Costo--}%
%{--            </div>--}%

%{--            <div class="span1" style="margin-left: 5px; width: 90px;">--}%
%{--                <input type="text" style="width: 69px;text-align: right" disabled="" id="costo_volqueta2">--}%
%{--            </div>--}%

%{--            <div class="span1" style="margin-left: 5px;">--}%
%{--                Chofer--}%
%{--            </div>--}%

%{--            <div class="span3" style="margin-left: 5px;">--}%
%{--                <g:select style="width: 165px;" name="volquetes" from="${choferes}" optionKey="id" optionValue="nombre" id="cmb_chof2" noSelection="${['-1': 'Seleccione']}" value="${aux.chofer.id}"/>--}%
%{--            </div>--}%

%{--            <div class="span1" style="width: 35px;margin-left: 5px;">--}%
%{--                Costo--}%
%{--            </div>--}%

%{--            <div class="span1" style="margin-left: 5px; width: 90px;">--}%
%{--                <input type="text" style="width: 69px;text-align: right" disabled="" id="costo_chofer2">--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="row-fluid" style="border-bottom: 1px solid black;margin-bottom: 10px">--}%
%{--            <div class="span6">--}%
%{--                <b>Distancia peso</b>--}%
%{--            </div>--}%

%{--            <div class="span5" style="margin-left: 30px;">--}%
%{--                <b>Distancia volumen</b>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="row-fluid">--}%
%{--            <div class="span2">--}%
%{--                Canton--}%
%{--            </div>--}%

%{--            <div class="span3">--}%
%{--                <input type="text" style="width: 50px;" id="dist_p1g" value="10.00">--}%
%{--            </div>--}%

%{--            <div class="span4">--}%
%{--                Materiales Petreos Hormigones--}%
%{--            </div>--}%

%{--            <div class="span3">--}%
%{--                <input type="text" style="width: 50px;" id="dist_v1g" value="20.00">--}%
%{--            </div>--}%

%{--        </div>--}%

%{--        <div class="row-fluid">--}%
%{--            <div class="span2">--}%
%{--                Especial--}%
%{--            </div>--}%

%{--            <div class="span3">--}%
%{--                <input type="text" style="width: 50px;" id="dist_p2g" value="10.00">--}%
%{--            </div>--}%

%{--            <div class="span4">--}%
%{--                Materiales Mejoramiento--}%
%{--            </div>--}%

%{--            <div class="span3">--}%
%{--                <input type="text" style="width: 50px;" id="dist_v2g" value="20.00">--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="row-fluid">--}%
%{--            <div class="span5">--}%

%{--            </div>--}%

%{--            <div class="span4">--}%
%{--                Materiales Carpeta Asfáltica--}%
%{--            </div>--}%

%{--            <div class="span3">--}%
%{--                <input type="text" style="width: 50px;" id="dist_v3g" value="20.00">--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="row-fluid" style="border-bottom: 1px solid black;margin-bottom: 10px">--}%
%{--            <div class="span6">--}%
%{--                <b>Listas de precios</b>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="row-fluid">--}%
%{--            <div class="span1">--}%
%{--                Cantón--}%
%{--            </div>--}%

%{--            <div class="span4">--}%
%{--                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=1')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_1g"/>--}%
%{--            </div>--}%

%{--            <div class="span3">--}%
%{--                Petreos Hormigones--}%
%{--            </div>--}%

%{--            <div class="span4">--}%
%{--                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=3')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_3g"/>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="row-fluid">--}%
%{--            <div class="span1">--}%
%{--                Especial--}%
%{--            </div>--}%

%{--            <div class="span4">--}%
%{--                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=2')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_2g"/>--}%
%{--            </div>--}%

%{--            <div class="span3">--}%
%{--                Mejoramiento--}%
%{--            </div>--}%

%{--            <div class="span4">--}%
%{--                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=4')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_4g"/>--}%
%{--            </div>--}%
%{--        </div>--}%

%{--        <div class="row-fluid">--}%
%{--            <div class="span5"></div>--}%

%{--            <div class="span3">--}%
%{--                Carpeta Asfáltica--}%
%{--            </div>--}%

%{--            <div class="span4">--}%
%{--                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=5')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_5g"/>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="modal-footer" id="modal_trans_footer2">--}%
%{--        <g:hiddenField name="nodeId" val=""/>--}%
%{--        <g:hiddenField name="nodeGrupo" val=""/>--}%
%{--        <a href= "#" data-dismiss="modal" class="btn btn-primary" id="imp_consolidado" data-transporte="true"><i class="icon-print"></i>Consolidado</a>--}%
%{--        <a href= "#" data-dismiss="modal" class="btn btn-primary" id="imp_consolidado_excel" data-transporte="true"><i class="icon-table"></i> Consolidado Excel</a>--}%
%{--        <a href="#" data-dismiss="modal" class="btn" id="btnCancel">Cancelar</a>--}%
%{--    </div>--}%
%{--</div>--}%

<script type="text/javascript">

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

    function imprimirRubrosGrupo(id) {
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'imprimirRubros_ajax')}",
            data    : {
                id: id
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


    function getPrecios($cmb, $txt, $fcha) {
        if ($cmb.val() !== "-1") {
            var datos = "fecha=" + $fcha.val() + "&ciudad=" + $("#ciudad").val() + "&ids=" + $cmb.val();
            $.ajax({
                type    : "POST",
                url     : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                data    : datos,
                success : function (msg) {
                    var precios = msg.split("&");
                    for (var i = 0; i < precios.length; i++) {
                        var parts = precios[i].split(";");
                        if (parts.length > 1) {
                            $txt.val(parts[1].trim());
                        }
                    }
                }
            });
        } else {
            $txt.val("0.00");
        }
    }

    function imprimir(params) {
        $("#nodeId").val(params.id);
        if(params.grupo) {
            $("#nodeGrupo").val(params.grupo);
        } else {
            $("#nodeGrupo").val();
        }
        return obj = {
            label            : params.label,
            separator_before : params.sepBefore, // Insert a separator before the item
            separator_after  : params.sepAfter, // Insert a separator after the item
            icon             : params.icon,
            action           : function (obj) {
                $("#modal-transporte").modal("show");
            }
        };
    }

    function imprimirConsolidado(params) {
        $("#nodeId").val(params.id);
        if(params.grupo) {
            $("#nodeGrupo").val(params.grupo);
        } else {
            $("#nodeGrupo").val();
        }
        return  obj = {
            label            : params.label,
            separator_before : params.sepBefore, // Insert a separator before the item
            separator_after  : params.sepAfter, // Insert a separator after the item
            icon             : params.icon,
            action           : function (obj) {
                $("#modal-transporte2").dialog("open");
                $("#fecha_precios2").change();
            }
        };
    }

    $("#modal-transporte2").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 220,
        position: 'center',
        title: 'No se ha generado la Matriz!',
        buttons: {
            "Aceptar": function () {
                $("#modal-transporte2").dialog("close");
            }
        }
    });

    // function createUpdate(params) {
    //     return obj = {
    //         label            : params.label,
    //         separator_before : params.sepBefore, // Insert a separator before the item
    //         separator_after  : params.sepAfter, // Insert a separator after the item
    //         icon             : params.icon,
    //         action           : function (obj) {
    //             $.ajax({
    //                 type    : "POST",
    //                 url     : params.url,
    //                 data    : params.data,
    //                 success : function (msg) {
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
    //                 }
    //             });
    //         }
    //     };
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
    //                         if (parts[0] == "OK") {
    //                             $("#tree").jstree('delete_node', $("#" + params.nodeStrId));
    //                             $("#modal-tree").modal("hide");
    //                             log(params.log + " eliminado correctamente");
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

    function createContextmenu_old(node) {
        var parent = node.parent().parent();

        var nodeStrId = node.attr("id");
        var nodeText = $.trim(node.children("a").text());

        var parentStrId = parent.attr("id");
        var parentText = $.trim(parent.children("a").text());

        var nodeRel = node.attr("rel");
        var parts = nodeRel.split("_");
        var nodeNivel = parts[0];
        var nodeTipo = parts[1];

        var parentRel = parent.attr("rel");
        parts = nodeRel.split("_");
        var parentNivel = parts[0];
        var parentTipo = parts[1];

        parts = nodeStrId.split("_");
        var nodeId = parts[1];

        parts = parentStrId.split("_");
        var parentId = parts[1];

        var nodeHasChildren = node.hasClass("hasChildren");
        var cantChildren = node.children("ul").children().size();
        nodeHasChildren = nodeHasChildren || cantChildren != 0;

        var menuItems = {}, lbl = "", item = "";

        switch (nodeTipo) {
            case "material":
                lbl = "o material";
                item = "Material";
                break;
            case "manoObra":
                lbl = "a mano de obra";
                item = "Mano de obra";
                break;
            case "equipo":
                lbl = "o equipo";
                item = "Equipo";
                break;
        }

//                ////console.log(nodeNivel);

        switch (nodeNivel) {
            case "root":

                menuItems.crearHijo = createUpdate({
                    action    : "create",
                    label     : "Nuevo Solicitante",
                    icon      : icons.grupo,
//                    icon      : icons[nodeRel],
                    sepBefore : false,
                    sepAfter  : false,
                    url       : "${createLink(action:'formGr_ajax')}",
                    data      : {
                        grupo : nodeId
                    },
                    open      : false,
                    nodeStrId : nodeStrId,
                    where     : "first",
                    tipo      : "sg",
                    log       : "Grupo ",
                    title     : "Nuevo Solicitante"
                });

                break;
            case "grupo":
                menuItems.editar = createUpdate({
                    action    : "update",
                    label     : "Editar Solicitante",
                    icon      : icons.edit,
                    sepBefore : false,
                    sepAfter  : false,
                    url       : "${createLink(action:'formGr_ajax')}",
                    data      : {
                        grupo : parentId,
                        id    : nodeId
                    },
                    open      : false,
                    nodeStrId : nodeStrId,
                    log       : "Grupo ",
                    title     : "Editar Solicitante"
                });
                if (!nodeHasChildren) {
                    menuItems.eliminar = remove({
                        label       : "Eliminar Solicitante",
                        sepBefore   : false,
                        sepAfter    : false,
                        icon        : icons.delete,
                        title       : "Eliminar Solicitante",
                        confirm     : "grupo",
                        url         : "${createLink(action:'deleteGr_ajax')}",
                        data        : {
                            id : nodeId
                        },
                        nodeStrId   : nodeStrId,
                        parentStrId : parentStrId,
                        log         : "Grupo "
                    });
                }
                menuItems.crearHermano = createUpdate({
                    action    : "create",
                    label     : "Nuevo Solicitante",
                    icon      : icons[nodeRel],
                    sepBefore : true,
                    sepAfter  : true,
                    url       : "${createLink(action:'formGr_ajax')}",
                    data      : {
                        grupo : parentId
                    },
                    open      : false,
                    nodeStrId : nodeStrId,
                    where     : "after",
                    tipo      : "sg",
                    log       : "Grupo ",
                    title     : "Nuevo Solicitante"
                });
                menuItems.crearHijo = createUpdate({
                    action    : "create",
                    label     : "Nuevo Grupo",
                    sepBefore : false,
                    sepAfter  : false,
                    icon      : icons.subgrupo,
                    url       : "${createLink(action:'formSg_gr_ajax')}",
                    data      : {
                        grupo : nodeId
                    },
                    open      : true,
                    nodeStrId : nodeStrId,
                    where     : "first",
                    tipo      : "sg",
                    log       : "Subgrupo ",
                    title     : "Nuevo Grupo"
                });
                menuItems.print = imprimirConsolidado({
                    id        : nodeStrId,
                    label     : "Imprimir rubros del grupo",
                    sepBefore : true,
                    sepAfter  : false,
                    icon      : icons.print
                });

                break;

            case "subgrupo":
                menuItems.editar = createUpdate({
                    action    : "update",
                    label     : "Editar Grupo",
                    icon      : icons.edit,
                    sepBefore : false,
                    sepAfter  : false,
                    url       : "${createLink(action:'formSg_gr_ajax')}",
                    data      : {
                        grupo : parentId,
                        id    : nodeId
                    },
                    open      : false,
                    nodeStrId : nodeStrId,
                    log       : "Subgrupo ",
                    title     : "Editar Grupo"
                });
                if (!nodeHasChildren) {
                    menuItems.eliminar = remove({
                        label       : "Eliminar Grupo",
                        sepBefore   : false,
                        sepAfter    : false,
                        icon        : icons.delete,
                        title       : "Eliminar Grupo",
                        confirm     : "grupo",
                        url         : "${createLink(action:'deleteSg_ajax')}",
                        data        : {
                            id : nodeId
                        },
                        nodeStrId   : nodeStrId,
                        parentStrId : parentStrId,
                        log         : "Subgrupo "
                    });
                }
                menuItems.crearHermano = createUpdate({
                    action    : "create",
                    label     : "Nuevo Grupo",
                    icon      : icons[nodeRel],
                    sepBefore : true,
                    sepAfter  : true,
                    url       : "${createLink(action:'formSg_gr_ajax')}",
                    data      : {
                        grupo : parentId
                    },
                    open      : false,
                    nodeStrId : nodeStrId,
                    where     : "after",
                    tipo      : "sg",
                    log       : "Subgrupo ",
                    title     : "Nuevo Grupo"
                });
                menuItems.crearHijo = createUpdate({
                    action    : "create",
                    label     : "Nuevo subgrupo",
                    sepBefore : false,
                    sepAfter  : false,
                    icon      : icons.departamento,
                    url       : "${createLink(action:'formDp_gr_ajax')}",
                    data      : {
                        subgrupo : nodeId
                    },
                    open      : true,
                    nodeStrId : nodeStrId,
                    where     : "first",
                    tipo      : "dp",
                    log       : "Departamento ",
                    title     : "Nuevo subgrupo"
                });
                menuItems.print = imprimir({
                    id        : nodeStrId,
                    label     : "Imprimir rubros subgrupo",
                    sepBefore : true,
                    sepAfter  : false,
                    icon      : icons.print
                });
                break;
            case "departamento":

                menuItems.editar = createUpdate({
                    action    : "update",
                    label     : "Editar subgrupo",
                    icon      : icons.edit,
                    sepBefore : false,
                    sepAfter  : false,
                    url       : "${createLink(action:'formDp_gr_ajax')}",
                    data      : {
                        subgrupo : parentId,
                        id       : nodeId
                    },
                    open      : false,
                    nodeStrId : nodeStrId,
                    log       : "Departamento ",
                    title     : "Editar subgrupo"
                });
                if (!nodeHasChildren) {
                    menuItems.eliminar = remove({
                        label       : "Eliminar subgrupo",
                        sepBefore   : false,
                        sepAfter    : false,
                        icon        : icons.delete,
                        title       : "Eliminar subgrupo",
                        confirm     : "departamento",
                        url         : "${createLink(action:'deleteDp_ajax')}",
                        data        : {
                            id : nodeId
                        },
                        nodeStrId   : nodeStrId,
                        parentStrId : parentStrId,
                        log         : "Departamento "
                    });
                }
                menuItems.crearHermano = createUpdate({
                    action    : "create",
                    label     : "Nuevo subgrupo",
                    sepBefore : true,
                    sepAfter  : true,
                    icon      : icons[nodeRel],
                    url       : "${createLink(action:'formDp_gr_ajax')}",
                    data      : {
                        subgrupo : parentId
                    },
                    open      : false,
                    nodeStrId : nodeStrId,
                    where     : "after",
                    tipo      : "dp",
                    log       : "Departamento ",
                    title     : "Nuevo subgrupo"
                });
                menuItems.print = imprimir({
                    id        : nodeStrId,
                    label     : "Imprimir capítulo",
                    sepBefore : true,
                    sepAfter  : false,
                    icon      : icons.print
                });
                break;
            case "rubro":
                menuItems.print = imprimir({
                    id        : nodeStrId,
                    label     : "Imprimir rubro",
                    sepBefore : true,
                    sepAfter  : false,
                    icon      : icons.print
                });
                break;

        }

        return menuItems;
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
                imprimirRubrosGrupo(nodeId)
            }
        };

        var imprimirSubGrupo = {
            label  : "Imprimir rubros del subgrupo",
            icon   : "fa fa-print text-warning",
            action : function () {
                createEditItem(nodeId, parentId);
            }
        };

        var imprimirCapitulo = {
            label  : "Imprimir capítulo",
            icon   : "fa fa-print text-warning",
            action : function () {
                createEditItem(nodeId, parentId);
            }
        };

        var imprimirRubro = {
            label  : "Imprimir rubro",
            icon   : "fa fa-print text-warning",
            action : function () {
                createEditItem(nodeId, parentId);
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
        }).bind("select_node.jstree", function (node, selected) {
            showInfo();
        });
    }

    function doSearch() {
        var val = $.trim($("#search").val());
        if (val != "") {
            $("#btnSearch").replaceWith(sp);
            $("#tree").jstree("search", val);
        }
    }

    $(function () {
        $("#search").val("");

        // initTree();

        $("#fecha_precios").change(function(){
            $("#cmb_vol").change()
            $("#cmb_chof").change()
        })
        $("#fecha_precios2").change(function(){
            $("#cmb_vol2").change()
            $("#cmb_chof2").change()
        })

        $("#cmb_vol").change(function () {
            getPrecios($("#cmb_vol"), $("#costo_volqueta"), $("#fecha_precios"));
        });
        $("#cmb_vol2").change(function () {
            getPrecios($("#cmb_vol2"), $("#costo_volqueta2"), $("#fecha_precios2"));
        });

        $("#cmb_chof").change(function () {
            getPrecios($("#cmb_chof"), $("#costo_chofer"), $("#fecha_precios"));
        });
        $("#cmb_chof2").change(function () {
            getPrecios($("#cmb_chof2"), $("#costo_chofer2"), $("#fecha_precios2"));
        });

        getPrecios($("#cmb_chof"), $("#costo_chofer"), $("#fecha_precios"));
        getPrecios($("#cmb_vol"), $("#costo_volqueta"), $("#fecha_precios"));

        $("#btnSearch").click(function () {
            doSearch();
        });
        $("#search").keyup(function (ev) {
            if (ev.keyCode == 13) {
                doSearch();
            }
        });

        $(".btnPrint").click(function () {

            var dsp0 = $("#dist_p1").val();
            var dsp1 = $("#dist_p2").val();
            var dsv0 = $("#dist_v1").val();
            var dsv1 = $("#dist_v2").val();
            var dsv2 = $("#dist_v3").val();
            var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," + $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val();
            var volqueta = $("#costo_volqueta").val();
            var chofer = $("#costo_chofer").val();
            var trans = $(this).data("transporte");
            var nodeId = $("#nodeId").val();

            var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 +
                "&dsv2=" + dsv2 + "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val() +
                "&id=" + nodeId + "&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof").val() +
                "&volq=" + $("#cmb_vol").val() + "&indi=" + $("#costo_indi").val() + "&trans=" + trans;
            location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosTransporteGrupo')}?" + datos;

            $("#modal-transporte").modal("hide");
            return false;
        });

        $(".btnPrintVae").click(function () {
            var dsp0 = $("#dist_p1").val();
            var dsp1 = $("#dist_p2").val();
            var dsv0 = $("#dist_v1").val();
            var dsv1 = $("#dist_v2").val();
            var dsv2 = $("#dist_v3").val();
            var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," + $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val();
            var volqueta = $("#costo_volqueta").val();
            var chofer = $("#costo_chofer").val();
            var trans = $(this).data("transporte");
            var nodeId = $("#nodeId").val();

            var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1
                + "&dsv2=" + dsv2 + "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val()
                + "&id=" + nodeId + "&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof").val()
                + "&volq=" + $("#cmb_vol").val() + "&indi=" + $("#costo_indi").val() + "&trans=" + trans;
            location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosVaeGrupo')}?" + datos;

            $("#modal-transporte").modal("hide");
            return false;
        });
        $("#print_totales").click(function () {
            var dsp0 = $("#dist_p1").val();
            var dsp1 = $("#dist_p2").val();
            var dsv0 = $("#dist_v1").val();
            var dsv1 = $("#dist_v2").val();
            var dsv2 = $("#dist_v3").val();
            var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," + $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val();
            var volqueta = $("#costo_volqueta").val();
            var chofer = $("#costo_chofer").val();
            var trans = $(this).data("transporte");
            var nodeId = $("#nodeId").val();
            var principal = false;

            var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2 +
                "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val() + "&id=" + nodeId +
                "&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof").val() +
                "&volq=" + $("#cmb_vol").val() + "&indi=" + $("#costo_indi").val() + "&principal=" + principal +"&trans=" + trans;
            location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosConsolidadoGrupo')}?" + datos;

            $("#modal-transporte").modal("hide");
            return false;
        });

        %{--$("#imp_consolidado").click(function () {--}%
        %{--    var dsp0 = $("#dist_p1g").val();--}%
        %{--    var dsp1 = $("#dist_p2g").val();--}%
        %{--    var dsv0 = $("#dist_v1g").val();--}%
        %{--    var dsv1 = $("#dist_v2g").val();--}%
        %{--    var dsv2 = $("#dist_v3g").val();--}%
        %{--    var lista1 = $("#lista_1g").val();--}%
        %{--    var lista2 = $("#lista_2g").val();--}%
        %{--    var lista3 = $("#lista_3g").val();--}%
        %{--    var lista4 = $("#lista_4g").val();--}%
        %{--    var lista5 = $("#lista_5g").val();--}%
        %{--    var lista6 = $("#ciudad").val();--}%
        %{--    var volqueta = $("#costo_volqueta2").val();--}%
        %{--    var chofer = $("#costo_chofer2").val();--}%
        %{--    var trans = $(this).data("transporte");--}%
        %{--    var nodeId = $("#nodeId").val();--}%
        %{--    var principal = true;--}%

        %{--    var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2 +--}%
        %{--        "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios2").val() + "&id=" + nodeId +--}%
        %{--        "&lugar=" + $("#ciudad").val() + "&lista1=" + lista1 + "&lista2=" + lista2 + "&lista3=" + lista3 +--}%
        %{--        "&lista4=" + lista4 + "&lista5=" + lista5 + "&lista6=" + lista6 + "&principal=" + principal--}%
        %{--        + "&chof=" + $("#cmb_chof").val() +--}%
        %{--        "&volq=" + $("#cmb_vol").val() + "&indi=" + $("#costo_indi2").val() + "&trans=" + trans;--}%
        %{--    location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosConsolidadoGrupo2')}?" + datos;--}%

        %{--    $("#modal-transporte2").modal("hide");--}%
        %{--    return false;--}%
        %{--});--}%


        %{--$("#imp_consolidado_excel").click(function () {--}%

        %{--    var dsp0 = $("#dist_p1g").val();--}%
        %{--    var dsp1 = $("#dist_p2g").val();--}%
        %{--    var dsv0 = $("#dist_v1g").val();--}%
        %{--    var dsv1 = $("#dist_v2g").val();--}%
        %{--    var dsv2 = $("#dist_v3g").val();--}%
        %{--    var lista1 = $("#lista_1g").val();--}%
        %{--    var lista2 = $("#lista_2g").val();--}%
        %{--    var lista3 = $("#lista_3g").val();--}%
        %{--    var lista4 = $("#lista_4g").val();--}%
        %{--    var lista5 = $("#lista_5g").val();--}%
        %{--    var lista6 = $("#ciudad").val();--}%
        %{--    var volqueta = $("#costo_volqueta2").val();--}%
        %{--    var chofer = $("#costo_chofer2").val();--}%
        %{--    var trans = $(this).data("transporte");--}%
        %{--    var nodeId = $("#nodeId").val();--}%
        %{--    var principal = true;--}%

        %{--    var datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2 +--}%
        %{--        "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios2").val() + "&id=" + nodeId +--}%
        %{--        "&lugar=" + $("#ciudad").val() + "&lista1=" + lista1 + "&lista2=" + lista2 + "&lista3=" + lista3 +--}%
        %{--        "&lista4=" + lista4 + "&lista5=" + lista5 + "&lista6=" + lista6 + "&principal=" + principal--}%
        %{--        + "&chof=" + $("#cmb_chof").val() +--}%
        %{--        "&volq=" + $("#cmb_vol").val() + "&indi=" + $("#costo_indi2").val() + "&trans=" + trans;--}%
        %{--    location.href = "${g.createLink(controller: 'reportes2',action: 'consolidadoExcel')}?" + datos;--}%
        %{--    $("#modal-transporte2").modal("hide");--}%
        %{--    return false;--}%
        %{--});--}%

        var cache = {};
        $("#search").autocomplete({
            minLength : 3,
            source    : function (request, response) {
                var term = request.term;
                if (term in cache) {
                    response(cache[ term ]);
                    return;
                }

                $.ajax({
                    type     : "POST",
                    dataType : 'json',
                    url      : "${createLink(action: 'search_ajax')}",
                    data     : {
                        search : term,
                        tipo   : current
                    },
                    success  : function (data) {
                        $("#search").removeClass("ui-autocomplete-loading-error");
                        cache[ term ] = data;
                        response(data);
                    }, error : function () {
                        $("#search").removeClass("ui-autocomplete-loading").addClass("ui-autocomplete-loading-error");
                    }
                });

            }
        });



    });
</script>

</body>
</html>
