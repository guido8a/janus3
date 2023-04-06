<div class="span1" style="font-weight: bold; margin-left: -1px">Persona:</div>
<g:select name="persona.id" class="persona form-control" id="persona" from="${personas}" optionValue="${{it.nombre + ' ' + it.apellido}}" optionKey="id"
          style="width: 400px; margin-left: -15px"/>

<script type="text/javascript">

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
            url: "${g.createLink(action: 'obtenerFuncionCoor')}",
            data : {
                id: idPersona
            } ,
            success: function (msg) {

                $("#funcionPersona").html(msg);
            }
        });
    }

</script>