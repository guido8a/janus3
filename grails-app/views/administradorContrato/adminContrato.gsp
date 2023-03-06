
<%@ page import="janus.Departamento; janus.Contrato" %>
<fieldset>

    <div class="alert alert-error hide" id="divError">
    </div>

    <div class="row">
        <div class="col-md-2"><label> Personas </label></div>
        <div class="col-md-4">
            <g:select id="administrador" name="administrador.id" from="${personal}"
                      optionKey="id" class="many-to-one required form-control" optionValue="${{ it.apellido + ' ' + it.nombre }}"
                      noSelection="['null': 'Seleccione ...']" style="width:300px; margin-right: 20px;"/>
        </div>
    </div>
    <div class="row" style="margin-bottom: 5px">
        <div class="col-md-2"><label>Desde</label></div>
        <div class="col-md-3">
            <input aria-label="" name="desde" id='fechaAC' type='text' class="form-control" value="${new Date()?.format("dd-MM-yyyy")}" />
        </div>
        <div class="col-md-2">
            <a href="#" class="btn btn-success" id="btnAddAdmin" style=""><i class="fa fa-plus"></i> Agregar</a>
        </div>
    </div>

</fieldset>

<div id="tabla"></div>

<script type="text/javascript">

    $('#fechaAC').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    function loadTabla() {
        $("#tabla").html("");
        var contrato = '${contrato?.id}';
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'tabla')}",
            data    : {
                contrato : contrato
            },
            success : function (msg) {
                $("#tabla").html(msg);
            }
        });
    }
    $(function () {

        loadTabla();

        $("#btnAddAdmin").click(function () {
            var $admin = $("#administrador");
            var contrato = '${contrato?.id}';
            var admin = $admin.val();
            var desde = $("#fechaAC").val();

            $.ajax({
                type    : "POST",
                url     : "${createLink(action: 'addAdmin')}",
                data    : {
                    contrato : contrato,
                    admin    : admin,
                    desde    : desde
                },
                success : function (msg) {
                    var p = msg.split("_");
                    if (p[0] === "NO") {
                        bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + "<strong style='font-size: 14px'>" +  p[1] +  "</strong>");
                    } else {
                        loadTabla();
                    }
                }
            });
        });
    });

</script>