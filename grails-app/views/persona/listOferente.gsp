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
            <a href="#" class="btn btn-info btn-new" >  <i class="fa fa-user"></i>  Nuevo Oferente</a>
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


%{--        <div id="list-Persona" role="main" style="margin-top: 10px;">--}%
%{--            <form id="frmExport">--}%
%{--                <table class="table table-bordered table-striped table-condensed table-hover">--}%
%{--                    <thead>--}%
%{--                        <tr>--}%
%{--                            <g:sortableColumn property="cedula" title="Cedula"/>--}%
%{--                            <g:sortableColumn property="nombre" title="Nombre"/>--}%
%{--                            <g:sortableColumn property="apellido" title="Apellido"/>--}%
%{--                            <g:sortableColumn property="login" title="Login"/>--}%
%{--                            <g:sortableColumn property="departamento" title="Departamento"/>--}%
%{--                            <g:sortableColumn property="activo" title="Activo"/>--}%
%{--                            <th width="150">Acciones</th>--}%
%{--                        </tr>--}%
%{--                    </thead>--}%
%{--                    <tbody class="paginate">--}%

%{--                        <g:each in="${sesion}" status="j" var="sesionPerfil">--}%
%{--                            <tr>--}%
%{--                                <td>${sesionPerfil?.usuario?.cedula}</td>--}%
%{--                                <td>${sesionPerfil?.usuario?.nombre}</td>--}%
%{--                                <td>${sesionPerfil?.usuario?.apellido}</td>--}%
%{--                                <td>${sesionPerfil?.usuario?.login}</td>--}%
%{--                                <td>${sesionPerfil?.usuario?.departamento?.descripcion}</td>--}%
%{--                                <td><g:formatBoolean boolean="${sesionPerfil?.usuario?.activo == 1}" true="Sí" false="No"/></td>--}%
%{--                                <td>--}%
%{--                                    <a class="btn btn-small btn-show btn-ajax" href="#" rel="tooltip" title="Ver" data-id="${sesionPerfil?.usuario?.id}">--}%
%{--                                        <i class="icon-zoom-in icon-large"></i>--}%
%{--                                    </a>--}%
%{--                                    <a class="btn btn-small btn-edit btn-ajax" href="#" rel="tooltip" title="Editar" data-id="${sesionPerfil?.usuario?.id}">--}%
%{--                                        <i class="icon-pencil icon-large"></i>--}%
%{--                                    </a>--}%
%{--                                    <a class="btn btn-small btn-password btn-ajax" href="#" rel="tooltip" title="Cambiar password" data-id="${sesionPerfil?.usuario?.id}">--}%
%{--                                        <i class="icon-lock icon-large"></i>--}%
%{--                                    </a>--}%
%{--                                    <a class="btn btn-small btn-cambiarEstado" href="#" rel="tooltip" title="Cambiar estado" data-id="${sesionPerfil?.usuario?.id}" data-activo="${sesionPerfil?.usuario?.activo}">--}%
%{--                                        <i class="icon-refresh icon-large"></i>--}%
%{--                                    </a>--}%
%{--                                </td>--}%
%{--                            </tr>--}%
%{--                        </g:each>--}%
%{--                    </tbody>--}%
%{--                </table>--}%
%{--            </form>--}%
%{--        </div>--}%

%{--        <div class="modal large hide fade" id="modal-Persona" style="width: 900px;">--}%
%{--            <div class="modal-header" id="modalHeader">--}%
%{--                <button type="button" class="close darker" data-dismiss="modal">--}%
%{--                    <i class="icon-remove-circle"></i>--}%
%{--                </button>--}%

%{--                <h3 id="modalTitle"></h3>--}%
%{--            </div>--}%

%{--            <div class="modal-body" id="modalBody">--}%
%{--            </div>--}%

%{--            <div class="modal-footer" id="modalFooter">--}%
%{--            </div>--}%
%{--        </div>--}%


%{--        <div id="cambiarEstado-dialog">--}%
%{--            <div class="span3">--}%
%{--                Está seguro de querer cambiar el estado del oferente?--}%
%{--            </div>--}%
%{--        </div>--}%

        <script type="text/javascript">
            %{--var url = "${resource(dir:'images', file:'spinner_24.gif')}";--}%
            %{--var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");--}%

            // function submitForm(btn) {
            //     if ($("#frmSave-Oferente").valid()) {
            //         btn.replaceWith(spinner);
            //     }
            //     $("#frmSave-Oferente").submit();
            // }

            $(function () {
                // $('[rel=tooltip]').tooltip();
                //
                // $(".paginate").paginate({
                //     maxRows        : 15,
                //     searchPosition : $("#search"),
                //     float          : "right"
                // });

                /*
                 $("#chkAll").click(function () {
                 $(".chk").attr("checked", $(this).is(":checked"));
                 });
                 */

                // $(".chk").click(function () {
                //     if (!$(this).is(":checked")) {
                //         $("#chkAll").attr("checked", false);
                //     } else {
                //         if ($(".chk").length == $(".chk:checked").length) {
                //             $("#chkAll").attr("checked", true);
                //         }
                //     }
                // });

                %{--$(".btn-copy").click(function () {--}%
                %{--    $.ajax({--}%
                %{--        type    : "POST",--}%
                %{--        url     : "${createLink(controller: 'export', action:'exportOferentes')}",--}%
                %{--        data    : $("#frmExport").serialize(),--}%
                %{--        success : function (msg) {--}%
                %{--            $("#divError").show();--}%
                %{--            $("#spanError").html(msg);--}%
                %{--        }--}%
                %{--    });--}%
                %{--    return false;--}%
                %{--}); //click btn new--}%

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
                        url     : "${createLink(action:'showOferente')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn btn-primary">Aceptar</a>');
                            $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-show");
                            $("#modalTitle").html("Ver Oferente");
                            $("#modalBody").html(msg);
                            $("#modalFooter").html("").append(btnOk);
                            $("#modal-Persona").modal("show");
                        }
                    });
                    return false;
                }); //click btn show
                var id;
                $(".btn-cambiarEstado").click(function () {
                    id = $(this).data("id");
                    $("#cambiarEstado-dialog").dialog("open");
                });

//                $(".btn-delete").click(function () {
//                    var id = $(this).data("id");
//                    $("#id").val(id);
//                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
//                    var btnDelete = $('<a href="#" class="btn btn-danger"><i class="icon-trash"></i> Eliminar</a>');
//
//                    btnDelete.click(function () {
//                        btnDelete.replaceWith(spinner);
//                        $("#frmDelete-Oferente").submit();
//                        return false;
//                    });
//
//                    $("#modalHeader").removeClass("btn-edit btn-show btn-delete").addClass("btn-delete");
//                    $("#modalTitle").html("Eliminar Oferente");
//                    $("#modalBody").html("<p>¿Está seguro de querer eliminar este Oferente?</p>");
//                    $("#modalFooter").html("").append(btnOk).append(btnDelete);
//                    $("#modal-Persona").modal("show");
//                    return false;
//                });
                $(".btn-password").click(function () {
                    var id = $(this).data("id");
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(action:'passOferente')}",
                        data    : {
                            id : id
                        },
                        success : function (msg) {
                            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                            var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                            btnSave.click(function () {
                                submitForm(btnSave);
                                return false;
                            });

                            $("#modalHeader").removeClass("btn-edit btn-show btn-delete");
                            $("#modalTitle").html("Cambiar password del Oferente");
                            $("#modalBody").html(msg);
                            $("#modalFooter").html("").append(btnOk).append(btnSave);
                            $("#modal-Persona").modal("show");
                        }
                    });
                    return false;
                }); //click btn password

                $("#cambiarEstado-dialog").dialog({

                    autoOpen  : false,
                    resizable : false,
                    modal     : true,
                    draggable : false,
                    width     : 350,
                    height    : 200,
                    position  : 'center',
                    title     : 'Cambiar Estado',
                    buttons   : {
                        "Aceptar"  : function () {
                            $.ajax({
                                type    : "POST",
                                url     : "${g.createLink(action: 'cambiarEstado')}",
                                data    : {
                                    id : id
                                },
                                success : function (msg) {
                                    if (msg == 'ok') {
                                        %{--location.href = "${createLink(action: 'listOferente')}"--}%
                                        location.reload(true);
                                    } else {
                                        $("#divError").removeClass("hide");
                                        $("#spanError").html(msg);
                                        $("#cambiarEstado-dialog").dialog("close");
                                    }
                                }
                            });
                        },
                        "Cancelar" : function () {
                            $("#cambiarEstado-dialog").dialog("close");
                        }
                    }
                });
            });
        </script>

    </body>
</html>
