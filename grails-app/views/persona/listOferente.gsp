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

    <div style="overflow: hidden">
        <fieldset class="borde" style="border-radius: 4px; margin-bottom: 10px">
            <div class="row-fluid" style="margin-left: 10px">
                <span class="grupo">
                    <span class="col-md-2">
                        <label class="control-label text-info">Buscar Por</label>
                        <g:select name="buscarPor" class="buscarPor col-md-12 form-control" from="${[1: 'Cédula', 2: 'Nombre', 3 : 'Apellido']}" optionKey="key"
                                  optionValue="value"/>
                    </span>
                    <span class="col-md-2">
                        <label class="control-label text-info">Criterio</label>
                        <g:textField name="buscarCriterio" id="criterioCriterio" class="form-control"/>
                    </span>
                </span>
                <div class="col-md-1" style="margin-top: 20px">
                    <button class="btn btn-info" id="btnBuscarOferentes"><i class="fa fa-search"></i></button>
                </div>
                <div class="col-md-1" style="margin-top: 20px">
                    <button class="btn btn-warning" id="btnLimpiarBusqueda" title="Limpiar Búsqueda"><i class="fa fa-eraser"></i></button>
                </div>
            </div>
        </fieldset>

        <fieldset class="borde" style="border-radius: 4px">
            <div id="divTablaOferentes" >
            </div>
        </fieldset>
    </div>

        <script type="text/javascript">

        $("#btnLimpiarBusqueda").click(function  () {
            $("#buscarPor").val(1);
            $("#criterioCriterio").val('');
            cargarTablaOferentes();
        });

        cargarTablaOferentes();

        $("#btnBuscarOferentes").click(function () {
            cargarTablaOferentes();
        });

        function cargarTablaOferentes(){
            var d = cargarLoader("Cargando...");
            var buscarPor = $("#buscarPor option:selected").val();
            var criterio = $("#criterioCriterio").val();
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'persona', action: 'tablaOferentes_ajax')}',
                data:{
                    buscarPor: buscarPor,
                    criterio: criterio
                },
                success: function (msg){
                    d.modal("hide");
                    $("#divTablaOferentes").html(msg)
                }
            })
        }

            // $(function () {

                $(".btn-new").click(function () {
                    createEditOferente();
                }); //click btn new

                // $(".btn-edit").click(function () {
                //     var id = $(this).data("id");
                //     createEditOferente(id);
                // }); //click btn edit

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
                                        // location.reload();
                                        cargarTablaOferentes();
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

                %{--$(".btn-show").click(function () {--}%
                %{--    var id = $(this).data("id");--}%
                %{--    $.ajax({--}%
                %{--        type    : "POST",--}%
                %{--        url     :  "${createLink(controller: 'persona', action:'showOferente')}",--}%
                %{--        data    : {--}%
                %{--            id: id--}%
                %{--        },--}%
                %{--        success : function (msg) {--}%
                %{--            var b = bootbox.dialog({--}%
                %{--                id      : "dlgShowOF",--}%
                %{--                title   : "Ver datos de oferente",--}%
                %{--                message : msg,--}%
                %{--                buttons : {--}%
                %{--                    cancelar : {--}%
                %{--                        label     : "Cancelar",--}%
                %{--                        className : "btn-primary",--}%
                %{--                        callback  : function () {--}%
                %{--                        }--}%
                %{--                    }--}%
                %{--                } //buttons--}%
                %{--            }); //dialog--}%
                %{--        } //success--}%
                %{--    }); //ajax--}%
                %{--}); //click btn show--}%

%{--                $(".btn-cambiarEstado").click(function () {--}%
%{--                    var id = $(this).data("id");--}%
%{--                    bootbox.confirm({--}%
%{--                        title: "Cambiar estado",--}%
%{--                        message: "Está seguro que desea cambiar el estado del oferente?",--}%
%{--                        buttons: {--}%
%{--                            cancel: {--}%
%{--                                label: '<i class="fa fa-times"></i> Cancelar',--}%
%{--                                className: 'btn-primary'--}%
%{--                            },--}%
%{--                            confirm: {--}%
%{--                                label: '<i class="fa fa-check"></i> Aceptar',--}%
%{--                                className: 'btn-success'--}%
%{--                            }--}%
%{--                        },--}%
%{--                        callback: function (result) {--}%
%{--                            if(result){--}%
%{--                                var g = cargarLoader("Guardando...");--}%
%{--                                $.ajax({--}%
%{--                                    type    : "POST",--}%
%{--                                    url     : "${g.createLink(action: 'cambiarEstado')}",--}%
%{--                                    data    : {--}%
%{--                                        id : id--}%
%{--                                    },--}%
%{--                                    success : function (msg) {--}%
%{--                                        g.modal("hide");--}%
%{--                                        var parts = msg.split("_");--}%
%{--                                        if(parts[0] === 'ok'){--}%
%{--                                            log(parts[1], "success");--}%
%{--                                            setTimeout(function () {--}%
%{--                                                location.reload();--}%
%{--                                            }, 800);--}%
%{--                                        }else{--}%
%{--                                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');--}%
%{--                                            return false;--}%
%{--                                        }--}%
%{--                                    }--}%
%{--                                });--}%
%{--                            }--}%
%{--                        }--}%
%{--                    });--}%
%{--                });--}%

                %{--$(".btn-password").click(function () {--}%
                %{--    var id = $(this).data("id");--}%

                %{--    $.ajax({--}%
                %{--        type    : "POST",--}%
                %{--        url     :  "${createLink(controller: 'persona', action:'passOferente')}",--}%
                %{--        data    : {--}%
                %{--            id: id--}%
                %{--        },--}%
                %{--        success : function (msg) {--}%
                %{--            var b = bootbox.dialog({--}%
                %{--                id      : "dlgPassOF",--}%
                %{--                // class   : "modal-lg",--}%
                %{--                title   : "Cambiar password del oferente",--}%
                %{--                message : msg,--}%
                %{--                buttons : {--}%
                %{--                    cancelar : {--}%
                %{--                        label     : "Cancelar",--}%
                %{--                        className : "btn-primary",--}%
                %{--                        callback  : function () {--}%
                %{--                        }--}%
                %{--                    },--}%
                %{--                    guardar  : {--}%
                %{--                        id        : "btnSave",--}%
                %{--                        label     : "<i class='fa fa-save'></i> Guardar",--}%
                %{--                        className : "btn-success",--}%
                %{--                        callback  : function () {--}%
                %{--                            return submitFormPassword();--}%
                %{--                        } //callback--}%
                %{--                    } //guardar--}%
                %{--                } //buttons--}%
                %{--            }); //dialog--}%
                %{--        } //success--}%
                %{--    }); //ajax--}%
                %{--}); //click btn password--}%

                // function submitFormPassword() {
                //     var $form = $("#frmPass-Oferente");
                //     if ($form.valid()) {
                //         var data = $form.serialize();
                //         var dialog = cargarLoader("Guardando...");
                //         $.ajax({
                //             type    : "POST",
                //             url     : $form.attr("action"),
                //             data    : data,
                //             success : function (msg) {
                //                 dialog.modal('hide');
                //                 var parts = msg.split("_");
                //                 if(parts[0] === 'ok'){
                //                     log(parts[1], "success");
                //                     setTimeout(function () {
                //                         location.reload();
                //                     }, 800);
                //                 }else{
                //                     bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                //                     return false;
                //                 }
                //             }
                //         });
                //     } else {
                //         return false;
                //     }
                // }
            // });
        </script>
    </body>
</html>