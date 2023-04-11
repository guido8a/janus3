<g:form class="form-horizontal" name="frmPass-Oferente" action="savePass">
    <g:hiddenField name="id" value="${usroInstance?.id}"/>

    <div class="col-md-12">
        <span class="grupo">
            <label class="col-md-3 control-label">
                Usuario
            </label>

            <span class="col-md-6" style="color: #0c6dc4">
                ${usroInstance.nombre} ${usroInstance.apellido} (${usroInstance.login})
            </span>
        </span>
    </div>

    <div class="form-group keeptogether">
        <div class="col-md-6">
            <span class="grupo">
                <span class="col-md-12">
                    <label for="password" class="control-label">
                        Nuevo password
                    </label>
                    <g:passwordField name="password" maxlength="63" class="form-control required"/>
                </span>
            </span>
        </div>

        <div class="col-md-6">
            <span class="grupo">
                <span class="col-md-12">
                    <label for="passwordVerif" class="control-label">
                        Verificar password
                    </label>

                    <g:passwordField name="passwordVerif" equalTo="#password" maxlength="63" class="form-control required" />
                </span>
            </span>
        </div>
    </div>

</g:form>

<script type="text/javascript">
    $("#frmSave-Oferente").validate({
        errorClass    : "help-block",
        errorPlacement: function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success       : function (label) {
            label.parents(".grupo").removeClass('has-error');
            label.remove();
        },
        rules          : {
            password          : {
                required : function () {
                    return $.trim($("#autorizacionAct").val()) === ""
                }
            },
            passwordVerif     : {
                required : function () {
                    return $.trim($("#autorizacionAct").val()) === ""
                }
            }
        },
        messages       : {
            passwordVerif     : {
                remote : "El password no coincide"
            }
        }
    });


</script>
