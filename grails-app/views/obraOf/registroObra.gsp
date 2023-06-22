
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">

    <style type="text/css">

    .formato {
        font-weight: bolder;
    }

    .titulo {
        font-size: 20px;
    }

    .error {
        background: #c17474;
    }

    .bold {
        font-weight: bold;
    }
    .botonReg {
        <g:if test="${obra?.estado == 'N'}">
            background-color: #2b6c7c;
        </g:if>
        <g:else>
            background-color: #7c4f39;
        </g:else>
        color: #fff;
    }
    .botonReg:hover {
        color: #fff;
        font-weight: bold;
    }    
    </style>

    <title>Registro de Obras</title>
</head>

<body>

<h3 style="text-align: center">${titulo}</h3>

<div class="row">
    <div class="span12 btn-group" role="navigation" style="margin-bottom: 15px;">
        <button class="btn btn-primary" id="lista"><i class="fa fa-list"></i> Lista</button>
        <g:if test="${obra?.id != null}">
            <button class="btn btn-info" id="btnImprimir"><i class="fa fa-print"></i> Imprimir</button>
            <g:if test="${obraOferente?.estado != 'C'}">
                %{--<button class="btn btn-success botonReg" id="cambiarEstado"><i class="fa fa-retweet"></i> Cambiar Estado</button>--}%
                <button class="btn botonReg" id="cambiarEstado"><i class="fa fa-retweet"></i> Cambiar Estado</button>
            </g:if>
            <g:else>
                <g:if test="${obraOferente?.estado == 'C'}">
                    <button class="btn botonReg" id="cambiarEstado" disabled><i class="fa fa-check"></i> Obra migrada a Proyectos</button>
                </g:if>
            </g:else>
            <g:if test="${obra?.estado == 'R' && obra?.tipo != 'O'}">
                <button class="btn btn-success" id="migrarObra"><i class="fa fa-retweet"></i> Migrar obra a Proyectos</button>
            </g:if>
        </g:if>
    </div>
</div>

<g:form class="form-horizontal" name="frmSave-Lugar" action="save">
    <div style="border: 1px solid black; width: 100%; height: 400px">
        <div class="col-md-12" style="margin-bottom: 10px; margin-top: 20px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Código
                    </span>
                </div>

                <div class="controls col-md-10">
                    ${obra?.codigo}
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Nombre
                    </span>
                </div>

                <div class="controls col-md-10">
                    ${obra?.nombre}
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Descripción
                    </span>
                </div>

                <div class="controls col-md-10">
                    ${obra?.descripcion}
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Programa
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.programacion?.descripcion}
                </div>


                <div>
                    <span class="badge col-md-2">
                        Tipo
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.tipoObjetivo?.descripcion}
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Clase
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.claseObra?.descripcion}
                </div>

                <div>
                    <span class="badge col-md-2">
                        Referencias
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.referencia}
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Cantón
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.comunidad?.parroquia?.canton?.nombre}
                </div>

                <div>
                    <span class="badge col-md-2">
                        Parroquia
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.comunidad?.parroquia?.nombre}
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Comunidad
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.comunidad?.nombre}
                </div>

                <div>
                    <span class="badge col-md-2">
                        Sitio
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.sitio}
                </div>
            </div>
        </div>


        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Barrio
                    </span>
                </div>

                <div class="controls col-md-4">
                    ${obra?.barrio}
                </div>

                <div>
                    <span class="badge col-md-2">
                        Fecha
                    </span>
                </div>

                <div class="controls col-md-4">
                    <g:formatDate date="${obra?.fechaPreciosRubros}" format="dd-MM-yyyy"/>
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
                <div class="control-group">
                    <div>
                        <span class="badge col-md-2">
                            Plazo
                        </span>
                    </div>

                    <div class="controls col-md-4">
                        ${obra?.plazoEjecucionMeses} Mes${obra?.plazoEjecucionMeses == 1 ? '' : 'es'}
                        ${obra?.plazoEjecucionDias} Día${obra?.plazoEjecucionDias == 1 ? '' : 's'}
                    </div>

                    <div>
                        <span class="badge col-md-2">
                            Anticipo
                        </span>
                    </div>

                    <div class="controls col-md-4">
                        ${obra?.porcentajeAnticipo}%
                    </div>
                </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
                <div class="control-group">
                    <div>
                        <span class="badge col-md-2">
                            Coordenadas
                        </span>
                    </div>

                    <div class="controls col-md-4">
                        ${obra?.coordenadas}
                    </div>

                    <div>
                        <span class="badge col-md-2">
                            Registrada:
                        </span>
                    </div>

                    <div class="controls col-md-4">
                        ${obra?.estado == "N" ? "Acepta modificaciones" : "Registrado"}
                    </div>
                </div>
        </div>

        <div class="col-md-12" style="margin-bottom: 10px">
            <div class="control-group">
                <div>
                    <span class="badge col-md-2">
                        Observaciones
                    </span>
                </div>

                <div class="controls col-md-10">
                    ${obra?.observaciones}
                </div>
            </div>
        </div>
    </div>
</g:form>


%{--<div id="busqueda" class="hide">--}%

%{--    <fieldset class="borde">--}%
%{--        <div class="span7">--}%

%{--            <div class="span2">Buscar Por</div>--}%

%{--            <div class="span2">Criterio</div>--}%

%{--            <div class="span1">Ordenar</div>--}%

%{--        </div>--}%

%{--        <div>--}%
%{--            <div class="span2"><g:select name="buscarPor" class="buscarPor"--}%
%{--                                         from="['1': 'Provincia', '2': 'Cantón', '3': 'Parroquia', '4': 'Comunidad']"--}%
%{--                                         style="width: 120px" optionKey="key"--}%
%{--                                         optionValue="value"/></div>--}%

%{--            <div class="span2" style="margin-left: -20px"><g:textField name="criterio" class="criterio"/></div>--}%

%{--            <div class="span1"><g:select name="ordenar" class="ordenar" from="['1': 'Ascendente', '2': 'Descendente']"--}%
%{--                                         style="width: 120px; margin-left: 60px;" optionKey="key"--}%
%{--                                         optionValue="value"/></div>--}%

%{--            <div class="span2" style="margin-left: 140px"><button class="btn btn-info" id="btn-consultar"><i--}%
%{--                    class="icon-check"></i> Consultar--}%
%{--            </button></div>--}%

%{--        </div>--}%
%{--    </fieldset>--}%

%{--    <fieldset class="borde">--}%

%{--        <div id="divTabla" style="height: 460px; overflow-y:auto; overflow-x: auto;">--}%

%{--        </div>--}%

%{--    </fieldset>--}%

%{--</div>--}%

<g:if test="${obra?.id}">
    <div class="btn-group" style="margin-top: 10px;padding-left: 5px;float: left" align="center">

        <a href="#" id="btnVar" class="btn"><i class="fa fa-edit"></i> Variables</a>
        <a href="${g.createLink(controller: 'volumenObraOf', action: 'volObra', id: obra?.id)}" class="btn"><i
                class="fa fa-list"></i> Volúmenes de Obra
        </a>
%{--        <a href="#" id="matriz" class="btn"><i class="fa fa-table"></i> Matriz FP</a>--}%

%{--        <g:link controller="formulaPolinomica" action="insertarVolumenesItem" class="btn btnFormula"--}%
%{--                params="[obra: obra?.id]" title="Coeficientes">--}%
%{--            Fórmula Pol.--}%
%{--        </g:link>--}%

%{--        <a href="#" id="btnRubros" class="btn"><i class="fa fa-money-bill"></i> Rubros</a>--}%
%{--        <a href="${g.createLink(controller: 'cronograma', action: 'cronogramaObra', id: obra?.id)}" class="btn"><i--}%
%{--                class="fa fa-calendar"></i> Cronograma--}%
%{--        </a>--}%

%{--        <g:link controller="variables" action="composicion" id="${obra?.id}" class="btn"><i--}%
%{--                class="fa fa-paste"></i> Composición--}%
%{--        </g:link>--}%

        <a href="#" id="btnMapa" class="btn"><i class="fa fa-map-marker"></i> Mapa de la obra</a>
    </div>
</g:if>







%{--<g:if test="${obra?.id}">--}%
%{--    <div class="navbar navbar-inverse" style="margin-top: 10px;padding-left: 5px;float: left; width: 100%;"--}%
%{--         align="center">--}%
%{--        <div class="navbar-inner">--}%
%{--            <div class="botones">--}%
%{--                <ul class="nav">--}%
%{--                    <li><a href="#" id="btnVar"><i class="icon-pencil"></i>Variables</a></li>--}%
%{--                    <li><a href="${g.createLink(controller: 'volumenObra', action: 'volObra', id: obra?.id)}"><i--}%
%{--                            class="icon-list-alt"></i>Vol. Obra--}%
%{--                    </a></li>--}%
%{--                    <li><a href="#" id="matriz"><i class="icon-th"></i>Matriz FP</a></li>--}%
%{--                    <li>--}%
%{--                        <g:link controller="formulaPolinomica" action="insertarVolumenesItem" class="btnFormula"--}%
%{--                                params="[obra: obra?.id]" title="Coeficientes">--}%
%{--                            Fórmula Pol.--}%
%{--                        </g:link>--}%
%{--                    </li>--}%
%{--                    <li><a href="#" id="btnRubros"><i class="icon-money"></i>Rubros</a></li>--}%
%{--                    <li><a href="${g.createLink(controller: 'cronograma', action: 'cronogramaObra', id: obra?.id)}"><i--}%
%{--                            class="icon-calendar"></i>Cronograma--}%
%{--                    </a></li>--}%
%{--                    <li>--}%
%{--                        <g:link controller="variables" action="composicion" id="${obra?.id}"><i--}%
%{--                                class="icon-paste"></i>Composición--}%
%{--                        </g:link>--}%
%{--                    </li>--}%
%{--                    <li>--}%
%{--                        <a href="#" id="btnMapa"><i class="icon-flag"></i>Mapa</a>--}%
%{--                    </li>--}%
%{--                </ul>--}%
%{--            </div>--}%
%{--        </div>--}%
%{--    </div>--}%
%{--</g:if>--}%

<div id="modal-var">
    <div id="modal_body_var">

    </div>

    <div class="modal-footer" id="modal_footer_var">
    </div>
</div>

%{--<div class="modal hide fade" id="modal-var" style=";overflow: hidden;">--}%
%{--    <div class="modal-header btn-primary">--}%
%{--        <button type="button" class="close" data-dismiss="modal">×</button>--}%

%{--        <h3 id="modal_title_var">--}%
%{--        </h3>--}%
%{--    </div>--}%

%{--    <div class="modal-body" id="modal_body_var">--}%

%{--    </div>--}%

%{--    <div class="modal-footer" id="modal_footer_var">--}%
%{--    </div>--}%
%{--</div>--}%


<div class="modal hide fade mediumModal" id="modal-TipoObra" style=";overflow: hidden;">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle_tipo">
        </h3>
    </div>

    <div class="modal-body" id="modalBody_tipo">

    </div>

    <div class="modal-footer" id="modalFooter_tipo">
    </div>
</div>


<div class="modal grandote hide fade " id="modal-busqueda" style=";overflow: hidden;">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle_busqueda"></h3>
    </div>

    <div class="modal-body" id="modalBody">
        <bsc:buscador name="obra?.buscador.id" value="" accion="buscarObra" controlador="obra" campos="${campos}"
                      label="Obra" tipo="lista"/>
    </div>

    <div class="modal-footer" id="modalFooter_busqueda">
    </div>
</div>


<div id="estadoDialog">

    <fieldset>
        <div class="span4">
            Está seguro de querer cambiar el estado de la obra:<div style="font-weight: bold;">${obra?.nombre} ?

        </div>
            <br>
            <span style="color: red">
                Una vez registrada los datos de la obra no podrán ser editados.
            </span>

        </div>
    </fieldset>
</div>

<div id="listaObra" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 20px">

            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor col-md-12" from="${listaObra}" optionKey="key"
                          optionValue="value"/>
            </div>

            <div class="col-md-2">Criterio
            <g:textField name="buscarCriterio" id="criterioCriterio" style="width: 80%"/>
            </div>

            <div class="col-md-2">Ordenado por
            <g:select name="ordenar" class="ordenar" from="${listaObra}" style="width: 100%" optionKey="key"
                      optionValue="value"/>
            </div>
            <div class="col-md-2" style="margin-top: 6px">
                <button class="btn btn-info" id="cnsl-rubros"><i class="fa fa-search"></i> Buscar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaRbro" style="height: 460px; overflow: auto">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $("#migrarObra").click(function () {
        var id = ${obra?.id}
        bootbox.confirm({
            title: "Migrar Obra",
            message: '<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' +
              "Está seguro de importar esta obra a proyectos?" + '</strong>',
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
                    $.ajax({
                        type : "POST",
                        url : "${createLink(controller: "export", action: 'importarAProyectos')}",
                        data     : {
                            obra: id
                        },
                        success  : function (msg) {
                            if(msg === 'ok'){
                                log("Obra migrada a Proyectos correctamente", "success");
                            }else {
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' +
                                    '<strong style="font-size: 14px">' + "Error al migrar la obra" + '</strong>');
                            }

                        }
                    });
                }
            }
        });
    });

    $("#frm-registroObra").validate();

    function validarNum(ev) {
        /*
         48-57      -> numeros
         96-105     -> teclado numerico
         188        -> , (coma)
         190        -> . (punto) teclado
         110        -> . (punto) teclado numerico
         8          -> backspace
         46         -> delete
         9          -> tab
         37         -> flecha izq
         39         -> flecha der
         */
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
            ev.keyCode == 37 || ev.keyCode == 39);
    }

    $("#porcentajeAnticipo").keydown(function (ev) {

        return validarNum(ev);

    }).keyup(function () {

        var enteros = $(this).val();

        if (parseFloat(enteros) > 100) {

            $(this).val(100)

        }

    });

    $("#plazo").keydown(function (ev) {

        return validarNum(ev);

    }).keyup(function () {

        var enteros = $(this).val();

    });

    $("#latitud").bind({
        keydown: function (ev) {
            // esta parte valida el punto: si empieza con punto le pone un 0 delante, si ya hay un punto lo ignora
            if (ev.keyCode == 190 || ev.keyCode == 110) {
                var val = $(this).val();
                if (val.length == 0) {
                    $(this).val("0");
                }
                return val.indexOf(".") == -1;
            } else {
                // esta parte valida q sean solo numeros, punto, tab, backspace, delete o flechas izq/der
                return validarNum(ev);
            }
        }, //keydown
        keyup: function () {
            var val = $(this).val();
            // esta parte valida q no ingrese mas de 2 decimales
            var parts = val.split(".");
            if (parts.length > 1) {
                if (parts[1].length > 5) {
                    parts[1] = parts[1].substring(0, 5);
                    val = parts[0] + "." + parts[1];
                    $(this).val(val);
                }
            }

        }

    });

    $("#longitud").bind({
        keydown: function (ev) {
            // esta parte valida el punto: si empieza con punto le pone un 0 delante, si ya hay un punto lo ignora
            if (ev.keyCode == 190 || ev.keyCode == 110) {
                var val = $(this).val();
                if (val.length == 0) {
                    $(this).val("0");
                }
                return val.indexOf(".") == -1;
            } else {
                // esta parte valida q sean solo numeros, punto, tab, backspace, delete o flechas izq/der
                return validarNum(ev);
            }
        }, //keydown
        keyup: function () {
            var val = $(this).val();
            // esta parte valida q no ingrese mas de 2 decimales
            var parts = val.split(".");
            if (parts.length > 1) {
                if (parts[1].length > 5) {
                    parts[1] = parts[1].substring(0, 5);
                    val = parts[0] + "." + parts[1];
                    $(this).val(val);
                }
            }

        }

    });

    $(function () {
        <g:if test="${obra}">

        $(".plazo").blur(function () {
            var $m = $("#plazoEjecucionMeses");
            var $d = $("#plazoEjecucionDias");

            var valM = $m.val();
            var oriM = $m.data("original");

            var valD = $d.val();
            var oriD = $d.data("original");

            if (parseFloat(valM) == parseFloat(oriM) && parseFloat(valD) == parseFloat(oriD)) {
                $("#crono").val(0);
            } else {
                $.box({
                    imageClass: "box_info",
                    text: "Si cambia el plazo de la obra y guarda se eliminará el cronograma.<br/>Desea continuar?",
                    title: "Confirmación",
                    iconClose: false,
                    dialog: {
                        resizable: false,
                        draggable: false,
                        buttons: {
                            "Cancelar": function () {
                                $m.val(oriM);
                                $d.val(oriD);
                            },
                            "Sí": function () {
                                $("#crono").val(1);
                            },
                            "No": function () {
                                $m.val(oriM);
                                $d.val(oriD);
                            }
                        }
                    }
                });
            }
        });


        $("#ok_matiz").click(function () {
            var sp = $("#mtariz_sub").val();
            var tr = $("#si_trans").attr("checked");
//            console.log(sp,tr)
//                    if (sp != "-1")

            $("#dlgLoad").dialog("open");

            $.ajax({
                type: "POST",
                url: "${createLink(action: 'validaciones',controller: 'obraFP')}",
                data: "obra=${obra.id}&sub=" + sp + "&trans=" + tr,
                success: function (msg) {
                    $("#dlgLoad").dialog("close");
                    $("#modal-matriz").modal("hide")
                    if (msg != "ok") {
                        $.box({
                            imageClass: "box_info",
                            text: msg,
                            title: "Errores",
                            iconClose: false,
                            dialog: {
                                resizable: false,
                                draggable: false,
                                width: 900,
                                buttons: {
                                    "Aceptar": function () {
                                    }
                                }
                            }
                        });
                    } else {
                        location.href = "${g.createLink(controller: 'matriz',action: 'pantallaMatriz',params:[id:obra.id,inicio:0,limit:40])}"
                    }
                },
                error: function () {
                    $("#dlgLoad").dialog("close");
                    $("#modal-matriz").modal("hide");
                    $.box({
                        imageClass: "box_info",
                        text: "Ha ocurrido un error interno, comuniquese con el administrador del sistema.",
                        title: "Errores",
                        iconClose: false,
                        dialog: {
                            resizable: false,
                            draggable: false,
                            width: 700,
                            buttons: {
                                "Aceptar": function () {
                                }
                            }
                        }
                    });
                }
            });
        });
        </g:if>

        $("#lista").click(function () {
            $("#listaObra").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        });

        $("#listaObra").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 1000,
            height: 500,
            position: 'center',
            title: 'Obras'
        });

        $("#cnsl-rubros").click(function () {
            buscaObras();
        });

        function buscaObras() {
            var d = cargarLoader("Cargando...");
            var buscarPor = $("#buscarPor").val();
            var tipo = $("#buscarTipo").val();
            var criterio = $("#criterioCriterio").val();
            var ordenar = $("#ordenar").val();
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'obraOf', action:'listaObras')}",
                data: {
                    buscarPor: buscarPor,
                    buscarTipo: tipo,
                    criterio: criterio,
                    ordenar: ordenar,
                    tipo: "oferente"
                },
                success: function (msg) {
                    d.modal("hide");
                    $("#divTablaRbro").html(msg);
                }
            });
        }


        $("#nuevo").click(function () {
            location.href = "${g.createLink(action: 'registroObra')}";
        });

        $("#cancelarObra").click(function () {
            location.href = "${g.createLink(action: 'registroObra')}" + "?obra=" + "${obra?.id}";
        });

        $("#eliminarObra").click(function () {
            if (${obra?.id != null}) {
                $("#eliminarObraDialog").dialog("open");
            }

        });

        $("#cambiarEstado").click(function () {
            if (${obra?.id != null}) {
                $("#estadoDialog").dialog("open")
            }
        });

        $("#btnDocumentos").click(function () {

            if (${obra?.estado == 'R'}) {
                $("#dlgLoad").dialog("open");
                location.href = "${g.createLink(controller: 'documentosObra', action: 'documentosObra', id: obra?.id)}"
            }
            else {
                $("#documentosDialog").dialog("open")
            }
        });

        $("#btnMapa").click(function () {
            location.href = "${g.createLink(action: 'mapaObra', id: obra?.id)}"
        });

        $("#btn-aceptar").click(function () {
            $("#frm-registroObra").submit();
        });

        $("#btn-buscar").click(function () {
            $("#dlgLoad").dialog("close");
            $("#busqueda").dialog("open");
            return false;
//
        });
        $("#copiarObra").click(function () {
            $("#copiarDialog").dialog("open");
        });

        $("#btnRubros").click(function () {
            var url = "${createLink(controller:'reportes', action:'imprimirRubros')}?oferente=${session.usuario.id}&obra=${obra?.id}&transporte=";
            var urlVae= "${createLink(controller:'reportes', action:'imprimirRubrosVae')}?oferente=${session.usuario.id}&obra=${obra?.id}&transporte=";


            $.box({
                imageClass: "box_info",
                text: "Como desea imprimir los rubros de la obra?",
                title: "Impresión",
                iconClose: false,
                dialog: {
                    width: 400,
                    resizable: false,
                    draggable: false,
                    buttons: {

                        "Pdf": function () {
                            url += "0";
                            location.href = url;
                            %{--location.href = "${g.createLink(controller: 'pdf',action: 'pdfLink')}?url=" + url--}%
                        },
                        "Excel": function () {
                            var url = "${createLink(controller:'reportes', action:'imprimirRubrosExcel')}?oferente=${session.usuario.id}&obra=${obra?.id}&transporte=";
                            url += "1";
                            location.href = url;
                        },
                        "Pdf Vae": function () {
                            url += "0";
                            location.href = urlVae;
                        },
                        "Excel Vae": function () {
                            var urlExcelVae = "${createLink(controller:'reportes', action:'imprimirRubrosExcelVae')}?oferente=${session.usuario.id}&obra=${obra?.id}&transporte=";
                            urlExcelVae += "1";
                            location.href = urlExcelVae;

                        },
                        "Cancelar": function () {

                        }
                    }
                }
            });
            return false;
        });

        $("#btn-consultar").click(function () {
            $("#dlgLoad").dialog("open");
            busqueda();
        });

        $("#btnImprimir").click(function () {
            $("#dlgLoad").dialog("open");
            location.href = "${g.createLink(controller: 'reportes', action: 'reporteRegistro', id: obra?.id)}"
            $("#dlgLoad").dialog("close")
        });

        $("#btnVar").click(function () {
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'variablesOf', action:'variables_ajax')}",
                data: {
                    obra: "${obra?.id}"
                },
                success: function (msg) {
                    var btnCancel = $('<a href="#" data-dismiss="modal" class="btn btn-info"><i class="fa fa-times"></i> Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="fa fa-save"></i> Guardar</a>');

                    btnSave.click(function () {
                        if ($("#frmSave-var").valid()) {
                            // btnSave.replaceWith(spinner);
                        }
                        var data = $("#frmSave-var").serialize() + "&id=" + $("#id").val()+"&lang=en_US";
                        var url = $("#frmSave-var").attr("action");

                        $.ajax({
                            type: "POST",
                            url: url,
                            data: data,
                            success: function (msg) {
                                var parts = msg.split("_");
                                if(parts[0] === 'no'){
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                                }else{
                                    log(parts[1], "success");
                                    $("#modal-var").dialog("close");
                                }
                            }
                        });

                        return false;
                    });

                    btnCancel.click(function () {
                        $("#modal-var").dialog("close");
                    });

                    $("#modal_title_var").html("Variables");
                    $("#modal_body_var").html(msg);

                    <g:if test="${obra?.estado !='R'}">
                    $("#modal_footer_var").html("").append(btnCancel).append(btnSave);
                    </g:if>
                    <g:else>
                    $("#modal_footer_var").html("").append(btnCancel);
                    </g:else>

                    $("#modal-var").dialog("open");
                    $(".ui-dialog-titlebar-close").html("x")
                }
            });
            return false;
        });

        $("#modal-var").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 600,
            height: 500,
            position: 'center',
            title: 'Variables'
        });

        $("#copiarDialog").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 380,
            height: 280,
            position: 'center',
            title: 'Copiar la obra',
            buttons: {
                "Aceptar": function () {

                    var originalId = "${obra?.id}";
                    var nuevoCodigo = $.trim($("#nuevoCodigo").val());

                    $.ajax({
                        type: "POST",
                        url: "${createLink(action: 'saveCopia')}",
                        data: {
                            id: originalId,
                            nuevoCodigo: nuevoCodigo

                        },
                        success: function (msg) {

                            $("#copiarDialog").dialog("close")
                            var parts = msg.split('_')
                            if (parts[0] == 'NO') {

                                $("#spanError").html(parts[1]);
                                $("#divError").show()
                            } else {

                                $("#divError").hide()
                                $("#spanOk").html(parts[1]);
                                $("#divOk").show()

                            }

                        }
                    });

                },
                "Cancelar": function () {

                    $("#copiarDialog").dialog("close");

                }
            }


        });

        $("#busqueda").dialog({

            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 800,
            height: 600,
            position: 'center',
            title: 'Datos de Situación Geográfica'

        });

        $("#estadoDialog").dialog({

            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 450,
            height: 260,
            position: 'center',
            title: 'Cambiar estado de la Obra',
            buttons: {
                "Aceptar": function () {
//
                    var estadoCambiado = $("#estado").val();

                    %{--var estadoCambiado1 = ${obra?.estado}--}%

                    %{--console.log(${obra?.estado})--}%

                    if (${obra?.estado == 'N'}) {
//                        estadoCambiado = 'R';
                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(controller: 'obraOf', action: 'regitrarObra')}",
                            data: "id=${obra?.id}",
                            success: function (msg) {
                                console.log(msg)
                                if (msg != "ok") {
                                    $.box({
                                        imageClass: "box_info",
                                        text: msg,
                                        title: "Errores",
                                        iconClose: false,
                                        dialog: {
                                            resizable: false,
                                            draggable: false,
                                            width: 900,
                                            buttons: {
                                                "Aceptar": function () {
                                                }
                                            }
                                        }
                                    });
                                } else {
                                    location.reload(true)
                                }
                            }
                        });
//
                    } else {
                        estadoCambiado = 'N';
                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(controller: 'obraOf', action: 'desregitrarObra')}",
                            data: "id=${obra?.id}",
                            success: function (msg) {
                                if (msg != "ok") {
                                    $.box({
                                        imageClass: "box_info",
                                        text: msg,
                                        title: "Errores",
                                        iconClose: false,
                                        dialog: {
                                            resizable: false,
                                            draggable: false,
                                            width: 900,
                                            buttons: {
                                                "Aceptar": function () {
                                                }
                                            }
                                        }
                                    });
                                } else {
                                    location.reload(true)
                                }
                            }
                        });
//
                    }
//                            $(".estado").val(estadoCambiado);
                    $("#estadoDialog").dialog("close");
//
                },
                "Cancelar": function () {
                    $("#estadoDialog").dialog("close");
                }
            }

        });

        $("#documentosDialog").dialog({

            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 350,
            height: 180,
            position: 'center',
            title: 'Imprimir Documentos de la Obra',
            buttons: {
                "Aceptar": function () {

                    $("#documentosDialog").dialog("close");

                }
            }

        });

        $(".btnFormula").click(function () {
            var url = $(this).attr("href");
            $("#dlgLoad").dialog("open");
            $.ajax({
                type: "POST",
                url: url,
                success: function (msg) {
                    if (msg == "ok" || msg == "OK") {
                        location.href = "${createLink(controller: 'formulaPolinomica', action: 'coeficientes', id:obra?.id)}";
                    }
                }
            });

            return false;
        });

        var url = "${resource(dir:'images', file:'spinner_24.gif')}";
        var spinner = $("<img style='margin-left:15px;' src='" + url + "' alt='Cargando...'/>");

        function submitForm(btn) {
            if ($("#frmSave-TipoObra").valid()) {
                btn.replaceWith(spinner);
            }
            $("#frmSave-TipoObra").submit();
        }

        $("#btnCrearTipoObra").click(function () {

            $.ajax({
                type: "POST",
                url: "${createLink(action:'crearTipoObra')}",
                success: function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-save"></i> Guardar</a>');

                    btnSave.click(function () {
//                            submitForm(btnSave);
                        $(this).replaceWith(spinner);
                        $.ajax({
                            type: "POST",
                            url: "${createLink(controller: 'tipoObra', action:'saveTipoObra')}",
                            data: $("#frmSave-TipoObra").serialize(),
                            success: function (msg) {
                                if (msg != 'error') {
                                    $("#divTipoObra").html(msg);
                                }

                                $("#modal-TipoObra").modal("hide");
                            }
                        });

                        return false;
                    });

                    $("#modalHeader_tipo").removeClass("btn-edit btn-show btn-delete");
                    $("#modalTitle_tipo").html("Crear Tipo de Obra");
                    $("#modalBody_tipo").html(msg);
                    $("#modalFooter_tipo").html("").append(btnOk).append(btnSave);
                    $("#modal-TipoObra").modal("show");
                }
            });
            return false;

        });

        $("#eliminarObraDialog").dialog({

            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 350,
            height: 220,
            position: 'center',
            title: 'Eliminar Obra',
            buttons: {
                "Aceptar": function () {

                    if (${volumen?.id != null || formula?.id != null}) {

                        $("#noEliminarDialog").dialog("open")

                    }

                    else {

                        $.ajax({
                            type: "POST",
                            url: "${createLink(action: 'delete')}",
                            data: "id=${obra?.id}",
                            success: function (msg) {

                                if (msg == 'ok') {

                                    location.href = "${createLink(action: 'registroObra')}"

                                } else {

                                }

                            }
                        });

                    }

                    $("#eliminarObraDialog").dialog("close")

                },
                "Cancelar": function () {

                    $("#eliminarObraDialog").dialog("close")

                }

            }

        });

        $("#noEliminarDialog").dialog({

            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 350,
            height: 220,
            position: 'center',
            title: 'No se puede Eliminar la Obra!',
            buttons: {
                "Aceptar": function () {

                    $("#eliminarObraDialog").dialog("close");
                    $("#noEliminarDialog").dialog("close");

                }
            }


        });

        function busqueda() {

            var buscarPor = $("#buscarPor").val();
            var criterio = $(".criterio").val();

            var ordenar = $("#ordenar").val();

//                   console.log("buscar" + buscarPor)
//                    console.log("criterio" + criterio)
//                    console.log("ordenar" + ordenar)

            $.ajax({
                type: "POST",
                url: "${createLink(action:'situacionGeografica')}",
                data: {
                    buscarPor: buscarPor,
                    criterio: criterio,
                    ordenar: ordenar

                },
                success: function (msg) {

                    $("#divTabla").html(msg);
                    $("#dlgLoad").dialog("close");
                }
            });

        }

    });
</script>

</body>
</html>