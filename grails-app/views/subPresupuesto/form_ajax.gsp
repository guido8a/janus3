<%@ page import="janus.SubPresupuesto" %>

<div id="create-SubPresupuesto" class="span" role="main">
<div class="col-md-12 alert " role="status" style="background: rgba(255, 0, 0, 0.42);color: black;font-weight:
  bold;font-size: 12px">
    Antes de crear un subpresupuesto asegúrese de que no exista en ningún grupo. Recuerde que la lista de
    subpresupuestos depende de la opción seleccionada en "Tipo de obra"
</div>
<g:form class="form-horizontal" name="frmSave-SubPresupuesto" action="save">
    <g:hiddenField name="id" value="${subPresupuestoInstance?.id}"/>
    <g:hiddenField name="volob" value="0"/>

    <div class="col-md-12 row control-group" >
            <div class="col-md-3 control-label">
                Grupo
            </div>

        <div class="controls">

            <g:select name="grupo.id" from="${grupo}" optionKey="id" optionValue="descripcion"/>
            %{--<g:select name="grupo.id" from="${janus.Grupo.findByDireccion(obra.departamento.direccion)}" optionKey="id" optionValue="descripcion"/>--}%

           <p class="help-block ui-helper-hidden"></p>
        </div>
    </div>

    <div class="col-md-12 row control-group">
            <div class="col-md-3 control-label">
                Descripción
            </div>

            <g:textArea name="descripcion" maxlength="127" class="required input-small col-md-8 required allCaps"
                        value="${subPresupuestoInstance?.descripcion}" style="resize: none" />
            <span class="required">*</span>

            <p class="help-block ui-helper-hidden"></p>
    </div>

</g:form>

<script type="text/javascript">
    $(".allCaps").keyup(function () {
        this.value = this.value.toUpperCase();
    });

    $("#frmSave-SubPresupuesto").validate({
        errorPlacement : function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success        : function (label) {
            label.parent().hide();
        },
        errorClass     : "label label-important",
        submitHandler  : function (form) {
            $(".btn-success").replaceWith(spinner);
            form.submit();
        }
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode == 13) {
            submitForm($(".btn-success"));
        }
    });
</script>
