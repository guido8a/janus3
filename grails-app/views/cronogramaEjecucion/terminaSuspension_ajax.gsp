<g:form class="form-horizontal" name="frmSave-terminaSuspension" >
    <div class="alert alert-danger">
        <h4>Atención</h4>
        <i class="icon-info-sign icon-2x pull-left"></i>
        Una vez terminada la suspensión no se puede deshacer.
        <br/>
        ${raw(suspension)}
    </div>

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Fecha de fin--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <elm:datepicker name="fcfn"  minDate="new Date(${min})"  class="required dateEC" onClose="updateDias"/>--}%
%{--            <span class="mandatory">*</span>--}%
%{--            <span style="margin-left: 20px">Día en el que se reinicia la obra</span>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

    <div class="form-group">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
                Fecha de reinicio de la obra
            </label>
            <span class="col-md-3">
                <input aria-label="" name="fcfn" id='fcfn' type='text' class="form-control required dateEC" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
            <span class="col-md-6 text-info"  style="font-size: 14px; font-weight: bold; margin-left: -20px">
                Día en el que se reinicia la obra
            </span>
        </span>
    </div>



    <div class="form-group">
        <span class="grupo">
            <label class="col-md-3 control-label text-info">
                Observaciones
            </label>
            <span class="col-md-8">
                <g:textField name="observaciones" class="form-control"/>
            </span>
        </span>
    </div>

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Observaciones--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="observaciones" class="col-md-12"/>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

</g:form>

<script type="text/javascript">
    // $("#frmSave-terminaSuspension").validate();

    $('#fcfn').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        minDate: new Date(${min}),
        icons: {
        }
    });



    // $(".datepicker").keydown(function () {
    //     return false;
    // });
</script>