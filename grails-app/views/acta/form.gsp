<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="janus.actas.Acta" %>
<html>
<head>
    <meta name="layout" content="main">

        %{-- <asset:javascript src="/jquery/plugins/ckeditor/ckeditor.js"/> --}%
        <ckeditor:resources/>

    <title>Acta</title>

    <style>
    .tituloChevere {
        font-size : 20px !important;
    }

    .titulo {
        font-size : 20px;
    }

    .bold {
        font-weight : bold;
    }

    .span1 {
        width : 95px !important;
    }

    .editable {
        background : right no-repeat rgba(245, 245, 245, 0.5);
        border     : solid 1px #efefef;
        padding    : 3px 20px 0 3px;
        margin     : 10px 0;
        width      : auto;
        min-height : 25px;
    }

    .numero {
        width : 35px !important;
    }

    .seccion {
        background    : rgba(50, 100, 150, 0.3);
        padding       : 5px;
        margin-bottom : 10px;
        position      : relative;
    }

    .botones {
        width    : 31px;
        position : absolute;
        /*float: right;*/
        /*right    : -15px;*/
        margin-left: 1px;
        top      : 1px;
    }

    .seccion .span9 {
        margin : 0 !important;
    }

    .lvl2 {
        margin-left : 20px !important;
    }

    .lblSeccion {
        width : 800px;
    }

    .contParrafo {
        width : 800px;
        margin-left : 10px !important;
    }

    .tablas {
        width      : 900px;
        margin-left : 85px !important;
    }

    .tablas .table {
        margin-bottom : 0 !important;
    }

    th {
        vertical-align : middle !important;
    }

    .tal {
        text-align : left !important;
    }

    .warning {
        font-size : 15px;
    }

    .strongWarning {
        font-size   : 18px;
        font-weight : bold;
    }
    </style>
</head>

<body>

<g:if test="${flash.message}">
    <div class="row">
        <div class="span12">
            <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
                <a class="close" data-dismiss="alert" href="#">×</a>
                ${flash.message}
            </div>
        </div>
    </div>
</g:if>

<div class="row" style="margin-bottom: 15px;">
    <div class="span9" role="navigation">
        <div class="btn-group">
            <g:if test="${actaInstance.contrato}">
                <g:link controller="contrato" action="verContrato" id="${actaInstance.contratoId}" class="btn  btn-primary" title="Regresar al contrato">
                    <i class="fa fa-arrow-left"></i>
                    Contrato
                </g:link>
                <g:link controller="planilla" action="list" class="btn btn-info" id="${actaInstance.contratoId}">
                    <i class="fa fa-arrow-left"></i>
                    Planillas
                </g:link>
            </g:if>
        </div>

        <div class="btn-group">
            <g:if test="${!actaInstance?.id || editable}">
                <a href="#" id="btnSave" class="btn btn-success"><i class="fa fa-save"></i> Guardar</a>
                <a href="#" id="btnCorregir" class="btn btn-warning"><i class="fa fa-language"></i> Corregir texto</a>
            </g:if>
        </div>

        <div class="btn-group">
            <g:if test="${actaInstance?.id}">
                <a href="#" class="btn btn-info" id="btnPrint"><i class="fa fa-print"></i> Imprimir</a>
                <a href="#" class="btn btn-primary" id="btnPrintCmpl"><i class="fa fa-print"></i> Impr. Complementario</a>
            </g:if>
        </div>

        <div class="btn-group">
            <g:if test="${actaInstance?.id}">
                <g:if test="${editable}">
                    <a href="#" class="btn btn-warning" id="btnRegistro"><i class="fa fa-lock"></i> Registrar</a>
                </g:if>
            </g:if>
        </div>
    </div>
</div>

<g:form class="form-horizontal" name="frmSave-Acta" action="save">
    <g:if test="${editable}">
        <g:hiddenField name="id" value="${actaInstance?.id}"/>
        <g:hiddenField id="contrato" name="contrato.id" value="${actaInstance?.contrato?.id}"/>
        <g:hiddenField id="txtDescripcion" name="descripcion" value="${actaInstance?.descripcion}"/>
    </g:if>

    <div class="titulo bold col-md-12">

        <div class="col-md-2">
            Acta de
            <g:if test="${editable}">
                <g:textField name="nombre" maxlength="20" class="form-control required" value="${actaInstance?.nombre ?: actaProv ? actaProv.nombre : 'recepción'}"/>
            </g:if>
            <g:else>
                ${actaInstance?.nombre}
            </g:else>
        </div>
        <div class="col-md-2">
            &nbsp;
            <g:if test="${editable}">
                <g:select name="tipo" from="${tipos}" class="form-control required" value="${actaInstance?.tipo}" valueMessagePrefix="acta.tipo"/>
            </g:if>
            <g:else>
                <g:message code="acta.tipo.${actaInstance.tipo}"/>
            </g:else>
        </div>
        <div class="col-md-2">
            Número
            <g:if test="${editable}">
                <g:textField name="numero" maxlength="20" class="form-control required allCaps" value="${actaInstance?.numero}"/>
            </g:if>
            <g:else>
                ${actaInstance.numero}
            </g:else>
        </div>
        <div class="col-md-5">
            Efectuada el
            <g:if test="${editable}">
                <input aria-label="" name="fecha" id='fecha' type='text' class="form-control required" style="width: 150px" value="${actaInstance?.fecha?.format("dd-MM-yyyy")}" />
            </g:if>
            <g:else>
                <g:formatDate date="${actaInstance.fecha}" format="dd-MM-yyyy"/>
                y registrada el:
                <g:if test="${actaInstance.fechaRegistro}">
                    <g:formatDate date="${actaInstance.fechaRegistro}" format="dd-MM-yyyy"/>
                </g:if>
                <g:else>
                    (No registrada)
                </g:else>
            </g:else>
        </div>

    </div>
    <div class="col-md-12">
        <div class="col-md-9"></div>
        <div class="col-md-2 text-info bold">
            Insertar espacios Extra:
        </div>
        <div class="col-md-1">
            <g:textField name="espacios" maxlength="1" class="form-control" value="${actaInstance?.espacios}"/>
        </div>
    </div>

    <g:if test="${!actaInstance.id && actaInstance.tipo == 'D'}">
        <div class="alert alert-info" style="margin-top: 15px;">
            Está creando el acta definitiva. Una vez ingresados el número y la fecha y guardada el acta se copiarán las secciones y los párrafos del acta provisional.
        </div>
    </g:if>

    <div class="tituloChevere">
        Datos Generales: ${actaInstance?.tipo == 'D' ? 'Acta de Recepción Definitiva' : 'Acta de Recepción Provisional'}
    </div>

    <g:set var="garantias" value="${janus.pac.Garantia.findAllByContrato(actaInstance.contrato)}"/>
    <g:set var="obra" value="${actaInstance.contrato.oferta.concurso.obra}"/>
    <g:set var="fisc" value="${janus.ejecucion.Planilla.findAllByContrato(actaInstance.contrato, [sort: "id", order: "desc"]).first().fiscalizador}"/>
    <div class="well" style="height: 230px;">
        <div class='col-md-12'>
            <div class="bold col-md-1">Contrato N.</div>
            <div class="col-md-10">${actaInstance.contrato.codigo}</div>
        </div>

        <div class='col-md-12'>
            <div class="bold col-md-1">Garantías.</div>

            <div class="col-md-10" style="height: 50px; overflow-y: auto; margin-top: 0px">
                <g:each in="${garantias}" var="gar" status="i">
                    ${gar.tipoDocumentoGarantia.descripcion} N. ${gar.codigo} - ${gar.aseguradora.nombre} ${i < garantias.size() - 1 ? "," : ""}
                </g:each>
            </div>
        </div>

        <div class='col-md-12' style="margin-top: 5px">
            <div class="bold col-md-1">Objeto</div>
            <div class="col-md-10">${actaInstance.contrato.objeto}</div>
        </div>

        <div class='col-md-12'>
            <div class="bold col-md-1">Lugar</div>
            <div class="col-md-10">${obra.sitio}</div>
        </div>

        <div class='col-md-12'>
            <div class="bold col-md-1">Ubicación</div>
            <div class="col-md-10">Parroquia ${obra.parroquia.nombre} - Cantón ${obra.parroquia.canton.nombre}</div>
        </div>

        <div class='col-md-12'>
            <div class="bold col-md-1">Monto $.</div>
            <div class="col-md-10">${actaInstance.contrato.monto}</div>
        </div>

        <div class='col-md-12'>
            <div class="bold col-md-1">Contratista</div>
            <div class="col-md-10">${actaInstance.contrato.oferta.proveedor.nombre}</div>
        </div>

        <div class='col-md-12'>
            <div class="bold col-md-1">Fiscalizador</div>
            <div class="col-md-10">${fisc.titulo} ${fisc.nombre} ${fisc.apellido}</div>
        </div>

    </div> %{-- well contrato --}%

    <div class="well ui-corner-all " style="height: 50px;" >
            <elm:poneHtml textoHtml="${actaInstance.descripcion}"/>
    </div>

    <div class="col-md-12" style="margin-bottom: 10px">
    <g:if test="${editable}">
        <g:if test="${actaInstance.id}">
            <a href="#" class="btn btn-primary btn-xs" style="margin-top: 0px; float: left;" id="btnAddSeccion"><i class="fa fa-plus"></i> Agregar sección</a>
        </g:if>
        <a href="#" class="btn btn-xs btn-success " id="btnEditarDescripcion" style="margin-top: 0px; float: right"><i class="fa fa-edit"></i> Editar Descripción</a>
    </g:if>

    </div>

    <div class="col-md-12" id="secciones"></div>

</g:form>

<div class="modal hide fade" id="modal">
    <div class="modal-header" id="modalHeader">
        <button type="button" class="close darker" data-dismiss="modal">
            <i class="icon-remove-circle"></i>
        </button>

        <h3 id="modalTitle"></h3>
    </div>

    <div class="modal-body" id="modalBody">
    </div>

    <div class="modal-footer" id="modalFooter">
    </div>
</div>

<script type="text/javascript">
    var secciones = 1;
    var $btnSaveActa = $("#btnSave");

    $('#fecha').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        minDate: new Date(${contrato.fechaPedidoRecepcionFiscalizador.format('yyyy')},${contrato.fechaPedidoRecepcionFiscalizador.format('MM').toInteger() - 1},
            ${contrato.fechaPedidoRecepcionFiscalizador.format('dd')},0,0,0,0),
        sideBySide: true,
        icons: {
        }
    });


    $("#btnEditarDescripcion").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(controller: 'acta', action:'formDescripcion_ajax')}",
            data    : {
                id : '${actaInstance?.id}'
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEditD",
                    title   : "Editar",
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
                                return  submitFormEditarDescripcion();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
        return false;
    });

    function submitFormEditarDescripcion() {
        var $form = $("#frmEditarDesc");
        var descripcion = CKEDITOR.instances["descripcion"].getData();
        var id = $("#id").val();
        if ($form.valid()) {
            var url = $form.attr("action");
            $.ajax({
                type    : "POST",
                url     : url,
                // data    : $form.serialize(),
                data    : {
                        descripcion: descripcion,
                        id: id
                },
                success : function (msg) {
                    if (msg === 'ok') {
                        log("Guardado correctamente", "success");
                        setTimeout(function () {
                            location.reload();
                        }, 800);
                    } else {
                        log("Error al editar la información", "error");
                    }
                }
            });
        }
        else {
            return false;
        }
    }

    $("#btnCorregir").click(function () {
        var d = cargarLoader("Procesando...");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'acta', action: 'corregirTexto_ajax')}",
            data    : {
                acta: '${actaInstance?.id}'
            },
            success : function (msg) {
                d.modal("hide");
            }
        });
    });

    function submitFormSeccion() {
        var $form = $("#frmSave");
        if ($form.valid()) {
            var url = $form.attr("action");
            $.ajax({
                type    : "POST",
                url     : url,
                data    : $form.serialize(),
                success : function (msg) {
                    if (msg.startsWith("NO")) {
                        var p = msg.split("_");
                        log(p[1], "error");
                    } else {
                        var $sec = addSeccion($.parseJSON(msg), true);
                        if ($sec) {
                            $('html, body').animate({
                                scrollTop : $sec.offset().top
                            }, 2000);
                        }
                        log("Sección creada correctamente", "success");
                    }
                }
            });
        }
        else {
            return false;
        }
    }

    function submitFormParrafo(num, $div, add, $replace) {
        var $form = $("#frmSave");
        if ($form.valid()) {
            var url = $form.attr("action");
            $.ajax({
                type    : "POST",
                url     : url,
                data    : $form.serialize(),
                  success : function (msg) {
                    if (msg.startsWith("NO")) {
                        var p = msg.split("_");
                        log(p[1], "error");
                    } else {
                        var $sec;
                        if (add) {
                            $sec = addParrafo($.parseJSON(msg), num, $div);
                            if ($sec) {
                                $('html, body').animate({
                                    scrollTop : $div.parents(".seccion").offset().top
                                }, 2000);
                            }
                            log("Párrafo agregado correctamente", "success");
                            setTimeout(function () {
                                location.reload()
                            }, 800);
                        } else {
                            $sec = addParrafo($.parseJSON(msg), num, $div, $replace);
                            setTimeout(function () {
                                location.reload()
                            }, 800);
                        }
                        editable($sec.find(".editable"));
                    }
                }
            });
        }else{
            return false
        }
    }

    function getSecciones() {
        var str = "";
        $(".seccion").each(function () {
            var $sec = $(this);
            var num = $sec.data("numero");
            var titulo = $sec.data("titulo");
            if (str !== "") {
                str += "&";
            }
            str += "seccion=" + num + "**" + titulo;
            var parrafos = getParrafos($sec);
            str += parrafos !== "" ? "&" + parrafos : "";
        });
        return str;
    }

    function getParrafos($seccion) {
        var str = "";
        $seccion.find(".parrafo").each(function () {
            var $p = $(this);
            var num = $p.data("numero");
            var cont = $p.data("contenido");
            if (str !== "") {
                str += "&";
            }
            str += "parrafos" + $seccion.data("numero") + "=" + num + "**" + cont;
        });
        return str;
    }

    function numerosSecciones() {

        var cont = 1;

        $(".seccion").each(function () {
            var $sec = $(this);
            var $titulo = $sec.find(".tituloSeccion");
            var $num = $titulo.find(".numero");
            var num = $.trim($num.text());
            num = $.trim(str_replace(".-", "", num));

            if (parseInt(num) !== cont) {
                num = cont;
                $num.text(num + ".-");
            }

            // var titulo = CKEDITOR.instances["seccion_" + $sec.data("id")].getData();
            var titulo = $sec.val();

            $sec.data({
                numero : num,
                titulo : titulo
            });
            numerosParrafos($sec);
            cont++;
        });
    }

    function numerosSeccionesBajar() {

        var cont = 1;

        $(".seccion").each(function () {
            var $sec = $(this);
            var $titulo = $sec.find(".tituloSeccion");
            var $num = $titulo.find(".numero");
            var num = $.trim($num.text());
            num = $.trim(str_replace(".-", "", num));

            if (parseInt(num) !== cont) {
                num = cont;
                $num.text(num + ".-");
            }

            // var titulo = CKEDITOR.instances["seccion_" + $sec.data("id")].getData();
            var titulo = $sec.val()

            $sec.data({
                numero : num,
                titulo : titulo
            });
            numerosParrafos($sec);
            cont++;
        });
    }

    function tipoTabla(tipo, $div) {
        var $tabla = $("<table class='table table-bordered table-condensed'></table>");
        var $thead = $("<thead></thead>").appendTo($tabla);
        var $tr = $("<tr></tr>").appendTo($thead);
        var $cont = $("<div class='col-md-9 tablas lvl2 ui-corner-all'></div>");

        switch (tipo) {
            case "RBR": //Rubros (4.1),
                $("<th>N.</th>").appendTo($tr);
                $("<th>Descripción del rubro</th>").appendTo($tr);
                $("<th>U.</th>").appendTo($tr);
                $("<th>Precio unitario</th>").appendTo($tr);
                $("<th>Volumen contratado</th>").appendTo($tr);
                $("<th>Cantidad total ejecutada</th>").appendTo($tr);
                $("<th>Valor total ejecutado</th>").appendTo($tr);
                break;
            case  "DTP": //Detalle planillas (4.2),
                $("<th rowspan='2'>Fecha</th>").appendTo($tr);
                $("<th rowspan='2'>N. planilla</th>").appendTo($tr);
                $("<th rowspan='2'>Periodo</th>").appendTo($tr);
                $("<th rowspan='2'>Valor</th>").appendTo($tr);
                $("<th colspan='2'>Descuentos</th>").appendTo($tr);
                var $tr2 = $("<tr></tr>").appendTo($thead);
                $("<th>Anticipo</th>").appendTo($tr2);
                $("<th>Multas</th>").appendTo($tr2);
                break;
            case "OAD": // Obras adicionales (4.3)
                $("<th>Valor de obras adicionales contractuales</th>").appendTo($tr);
                $("<th>%</th>").appendTo($tr);
                $("<th>Valor de obras adicionales costo + porcentaje</th>").appendTo($tr);
                $("<th>%</th>").appendTo($tr);
                $("<th>Memorando de autorización</th>").appendTo($tr);
                $("<th>Memorando a Dir. Financiera</th>").appendTo($tr);
                $("<th>Memorando a partida presupuestaria</th>").appendTo($tr);
                $("<th>% total</th>").appendTo($tr);
                break;
            case "OCP": //costo y porcentaje (4.4),
                $("<th>Fecha</th>").appendTo($tr);
                $("<th>N. planilla</th>").appendTo($tr);
                $("<th>Periodo</th>").appendTo($tr);
                $("<th>Valor neto</th>").appendTo($tr);
                $("<th>%</th>").appendTo($tr);
                $("<th>Valor total</th>").appendTo($tr);
                break;
            case "RRP": //resumen reajuste precios (4.5),
                $("<th>Fecha</th>").appendTo($tr);
                $("<th>N. planilla</th>").appendTo($tr);
                $("<th>Periodo</th>").appendTo($tr);
                $("<th>Valor</th>").appendTo($tr);
                break;
            case "RGV": //resumen general valores (4.6),
                $("<th class='tal'>Total valor de liquidación de obra</th>").appendTo($tr);
                var $tr2 = $("<tr></tr>").appendTo($thead);
                $("<th class='tal'>Total valor de reajuste de precios</th>").appendTo($tr2);
                var $tr3 = $("<tr></tr>").appendTo($thead);
                $("<th class='tal'>Total valor de la inversión</th>").appendTo($tr3);
                break;
            case "DTA": //detalle ampliaciones (5.5)
                $("<th>N.</th>").appendTo($tr);
                $("<th>N. de días</th>").appendTo($tr);
                $("<th>Trámite</th>").appendTo($tr);
                $("<th>Fecha</th>").appendTo($tr);
                $("<th>Motivo</th>").appendTo($tr);
                $("<th>Observaciones</th>").appendTo($tr);
                break;
            case "DTS": //detalle suspensiones (5.6),
                $("<th>N.</th>").appendTo($tr);
                $("<th>N. de días</th>").appendTo($tr);
                $("<th>Periodo</th>").appendTo($tr);
                $("<th>Trámite</th>").appendTo($tr);
                $("<th>Fecha</th>").appendTo($tr);
                $("<th>Motivo</th>").appendTo($tr);
                break;
            case  "RPR": //resumen reajuste (8.1)
                $("<th>N.</th>").appendTo($tr);
                $("<th>Periodo</th>").appendTo($tr);
                $("<th>Valor provisional</th>").appendTo($tr);
                $("<th>Valor definitivo</th>").appendTo($tr);
                $("<th>Diferencia</th>").appendTo($tr);
                break;
        }

        $cont.html($tabla);
        $cont.appendTo($div);
    }

    function numerosParrafos($seccion) {

        var cont = 1;

        var numSec = $seccion.data("numero");
        $seccion.find(".parrafo").each(function () {
            var $par = $(this);

            var $titulo = $par.find(".tituloParrafo");
            var $num = $titulo.find(".numero");
            var num = $.trim($num.text());
            num = $.trim(str_replace(".-", "", num));
            var parts = num.split(".");
            num = parts[1];

            if (parseInt(num) !== cont || parseInt(parts[0]) !== numSec) {
                num = cont;
                $num.text(numSec + "." + num + ".-");
            }

            // var contenido = CKEDITOR.instances["parrafo_" + $par.data("id")].getData();
            var contenido = $par.val();

            $par.data({
                numero    : num,
                contenido : contenido
            });
            cont++;
        });
    }

    function addParrafo(data, num, $div, $replace, isEditable) {
        if (data.contenido === "null" || data.contenido == null) {
            data.contenido = "";
        }

        var clase = "editable", contentEditable = "contenteditable='true'";
        // if (!isEditable) {
        //     clase = "";
        //     contentEditable = "";
        // }

        var $parr = $("<div class='col-md-12 parrafo'></div>");
        var $titulo = $("<div class='col-md-12 tituloParrafo '></div>");
        $("<div class='col-md-1 numero lvl2 bold'>" + num + "." + data.numero + ".-</div>").appendTo($titulo);
        // var $edit = $("<div class='col-md-9 contParrafo " + clase + " ui-corner-all' id='parrafo_" + data.id + "' " + contentEditable + ">" + data.contenido + "</div>").appendTo($titulo);
        var $edit = $("<div class='col-md-9 contParrafo " + clase + " ui-corner-all' id='parrafo_" + data.id + "' " + ">" + data.contenido + "</div>").appendTo($titulo);
        if (data.tipoTabla) {
            tipoTabla(data.tipoTabla, $titulo);
        }
        var $btnTabla = $('<a href="#" class="btn btn-xs btn-info" style="margin-left: 10px; margin-top: 10px">Modificar</a>');
        var $btnEliminarParrafo = $('<a href="#" class="btn btn-delete btn-xs btn-danger" style="margin-left: 10px; margin-top: 10px"> Eliminar </a>');
        var $btnEditarParrafo = $('<a href="#" class="btn btn-xs btn-success" style="margin-left: 10px; margin-top: 10px"><i class="fa fa-edit"></i> Editar</a>');

        $btnTabla.click(function () {
            $.ajax({
                type    : "POST",
                url: "${createLink(controller: 'parrafo', action:'form_ext_ajax')}",
                data    : {
                    id : data.id
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEditP",
                        title   : " Párrafo",
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
                                    return  submitFormParrafo(data.numero, $parr, false, $parr);
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
            return false;
        });

        $btnEliminarParrafo.click(function () {
            var $del = $(this).parents(".parrafo");

            bootbox.dialog({
                title   : "Alerta",
                message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar este párrafo? Esta acción no se puede deshacer.</p>",
                buttons : {
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-primary",
                        callback  : function () {
                        }
                    },
                    eliminar : {
                        label     : "<i class='fa fa-trash'></i> Eliminar",
                        className : "btn-danger",
                        callback  : function () {
                            var v = cargarLoader("Eliminando...");
                            $.ajax({
                                type    : "POST",
                                url     : '${createLink(controller: 'parrafo', action: 'delete_ext')}',
                                data    : {
                                    id : data.id
                                },
                                success : function (msg) {
                                    v.modal("hide");
                                    var parts = msg.split("_");
                                    if(parts[0] === 'OK'){
                                        log(parts[1],"success");
                                        numerosParrafos($div.parents(".seccion"));
                                        setTimeout(function () {
                                            location.reload()
                                        }, 1000);
                                    }else{
                                        log(parts[1],"error")
                                    }
                                }
                            });
                        }
                    }
                }
            });
            return false;
        });

        $btnEditarParrafo.click(function () {
            $.ajax({
                type    : "POST",
                url: "${createLink(controller: 'acta', action:'formParrafo_ajax')}",
                data    : {
                    id : data.id
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEditP",
                        title   : "Editar",
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
                                    return  submitFormEditarParrafo();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
            return false;
        });

        function submitFormEditarParrafo() {
            var $form = $("#frmEditarSave");
            var contenido = CKEDITOR.instances["contenido"].getData();
            var id = $("#idParrafo").val();
            if ($form.valid()) {
                var url = $form.attr("action");
                $.ajax({
                    type    : "POST",
                    url     : url,
                    // data    : $form.serialize(),
                    data:{
                        contenido: contenido,
                        id: id
                    },
                    success : function (msg) {
                        if (msg === 'ok') {
                            log("Guardado correctamente", "success");
                            setTimeout(function () {
                                location.reload();
                            }, 800);
                        } else {
                            log("Error al editar la información", "error");
                        }
                    }
                });
            }
            else {
                return false;
            }
        }

        if (isEditable) {
            $titulo.append($btnEditarParrafo).append($btnEliminarParrafo).append($btnTabla);
        }
        $titulo.appendTo($parr);
        if ($replace) {
            $replace.replaceWith($parr);
        } else {
            $parr.appendTo($div);
        }

        $parr.data({
            id        : data.id,
            numero    : data.numero,
            contenido : data.contenido,
            tipoTabla : data.tipoTabla
        });
        return $parr;
    }


    function addSeccion(data, isEditable) {
        var $seccion = $("<div class='seccion ui-corner-all'></div>");
        var $titulo = $("<div class='col-md-12 tituloSeccion'></div>");
        $("<div class='col-md-1 numero lvl1 bold'>" + data.numero + ".-</div>").appendTo($titulo);

        var clase = "editable", contentEditable = "contenteditable='true'";
        // if (!isEditable) {
        //     clase = "";
        //     contentEditable = "";
        // }

        // var $edit = $("<div class='col-md-7 lblSeccion " + clase + " ui-corner-all' id='seccion_" + data.id + "' " + contentEditable + ">" + data.titulo + "</div>").appendTo($titulo);
        var $edit = $("<div class='col-md-7 lblSeccion " + clase + " ui-corner-all' id='seccion_" + data.id + "' " + ">" + data.titulo + "</div>").appendTo($titulo);
        var $btnAddParrafo = $('<a href="#" class="btn btn-show btn-warning btn-xs pull-right" style="margin-left: 10px;"><i class="fa fa-plus"></i> Agregar párrafo</a>');
        var $btnEliminarSeccion = $('<a href="#" class="btn btn-danger btn-xs pull-right" style="margin-left: 10px;"><i class="fa fa-minus"></i> Eliminar sección</a>');
        var $btnEditarSeccion = $('<a href="#" class="btn btn-xs btn-success " style="margin-left: 10px; margin-top: 10px"><i class="fa fa-edit"></i> Editar</a>');

        var $btnSubir = $('<a href="#" class="btn btn-bajar btn-xs btn-info"><i class="fa fa-arrow-up"></i></a>');

        var $botones = $("<div class='botones'></div>");
        $botones.append($btnSubir);



        $btnSubir.click(function () {
            var $prev = $seccion.prev();

            if ($prev) {
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller:'seccion', action: 'updateNumeros')}",
                    data    : {
                        acta   : "${actaInstance.id}",
                        id     : data.id,
                        numero : $seccion.data("numero") - 1
                    },
                    success : function (msg) {
                        var p = msg.split("_");
                        if (p[0] === "OK") {
                            $prev.before($seccion);
                            numerosSecciones();
                        } else {
                            log(p[1], "error");
                        }
                    }
                });
            }
            return false;
        });

        if (!data.parrafos) {
            data.parrafos = [];
        }

        var parrafos = data.parrafos.length;

        var $parr = $("<div class='row parrafos'></div>");

        $btnAddParrafo.click(function () {

            $.ajax({
                type    : "POST",
                url: "${createLink(controller: 'parrafo', action:'form_ext_ajax')}",
                data    : {
                    seccion : data.id,
                    numero  : parrafos + 1
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEditP",
                        title   : " Párrafo",
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
                                    return submitFormParrafo(data.numero, $parr, true);
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
        });


        $btnEliminarSeccion.click(function () {
            var $del = $(this).parents(".seccion");

            bootbox.dialog({
                title   : "Alerta",
                message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar esta sección? Esta acción no se puede deshacer.</p>",
                buttons : {
                    cancelar : {
                        label     : "Cancelar",
                        className : "btn-primary",
                        callback  : function () {
                        }
                    },
                    eliminar : {
                        label     : "<i class='fa fa-trash'></i> Eliminar",
                        className : "btn-danger",
                        callback  : function () {
                            var v = cargarLoader("Eliminando...");
                            $.ajax({
                                type    : "POST",
                                url     : '${createLink(controller: 'seccion', action: 'delete_ext')}',
                                data    : {
                                    id : data.id
                                },
                                success : function (msg) {
                                    v.modal("hide");
                                    var parts = msg.split("_");
                                    if(parts[0] === 'OK'){
                                        log(parts[1],"success");
                                        numerosSecciones();
                                        setTimeout(function () {
                                            location.reload()
                                        }, 1000);
                                    }else{
                                        log(parts[1],"error")
                                    }
                                }
                            });
                        }
                    }
                }
            });

            return false;
        });

        $btnEditarSeccion.click(function () {
            $.ajax({
                type    : "POST",
                url: "${createLink(controller: 'acta', action:'formSeccion_ajax')}",
                data    : {
                    id : data.id
                },
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEditS",
                        title   : "Editar",
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
                                    return  submitFormEditarSeccion();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
            return false;
        });

        function submitFormEditarSeccion() {
            var $form = $("#frmEditarSeccionSave");
            var titulo = CKEDITOR.instances["titulo"].getData();
            var id = $("#idSeccion").val();
            if ($form.valid()) {
                var url = $form.attr("action");
                $.ajax({
                    type    : "POST",
                    url     : url,
                    // data    : $form.serialize(),
                    data:{
                        titulo: titulo,
                        id: id
                    },
                    success : function (msg) {
                        if (msg === 'ok') {
                            log("Guardado correctamente", "success");
                            setTimeout(function () {
                                location.reload();
                            }, 800);
                        } else {
                            log("Error al editar la información", "error");
                        }
                    }
                });
            }
            else {
                return false;
            }
        }

        if (isEditable) {
            $seccion.append($btnAddParrafo).append($btnEliminarSeccion);
            $titulo.append($btnEditarSeccion);
        }

        $titulo.appendTo($seccion);

        $seccion.data({
            id     : data.id,
            numero : data.numero,
            titulo : data.titulo
        });
        var parrafosAdded = [];
        if (parrafos > 0) {
            for (var i = 0; i < data.parrafos.length; i++) {
                var $par = addParrafo(data.parrafos[i], data.numero, $parr, false, isEditable);
                parrafosAdded.push($par)
            }
        }

        $parr.appendTo($seccion);

        $("#secciones").append($seccion);
        if (isEditable) {
            $seccion.append($botones);
        }

        secciones++;
        if (isEditable) {
            editable($edit);
            for (var j = 0; j < parrafosAdded.length; j++) {
                editable(parrafosAdded[j].find(".editable"));
            }
        }
        return $seccion;
    }

    function initSecciones() {
        var secciones = <elm:poneHtml textoHtml="${secciones}"/>
        for (var i = 0; i < secciones.length; i++) {
            addSeccion(secciones[i], ${editable});
        }
    }

    function doSave() {
        if ($("#frmSave-Acta").valid()) {
            var v = cargarLoader("Guardando...");
            // $("#txtDescripcion").val(CKEDITOR.instances.descripcion.getData());
            $("#frmSave-Acta").serialize();
            $("#frmSave-Acta").submit();
            numerosSecciones();
            setTimeout(function () {
                location.reload();
            }, 800);
        }
    }

    function editable($elm) {
        %{--var id = $elm.attr("id");--}%
        %{--var p = id.split("_");--}%
        %{--CKEDITOR.config.toolbar_descripcion = [--}%
        %{--    ['Undo', 'Redo'],--}%
        %{--    ['Bold', 'Italic', 'Underline'],--}%
        %{--    ['Subscript', 'Superscript'],--}%
        %{--    ['NumberedList', 'BulletedList'],--}%
        %{--    ['Outdent', 'Indent']--}%
        %{--];--}%
        %{--CKEDITOR.config.toolbar_seccion = [--}%
        %{--    ['Undo', 'Redo'],--}%
        %{--    ['Bold', 'Italic', 'Underline'],--}%
        %{--    ['Subscript', 'Superscript']--}%
        %{--];--}%
        %{--CKEDITOR.config.toolbar_parrafo = [--}%
        %{--    ['Undo', 'Redo'],--}%
        %{--    ['Bold', 'Italic', 'Underline'],--}%
        %{--    ['Subscript', 'Superscript'],--}%
        %{--    ['NumberedList', 'BulletedList'],--}%
        %{--    ['Outdent', 'Indent']--}%
        %{--];--}%

        %{--try {--}%
        %{--    CKEDITOR.inline(id, {--}%
        %{--        toolbar : p[0],--}%
        %{--        on      : {--}%
        %{--            blur : function (event) {--}%
        %{--                var data = event.editor.getData();--}%
        %{--                var url, datos;--}%
        %{--                switch (p[0]) {--}%
        %{--                    case "descripcion":--}%
        %{--                        url = "${createLink(controller: 'acta', action: 'updateDescripcion')}";--}%
        %{--                        datos = {--}%
        %{--                            id          : "${actaInstance.id}",--}%
        %{--                            descripcion : data--}%
        %{--                        };--}%
        %{--                        break;--}%
        %{--                    case "seccion":--}%
        %{--                        url = "${createLink(controller: 'seccion', action: 'save_ext')}";--}%
        %{--                        datos = {--}%
        %{--                            id     : $elm.parents(".seccion").data("id"),--}%
        %{--                            titulo : data--}%
        %{--                        };--}%
        %{--                        break;--}%
        %{--                    case "parrafo":--}%
        %{--                        url = "${createLink(controller: 'parrafo', action: 'save_ext')}";--}%
        %{--                        datos = {--}%
        %{--                            id        : $elm.parents(".parrafo").data("id"),--}%
        %{--                            contenido : data--}%
        %{--                        };--}%
        %{--                        break;--}%
        %{--                }--}%
        %{--                <g:if test="${actaInstance.id}">--}%
        %{--                $.ajax({--}%
        %{--                    type    : "POST",--}%
        %{--                    url     : url,--}%
        %{--                    data    : datos,--}%
        %{--                    success : function (msg) {--}%
        %{--                        var p = msg.split("_");--}%
        %{--                        if (p[0] === "NO") {--}%
        %{--                            log(p[1], p[0] === "NO");--}%
        %{--                        }--}%
        %{--                    }--}%
        %{--                });--}%
        %{--                </g:if>--}%
        %{--            }--}%
        %{--        }--}%
        %{--    });--}%
        %{--} catch (e) {--}%
        %{--}--}%
    }


    $(function () {

        // CKEDITOR.disableAutoInline = true;


        initSecciones();

        $(".editable").each(function () {
            editable($(this));
        });

        $("#btnPrint").click(function () {
            location.href ="${createLink(controller:'reportesPlanillas', action: '_actaRecepcion', id:actaInstance.id)}";
        });

        $("#btnPrintCmpl").click(function () {
            location.href = "${createLink(controller:'reportesPlanillas', action: '_actaRecepcionTotl', id:actaInstance.id)}";
        });

        $("#btnRegistro").click(function () {
            bootbox.confirm({
                title: "Registrar",
                message: "Verifique que el acta ha ser registrada sea la que fue firmada, una vez registrada el acta NO puede ser modificada y el registro es definitivo y NO se puede deshacer. ",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-check"></i> Registrar',
                        className: 'btn-success'
                    }
                },
                callback: function (result) {
                    if(result){
                        $.ajax({
                            type : "POST",
                            url : location.href = "${createLink(action:'registrar')}",
                            data     : {
                                id: '${actaInstance?.id}'
                            },
                            success  : function (msg) {
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1],"success");
                                    setTimeout(function () {
                                        location.href = "${createLink(controller:'planilla', action: 'list', id: actaInstance.contrato.id)}"
                                    }, 800);
                                }else{
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                }
                            }
                        });
                    }
                }
            });
        });

        $("#btnAddSeccion").click(function () {
            var id = "${actaInstance.id}";
            if (id === "") {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Guarde el acta antes de insertar secciones y párrafos" + '</strong>');
            } else {
                createEditSeccion(null, id, secciones);
            }
            return false;
        });

        function createEditSeccion(id, acta, numero) {
            var title = id ? "Editar " : "Crear ";
            var data = id ? {id : id, numero: numero} : {acta: acta, numero: numero};
            $.ajax({
                type    : "POST",
                url: "${createLink(controller: 'seccion', action:'form_ext_ajax')}",
                data    : data,
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEdit",
                        title   : title + " Sección",
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
                                    return submitFormSeccion();
                                } //callback
                            } //guardar
                        } //buttons
                    }); //dialog
                } //success
            }); //ajax
        } //createEdit




        $("#btnSave").click(function () {
            doSave();
            return false;
        });

        $("#frmSave-Acta").validate({
            errorClass    : "label label-important",
            submitHandler : function (form) {
                $(".btn-success").replaceWith(spinner);
                form.submit();
            }
        });

    });
</script>
</body>
</html>