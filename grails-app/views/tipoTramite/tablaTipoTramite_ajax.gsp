

<g:each in="${departamentos}" var="departamento">
    <tr>
        <td>${departamento?.rolTramite?.descripcion}</td>
        <td>${departamento?.departamento?.descripcion}</td>
        <td>
            <a href="#" class="btn btn-danger btn-xs btnBorrar" data-id="${departamento?.id}">
                <i class="fa fa-trash"></i>
            </a>
        </td>
    </tr>
</g:each>


<script type="text/javascript">

    $(".btnBorrar").click(function (){
        var id = $(this).data("id");
        $.ajax({
            type: 'POST',
            url: '${createLink(action: 'borrarDepartamentoTramite_ajax')}',
            data:{
                id: id
            },
            success: function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1],"success");
                    cargarTablaDepartamentos('${tipoTramite?.id}')
                }else{
                    log(parts[1], "error")
                }
            }
        })
    })

</script>