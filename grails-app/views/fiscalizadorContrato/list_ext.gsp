<%@ page import="seguridad.Persona; janus.Departamento" %>

<div class="container">

    <div class="col-md-12">
        <div class="col-md-1">
            Fizcalizador
        </div>
        <div class="col-md-4">
            <g:select id="fiscalizador" name="fiscalizador.id" from="${seguridad.Persona.findAllByActivoAndDepartamentoInList(1,
                    janus.Departamento.findAllByCodigoInList(['FISC', 'DFZLAB', 'DFZCCO', 'DGFDIA', 'DGFDV', 'DGRPRS']), [sort: 'apellido'])}"
                      optionKey="id" class="many-to-one form-control required" optionValue="${{ it.apellido + ' ' + it.nombre }}"
                      noSelection="['null': 'Seleccione ...']" style="width:300px; margin-right: 20px;"/>
        </div>
    </div>
    <div class="col-md-12" style="margin-top: 5px">
        <div class="col-md-1">
            Desde
        </div>
        <div class="col-md-3">
            <input aria-label="" name="desde" id='desde' type='text' class="form-control required"  value="${new Date().format("dd-MM-yyyy")}" />
        </div>
        <div class="col-md-1">
            <a href="#" class="btn btn-success" id="btnAddFisc" style="margin-left: 10px;"><i class="fa fa-plus"></i> Agregar</a>
        </div>
    </div>
</div>


<div id="tabla" style="margin-top: 5px"></div>

<script type="text/javascript">

    $('#desde').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    function loadTabla() {
        $("#tabla").html("");
        var contrato = "${contrato}";
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

        $("#btnAddFisc").click(function () {
            var desde = $("#desde").val();
            var fiscalizador = $("#fiscalizador option:selected").val();

            if(fiscalizador !== 'null'){
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action: 'addFisc')}",
                    data    : {
                        contrato : "${contrato}",
                        fisc     : fiscalizador,
                        desde    : desde
                    },
                    success : function (msg) {
                        var p = msg.split("_");
                        if (p[0] === "NO") {
                            log(p[1], "danger");
                        } else {
                            loadTabla();
                        }
                    }
                });
            }else{
                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un fiscalizador" + '</strong>');
                return false;
            }
        });
    });

</script>