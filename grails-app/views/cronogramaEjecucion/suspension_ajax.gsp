<style type="text/css">
.fecha {
    color: #0c4c85;
    font-weight: bold;
    border-color: #0a6aa1;
}
</style>

<g:form class="form-horizontal" name="frmSave-suspension" action="ampliacion">
    <div class="col-md-12 alert alert-danger" style="display: inline-block">
        <i class="fa fa-exclamation-triangle text-danger fa-3x"></i> <h4 style="float: right">Atención: Una vez hecha la suspensión no se puede deshacer.</h4>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
                Fecha de inicio
            </label>
            <span class="col-md-3">
                <input aria-label="" name="ini" id='ini' type='text' class="form-control required dateEC" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
            <span class="col-md-6">
                Día en el que se inicia la suspensión
            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
                Fecha de reinicio de la obra (opcional)
            </label>
            <span class="col-md-3">
                <input aria-label="" name="fin" id='fin' type='text' class="form-control fecha" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
            <span class="col-md-6, text-info" style="font-size: 14px; font-weight: bold;">
                Fecha en el que se reinicia la obra
            </span>
        </span>
    </div>

    <div class="form-group" style="margin-top: 10px">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
                Días de suspensión
            </label>
            <span class="col-md-2" id="diasSuspension">

            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
                Memorando No.
            </label>
            <span class="col-md-4">
                <g:textField name="memo" class="form-control required allCaps"/>
            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
                Observaciones
            </label>
            <span class="col-md-8">
                <g:textField name="observaciones" class="required form-control"/>
            </span>
        </span>
    </div>





%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Fecha de inicio--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <elm:datepicker name="ini" minDate="new Date(${min})" maxDate="new Date(${max})" onClose="updateDias" class="required dateEC"/>--}%
%{--            <span class="mandatory">*</span>--}%
%{--            <span style="margin-left: 12px">Dia en el que se inicia la suspensión</span>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Fecha de fin (opcional)--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <elm:datepicker name="fin" class="dateEC" onClose="updateDias"/>--}%
%{--            <span style="margin-left: 20px">Dia en el que se reinicia la obra</span>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Días de suspensión--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <span id="diasSuspension">--}%

%{--            </span>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Memorando No.--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="memo" class="required allCaps"/>--}%
%{--            <span class="mandatory">*</span>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Motivo--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textArea name="motivo" class="required span6" maxlength="255"  style="height: 65px; width: 750px; resize: none"/>--}%
%{--            <span class="mandatory">*</span>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Observaciones--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="observaciones" class="required span8"/>--}%
%{--            <span class="mandatory">*</span>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

</g:form>

<script type="text/javascript">

    $('#ini').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        minDate: new Date(${min}),
        maxDate: new Date(${max}),
        icons: {
        }
    }).on('dp.change', function(e){
        updateDias();
    });

    $('#fin').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    }).on('dp.change', function(e){
        updateDias();
    });

    function updateDias() {
        var ini = $("#ini").val();
        var fin = $("#fin").val();

        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'cronogramaEjecucion', action: 'calcularDias_ajax')}',
            data:{
                inicio: ini,
                fin: fin
            },
            success: function (msg){
                $("#diasSuspension").text(msg + " día" + (msg === 1 ? "" : "s"));
            }
        });

    }


    $("#frmSave-suspension").validate({
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


    // $("#frmSave-suspension").validate();
    //
    // $(".datepicker").keydown(function () {
    //     return false;
    // });

</script>