<%@ page import="janus.Contrato; janus.ejecucion.TipoPlanilla; janus.ejecucion.Planilla" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Planillas
    </title>

    <style type="text/css">
    .cmplcss {
        color: #0067df;
        font-weight: bold;
    }
    </style>
</head>

<body>


<g:set var="cont" value="${1}"/>
<g:set var="prej" value="${janus.pac.PeriodoEjecucion.findAllByObra(obra, [sort: 'fechaFin', order: 'desc'])}"/>
<g:set var="anticipo" value="${Planilla.countByContratoAndTipoPlanilla(contrato, TipoPlanilla.findByCodigo('A'))}"/>

<div class="alert alert-info">
    Planillas del contrato: <strong>${contrato?.codigo + " - " + obra?.descripcion}</strong>
</div>

<div class="row">
    <div class="span9" role="navigation">
        <div class="btn-group">
            <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-primary" title="Regresar al contrato">
                <i class="fa fa-arrow-left"></i>
                Contrato
            </g:link>
            <g:if test="${anticipo >= 0}">
                <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">

                    <a href="#" class="btn btn-success" id="btnNuevaPlanilla">
                        <i class="fa fa-file"></i>
                        Nueva planilla
                    </a>
                    <g:link controller="documentoProceso" action="list" params="[id: contrato?.oferta?.concurso?.id, contrato: contrato?.id]"
                            class="btn btn-info" title="Cargar Docuemnto de repaldo para Obras adicionales">
                        <i class="fa fa-folder"></i>
                        Doc. respaldo Obras Adicionales
                    </g:link>
                    <g:link controller="documentoProceso" action="list" params="[id: contrato?.oferta?.concurso?.id, contrato: contrato?.id]"
                            class="btn btn-info" title="Cargar Docuemnto de repaldo para Obras adicionales">
                        <i class="fa fa-folder"></i>
                        Doc. respaldo Costo + %
                    </g:link>
                </g:if>
            </g:if>

        </div>
    </div>

    <div class="span3" id="busqueda-Planilla"></div>
</div>

<div class="row">
    <div class="span12" role="navigation">
        <g:if test="${liquidacion}">
            <div class="btn-group">
                <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                    <g:link controller="reportesPlanillas" action="reporteDiferencias" class="btn btn-info" id="${contrato.id}">
                        <i class="fa fa-list-ul"></i>
                        Reporte de diferencias
                    </g:link>
                    <g:link controller="acta" action="form" class="btn btn-success" params="[contrato: contrato.id, tipo: 'P']">
                        <i class="fa fa-table"></i>
                        Acta de recepción provisional
                    </g:link>
                    <g:set var="actaProvisional" value="${janus.actas.Acta.findAllByContratoAndTipo(contrato, 'P')}"/>
                    <g:if test="${actaProvisional.size() == 1 && actaProvisional[0].registrada == 1}">
                        <g:link controller="acta" action="form" class="btn btn-info" params="[contrato: contrato.id, tipo: 'D']">
                            <i class="fa fa-table"></i>
                            Acta de recepción definitiva
                        </g:link>
                    </g:if>
                </g:if>
            </div>
        </g:if>
        <g:if test="${obra.fechaInicio}">
            <a href="#" class="btn  btn-info" id="imprimir">
                <i class="fa fa-print"></i>
                Imprimir Orden de Inicio de Obra
            </a>
        </g:if>
        <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
            <a href="#" class="btn btn-primary" id="garantias">
                <i class="fa fa-calendar"></i>
                Garantías
            </a>
        </g:if>
    </div>
</div>


<div id="list-Planilla" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr style="width: 100%">
            <th style="width: 15%">#</th>
            <th style="width: 13%">Tipo</th>
            <th style="width: 8%">Fecha Presentación</th>
            <th style="width: 7%">Fecha Inicio</th>
            <th style="width: 7%">Fecha Fin</th>
            <th style="width: 22%">Descripción</th>
            <th style="width: 8%">Valor</th>
            <th style="width: 12%">Acciones</th>
            <th style="width: 8%">Pagos</th>
        </tr>
        </thead>
    </table>
    <div style="width: 100%;height: 600px;overflow-y: auto;float: right; margin-top: -20px" id="detalle">
        <table class="table table-bordered table-striped table-condensed table-hover">
            <tbody class="paginate">
            <g:each in="${planillaInstanceList}" status="i" var="planillaInstance">
                <g:set var="periodosOk" value="${janus.ejecucion.ReajustePlanilla.findAllByPlanilla(planillaInstance)}"/>
                <g:set var="eliminable" value="${planillaInstance.fechaMemoSalidaPlanilla == null}"/>

                <tr style="font-size: 10px" class="${planillaInstance.tipoContrato == 'C' ? 'cmplcss' : ''}">
                    <td style="width: 15%">${fieldValue(bean: planillaInstance, field: "numero")}</td>
                    <td style="width: 13%">
                        ${planillaInstance.tipoPlanilla.nombre}
                        <g:if test="${planillaInstance.tipoPlanilla.codigo == 'P'}">
                            <g:if test="${cont == prej.size() && planillaInstance.fechaFin >= prej[0].fechaFin}">
                                (Liquidación)
                            </g:if>
                            <g:set var="cont" value="${cont + 1}"/>
                        </g:if>
                    </td>
                    <td style="width: 8%">
                        <g:formatDate date="${planillaInstance.fechaPresentacion}" format="dd-MM-yyyy"/>
                    </td>
                    <td style="width: 7%">
                        <g:formatDate date="${planillaInstance.fechaInicio}" format="dd-MM-yyyy"/>
                    </td>
                    <td style="width: 7%">
                        <g:formatDate date="${planillaInstance.fechaFin}" format="dd-MM-yyyy"/>
                    </td>
                    <td style="width: 22%">${planillaInstance?.id} ${fieldValue(bean: planillaInstance, field: "descripcion")}</td>
                    <td class="numero" style="width: 8%">
                        <g:formatNumber number="${planillaInstance.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,##0" locale="ec"/>
                    </td>
                    <td style="width: 12%; text-align: center">
                        <g:if test="${eliminable && planillaInstance.tipoPlanilla.codigo in ['A', 'B']}">
                            <g:link action="form" class="btn btn-xs btn-success" rel="tooltip" title="Editar"
                                    params="[contrato: contrato.id]" id="${planillaInstance.id}">
                                <i class="fa fa-edit"></i>
                            </g:link>
                            <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                                <div data-id="${planillaInstance.id}" rel="tooltip" title="Procesar" class="btn btn-xs btn-success btnProcesa">
                                    <i class="fa fa-cog"></i>
                                </div>
                            </g:if>
                        </g:if>

                        <g:if test="${eliminable && planillaInstance.tipoPlanilla.codigo in ['E']}">
                            <g:link action="sinAnticipo" class="btn btn-xs btn-success" rel="tooltip" title="Editar Entrega"
                                    params="[contrato: contrato.id]" id="${planillaInstance.id}">
                                <i class="fa fa-edit"></i>
                            </g:link>
                        </g:if>

                        <g:if test="${planillaInstance.tipoPlanilla.codigo in ['P', 'Q', 'O', 'C', 'L', 'R'] && !planillaInstance.fechaMemoSalidaPlanilla && contrato?.fiscalizador?.id == session.usuario.id}">
                            <g:link controller="planilla" action="form" params="[id: planillaInstance.id, contrato: planillaInstance.contrato.id]"
                                    rel="tooltip" title="Editar" class="btn btn-xs btn-success">
                                <i class="fa fa-edit"></i>
                            </g:link>
                        </g:if>
                        <g:if test="${planillaInstance.tipoPlanilla.codigo in ['P', 'Q', 'O', 'L', 'R']}">
                            <g:if test="${(contrato?.fiscalizador?.id == session.usuario.id)}">
                                <g:if test="${planillaInstance.tipoPlanilla.codigo != 'L'}">
                                    <g:link action="detalleNuevo" id="${planillaInstance.id}" params="[contrato: contrato.id]"
                                            rel="tooltip" title="Detalles" class="btn btn-xs btn-primary">
                                        <i class="fa fa-list-ul"></i>
                                    </g:link>
                                </g:if>
                                <g:if test="${!planillaInstance.fechaMemoSalidaPlanilla}">
                                    <div data-id="${planillaInstance.id}" rel="tooltip" title="Procesar"
                                         class="btn btn-xs btn-success btnProcesaQ">
                                        <i class="fa fa-cog"></i>
                                    </div>
                                </g:if>
                            </g:if>
                        </g:if>

                        <g:if test="${planillaInstance.tipoPlanilla.codigo in ['E']}">
                            <g:if test="${(contrato?.fiscalizador?.id == session.usuario.id)}">
                                <g:link action="dtEntrega" id="${planillaInstance.id}" params="[contrato: contrato.id]"
                                        rel="tooltip" title="Detalles Entrega" class="btn btn-xs btn-primary">
                                    <i class="fa fa-list-ul"></i>
                                </g:link>
                                <g:if test="${!planillaInstance.fechaMemoSalidaPlanilla}">
                                    <div data-id="${planillaInstance.id}" rel="tooltip" title="Procesar Entrega"
                                         class="btn btn-xs btn-success btnProcesaE">
                                        <i class="fa fa-cog"></i>
                                    </div>
                                </g:if>
                            </g:if>
                        </g:if>
                        <g:if test="${planillaInstance.tipoPlanilla.codigo == 'C'}">
                            <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                                <g:link action="detalleCosto" id="${planillaInstance.id}" params="[contrato: contrato.id]"
                                        rel="tooltip" title="Detalles" class="btn btn-xs btn-primary">
                                    <i class="fa fa-list-ul"></i>
                                </g:link>
                            </g:if>
                        </g:if>
                        <g:if test="${planillaInstance.tipoPlanilla.codigo != 'C' && janus.ejecucion.ReajustePlanilla.countByPlanilla(planillaInstance) > 0}">
                            <g:link controller="reportePlanillas4" action="reportePlanillaNuevo1f" id="${planillaInstance.id}"
                                    class="btn btn-info btnPrint btn-xs btn-ajax" rel="tooltip" title="Imprimir planilla">
                                <i class="fa fa-print"></i>
                            </g:link>
                        </g:if>

                        <g:if test="${planillaInstance.planillaCmpl && janus.ejecucion.DetallePlanillaEjecucion.countByPlanilla(planillaInstance) >= 0}">
                            <g:link controller="reportePlanillas4" action="reportePlanillaTotal1f" id="${planillaInstance.id}"
                                    class="btn btnPrint btn-xs btn-primary btn-ajax" rel="tooltip" title="Imprimir Total">
                                <i class="fa fa-print"></i>
                            </g:link>
                        </g:if>

                        <g:if test="${planillaInstance.tipoPlanilla.codigo == 'C' && janus.ejecucion.DetallePlanillaCosto.countByPlanilla(planillaInstance) > 0}">
                            <g:link controller="reportesPlanillas" action="reportePlanillaCosto" id="${planillaInstance.id}"
                                    class="btn btnPrint btn-xs btn-info btn-ajax" rel="tooltip" title="Imprimir">
                                <i class="fa fa-print"></i>
                            </g:link>
                        </g:if>
                    </td>

                    <td style="text-align: center;width: 8%">
                        <g:if test="${periodosOk.size() > 0 || planillaInstance.tipoPlanilla.codigo == 'C' || planillaInstance.tipoPlanilla.codigo == 'L'}">
                            <g:set var="lblBtn" value="${-1}"/>
                            <g:if test="${planillaInstance.fechaOficioEntradaPlanilla}">
                                <g:set var="lblBtn" value="${2}"/>
                                <g:if test="${planillaInstance.fechaMemoSalidaPlanilla}">
                                    <g:set var="lblBtn" value="${3}"/>
                                    <g:if test="${planillaInstance.fechaMemoPedidoPagoPlanilla}">
                                        <g:set var="lblBtn" value="${4}"/>
                                        <g:if test="${planillaInstance.fechaMemoPagoPlanilla}">
                                            <g:set var="lblBtn" value="${5}"/>
                                        </g:if>
                                    </g:if>
                                </g:if>
                            </g:if>
                            <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A' && planillaInstance.contrato.oferta.concurso.obra.fechaInicio}">
                                <g:set var="lblBtn" value="${-6}"/>
                            </g:if>

                            <g:if test="${lblBtn > 0}">
                                <g:if test="${lblBtn == 2}">
                                    <g:if test="${contrato?.fiscalizador?.id == session.usuario.id}">
                                        <a href="#" class="btn btn-xs btn-success btn-pagar pg_${lblBtn}" data-id="${planillaInstance.id}" data-tipo="${lblBtn}">
                                            Enviar planilla
                                        </a>
                                    </g:if>
                                </g:if>

                                <g:if test="${lblBtn == 3}">
                                    Pedir pago
                                </g:if>

                                <g:if test="${lblBtn == 4}">
                                    Informar pago
                                </g:if>
                                <g:if test="${lblBtn == 5}">
                                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A'}">
                                        Iniciar Obra
                                    </g:if>
                                    <g:else>
                                        <i class="fa fa-check-circle text-success fa-2x" title="Pago completado"></i>
                                    </g:else>
                                </g:if>
                            </g:if>
                            <g:elseif test="${lblBtn == -6}">
                                <i class="fa fa-check-circle text-success fa-2x" title="Pago completado"></i>
                            </g:elseif>

                            <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A' && Math.abs(lblBtn) > 3}">
                                <a href="#" class="btn btn-xs btn-info btnPedidoPagoAnticipo" title="Imprimir memo de pedido de pago"
                                   data-id="${planillaInstance.id}">
                                    <i class="fa fa-print"></i>
                                </a>
                            </g:if>
                            <g:if test="${(planillaInstance.tipoPlanilla.codigo in ['P', 'Q']) && Math.abs(lblBtn) > 3}">
                                <a href="#" class="btn btn-xs btn-info btnPedidoPago" title="Imprimir memo de pedido de pago"
                                   data-id="${planillaInstance.id}">
                                    <i class="fa fa-print"></i>
                                </a>
                            </g:if>
                        </g:if>
                        <g:else>
                        </g:else>
                    </td>
                </tr>
            </g:each>
            </tbody>
        </table>
    </div>
</div>

<div class="modal hide fade mediumModal" id="modal-Planilla">
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


<div id="errorImpresion">
    <fieldset>
        <div class="spa3" style="margin-top: 30px; margin-left: 10px">

            Debe ingresar un número de Oficio!

        </div>
    </fieldset>
</div>

<div class="modal hide fade mediumModal" id="modal-var" style="overflow: hidden">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">x</button>

        <h3 id="modal_tittle_var">

        </h3>

    </div>

    <div class="modal-body" id="modal_body_var">

    </div>

    <div class="modal-footer" id="modal_footer_var">

    </div>

</div>


<script type="text/javascript">


    $("#garantias").click(function () {
        var d = cargarLoader("Cargando...");
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'garantiaFinanciero', action:'garantia_ajax')}",
            data    : {
                contrato : '${contrato?.id}'
            },
            success : function (msg) {
                d.modal("hide");
                var b = bootbox.dialog({
                    id      : "dlgShowGarantia",
                    title   : "Garantía",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Aceptar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
    });

    $("#btnNuevaPlanilla").click(function () {
        <g:if test="${Planilla.findByContratoAndTipoPlanilla(janus.Contrato.get(contrato?.id), TipoPlanilla.findByCodigo('A'))}">
        <g:if test="${contrato?.obra?.fechaInicio}">
        location.href = "${g.createLink(controller: 'planilla', action: 'form')}?contrato=" + ${contrato?.id};
        </g:if>
        <g:else>
        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Sin Inicio de Obra </br> La obra perteneciente a este contrato no ha sido iniciada, no se puede crear planillas" + '</strong>');
        </g:else>
        </g:if>
        <g:else>
        location.href = "${g.createLink(controller: 'planilla',action: 'form')}?contrato=" + ${contrato?.id};
        </g:else>
    });

    function submitFormOC(btn) {
        if ($("#frmSave-OrdenCambio").valid()) {
        }
        $("#frmSave-OrdenCambio").submit();
    }

    function submitFormOC2(btn,id) {
        if ($("#frmSave-OrdenCambio").valid()) {
            $("#frmSave-OrdenCambio").submit();
        }
    }

    function submitFormOT(btn) {
        if ($("#frmSave-OrdenTrabajo").valid()) {
        }
        $("#frmSave-OrdenTrabajo").submit();
    }

    $(".btnOrdenCambio").click(function () {
        var id = $(this).data("id");
        $.ajax({
            type    : "POST",
            url: '${createLink(controller: 'planilla', action: 'ordenCambio_ajax')}',
            data    : {
                id : id
            },
            success : function (msg) {
                var $btnSave = $('<a href="#" class="btn btn-success"><i class="icon icon-save"></i> Guardar</a>');
                var $btnCerrar = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
                var $btnImprimir = $('<a href="#" data-dismiss="modal" class="btn btn-info"><i class="icon icon-print"></i> Imprimir</a>');

                $btnSave.click(function () {
                    $("#adi").val(0);
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: 'planilla', action:'saveOrdenCambio')}",
                        data: $("#frmSave-OrdenCambio").serialize(),
                        success: function (msg) {
                            if (msg !== 'no') {
                                alert('Orden de Cambio Guardada!')
                            } else {
                                alert('No se pudo guardar la orden de cambio')
                            }
                        }
                    });
                });

                $btnImprimir.click(function () {
                    $("#adi").val(1);
                    submitFormOC2($btnSave,id);
                    return false;
                });

                $("#modal_tittle_var").text("Orden de Cambio");
                $("#modal_body_var").html(msg);
                $("#modal_footer_var").html($btnCerrar).append($btnImprimir).append($btnSave);
                $("#modal-var").modal("show");
            }
        });
        return false;
    });

    $(".btnOrdenTrabajo").click(function () {
        var id = $(this).data("id");
        $.ajax({
            type    : "POST",
            url: '${createLink(controller: 'planilla', action: 'ordenTrabajo_ajax')}',
            data    : {
                id : id
            },
            success : function (msg) {
                var $btnSave = $('<a href="#" class="btn btn-success"><i class="icon icon-save"></i> Guardar</a>');
                var $btnCerrar = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
                var $btnImprimir = $('<a href="#" data-dismiss="modal" class="btn btn-info"><i class="icon icon-print"></i> Imprimir</a>');

                $btnSave.click(function () {
                    $("#adi2").val(0);
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: 'planilla', action:'saveOrdenTrabajo')}",
                        data: $("#frmSave-OrdenTrabajo").serialize(),
                        success: function (msg) {
                            if (msg !== 'no') {
                                alert('Orden de Trabajo Guardada!')
                            } else {
                                alert('No se pudo guardar la orden de trabajo')
                            }
                        }
                    });
                });

                $btnImprimir.click(function () {
                    $("#adi2").val(1);
                    submitFormOT($btnSave);
                    return false;
                });

                $("#modal_tittle_var").text("Orden de Trabajo");
                $("#modal_body_var").html(msg);
                $("#modal_footer_var").html($btnCerrar).append($btnImprimir).append($btnSave);
                $("#modal-var").modal("show");
            }
        });
        return false;
    });

    var url = "${resource(dir:'images', file:'spinner_24.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");

    function submitForm() {
        if ($("#frmSave-Planilla").valid()) {
            $("#frmSave-Planilla").submit();
        }
        return false;
    }

    $(function () {

        $(".btnPedidoPagoAnticipo").click(function () {
            location.href = "${g.createLink(controller: 'reportesPlanillas',action: 'memoPedidoPagoAnticipo')}/" + $(this).data("id");
            return false;
        });

        $(".btnPedidoPago").click(function () {
            location.href = "${g.createLink(controller: 'reportesPlanillas', action: 'memoPedidoPago')}/" + $(this).data("id");
            return false;
        });

        $(".btn-pagar").click(function () {
            var $btn = $(this);
            var tipo = $btn.data("tipo").toString();
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'pago_ajax')}",
                data    : {
                    id   : $btn.data("id"),
                    tipo : tipo
                },
                success : function (msg) {

                    if(msg === "NO"){
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' +
                            '<strong style="font-size: 14px">' + "No se encontró un administrador activo para el contrato.<br/>Por favor asigne uno desde la página del contrato en la opción Administrador." + '</strong>');
                    }else{
                        var b = bootbox.dialog({
                            id      : "dlgPagar",
                            title   : "Pedir pago",
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
                    }
                }
            });
            return false;
        }); //click btn new

        $(".btn-new").click(function () {
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'form_ajax')}",
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                    $("#modalTitle").html("Crear Planilla");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk).append(btnSave);
                    $("#modal-Planilla").modal("show");
                }
            });
            return false;
        }); //click btn new

        $(".btn-edit").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'form_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        submitForm(btnSave);
                        return false;
                    });

                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");
                    $("#modalTitle").html("Editar Planilla");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk).append(btnSave);
                    $("#modal-Planilla").modal("show");
                }
            });
            return false;
        }); //click btn edit

        $(".btn-show").click(function () {
            var id = $(this).data("id");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'show_ajax')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');
                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-show");
                    $("#modalTitle").html("Ver Planilla");
                    $("#modalBody").html(msg);
                    $("#modalFooter").html("").append(btnOk);
                    $("#modal-Planilla").modal("show");
                }
            });
            return false;
        }); //click btn show

        $(".btnProcesa").click(function () {
            var id = $(this).data("id");
            var g = cargarLoader("Procesando...");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'procesarLq')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    location.reload();
                    g.modal("hide");
                }
            });
            return false;
        }); //click btn show

        $(".btnProcesaQ").click(function () {
            var id = $(this).data("id");
            var g = cargarLoader("Procesando...");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'procesarLq')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    g.modal("hide");
                    if (msg === 'fechas') {
                        location.href = "${g.createLink(controller: 'contrato', action: 'fechasPedidoRecepcion' )}?id=" + ${contrato?.id};
                    } else {
                        location.reload();
                    }
                }
            });
            return false;
        }); //click btn show

        $(".btnProcesaE").click(function () {
            var id = $(this).data("id");
            var g = cargarLoader("Procesando...");
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'procEntrega')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    g.modal("hide");
                    if (msg === 'fechas') {
                        location.href = "${g.createLink(controller: 'contrato', action: 'fechasPedidoRecepcion' )}?id=" + ${contrato?.id};
                    } else {
                        location.reload();
                    }
                }
            });
            return false;
        }); //click btn show

        $(".btn-delete").click(function () {
            var id = $(this).data("id");
            $("#id").val(id);
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
            var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');

            btnDelete.click(function () {
                btnDelete.replaceWith(spinner);
                $("#frmDelete-Planilla").submit();
                return false;
            });

            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
            $("#modalTitle").html("Eliminar Planilla");
            $("#modalBody").html("<p>¿Está seguro de querer eliminar esta Planilla?</p>");
            $("#modalFooter").html("").append(btnOk).append(btnDelete);
            $("#modal-Planilla").modal("show");
            return false;
        });

        $("#imprimir").click(function () {
            location.href = "${g.createLink(controller: 'reportesPlanillas', action: 'reporteContrato', id: obra?.id)}?oficio=" +
                $("#oficio").val() + "&firma=" + $("#firma").val();
        });

        $("#errorImpresion").dialog({
            autoOpen  : false,
            resizable : false,
            modal     : true,
            draggable : false,
            width     : 320,
            height    : 200,
            position  : 'center',
            title     : 'Error',
            buttons   : {
                "Aceptar" : function () {
                    $("#errorImpresion").dialog("close")
                }
            }
        });

    });

</script>

</body>
</html>