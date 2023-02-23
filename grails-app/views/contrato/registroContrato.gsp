<%@ page import="janus.Contrato; janus.ejecucion.FormulaPolinomicaContractual; janus.ejecucion.TipoPlanilla" contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">
    %{--<script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'jquery.validate.min.js')}"></script>--}%
    %{--<script src="${resource(dir: 'js/jquery/plugins/jquery-validation-1.9.0', file: 'messages_es.js')}"></script>--}%

    %{--<script src="${resource(dir: 'js/jquery/plugins/', file: 'jquery.livequery.js')}"></script>--}%
    %{--<script src="${resource(dir: 'js/jquery/plugins/box/js', file: 'jquery.luz.box.js')}"></script>--}%
    %{--<link href="${resource(dir: 'js/jquery/plugins/box/css', file: 'jquery.luz.box.css')}" rel="stylesheet">--}%

    <style type="text/css">

    .formato {
        font-weight : bolder;
    }

    .caps {
        text-transform : uppercase;
    }
    .help-block {
        color: #f00;
    }

    .comple{
        background-color: #254897;
    }
    .contratado{
        background-color: #3d9794;
    }

    .adm{
        color: #fff;
        background-color: #5a7ab2;
    }
    </style>


    <title>Registro de Contratos</title>
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


<div class="row">

    %{--<div class="col-md-12 btn-group" role="navigation" style="margin-left: 0px;width: 100%;height: 35px;">--}%
    <div class="col-md-12 btn-group" role="navigation" style="margin-left: 0px;width: 100%;">
        <button class="btn" id="btn-lista"><i class="fa fa-list"></i> Lista</button>
        <button class="btn" id="btn-nuevo"><i class="icon-plus"></i> Nuevo</button>
        <g:if test="${contrato?.estado != 'R'}">
            <button class="btn btn-success" id="btn-aceptar"><i class="icon-save"></i> Guardar</button>
        </g:if>
        <button class="btn" id="btn-cancelar"><i class="icon-undo"></i> Cancelar</button>
        <g:if test="${contrato?.id}">
            <g:if test="${contrato?.id && contrato?.estado != 'R'}">
                <button class="btn" id="btn-borrar"><i class="icon-remove"></i> Eliminar Contrato</button>
            </g:if>
        </g:if>

        <g:if test="${contrato?.estado == 'R'}">
            <g:if test="${planilla == 0}">
                <button class="btn" id="btn-desregistrar"><i class="icon-exclamation"></i> Cambiar Estado
                </button>
            </g:if>
        </g:if>
        <g:if test="${contrato?.id && contrato?.estado != 'R'}">
            <button class="btn" id="btn-registrar"><i class="icon-exclamation"></i> Registrar</button>
        </g:if>



    %{--<g:if test="${contrato?.estado != 'R' && }">--}%

    %{--</g:if>--}%
    %{--<g:else>--}%

    %{--</g:else>--}%



    %{--<button class="btn" id="btn-salir"><i class="icon-ban-circle"></i> Salir</button>--}%
    </div>
</div>

<g:form class="registroContrato" name="frmRegistroContrato" action="save">

    <g:hiddenField name="id" value="${contrato?.id}"/>

    <g:if test="${contrato?.estado == 'R'}">
        <g:if test="${planilla != 0}">
            <div id="alertaEstado" title="Obra en ejecución">
                <p>Este contrato ya posee planillas y se halla en ejecución</p>
            </div>
        </g:if>
    </g:if>

    <fieldset class="grupo" style="position: relative; margin-top: 10px; height: 30px; border-bottom: 1px solid black;">

        <div class="grupo col-md-4" style="display: inline;">
            <label class="col-md-1 formato" style="width: 100px;">Contrato N°</label>
            <div class="col-md-2"><g:textField name="codigo" maxlength="20" class="codigo required caps"
                                            value="${contrato?.codigo}" style="font-weight: bold; width: 140px"/></div>
            <p class="help-block ui-helper-hidden"></p>
        </div>

        <div class="col-md-2 formato">Memo de Distribución</div>

        <div class="col-md-3"><g:textField name="memo" class="memo caps allCaps" value="${contrato?.memo}" maxlength="20"/></div>

        <div class="col-md-2 text-info" style="font-weight: bolder">
            Contrato ${contrato?.estado == 'R'? 'Registrado' : 'No Registrado'}
        </div>

    </fieldset>


    <fieldset class="" style="position: relative; padding: 10px;border-bottom: 1px solid black;">

        <p class="css-vertical-text">Contratación</p>

        <div class="linea" style="height: 85%;"></div>

    %{--<g:hiddenField name="ofertaAc" class="oferta" value="${contrato?.oferta?.id}"/>--}%

        <g:if test="${contrato?.codigo != null}">

            <div class="col-md-12">

                <div class="col-md-1 formato">Obra</div>
                <div class="col-md-4"><g:textField name="obra" id="obraCodigo" class="obraCodigo required" autocomplete="off"
                                                value="${contrato?.oferta?.concurso?.obra?.codigo}" disabled="true"/>
                <strong class="text-info" style="font-size: large">${contrato?.obra?.codigo - contrato?.oferta?.concurso?.obra?.codigo}</strong></div>

                <div class="col-md-1 formato">Nombre</div>
                <div class="col-md-3">
                    <g:textField name="nombre" class="nombreObra" value="${contrato?.oferta?.concurso?.obra?.nombre}"
                                 style="width: 500px" disabled="true"/></div>

            </div>

            <div class="col-md-12" style="margin-top: 5px">

                <div class="col-md-1 formato">Parroquia</div>
                <div class="col-md-4"><g:textField name="parroquia" class="parroquia" value="${contrato?.oferta?.concurso?.obra?.parroquia?.nombre}" disabled="true"/></div>

                <div class="col-md-1 formato">Cantón</div>

                <div class="col-md-2"><g:textField name="canton" class="canton" value="${contrato?.oferta?.concurso?.obra?.parroquia?.canton?.nombre}" disabled="true"/></div>

            </div>

            <div class="col-md-12" style="margin-top: 5px">

                <div class="col-md-1 formato">Clase Obra</div>

                <div class="col-md-3"><g:textField name="claseObra" class="claseObra" value="${contrato?.oferta?.concurso?.obra?.claseObra?.descripcion}" disabled="true"/></div>

            </div>

            <div class="col-md-12" style="margin-top: 5px">

                <div class="col-md-1 formato">Contratista</div>

                <div class="col-md-4"><g:textField name="contratista" class="contratista" value="${contrato?.oferta?.proveedor?.nombre}" disabled="true"  style="width: 320px"/></div>

                <div class="col-md-4 formato">Fecha presentación de la Oferta</div>

                <div class="col-md-1"><g:textField name="fechaPresentacion" class="fechaPresentacion" value="${contrato?.oferta?.fechaEntrega?.format('dd-MM-yyyy') ?: ''}"
                                                disabled="true" style="width: 100px; margin-left: -180px"/></div>

            </div>

        </g:if>

        <g:else>

            <div class="col-md-12" style="margin-top: 5px" align="center">

                <div class="col-md-2 formato">Obra</div>

                <div class="col-md-3">
                    <input type="hidden" id="obraId" value="${contrato?.oferta?.concurso?.obra?.codigo}" name="obra.id">
                    <g:textField name="obra" id="obraCodigo" class="obraCodigo required txtBusqueda"
                                 value="${contrato?.oferta?.concurso?.obra?.codigo}" readOnly="true"/>
                </div>

                <div class="col-md-1 formato">Nombre</div>

                <div class="col-md-5">
                    <g:textField name="nombre" class="nombreObra" id="nombreObra" style="width: 400px" disabled="true"/>
                </div>

            </div>

            <div class="col-md-12" style="margin-top: 5px" align="center">
                <div class="col-md-2 formato">Oferta</div>

                <div class="col-md-3" id="div_ofertas">
                    <g:select name="oferta.id" from="" noSelection="['-1': 'Seleccione']" id="oferta" optionKey="id"/>
                </div>

                %{--<div class="col-md-3 formato" style="margin-left: -1px">Fecha presentación de la Oferta</div>--}%

                %{--<div class="col-md-2"><g:textField name="fechaPresentacion" class="fechaPresentacion" value="${contrato?.oferta?.fechaEntrega?.format('dd-MM-yyyy') ?: ''}"--}%
                %{--disabled="true" style="width: 100px; margin-left: -180px"/></div>--}%

                <div class="col-md-6" id="filaFecha">

                </div>
                %{--<div class="col-md-2"><g:textField name="fechaPresentacion" class="fechaPresentacion" id="fechaPresentacion"--}%
                %{--disabled="true" style="width: 100px; margin-left: -180px"/></div>--}%
            </div>

            <div class="col-md-12" style="margin-top: 5px" align="center">
                <div class="col-md-2 formato">Contratista</div>

                <div class="col-md-3">
                    <g:textField name="contratista" class="contratista" id="contratista" disabled="true"/>
                </div>
            </div>

            <div class="col-md-12" style="margin-top: 5px" align="center">

                <div class="col-md-2 formato">Parroquia</div>

                <div class="col-md-3"><g:textField name="parroquia" class="parroquia" id="parr"/></div>

                <div class="col-md-1 formato">Cantón</div>

                <div class="col-md-2"><g:textField name="canton" class="canton" id="canton"/></div>

            </div>

            <div class="col-md-12" style="margin-top: 5px" align="center">

                <div class="col-md-2 formato">Clase Obra</div>

                <div class="col-md-3"><g:textField name="claseObra" class="claseObra" id="clase"/></div>

            </div>

            <div class="col-md-12" style="margin-top: 5px" align="center">

            </div>

        </g:else>

    </fieldset>

    <fieldset class="" style="position: relative; height: 110px; border-bottom: 1px solid black;">

        <div class="col-md-12" style="margin-top: 10px">

            <div class="col-md-2 formato text-info">Tipo de contrato</div>

            <div class="col-md-2" style="margin-left:-50px">
                <g:select from="${janus.pac.TipoContrato.list()}" name="tipoContrato.id" id="tpcr"
                          class="tipoContrato activo text-info" value="${contrato?.tipoContrato?.id}"
                          optionKey="id" optionValue="descripcion" style="font-weight: bolder"/></div>

            <div id="CntrPrincipal" hidden>
                <div class="col-md-1 formato text-info" style="margin-left:0px; width: 100px;">Contrato Principal</div>

                <div class="col-md-2" style="margin-left:-20px">
                    <g:select from="${janus.Contrato.list([sort: 'fechaSubscripcion'])}" name="padre.id"
                              class="activo text-info" noSelection="['-1': '-- Seleccione']"
                              value="${contrato?.padre?.id}" optionKey="id" optionValue="codigo"
                              style="width: 140px" />
                </div>
            </div>
            <div class="col-md-1 formato">Fecha de Suscripción</div>

            <div class="col-md-2">
                <elm:datepicker name="fechaSubscripcion" class="fechaSuscripcion datepicker required input-small activo"
                                value="${contrato?.fechaSubscripcion}"/></div>

            <div class="col-md-2">
                <div class="col-md-1 formato" style="width: 100px; margin-left: 20px">Aplica reajuste</div>

                <div class="col-md-1">
                    <g:select name="aplicaReajuste" from="${[0 : 'NO', 1 : 'SI']}" optionKey="key" optionValue="value"
                              value="${contrato?.aplicaReajuste == 1 ? 1 : 0}" style="width: 60px"/>
                </div>
            </div>
        </div>

        <div class="col-md-12" style="margin-top: 5px">

            <div class="col-md-2 formato">Objeto del Contrato</div>

            <div class="col-md-9" style="margin-left: -50px"><g:textArea name="objeto" class="activo"
                                                                      style="height: 55px; width: 960px; resize: none; margin-top: -6px" value="${contrato?.objeto}"/></div>

        </div>

    </fieldset>

    <fieldset class="" style="position: relative; border-bottom: 1px solid black; padding-bottom: 10px">

        <div class="col-md-12" style="margin-top: 10px">

            <div class="col-md-3 formato">Multa por retraso de obra</div>

            <div class="col-md-1">
                <g:textField name="multaRetraso" class="number" style="width: 50px"
                             value="${g.formatNumber(number: contrato?.multaRetraso ?: 0, maxFractionDigits: 0,
                                     minFractionDigits: 0, format: '##,##0', locale: 'ec')}"/>
            </div>
            <div class="col-md-1" style="margin-left: -40px">
                x 1000
            </div>
            <div class="col-md-1">
            </div>

            <div class="col-md-4 formato">Multa por no presentación de planilla</div>

            <div class="col-md-1">
                <g:textField name="multaPlanilla" class="number" style="width: 50px"
                             value="${g.formatNumber(number: contrato?.multaPlanilla ?: 0, maxFractionDigits: 0, minFractionDigits: 0, format: '##,##0', locale: 'ec')}"/>
            </div>
            <div class="col-md-1" style="margin-left: -40px">
                x 1000
            </div>

        </div>

        <div class="col-md-12" style="margin-top: 10px">

            <div class="col-md-3 formato">Multa por incumplimiento del cronograma</div>

            <div class="col-md-1">
                <g:textField name="multaIncumplimiento" class="number" style="width: 50px"
                             value="${g.formatNumber(number: contrato?.multaIncumplimiento ?: 0, maxFractionDigits: 0, minFractionDigits: 0, format: '##,##0', locale: 'ec')}"/>
            </div>
            <div class="col-md-1" style="margin-left: -40px">
                x 1000
            </div>
            <div class="col-md-1">
            </div>

            <div class="col-md-4 formato">Multa por no acatar disposiciones del fiscalizador</div>

            <div class="col-md-1">
                <g:textField name="multaDisposiciones" class="number" style="width: 50px"
                             value="${g.formatNumber(number: contrato?.multaDisposiciones ?: 0, maxFractionDigits: 0, minFractionDigits: 0, format: '##,##0', locale: 'ec')}"/>
            </div>
            <div class="col-md-1" style="margin-left: -40px">
                x 1000
            </div>

        </div>

        <div class="col-md-12" style="margin-top: 10px">

            <div class="col-md-3 formato">Monto del contrato</div>

            <div class="col-md-2"><g:textField name="monto" class="monto activo number"
                 value="${contrato?.monto}"/></div>

            <div class="col-md-1 formato" style="margin-left: 53px">Plazo</div>

            <div class="col-md-2">
                <g:textField name="plazo" class="plazo activo" style="width: 50px; margin-left: -40px" maxlength="4"
                value="${g.formatNumber(number: contrato?.plazo, maxFractionDigits: 0, minFractionDigits: 0, locale: 'ec')}"/>
            </div>
            <div class="col-md-2" style="margin-left: -160px">
                Días
            </div>
            <div class="col-md-1 formato" style="margin-left: 65px">Indirectos</div>

            <div class="col-md-1">
                <g:textField name="indirectos" class="anticipo activo"
                             value="${g.formatNumber(number: contrato?.indirectos ?: 20, maxFractionDigits: 0,
                                     minFractionDigits: 0, locale: 'ec')}"
                             style="width: 30px; text-align: right"/> %
            </div>


        </div>

        <div class="col-md-12" style="margin-top: 10px">

            <div class="col-md-3 formato">Anticipo sin reajuste</div>

            <div class="col-md-1">
                <g:textField name="porcentajeAnticipo" class="anticipo activo"
                             value="${g.formatNumber(number: contrato?.porcentajeAnticipo, maxFractionDigits: 0, minFractionDigits: 0, locale: 'ec')}"
                             style="width: 30px; text-align: right"/> %
            </div>

            <div class="col-md-2" style="margin-left: -40px">
                <g:textField name="anticipo" class="anticipoValor activo" style="width: 105px; text-align: right"
                             value="${g.formatNumber(number: contrato?.anticipo, maxFractionDigits: 2, minFractionDigits: 2, locale: 'ec')}"/>
            </div>


            <div class="col-md-4 formato">Indices 30 días antes de la presentación de la oferta</div>
            <div class="col-md-2">
                <g:select name="periodoInec.id" from="${janus.pac.PeriodoValidez.list([sort: 'fechaFin'])}"
                    class="indiceOferta activo" value="${contrato?.periodoInec?.id}"
                    optionValue="descripcion" optionKey="id" style="width: 200px"/></div>
        </div>

        <div class="col-md-12" style="margin-top: 15px">

            <div class="col-md-2 formato">Departamento Administrador</div>

            <div class="col-md-4">
                <g:select name="depAdministrador.id" from="${janus.Departamento.list([sort: 'descripcion'])}"
                          optionKey="id" optionValue="descripcion"  value="${contrato?.depAdministrador?.id?:1}"
                          class="required" style="width: 300px"/>
            </div>

            <div class="col-md-4 formato" style="margin-left: -40px">La multa por retraso de obra incluye el valor del reajuste</div>
            <div class="col-md-1">
                <g:select name="conReajuste" from="${[0 : 'NO', 1 : 'SI']}" optionKey="key" optionValue="value" value="${contrato?.conReajuste == 1 ? 1 : 0}" style="width: 60px"/>
            </div>

        </div>

        <div class="col-md-12" style="margin-top: 10px">
            <div class="col-md-2 formato">Administrador delegado</div>

            <div class="${contrato?.administrador?.nombre ? 'col-md-4' : 'col-md-4'}">
                ${contrato?.administrador?.titulo} ${contrato?.administrador?.nombre} ${contrato?.administrador?.apellido}
            </div>

            <div class="col-md-4 formato" style="margin-left: -40px">Aplica multa al saldo por planillar</div>
            <div class="col-md-1">
                <g:select name="saldoMulta" from="${[0 : 'NO', 1 : 'SI']}" optionKey="key" optionValue="value"
                          value="${contrato?.saldoMulta == 1 ? 1 : 0}" style="width: 60px"/>
            </div>
        </div>
    </fieldset>

    </g:form>

    <g:if test="${contrato}">
    <div class="btn-group" style="margin-top: 10px;padding-left: 5px;float: left" align="center">

        <g:if test="${contrato?.estado == 'R'}">
            <g:if test="${!janus.ejecucion.FormulaPolinomicaContractual.findAllByContrato(janus.Contrato.get(contrato?.id))}">
                <a href="#" class="btn" id="btnFPoli">F. polinómica</a>
            </g:if>
            <g:else>
                <g:link action="copiarPolinomica" class="btn" id="${contrato?.id}"><i
                        class="fa fa-superscript"></i> F. polinómica</g:link>
            </g:else>
        </g:if>
        <g:else>
            <g:if test="${!janus.ejecucion.FormulaPolinomicaContractual.findAllByContrato(janus.Contrato.get(contrato?.id))}">
                <a href="#" class="fa fa-superscript" id="btnFPoliPregunta"
                   data-id="${contrato?.id}">F. polinómica</a>
            </g:if>
            <g:else>
                <g:link action="copiarPolinomica" class="btn" id="${contrato?.id}"><i
                        class="fa fa-superscript"></i> F. polinómica</g:link>
            </g:else>
        </g:else>



        <g:link controller="documentoProceso" class="btn" action="list" id="${contrato?.oferta?.concursoId}"
                params="[contrato: contrato?.id, show: 1]">
            <i class="fa fa-book"></i> Biblioteca
        </g:link>



        <g:link controller="contrato" action="asignar" class="btn" id="${contrato?.oferta?.concursoId}"
                params="[contrato: contrato?.id, show: 1]">
            <i class="icon-plus"></i> Asignar F. Polinómica
        </g:link>

        <g:if test="${session.perfil.codigo == 'CNTR' && contrato?.estado == 'R' && !contrato.padre}">

            <a href="#" id="btnAgregarAdmin" class="btn adm">
                <i class="icon-user"></i> Administrador
            </a>

        </g:if>

        <g:link class="contratado, btn" controller="cronogramaContrato" action="editarVocr" id="${contrato?.id}"
                title="Nuevo Cronograma Contrato Complementario">
            <i class="icon-th"></i> Valores Contratados
        </g:link>


        <g:link class="comple, btn" controller="cronogramaContrato" action="nuevoCronograma" id="${contrato?.id}"
                title="Nuevo Cronograma Contrato Complementario">
            <i class="icon-th"></i> Cronograma Total
        </g:link>


        <g:link class="comple, btn" controller="cronogramaContrato" action="corrigeCrcr" id="${contrato?.id}"
                title="Nuevo Cronograma Contrato Complementario">
            <i class="icon-th"></i> Corregir decimales Crono.
        </g:link>

        <g:if test="${complementario}">

            <a href="#" class="comple, btn" name="integrarFP_name" id="integrarFP"
               title="Integración al contrato principal la FP del contrato complementario">
                <i class="fa icon-th"></i> Integrar FP Comp.
            </a>



            <a href="#" class="btn comple" name="integrar_name" id="integrarCronograma"
               title="Integración al cronograma principal los rubros del contrato complementario">
                <i class="fa icon-th"></i> Integrar cronograma Comp.
            </a>

        </g:if>
    </div>

%{--comentar para no incluir complementearios--}%

%{--<div class="navbar navbar-inverse" style="margin-top: -10px;padding-left: 5px;">--}%
%{--<div class="navbar-inner">--}%
%{--<div class="botones">--}%
%{--<ul class="nav">--}%
%{--<li>--}%
%{--<g:link controller="cronogramaContrato" action="nuevoCronograma" id="${contrato?.id}" title="Nuevo Cronograma Contrato">--}%
%{--<i class="icon-th"></i> Cronograma contrato--}%
%{--</g:link>--}%
%{--</li>--}%
%{--<g:if test="${complementario}">--}%
%{--<li>--}%
%{--<a href="#" name="integrarFP_name" id="integrarFP" title="Integración de la FP del contrato y de la FP del contrato complementario">--}%
%{--<i class="fa icon-th"></i> Integrar FP complementario--}%
%{--</a>--}%
%{--</li>--}%

%{--<li>--}%
%{--<a href="#" name="integrar_name" id="integrarCronograma" title="Integración del cronograma contrato y del cronograma del contrato complementario">--}%
%{--<i class="fa icon-th"></i> Integrar cronograma complementario--}%
%{--</a>--}%
%{--</li>--}%
%{--</g:if>--}%
%{--</ul>--}%
%{--</div>--}%
%{--</div>--}%
%{--</div>--}%

</g:if>

<div class="modal hide fade mediumModal" id="modal-var" style="overflow: hidden">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">x</button>

        <h3 id="modal_tittle_var">

        </h3>

    </div>

    <div class="modal-body" id="modal_body_var">

    </div>

    <div class="modal-footer" id="modal_footer_var">

    </div>

</div>

<div id="listaContrato" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 20px">

            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPor" class="buscarPor col-md-12" from="${listaContrato}" optionKey="key"
                          optionValue="value"/>
            </div>

            <div class="col-md-2">Criterio
            <g:textField name="buscarCriterio" id="criterioCriterio" style="width: 80%"/>
            </div>

            <div class="col-md-2">Ordenado por
            <g:select name="ordenar" class="ordenar" from="${listaContrato}" style="width: 100%" optionKey="key"
                      optionValue="value"/>
            </div>
            <div class="col-md-2" style="margin-top: 6px">
                <button class="btn btn-info" id="cnsl-contratos"><i class="fa fa-search"></i> Consultar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaRbro" style="height: 460px; overflow: auto">
        </div>
    </fieldset>
</div>


<div class="modal grandote hide fade" id="modal-busqueda" style="overflow: hidden">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">x</button>
        <h3 id="modalTitle_busqueda"></h3>
    </div>

    <div class="modal-body" id="modalBody">
        <bsc:buscador name="contratos" value="" accion="buscarContrato" controlador="contrato" campos="${campos}" label="Contrato" tipo="lista"/>
    </div>
    <div class="modal-footer" id="modalFooter_busqueda">
    </div>

</div>


<div id="borrarContrato">

    <fieldset>
        <div class="col-md-3">
            Está seguro de que desea borrar el contrato: <div style="font-weight: bold;">${contrato?.codigo} ?</div>

        </div>
    </fieldset>
</div>


<div id="integrarCronoDialog">
    <fieldset>
        <div class="col-md-4">
            Seleccione el contrato complementario cuyo cronograma será integrado al cronograma del contrato: <strong>${contrato?.codigo}</strong>
        </div>
    </fieldset>
    <fieldset style="margin-top: 10px">
        <div class="col-md-4">
            <g:select from="${complementarios}" optionKey="id" optionValue="${{it?.codigo + " - " + it?.objeto}}"
                      name="complementarios_name" id="contratosComp" class="form-control" style="width: 380px"/>
        </div>
    </fieldset>
</div>

<div id="integrarCronoDialogNo">
    <fieldset>
        <div class="col-md-4">
            Ya se ha realizado la integración del cronograma del contrato complementario al contrato: <p><strong>${contrato?.codigo}</strong></p>
        </div>
    </fieldset>
</div>

<div id="integrarFPDialogNo">
    <fieldset>
        <div class="col-md-4">
            Ya se ha realizado la integración de la fórmula polinómica del contrato complementario al contrato:
            <p><strong>${contrato?.codigo}</strong></p>
        </div>
    </fieldset>
</div>

<div id="integrarFPDialog">
    <fieldset>
        <div class="col-md-4">
            Seleccione el contrato complementario cuya FP será integrada a la FP del contrato: <strong>${contrato?.codigo}</strong>
        </div>
    </fieldset>
    <fieldset style="margin-top: 10px">
        <div class="col-md-4">
            <g:select from="${formula}" optionKey="id" optionValue="${{it?.codigo + " - " + it?.objeto}}"
                      name="complementariosFP_name" id="contratosFP" class="form-control" style="width: 380px"/>
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

    $("#btnFPoliPregunta").click(function () {
        var id = $(this).data("id");
        $.box({
            imageClass : "box_info",
            title      : "Confirmación",
            text       : "Está seguro que desea copiar la FP de la obra al contrato?",
            iconClose  : false,
            dialog     : {
                width         : 400,
                resizable     : false,
                draggable     : false,
                closeOnEscape : false,
                buttons       : {
                    "Aceptar" : function () {
                         location.href="${createLink(controller: 'contrato', action: 'copiarPolinomica')}?id=" + id
                    },
                    "Cancelar" : function () {
                    }
                }
            }
        });


    });



    $("#preguntarFPDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 450,
        height    : 220,
        position  : 'center',
        title     : 'Generar Fórmula Polinómica',
        buttons   : {
            "Aceptar"  : function () {
                $.box({
                    imageClass : "box_info",
                    title      : "Confirmación",
                    text       : "Está seguro que desea generar la FP del contrato?",
                    iconClose  : false,
                    dialog     : {
                        width         : 400,
                        resizable     : false,
                        draggable     : false,
                        closeOnEscape : false,
                        buttons       : {
                            "Aceptar" : function () {

                            },
                            "Cancelar" : function () {
                                $("#preguntarFPDialog").dialog("close");
                            }
                        }
                    }
                });
            },
            "Cancelar" : function () {
                $("#preguntarFPDialog").dialog("close");
            }
        }
    });



    $("#btnFPoli").click(function () {
       alert("Este contrato fue registrado sin fórmula polinómica")
    });


    $("#btnAgregarAdmin").click(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'administradorContrato', action: 'adminContrato')}",
            data    : {
                contrato : "${contrato?.id}"
            },
            success : function (msg) {
                var $btnOk = $('<a href="#" class="btn">Aceptar</a>');
                $btnOk.click(function () {
                    $(this).replaceWith(spinner);
                    location.reload(true);
                });
                $("#modal_tittle_var").text("Administradores");
                $("#modal_body_var").html(msg);
                $("#administrador").data("contrato", "${contrato?.id}");
                $("#modal_footer_var").html($btnOk);
                $("#modal-var").modal("show");
            }
        });
        return false;
    });


    $("#integrarFP").click(function () {
        var fp = parseInt("${compFp}");
        if(fp == 0){
            $("#integrarFPDialog").dialog("open")
        }else{
            $("#integrarFPDialogNo").dialog("open")
        }
    });

    $("#integrarFPDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 450,
        height    : 220,
        position  : 'center',
        title     : 'Integrar Fórmula Polinómica',
        buttons   : {
            "Aceptar"  : function () {
                var complementario = $("#contratosFP").val();

                $.box({
                    imageClass : "box_info",
                    title      : "Confirmación",
                    text       : "Está seguro que desea integrar la FP del contrato con la FP del contrato complementario?",
                    iconClose  : false,
                    dialog     : {
                        width         : 400,
                        resizable     : false,
                        draggable     : false,
                        closeOnEscape : false,
                        buttons       : {
                            "Aceptar" : function () {
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'contrato', action: 'integrarFP')}",
                                    data    :  {
                                        id: '${contrato?.id}',
                                        comp: complementario
                                    },
                                    success : function (msg) {
                                        var parts = msg.split("_");
                                        if(parts[0] == 'no'){
                                            $.box({
                                                imageClass : "box_info",
                                                title      : "Alerta",
                                                text       : parts[1],
                                                iconClose  : false,
                                                dialog     : {
                                                    width         : 400,
                                                    resizable     : false,
                                                    draggable     : false,
                                                    closeOnEscape : false,
                                                    buttons       : {
                                                        "Aceptar" : function () {
                                                        }
                                                    }
                                                }
                                            });
                                        }else{
                                            location.reload();
                                            /*
                                             $.box({
                                             imageClass : "box_info",
                                             title      : "Integrado",
                                             text       : parts[1],
                                             iconClose  : false,
                                             dialog     : {
                                             width         : 400,
                                             resizable     : false,
                                             draggable     : false,
                                             closeOnEscape : false,
                                             buttons       : {
                                             "Aceptar" : function () {
                                             $("#integrarFPDialog").dialog("close");
                                             }
                                             }
                                             }
                                             });
                                             */
                                        }
                                    }
                                });
                            },
                            "Cancelar" : function () {
                                $("#integrarFPDialog").dialog("close");
                            }
                        }
                    }
                });
            },
            "Cancelar" : function () {
                $("#integrarFPDialog").dialog("close");
            }
        }
    });

    $("#integrarCronograma").click(function () {
        var complementario = $("#contratosComp").val();
        if(complementario){
            $("#integrarCronoDialog").dialog("open")
        }else{
            $("#integrarCronoDialogNo").dialog("open")
        }
    });

    $("#integrarCronoDialogNo").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 450,
        height    : 180,
        position  : 'center',
        title     : 'Integrar cronograma',
        buttons   : {
            "Aceptar": function () {
                $("#integrarCronoDialogNo").dialog("close")
            }
        }
    });

    $("#integrarFPDialogNo").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 450,
        height    : 180,
        position  : 'center',
        title     : 'Integrar Fórmula Polinómica',
        buttons   : {
            "Aceptar": function () {
                $("#integrarFPDialogNo").dialog("close")
            }
        }
    });


    $("#integrarCronoDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 450,
        height    : 220,
        position  : 'center',
        title     : 'Integrar cronograma',
        buttons   : {
            "Aceptar"  : function () {
                var complementario = $("#contratosComp").val();
                $.box({
                    imageClass : "box_info",
                    title      : "Confirmación",
                    text       : "Está seguro que desea integrar el cronograma del contrato complementario en el cronograma del contrato: ${contrato?.codigo} ?",
                    iconClose  : false,
                    dialog     : {
                        width         : 400,
                        resizable     : false,
                        draggable     : false,
                        closeOnEscape : false,
                        buttons       : {
                            "Aceptar" : function () {
                                $.ajax({
                                    type    : "POST",
                                    url     : "${createLink(controller: 'contrato', action: 'integrarCrono')}",
                                    data    :  {
                                        id: '${contrato?.id}',
                                        comp: complementario
                                    },
                                    success : function (msg) {
                                        var parts = msg.split("_");
                                        if(parts[0] == 'no'){
                                            $.box({
                                                imageClass : "box_info",
                                                title      : "Alerta",
                                                text       : parts[1],
                                                iconClose  : false,
                                                dialog     : {
                                                    width         : 400,
                                                    resizable     : false,
                                                    draggable     : false,
                                                    closeOnEscape : false,
                                                    buttons       : {
                                                        "Aceptar" : function () {
                                                        }
                                                    }
                                                }
                                            });
                                        } else {
                                            $.box({
                                                imageClass : "box_info",
                                                title      : "Integrado",
                                                text       : parts[1],
                                                iconClose  : false,
                                                dialog     : {
                                                    width         : 400,
                                                    resizable     : false,
                                                    draggable     : false,
                                                    closeOnEscape : false,
                                                    buttons       : {
                                                        "Aceptar" : function () {
                                                            $("#integrarCronoDialog").dialog("close");
                                                        }
                                                    }
                                                }
                                            });
                                        }
                                        location.reload();
                                    }
                                });
                            },
                            "Cancelar" : function () {
                                $("#integrarCronoDialog").dialog("close");
                            }
                        }
                    }
                });
            },
            "Cancelar" : function () {
                $("#integrarCronoDialog").dialog("close");
            }
        }
    });

    $("#multaRetraso").keydown(function (ev) {
    }).keyup(function () {
        if($(this).val() == ''){
            $(this).val(0)
        }
    });


    $("#multaPlanilla").keydown(function (ev) {
    }).keyup(function () {
        if($(this).val() == ''){
            $(this).val(0)
        }
    });


    $("#multaIncumplimiento").keydown(function (ev) {
    }).keyup(function () {
        if($(this).val() == ''){
            $(this).val(0)
        }
    });


    $("#multaDisposiciones").keydown(function (ev) {
    }).keyup(function () {
        if($(this).val() == ''){
            $(this).val(0)
        }
    });

    function updateAnticipo() {
        %{--console.log("reg:", "${contrato?.estado}", "${contrato?.estado != 'R'}")--}%
        if("${contrato?.estado}" != 'R') {
            var porcentaje = $("#porcentajeAnticipo").val();
            var monto = $("#monto").val().replace(/,/g, "");
            var anticipoValor = Math.round(parseFloat(porcentaje) * parseFloat(monto)) / 100;
            $("#anticipo").val(anticipoValor);
        }
//                $("#anticipo").val(number_format(anticipoValor, 2, ".", ","));
//                $("#monto").val(number_format(monto, 2, ".", ","));
    }


    $("#frmRegistroContrato").validate({
        errorClass: "help-block",
        errorPlacement: function (error, element) {
            if (element.parent().hasClass("input-group")) {
                error.insertAfter(element.parent());
            } else {
                error.insertAfter(element);
            }
            element.parents(".grupo").addClass('has-error');
        },
        success: function (label) {
            label.parents(".grupo").removeClass('has-error');
        },
        rules  : {
            codigo : {
                remote : {
                    url  : "${createLink(action:'validaCdgo')}",
                    type : "post",
                    data : {
                        id  : "${contrato?.id}",
                        antes: "${contrato?.codigo}"
                    }
                }
            }
        },
        messages       : {
            codigo : {
                remote : "El código ya existe"
            }
        }
    });

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
        ev.keyCode == 190 || ev.keyCode == 110 ||
        ev.keyCode == 8 || ev.keyCode == 46 || ev.keyCode == 9 ||
        ev.keyCode == 37 || ev.keyCode == 39);
    }

    function validarInt(ev) {
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


    $(".number").keydown(function (ev) {
        return validarInt(ev);
    });

    $("#plazo").keydown(function (ev) {
        return validarInt(ev);
    }).keyup(function () {
        var enteros = $(this).val();
    });

    $("#monto").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();
    });

    $("#porcentajeAnticipo").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();
        if (parseFloat(enteros) > 100) {
            $(this).val(100)
        }
        updateAnticipo();
    });


    $("#indirectos").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();
        if (parseFloat(enteros) > 100) {
            $(this).val(100)
        }
    });


    //            $("#anticipo").keydown(function (ev) {
    //                return validarNum(ev);
    //            }).keyup(function () {
    //                        var enteros = $(this).val();
    //                        updateAnticipo();
    //                        var porcentaje = $("#porcentajeAnticipo").val();
    //                        var monto = $("#monto").val();
    //                        var anticipoValor = (porcentaje * (monto)) / 100;
    //                        $("#anticipo").val(number_format(anticipoValor, 2, ".", ""));
    //                    }).click(function () {
    //                        updateAnticipo();
    //                        var porcentaje = $("#porcentajeAnticipo").val();
    //                        var monto = $("#monto").val();
    //                        var anticipoValor = (porcentaje * (monto)) / 100;
    //                        $("#anticipo").val(number_format(anticipoValor, 2, ".", ","));
    //                    });

    $("#financiamiento").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();
    });


    $("#tpcr").change(function () {
//        console.log("--->", $("#tpcr").val());
        if($("#tpcr").val() == "3") {
            $("#CntrPrincipal").show();
        } else {
            $("#CntrPrincipal").hide();
        }
    });

    function enviarObra() {
        var data = "";
        $("#buscarDialog").hide();
        $("#spinner").show();
        $(".crit").each(function () {
            data += "&campos=" + $(this).attr("campo");
            data += "&operadores=" + $(this).attr("operador");
            data += "&criterios=" + $(this).attr("criterio");
        });
        if (data.length < 2) {
            data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" +
                $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
        }
        data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
        $.ajax({type : "POST", url : "${g.createLink(controller: 'contrato', action:'buscarObra')}",
            data     : data,
            success  : function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });
    }

    function cargarCombo() {
        if ($("#obraId").val() * 1 > 0) {
            $.ajax({
                type    : "POST", url : "${g.createLink(controller: 'contrato',action:'cargarOfertas')}",
                data    : "id=" + $("#obraId").val(),
                success : function (msg) {
                    $("#div_ofertas").html(msg)
                }
            });
        }
    }

    function cargarCanton() {
        if ($("#obraId").val() * 1 > 0) {
            $.ajax({
                type    : "POST", url : "${g.createLink(controller: 'contrato',action:'cargarCanton')}",
                data    : "id=" + $("#obraId").val(),
                success : function (msg) {
                    $("#canton").val(msg)
                }
            });
        }
    }

    $("#listaObra").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        draggable: false,
        width: 1000,
        height: 500,
        position: 'center',
        title: 'Obras ofertadas'
    });


    $("#obraCodigo").dblclick(function () {
        $("#listaObra").dialog("open");
        $(".ui-dialog-titlebar-close").html("x")
    });

    $("#cnsl-obras").click(function () {
        buscaObras();
    });

    function buscaObras() {
        var buscarPor = $("#buscarPor").val();
        var tipo = $("#buscarTipo").val();
        var criterio = $("#criterioCriterio").val();
        var ordenar = $("#ordenar").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'contrato', action:'tablaObras_ajax')}",
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



    $("#btn-lista").click(function () {
        $("#listaContrato").dialog("open");
        $(".ui-dialog-titlebar-close").html("x")
    });

    $("#listaContrato").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        draggable: false,
        width: 1000,
        height: 500,
        position: 'center',
        title: 'Contratos'
    });

    $("#cnsl-contratos").click(function () {
        buscaContratos();
    });

    function buscaContratos() {
        var buscarPor = $("#buscarPor").val();
        var tipo = $("#buscarTipo").val();
        var criterio = $("#criterioCriterio").val();
        var ordenar = $("#ordenar").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'contrato', action:'listaContratos')}",
            data: {
                buscarPor: buscarPor,
                buscarTipo: tipo,
                criterio: criterio,
                ordenar: ordenar
            },
            success: function (msg) {
                $("#divTablaRbro").html(msg);
            }
        });
    }



    $("#btn-nuevo").click(function () {
        location.href = "${createLink(action: 'registroContrato')}"
    });

    $("#obraCodigo").focus(function () {
        var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
        $("#modalTitle_busquedaOferta").html("Lista de Obras");
        $("#modalFooter_busquedaOferta").html("").append(btnOk);
        $("#modal-busquedaOferta").modal("show");

    });


    $("#btn-salir").click(function () {
        location.href = "${g.createLink(action: 'index', controller: "inicio")}";
    });

    $("#btn-aceptar").click(function () {
//                console.log("guardar", $(".indiceOferta").val())
        if($(".indiceOferta").val()){
//                    console.log("hace submit")
            $("#frmRegistroContrato").submit();
//                    console.log("DESPUÉS DE submit")
        }else{
            alert("No ha seleccionado un indice!")
        }
    });

    $("#btn-registrar").click(function () {
        var $btn = $(this).clone(true);
        $(this).replaceWith(spinner);
        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'saveRegistrar')}",
            data    : "id=${contrato?.id}",
            success : function (msg) {
                var parts = msg.split("_");
                if (parts[0] == "ok") {
                    alert("Contrato registrado");
                    location.href = "${g.createLink(controller: 'contrato', action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
                } else {
                    spinner.replaceWith($btn);
                    $.box({
                        imageClass : "box_info",
                        title      : "Alerta",
                        text       : parts[1],
                        iconClose  : false,
                        dialog     : {
                            width         : 400,
                            resizable     : false,
                            draggable     : false,
                            closeOnEscape : false,
                            buttons       : {
                                "Aceptar" : function () {
                                }
                            }
                        }
                    });
                }
            }
        });
    });

    $("#btn-desregistrar").click(function () {

        $.ajax({
            type    : "POST",
            url     : "${createLink(action: 'cambiarEstado')}",
            data    : "id=${contrato?.id}",
            success : function (msg) {

                %{--location.href = "${g.createLink(action: 'registroContrato')}";--}%
                location.href = "${g.createLink(controller: 'contrato', action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
            }
        });

    });

    $("#btn-cancelar").click(function () {
        if (${contrato?.id == null}) {
            location.href = "${g.createLink(action: 'registroContrato')}";
        } else {
            location.href = "${g.createLink(action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
        }
    })

    $("#btn-borrar").click(function () {
        if (${contrato?.codigo != null}) {
            $("#borrarContrato").dialog("open")
        }
    });

    $("#borrarContrato").dialog({

        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 220,
        position  : 'center',
        title     : 'Eliminar Contrato',
        buttons   : {
            "Aceptar"  : function () {

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action: 'delete')}",
                    data    : "id=${contrato?.id}",
                    success : function (msg) {

                        $("#borrarContrato").dialog("close");
                        location.href = "${g.createLink(action: 'registroContrato')}";
                    }
                });
            },
            "Cancelar" : function () {
                $("#borrarContrato").dialog("close");
            }
        }
    });

    /* muestra la X en el botón de cerrar */
    $(function() {
        if(${contrato?.estado == 'R'}) {
            $("#alertaEstado").dialog({
                modal: true,
                open: function() {
                    $(this).closest(".ui-dialog")
                        .find(".ui-dialog-titlebar-close")
                        .removeClass("ui-dialog-titlebar-close")
                        .html("x");
                }
            });
        }
        $("#tpcr").change();
    });

</script>

</body>
</html>