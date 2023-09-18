<%@ page import="janus.ejecucion.TipoPlanilla; janus.ejecucion.Planilla" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Planillas
    </title>
</head>

<body>

<div class="alert alert-info">
    Planillas del contrato: <strong>${contrato?.codigo + " - " + obra?.descripcion}</strong>
</div>

<g:set var="anticipo"
       value="${janus.ejecucion.Planilla.countByContratoAndTipoPlanilla(contrato, TipoPlanilla.findByCodigo('A'))}"/>

<div class="row">
    <div class="span9 btn-group" role="navigation">
        <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-primary"
                title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
    </div>

    <div class="span3" id="busqueda-Planilla"></div>
</div>

<div class="row">
    <div class="col-md-3" role="navigation">
        <g:if test="${obra.fechaInicio}">
            <a href="#" class="btn btn-info" id="imprimir">
                <i class="fa fa-print"></i>
                Imprimir Orden de Inicio de Obra
            </a>
        </g:if>
    </div>
    <div class="col-md-5" role="navigation">
        <g:if test="${contrato.administrador.id == session.usuario.id}">
            <g:link controller="acta" action="form" class="btn btn-info" params="[contrato: contrato.id, tipo: 'P']">
                <i class="fa fa-book"></i>
                Acta de recepción provisional
            </g:link>
            <g:set var="actaProvisional" value="${janus.actas.Acta.findAllByContratoAndTipo(contrato, 'P')}"/>
            <g:if test="${actaProvisional.size() == 1 && actaProvisional[0].registrada == 1}">
                <g:link controller="acta" action="form" class="btn btn-info" params="[contrato: contrato.id, tipo: 'D']">
                    <i class="fa fa-book"></i>
                    Acta de recepción definitiva
                </g:link>
            </g:if>
        </g:if>
    </div>
</div>

<div id="list-Planilla" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th>#</th>
            <th>Tipo</th>
            <th>Fecha de presentación</th>
            <th>Fecha de inicio</th>
            <th>Fecha de fin</th>
            <th>Descripción</th>
            <th>Valor</th>
            <th>Acciones</th>
            <th>Pagos</th>
        </tr>
        </thead>
        <g:set var="cont" value="${1}"/>
        <g:set var="prej" value="${janus.pac.PeriodoEjecucion.findAllByObra(obra, [sort: 'fechaFin', order: 'desc'])}"/>
        <tbody class="paginate">
        <g:each in="${planillaInstanceList}" status="i" var="planillaInstance">
            <g:set var="eliminable" value="${planillaInstance.fechaMemoSalidaPlanilla == null}"/>
            <tr style="font-size: 10px">
                <td>${fieldValue(bean: planillaInstance, field: "numero")}</td>
                <td>
                    ${planillaInstance.tipoPlanilla.nombre}

                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'P'}">
                        <g:if test="${cont == prej.size() && planillaInstance.fechaFin >= prej[0].fechaFin}">
                            (Liquidación)
                        </g:if>
                        <g:set var="cont" value="${cont + 1}"/>
                    </g:if>

                </td>
                <td>
                    <g:formatDate date="${planillaInstance.fechaPresentacion}" format="dd-MM-yyyy"/>
                </td>
                <td>
                    <g:formatDate date="${planillaInstance.fechaInicio}" format="dd-MM-yyyy"/>
                </td>
                <td>
                    <g:formatDate date="${planillaInstance.fechaFin}" format="dd-MM-yyyy"/>
                </td>
                <td>${fieldValue(bean: planillaInstance, field: "descripcion")}</td>
                <td class="numero">
                    <g:formatNumber number="${planillaInstance.valor}" maxFractionDigits="2" minFractionDigits="2"
                                    format="##,##0" locale="ec"/>
                </td>
                <td style="text-align: center">
%{--                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'L'}">--}%
%{--                        <g:link controller="planilla2" action="liquidacion" id="${planillaInstance.id}" rel="tooltip"--}%
%{--                                title="Resumen" class="btn btn-small">--}%
%{--                            <i class=""></i>--}%
%{--                        </g:link>--}%
%{--                    </g:if>--}%
                %{--
                                                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'C'}">
                                                    <g:link action="detalleCosto" id="${planillaInstance.id}" params="[contrato: contrato.id]" rel="tooltip" title="Detalles" class="btn btn-small">
                                                        <i class="icon-reorder icon-large"></i>
                                                    </g:link>
                                                </g:if>
                --}%
                %{--
                                                <g:if test="${janus.ejecucion.PeriodoPlanilla.countByPlanilla(planillaInstance) > 0}">
                                                    <g:link controller="reportePlanillas3" action="reportePlanillaNuevo" id="${planillaInstance.id}" class="btn btnPrint  btn-small btn-ajax" rel="tooltip" title="Imprimir">
                                                        <i class="icon-print"></i>
                                                    </g:link>
                                                </g:if>
                --}%


                    <g:if test="${janus.ejecucion.ReajustePlanilla.countByPlanilla(planillaInstance) > 0}">
                        <g:link controller="reportePlanillas3" action="reportePlanillaNuevo" id="${planillaInstance.id}"
                                class="btn btnPrint  btn-xs btn-info btn-ajax" rel="tooltip" title="Imprimir">
                            <i class="fa fa-print"></i>
                        </g:link>
                    </g:if>
                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'C' && janus.ejecucion.DetallePlanillaCosto.countByPlanilla(planillaInstance) > 0}">
                        <g:link controller="reportesPlanillas" action="reportePlanillaCosto" id="${planillaInstance.id}"
                                class="btn btnPrint  btn-xs btn-info btn-ajax" rel="tooltip" title="Imprimir">
                            <i class="fa fa-print"></i>
                        </g:link>
                    </g:if>
                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'L'}">
                        <g:link controller="reportesPlanillas" action="reportePlanillaLiquidacion"
                                id="${planillaInstance.id}" class="btn btnPrint btn-info  btn-xs btn-ajax" rel="tooltip"
                                title="Imprimir">
                            <i class="fa fa-print"></i>
                        </g:link>
                    </g:if>

                </td>
                <td style="text-align: center;">
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
                            Enviar planilla
                        </g:if>

                        <g:if test="${(lblBtn == 3)}">
                            <g:if test="${garantia >= planillaInstance.fechaFin}">
                                <g:if test="${(contrato.administrador.id == session.usuario.id) && ((janus.ejecucion.ReajustePlanilla.countByPlanilla(planillaInstance) > 0) || (planillaInstance.tipoPlanilla.codigo == 'C'))}">
                                    <a href="#" class="btn btn-info btn-xs btn-pagar pg_${lblBtn}" data-id="${planillaInstance.id}"
                                       data-tipo="${lblBtn}">
                                        Pedir pago
                                    </a>
                                </g:if>
                            </g:if>
                            <g:else>
                                No se ha ingresado la garantía de este contrato, no es posible pedir el pago
                            </g:else>
                            <g:if test="${planillaInstance.tipoPlanilla.codigo != 'A'}">
                                <g:if test="${contrato.administrador.id == session.usuario.id}">
                                    <a href="#" class="btn btn-warning btn-xs btn-devolver pg_${lblBtn}"
                                       data-id="${planillaInstance.id}" data-tipo="${lblBtn}"
                                       data-txt="${planillaInstance.tipoPlanilla.codigo == 'A' ? 'reajuste' : 'planilla'}">
                                        Devolver
                                    </a>
                                </g:if>
                            </g:if>
                        </g:if>
                        <g:if test="${lblBtn == 4}">
                            Informar pago
                        </g:if>
                        <g:if test="${lblBtn == 5}">
                            <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A'}">
                                <a href="#" class="btn btn-success btn-xs btn-pagar pg_${lblBtn}" data-id="${planillaInstance.id}"
                                   data-tipo="${lblBtn}">
                                    Iniciar Obra
                                </a>
                            </g:if>
                            <g:else>
                                Pago completado
                            </g:else>
                        </g:if>
                    </g:if>
                    <g:else>
                        <g:if test="${lblBtn == -6}">
                           Pago completado
                        </g:if>
                    </g:else>
                    <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A' && Math.abs(lblBtn) > 3}">
                        <g:if test="${planillaInstance?.valor > 0}">
                            <a href="#" class="btn btn-xs btn-info btnPedidoPagoAnticipo"
                               title="Imprimir memorando de pedido de pago" data-id="${planillaInstance.id}">
                                <i class="fa fa-print"></i>
                            </a>
                        </g:if>
                    </g:if>
                    <g:if test="${(cmpl > 0) && (Math.abs(lblBtn?:0) > 3) && (planillaInstance.tipoPlanilla.codigo in ['O', 'P', 'Q', 'L'])}">
                        <g:if test="${planillaInstance?.tipoContrato == 'C'}">
                            <a href="#" class="btn btn-xs btnPedidoPagoC btn-info" title="Pedido de pago Complementarios"
                               data-id="${planillaInstance.id}">
                                <i class="fa fa-print"></i>
                            </a>
                        </g:if>
                        <g:if test="${(planillaInstance.tipoPlanilla.codigo in ['O', 'P', 'Q', 'L']) && Math.abs(lblBtn) > 3}">
                            <a href="#" class="btn btn-xs btn-info btnPedidoPago" title="Imprimir memorandum de pedido de pago"
                               data-id="${planillaInstance.id}">
                                <i class="fa fa-print"></i>
                            </a>
                        </g:if>
                    </g:if>
                    <g:else>
                        <g:if test="${(planillaInstance.tipoPlanilla.codigo in ['O', 'P', 'Q', 'L']) && Math.abs(lblBtn) > 3}">
                            <a href="#" class="btn btn-xs btnPedidoPago btn-info" title="Imprimir memorandum de pedido de pago"
                               data-id="${planillaInstance.id}">
                                <i class="fa fa-print"></i>
                            </a>
                        </g:if>
                    </g:else>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
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

%{--<div id="errorImpresion">--}%
%{--    <fieldset>--}%
%{--        <div class="spa3" style="margin-top: 30px; margin-left: 10px">--}%
%{--            Debe ingresar un número de Oficio!--}%
%{--        </div>--}%
%{--    </fieldset>--}%
%{--</div>--}%

<script type="text/javascript">
    var url = "${resource(dir:'images', file:'spinner_24.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");

    function submitForm() {
        if ($("#frmSave-Planilla").valid()) {
            $("#frmSave-Planilla").submit();
        }

        return false
    }

    $(function () {

        $("#imprimir").click(function () {
            location.href = "${g.createLink(controller: 'reportesPlanillas', action: 'reporteContrato', id: obra?.id)}?oficio=" + $("#oficio").val() + "&firma=" + $("#firma").val();
        });

        $(".btnPedidoPagoAnticipo").click(function () {
            location.href = "${g.createLink(controller: 'reportesPlanillas',action: 'memoPedidoPagoAnticipo')}/" + $(this).data("id");
            return false;
        });
        $(".btnPedidoPago").click(function () {
            location.href = "${g.createLink(controller: 'reportesPlanillas',action: 'memoPedidoPago')}/" + $(this).data("id");
            return false;
        });

        $(".btnPedidoPagoC").click(function () {
            location.href = "${g.createLink(controller: 'reportesPlanillas',action: 'memoPedidoPagoComp')}/" + $(this).data("id");
            return false;
        });

        $(".btn-pagar").click(function () {
            var $btn = $(this);
            var tipo = $btn.data("tipo").toString();
            var titulo = '';

            if(tipo === '5'){
                titulo = 'Iniciar obra'
            }else{
                titulo = 'Pedir Pago'
            }

            $.ajax({
                type: "POST",
                url: "${createLink(action:'pago_ajax')}",
                data: {
                    id: $btn.data("id"),
                    tipo: tipo
                },
                success: function (msg) {
                    if(msg === "NO"){
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No se encontró un administrador activo para el contrato.<br/>Por favor asigne uno desde la página del contrato en la opción Administrador." + '</strong>');
                    }else{
                        var b = bootbox.dialog({
                            id      : "dlgPagar",
                            title   : titulo,
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
        }); //click btn pagar

        $(".btn-devolver").click(function () {
            var $btn = $(this);
            var tipo = $btn.data("tipo").toString();
            var titulo = ''

            switch (tipo) {
                case "3":
                    titulo = "Devolver a Enviar";
                    break;
                case "4":
                    titulo = "Devolver a Pedir pago";
                    break;
            }


            $.ajax({
                type: "POST",
                url: "${createLink(action:'devolver_ajax')}",
                data: {
                    id: $btn.data("id"),
                    tipo: tipo
                },
                success: function (msg) {


                    var d = bootbox.dialog({
                        id      : "dlgDevolver",
                        title   : titulo,
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
            });
            return false;
        }); //click btn devolver

        $(".btn-new").click(function () {
            $.ajax({
                type: "POST",
                url: "${createLink(action:'form_ajax')}",
                success: function (msg) {
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
                type: "POST",
                url: "${createLink(action:'form_ajax')}",
                data: {
                    id: id
                },
                success: function (msg) {
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
                type: "POST",
                url: "${createLink(action:'show_ajax')}",
                data: {
                    id: id
                },
                success: function (msg) {
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
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'procesarLq')}",
                data    : {
                    id : id
                },
                success : function (msg) {
                    location.reload();
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
            location.href = "${g.createLink(controller: 'reportesPlanillas', action: 'reporteContrato', id: obra?.id)}?oficio=" + $("#oficio").val() + "&firma=" + $("#firma").val();
        });

        // $("#errorImpresion").dialog({
        //     autoOpen: false,
        //     resizable: false,
        //     modal: true,
        //     draggable: false,
        //     width: 320,
        //     height: 200,
        //     position: 'center',
        //     title: 'Error',
        //     buttons: {
        //         "Aceptar": function () {
        //
        //             $("#errorImpresion").dialog("close")
        //
        //         }
        //     }
        //
        // });
    });

</script>

</body>
</html>
