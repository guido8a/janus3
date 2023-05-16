<%@ page import="janus.ClaseObra" %>

<div id="create-claseObraInstance" class="span" role="main">
<g:form class="form-horizontal" name="frmSave-claseObraInstance" action="save_ext">
    <g:hiddenField name="id" value="${claseObraInstance?.id}"/>
    <g:hiddenField name="grupo" value="${grupo}"/>


    <div class="form-group ${hasErrors(bean: claseObraInstance, field: 'descripcion', 'error')} ">
        <span class="grupo">
            <label for="descripcion" class="col-md-2 control-label text-info">
                Descripción
            </label>
            <span class="col-md-6">
                <g:textField name="descripcion" maxlength="63" class="form-control allCaps required" value="${claseObraInstance?.descripcion}" />
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>

    <div class="form-group ${hasErrors(bean: claseObraInstance, field: 'grupo', 'error')} ">
        <span class="grupo">
            <label for="grupo" class="col-md-2 control-label text-info">
                Grupo
            </label>
            <span class="col-md-6">
                <g:select id="grupo" name="grupo.id" from="${janus.Grupo.list()}" optionKey="id" optionValue="descripcion" class="form-control" value="${claseObraInstance?.grupo?.id}"/>
                <p class="help-block ui-helper-hidden"></p>
            </span>
        </span>
    </div>


%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Descripción--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:textField name="descripcion" maxlength="63" class=" required" value="${claseObraInstance?.descripcion}"/>--}%
%{--            <span class="mandatory">*</span>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

%{--    <div class="control-group">--}%
%{--        <div>--}%
%{--            <span class="control-label label label-inverse">--}%
%{--                Grupo--}%
%{--            </span>--}%
%{--        </div>--}%

%{--        <div class="controls">--}%
%{--            <g:select id="grupo" name="grupo.id" from="${janus.Grupo.list()}" optionKey="id" class="many-to-one "--}%
%{--                      value="${claseObraInstance?.grupo?.id}"/>--}%

%{--            <p class="help-block ui-helper-hidden"></p>--}%
%{--        </div>--}%
%{--    </div>--}%

</g:form>

<script type="text/javascript">

    $("#frmSave-claseObraInstance").validate({
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

    $("input").keyup(function (ev) {
        if (ev.keyCode === 13) {
            submitForm($(".btn-success"));
        }
    });

</script>
