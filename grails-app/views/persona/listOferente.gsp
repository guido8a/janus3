<!doctype html>
<html>
    <head>
        <meta name="layout" content="main">
        <title>
            Lista de Oferentes
        </title>
    </head>

    <body>

    <div class="btn-toolbar toolbar" style="margin-bottom: 15px">
        <div class="btn-group">
            <a href="#" class="btn btn-info btn-new" ><i class="fa fa-user"></i>  Nuevo Oferente</a>
        </div>
    </div>

    <table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
        <thead>
        <tr>
            <th style="width: 10%">Cédula</th>
            <th style="width: 20%">Nombre</th>
            <th style="width: 20%">Apellido</th>
            <th style="width: 10%">Login</th>
            <th style="width: 20%">Departamento</th>
            <th style="width: 7%">Activo</th>
            <th style="width: 13%">Acciones</th>
        </tr>
        </thead>
    </table>

    <div class="" style="width: 99.7%;height: 530px; overflow-y: auto;float: right; margin-top: -20px">
        <table class="table-bordered table-condensed table-hover" style="width: 100%; ">
            <g:each in="${sesion}" status="j" var="sesionPerfil">
                <tr>
                    <td style="width: 10%">${sesionPerfil?.usuario?.cedula}</td>
                    <td style="width: 20%">${sesionPerfil?.usuario?.nombre}</td>
                    <td style="width: 20%">${sesionPerfil?.usuario?.apellido}</td>
                    <td style="width: 10%">${sesionPerfil?.usuario?.login}</td>
                    <td style="width: 20%">${sesionPerfil?.usuario?.departamento?.descripcion}</td>
                    <td style="width: 7%; text-align: center; background-color: ${sesionPerfil?.usuario?.activo == 1 ? '#c2f8a2' : '#E22B0C'};"><g:formatBoolean boolean="${sesionPerfil?.usuario?.activo == 1}" true="Sí" false="No"/></td>
                    <td style="width: 13%">
                        <a class="btn btn-xs btn-show btn-info" href="#" rel="tooltip" title="Ver" data-id="${sesionPerfil?.usuario?.id}">
                            <i class="fa fa-search"></i>
                        </a>
                        <a class="btn btn-xs btn-edit btn-success" href="#" rel="tooltip" title="Editar" data-id="${sesionPerfil?.usuario?.id}">
                            <i class="fa fa-edit"></i>
                        </a>
                        <a class="btn btn-xs btn-password btn-info" href="#" rel="tooltip" title="Cambiar password" data-id="${sesionPerfil?.usuario?.id}">
                            <i class="fa fa-lock"></i>
                        </a>
                        <a class="btn btn-xs btn-cambiarEstado btn-primary" href="#" rel="tooltip" title="Cambiar estado" data-id="${sesionPerfil?.usuario?.id}" data-activo="${sesionPerfil?.usuario?.activo}">
                            <i class="fa fa-retweet"></i>
                        </a>
                    </td>
                </tr>
            </g:each>
        </table>
    </div>

        <script type="text/javascript">

            $(function () {

                $(".btn-new").click(function () {
                    createEditOferente();
                }); //click btn new

                $(".btn-edit").click(function () {
                    var id = $(this).data("id");
                    createEditOferente(id);
                }); //click btn edit

                function createEditOferente(id) {
                    var title = id ? "Editar " : "Crear ";
                    var data = id ? {id : id} : {};

                    $.ajax({
                        type    : "POST",
                        url     :  "${createLink(controller: 'persona', action:'formOferente')}",
                        data    : data,
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgCreateEditOF",
                                class   : "modal-lg",
                                title   : title + " oferente",
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
                                            return submitFormOferente();
                                        } //callback
                                    } //guardar
                                } //buttons
                            }); //dialog
                            setTimeout(function () {
                                b.find(".form-control").not(".datepicker").first().focus()
                            }, 500);
                        } //success
                    }); //ajax
                } //createEdit

                function submitFormOferente() {
                    var $form = $("#frmSave-Oferente");
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
                                        location.reload();
                                    }, 800);
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

                $(".btn-show").click(function () {
                    var id = $(this).data("id");
                    $.ajax({
                        type    : "POST",
                        url     :  "${createLink(controller: 'persona', action:'showOferente')}",
                        data    : {
                            id: id
                        },
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgShowOF",
                                title   : "Ver datos de oferente",
                                message : msg,
                                buttons : {
                                    cancelar : {
                                        label     : "Cancelar",
                                        className : "btn-primary",
                                        callback  : function () {
                                        }
                                    }
                                } //buttons
                            }); //dialog
                        } //success
                    }); //ajax
                }); //click btn show

                $(".btn-cambiarEstado").click(function () {
                    var id = $(this).data("id");
                    bootbox.confirm({
                        title: "Cambiar estado",
                        message: "Está seguro que desea cambiar el estado del oferente?",
                        buttons: {
                            cancel: {
                                label: '<i class="fa fa-times"></i> Cancelar',
                                className: 'btn-primary'
                            },
                            confirm: {
                                label: '<i class="fa fa-check"></i> Aceptar',
                                className: 'btn-success'
                            }
                        },
                        callback: function (result) {
                            if(result){
                                var g = cargarLoader("Guardando...");
                                $.ajax({
                                    type    : "POST",
                                    url     : "${g.createLink(action: 'cambiarEstado')}",
                                    data    : {
                                        id : id
                                    },
                                    success : function (msg) {
                                        g.modal("hide");
                                        var parts = msg.split("_");
                                        if(parts[0] === 'ok'){
                                            log(parts[1], "success");
                                            setTimeout(function () {
                                                location.reload();
                                            }, 800);
                                        }else{
                                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                            return false;
                                        }
                                    }
                                });
                            }
                        }
                    });
                });

                $(".btn-password").click(function () {
                    var id = $(this).data("id");

                    $.ajax({
                        type    : "POST",
                        url     :  "${createLink(controller: 'persona', action:'passOferente')}",
                        data    : {
                            id: id
                        },
                        success : function (msg) {
                            var b = bootbox.dialog({
                                id      : "dlgPassOF",
                                // class   : "modal-lg",
                                title   : "Cambiar password del oferente",
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
                                            return submitFormPassword();
                                        } //callback
                                    } //guardar
                                } //buttons
                            }); //dialog
                        } //success
                    }); //ajax
                }); //click btn password

                function submitFormPassword() {
                    var $form = $("#frmPass-Oferente");
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
                                        location.reload();
                                    }, 800);
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
            });
        </script>
    </body>
</html>