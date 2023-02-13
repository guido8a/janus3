<label>Grupo</label>
<g:select id="selGrupo" name="rubro.suggrupoItem.id" from="${grupos}"
          class="col-md-12" optionKey="id" optionValue="descripcion" value="${rubro?. departamento?.subgrupo?.id}" noSelection="['': '--Seleccione--']"/>

<script type="text/javascript">

    cargarSubgrupo($("#selGrupo option:selected").val());

    $("#selGrupo").change(function () {
        var grupo = $("#selGrupo option:selected").val();
        cargarSubgrupo(grupo);
    });

    function cargarSubgrupo(grupo){
        $.ajax({
            type    : "POST",
            url     : "${createLink(action:'subgruposPorGrupo')}",
            data    : {
                id : grupo,
                rubro: '${rubro?.id}'
            },
            success : function (msg) {
                $("#seleccionarSubgrupo").html(msg);
            }
        });
    }

</script>