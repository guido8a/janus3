<%@ page import="janus.pac.TipoContrato; janus.ejecucion.TipoPlanilla; janus.ejecucion.Planilla" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        <g:if test="${planillaInstance?.id}">
            Editar planilla
        </g:if>
        <g:else>
            Nueva Planilla
        </g:else>
    </title>


    <style type="text/css">
    .formato {
        font-weight: bolder;
    }

    select.label-important, textarea.label-important {
        background: none !important;
        color: #555 !important;
        text-shadow: none !important;
    }
    </style>
</head>

<body>

<g:if test="${suspensiones.size() != 0}">
    <div class="btn-toolbar" style="margin-bottom: 20px;">
        <div class="btn-group">
            <g:link action="list" id="${contrato.id}" class="btn btn-primary">
                <i class="fa fa-arrow-left"></i>
                Regresar
            </g:link>
        </div>
    </div>

    <div class="alert alert-danger" style="font-size: large; font-weight: bold;">
        La ejecucion de la obra está suspendida desde ${ini*.format("dd-MM-yyyy")}, no puede generar planillas.
    </div>
</g:if>
<g:else>
    <g:set var="planillaAnticipo" value="${Planilla.findByTipoPlanillaAndContrato(TipoPlanilla.findByCodigo('A'), contrato)}"/>
    <g:set var="periodosOk" value="${[]}"/>

    <g:if test="${planillaAnticipo}">
        <g:set var="periodosOk" value="${janus.ejecucion.Planilla.findAllByTipoPlanilla(TipoPlanilla.findByCodigo('A'))}"/>
    </g:if>

    <g:if test="${tipos.find { it.codigo == 'A' } || periodosOk.size() > 0}">
        <div class="btn-toolbar" style="margin-bottom: 20px;">
            <div class="btn-group">
                <g:link action="list" id="${contrato.id}" class="btn btn-primary">
                    <i class="fa fa-arrow-left"></i>
                    Cancelar
                </g:link>

                <g:if test="${(anticipoPagado && !liquidado) || (planillaInstance?.id && planillaInstance.fechaMemoSalidaPlanilla == null) || (tipos.find{it.codigo == 'A'} && planillaInstance?.fechaMemoSalidaPlanilla == null)}">
                    <a href="#" id="btnSave" class="btn btn-success">
                        <i class="fa fa-save"></i>
                        Guardar
                    </a>
                </g:if>
                <g:if test="${contrato.aplicaReajuste ==0}">
                    <a href="#" id="btnSave" class="btn btn-mean" style="margin-left: 300px;" >
                        <i class="fa fa-check"></i>
                        Este contrato no aplica Reajuste de Precios
                    </a>
                </g:if>
            </div>
        </div>

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

        <g:if test="${anticipoPagado || planillaInstance?.id ||(tipos.find{it.codigo == 'A'} && planillaInstance?.fechaMemoSalidaPlanilla == null)}">
            <g:if test="${!liquidado}">
                <g:form name="frmSave-Planilla" action="save">
                    <fieldset>
                        <g:hiddenField name="id" value="${planillaInstance?.id}"/>
                        <g:hiddenField id="contrato" name="contrato.id" value="${planillaInstance?.contrato?.id}"/>

                        <div class="form-group col-md-12">
                            <span class="grupo">
                                <label class="col-md-2 control-label text-info">
                                    Tipo de Planilla
                                </label>
                                <span class="col-md-3">
                                    <g:if test="${planillaInstance?.id}">
                                        <g:if test="${planillaInstance?.tipoPlanilla?.toString() != 'A'}">
                                            ${planillaInstance?.tipoPlanilla?.nombre} <span>Planillado del: ${planillaInstance?.fechaInicio?.format('dd-MM-yyyy')} Hasta: ${planillaInstance?.fechaFin?.format('dd-MM-yyyy')}</span>
                                        </g:if>
                                        <g:else>
                                            ${planillaInstance?.tipoPlanilla?.nombre}
                                        </g:else>
                                    </g:if>
                                    <g:else>
                                        <g:select id="tipoPlanilla" name="tipoPlanilla.id" from="${tipos}" optionKey="id"
                                                  optionValue="nombre" class="form-control required"  value="${planillaInstance?.tipoPlanilla?.id}"/>
                                        <p class="help-block ui-helper-hidden"></p>
                                    </g:else>
                                </span>
                            </span>

                            <g:if test="${!planillaInstance?.id && !(tipos.find { it.codigo == 'A' })}">
                                <span class="grupo">
                                    <div class="col-md-1"></div>
                                    <label class="col-md-2 control-label text-info formato periodo">
                                        Período
                                    </label>
                                    <span class="col-md-4 periodo">
                                        <g:select id="periodoPlanilla" name="periodoPlanilla" from="${periodos}"
                                                  optionKey="key" class="many-to-one form-control"
                                                  optionValue="value"/>
                                    </span>
                                </span>
                            </g:if>
                        </div>

                        <div class="form-group col-md-12" >
                            <g:if test="${planillaInstance?.id && planillaInstance?.tipoPlanilla?.codigo == "C"}">
                                <span class="grupo">
                                    <label class="col-md-2 control-label text-info formato hide planillaAsociada">
                                        Planilla Asociada
                                    </label>
                                    <span class="col-md-3 hide planillaAsociada">
                                        <g:select name="asociada" class="form-control" from="${planillas}" optionKey="id" style="width: 600px"
                                                  value="${planillaInstance?.padreCosto?.id}"  noSelection="['null': 'Sin planilla asociada']"/>
                                    </span>
                                </span>
                            </g:if>
                        </div>

                        <div class="form-group col-md-12">
                            <span class="grupo">
                                <label class="col-md-2 control-label text-info formato">
                                    Número planilla
                                </label>
                                <span class="col-md-3">
                                    <g:textField name="numero" maxlength="28" class="form-control required allCaps"
                                                 value="${fieldValue(bean: planillaInstance, field: 'numero')}"/>
                                </span>
                            </span>
                            <span class="grupo">
                                <div class="col-md-1"></div>
                                <label class="col-md-2 control-label text-info formato">
                                    Fiscalizador
                                </label>
                                <span class="col-md-4">
                                    ${contrato.fiscalizador?.titulo} ${contrato.fiscalizador?.nombre} ${contrato.fiscalizador?.apellido}
                                </span>
                            </span>
                        </div>

                        <div class="form-group col-md-12">
                            <span class="grupo">
                                <label class="col-md-2 control-label text-info formato">
                                    <g:if test="${tipos.find { it.codigo == 'A' }}">
                                        Memo de anticipo
                                    </g:if>
                                    <g:else>
                                        Oficio de entrada
                                    </g:else>
                                </label>
                                <span class="col-md-3">
                                    <g:textField name="oficioEntradaPlanilla" class="form-control required allCaps"
                                                 value="${planillaInstance.oficioEntradaPlanilla}" maxlength="40"/>

                                </span>
                            </span>
                            <span class="grupo">
                                <div class="col-md-1"></div>
                                <label class="col-md-2 control-label text-info formato">
                                    Fecha de
                                    <g:if test="${tipos.find { it.codigo == 'A' }}">
                                        memo de anticipo
                                    </g:if>
                                    <g:else>
                                        oficio de entrada
                                    </g:else>
                                </label>
                                <span class="col-md-3">
                                    <input aria-label="" name="fechaOficioEntradaPlanilla" id='fechaOficioEntradaPlanilla' type='text' class="form-control required" value="${planillaInstance?.fechaOficioEntradaPlanilla?.format("dd-MM-yyyy")}" />
                                </span>
                            </span>
                        </div>

                        <div class="form-group col-md-12">
                            <span class="grupo">
                                <label class="col-md-2 control-label text-info formato">
                                    Fecha de Aprobación
                                </label>
                                <span class="col-md-3">
                                    <input aria-label="" name="fechaIngreso" id='fechaIngreso' type='text' class="form-control required" value="${planillaInstance?.fechaIngreso?.format("dd-MM-yyyy")}" />
                                </span>
                            </span>
                            <span class="grupo">
                                <div class="col-md-1"></div>
                                <label class="col-md-2 control-label text-info formato">
                                    Fecha Presentacion
                                </label>
                                <span class="col-md-3">
                                    <input aria-label="" name="fechaPresentacion" id='fechaPresentacion' type='text' class="form-control required" value="${planillaInstance?.fechaPresentacion?.format("dd-MM-yyyy")}" />
                                </span>
                            </span>
                        </div>

                        <div class="form-group col-md-12">
                            <span class="grupo">
                                <label class="col-md-2 control-label text-info formato">
                                    Periodo para el reajuste
                                </label>
                                <span class="col-md-4">
                                    <g:select name="periodoIndices.id"
                                              from="${janus.ejecucion.PeriodosInec.list([sort: 'fechaFin', order: 'desc', max: 20])}"
                                              class="form-control" optionKey="id" style="width: 100%" value="${planillaInstance.periodoIndices?.id}"/>
                                </span>
                            </span>
                            <span class="grupo">
                                <g:if test="${!(esAnticipo) && planillaInstance?.tipoContrato != 'C' && hayCmpl}">

                                    <label class="col-md-2 control-label text-info formato">
                                        Generar planilla para el Complementario
                                    </label>
                                    <span class="col-md-3">
                                        <g:select name="complementario" from="${['S': 'Generar Planilla', 'E': 'No']}"
                                                  optionKey="key" optionValue="value" class="form-control text-info"
                                                  value="${planillaInstance?.tipoContrato}" />
                                    </span>
                                </g:if>
                            </span>
                        </div>

                        <g:if test="${!(esAnticipo || planillaInstance?.tipoPlanilla?.codigo == 'A')}">   %{-- no es anticipo--}%
                            <div class="form-group col-md-12">
                                <span class="grupo">
                                    <label class="col-md-2 control-label text-info formato">
                                        Fórmula Polinómica a utilizar
                                    </label>
                                    <span class="col-md-4">
                                        <g:select id="formulaPolinomicaReajuste" name="formulaPolinomicaReajuste.id" from="${formulas}" optionKey="id"
                                                  optionValue="descripcion"
                                                  class="form-control required"
                                                  value="${planillaInstance?.formulaPolinomicaReajuste?.id}"/>
                                    </span>
                                </span>
                            </div>

                            <div class="form-group col-md-12" id="divMultaDisp">
                                <span class="grupo">
                                    <label class="col-md-2 control-label text-info formato">
                                        Multa por no acatar las disposiciones del fiscalizador
                                    </label>
                                    <span class="col-md-2">
                                        <g:textField type="number" name="diasMultaDisposiciones"
                                                     class="form-control required digits"
                                                     value="${planillaInstance.diasMultaDisposiciones}" maxlength="3"/>
                                    </span>
                                    <div class="col-md-1">días</div>
                                </span>
                                <div class="col-md-1"> </div>
                                <span class="grupo">
                                    <label class="col-md-2 control-label text-info formato">
                                        Avance físico
                                    </label>
                                    <span class="col-md-2">
%{--                                        <g:field type="number" name="avanceFisico" class="form-control required number"--}%
%{--                                                 value="${planillaInstance.avanceFisico}" max="100"/>--}%
                                        <g:textField type="text" name="avanceFisico" class="form-control required"
                                                     value="${planillaInstance?.avanceFisico}" style="width: 100%" />
                                    </span>
                                    <div class="col-md-1">%</div>
                                </span>
                            </div>
                        </g:if>

                        <g:if test="${esAnticipo}">
                            <div class="form-group col-md-12">
                                <span class="grupo">
                                    <label class="col-md-2 control-label text-info formato">
                                        Valor
                                    </label>
                                    <span class="col-md-4" id="divAnticipo">

                                    </span>
                                </span>
                            </div>
                        </g:if>

                        <div class="form-group col-md-12">
                            <span class="grupo">
                                <label class="col-md-2 control-label text-info formato">
                                    Descripción
                                </label>
                                <span class="col-md-10" >
                                    <g:textArea name="descripcion" cols="40" rows="2" maxlength="254" class="form-control required"
                                                value="${planillaInstance?.descripcion}" style="resize: none;"/>
                                </span>
                            </span>
                        </div>

                        <g:if test="${!esAnticipo}">
                            <div class="form-group col-md-12" id="divMulta">
                                <span class="grupo">
                                    <label class="col-md-2 control-label text-info formato">
                                        Multa
                                    </label>
                                    <span class="col-md-6" >
                                        <g:textField type="text" name="descripcionMulta" class="form-control"
                                                     value="${planillaInstance?.descripcionMulta}" style="width: 100%"/>

                                    </span>
                                </span>
                                <span class="grupo">
                                    <label class="col-md-1 control-label text-info formato">
                                        Monto
                                    </label>
                                    <span class="col-md-2" >
                                        <g:textField type="text" name="multaEspecial" class="form-control"
                                                     value="${planillaInstance?.multaEspecial}" style="width: 100%"/>

                                    </span>
                                </span>
                            </div>
                        </g:if>

                        <div class="form-group col-md-12">
                            <span class="grupo">
                                <label class="col-md-2 control-label text-info formato">
                                    Observaciones
                                </label>
                                <span class="col-md-10" >
                                    <g:textArea name="observaciones" cols="40" rows="2" maxlength="127" class="form-control"
                                                value="${planillaInstance?.observaciones}" style="resize: none;"/>
                                </span>
                            </span>
                        </div>

                        <div class="form-group col-md-12" id="divNoPago">
                            <span class="grupo">
                                <label class="col-md-2 control-label text-info formato">
                                    Nota de descuento
                                </label>
                                <span class="col-md-6" >
                                    <g:textArea maxlength="255" name="noPago" class="form-control"
                                                value="${planillaInstance?.noPago}" style="resize: none;"/>
                                </span>
                            </span>
                            <span class="grupo">
                                <label class="col-md-1 control-label text-info formato">
                                    Valor
                                </label>
                                <span class="col-md-2" >
                                    <g:textField type="text" name="noPagoValor" value="${planillaInstance?.noPagoValor}" class="form-control" />
                                </span>
                            </span>
                        </div>

                    </fieldset>
                </g:form>
            </g:if>
            <g:else>
                <div class="alert alert-warning">
                    <h4>Alerta</h4>

                    anticipoPagado: ${anticipoPagado} id:${planillaInstance?.id} tipos:${tipos.find{it.codigo == 'A'}} fc:${planillaInstance?.fechaMemoSalidaPlanilla}
                    <p style="margin-top: 10px;">
                        <i class="icon-warning-sign icon-2x pull-left"></i>
                        Ya se ha efectuado la planilla de liquidación del reajuste, no puede crear nuevas planillas.
                    </p>
                </div>
            </g:else>
        </g:if>
        <g:else>
            <div class="alert alert-warning">
                <h4>Alerta</h4>
                <p style="margin-top: 10px;">
                    <i class="icon-warning-sign icon-2x pull-left"></i>
                    La planilla de anticipo no ha sido pagada. Por favor páguela para continuar.
                </p>
            </div>
        </g:else>
    </g:if>
    <g:else>
        <div class="alert alert-danger">
            <h3>Alerta: ha ocurrido un error</h3>
            <p>
                El contrato no posee los períodos necesarios para crear planillas. <br/>
                Posiblemente al generar la planilla de anticipo no se encontraron valores de índice para algunos rubros.<br/>
                Por favor revise y corrija esto para intentar nuevamente.<br/>
            </p>
            <g:link action="list" id="${contrato.id}" class="btn btn-danger">Regresar</g:link>
        </div>
    </g:else>

    <div class="alert alert-info">
        <h4> Si está ingresando una planilla de Reliquidación, se debe cumplir con las siguientes condiciones:<br/>
            <ul>
                <li>La fecha de ingreso debe ser mayor a la fecha de finalización de la planilla de liquidación</li>
                <li>La fecha de finalización de la planilla de reliquidación debe ser mayor a la fecha de ingreso de esta planilla</li>
            </ul>
        </h4>
    </div>

</g:else>

<script type="text/javascript">

    $('#fechaPresentacion,#fechaOficioEntradaPlanilla').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        minDate: new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0),
        maxDate: new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0),
        sideBySide: true,
        icons: {
        }
    });

    $('#fechaIngreso').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        minDate: new Date(${contrato.fechaSubscripcion.format('yyyy')},${contrato.fechaSubscripcion.format('MM').toInteger() - 1},${contrato.fechaSubscripcion.format('dd')},0,0,0,0),
        maxDate: new Date(${fechaMax.format('yyyy')},${fechaMax.format('MM').toInteger() - 1},${fechaMax.format('dd')},0,0,0,0),
        sideBySide: true,
        icons: {
        }
    }).on('dp.change', function(e){
        var minDate = new Date(e.date);
            $('#fechaPresentacion').data("DateTimePicker").date(moment(minDate).format('DD/MM/YYYY'));
    });

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    function validarNumDec(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 110 || ev.keyCode === 190 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#diasMultaDisposiciones").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();

        if (parseFloat(enteros) > 1000) {
            $(this).val(999)
        }
        if (parseFloat(enteros) <= 0) {
            $(this).val(0)
        }
    });

    $("#avanceFisico").keydown(function (ev) {
        return validarNumDec(ev);
    }).keyup(function () {
        var enteros = $(this).val();

        if (parseFloat(enteros) > 100) {
            $(this).val(100)
        }
        if (parseFloat(enteros) <= 0) {
            $(this).val(0)
        }
    });

    function checkPeriodo() {
        var tppl = $("#tipoPlanilla").val();
        var tp = "${planillaInstance?.tipoPlanilla?.id}";
        if(isNaN(tp)) {
            tp = 0
        }

        if (tppl === "3" || tppl === "9" || (tp === "3" || tp === "9")) { //avance
            $(".periodo,.presentacion,#divMultaDisp, #divMulta").show();
        } else {
            $("#divMultaDisp").addClass('hide');
            $("#divMulta").addClass('hide');
            if (tppl === "1" || tppl === "2") {
                $(".periodo").addClass('hide');
                $(".presentacion").addClass('hide');
            } else if (tppl === "5" || tppl === "6") {
                $(".periodo").addClass('hide');
                $(".presentacion").removeClass('hide');
            }
        }
    }

    function cargarAsociada () {
        var tppl = $("#tipoPlanilla").val();

        if(${planillaInstance?.id && planillaInstance?.tipoPlanilla?.codigo == 'C'}){
            $(".planillaAsociada").removeClass('hide');
        }else{
            if(tppl === '5'){
                $(".planillaAsociada").removeClass('hide');
            }else{
                $(".planillaAsociada").addClass('hide');
            }
        }
    }

    $(function () {
        checkPeriodo();
        cargarAsociada();

        $("#frmSave-Planilla").validate({
            errorClass     : "help-block",
            errorPlacement : function (error, element) {
                if (element.parent().hasClass("input-group")) {
                    error.insertAfter(element.parent());
                } else {
                    error.insertAfter(element);
                }
                element.parents(".grupo").addClass('has-error');
            },
            success        : function (label) {
                label.parents(".grupo").removeClass('has-error');
            }
        });

        $("#btnSave").click(function () {
            var d = cargarLoader("Cargando...");
            if ($("#frmSave-Planilla").valid()) {
                $("#frmSave-Planilla").submit();
            }else{
                d.modal("hide")
            }
        });

        $("#tipoPlanilla").change(function () {
            var tp = $(this).val();
            checkPeriodo();
            cargarAsociada();
            cargarAnticipo(tp)
        });

        function cargarAnticipo (tipo) {
            $.ajax({
                type:'POST',
                url:'${createLink(controller: 'planilla', action: 'anticipo_ajax')}',
                data:{
                    contrato: '${contrato?.id}',
                    tipo: tipo
                },
                success: function (msg){
                    $("#divAnticipo").html(msg)
                }
            });
        }

        if('${contrato?.id}'){
            var tppl = $("#tipoPlanilla").val();
            if(!tppl) {
                tppl = "${planillaInstance?.tipoPlanilla?.id}"
            }
            cargarAnticipo(tppl);
        }
    });

</script>

</body>
</html>