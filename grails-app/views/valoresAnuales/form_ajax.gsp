
<%@ page import="janus.ValoresAnuales" %>

<div id="create-ValoresAnuales" class="span" role="main">
    <g:form class="form-horizontal" name="frmSave-ValoresAnuales" action="save">
        <g:hiddenField name="id" value="${valoresAnualesInstance?.id}"/>

        <div class="form-group ${hasErrors(bean: valoresAnualesInstance, field: 'anioNuevo', 'error')} ">
            <span class="grupo">
                <label for="anioNuevo" class="col-md-2 control-label text-info">
                    Año
                </label>
                <span class="col-md-3">
                    <g:select name="anioNuevo" from="${janus.pac.Anio.list([sort: 'anio'])}"  optionValue="anio" optionKey="id"  class="form-control required" value="${valoresAnualesInstance?.anioNuevo?.id}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: valoresAnualesInstance, field: 'costoDiesel', 'error')} ">
            <span class="grupo">
                <label for="costoDiesel" class="col-md-2 control-label text-info">
                    Costo Diesel
                </label>
                <span class="col-md-3">
                    <g:textField name="costoDiesel" type="number" class="form-control required" value="${valoresAnualesInstance?.costoDiesel}"/> Galón
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: valoresAnualesInstance, field: 'costoGrasa', 'error')} ">
            <span class="grupo">
                <label for="costoGrasa" class="col-md-2 control-label text-info">
                    Costo Grasa
                </label>
                <span class="col-md-3">
                    <g:textField name="costoGrasa" type="number" class="form-control required" value="${valoresAnualesInstance?.costoGrasa}"/> Kilo
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: valoresAnualesInstance, field: 'costoLubricante', 'error')} ">
            <span class="grupo">
                <label for="costoLubricante" class="col-md-2 control-label text-info">
                    Costo Lubricante
                </label>
                <span class="col-md-3">
                    <g:textField name="costoLubricante" type="number" class="form-control required" value="${valoresAnualesInstance?.costoLubricante}"/> Galón
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: valoresAnualesInstance, field: 'factorCostoRepuestosReparaciones', 'error')} ">
            <span class="grupo">
                <label for="factorCostoRepuestosReparaciones" class="col-md-2 control-label text-info">
                    Factor CRR
                </label>
                <span class="col-md-3">
                    <g:textField name="factorCostoRepuestosReparaciones" type="number" class="form-control required" value="${valoresAnualesInstance?.factorCostoRepuestosReparaciones}"/>
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: valoresAnualesInstance, field: 'sueldoBasicoUnificado', 'error')} ">
            <span class="grupo">
                <label for="sueldoBasicoUnificado" class="col-md-2 control-label text-info">
                    Sueldo Básico Unificado
                </label>
                <span class="col-md-3">
                    <g:textField name="sueldoBasicoUnificado" type="number" class="form-control required" value="${valoresAnualesInstance?.sueldoBasicoUnificado}"/> Dólares
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>

        <div class="form-group ${hasErrors(bean: valoresAnualesInstance, field: 'tasaInteresAnual', 'error')} ">
            <span class="grupo">
                <label for="tasaInteresAnual" class="col-md-2 control-label text-info">
                    Tasa Interés Anual
                </label>
                <span class="col-md-3">
                    <g:textField name="tasaInteresAnual" type="number" class="form-control required" value="${valoresAnualesInstance?.tasaInteresAnual}"/> %
                    <p class="help-block ui-helper-hidden"></p>
                </span>
            </span>
        </div>
                
%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Año--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                --}%%{--<g:field type="number" name="anio" class=" required" value="${fieldValue(bean: valoresAnualesInstance, field: 'anio')}" style="width:60px;" />--}%
%{--                <g:if test="${valoresAnualesInstance?.id}">--}%
%{--                    <g:textField type="number" name="anio" class=" required" value="${valoresAnualesInstance?.anio}" style="width: 60px" readonly="readonly"/>--}%
%{--                    <span class="mandatory">*</span>--}%
%{--                    <p class="help-block ui-helper-hidden"></p>--}%
%{--                </g:if>--}%
%{--                <g:else>--}%
%{--                    <g:textField type="number" name="anio" class=" required" value="${valoresAnualesInstance?.anio}" style="width: 60px"/>--}%
%{--                    <span class="mandatory">*</span>--}%
%{--                    <p class="help-block ui-helper-hidden"></p>--}%
%{--                </g:else>--}%

%{--            </div>--}%
%{--        </div>--}%
                
%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Costo Diesel--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                --}%%{--<g:field type="number" name="costoDiesel" class=" required" value="${fieldValue(bean: valoresAnualesInstance, field: 'costoDiesel')}" style="width:60px;"/>--}%
%{--                <g:textField type="number" name="costoDiesel" class=" required" value="${fieldValue(bean: valoresAnualesInstance, field: 'costoDiesel')}" style="width:60px;"/>--}%
%{--                <span class="mandatory">*</span> Galón--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%
                
%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Costo Grasa--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textField type="number" name="costoGrasa" class=" required" value="${fieldValue(bean: valoresAnualesInstance, field: 'costoGrasa')}" style="width:60px;"/>--}%
%{--                <span class="mandatory">*</span> Kilo--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%
                
%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Costo Lubricante--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textField type="number" name="costoLubricante" class=" required" value="${fieldValue(bean: valoresAnualesInstance, field: 'costoLubricante')}" style="width:60px;"/>--}%
%{--                <span class="mandatory">*</span> Galón--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%
                
%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Factor CRR--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textField type="number" name="factorCostoRepuestosReparaciones" class=" required" value="${fieldValue(bean: valoresAnualesInstance,--}%
%{--                        field: 'factorCostoRepuestosReparaciones')}" style="width:60px;"/>--}%
%{--                <span class="mandatory">*</span>--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%
                
%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Sueldo Básico Unificado--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textField type="number" name="sueldoBasicoUnificado" class=" required" value="${fieldValue(bean: valoresAnualesInstance,--}%
%{--                        field: 'sueldoBasicoUnificado')}" style="width:60px;"/>--}%
%{--                <span class="mandatory">*</span> Dólares--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%
                
%{--        <div class="control-group">--}%
%{--            <div>--}%
%{--                <span class="control-label label label-inverse">--}%
%{--                    Tasa Interés Anual--}%
%{--                </span>--}%
%{--            </div>--}%

%{--            <div class="controls">--}%
%{--                <g:textField type="number" name="tasaInteresAnual" class=" required" value="${fieldValue(bean: valoresAnualesInstance,--}%
%{--                        field: 'tasaInteresAnual')}" style="width:60px;"/>--}%
%{--                <span class="mandatory">*</span> %. Ej: 13--}%
%{--                <p class="help-block ui-helper-hidden"></p>--}%
%{--            </div>--}%
%{--        </div>--}%

        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Seguro
                </span>
            </div>

            <div class="controls">
                <g:textField type="number" name="seguro" class=" required" value="${fieldValue(bean: valoresAnualesInstance,
                        field: 'seguro')}" style="width:60px;"/>
                <span class="mandatory">*</span> Prima anual. Ej: 3% ingrese 3.00
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>


        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Inflación
                </span>
            </div>

            <div class="controls">
                <g:textField type="number" name="inflacion" class=" required" value="${fieldValue(bean: valoresAnualesInstance,
                        field: 'inflacion')}" style="width:60px;"/>
                <span class="mandatory">*</span> % Anual
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

                
    </g:form>

<script type="text/javascript">
    $("#frmSave-ValoresAnuales").validate({
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
    $(".form-control").keydown(function (ev) {
        if (ev.keyCode === 13) {
            submitFormVA();
            return false;
        }
        return true;
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
                (ev.keyCode == 190 || ev.keyCode == 110) ||
                ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
                ev.keyCode == 37 || ev.keyCode == 39);
    }

    function validarNumSin(ev) {
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
                ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
                ev.keyCode == 37 || ev.keyCode == 39);
    }


    $("#anio").keydown(function (ev){

        return validarNumSin(ev)
    })

    $("#costoDiesel").keydown(function (ev){

        return validarNum(ev)
    })

    $("#costoGrasa").keydown(function (ev){

        return validarNum(ev)
    })

    $("#costoLubricante").keydown(function (ev){

        return validarNum(ev)
    })

    $("#factorCostoRepuestosReparaciones").keydown(function (ev){

        return validarNum(ev)
    })

    $("#sueldoBasicoUnificado").keydown(function (ev){

        return validarNum(ev)
    })

    $("#tasaInteresAnual").keydown(function (ev){

        return validarNum(ev)
    })

    $("#seguro").keydown(function (ev){

        return validarNum(ev)
    })

    $("#inflacion").keydown(function (ev){

        return validarNum(ev)
    })


</script>
