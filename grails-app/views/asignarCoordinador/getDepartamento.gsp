<g:if test="${id != '-1'}">
    <div class="span1" style="font-weight: bold; margin-left: -1px">Departamento:</div>
    <g:select name="departamento.id" id="departamento" class="departamento form-control" from="${departamento}" optionValue="descripcion" optionKey="id"
              style="width: 400px;"/>

    <div class="col-md-6" style="margin-top: 5px" id="personasSel"></div>
</g:if>

<script type="text/javascript">
    cargarPersonas();
    cargarMensaje();

    function cargarPersonas() {
        var idDep = $("#departamento").val();
        $.ajax({
            type: "POST",
            url: "${g.createLink(controller: 'asignarCoordinador', action:'getPersonas')}",
            data: {
                id: idDep
            },
            success: function (msg) {
                $("#personasSel").html(msg);
            }
        });
    }

    $("#departamento").change(function () {
        var id = $(this).val();
        if (id !== '-1') {
            cargarPersonas();
            cargarMensaje()
        }
    });
</script>