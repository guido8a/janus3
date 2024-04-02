<legend>Precios de: ${item.nombre} (${item.unidad?.codigo?.trim()}) <br> Lista: ${lugarNombre}</legend>

<div style="height: 35px; width: 100%;">
    <div class="btn-group pull-left">
        <g:if test="${session.perfil.codigo in ['CSTO', 'RBRO']}">
            <a href="#" class="btn btn-primary" id="btnNew">
                <i class="fa fa-money-bill"></i>
                Nuevo Precio
            </a>
            <g:if test="${item.departamento.subgrupo.grupoId == 2 || item.departamento.subgrupo.grupoId == 3}">
                <a href="#" class="btn btn-warning" id="btnCalc${item.departamento.subgrupo.grupoId}">
                    <i class="fa fa-cog"></i>
                    Calcular precio
                </a>
            </g:if>
        </g:if>
    </div>

    <g:if test="${item.departamento.subgrupo.grupoId == 2 || item.departamento.subgrupo.grupoId == 3}">
        <span style="margin-left: 10px;" id="spanRef">

        </span>
    </g:if>

    <g:if test="${item.departamento.subgrupo.grupoId == 2 || item.departamento.subgrupo.grupoId == 3}">
        <div class="btn-group pull-left">
            <a href="#" class="btn btn-primary" id="btnPrint" style="display: none; margin-left: 10px" data-id="${item.id}" data-nombre="${item.nombre}">
                <i class="fa fa-print"></i>
                Imprimir
            </a>
        </div>
    </g:if>
</div>

<div id="divTabla" style="height: 630px; width: 100%; overflow-x: hidden; overflow-y: auto;">
    <table class="table table-striped table-bordered table-hover table-condensed" id="tablaPrecios">
        <thead>
        <tr style="width: 100%">
            <g:if test="${lgar}">
                <th style="width: 29%">Lugar</th>
            </g:if>
            <th style="width: 20%">Fecha</th>
            <th class="precio" style="width: 20%">Precio</th>
            <th class="delete" style="width: 30%"></th>
            <th style="width: 1%"></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${precios}" var="precio" status="i">
            <tr style="width: 100%">
                <g:if test="${lgar}">
                    <td style="width: 29%">
                        ${precio.lugar.descripcion}
                    </td>
                </g:if>
                <td style="width: 20%">
                    <g:formatDate date="${precio.fecha}" format="dd-MM-yyyy"/>
                </td>
                <g:if test="${session.perfil.codigo == 'CSTO'}">
                    <td class="precio textRight " style="width: 20%" data-original="${precio.precioUnitario}" data-valor="${precio.precioUnitario}" id="${precio.id}" >
                        <g:formatNumber number="${precio.precioUnitario}" maxFractionDigits="5" minFractionDigits="5" format="##,#####0" locale='ec'/>
                    </td>
                    <td class="delete" style="width: 30%">
                        <g:if test="${precio?.registrado != 'R'}">
                            <a href="#" class="btn btn-info btn-xs btnEditar" title="Editar valor" data-id="${precio.id}">
                                <i class="fa fa-edit"></i>
                            </a>
                        </g:if>
                        <g:if test="${precio?.registrado != 'R'}">
                            <a href="#" class="btn btn-success btn-xs btnEditarCantones" title="Editar valor para todos los cantones" data-id="${precio.id}">
                                <i class="fa fa-list-ul"></i>
                            </a>
                        </g:if>
                        <a href="#" class="btn btn-danger btn-xs ${precio.registrado != 'R' ? 'btnDelete' : 'btnDeleteReg'}" rel="tooltip" title="Borrar precio" id="${precio.id}">
                            <i class="fa fa-trash"></i>
                        </a>
                    </td>
                </g:if>
                <g:else>
                    <td class="precio textRight" style="width: 19%" data-original="${precio.precioUnitario}" data-valor="${precio.precioUnitario}" id="${precio.id}">
                        <g:formatNumber number="${precio.precioUnitario}" maxFractionDigits="5" minFractionDigits="5" format="##,#####0" locale='ec'/>
                    </td>
                    <td class="delete" style="width: 25%">

                    </td>
                </g:else>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<div class="modal hide fade" id="modal_lugar">
    <div class="modal-header" id="modal-header_lugar">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle_lugar"></h3>
    </div>

    <div class="modal-body" id="modalBody_lugar">
    </div>

    <div class="modal-footer" id="modalFooter_lugar">
    </div>
</div>

<div class="modal hide fade" id="modal-tree1">

    <div class="modal-body" id="modalBody-tree1">
    </div>

    <div class="modal-footer" id="modalFooter-tree1">
    </div>
</div>

<div id="modal-tree2">

    <div class="modal-body" id="modalBody-tree2" style="width: 970px;">
    </div>

    <div class="modal-footer" id="modalFooter-tree2">
    </div>
</div>

<div id="imprimirDialog">
    <fieldset>
        <div class="span3">
            Elija la fecha de validez del cálculo:
            <div class="span2" style="margin-top: 20px; margin-left: 50px">
                <elm:datepicker name="fechaCalculo" class="span24" id="fechaCalculoId" value="${new java.util.Date()}" style="width: 100px" minDate="new Date(${new Date().format('yyyy')},0,1)" maxDate="new Date(${new Date().format('yyyy')},11,31)"
                                readonly="true" />
            </div>
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            (ev.keyCode === 188 || ev.keyCode === 190 || ev.keyCode === 110) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        createEditPrecio(id);
    });

    $("#btnNew").click(function () {
        createEditPrecio();
    });

    $(".btnEditarCantones").click(function () {
        var id = $(this).data("id");
        createEditPrecioCantones(id);
    });


    function createEditPrecio(precio) {
        var fechaDefecto = $("#datetimepicker2").val();
        var title = precio ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formPrecio_ajax')}",
            data    : {
                item        : "${item.id}",
                lugar       : "${lugarId}",
                nombreLugar : "${lugarNombre}",
                fecha       : "${fecha}",
                all         : "${params.all}",
                ignore      : "${params.ignore}",
                id: precio,
                fd: fechaDefecto
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditP",
                    title : title + " precio",
                    // class : "modal-sm",
                    message : msg,
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
                                return submitFormPrecio();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitFormPrecio() {
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
                    if(parts[0] === 'OK'){
                        log(parts[1], "success");
                        setTimeout(function () {
                            if(tipoSeleccionado === 1){
                                cargarMateriales();
                                recargarMateriales();
                            }else if(tipoSeleccionado === 2){
                                cargarMano();
                                recargaMano();
                            }else{
                                cargarEquipo();
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

    function createEditPrecioCantones(precio) {
        var title = precio ? "Editar" : "Nuevo";
        $.ajax({
            type    : "POST",
            url     : "${createLink( action:'formPreciosCantones_ajax')}",
            data    : {
                item        : "${item.id}",
                lugar       : "${lugarId}",
                nombreLugar : "${lugarNombre}",
                fecha       : "${fecha}",
                all         : "${params.all}",
                ignore      : "${params.ignore}",
                id: precio
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id    : "dlgCreateEditP",
                    title : title + " precio para los cantones",
                    message : msg,
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
                                // chequeados();
                               return submitFormPrecioC();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
                setTimeout(function () {
                    b.find(".form-control").first().focus()
                }, 500);
            } //success
        }); //ajax
    } //createEdit

    function submitFormPrecioC() {
        var $form = $("#frmSaveCantones");
        if ($form.valid()) {
            var data = $form.serialize();
            var lugares = chequeados();

            if(lugares == ''){
                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione al menos un lugar" + '</strong>');
                return false;
            }else{
                var dialog = cargarLoader("Guardando...");
                $.ajax({
                    type    : "POST",
                    url     : $form.attr("action"),
                    data    : data + "&lugares=" + lugares,
                    success : function (msg) {
                        dialog.modal('hide');
                        var parts = msg.split("_");
                        if(parts[0] === 'ok'){
                            log(parts[1], "success");
                            setTimeout(function () {
                                if(tipoSeleccionado === 1){
                                    cargarMateriales();
                                    recargarMateriales();
                                }else if(tipoSeleccionado === 2){
                                    cargarMano();
                                    recargaMano();
                                }else{
                                    cargarEquipo();
                                    recargaEquipo();
                                }
                            }, 1000);
                        }else{
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            return false;
                        }
                    }
                });
            }
        } else {
            return false;
        }
    }

    $(".btnDelete").click(function () {
        var id = $(this).attr("id");
        borrarPrecio(id)
    });

    var valorSueldo;
    var id2;

    $("#btnCalc2").click(function () {

        bootbox.prompt({
            class: 'modal-sm',
            title: 'Por favor ingrese el sueldo básico para el Obrero del año:  ${new Date().getYear()}.',
            callback: function(result) {
                if(result){
                    if(result == ''){
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese un valor numérico" + '</strong>');
                        return false
                    }else{
                        var v = cargarLoader("Calculando...");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(action:'calcPrecioRef_ajax')}',
                            data    : {
                                precio: result
                            },
                            success : function (msg) {
                                v.modal("hide");
                                if(msg == 'error'){
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese un valor numérico" + '</strong>');
                                }else{
                                    $("#spanRef").text("Precio ref: " + msg)
                                }
                            }
                        });
                    }
                }

            }
        });
    });

    $("#btnCalc3").click(function () {
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'calcPrecEq')}",
            data    : {
                item : ${item.id}
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : "Cálculo del valor por Hora de Equipos",
                    class : "modal-lg",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                            }
                        },
                    } //buttons
                }); //dialog
            } //success
        }); //ajax

    });

    $("#modal-tree1").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 950,
        height: 700,
        position: 'center',
        title: 'Datos de Situación Geográfica'
    });


    function borrarPrecio(id) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar este precio? Esta acción no se puede deshacer.</p>",
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
                            url     : '${createLink(action:'deletePrecio_ajax')}',
                            data    : {
                                id : id
                            },
                            success : function (msg) {
                                v.modal("hide");
                                var parts = msg.split("_");
                                if(parts[0] === 'OK'){
                                    log(parts[1],"success");
                                    setTimeout(function () {
                                        if(tipoSeleccionado === 1){
                                            cargarMateriales();
                                            recargarMateriales();
                                        }else if(tipoSeleccionado === 2){
                                            cargarMano();
                                            recargaMano();
                                        }else{
                                            cargarEquipo();
                                            recargaEquipo();
                                        }
                                    }, 1000);
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

    function borrarPrecioRegistrado(id) {
        bootbox.dialog({
            title   : "Alerta",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i><p style='font-weight: bold'> Está seguro que desea eliminar este precio? Esta acción no se puede deshacer.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                aceptar : {
                    label     : "<i class='fa fa-trash'></i> Aceptar",
                    className : "btn-danger",
                    callback  : function () {

                        bootbox.prompt({
                            class: 'modal-sm',
                            title: 'Este precio está registrado. Para eliminarlo necesita ingresar su clave de autorización.',
                            callback: function(result) {
                                if(result){
                                    if(result == ''){
                                        bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese su código de autorización" + '</strong>');
                                        return false
                                    }else{
                                        var v = cargarLoader("Eliminando...");
                                        $.ajax({
                                            type    : "POST",
                                            url     : '${createLink(action:'deletePrecio_ajax')}',
                                            data    : {
                                                id : id,
                                                auto: result
                                            },
                                            success : function (msg) {
                                                v.modal("hide");
                                                var parts = msg.split("_");
                                                if(parts[0] === 'ok'){
                                                    log(parts[1],"success");
                                                    setTimeout(function () {
                                                        if(tipoSeleccionado === 1){
                                                            cargarMateriales();
                                                            recargarMateriales();
                                                        }else if(tipoSeleccionado === 2){
                                                            cargarMano();
                                                            recargaMano();
                                                        }else{
                                                            cargarEquipo();
                                                            recargaEquipo();
                                                        }
                                                    }, 1000);
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
                }
            }
        });
    }

    $(".btnDeleteReg").click(function () {
        var id = $(this).attr("id");
        borrarPrecioRegistrado(id);
    });

    $("#btnPrint").click(function () {
        $("#imprimirDialog").dialog("open");
    });

    $("#imprimirDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        dragable  : false,
        width     : 320,
        height    : 220,
        position  : 'center',
        title     : 'Elegir fecha de validez de cálculo',
        buttons   : {
            "Aceptar" : function () {
                console.log( $("#btnPrint").data("id"))
                location.href="${g.createLink(controller: 'reportes3',action: 'imprimirCalculoValor')}?valor=" + valorSueldo + "&fechaCalculo=" + $("#fechaCalculoId").val() + "&id=" +
                    $("#btnPrint").data("id")
                $("#imprimirDialog").dialog("close");

            },
            "Cancelar" : function () {
                $("#imprimirDialog").dialog("close");
            }
        }
    })

</script>