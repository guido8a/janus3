<div class="row-fluid"  style="width: 99.7%;height: 500px;overflow-y: auto;float: right; margin-top: -20px">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:each in="${periodosInecInstanceList}" status="i" var="periodosInecInstance">
            <tr>
                <td style="width: 20%;">${fieldValue(bean: periodosInecInstance, field: "descripcion")}</td>
                <td style="width: 20%;"><g:formatDate date="${periodosInecInstance.fechaInicio}" format="dd-MM-yyyy" /></td>
                <td style="width: 20%;"><g:formatDate date="${periodosInecInstance.fechaFin}" format="dd-MM-yyyy"/></td>
                <td style="text-align: center; width: 20%">${periodosInecInstance?.periodoCerrado == 'N' ? 'NO' : 'SI'}</td>
                <td style="text-align: center; width: 20%;">
%{--                    <a class="btn btn-xs btn-show btn-info" href="#" rel="tooltip" title="Ver" data-id="${periodosInecInstance.id}">--}%
%{--                        <i class="fa fa-search"></i>--}%
%{--                    </a>--}%
                    <a class="btn btn-xs btn-edit btn-success" href="#" rel="tooltip" title="Editar" data-id="${periodosInecInstance.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-xs btn-delete btn-danger" href="#" rel="tooltip" title="Eliminar" data-id="${periodosInecInstance.id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btn-edit").click(function () {
        var id = $(this).data("id");
        createEditRowPI(id);
    }); //click btn edit



    $(".btn-delete").click(function () {
        var id = $(this).data("id");
        deleteRow(id);
    });

    function deleteRow(id) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar este registro? Esta acción no se puede deshacer.</p>",
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
                        var v = cargarLoader("Eliminando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(action:'delete')}',
                            data    : {
                                id : id
                            },
                            success : function (msg) {
                                v.modal("hide");
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1],"success");
                                    cargarTablaPeriodos();
                                }else{
                                    log(parts[1],"error")
                                }
                            }
                        });
                    }
                }
            }
        });
    }


</script>