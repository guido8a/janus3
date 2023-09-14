<%@ page import="janus.pac.Concurso; janus.Contrato; janus.pac.Oferta" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Lista de Procesos
    </title>

    <style>
    td {
        line-height: 12px !important;
    }

    .row {
        height: 35px;;
    }

    .tab-content {
        padding: 10px;
        border: solid 1px #555;
    }

    #myTab {
        margin-bottom: 0;
        border: solid 1px #555;
    }

    .red .active a,
    .red .active a:hover {
        background-color: #6f5437;
        color: #ffffff;
    }
    </style>
</head>

<body>

<g:if test="${flash.message}">
    <div class="col-md-12">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            <elm:poneHtml textoHtml="${flash.message}"/>
        </div>
    </div>
</g:if>
<input type="hidden" id="con_id" value="${concursoInstance?.id}">

<div class="row" style="margin-bottom: 10px;">
    <div class="col-md-9 btn-group" role="navigation">
        <g:link controller="concurso" action="list" class="btn btn-info">
            <i class="fa fa-arrow-left"></i> Regresar
        </g:link>
        <g:if test="${concursoInstance.estado != 'R'}">
            <a href="#" class="btn btn-success" id="btnSave">
                <i class="fa fa-save"></i> Guardar
            </a>
        </g:if>
        <g:if test="${concursoInstance}">
            <a href="#" class="btn" id="btnRegi"><i class="fa fa-check"></i> Cambiar Estado</a>
        </g:if>
    </div>
</div>


<div style="border-bottom: 1px solid black;padding-left: 50px;position: relative;height: 150px;margin-bottom: 10px;">
    <p class="css-vertical-text" style="font-size: 30px;margin-left: -7px">
        <span id="msg">P A C</span>
    </p>

    <div class="linea" style="height: 100%"></div>

    <div class="row">
        <div class="col-md-12">
            <span class="col-md-2 badge" style="width: 135px;">
                Tipo Procedimiento:
            </span>

            <div class="controls col-md-2">
                ${concursoInstance?.pac?.tipoProcedimiento?.descripcion}
            </div>
            <span class="badge col-md-2" style="width: 100px;">
                Tipo Compra:
            </span>

            <div class="controls col-md-1">
                ${concursoInstance?.pac?.tipoCompra?.descripcion}
            </div>
            <span class="badge col-md-1">
                Código cp:
            </span>

            <div class="controls col-md-1" title=" ${concursoInstance?.pac?.cpp?.descripcion}">
                ${concursoInstance?.pac?.cpp?.numero}
            </div>
        </div>
    </div>

    <div class="row" style="margin-top: 0px">
        <div class="col-md-12">
            <span class="badge col-md-1">
                Partida:
            </span>

            <div class="controls col-md-11" title="">
                ${concursoInstance?.pac?.presupuesto?.numero} (${concursoInstance?.pac?.presupuesto?.descripcion})
            </div>
        </div>
    </div>

    <div class="row" style="margin-top: 0px">
        <div class="col-md-12">
            <span class="badge col-md-1">
                Descripción:
            </span>

            <div class="controls col-md-11" title="">
                ${concursoInstance?.pac?.descripcion}
            </div>
        </div>
    </div>

    <div class="row" style="margin-top: 0px">
        <div class="col-md-10">
            <span class="badge col-md-1">
                Cantidad:
            </span>

            <div class="controls col-md-1" title="">
                ${concursoInstance?.pac?.cantidad}
            </div>
            <span class="badge col-md-1">
                Unidad:
            </span>

            <div class="controls col-md-1" title="">
                ${concursoInstance?.pac?.unidad?.descripcion}
            </div>
            <span class="badge col-md-1">
                Precio U.:
            </span>

            <div class="controls col-md-1" title="">
                <g:formatNumber number="${concursoInstance?.pac?.costo?.round(2)}" type="number"/>
            </div>
            <span class="badge col-md-1">
                Total:
            </span>

            <div class="controls col-md-1" title="">
                <g:formatNumber number="${(concursoInstance?.pac?.costo * concursoInstance?.pac?.cantidad)?.round(2)}"
                                type="number"/>
            </div>
        </div>
    </div>
</div>

<div style="border-bottom: 1px solid black;padding-left: 40px;position: relative;margin-bottom: 10px; height: 440px">
    <p class="css-vertical-text">Proceso de contratación</p>

    <div class="linea" style="height: 100%"></div>

    <g:form class="form-horizontal" name="frmSave-Concurso" action="save" id="${concursoInstance?.id}">
        <ul class="nav nav-pills red ui-corner-top" id="myTab">
            <li class="active"><a href="#datos" style="padding-left: 30px; padding-right: 30px">Datos proceso</a></li>
            <li><a href="#fechas" style="padding-left: 30px; padding-right: 30px">Fechas del proceso</a></li>
        </ul>

        <div class="tab-content ui-corner-bottom" style="height: 385px">
            <div class="tab-pane active" id="datos">

                <div class="row">
                    <div class="col-md-7">
                        <span class="badge col-md-4">
                            Prefecto
                        </span>

                        <div class="controls col-md-8">
                            <g:hiddenField name="administracion.id" value="${concursoInstance?.administracion?.id}"/>
                            ${concursoInstance?.administracion?.nombrePrefecto}
                        </div>
                    </div>

                    <div class="col-md-5">
                        <div class="control-group">
                            <div>
                                <span class="badge col-md-3">
                                    Estado
                                </span>
                            </div>

                            <div class="controls col-md-1">
                                <g:hiddenField name="estado" value="${concursoInstance?.estado}"/>
                                ${concursoInstance?.estado == 'R' ? 'Registrado' : 'No registrado'}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row" style="margin-top: -10px">
                    <div class="col-md-12" style="margin-top: 10px">
                        <div class="control-group">
                            <div>
                                <span class="badge col-md-2">
                                    Objeto
                                </span>
                            </div>

                            <div class="controls col-md-10">
                                <g:textArea name="objeto" class="col-md-12" style="resize: vertical; height: 80px"
                                            value="${concursoInstance?.objeto}"/>
                                <p class="help-block ui-helper-hidden"></p>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="control-group col-md-7" style="margin-top: 10px">
                        <div>
                            <span class="badge col-md-4">
                                Número de certificación:
                            </span>
                        </div>

                        <div class="controls col-md-8" style="margin-left: 0px; padding-right: 0px">
                            <g:textField name="numeroCertificacion"
                                         value="${concursoInstance?.numeroCertificacion ?: '0000'}" style="width: 50px;"
                                         maxlength="4"/> (Número de certificación de disponibilidad de fondos)
                        </div>
                    </div>

                    <div class="control-group col-md-5" style="margin-top: 10px">
                        <div>
                            <span class="badge col-md-4">
                                Código
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <g:textField name="codigo" value="${concursoInstance?.codigo}" maxlength="20"
                                         class="allCaps required"/>
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="control-group col-md-7" style="margin-top: 10px">
                        <div>
                            <span class="badge col-md-4">
                                Memo Certificación Fondos
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <g:textField name="memoCertificacionFondos"
                                         value="${concursoInstance?.memoCertificacionFondos}" style="text-align: left;"
                                         class="allCaps"/>

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>


                    <div class="control-group col-md-5" style="margin-top: 10px">
                        <div>
                            <span class="badge col-md-4">
                                Costo Bases
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input type="radio" name="costo" id="rbt_costoBases"
                                ${(concursoInstance.costoBases > 0 || (concursoInstance.costoBases == 0 &&
                                        concursoInstance.porMilBases == 0) || !concursoInstance.costoBases || !concursoInstance.porMilBases) ? "checked" : ""}/>
                            <g:field type="text" name="costoBases" class="input-mini" style="width: 60px"
                                     value="${concursoInstance.costoBases == null ? 200 : concursoInstance.costoBases}"/>
                            <input type="radio" name="costo"
                                   id="rbt_porMilBases" ${concursoInstance.porMilBases > 0 ? "checked" : ""}/>
                            <g:field type="text" name="porMilBases" class="input-mini" style="width: 60px"
                                     value="${concursoInstance.porMilBases ?: 0}"/> x 1000
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="control-group col-md-7" style="margin-top: 10px">
                        <div>
                            <span class="badge col-md-4">
                                Memo SIF.
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <g:textField name="memoSif" value="${concursoInstance?.memoSif}" class="allCaps"/>
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>


                    <div class="control-group col-md-5" style="margin-top: 10px">
                        <div>
                            <span class="badge col-md-4">
                                Memo de requerimiento
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <g:textField name="memoRequerimiento" value="${concursoInstance?.memoRequerimiento}"
                                         class="allCaps"/>
                            <p class="help-block ui-helper-hidden allCaps"></p>
                        </div>
                    </div>

                </div>

                <div class="row">
                    <div class="control-group col-md-7" style="margin-top: 10px">
                        <div>
                            <span class="badge col-md-4">
                                Obra requerida
                            </span>
                        </div>

                        <div class="controls col-md-6">
                            <input type="hidden" id="obra_id" name="obra.id" value="${concursoInstance?.obra?.id}">
                            <input type="text" id="obra_busqueda" value="${concursoInstance?.obra?.codigo}"
                                   title="${concursoInstance?.obra?.nombre}" readonly>

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                    <div class="control-group col-md-5" style="margin-top: 10px">
                        <div>
                            <span class="badge col-md-4">
                                Monto referencial
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <div class="input-append">
                                <g:field type="text" name="presupuestoReferencial" id="presupuestoReferencial" class="required number"
                                         value="${concursoInstance?.presupuestoReferencial ?: 0}"
                                         style="text-align: right;width: 120px;"/>
                                <span class="add-on">$</span>
                            </div>

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                </div>


                <div class="row">
                    <div class="control-group col-md-12">
                        <div>
                            <span class="badge col-md-2">
                                Observaciones
                            </span>
                        </div>

                        <div class="controls col-md-10">
                            <g:textField name="observaciones" class="col-md-12"
                                         value="${concursoInstance?.observaciones}"/>
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>
                </div> <!-- fin tab datos -->
            </div> <!-- fin tab datos -->

            <div class="tab-pane" id="fechas">

                <g:set var="minHour" value="${8}"/>
                <g:set var="maxHour" value="${20}"/>
                <g:set var="stepMin" value="${10}"/>

                <div class="row" style="margin-top:10px">
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Publicación
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaPublicacion" id='fecha1' type='text' class="input-small" value="${concursoInstance?.fechaPublicacion?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Inicio Evaluación Oferta
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaInicioEvaluacionOferta" id='fecha2' type='text' class="input-small" value="${concursoInstance?.fechaInicioEvaluacionOferta?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>
                </div>

                <div class="row" style="margin-top:10px">
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Aceptación proveedor
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaAceptacionProveedor" id='fecha3' type='text' class="input-small" value="${concursoInstance?.fechaAceptacionProveedor?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Límite resultados finales
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaLimiteResultadosFinales" id='fecha4' type='text' class="input-small" value="${concursoInstance?.fechaLimiteResultadosFinales?.format("dd-MM-yyyy HH:mm")}" />
                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>
                </div>

                <div class="row" style="margin-top:10px">
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Límite Preguntas
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaLimitePreguntas" id='fecha5' type='text' class="input-small" value="${concursoInstance?.fechaLimitePreguntas?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Adjudicación
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaAdjudicacion" id='fecha6' type='text' class="input-small" value="${concursoInstance?.fechaAdjudicacion?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                </div>

                <div class="row" style="margin-top:10px">

                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Límite Respuestas
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaLimiteRespuestas" id='fecha7' type='text' class="input-small" value="${concursoInstance?.fechaLimiteRespuestas?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Inicio
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaInicio" id='fecha8' type='text' class="input-small" value="${concursoInstance?.fechaInicio?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>


                </div>

                <div class="row" style="margin-top:10px">
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Límite Entrega Ofertas
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaLimiteEntregaOfertas" id='fecha9' type='text' class="input-small" value="${concursoInstance?.fechaLimiteEntregaOfertas?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Calificación
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaCalificacion" id='fecha10' type='text' class="input-small" value="${concursoInstance?.fechaCalificacion?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                </div>

                <div class="row" style="margin-top:10px">
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Apertura Ofertas
                            </span>
                        </div>

                        <div class="controls col-md-8">

                            <input aria-label="" name="fechaAperturaOfertas" id='fecha11' type='text' class="input-small" value="${concursoInstance?.fechaAperturaOfertas?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Inicio Puja
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaInicioPuja" id='fecha12' type='text' class="input-small" value="${concursoInstance?.fechaInicioPuja?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                </div>

                <div class="row" style="margin-top:10px">
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Solicitar Convalidación
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaLimiteSolicitarConvalidacion" id='fecha13' type='text' class="input-small" value="${concursoInstance?.fechaLimiteSolicitarConvalidacion?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Fin Puja
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaFinPuja" id='fecha14' type='text' class="input-small" value="${concursoInstance?.fechaFinPuja?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>


                </div>

                <div class="row" style="margin-top:10px">
                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Recibir Convalidación
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaLimiteRespuestaConvalidacion" id='fecha15' type='text' class="input-small" value="${concursoInstance?.fechaLimiteRespuestaConvalidacion?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                    <div class="control-group col-md-6">
                        <div>
                            <span class="badge col-md-4">
                                Notificación adjudicación
                            </span>
                        </div>

                        <div class="controls col-md-8">
                            <input aria-label="" name="fechaNotificacionAdjudicacion" id='fecha16' type='text' class="input-small" value="${concursoInstance?.fechaNotificacionAdjudicacion?.format("dd-MM-yyyy HH:mm")}" />

                            <p class="help-block ui-helper-hidden"></p>
                        </div>
                    </div>

                </div> <!-- fin col 1 -->



            %{--</div>--}%
            </div> <!-- fin tab fechas -->

            <div class="tab-pane" id="fechas2">
                %{--<div id="cols" style="float: left;">--}%
                <div class="row" style="margin: 10px;">
                    <div class="col-md-5">
                        <a href="#" id="tramites" class="btn btn-primary">
                            <i class="icon-search"></i> Ver tramites S.A.D.
                        </a>
                    </div>
                </div>

                <fielset id="desc_prep"
                         style="padding-bottom: 10px;border: 1px solid #000000;width: 95%;float: left;margin-left: 33px;padding: 10px;margin-bottom: 20px;"
                         class="ui-corner-all">
                    <legend style="color:#876945;border-color: #6f5437;cursor: pointer" id="label_prep" class="active"
                            title="Minimizar">Etapa Preparatoria <i class="icon-arrow-down" style="cursor: pointer"
                                                                    title="Mostrar seguimiento"></i></legend>

                    <div class="row" style="">
                        <div class="col-md-6">
                            <div class="control-group">
                                <div>
                                    <span class="badge">
                                        Fecha Inicio Preparatorio
                                    </span>
                                </div>

                                <div class="controls">
                                    <input aria-label="" name="fechaInicioPreparatorio" id='fecha17' type='text' class="input-small" value="${concursoInstance?.fechaInicioPreparatorio?.format("dd-MM-yyyy HH:mm")}" />

                                    <g:if test="${concursoInstance?.fechaInicioPreparatorio == null}">
                                        <a class="btn btn-small btn-primary btn-ajax" href="#" rel="tooltip"
                                           title="Empezar preparatorio" id="inicio_prep" style="margin-left: 5px;">
                                            <i class="icon-check"></i>
                                        </a>
                                    </g:if>
                                    <div id="info_prep" style="width: 200px;float: left;margin-left: 10px;">
                                        <span style="color: ${(duracionPrep < maxPrep) ? 'green' : 'red'}">
                                            <g:if test="${concursoInstance.fechaInicioPreparatorio != null}">

                                                <g:if test="${duracionPrep < maxPrep}">
                                                    <g:if test="${maxPrep - duracionPrep < 2}">
                                                        <div class="amarillo"></div>
                                                    </g:if>
                                                    <g:else>
                                                        <div class="verde"></div>
                                                    </g:else>
                                                </g:if>
                                                <g:else>
                                                    <g:set var="retraso"
                                                           value="- ${((new Date()) - (concursoInstance?.fechaInicioPreparatorio + maxPrep))} días de retraso"/>
                                                    <div class="rojo" title="Retrasado"></div>
                                                </g:else>
                                                <g:if test="${concursoInstance?.fechaFinPreparatorio == null}">
                                                    En curso ${retraso}
                                                </g:if>
                                                <g:else>
                                                    Terminado
                                                </g:else>

                                            </g:if>
                                        </span>
                                    </div>

                                    <p class="help-block ui-helper-hidden"></p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4">
                            <div class="control-group">
                                <div>
                                    <span class="badge">
                                        Fecha Fin Preparatorio
                                    </span>
                                </div>

                                <div class="controls">
                                    <input aria-label="" name="fechaFinPreparatorio" id='fecha18' type='text' class="input-small" value="${concursoInstance?.fechaFinPreparatorio?.format("dd-MM-yyyy HH:mm")}" />
                                    <p class="help-block ui-helper-hidden"></p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-11 hide_prep"
                         style="height: 20px;margin: 10px;margin-left: 30px;margin-bottom: 20px;">
                        <div class="col-md-3"
                             style="background: ${(concursoInstance?.fechaEtapa1 != null) ? '#feff6d' : 'gray'};margin: 0px;height: 15px;border-right: 2px solid black;text-align: center;font-weight: bold">Etapa 1 ${concursoInstance?.fechaEtapa1?.format("dd-MM-yyyy")}</div>

                        <div class="col-md-5"
                             style="background:  ${(concursoInstance?.fechaEtapa2 != null) ? '#feff6d' : 'gray'};margin: 0px;height: 15px;border-right: 2px solid black;text-align: center;font-weight: bold">Etapa 2 ${concursoInstance?.fechaEtapa2?.format("dd-MM-yyyy")}</div>

                        <div class="col-md-3"
                             style="background:  ${(concursoInstance?.fechaEtapa3 != null) ? '#feff6d' : 'gray'};margin: 0px;height: 15px;border-right: 2px solid black;text-align: center;font-weight: bold">Etapa 3 ${concursoInstance?.fechaEtapa3?.format("dd-MM-yyyy")}</div>
                    </div>
                    <fieldset class="col-md-11 ui-corner-all hide_prep" id="seguimiento"
                              style="padding: 0px;margin-left: 0px;">
                        <legend style="border:none;background: none;">Seguimiento del tramite</legend>
                    </fieldset>

                </fielset>

                <div class="row">
                    <div class="col-md-6">

                        <div class="control-group">
                            <div>
                                <span class="badge">
                                    Fecha Inicio Precontractual
                                </span>
                            </div>

                            <div class="controls">
                                <input aria-label="" name="fechaInicioPrecontractual" id='fecha19' type='text' class="input-small" value="${concursoInstance?.fechaInicioPrecontractual?.format("dd-MM-yyyy HH:mm")}" />

                                <p class="help-block ui-helper-hidden"></p>
                            </div>
                        </div>

                        <div class="control-group">
                            <div>
                                <span class="badge">
                                    Fecha Inicio Contractual
                                </span>
                            </div>

                            <div class="controls">
                                %{--                        <elm:datepicker name="fechaInicioContractual" class=""--}%
                                %{--                                        value="${concursoInstance?.fechaInicioContractual}"--}%
                                %{--                                        style="width:130px;"/>--}%
                                <input aria-label="" name="fechaInicioContractual" id='fecha20' type='text' class="input-small" value="${concursoInstance?.fechaInicioContractual?.format("dd-MM-yyyy HH:mm")}" />

                                <p class="help-block ui-helper-hidden"></p>
                            </div>
                        </div>

                    </div> <!-- fin col 1 -->

                    <div class="col-md-5">

                        <div class="control-group">
                            <div>
                                <span class="badge">
                                    Fecha Fin Precontractual
                                </span>
                            </div>

                            <div class="controls">
                                %{--                        <elm:datepicker name="fechaFinPrecontractual" class=""--}%
                                %{--                                        value="${concursoInstance?.fechaFinPrecontractual}"--}%
                                %{--                                        style="width:130px;"/>--}%
                                <input aria-label="" name="fechaFinPrecontractual" id='fecha21' type='text' class="input-small" value="${concursoInstance?.fechaFinPrecontractual?.format("dd-MM-yyyy HH:mm")}" />

                                <p class="help-block ui-helper-hidden"></p>
                            </div>
                        </div>

                        <div class="control-group">
                            <div>
                                <span class="badge">
                                    Fecha Fin Contractual
                                </span>
                            </div>

                            <div class="controls">
                                <input aria-label="" name="fechaFinContractual" id='fecha22' type='text' class="input-small" value="${concursoInstance?.fechaFinContractual?.format("dd-MM-yyyy HH:mm")}" />
                                <p class="help-block ui-helper-hidden"></p>
                            </div>
                        </div>
                    </div> <!-- fin col 2-->
                </div>
            </div> <!-- fin tab fechas2 -->
        </div>
    </g:form>
</div>

<div class="modal grandote hide fade" id="modal-busqueda" style="overflow: hidden">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">x</button>

        <h3 id="modalTitle_busqueda"></h3>

    </div>

    <div class="modal-body" id="modalBody">
        <bsc:buscador name="obras" value="" accion="buscarObra" controlador="concurso" campos="${campos}" label="Obras"
                      tipo="lista"/>

    </div>

    <div class="modal-footer" id="modalFooter_busqueda">

    </div>

</div>

<div class="modal grandote hide fade " id="modal-tramite" style=";overflow: hidden;">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle_tramite">Tramites</h3>
    </div>

    <div class="modal-body" id="modal-tramite-body">

    </div>

    <div class="modal-footer" id="modalTramite_busqueda">
    </div>
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
                <button class="btn btn-info" id="cnsl-obras"><i class="fa fa-search"></i> Consultar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaObra" style="height: 460px; overflow: auto">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $("#cnsl-obras").click(function () {
        buscaObras();
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

    function buscaObras() {
        var buscarPor = $("#buscarPor").val();
        var tipo = $("#buscarTipo").val();
        var criterio = $("#criterioCriterio").val();
        var ordenar = $("#ordenar").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'concurso', action:'tablaObras_ajax')}",
            data: {
                buscarPor: buscarPor,
                buscarTipo: tipo,
                criterio: criterio,
                ordenar: ordenar
            },
            success: function (msg) {
                $("#divTablaObra").html(msg);
            }
        });
    }

    $('#fecha1, #fecha2, #fecha3, #fecha4, #fecha5, #fecha6, #fecha7, #fecha8, #fecha9, #fecha10, #fecha11, #fecha12, #fecha13, #fecha14, #fecha15, #fecha16, #fecha17, #fecha18, #fecha19, #fecha20, #fecha21, #fecha22').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY HH:mm',
        // minDate: moment({hour: 9, minute: 30}),
        sideBySide: true,
        icons: {
        }
    });

    function cargarDatos() {
        $.ajax({
            type: "POST", url: "${g.createLink(controller: 'concurso',action:'datosObra')}",
            data: "obra=" + $("#obra_id").val(),
            success: function (msg) {
                var parts = msg.split("&&");
                $("#presupuestoReferencial").val(parts[3]);
                $("#obra_busqueda").val(parts[0]).attr("title", parts[1]);
            }
        });
    }

    $('#myTab a').click(function (e) {
        e.preventDefault();
        $(this).tab('show');
    });

    $("#label_prep").click(function () {
        if ($(this).hasClass("active")) {
            $(".hide_prep").hide();
            $(this).removeClass("active");
            $(this).attr("title", "Maximizar")
        } else {
            $(".hide_prep").show("slide");
            $(this).addClass("active");
            $(this).attr("title", "Minimizar")
        }
    });

    $("[name=costo]").click(function () {
        var id = $(this).attr("id");
        var p = id.split("_");
        id = p[1];
        if (id === "porMilBases") {
            $("#costoBases").val(0);
        } else {
            $("#porMilBases").val(0);
        }
    });

    $("#inicio_prep").click(function () {
        var memo = $("#memoRequerimiento").val().trim();
        var fecha = $("#fechaInicioPreparatorio").val();
        var error = "";
        if (memo === "") {
            error = "<br>Primero ingrese un memorando de requerimiento"
        }
        if (fecha === "") {
            error += "<br>Seleccione una fecha de inicio"
        }

        if (error === "") {
            $.ajax({
                type: "POST",
                url: "${g.createLink(action:'iniciarPreparatorio',controller: 'concurso')}",
                data: "id=${concursoInstance?.id}&memo=" + memo + "&fecha=" + fecha,
                success: function (msg) {
                    if (msg === "ok") {
                        window.location.reload(true)
                    }
                }
            });
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + error + '</strong>');
        }

    });

    $("#frmSave-Concurso").validate({
        errorPlacement: function (error, element) {
            element.parent().find(".help-block").html(error).show();
        },
        success: function (label) {
            label.parent().hide();
        },
        errorClass: "label label-important",
        submitHandler: function (form) {
            $(".btn-success").replaceWith(spinner);
            form.submit();
        }
    });

    $("#obra_busqueda").dblclick(function () {
        $("#listaObra").dialog("open");
        $(".ui-dialog-titlebar-close").html("x")
        // var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
        // $("#modalTitle_busqueda").html("Lista de obras");
        // $("#modalFooter_busqueda").html("").append(btnOk);
        // $("#modal-busqueda").modal("show");
        // $("#contenidoBuscador").html("")
    });

    $("#btnSave").click(function () {
        $("#frmSave-Concurso").submit();
    });

    $("input").keyup(function (ev) {
        if (ev.keyCode === 13) {
            submitForm($(".btn-success"));
        }
    });

    $("#btnRegi").click(function () {
        var obraId = $.trim($("#obra_id").val());
        if (obraId !== "") {
            var esta = $("#estado").val();
            if (esta === 'R') {
                $("#estado").val("N");
            } else {
                $("#estado").val("R");
            }
            $("#frmSave-Concurso").submit();
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione una obra" + '</strong>');
        }

    });
    $("#tramites").click(function () {
        $.ajax({
            type: "POST",
            url: "${g.createLink(action:'verTramitesAjax',controller: 'tramite',id: concursoInstance?.memoRequerimiento)}",
            success: function (msg) {
                $("#modal-tramite-body").html(msg);
                $("#modal-tramite").modal("show");
            }
        });
    })

</script>
</body>
</html>
