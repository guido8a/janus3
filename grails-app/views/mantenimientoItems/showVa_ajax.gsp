<fieldset class="borde">
    <legend>Valores del VAE para: ${item.nombre} (${item.unidad?.codigo?.trim()}) </legend>
</fieldset>

<div style="height: 35px; width: 100%; margin-top: 20px;">
    <div class="btn-group pull-left">
        <a href="#" class="btn btn-success" id="btnNew">
            <i class="fa fa-file"></i>
            Nuevo Valor del VAE
        </a>
    </div>
</div>

<div id="divTabla" style="height: 400px; width: 100%; overflow-x: hidden; overflow-y: auto;">
    <table class="table table-striped table-bordered table-hover table-condensed" id="tablaPrecios">
        <thead>
        <tr>
            <th>Fecha</th>
            <th class="precio">Porcentaje</th>
            <th class="delete"></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${vaeItems}" var="vae" status="i">
            <tr>
                <td>
                    <g:formatDate date="${vae.fecha}" format="dd-MM-yyyy"/>
                </td>
                <td class="precio textRight ${vae.registrado != 'R' ? 'editable' : ''}" data-original="${vae.porcentaje}" data-valor="${vae.porcentaje}" id="${vae.id}">
                    <g:formatNumber number="${vae.porcentaje}" maxFractionDigits="2" minFractionDigits="2" format="#,##0" locale='ec'/>
                </td>
                <td>
                    <a href="#" class="btn btn-info btn-xs btnEditar" rel="tooltip" title="Editar vae" data-id="${vae.id}" data-item="${vae?.item?.id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <g:if test="${vae.registrado != 'R'}">
                        <a href="#" class="btn btn-danger btn-xs btnDelete" rel="tooltip" title="Eliminar" data-id="${vae.id}">
                            <i class="fa fa-trash"></i>
                        </a>
                    </g:if>
                    <g:else>
                        <a href="#" class="btn btn-danger btn-xs btnDeleteReg" rel="tooltip" title="Eliminar" data-id="${vae.id}">
                            <i class="fa fa-trash"></i>
                        </a>
                    </g:else>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        createEditRow(id);
    });

    function createEditRow(id) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id, item:'${item.id}'} : {item: '${item.id}'};
        data.fechaDefecto = $("#datetimepicker2").val()
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'formVa_ajax')}",
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : title + " VAE",
                    message : msg,
                    class: 'modal-sm',
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                        guardar  : {
                            id        : "btnSave",
                            label     : "<i class='fa fa-save'></i> Guardar",
                            className : "btn-success",
                            callback  : function () {
                                return submitFormVAE();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    } //createEdit

    function submitFormVAE() {
        var $form = $("#frmSave");
        if ($form.valid()) {
            var data = $form.serialize();
            var dialog = cargarLoader("Guardando...");
            $.ajax({
                type    : "POST",
                url     : $form.attr("action"),
                data    : data,
                success : function (msg) {
                    dialog.modal('hide');
                    var parts = msg.split("_");
                    if(parts[0] === 'ok'){
                        log(parts[1], "success");
                        setTimeout(function () {
                            if(tipoSeleccionado === 1){
                                recargarMateriales();
                            }else if(tipoSeleccionado === 2){
                                recargaMano();
                            }else{
                                recargaEquipo();
                            }
                        }, 1000);
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                        return false;
                    }
                }
            });
        } else {
            return false;
        }
    }

    function deleteRow(itemId, auto) {
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
                            url     : '${createLink(action:'deleteVae_ajax')}',
                            data    : {
                                id : itemId,
                                auto: auto
                            },
                            success : function (msg) {
                                v.modal("hide");
                                var parts = msg.split("_");
                                if(parts[0] === 'ok'){
                                    log(parts[1],"success");
                                    setTimeout(function () {
                                        if(tipoSeleccionado === 1){
                                            recargarMateriales();
                                        }else if(tipoSeleccionado === 2){
                                            recargaMano();
                                        }else{
                                            recargaEquipo();
                                        }
                                    }, 800);
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

    $("#btnNew").click(function () {
        createEditRow();
    });


    $(".btnDelete").click(function () {
        var id = $(this).data("id");
        deleteRow(id);
    });

    $(".btnDeleteReg").click(function () {
        var id = $(this).data("id");

        bootbox.prompt({
            title: 'Ingrese su número de autorización',
            class: 'modal-sm',
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-trash"></i> Borrar',
                    className: 'btn-danger'
                }
            },
            callback: function (result) {
                if(result != null){
                    deleteRow(id, result);
                }
            }
        });
    });


</script>
