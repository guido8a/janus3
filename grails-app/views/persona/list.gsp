<%@ page import="seguridad.Permiso; seguridad.Permiso; seguridad.Prfl; seguridad.PermisoUsuario; seguridad.Sesn; seguridad.Accs; seguridad.Persona" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Personal</title>

    <style type="text/css">
    .table {
        font-size     : 12px;
        margin-bottom : 0 !important;
    }

    .perfiles option:first-child {
        font-weight : normal !important;
    }
    </style>
</head>

<body>
<g:set var="iconActivar" value="fa-hdd-o"/>
<g:set var="iconDesactivar" value="fa-power-off"/>


<!-- botones -->
<div class="btn-toolbar toolbar" style="margin-bottom: 15px">
    <div class="btn-group">
        <a href="#" class="btn btn-info btnCrear" >  <i class="fa fa-user"></i>  Nuevo Usuario</a>
        <a href="#" class="btn btn-info" id="btnOferentes">  <i class="fa fa-user"></i> Crear Oferente</a>
        <a href="#" class="btn btn-info" id="btnColocarRol" >  <i class="fa fa-cog"></i> Colocar Rol en la persona</a>
        <a href="#" class="btn btn-info" id="btnAsignarDirector">  <i class="fa fa-star"></i> Asignar director</a>
        <a href="#" class="btn btn-info" id="btnAsignarCoordinador">  <i class="fa fa-users"></i> Asignar coordinador</a>
    </div>
    <div class="btn-group">
        <a href="#" class="btn btn-success btnReporte" >  <i class="fa fa-print"></i>  Reporte de usuarios</a>
     </div>
</div>


<div style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <span class="col-md-2">
                    <label class="control-label text-info">Buscar Por</label>
                    <g:select name="buscarPor" class="buscarPor col-md-12 form-control" from="${[1: 'Usuario', 2: 'Nombre', 3 : 'Apellido']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">Criterio</label>
                    <g:textField name="buscarCriterio" id="criterioCriterio" class="form-control"/>
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">Estado del usuario</label>
                    <g:select name="estado" class="estado form-control" from="${[1: 'Todos', 2: 'Activo', 3: 'Inactivo']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">Perfil</label>
                    <g:select name="perfil" class="form-control" from="${seguridad.Prfl.list([sort: 'nombre'])}" optionKey="id"
                              optionValue="nombre" noSelection="[0 : 'Seleccionar...']"/>
                </span>
                <span class="col-md-3">
                    <label class="control-label text-info">Departamento</label>
                    <g:select name="departamento" class="form-control" from="${janus.Departamento.list().sort{it.descripcion}}" optionKey="id"
                              optionValue="descripcion" noSelection="[0 : 'Seleccionar...']"/>
                </span>
            </span>
            <div class="col-md-1" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscarUsuarios"><i class="fa fa-search"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaUsuarios" style="height: 560px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $(".btnReporte").click(function () {
        location.href = "${g.createLink(controller: 'reportes6',action: 'imprimirUsuariosExcel')}"
    });

    $("#btnOferentes").click(function () {
        createEditOferente();
    });

    $("#btnAsignarCoordinador").click(function () {
        location.href="${createLink(controller: 'asignarCoordinador', action: 'asignarCoordinador')}"
    });

    $("#btnAsignarDirector").click(function () {
        location.href="${createLink(controller: 'asignarDirector', action: 'asignarDirector')}"
    });

    $("#btnColocarRol").click(function () {
        location.href="${createLink(controller: 'personaRol', action: 'registroPersonaRol')}"
    });

    cargarTablaUsuarios();

    $("#btnBuscarUsuarios").click(function () {
        cargarTablaUsuarios();
    });

    function cargarTablaUsuarios(){
        var d = cargarLoader("Cargando...");
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $("#criterioCriterio").val();
        var estado = $("#estado option:selected").val();
        var perfil = $("#perfil option:selected").val();
        var departamento = $("#departamento option:selected").val();
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'persona', action: 'tablaUsuarios_ajax')}',
            data:{
                buscarPor: buscarPor,
                criterio: criterio,
                estado: estado,
                perfil: perfil,
                departamento: departamento
            },
            success: function (msg){
                d.modal("hide");
                $("#divTablaUsuarios").html(msg)
            }
        })
    }

    function submitForm() {
        var $form = $("#frmPersona");
        var $btn = $("#dlgCreateEdit").find("#btnSave");
        var idPersona = $("#trPersona").data("id");
        if ($form.valid()) {

            var dialog = cargarLoader("Guardando...");

            $.ajax({
                type    : "POST",
                %{--url     : '${createLink(controller: 'persona', action:'save_ajax')}',--}%
                url     : '${createLink(controller: 'persona', action:'savePersona_ajax')}',
                data    : $form.serialize(),
                success : function (msg) {
                    var parts = msg.split("_");
                    if (parts[0] !== "INFO") {
                        // log(parts[1], parts[0] === "SUCCESS" ? "success" : "error");
                        // if (parts[0] === "SUCCESS") {
                        //     dialog.modal('hide');
                        //     setTimeout(function () {
                        //         location.reload();
                        //     }, 1000);
                        // } else {
                        //     spinner.replaceWith($btn);
                        //     dialog.modal('hide');
                        //     return false;
                        // }

                        if(parts[0] == 'ok'){
                            dialog.modal('hide');
                            log(parts[1], "success")
                            setTimeout(function () {
                                location.reload();
                            }, 1000);
                        }else{
                            dialog.modal('hide');
                            log(parts[1], "error")
                        }

                    } else {
                        // closeLoader();
                        bootbox.dialog({
                            title   : "Alerta",
                            message : "<i class='fa fa-warning fa-3x pull-left text-warning text-shadow'></i>" + parts[1],
                            buttons : {
                                cancelar : {
                                    label     : "Cancelar",
                                    className : "btn-primary",
                                    callback  : function () {
                                    }
                                },
                                aceptar  : {
                                    label     : "<i class='fa fa-thumbs-o-up '></i> Continuar",
                                    className : "btn-success",
                                    callback  : function () {
                                        var $sel = $("#selWarning");
                                        var resp = $sel.val();
                                        var dpto = $sel.data("dpto");
                                        if (resp === 1 || resp === "1") {
                                            openLoader("Cambiando");
                                            $.ajax({
                                                type    : "POST",
                                                url     : '${createLink(controller: 'persona', action:'cambioDpto_ajax')}',
                                                data    : {
                                                    id   : idPersona,
                                                    dpto : dpto
                                                },
                                                success : function (msg) {
                                                    var parts = msg.split("_");
                                                    log(parts[1], parts[0] === "OK" ? "success" : "error"); // log(msg, type, title, hide)
                                                    if (parts[0] === "OK") {
                                                        location.reload();
                                                    }
                                                }
                                            });
                                        }
                                    }
                                }
                            }
                        });
                    }
                }
            });
        } else {
            return false;
        } //else
    }
    function deleteRow(itemId) {
        bootbox.dialog({
            title   : "<strong>Eliminar</strong> usuario del sistema",
            message : "<i class='fa fa-trash fa-2x pull-left text-danger text-shadow'></i>" +
                "<p> ¿Está seguro que desea eliminar al usuario seleccionado? Esta acción no se puede deshacer.</p>",
            buttons : {
                cancelar : {
                    label     : "Cancelar",
                    className : "btn-primary",
                    callback  : function () {
                    }
                },
                eliminar : {
                    label     : "<i class='fa fa-trash'></i> Eliminar Usuario",
                    className : "btn-danger",
                    callback  : function () {
                        var a = cargarLoader("Eliminando");
                        $.ajax({
                            type    : "POST",
                            url     : '${createLink(controller: 'persona', action:'delete_ajax')}',
                            data    : {
                                id : itemId
                            },
                            success : function (msg) {
                                a.modal('hide');
                                var parts = msg.split("_");
                                log(parts[1], parts[0] === "OK" ? "success" : "error"); // log(msg, type, title, hide)
                                if (parts[0] === "OK") {
                                    location.reload();
                                }
                            }
                        });
                    }
                }
            }
        });
    }

    function createEditRow(id, tipo) {
        var title = id ? "Editar " : "Crear ";
        var data = id ? {id : id} : {};

        var url = "";
        switch (tipo) {
            case "persona":
                url = "${createLink(controller: 'persona', action:'form_ajax')}";
                break;
            case "usuario":
                url = "${createLink(controller: 'persona',  action:'formUsuario_ajax')}";
                break;
        }

        $.ajax({
            type    : "POST",
            url     : url,
            data    : data,
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    class   : "modal-lg",
                    title   : title + tipo,
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
                                return submitForm();
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

    $(function () {
        $(".btnCrear").click(function () {
            createEditRow(null, "persona");
            return false;
        });
    });

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


</script>

</body>
</html>