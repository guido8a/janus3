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
        <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-primary"
                title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
    </div>

    <div class="span3" id="busqueda-Planilla"></div>
</div>

<div class="row">
    <div class="span12" role="navigation">
        <g:if test="${obra.fechaInicio}">
            <a href="#" class="btn  " id="imprimir">
                <i class="icon-print"></i>
                Imprimir Orden de Inicio de Obra
            </a>
        </g:if>
    </div>
</div>

<g:form action="delete" name="frmDelete-Planilla">
    <g:hiddenField name="id"/>
</g:form>

<div id="list-Planilla" role="main" style="margin-top: 10px;">

<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <g:sortableColumn property="numero" title="#"/>
        <g:sortableColumn property="tipoPlanilla" title="Tipo"/>
        <g:sortableColumn property="fechaPresentacion" title="Fecha presentación"/>
        <g:sortableColumn property="fechaInicio" title="Fecha inicio"/>
        <g:sortableColumn property="fechaFin" title="Fecha fin"/>
        <g:sortableColumn property="descripcion" title="Descripcion"/>
        <g:sortableColumn property="valor" title="Valor"/>
        <th width="160">Acciones</th>
        <th>Pagos</th>
    </tr>
    </thead>
    <g:set var="cont" value="${1}"/>
    <g:set var="prej" value="${janus.pac.PeriodoEjecucion.findAllByObra(obra, [sort: 'fechaFin', order: 'desc'])}"/>
    <tbody class="paginate">
    <g:each in="${planillaInstanceList}" status="i" var="planillaInstance">
        <g:set var="periodosOk" value="${janus.ejecucion.PeriodoPlanilla.findAllByPlanilla(planillaInstance)}"/>

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
            <td>

                <g:if test="${planillaInstance.tipoPlanilla.codigo != 'C' && janus.ejecucion.ReajustePlanilla.countByPlanilla(planillaInstance) > 0}">
                    <g:link controller="reportePlanillas4" action="reportePlanillaNuevo1f" id="${planillaInstance.id}"
                            class="btn btn-info btnPrint btn-xs btn-ajax" rel="tooltip" title="Imprimir planilla">
                        <i class="fa fa-print"></i>
                    </g:link>
                </g:if>

%{--                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'P'}">--}%
%{--                    <g:link action="detalle" id="${planillaInstance.id}" params="[contrato: contrato.id]" rel="tooltip"--}%
%{--                            title="Detalles" class="btn btn-small">--}%
%{--                        <i class="icon-reorder icon-large"></i>--}%
%{--                    </g:link>--}%
%{--                </g:if>--}%
%{--                <g:if test="${planillaInstance.tipoPlanilla.codigo == 'A'}">--}%
%{--                    <g:link controller="planilla2" action="resumen" id="${planillaInstance.id}" rel="tooltip"--}%
%{--                            title="Resumen" class="btn btn-small">--}%
%{--                        <i class="icon-table icon-large"></i>--}%
%{--                    </g:link>--}%
%{--                </g:if>--}%
%{--                <g:elseif test="${planillaInstance.tipoPlanilla.codigo in ['P', 'Q']}">--}%
%{--                    <g:link controller="planilla2" action="resumen" id="${planillaInstance.id}" fprj="${planillaInstance.formulaPolinomicaReajuste}" rel="tooltip"--}%
%{--                            title="Resumen" class="btn btn-small">--}%
%{--                        <i class="icon-table icon-large"></i>--}%
%{--                    </g:link>--}%
%{--                </g:elseif>--}%
%{--                <g:elseif test="${planillaInstance.tipoPlanilla.codigo == 'L'}">--}%
%{--                    <g:link controller="planilla2" action="liquidacion" id="${planillaInstance.id}" rel="tooltip"--}%
%{--                            title="Resumen" class="btn btn-small">--}%
%{--                        <i class="icon-table icon-large"></i>--}%
%{--                    </g:link>--}%
%{--                </g:elseif>--}%

            </td>
            <td style="text-align: center;">
                <g:if test="${periodosOk.size() > 0}">
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
                            <g:if test="${planillaInstance.tipoPlanilla.codigo != 'A'}">
                                Enviar planilla
                            </g:if>
                        </g:if>
                        <g:if test="${lblBtn == 3 || (lblBtn == 2 && planillaInstance.tipoPlanilla.codigo == 'A')}">
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
                               Pago completado
                            </g:else>
                        </g:if>
                    </g:if>
                    <g:elseif test="${lblBtn == -6}">
                        Pago completado
                    </g:elseif>
                </g:if>
                <g:else>
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

<script type="text/javascript">
    var url = "${resource(dir:'images', file:'spinner_24.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");

    function submitForm(btn) {
        if ($("#frmSave-Planilla").valid()) {
            btn.replaceWith(spinner);
        }
        $("#frmSave-Planilla").submit();
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

        %{--$(".btn-pagar").click(function () {--}%
        %{--    var $btn = $(this);--}%
        %{--    var tipo = $btn.data("tipo").toString();--}%
        %{--    $.ajax({--}%
        %{--        type: "POST",--}%
        %{--        url: "${createLink(action:'pago_ajax')}",--}%
        %{--        data: {--}%
        %{--            id: $btn.data("id"),--}%
        %{--            tipo: tipo--}%
        %{--        },--}%
        %{--        success: function (msg) {--}%
        %{--            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');--}%
        %{--            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');--}%

        %{--            btnSave.click(function () {--}%
        %{--                submitForm(btnSave);--}%
        %{--                return false;--}%
        %{--            });--}%

        %{--            switch (tipo) {--}%
        %{--                case "2":--}%
        %{--                    $("#modalTitle").html("Enviar reajuste");--}%
        %{--                    break;--}%
        %{--                case "3":--}%
        %{--                    $("#modalTitle").html("Pedir pago");--}%
        %{--                    break;--}%
        %{--                case "4":--}%
        %{--                    $("#modalTitle").html("Informar pago");--}%
        %{--                    break;--}%
        %{--            }--}%

        %{--            $("#modalHeader").removeClass("btn-edit btn-show btn-delete");--}%

        %{--            $("#modalBody").html(msg);--}%
        %{--            $("#modalFooter").html("").append(btnOk).append(btnSave);--}%
        %{--            $("#modal-Planilla").modal("show");--}%
        %{--        }--}%
        %{--    });--}%
        %{--    return false;--}%
        %{--}); //click btn new--}%

        %{--$(".btn-new").click(function () {--}%
        %{--    $.ajax({--}%
        %{--        type: "POST",--}%
        %{--        url: "${createLink(action:'form_ajax')}",--}%
        %{--        success: function (msg) {--}%
        %{--            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');--}%
        %{--            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');--}%

        %{--            btnSave.click(function () {--}%
        %{--                submitForm(btnSave);--}%
        %{--                return false;--}%
        %{--            });--}%

        %{--            $("#modalHeader").removeClass("btn-edit btn-show btn-delete");--}%
        %{--            $("#modalTitle").html("Crear Planilla");--}%
        %{--            $("#modalBody").html(msg);--}%
        %{--            $("#modalFooter").html("").append(btnOk).append(btnSave);--}%
        %{--            $("#modal-Planilla").modal("show");--}%
        %{--        }--}%
        %{--    });--}%
        %{--    return false;--}%
        %{--}); //click btn new--}%

        %{--$(".btn-edit").click(function () {--}%
        %{--    var id = $(this).data("id");--}%
        %{--    $.ajax({--}%
        %{--        type: "POST",--}%
        %{--        url: "${createLink(action:'form_ajax')}",--}%
        %{--        data: {--}%
        %{--            id: id--}%
        %{--        },--}%
        %{--        success: function (msg) {--}%
        %{--            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');--}%
        %{--            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');--}%

        %{--            btnSave.click(function () {--}%
        %{--                submitForm(btnSave);--}%
        %{--                return false;--}%
        %{--            });--}%

        %{--            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-edit");--}%
        %{--            $("#modalTitle").html("Editar Planilla");--}%
        %{--            $("#modalBody").html(msg);--}%
        %{--            $("#modalFooter").html("").append(btnOk).append(btnSave);--}%
        %{--            $("#modal-Planilla").modal("show");--}%
        %{--        }--}%
        %{--    });--}%
        %{--    return false;--}%
        %{--}); //click btn edit--}%

        %{--$(".btn-show").click(function () {--}%
        %{--    var id = $(this).data("id");--}%
        %{--    $.ajax({--}%
        %{--        type: "POST",--}%
        %{--        url: "${createLink(action:'show_ajax')}",--}%
        %{--        data: {--}%
        %{--            id: id--}%
        %{--        },--}%
        %{--        success: function (msg) {--}%
        %{--            var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');--}%
        %{--            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-show");--}%
        %{--            $("#modalTitle").html("Ver Planilla");--}%
        %{--            $("#modalBody").html(msg);--}%
        %{--            $("#modalFooter").html("").append(btnOk);--}%
        %{--            $("#modal-Planilla").modal("show");--}%
        %{--        }--}%
        %{--    });--}%
        %{--    return false;--}%
        %{--}); //click btn show--}%

        // $(".btn-delete").click(function () {
        //     var id = $(this).data("id");
        //     $("#id").val(id);
        //     var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
        //     var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');
        //
        //     btnDelete.click(function () {
        //         btnDelete.replaceWith(spinner);
        //         $("#frmDelete-Planilla").submit();
        //         return false;
        //     });
        //
        //     $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
        //     $("#modalTitle").html("Eliminar Planilla");
        //     $("#modalBody").html("<p>¿Está seguro de querer eliminar esta Planilla?</p>");
        //     $("#modalFooter").html("").append(btnOk).append(btnDelete);
        //     $("#modal-Planilla").modal("show");
        //     return false;
        // });

    });

</script>

</body>
</html>
