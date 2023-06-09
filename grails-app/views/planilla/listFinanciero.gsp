<%@ page import="janus.ejecucion.Planilla" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Planillas
    </title>
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

<div class="alert alert-info">
    Planillas del contrato: <strong>${contrato?.codigo + " - " + obra?.descripcion}</strong>
</div>

<div class="row">
    <div class="span9 btn-group" role="navigation">
        <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-primary" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
    </div>

    <div class="span3" id="busqueda-Planilla"></div>
</div>

<div class="row">
    <div class="span12" role="navigation">
        <g:if test="${obra?.fechaInicio}">
            <a href="#" class="btn btn-info" id="imprimir">
                <i class="fa fa-print"></i>
                Imprimir Orden de Inicio de Obra
            </a>
        </g:if>
    </div>
</div>


<div id="list-Planilla" role="main" style="margin-top: 10px;">

    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr>
            <th style="width: 15%">#</th>
            <th style="width: 13%">Tipo</th>
            <th style="width: 8%">Fecha Presentación</th>
            <th style="width: 7%">Fecha Inicio</th>
            <th style="width: 6%">Fecha Fin</th>
            <th style="width: 22%">Descripción</th>
            <th style="width: 7%">Valor</th>
            <th style="width: 8%">Acciones</th>
            <th style="width: 14%">Pagos</th>
        </tr>
        </thead>
        <g:set var="cont" value="${1}"/>
        <g:set var="prej" value="${janus.pac.PeriodoEjecucion.findAllByObra(obra, [sort: 'fechaFin', order: 'desc'])}"/>
        <tbody class="paginate">
        <g:each in="${planillaInstanceList}" status="i" var="planillaInstance">
            <g:set var="periodosOk" value="1"/>
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
                    <g:formatNumber number="${planillaInstance.valor}" maxFractionDigits="2" minFractionDigits="2" format="##,##0" locale="ec"/>
                </td>
                <td style="text-align: center">
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

                <td style="text-align: center;">
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
                        <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A' && planillaInstance.contrato.obra.fechaInicio}">
                            <g:set var="lblBtn" value="${-6}"/>
                        </g:if>
                        <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A' && !planillaInstance.contrato.obra.fechaInicio && planillaInstance.fechaMemoPedidoPagoPlanilla}">
                            <g:set var="lblBtn" value="${-7}"/>
                        </g:if>
                        <g:if test="${lblBtn > 0}">
                            <g:if test="${lblBtn == 2}">
                                <g:if test="${planillaInstance.tipoPlanilla.codigo != 'A'}">
                                    Enviar planilla
                                </g:if>
                            </g:if>
                            <g:if test="${lblBtn == 3 || (lblBtn == 2 && planillaInstance.tipoPlanilla.codigo == 'A')}">
                                Pedir pago
                            </g:if>
                            <g:if test="${lblBtn == 4}">
                                <a href="#" class="btn btn-pagar btn-success btn-xs pg_${lblBtn}" data-id="${planillaInstance.id}" data-tipo="${lblBtn}">
                                    Informar pago
                                </a>
                                <a href="#" class="btn btn-devolver pg_${lblBtn} btn-warning btn-xs" data-id="${planillaInstance.id}" data-tipo="${lblBtn}" data-txt="${planillaInstance.tipoPlanilla.codigo == 'A' ? 'reajuste' : 'planilla'}">
                                    Devolver
                                </a>
                            </g:if>
                            <g:elseif test="${lblBtn == 5}">
                                <a href="#" class="btn btn-pagar btn-success btn-xs pg_${lblBtn}" data-id="${planillaInstance.id}" data-tipo="4">
                                    Corregir pago
                                </a>
                                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A'}">
                                    Iniciar Obra
                                </g:if>
                                <g:else>
                                    Pago completado
                                </g:else>
                            </g:elseif>
                        </g:if>
                        <g:elseif test="${lblBtn == -6}">
                            Pago completado
                        </g:elseif>
                        <g:elseif test="${lblBtn == -7}">
                            <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A' && planillaInstance.fechaMemoPagoPlanilla}">
                                <a href="#" class="btn btn-pagar btn-success btn-xs pg_${lblBtn}" data-id="${planillaInstance.id}" data-tipo="4">
                                    Corregir pago
                                </a>
                                Pago completado
                            </g:if>
                            <g:else>
                                <a href="#" class="btn btn-pagar btn-success btn-xs pg_${lblBtn}" data-id="${planillaInstance.id}" data-tipo="4">
                                    Informar pago
                                </a>
                            </g:else>
                        </g:elseif>
                    </g:if>
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
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No se encontró un administrador activo para el contrato.<br/>Por favor asigne uno desde la página del contrato en la opción Administrador." + '</strong>');
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


        $(".btn-devolver").click(function () {
            var $btn = $(this);
            var tipo = $btn.data("tipo").toString();
            var titulo = '';

            switch (tipo) {
                case "3":
                    titulo = "Devolver a Enviar";
                    break;
                case "4":
                   titulo = "Devolver a Pedir pago";
                    break;
            }

            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'devolver_ajax')}",
                data    : {
                    id   : $btn.data("id"),
                    tipo : tipo
                },
                success : function (msg) {


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

    });

</script>

</body>
</html>
