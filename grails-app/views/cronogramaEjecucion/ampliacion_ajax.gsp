<g:form class="form-horizontal" name="frmSave-ampliacion" action="ampliacion">
    <div class="col-md-12 alert alert-danger">
                <i class="fa fa-exclamation-triangle text-danger fa-3x"></i> <h4>Atención: Una vez hecha la ampliación no se puede deshacer.</h4>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label for="dias" class="col-md-2 control-label text-info">
                Días de ampliación
            </label>
            <span class="col-md-2">
                <g:textField name="dias" class="form-control required digits" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label for="memo" class="col-md-2 control-label text-info">
                Memo N.
            </label>
            <span class="col-md-4">
                <g:textField name="memo" class="form-control required allCaps" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label for="motivo" class="col-md-2 control-label text-info">
                Motivo
            </label>
            <span class="col-md-7">
                <g:textField name="motivo" class="form-control required" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group">
        <span class="grupo">
            <label for="observaciones" class="col-md-2 control-label text-info">
                Observaciones
            </label>
            <span class="col-md-7">
                <g:textField name="observaciones" class="form-control" />
            </span>
        </span>
    </div>



%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Días de ampliación--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="dias" class="required digits" style="width: 100px;"/>--}%
%{--            <span class="mandatory">*</span>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Memo N.--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="memo" class="required allCaps" style="width: 240px;"/>--}%
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
%{--            <g:textField name="motivo" class="required" style="width: 500px;"/>--}%
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
%{--            <g:textField name="observaciones" style="width: 500px;"/>--}%
%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

</g:form>

<script type="text/javascript">
    $("#frmSave-ampliacion").validate({
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

    $("#dias").keydown(function (ev) {
        return validarNum(ev);
    });

</script>