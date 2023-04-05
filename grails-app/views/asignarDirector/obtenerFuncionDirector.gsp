
<g:each in="${rol}" var="r" status="i" >
    <tr data-id="${r?.funcionId}" data-valor="${r?.funcion?.descripcion}">
        <td style="width: 50px">${i+1}</td>
        <td style="width: 350px"> ${r?.funcion?.descripcion}</td>
        <td style="width: 20px"> <a href='#' class='btn btn-danger btnBorrar btn-xs' data-id="${r.id}"><i class='fa fa-trash'></i></a></td>
    </tr>
</g:each>

<script type="text/javascript">

    $(".btnBorrar").click(function () {
        var id = $(this).data("id");
        deleteRow(id)
    });

    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "<strong>Eliminar</strong> función",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i>" +
                "<p> ¿Está seguro que desea eliminar la función de la persona seleccionada?.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash'></i> Eliminar",
                    className : "btn-danger",
                    callback  : function () {
                        var ad = cargarLoader("Eliminando");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'asignarDirector', action:'delete')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                ad.modal('hide');
                                var parts = msg.split("_");
                                if (parts[0] === "ok") {
                                    log(parts[1], "success");
                                    cargarFuncion();
                                    cargarMensaje();
                                }else{
                                    log(parts[1], "error");
                                }
                            }
                        });
                    }
                }
            }
        });
    }

</script>
