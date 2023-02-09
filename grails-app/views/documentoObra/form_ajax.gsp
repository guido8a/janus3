<%@ page import="janus.pac.DocumentoObra" %>

<div id="create-DocumentoObra">
    <g:uploadForm name="frmSave-DocumentoObra" action="save">
        <g:hiddenField name="id" value="${documentoObraInstance?.id}"/>
        <g:hiddenField name="obra.id" value="${obra.id}"/>

        <div class="row" style="width: 100%">
            <div class="col-md-3">
                    Archivo
            </div>

            <div class="col-md-9 controls" >
                <input type="file" id="archivo" name="archivo" style="height: 32px; margin-top: -5px"/>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
                <div class="col-md-3">
                    Nombre
                </div>

            <div class="col-md-9 controls">
                <g:textArea name="nombre" cols="60" rows="1" maxlength="255" class="" value="${documentoObraInstance?.nombre}"
                style="height:25px; width: 300px;"/>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
                <div class="col-md-3">
                    Resumen del contenido
                </div>

            <div class="col-md-9 controls">
                <g:textArea name="resumen" cols="40" rows="3" maxlength="1024" class="" value="${documentoObraInstance?.resumen}"
                            style="height:60px; width: 300px;"/>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
                <div class="col-md-3">
                    Descripción del documento
                </div>

            <div class="col-md-9 controls">
                <g:textField name="descripcion" maxlength="63" style="width: 300px" value="${documentoObraInstance?.descripcion}"/>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

        <div class="row">
                <div class="col-md-3">
                    Palabras Clave
                </div>

            <div class="col-md-9 controls">
                <g:textField name="palabrasClave" maxlength="63" value="${documentoObraInstance?.palabrasClave}"
                style="width: 300px"/>
                <p class="help-block ui-helper-hidden"></p>
            </div>
        </div>

    </g:uploadForm>
</div>

<script type="text/javascript">
    $("#frmSave-DocumentoObra").validate({
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
