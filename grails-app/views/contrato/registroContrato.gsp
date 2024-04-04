<%@ page import="janus.Contrato; janus.ejecucion.FormulaPolinomicaContractual; janus.ejecucion.TipoPlanilla" contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">

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
        color: #000;
        background-color: #aabfb4;
    }
    .contratado{
        background-color: #3d9794;
    }

    .adm{
        color: #fff;
        background-color: #5a7ab2;
    }
    .adm:hover{
        color: #ffd;
        background-color: #4a6aa2;
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
    <div class="col-md-12 btn-group" role="navigation" style="width: 100%;">
        <button class="btn btn-info" id="btn-lista"><i class="fa fa-list"></i> Lista</button>

        <g:if test="${session.perfil.codigo == 'CNTR'}">
            <button class="btn" id="btn-nuevo"><i class="fa fa-plus"></i> Nuevo</button>
            <g:if test="${contrato?.estado != 'R'}">
                <button class="btn btn-success" id="btn-aceptar"><i class="fa fa-save"></i> Guardar</button>
            </g:if>
            <button class="btn" id="btn-cancelar"><i class="fa fa-times"></i> Cancelar</button>
            <g:if test="${contrato?.id}">
                <g:if test="${contrato?.id && contrato?.estado != 'R'}">
                    <button class="btn btn-danger" id="btn-borrar"><i class="fa fa-trash"></i> Eliminar Contrato</button>
                </g:if>
            </g:if>

            <g:if test="${contrato?.estado == 'R'}">
                <g:if test="${planilla == 0}">
                    <button class="btn" id="btn-desregistrar"><i class="fa fa-retweet"></i> Cambiar Estado
                    </button>
                </g:if>
            </g:if>
            <g:if test="${contrato?.id && contrato?.estado != 'R'}">
                <button class="btn" id="btn-registrar"><i class="fa fa-retweet"></i> Registrar</button>
            </g:if>
        </g:if>
    </div>
</div>

<g:form class="registroContrato" name="frmRegistroContrato" action="save">

    <g:hiddenField name="id" value="${contrato?.id}"/>

    <fieldset class="grupo" style="position: relative; margin-top: 10px; height: 30px; border-bottom: 1px solid black;">

        <div class="grupo col-md-4" style="display: inline;">
            <label class="col-md-1 formato" style="width: 100px; color: #0b2c89">Contrato N°</label>
            <div class="col-md-2"><g:textField name="codigo" maxlength="20" class="codigo required caps"
                                               value="${contrato?.codigo}" style="font-weight: bold; width: 140px"/></div>
            <p class="help-block ui-helper-hidden"></p>
        </div>

        <div class="col-md-2 formato" style="color: #0b2c89;"> Memo de Distribución</div>

        <div class="col-md-3"><g:textField name="memo" class="memo caps allCaps" value="${contrato?.memo}" maxlength="20"/></div>

        <div class="col-md-2 " style="font-weight: bolder; font-size: 14px; background-color: ${contrato?.estado == 'R' ? 'green' : '#0b2c89'}; color: white; text-align: center">
            <i class="${contrato?.estado == 'R' ? 'fa fa-check' : 'fa fa-exclamation-triangle'}"></i>  Contrato ${contrato?.estado == 'R'? 'Registrado' : 'No Registrado'}
        </div>

    </fieldset>


    <fieldset class="" style="position: relative; padding: 10px;border-bottom: 1px solid black;">

        <p class="css-vertical-text">Contratación</p>

        <div class="linea" style="height: 85%;"></div>

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

                <div class="col-md-6">
                    <g:textField name="nombre" class="nombreObra" id="nombreObra" style="width: 400px" disabled="true"/>
                </div>

            </div>

            <div class="col-md-12" style="margin-top: 5px" align="center">
                <div class="col-md-2 formato">Oferta</div>

                <div class="col-md-3" id="div_ofertas">
                </div>

                <div class="col-md-6" id="filaFecha">

                </div>
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
                <div class="col-md-1 formato text-info" style="width: 100px;">Contrato Principal</div>

                <div class="col-md-2" style="margin-left:-20px">
                    <g:select from="${janus.Contrato.list([sort: 'fechaSubscripcion'])}" name="padre.id"
                              class="activo text-info" noSelection="['-1': '-- Seleccione']"
                              value="${contrato?.padre?.id}" optionKey="id" optionValue="codigo"
                              style="width: 140px" />
                </div>
            </div>
            <div class="col-md-1 formato">Fecha de Suscripción</div>

            <div class="col-md-2">
                <input aria-label="" name="fechaSubscripcion" id='fecha1' type='text' class="input-small" value="${contrato?.fechaSubscripcion?.format("dd-MM-yyyy")}" />
            </div>

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
            <div class="col-md-9" style="margin-left: -50px">
                <g:textArea name="objeto" class="activo required" style="height: 55px; width: 960px; resize: none; margin-top: -6px" value="${contrato?.objeto}"/>
            </div>
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
                             value="${g.formatNumber(number: contrato?.indirectos ?: 20, maxFractionDigits: 2,
                                     minFractionDigits: 0, locale: 'ec')}"
                             style="width: 45px; text-align: right"/> %
            </div>
        </div>

        <div class="col-md-12" style="margin-top: 10px">
            <div class="col-md-3 formato">Anticipo sin reajuste</div>
            <div class="col-md-1">
                <g:textField name="porcentajeAnticipo" class="anticipo required activo"
                             value="${g.formatNumber(number: contrato?.porcentajeAnticipo, maxFractionDigits: 0, minFractionDigits: 0, locale: 'ec')}"
                             style="width: 30px; text-align: right"/> %
            </div>
            <div class="col-md-2" style="margin-left: -40px">
                <g:textField name="anticipo" class="anticipoValor activo required" style="width: 105px; text-align: right"
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
    <g:if test="${session.perfil.codigo == 'CNTR'}">
        <div class="btn-group" style="margin-top: 10px;padding-left: 5px;float: left" align="center">

            <g:if test="${contrato?.estado == 'R'}">
                <g:if test="${!janus.ejecucion.FormulaPolinomicaContractual.findAllByContrato(janus.Contrato.get(contrato?.id))}">
                    <a href="#" class="btn" id="btnFPoli"><i class="fa fa-superscript"></i> F. polinómica</a>
                </g:if>
                <g:else>
                    <g:link action="copiarPolinomica" class="btn" id="${contrato?.id}">
                        <i class="fa fa-superscript"></i> F. polinómica</g:link>
                </g:else>
            </g:if>
            <g:else>
                <g:if test="${!janus.ejecucion.FormulaPolinomicaContractual.findAllByContrato(janus.Contrato.get(contrato?.id))}">
                    <a href="#" class="btn" id="btnFPoliPregunta"
                       data-id="${contrato?.id}"><i class="fa fa-superscript"></i> F. polinómica
                    </a>
                </g:if>
                <g:else>
                    <g:link action="copiarPolinomica" class="btn" id="${contrato?.id}">
                        <i class="fa fa-superscript"></i> F. polinómica</g:link>
                </g:else>
            </g:else>

            <g:link controller="documentoProceso" class="btn" action="list" id="${contrato?.oferta?.concursoId}"
                    params="[contrato: contrato?.id, show: 1]">
                <i class="fa fa-book"></i> Biblioteca
            </g:link>

            <g:link controller="contrato" action="asignar" class="btn" id="${contrato?.oferta?.concursoId}"
                    params="[contrato: contrato?.id, show: 1]">
                <i class="fa fa-plus"></i> Asignar F. Polinómica
            </g:link>

            <g:if test="${session.perfil.codigo == 'CNTR' && !contrato.padre}">
                <a href="#" id="btnAgregarAdmin" class="btn adm">
                    <i class="fa fa-user"></i> Administrador
                </a>
            </g:if>

            <g:link class="comple, btn" controller="cronogramaContrato" action="nuevoCronograma" id="${contrato?.id}"
                    title="Nuevo Cronograma Contrato Complementario">
                <i class="fa fa-clipboard"></i> Cronograma Total
            </g:link>

            <g:if test="${complementario}">
                <a href="#" class="comple btn" name="integrarFP_name" id="integrarFP"
                   title="Integración al contrato principal la FP del contrato complementario">
                    <i class="fa fa-th"></i> Integrar FP Comp.
                </a>
                <a href="#" class="btn comple" name="integrar_name" id="integrarCronograma"
                   title="Integración al cronograma principal los rubros del contrato complementario">
                    <i class="fa fa-th"></i> Integrar cronograma Comp.
                </a>
            </g:if>
        </div>
    </g:if>

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
        <div id="divTablaRbro" style="height: 400px; overflow: auto">
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
        <div class="col-md-12">
            Seleccione el contrato complementario cuyo cronograma será integrado al cronograma del contrato:
            <strong>${contrato?.codigo}</strong>
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
        <div class="col-md-12">
            Ya se ha realizado la integración del cronograma del contrato complementario al contrato:
            <p><strong>${contrato?.codigo}</strong></p>
        </div>
    </fieldset>
</div>

<div id="integrarFPDialogNo">
    <fieldset>
        <div class="col-md-12">
            Ya se ha realizado la integración de la fórmula polinómica del contrato complementario al contrato:
            <p><strong>${contrato?.codigo}</strong></p>
        </div>
    </fieldset>
</div>

<div id="integrarFPDialog">
    <fieldset>
        <div class="col-md-12">
            Seleccione el contrato complementario cuya FP será integrada a la FP del contrato: <strong>${contrato?.codigo}</strong>
        </div>
    </fieldset>
    <fieldset style="margin-top: 10px">
        <div class="col-md-12">
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
            <g:textField name="buscarCriterio" id="criterioObra" style="width: 80%"/>
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
        <div id="divTablaObra" style="height: 400px; overflow: auto">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $('#fecha1').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    window.addEventListener("load", function() {
        <g:if test="${contrato?.estado == 'R'}">
        <g:if test="${planilla != 0}">
        bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + "<strong style='font-size: 14px'> Este contrato ya posee planillas y se encuentra en ejecución. </strong>");
        </g:if>
        </g:if>
    });

    $("#btnFPoliPregunta").click(function () {
        var id = $(this).data("id");
        bootbox.confirm({
            title: "Copiar FP",
            message: "Está seguro que desea copiar la FP de la obra al contrato?",
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
                    var d = cargarLoader("Cargando...");
                    location.href="${createLink(controller: 'contrato', action: 'copiarPolinomica')}?id=" + id
                }
            }
        });
    });

    $("#btnFPoli").click(function () {
        bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-danger'></i>" + "<strong style='font-size: 14px'> Este contrato fue registrado sin fórmula polinómica. </strong>");
    });

    $("#btnAgregarAdmin").click(function () {
        $.ajax({
            type    : "POST",
            url     : "${createLink(controller: 'administradorContrato', action: 'adminContrato')}",
            data    : {
                contrato : "${contrato?.id}"
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgCreateEdit",
                    title   : "Asignar administrador",
                    message : msg,
                    buttons : {
                        cancelar : {
                            label     : "Cancelar",
                            className : "btn-primary",
                            callback  : function () {
                                cargarLoader("Cargando...");
                                location.reload();
                            }
                        }
                    } //buttons
                }); //dialog
            }
        });
        return false;
    });

    $("#integrarFP").click(function () {
        var fp = parseInt("${compFp}");
        if(fp === 0){
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

                bootbox.confirm({
                    title: "Integrar FP",
                    message: "Está seguro que desea integrar la FP del contrato con la FP del contrato complementario?",
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
                            var d1 = cargarLoader("Cargando...");
                            $.ajax({
                                type    : "POST",
                                url     : "${createLink(controller: 'contrato', action: 'integrarFP')}",
                                data    :  {
                                    id: '${contrato?.id}',
                                    comp: complementario
                                },
                                success : function (msg) {
                                    d1.modal("hide");
                                    var parts = msg.split("_");
                                    if(parts[0] === 'no'){
                                        bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + parts[1])
                                    }else{
                                        location.reload();
                                    }
                                }
                            });
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
        //var complementario = 12;
        console.log('complementario', complementario)
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

                bootbox.confirm({
                    title: "Integrar cronograma",
                    message: "Está seguro que desea integrar el cronograma del contrato complementario en el cronograma del contrato: ${contrato?.codigo} ?",
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
                                url     : "${createLink(controller: 'contrato', action: 'integrarCrono')}",
                                data    :  {
                                    id: '${contrato?.id}',
                                    comp: complementario
                                },
                                success : function (msg) {
                                    g.modal("hide")
                                    var parts = msg.split("_");
                                    if(parts[0] === 'no'){
                                        bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + parts[1])
                                    } else {
                                        var b = bootbox.dialog({
                                            id      : "dlgCreateEdit",
                                            title   : "Integrado",
                                            message : "<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + parts[1],
                                            buttons : {
                                                cancelar : {
                                                    label     : "Aceptar",
                                                    className : "btn-primary",
                                                    callback  : function () {
                                                        $("#integrarCronoDialog").dialog("close");
                                                    }
                                                }
                                            } //buttons
                                        }); //dialog
                                    }
                                    location.reload();
                                }
                            });
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
        if($(this).val() === ''){
            $(this).val(0)
        }
    });

    $("#multaPlanilla").keydown(function (ev) {
    }).keyup(function () {
        if($(this).val() === ''){
            $(this).val(0)
        }
    });

    $("#multaIncumplimiento").keydown(function (ev) {
    }).keyup(function () {
        if($(this).val() === ''){
            $(this).val(0)
        }
    });

    $("#multaDisposiciones").keydown(function (ev) {
    }).keyup(function () {
        if($(this).val() === ''){
            $(this).val(0)
        }
    });

    function updateAnticipo() {
        if("${contrato?.estado}" !== 'R') {
            var porcentaje = $("#porcentajeAnticipo").val();
            var monto = $("#monto").val().replace(/,/g, "");
            var anticipoValor = Math.round(parseFloat(porcentaje) * parseFloat(monto)) / 100;
            if(anticipoValor){
                $("#anticipo").val(anticipoValor);
            }else{
                $("#anticipo").val(0);
            }
        }
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
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 190 || ev.keyCode === 110 ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    function validarInt(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
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

    $("#financiamiento").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();
    });

    $("#tpcr").change(function () {
        if($("#tpcr").val() === "3") {
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
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'contrato', action:'buscarObra')}",
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
                type    : "POST",
                url : "${g.createLink(controller: 'contrato',action:'cargarOfertas')}",
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
                type    : "POST",
                url : "${g.createLink(controller: 'contrato',action:'cargarCanton')}",
                data    : "id=" + $("#obraId").val(),
                success : function (msg) {
                    $("#canton").val(msg)
                }
            });
        }
    }

    function cargarParroquia() {
        if ($("#obraId").val() * 1 > 0) {
            $.ajax({
                type    : "POST",
                url : "${g.createLink(controller: 'contrato',action:'cargarParroquia')}",
                data    : "id=" + $("#obraId").val(),
                success : function (msg) {
                    $("#parr").val(msg)
                }
            });
        }
    }

    function cargarClaseObra() {
        if ($("#obraId").val() * 1 > 0) {
            $.ajax({
                type    : "POST",
                url : "${g.createLink(controller: 'contrato',action:'cargarClase')}",
                data    : "id=" + $("#obraId").val(),
                success : function (msg) {
                    $("#clase").val(msg)
                }
            });
        }
    }

    function cargarPorcentajeAnticipo() {
        if ($("#obraId").val() * 1 > 0) {
            $.ajax({
                type    : "POST",
                url : "${g.createLink(controller: 'contrato',action:'cargarPorcentaje')}",
                data    : "id=" + $("#obraId").val(),
                success : function (msg) {
                    $("#porcentajeAnticipo").val(msg)
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
        var criterio = $("#criterioObra").val();
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

    $("#criterioCriterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            buscaContratos();
            return false;
        }
    });

    function buscaContratos() {
        var buscarPor = $("#buscarPor").val();
        var tipo = $("#buscarTipo").val();
        var criterio = $("#criterioCriterio").val();
        console.log('criterio', criterio)
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
        if($(".indiceOferta").val()){
            $("#frmRegistroContrato").submit();
        }else{
            bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i> No ha seleccionado un indice")
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
                if (parts[0] === "ok") {
                    bootbox.alert("<i class='fa fa-check fa-3x text-success'></i> Contrato registrado");
                    setTimeout(function () {
                        location.href = "${g.createLink(controller: 'contrato', action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
                    }, 800);
                } else {
                    spinner.replaceWith($btn);
                    bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + parts[1])
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
                bootbox.alert("<i class='fa fa-check fa-3x text-success'></i> Contrato sin registro");
                setTimeout(function () {
                    location.href = "${g.createLink(controller: 'contrato', action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
                }, 800);
            }
        });
    });

    $("#btn-cancelar").click(function () {
        if (${contrato?.id == null}) {
            location.href = "${g.createLink(action: 'registroContrato')}";
        } else {
            location.href = "${g.createLink(action: 'registroContrato')}" + "?contrato=" + "${contrato?.id}";
        }
    });

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