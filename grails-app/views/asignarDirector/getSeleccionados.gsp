<g:if test="${id != '-1'}">
    <div class="span1" style="font-weight: bold">Persona:</div>
    <g:select name="persona.id" class="persona form-control" from="${personas}" optionValue="${{it.nombre + ' ' + it.apellido}}" optionKey="id"
              style="width: 400px"/>
</g:if>

<script type="text/javascript">

    cargarMensaje();

    if($(".persona").val() != null){
        cargarFuncion();
    }else {
        $("#funcionPersona").html("");
    }

    $(".persona").change(function () {
        cargarFuncion();
    });

    function cargarFuncion () {
        var idPersona = $(".persona").val();
        $.ajax({
            type: "POST",
            url: "${g.createLink(action: 'obtenerFuncionDirector')}",
            data : { id: idPersona
            } ,
            success: function (msg) {
                $("#funcionPersona").html(msg);
            }
        });
    }

</script>