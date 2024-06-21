<%@ page import="janus.FormulaPolinomica; janus.pac.Concurso; janus.Departamento" contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <meta name="layout" content="main">
    <asset:javascript src="/jquery/plugins/jquery-validation-1.9.0/jquery.validate.min.js"/>
    <asset:javascript src="/jquery/plugins/jquery-validation-1.9.0/messages_es.js"/>
    <asset:javascript src="/jquery/plugins/jquery.livequery.js"/>
    <asset:javascript src="/jquery/plugins/box/js/jquery.luz.box.js"/>

    <style type="text/css">

    .formato {
        font-weight: bolder;
    }

    .titulo {
        font-size: 20px;
    }

    .editable {
        border-bottom: 1px dashed;
    }

    .error {
        background  : inherit !important;
        border: solid 1px #c14211;
        font-weight: bold;
    }

    .ui-dialog-titlebar-close {
        background-color: white !important;
        color: black;
        padding: 2px;
        padding-top: -5px !important;
    }

    </style>

    <title>REGISTRO DE OBRAS</title>
</head>

<body>
<g:if test="${flash.message}">
    <div class="col-md-12" style="margin-bottom: 10px;">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${flash.message}
        </div>
    </div>
</g:if>

<div class="col-md-6 hide" style="margin-bottom: 10px;" id="divError">
    <div class="alert alert-error" role="status">
        <a class="close" data-dismiss="alert" href="#">×</a>
        <span id="spanError"></span>
    </div>
</div>

<div class="col-md-6 hide" style="margin-bottom: 10px;" id="divOk">
    <div class="alert alert-info" role="status">
        <a class="close" data-dismiss="alert" href="#">×</a>
        <span id="spanOk"></span>
    </div>
</div>

<div id="spinner" class="row col-md-12 hide" style="z-index: 1; position: absolute; border: 1px solid black;
width: 160px; height: 120px; top: 10%; left: 40%; background-color: #cdcdcd; text-align: center">
    <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Cargando...' width="64px" height="64px" z-index="100"/>
    <p>Cargando...Por favor espere</p>
</div>


<div class="col-md-6 btn-group" role="navigation" style="margin-left: 0px;width: 100%;float: left;height: 35px;">
    <button class="btn btn-info" id="lista"><i class="fa fa-list"></i> Lista</button>
    <button class="btn" id="nuevo"><i class="fa fa-plus"></i> Nuevo</button>

    <g:if test="${persona?.departamento?.codigo != 'UTFPU'}">

        <g:if test="${obra?.estado != 'R'}">
            <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1) || obra?.id == null}">
                <button class="btn btn-success" id="btn-aceptar"><i class="fa fa-save"></i> Grabar
                </button>
            </g:if>
        </g:if>

        <g:if test="${obra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id || obra?.id == null}">
            <button class="btn" id="cancelarObra"><i class="fa fa-times"></i> Cancelar</button>
        </g:if>

        <g:if test="${obra?.id != null}">

            <button class="btn" id="btnImprimir"><i class=" fa fa-print"></i> Imprimir</button>
        </g:if>
        <g:if test="${obra?.liquidacion == 0}">
            <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1) && (Concurso.countByObra(obra) == 0)}">
            %{--las obras tuipo 'O' son migradas de oferentes no se pueden desregistrar--}%
                <g:if test="${obra?.fechaInicio == null && obra?.tipo != 'O'}">
                    <button class="btn" id="cambiarEstado"><i class="fa fa-retweet"></i> Cambiar de Estado</button>
                </g:if>
            </g:if>

            <g:if test="${obra?.id != null}">
                <button class="btn" id="copiarObra"><i class="fa fa-copy"></i> Copiar Obra</button>
            </g:if>

            <g:if test="${obra?.id != null && obra?.estado == 'R' && perfil.codigo == 'CNTR' && concurso}">
                <g:if test="${!existeObraOferente}">
                    <button class="btn" id="copiarObraOfe"><i class="fa fa-copy"></i> Copiar Obra a Oferentes
                    </button>
                </g:if>g
            </g:if>
        </g:if>
        <g:if test="${obra?.estado == 'R' && obra?.tipo == 'D'}">
            <g:if test="${!obra?.fechaInicio}">
                <button class="btn btn-azul" id="btn-adminDirecta"><i class="fa fa-thumbs-up"></i> Iniciar obra
                </button>
            </g:if>
        </g:if>
        <g:if test="${obra?.estado == 'R' && obra?.tipo != 'D'}">
            <g:if test="${!obra?.fechaInicio}">
                <button class="btn" id="btn-memoSIF"><i class="fa fa-file"></i> Memo al S.I.F.
                </button>
            </g:if>
            <g:if test="${obra?.memoSif != "" && obra?.estadoSif != 'R'}">
                <button class="btn" id="btn-aprobarSif"><i class="fa fa-file"></i> Aprobar S.I.F.
                </button>
            </g:if>
        </g:if>
    </g:if>
    <g:else>%{-- usuario de UTFPU --}%

        <g:if test="${obra?.estado != 'R'}">
            <g:if test="${duenoObra == 1 || obra?.id == null}">
                <button class="btn btn-success" id="btn-aceptar"><i class="fa fa-save"></i> Grabar</button>
            </g:if>
        </g:if>

        <g:if test="${duenoObra == 1 || obra?.id == null}">
            <button class="btn" id="cancelarObra"><i class="fa fa-times"></i> Cancelar</button>
        </g:if>
        <g:if test="${obra?.liquidacion == 0}">
            <g:if test="${obra?.estado != 'R'}">
                <g:if test="${duenoObra == 1 || obra?.id == null}">
                    <button class="btn" id="eliminarObra"><i class="fa fa-trash"></i> Eliminar la Obra</button>
                </g:if>
            </g:if>
        </g:if>
        <g:if test="${obra?.id != null}">

            <button class="btn" id="btnImprimir"><i class="fa fa-print"></i> Imprimir</button>
        </g:if>
        <g:if test="${obra?.liquidacion == 0}">
            <g:if test="${duenoObra == 1 && (Concurso.countByObra(obra) == 0) && (obra?.codigo[-2..-1] != 'OF')}">
                <g:if test="${obra?.fechaInicio == null}">
                    <button class="btn" id="cambiarEstado"><i class="fa fa-retweet"></i> Cambiar de Estado</button>
                </g:if>
            </g:if>

            <g:if test="${obra?.id != null}">
                <button class="btn" id="copiarObra"><i class="fa fa-copy"></i> Copiar Obra</button>
            </g:if>

            <g:if test="${obra?.id != null && obra?.estado == 'R' && perfil.codigo == 'CNTR' && concurso}">
                <g:if test="${!existeObraOferente}">
                    <button class="btn" id="copiarObraOfe"><i class="fa fa-copy"></i> Copiar Obra a Oferentes
                    </button>
                </g:if>
            </g:if>
        </g:if>

        <g:if test="${obra?.estado == 'R' && obra?.tipo == 'D'}">
            <g:if test="${!obra?.fechaInicio}">
                <button class="btn" id="btn-adminDirecta"><i class="fa fa-thumbs-up" ></i> Iniciar obra
                </button>
            </g:if>
        </g:if>
        <g:if test="${obra?.estado == 'R' && obra?.tipo != 'D'}">
            <g:if test="${!obra?.fechaInicio}">
                <button class="btn" id="btn-memoSIF"><i class="fa fa-file"></i> Memo al S.I.F.
                </button>
            </g:if>
            <g:if test="${obra?.memoSif != "" && obra?.estadoSif != 'R'}">
                <button class="btn" id="btn-aprobarSif"><i class="fa fa-file"></i> Aprobar S.I.F.
                </button>
            </g:if>
        </g:if>

    </g:else>

    <g:if test="${obra?.id}">
        <g:if test="${obra?.estado != 'R'}">
            <button class="btn" id="revisarPrecios"><i class="fa fa-list"></i> Precios 0</button>
        </g:if>
    </g:if>

    <g:if test="${obra?.tipo == 'O'}">
        <button class="btn btn-danger" id="revisarPrecios" disabled><i class="fa fa-check"></i> Importada de Oferentes</button>
    </g:if>
</div>

<g:form class="registroObra" name="frm-registroObra" action="save">
    <g:hiddenField name="crono" value="0"/>

    <div style="width: 100%; float:left; border: 1px solid black;padding-left: 50px;margin-top: 20px;position: relative;
    height: 100px; background-color: #e8e8ef">
        <g:hiddenField name="id" value="${obra?.id}"/>
        <div style="margin-top: 15px" align="center">

            <p class="css-vertical-text">Ingreso</p>

            <div class="linea" style="height: 70%;"></div>

        </div>
        <div class="row-fluid">
            <g:if test="${obra?.tipo == 'D'}">
                <g:if test="${session.perfil.codigo == 'ADDI'}">
                    <div class="span 12"
                         style="margin-top: -15px; margin-left: 500px; color: #008; font-size: 14px;">ADMINISTRACIÓN DIRECTA</div>
                </g:if>
                <g:else>
                    <g:if test="${session.perfil.codigo == 'COGS'}">
                        <div class="span 12"
                             style="margin-top: -15px; margin-left: 500px; color: #008; font-size: 14px;">COGESTIÓN</div>
                    </g:if>
                    <g:else>
                        <div class="span 12"
                             style="margin-top: -15px; margin-left: 500px; color: #008; font-size: 14px;">ADMINISTRACIÓN DIRECTA / COGESTIÓN</div>
                    </g:else>
                </g:else>
            </g:if>

            <div class="col-md-12" style="margin-top: 20px">
                <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
                    <div class="col-md-1 formato">Requirente</div>

                    <div class="col-md-3">
                        <g:if test="${obra?.id}">
                            <g:if test="${duenoObra == 1}">
                                <g:select name="departamento.id"
                                          from="${Departamento.findAllByRequirente(1, [sort: 'direccion'])}"
                                          id="departamento" value="${obra?.departamento?.id?:21}"
                                          optionKey="id" optionValue="${{ it.direccion.nombre + ' - ' + it.descripcion }}"
                                          dire="${{ it.direccion.id }}" style="width: 670px; margin-left: 40px"/>

                            </g:if>
                            <g:else>
                                <g:hiddenField name="departamento.id" id="departamentoDire"
                                               value="${obra?.departamento?.direccion?.id}"/>
                                <g:hiddenField name="departamentoId" id="departamentoId" value="${obra?.departamento?.id}"/>

                                <g:textField name="departamentoText" id="departamentoObra" value="${obra?.departamento}"
                                             style="width: 670px; margin-left: 40px" readonly="true"
                                             title="Dirección actual del usuario"/>
                            </g:else>
                        </g:if>
                        <g:else>
                            <g:select name="departamento.id"
                                      from="${Departamento.findAllByRequirente(1, [sort: 'direccion'])}" id="departamento"
                                      value="${persona?.departamento?.id}"
                                      optionKey="id" optionValue="${{ it.direccion.nombre + ' - ' + it.descripcion }}"
                                      optionClass="${{ it.direccion.id }}" style="width: 670px; margin-left: 40px"/>
                        </g:else>
                    </div>
                </g:if>
                <g:else>
                    <div class="col-md-1 formato">DIRECCIÓN</div>

                    <div class="col-md-3">
                        <g:if test="${obra?.id}">
                            <g:hiddenField name="departamento.id" id="departamentoObra" value="${obra?.departamento?.id}"/>
                            <g:hiddenField name="per.id" id="per" value="${persona?.departamento?.id}"/>

                            <g:textField name="departamentoText" id="departamentoText" value="${obra?.departamento}"
                                         style="width: 670px; margin-left: 40px" readonly="true"
                                         title="Dirección actual del usuario"/>
                        </g:if>
                        <g:else>

                            <g:hiddenField name="departamento.id" id="departamentoObra"
                                           value="${persona?.departamento?.id}"/>
                            <g:hiddenField name="per.id" id="per" value="${persona?.departamento?.id}"/>
                            <g:textField name="departamentoText" id="departamentoText" value="${persona?.departamento}"
                                         style="width: 670px; margin-left: 40px" readonly="true"
                                         title="Dirección actual del usuario"/>
                        </g:else>
                    </div>
                </g:else>

                <div class="col-md-1" style="margin-left: 506px; font-weight: bold">ESTADO</div>

                <div class="col-md-1">
                    <g:if test="${obra?.estado == null}">
                        <g:textField name="estadoNom" class="estado" value="${'N'}" disabled="true"
                                     style="width: 30px; font-weight: bold" title="Estado de la Obra"/>
                        <g:hiddenField name="estado" id="estado" class="estado" value="${'N'}"/>
                    </g:if>

                    <g:else>
                        <g:textField name="estadoNom" class="estado" value="${obra?.estado}" disabled="true"
                                     style="width: 30px; font-weight: bold" title="Estado de la Obra"/>
                        <g:hiddenField name="estado" id="estado" class="estado" value="${obra?.estado}"/>
                    </g:else>
                </div>

            </div>

            <div class="col-md-12" style="margin-top: 10px">

                <div class="col-md-1 formato" style="width: 200px;">Documento de referencia</div>

                <div class="col-md-2">
                    <g:textField name="oficioIngreso" class="memo allCaps" value="${obra?.oficioIngreso}" maxlength="20"
                                 style="width: 120px; margin-left: -10px" title="Número del Oficio de Ingreso"/>
                </div>

                <div class="col-md-2 formato" style="width: 200px; margin-left: -10px;">Memorando cantidad de obra</div>

                <div class="col-md-2"><g:textField name="memoCantidadObra" class="cantidad allCaps"
                                                   value="${obra?.memoCantidadObra}" maxlength="20"
                                                   style="width: 120px; margin-left: -20px"
                                                   title="Memorandum u oficio de cantidad de obra"/></div>

                <div class="col-md-1 formato" style="margin-left: -20px;">Fecha</div>
                <div class="col-md-1"  style="width: 170px; margin-left: -40px">
                    <input aria-label="" name="fechaCreacionObra" id='fechaCreacionObra' type='text' class="required input-small"
                           value="${obra?.fechaCreacionObra?.format('dd-MM-yyyy') ?: fcha.format('dd-MM-yyyy')}"/>
                </div>
            </div>
        </div>
        %{--</fieldset>--}%
    </div>

    <div style="width: 100%; float:left; border: 1px solid black;padding-left: 0px; margin-top: 0px; height: auto">

        <g:if test="${obra?.tipo == 'D'}">
            <div class="col-md-12" style="margin-top: 15px" align="center">
                <div class="linea" style="height: 90%;"></div>
            </div>
        </g:if>
        <div class="col-md-12" style="margin-top: 10px">
            <div class="col-md-1">Código:</div>

            <g:if test="${obra?.codigo != null}">
                <div class="col-md-3"><g:textField name="codigo" class="codigo required allCaps"
                                                   value="${obra?.codigo}" style="width: 160px" readonly="readonly" maxlength="20"
                                                   title="Código de la Obra"/></div>
            </g:if>
            <g:else>
                <div class="col-md-3"><g:textField name="codigo" class="codigo required allCaps" value="${obra?.codigo}"
                                                   style="width: 160px" maxlength="20" title="Código de la Obra"/></div>
            </g:else>

            <div class="col-md-1" style="margin-left: -80px;">Nombre</div>

            <div class="col-md-7">
                <g:textField name="nombre" class="nombre required"
                             style="margin-left: -30px; width: 750px" value="${obra?.nombre}"
                             maxlength="127" title="Nombre de la Obra"/></div>
        </div>

        <div class="row-fluid col-md-12" style="margin-top: 10px">
            <div class="col-md-1">Programa</div>

            <div class="col-md-3">
                <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
                    <g:select id="programacion" name="programacion.id" class="programacion required" from="${programa}"
                              value="${obra?.programacion?.id}" optionValue="descripcion" optionKey="id"
                              title="Programa"/>
                    <a href="#" class="btn btn-xs btn-info" id="btnCrearPrograma" title="Crear Programa"
                       style="margin-top: -10px;">
                        <i class="fa fa-plus-square"></i>
                    </a>
                </g:if>
                <g:else>
                    <g:select id="programacion" name="programacion.id" class="programacion required" from="${programa}"
                              value="${obra?.programacion?.id}" optionValue="descripcion" optionKey="id"
                              title="Programa"/>
                </g:else>
            </div>

            <div class="col-md-1" style="margin-left: -50px;">Tipo</div>

            <div class="col-md-4" id="divTipoObra">
                <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
                    <g:select id="tipoObra" name="tipoObjetivo.id" class="tipoObjetivo required" from="${tipoObra}"
                              value="${obra?.tipoObjetivo?.id}" optionValue="descripcion" optionKey="id"
                              style="margin-left: -60px; width: 290px" title="Tipo de Obra"/>
                    <a href="#" class="btn btn-xs btn-info" id="btnCrearTipoObra" title="Crear Tipo"
                       style="margin-top: -10px;">
                        <i class="fa fa-plus-square"></i>
                    </a>
                </g:if>
                <g:else>
                    <g:select id="tipoObra" name="tipoObjetivo.id" class="tipoObjetivo required" from="${tipoObra}"
                              value="${obra?.tipoObjetivo?.id}" optionValue="descripcion" optionKey="id"
                              style="margin-left: -60px; width: 290px" title="Tipo de Obra"/>
                </g:else>
            </div>

            <div class="col-md-1" style="margin-left: -50px">Clase</div>

            <div class="col-md-3">
                <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
                    <g:select id="claseObra" name="claseObra.id" class="claseObra required" from="${claseObra}"
                              value="${obra?.claseObra?.id}" optionValue="descripcion" optionKey="id"
                              style="margin-left: -40px; width: 250px" title="Clase de Obra"/>
                    <a href="#" class="btn btn-xs btn-info" id="btnCrearClase" title="Crear Clase"
                       style="margin-top: -10px;">
                        <i class="fa fa-plus-square"></i>
                    </a>
                </g:if>
                <g:else>
                    <g:select id="claseObra" name="claseObra.id" class="claseObra required" from="${claseObra}"
                              value="${obra?.claseObra?.id}" optionValue="descripcion" optionKey="id"
                              style="margin-left: -40px; width: 250px" title="Clase de Obra"/>
                </g:else>
            </div>
        </div>


        <div class="row-fluid col-md-12" style="margin-top: 10px">
            <div class="col-md-1">Descripción de la Obra</div>

            <div class="col-md-8"><g:textArea name="descripcion" rows="5" cols="5" class="required"
                                              style="width:100%; height: 40px; resize: none" maxlength="511"
                                              value="${obra?.descripcion}" title="Descripción"/></div>
            <div class="col-md-1">Código CPC</div>
            <div class="col-md-1">
                <g:hiddenField name="codigoComprasPublicas" value="${obra?.codigoComprasPublicas?.id}"/>
                <g:textField style="margin-left: -30px; width: 120px;" name="codigoCPCNombre" id="item_codigo" class=""
                             value="${obra?.codigoComprasPublicas?.numero}" readonly=""/>

            </div>
            <div class="col-md-1">
                <a href="#" class="btn btn-xs btn-info" id="btnCodigoCPC" title="Seleccionar código CPC"
                   style="margin-top: 0px;">
                    <i class="fa fa-plus-square"></i>
                </a>
            </div>

        </div>

        <div class="row-fluid col-md-12" style="margin-top: 10px">
            <div class="col-md-2" style="width: 185px;">Referencia (Gestión / Disposición):</div>

            <div class="col-md-5"><g:textField name="referencia" class="referencia"
                                               style="width: 470px; margin-left: -60px" value="${obra?.referencia}"
                                               maxlength="127"
                                               title="Referencia de la disposición para realizar la Obra"/></div>

            <div class="col-md-1" style="width: 150px; margin-left: -10px">Longitud de la vía(m):</div>

            <div class="col-md-1"><g:textField name="longitudVia" class="referencia number" type="number"
                                               style="width: 100px; margin-left: -30px" maxlength="9"
                                               value="${g.formatNumber(number: obra?.longitudVia, maxFractionDigits: 1, minFractionDigits: 1, format: '##,##0', locale: 'ec')}"
                                               title="Longitud de la vía en metros. Sólo obras viales"/></div>

            <div class="col-md-1" style="width: 130px; margin-left: 0px">Ancho de la vía(m):</div>

            <div class="col-md-1"><g:textField name="anchoVia" class="referencia number" type="number"
                                               style="width: 100px; margin-left: -10px" maxlength="4"
                                               value="${g.formatNumber(number: obra?.anchoVia, maxFractionDigits: 1, minFractionDigits: 1, format: '##,##0', locale: 'ec')}"
                                               title="Ancho de la vía en metros. Sólo obras viales"/></div>
        </div>

        <div class="row-fluid col-md-12" style="margin-top: 10px" id="filaPersonas">
        </div>

        <div class="col-md-12">
            <div class="col-md-1" style="margin-top: 15px; width: 90px;">
                <button class="btn btn-buscar btn-info btn-xs" id="btn-buscar"><i class="fa fa-globe"></i> Buscar</button>
            </div>

            <div class="col-md-2" style="width: 220px; margin-left: 10px;">Cantón
            <g:hiddenField name="canton.id" id="hiddenCanton" value="${obra?.comunidad?.parroquia?.canton?.id}"/>
            <g:textField style="width: 210px;" name="cantonkk.id" id="cantNombre" class="canton required"
                         value="${obra?.comunidad?.parroquia?.canton?.nombre}" readonly="true" title="Cantón"/>
            </div>

            <div class="col-md-2" style="width: 200px; margin-left: 10px;">Parroquia
            <g:hiddenField name="parroquia.id" id="hiddenParroquia" value="${obra?.comunidad?.parroquia?.id}"/>
            <g:textField style="width: 190px;" name="parroquiakk.id" id="parrNombre" class="parroquia required"
                         value="${obra?.comunidad?.parroquia?.nombre}" readonly="true" title="Parroquia"/>
            </div>

            <div class="col-md-2" style="width: 200px; margin-left: 10px;">Comunidad
            <g:hiddenField name="comunidad.id" id="hiddenComunidad" value="${obra?.comunidad?.id}"/>
            <g:textField style="width: 190px;" name="comunidadkk.id" id="comuNombre" class="comunidad required"
                         value="${obra?.comunidad?.nombre}" readonly="true" title="Comunidad"/>
            </div>

            <div class="col-md-2" style="width: 355px; margin-left: 10px;">Sitio
            <g:textField style="width: 355px;margin-left:0px;" name="sitio" class="sitio" value="${obra?.sitio}" maxlength="63" title="Sitio urbano o rural"/>
            </div>
        </div>

        <div class="col-md-12" style="margin-top: 10px;">

            <div class="col-md-2">Localidad</div>

            <div class="col-md-4" style="margin-left: -70px; width: 480px;">
                <g:textField style="width: 440px;" name="barrio" class="barrio" value="${obra?.barrio}" maxlength="127"
                             title="Barrio, asentamiento, recinto o localidad"/></div>

            <div class="col-md-1" style="margin-left: 40px; width: 50px;">Anticipo</div>

            <div class="col-md-2" style="margin-left: 10px; width: 120px;">
                <g:textField name="porcentajeAnticipo" type="number" class="anticipo number required"
                             style="width: 40px" value="${obra?.porcentajeAnticipo >=0? obra?.porcentajeAnticipo : 50}" maxlength="3"
                             title="Porcentaje de Anticipo"/> %</div>

            <g:if test="${matrizOk}">
                <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id &&
                        duenoObra == 1) || obra?.id == null}">
                    <div class="col-md-1" style="margin-left: -40px; width: 100px;">
                        <g:link action="calculaPlazo" id="${obra.id}" style="margin-left: 0px;" class="btn btn-info btn-xs"><i class="fa fa-cog"></i> Calcular</g:link>
                    </div>
                </g:if>
            </g:if>

            <div class="col-md-1" style="margin-left: -10px; width:50px;">Plazo</div>

            <g:if test="${obra?.plazoEjecucionMeses == null}">
                <div class="col-md-2" style="margin-left: -10px; width: 130px;">
                    <g:textField name="plazoEjecucionMeses" class="plazoMeses plazo required number" style="width: 28px"
                                 data-original="${obra?.plazoEjecucionMeses}"
                                 maxlength="3" type="number" value="${'1'}" title="Plazo de ejecución en meses"/> Meses
                </div>
            </g:if>
            <g:else>
                <div class="col-md-2" style="margin-left: -10px; width: 120px;">
                    <g:textField name="plazoEjecucionMeses" class="plazoMeses plazo required number" style="width: 28px"
                                 data-original="${obra?.plazoEjecucionMeses}"
                                 maxlength="3" type="number" value="${obra?.plazoEjecucionMeses}"
                                 title="Plazo de ejecución en meses"/> Meses
                </div>
            </g:else>
            <g:if test="${obra?.plazoEjecucionDias == null}">
                <div class="col-md-2" style="margin-left: -40px; width: 100px;">
                    <g:textField name="plazoEjecucionDias" class="plazoDias  plazo required number " max="29"
                                 style="width: 28px" data-original="${obra?.plazoEjecucionDias}"
                                 maxlength="2" type="number" value="${'0'}" title="Plazo de ejecución en días"/> Días
                </div>
            </g:if>
            <g:else>
                <div class="col-md-2" style="margin-left: -30px; width: 100px;">
                    <g:textField name="plazoEjecucionDias" class="plazoDias  plazo required number " max="29"
                                 style="width: 28px" data-original="${obra?.plazoEjecucionDias}"
                                 maxlength="2" type="number" value="${obra?.plazoEjecucionDias}"
                                 title="Plazo de ejecución en días"/> Días
                </div>
            </g:else>
        </div>

        <div class="col-md-12" style="margin-top: 10px">
            <div class="col-md-1">Observaciones</div>
            <div class="col-md-5" style="width: 400px;"><g:textField name="observaciones" class="observaciones"
                                                                     style="width: 400px;" value="${obra?.observaciones}" maxlength="127" title="Observaciones"/></div>
            <div class="col-md-1" style="margin-left: 50px; width: 120px">Anexos y planos:</div>
            <div class="col-md-5" style="width: 400px;"><g:textField name="anexos" class="referencia"
                                                                     style="width: 475px; margin-left: -30px;" value="${obra?.anexos}" maxlength="127"
                                                                     title="Detalle de anexos y planos ingresados en la biblioteca de la obra"/></div>
        </div>

        <div class="col-md-12" style="margin-top: 10px;margin-bottom: 5px">
            <div class="col-md-2" style="width: 200px;">Lista de precios: MO y Equipos</div>

            <div class="col-md-2" style="margin-right: 20px; margin-left: 0px; width: 200px;"><g:select
                    style="width: 200px;" name="listaManoObra.id"
                    from="${janus.Lugar.findAll('from Lugar  where tipoLista=6')}" optionKey="id"
                    optionValue="descripcion" value="${obra?.listaManoObra?.id}"
                    title="Precios para Mano de Obra y Equipos"/></div>

            <div class="col-md-1" style="margin-left: 30px">Fecha</div>

            <div class="col-md-2" style="margin-left: -30px;">
                <input aria-label="" name="fechaPreciosRubros" id='fechaPreciosRubros' type='text' class="required input-small"
                       value="${obra?.fechaPreciosRubros?.format('dd-MM-yyyy') ?: fcha.format('dd-MM-yyyy')}"/>
            </div>

            <div class="col-md-1" style="margin-left: 30px">Coordenadas:</div>

            <div class="col-md-3" style="font-size: 10px">
                <g:set var="coords" value="${obra?.coordenadas}"/>
                <g:if test="${obra?.id == null || coords == null || coords?.trim() == ''}">
                    <g:set var="coords" value="${'S 0 12.5999999 W 78 31.194'}"/>
                </g:if>
                <g:hiddenField name="coordenadas" value="${coords}"/>
                %{--                <a href="#" id="coords" >--}%
                ${coords}
                %{--                </a>--}%
                <g:set var="coordsParts" value="${coords.split(' ')}"/>
            </div>
        </div>
    </div>

    <div style="width: 100%; float:left; border: 1px solid black; position: relative;
    padding-left: 30px; height: 65px; background-color: #e8e8ef">
        <div style="margin-top: 5px" align="center">
            <p class="css-vertical-text">Salida</p>
            <div class="linea" style="height: 100%;"></div>
            <div class="row-fluid" style="margin-top: 20px" id="dirSalida">
            </div>
        </div>
    </div>
</g:form>

<div id="busqueda-geo">

    <fieldset class="borde">
        <div class="col-md-10">
            <div class="col-md-2" style="width: 90px">Buscar Por</div>
            <div class="col-md-2"><g:select name="buscarPor-geo" class="buscarPor"
                                            from="['1': 'Provincia', '2': 'Cantón', '3': 'Parroquia', '4': 'Comunidad']"
                                            style="width: 100px; margin-left: -20px" optionKey="key"
                                            optionValue="value"/></div>
            <div class="col-md-2">Criterio</div>
            <div class="col-md-2" style="margin-left: -50px"><g:textField name="criterio-geo" class="criterio" style="width: 80px"/></div>
            <div class="col-md-2">Ordenar</div>
            <div class="col-md-2"><g:select name="ordenar-geo" class="ordenar" from="['1': 'Ascendente', '2': 'Descendente']"
                                            style="width: 120px; margin-left: -40px;" optionKey="key"
                                            optionValue="value"/></div>
        </div>

        <div class="col-md-2" style="margin-left: -10px">
            <button class="btn btn-info" id="btn-consultar-geo"><i
                    class="fa fa-search"></i> Buscar
            </button>
        </div>

    </fieldset>

    <fieldset class="borde">
        <div id="divTabla" style="height: 460px; overflow-y:auto; overflow-x: auto;">
        </div>
    </fieldset>
</div>

<div id="busqueda_CPC">
    <fieldset class="borde">
        <div class="col-md-8">
            <div class="col-md-3">
                <label>Buscar Por</label>
                <g:select name="buscarPor_CPC" class="buscarPor_CPC"
                          from="['1': 'Código', '2': 'Descripción']"
                          optionKey="key"
                          optionValue="value"/>
            </div>

            <div class="col-md-5" >
                <label>Criterio</label>
                <g:textField name="criterio_CPC" class="criterio_CPC" />
            </div>

            <div class="col-md-3">
                <label>Ordenar</label>
                <g:select name="ordenar_CPC" class="ordenar_CPC" from="['1': 'Ascendente', '2': 'Descendente']"
                          optionKey="key" optionValue="value" />
            </div>

        </div>

        <div class="col-md-2" style="margin-left: 10px; margin-top: 10px">
            <button class="btn btn-info" id="btn-consultar_CPC"><i
                    class="fa fa-search"></i> Buscar
            </button>
        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTabla_CPC" style="height: 460px; overflow-y:auto; overflow-x: auto;">
        </div>
    </fieldset>
</div>


<div id="estadoDialog">
    <fieldset>
        <div class="col-md-12">
            Está seguro de querer cambiar el estado de la obra:<div style="font-weight: bold;">${obra?.nombre} ?
        </div>
            <br>
            <span style="color: red">
                Una vez registrada los datos de la obra no podrán ser editados.
            </span>
        </div>
    </fieldset>
</div>

<div id="documentosDialog">
    <fieldset>
        <div class="col-md-3">
            Primero debe registrar la obra para poder imprimir los documentos.
        </div>
    </fieldset>
</div>

<div id="eliminarObraDialog">
    <fieldset>
        <div class="col-md-12">
            Esta seguro que desea eliminar la Obra:<div style="font-weight: bold">${obra?.nombre}</div>
        </div>
    </fieldset>
</div>

<div id="noEliminarDialog">
    <fieldset>
        <div class="col-md-3">
            No se puede eliminar la obra, porque contiene valores dentro de Volumenes de Obra o Fórmula Polinómica.
        </div>
    </fieldset>
</div>

<div id="copiarDialog">
    <fieldset>
        <div class="col-md-12">
            Por favor ingrese un nuevo código para la copia de la obra: <div
                style="font-weight: bold">${obra?.nombre}</div>
        </div>

        <div class="col-md-12" style="margin-top: 30px">
            <div class="col-md-5">Nuevo Código:</div>

            <div class="col-md-6"><g:textField name="nuevoCodigo" value="${obra?.codigo}" maxlength="20" class="allCaps" /></div>
        </div>
    </fieldset>
</div>

<div id="copiarDialogOfe">
    <fieldset>
        <div class="col-md-12">
            Seleccione el oferente para la obra: <div style="font-weight: bold">${obra?.nombre}</div>
        </div>

        <div class="col-md-12" style="margin-top: 10px">
            <div class="col-md-10">
                <g:select name="oferenteCopia"
                          from="${seguridad.Persona.findAllByDepartamento(Departamento.get(13), [sort: 'nombre'])}"
                          optionKey="id" optionValue="${{
                    it.nombre + ' ' + it.apellido
                }}"/>
            </div>
        </div>
    </fieldset>
</div>

<g:if test="${obra?.id}">
    <div class="btn-group" style="margin-top: 10px;padding-left: 5px;float: left" align="center">

        <a href="#" id="btnVar" class="btn"><i class="fa fa-edit"></i> Variables</a>
        <a href="${g.createLink(controller: 'volumenObra', action: 'volObra', id: obra?.id)}" class="btn"><i
                class="fa fa-list"></i> Vol. Obra
        </a>
        <a href="#" id="matriz" class="btn"><i class="fa fa-table"></i> Matriz FP</a>

        <a href="#" id="btnFormula" class="btn"><i class="fa fa-money-bill"></i> Fórmula Pol.

            <a href="#" id="btnRubros" class="btn"><i class="fa fa-money-bill"></i> Rubros</a>
            <a href="#" id="btnDocumentos" class="btn"><i class="fa fa-file"></i> Documentos</a>
            <a href="${g.createLink(controller: 'cronograma', action: 'cronogramaObra', id: obra?.id)}" class="btn"><i
                    class="fa fa-calendar"></i> Cronograma
            </a>

            <g:link controller="variables" action="composicion" id="${obra?.id}" class="btn"><i
                    class="fa fa-paste"></i> Composición
            </g:link>


            <g:link controller="documentoObra" action="list" id="${obra.id}" class="btn">
                <i class="fa fa-book"></i> Biblioteca
            </g:link>

            <a href="#" id="btnMapa" class="btn"><i class="fa fa-map-marker"></i> Mapa</a>

            <a href="#" id="btnVeri" class="btn"><i class="fa fa-check"></i> Precios no Act.</a>

            <g:if test="${obra?.tipo != 'D'}">

                <g:link controller="variables" action="composicionVae" id="${obra?.id}" class="btn"><i
                        class="fa fa-paste"></i> Fijar VAE
                </g:link>

            </g:if>
            <g:if test="${obra?.estado == 'R' && obra?.tipo == 'D' && obra?.fechaInicio}">
                <a href="${g.createLink(controller: 'planillasAdmin', action: 'list', id: obra?.id)}"
                   id="btnPlanillas" class="btn">
                    <i class="fa fa-file"></i> Planillas
                </a>
            </g:if>
    </div>
</g:if>

<div id="modal-var">
    <div id="modal_body_var">

    </div>

    <div class="modal-footer" id="modal_footer_var">
    </div>
</div>

<div id="modal-TipoObra" style=";overflow: hidden;">
    <div class="modal-body" id="modalBody_tipo">

    </div>

    <div class="modal-footer" id="modalFooter_tipo">
    </div>
</div>

<div class="modal grandote hide fade " id="modal-busqueda" style=";overflow: hidden;">
    <div class="modal-header btn-primary">
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

<g:if test="${obra}">
    <div id="modal-matriz" style=";overflow: hidden;">

        <div class="modal-body" id="modal_body_matriz">
            <div id="msg_matriz">
                <g:if test="${obra.desgloseTransporte == 'S'}">
                    <p style="font-size: 14px; text-align: center;">Ya existe una matriz generada <b>con</b> desglose transporte
                    </p>
                </g:if>
                <g:else>
                    <g:if test="${obra.desgloseTransporte == 'N'}">
                        <p style="font-size: 14px; text-align: center;">Ya existe una matriz generada <b>sin</b> desglose transporte
                        </p>
                    </g:if>
                </g:else>

                <span style="margin-left: 100px;">Generada para:</span>
                <g:select name="matriz_gen" from="${sbprMF}" optionKey="key" optionValue="value"
                          style="margin-right: 20px; width: 400px" />

                <p style="margin-top: 20px">Desea volver a generar la matriz? o generar otra matriz</p>
                <div class="btn-group col-md-12">
                    <a href="#" class="btn" id="no">No -> Ver la Matriz existente</a>
                    <g:if test="${(obra?.responsableObra?.departamento?.direccion?.id == persona?.departamento?.direccion?.id && duenoObra == 1)}">
                        <a href="#" class="btn btn-azul" id="si">Si -> Generar Matriz</a>
                    </g:if>
                    <a href="#" class="btn" id="cancela" style="margin-left: 5px;"><i class="fa fa-times"></i> Cancelar</a>

                </div>
            </div>
        </div>

        <div id="datos_matriz" style="text-align: center">
            <span>Seleccione el subpresupuesto:</span>
            <g:select name="matriz_sub" from="${subs}" noSelection="['0': 'Todos los subpresupuestos']"
                      optionKey="id" optionValue="descripcion" style="margin-right: 20px; margin-bottom: 10px" />
        <p>Generar con desglose de Transporte <input type="checkbox" id="si_trans" style="margin-top: -3px"  checked="true">
            <g:if test="${FormulaPolinomica.countByObra(janus.Obra.get(obra?.id)) > 0}">
                <p>Borrar la Fórmula Polinómica<input type="checkbox" id="borra_fp" style="margin-top: -3px" checked="true">
            </g:if>
        </p>
            <a href="#" class="btn btn-azul" id="ok_matiz">Generar</a>
        </div>
    </div>

    </div>

    <div id="modal-formula">
        <div class="modal-body" id="modal_body_formula">
            <div id="msg_formula">
                <g:if test="${!matrizOk}">
                    <p style="font-size: 14px; text-align: center;">No existe una matriz de la fórmula polinómica</p>
                </g:if>
                <g:else>
                    <span style="margin-left: 100px;">Subpresupuesto:</span>
                    <g:select class="col-md-12" name="matriz_genFP" from="${sbprMF}" optionKey="key" optionValue="value"
                              style="margin-right: 20px;"/>
                    <div class="col-md-12" style="margin-top: 30px">
                        <a href="#" class="btn btn-azul" id="irFP">Ir a la Fórmula Polinómica</a>
                        <a href="#" class="btn btn" id="cancelaFP" style="margin-left: 60px;"> <i class="fa fa-times"></i> Cancelar</a>
                    </div>
                </g:else>
            </div>
        </div>
    </div>
</g:if>

<div id="admDirecta">
    <br>
    <b>Observaciones:</b><br><br>
    <textarea style="width: 90%;height: 80px;resize: none" id="descAdm" maxlength="250"></textarea>
    <br> <br>
    <b>Fecha de inicio:</b> <br><br>
    <elm:datepicker id="fechaInicio"></elm:datepicker>
</div>

<div id="errorDialog">
    <fieldset>
        <div class="col-md-3">
            Debe seleccionar un transporte especial válido!
            <br>(Tab: Tranp. Especial)</br>
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


    $("#btnCodigoCPC").click(function () {
        $("#dlgLoad").dialog("close");
        $("#busqueda_CPC").dialog("open");
        $(".ui-dialog-titlebar-close").html("x");
        return false;
    });

    $('#fechaCreacionObra').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        // daysOfWeekDisabled: [0, 6],
        sideBySide: true,
        icons: {
        }
    });

    $('#fechaPreciosRubros').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        // daysOfWeekDisabled: [0, 6],
        sideBySide: true,
        widgetPositioning: {
            horizontal: "left",
            vertical: "top"
        },
        icons: {
        }
    });

    //    $.jGrowl.defaults.closerTemplate = '<div>[ cerrar todo ]</div>';

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

    $("#modal-TipoObra").dialog({
        autoOpen: false,
        resizable: true,
        modal: true,
        draggable: false,
        width: 500,
        height: 290,
        position: 'center',
        title: 'Programa'
    });

    $("#cnsl-rubros").click(function () {
        buscaObras();
    });

    $("#criterioCriterio").keydown(function (ev) {
        if (ev.keyCode === 13) {
            ev.preventDefault();
            buscaObras();
            return false;
        }
    });

    function buscaObras() {
        var d = cargarLoader("Cargando...");
        var buscarPor = $("#buscarPor").val();
        var tipo = $("#buscarTipo").val();
        var criterio = $("#criterioCriterio").val();
        var ordenar = $("#ordenar").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'obra', action:'listaObras')}",
            data: {
                buscarPor: buscarPor,
                buscarTipo: tipo,
                criterio: criterio,
                ordenar: ordenar
            },
            success: function (msg) {
                d.modal("hide");
                $("#divTablaRbro").html(msg);
            }
        });
    }

    function enviarLq() {
        var data = "";
        $("#buscarDialog").hide();
        $("#spinner").show();
        $(".crit").each(function () {
            data += "&campos=" + $(this).attr("campo");
            data += "&operadores=" + $(this).attr("operador");
            data += "&criterios=" + $(this).attr("criterio");
        });
        if (data.length < 2) {
            data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" + $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
        }
        data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
        $.ajax({
            type: "POST", url: "${g.createLink(controller: 'obra',action:'buscarObraLq')}",
            data: data,
            success: function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });
    }

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
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#porcentajeAnticipo").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();
        if (parseFloat(enteros) > 100) {
            $(this).val(100)
        }
    });

    $("#longitudVia, #anchoVia, #latitud, #longitud").bind({
        keydown: function (ev) {
            // esta parte valida el punto: si empieza con punto le pone un 0 delante, si ya hay un punto lo ignora
            if (ev.keyCode === 190 || ev.keyCode === 110) {
                var val = $(this).val();
                if (val.length === 0) {
                    $(this).val("0");
                }
                return val.indexOf(".") === -1;
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

    $("#plazo").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();
    });

    function loadPersonas() {
        var idP;
        var idDep1;
        <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
        <g:if test="${obra}">
        <g:if test="${duenoObra == 1}">
        idP = $("#departamento option:selected").attr("class");
        idDep1 = $("#departamento option:selected").val();
        </g:if>
        <g:else>
        idP = $("#departamentoDire").val();
        idDep1 = $("#departamentoId").val();
        </g:else>
        </g:if>
        <g:else>
        idP = $("#departamento option:selected").attr("class");
        idDep1 = $("#departamento option:selected").val();
        </g:else>
        </g:if>
        <g:else>
        <g:if test="${obra}">
        idP = ${persona?.departamento?.direccion?.id}
            idDep1 = ${persona?.departamento?.id}
                </g:if>
                <g:else>
                idP = ${persona?.departamento?.direccion?.id}
                    idDep1 = ${persona?.departamento?.id}
        </g:else>
        </g:else>

        var idObra = ${obra?.id}
            $.ajax({
                type: "POST",
                url: "${g.createLink(action:'getPersonas2')}",
                data: {
                    id: idP,
                    idDep: idDep1,
                    obra: idObra
                },
                success: function (msg) {
                    $("#filaPersonas").html(msg);
                }
            });
    }

    $("#departamentoObra").change(function () {

        var idDep = $("#departamentoObra").val();
        var idObra = ${obra?.id}
            $.ajax({
                type: "POST",
                url: "${g.createLink(action:'getPersonas2')}",
                data: {
                    id: idDep,
                    obra: idObra

                },
                success: function (msg) {
                    $("#filaPersonas").html(msg);
                }
            });
    });

    $(function () {
        var memoSIF = "${obra?.memoSif?:''}";
        $("#btn-aprobarSif").click(function () {
            $.box({
                imageClass: "box_light",
                input: "<input type='text' name='memoSIF' id='memoSIF' maxlength='20' class='allCaps' disabled value='" + memoSIF + "' />",
                type: "prompt",
                title: "Memo S.I.F.",
                text: "Desea aprobar el memorando S.I.F.",
                dialog: {
                    open: function (event, ui) {
                        $(".ui-dialog-titlebar-close").html("X");
                    },
                    buttons: {
                        "Aprobar": function (r) {
                            $.ajax({
                                type: "POST",
                                url: "${createLink(action:'aprobarSif')}",
                                data: {
                                    obra: "${obra?.id}"
                                },
                                success: function (msg) {
                                    if (msg == "ok") {
                                        window.reload(true);
                                    }
                                }
                            });
                        }
                    }
                }
            });
        });

        $("#btn-setAdminDirecta").click(function () {
            $.box({
                imageClass: "box_info",
                title: "Confirmación",
                text: "<span style='font-size:larger; font-weight: bold;'>¿Está seguro de querer cambiar el tipo de " +
                    "la obra a administración directa?<br/>Recuerde que una vez cambiado el tipo no podrá " +
                    "revertir el cambio.</span>",
                iconClose: false,
                dialog: {
                    resizable: false,
                    draggable: false,
                    buttons: {
                        "Cambiar": function () {
                            location.href = "${createLink(action:'cambiarAdminDir', id:obra?.id)}";
                        },
                        "Cancelar": function () {
                        }
                    }
                }
            });
            return false;
        });

        $("#btn-memoSIF").click(function () {
            $.box({
                imageClass: "box_light",
                input: "<input type='text' name='memoSIF' id='memoSIF' maxlength='20' class='allCaps' ${(obra?.estadoSif !='R')?'disabled':''} value='" + memoSIF + "' />",
                type: "prompt",
                title: "Memo S.I.F.",
                <g:if test="${obra?.estadoSif!='R'}">
                text: "Memorando S.I.F. aprobado",
                </g:if>
                <g:else>
                text: "Ingrese el número de memorando de envío al S.I.F.",
                </g:else>
                dialog: {
                    open: function (event, ui) {
                        $(".ui-dialog-titlebar-close").html("X");
                    },
                    buttons: {
                        <g:if test="${obra?.estadoSif!='R'}">
                        "Cerrar": function (r) {

                        }
                        </g:if>
                        <g:else>
                        "Guardar": function (r) {
                            $.ajax({
                                type: "POST",
                                url: "${createLink(action:'saveMemoSIF')}",
                                data: {
                                    obra: "${obra?.id}",
                                    memo: r
                                },
                                success: function (msg) {
                                    var parts = msg.split("_");
                                    if (parts[0] === "OK") {
                                        memoSIF = parts[1];
                                        log("Se ha guardado correctamente el número de memorando de envío al S.I.F.", false);
                                    } else {
                                        log(parts[1], true);
                                    }
                                }
                            });
                        }
                        </g:else>
                    }
                }
            });
        });

        $("#btn-adminDirecta").click(function () {
            $("#admDirecta").dialog("open");
            $(".ui-dialog-titlebar-close").html("X");
        });
        $("#admDirecta").dialog({
            autoOpen: false,
            width: 500,
            height: 400,
            title: "Iniciar obra",
            modal: true,
            buttons: {
                "Cerrar": function () {
                    $(this).dialog('close');
                },
                "Iniciar obra": function () {
                    var obs = $("#descAdm").val();
                    var fec = $("#fechaInicio").val();
                    var msg = "";
                    if (obs.length > 250)
                        msg += "<br>El campo observaciones debe tener máximo 250 caracteres.";
                    if (!fec || fec === "") {
                        msg += "<br>Seleccione una fecha de inicio de obra."
                    }
                    if (msg !== "") {
                        $.box({
                            imageClass: "box_info",
                            text: msg,
                            title: "Errores",
                            iconClose: false,
                            dialog: {
                                resizable: false,
                                draggable: false
                            }
                        });
                    } else {
                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(action:'iniciarObraAdm' )}",
                            data: "obra=${obra?.id}&fecha=" + fec + "&obs=" + obs,
                            success: function (msg) {
                                if (msg === "ok")
                                    location.reload();
                                else {
                                    $.box({
                                        imageClass: "box_info",
                                        text: msg,
                                        title: "Errores",
                                        iconClose: false,
                                        dialog: {
                                            resizable: false,
                                            draggable: false
                                        }
                                    });
                                }
                            }
                        });
                    }

                }
            }
        });

        loadPersonas();

        %{--<g:if test="${persona?.departamento?.codigo == 'UTFPU'}">--}%
        loadSalida();
        %{--</g:if>--}%

        <g:if test="${obra}">

        $(".plazo").blur(function () {
            var $m = $("#plazoEjecucionMeses");
            var $d = $("#plazoEjecucionDias");

            var valM = $m.val();
            var oriM = $m.data("original");

            var valD = $d.val();
            var oriD = $d.data("original");

            if (parseFloat(valM) === parseFloat(oriM) && parseFloat(valD) === parseFloat(oriD)) {
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
                            "Si": function () {
                                $("#crono").val(1);
                                $("#frm-registroObra").submit();
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

        $("#modal-matriz").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 460,
            height: 240,
            position: 'center',
            title: 'Matriz'
        });

        $("#matriz").click(function () {
            $("#modal_title_matriz").html("Generar matriz");
            $("#datos_matriz").hide();
            $("#msg_matriz").show();
            $("#modal-matriz").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        });

        $("#no").click(function () {
            cargarLoader("Cargando Matriz...");
            var sb = $("#matriz_gen").val();
            location.href = "${g.createLink(controller: 'matriz',action: 'pantallaMatriz',id: obra?.id)}?sbpr=" + sb
        });

        $("#si").click(function () {
            $("#datos_matriz").show();
            $("#msg_matriz").hide()
        });
        $("#cancela").click(function () {
            $("#modal-matriz").dialog("close")
        });

        $("#btnGenerarFP").click(function () {
            var btn = $(this);
            var $btn = btn.clone(true);
            $.box({
                imageClass: "box_info",
                text: "Una vez generado el número de fórmula polinómica no se puede revertir y se utlizará el " +
                    "siguiente de la secuencia. ¿Está seguro de querer continuar?",
                title: "Alerta",
                iconClose: false,
                dialog: {
                    resizable: false,
                    draggable: false,
                    buttons: {
                        "Generar": function () {
                            btn.replaceWith(spinner);
                            $.ajax({
                                type: "POST",
                                url: "${createLink(action: 'generaNumeroFP')}",
                                data: "obra=${obra.id}",
                                success: function (msg) {
                                    var parts = msg.split("_");
                                    if (parts[0] === "OK") {
                                        spinner.replaceWith("<div style='font-weight: normal;'>" + parts[1] + "</div>");
                                    } else {
                                        $.box({
                                            imageClass: "box_info",
                                            text: parts[1],
                                            title: "Errores",
                                            iconClose: false,
                                            dialog: {
                                                resizable: false,
                                                draggable: false,
                                                buttons: {
                                                    "Aceptar": function () {
                                                    }
                                                }
                                            }
                                        });
                                        spinner.replaceWith($btn);
                                    }
                                }
                            });
                        },
                        "Cancelar": function () {
                        }
                    }
                }
            });
            return false;
        });

        $("#ok_matiz").click(function () {
            var sp = $("#matriz_sub").val();
            var tr = $("#si_trans").is(':checked');
            var borrar = $("#borra_fp").is(':checked');

            $("#dlgLoad").dialog("open");
            $(".ui-dialog-titlebar-close").html("x");

            var lo = cargarLoader("Cargando...");

            $.ajax({
                type: "POST",
                url: "${createLink(action: 'validaciones', controller: 'obraFP')}",
                data: "obra=${obra.id}&sub=" + sp + "&trans=" + tr + "&borraFP=" + borrar,
                success: function (msg) {
                    lo.modal("hide");
                    $("#dlgLoad").dialog("close");
                    $("#modal-matriz").modal("hide");
                    var arr = msg.split("_");
                    var ok_msg = arr[0];
                    var sbpr = arr[1];
                    if (ok_msg !== "ok") {
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
                        var lo1 = cargarLoader("Cargando Matriz...");
                        location.href = "${g.createLink(controller: 'matriz',action: 'pantallaMatriz',
                        params:[id:obra.id,inicio:0,limit:40])}&sbpr=" + sbpr
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
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
            $("#modalTitle_busqueda").html("Lista de obras");
            $("#modalFooter_busqueda").html("").append(btnOk);
            $(".contenidoBuscador").html("");
            $("#buscarDialog").unbind("click");
            $("#buscarDialog").bind("click", enviar);
            $("#modal-busqueda").modal("show");
            setTimeout(function () {
                $('#criterio').focus()
            }, 500);
        });

        $("#listaLq").click(function () {
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
            $("#modalTitle_busqueda").html("Lista de obras de liquidación");
            $("#modalFooter_busqueda").html("").append(btnOk);
            $(".contenidoBuscador").html("");
            $("#modal-busqueda").modal("show");
            $("#buscarDialog").unbind("click");
            $("#buscarDialog").bind("click", enviarLq);
            setTimeout(function () {
                $('#criterio').focus()
            }, 500);
        });

        $("#nuevo").click(function () {
            location.href = "${g.createLink(action: 'registroObra')}";
        });

        $("#cancelarObra").click(function () {
            location.href = "${g.createLink(action: 'registroObra')}" + "?obra=" + "${obra?.id}";
        });

        $("#eliminarObra").click(function () {
            if(${obra?.id != null}) {
                $("#eliminarObraDialog").dialog("open");
                $(".ui-dialog-titlebar-close").html("x")
            }
        });

        $("#cambiarEstado").click(function () {
            if(${obra?.id != null}) {
                $("#estadoDialog").dialog("open");
                $(".ui-dialog-titlebar-close").html("x")
            }
        });

        $("#btnDocumentos").click(function () {
            location.href = "${g.createLink(controller: 'documentosObra', action: 'documentosObra', id: obra?.id)}"
        });

        $("#btnMapa").click(function () {
            location.href = "${g.createLink(action: 'mapaObra', id: obra?.id)}"
        });

        $("#btnVeri").click(function () {
            <g:if test="${verifOK}">
            location.href = "${g.createLink(controller: 'verificacionPrecios', action: 'verificacion', id: obra?.id)}";
            </g:if>
            <g:else>
            bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No se puede generar la Verificación de Precios, la obra no cuenta con una Matriz" + '</strong>');
            </g:else>
        });

        $("#btn-aceptar").click(function () {
            $("#frm-registroObra").submit();
        });

        $("#btn-buscar").click(function () {
            $("#dlgLoad").dialog("close");
            $("#busqueda-geo").dialog("open");
            $(".ui-dialog-titlebar-close").html("x");
            return false;
        });

        // $("#item_codigo").dblclick(function () {
        //     $("#dlgLoad").dialog("close");
        //     $("#busqueda_CPC").dialog("open");
        //     $(".ui-dialog-titlebar-close").html("x");
        //     return false;
        // });

        $("#departamento").change(function () {
            loadSalida();
            loadPersonas();
        });

        function loadSalida() {
            var direccionEl;
            <g:if test="${persona?.departamento?.codigo?.trim() == 'UTFPU'}">
            <g:if test="${obra}">
            <g:if test="${duenoObra == 1}">
//              direccionEl = $("#departamento option:selected").attr("dire");
            direccionEl = $("#departamento").val();
            </g:if>
            <g:else>
//                direccionEl = $("#departamentoDire").val();
            direccionEl = $("#departamento").val();
            </g:else>
            </g:if>
            <g:else>
            direccionEl = $("#departamento option:selected").attr("class");
            </g:else>
            </g:if>
            <g:else>
            <g:if test="${obra}">
//            direccionEl = $("#departamentoDire").val();
            direccionEl = $("#departamento").val();
            </g:if>
            <g:else>
            %{--direccionEl = ${persona?.departamento?/.direccion?.id}--}%
            direccionEl = ${persona?.departamento?.id}
            </g:else>
            </g:else>

            var idObra = "${obra?.id}";
            %{--console.log('Dir:', "${obra?.departamento?.id}", ${persona?.departamento?.id});--}%
            $.ajax({
                type: "POST",
                url: "${g.createLink(action:'getSalida')}",
                data: {
                    direccion: direccionEl,
                    obra: idObra
                },
                success: function (msg) {
                    $("#dirSalida").html(msg);
                }
            });
        }

        $("#copiarObra").click(function () {
            $("#copiarDialog").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        });
        $("#copiarObraOfe").click(function () {
            $("#copiarDialogOfe").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        });

        $("#btnRubros").click(function () {
            var url = "${createLink(controller:'reportes', action:'imprimirRubros')}?obra=${obra?.id}Wdesglose=";
            var urlVae = "${createLink(controller:'reportes3', action:'reporteRubrosVaeReg')}?obra=${obra?.id}Wdesglose=";
            var idObra = "${obra?.id}";

            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'obra', action: 'impresionesRubros_ajax')}",
                data:{
                    id : idObra
                },
                success: function (msg) {

                    var b = bootbox.dialog({
                        id      : "dlgImprimir",
                        title   : "Imprimir Rubros de la Obra",
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
                }
            });
            return false;



            %{--$.ajax({--}%
            %{--    type: 'POST',--}%
            %{--    url: "${createLink(controller: 'obra', action: 'revisarSizeRubros_ajax')}",--}%
            %{--    data:{--}%
            %{--        id: '${obra?.id}'--}%
            %{--    },--}%
            %{--    success: function (msg){--}%
            %{--        if(msg === 'ok'){--}%
            %{--            $.box({--}%
            %{--                imageClass: "box_info",--}%
            %{--                text: "Imprimir los análisis de precios unitarios de los rubros usados en la obra<br>" +--}%
            %{--                    "<span style='margin-left: 42px;'>Ilustraciones y Especificaciones</span>",--}%
            %{--                title: "Imprimir Rubros de la Obra",--}%
            %{--                iconClose: true,--}%
            %{--                dialog: {--}%
            %{--                    resizable: false,--}%
            %{--                    draggable: false,--}%
            %{--                    width: 600,--}%
            %{--                    height: 320,--}%
            %{--                    buttons: {--}%
            %{--                        "Con desglose de Trans.": function () {--}%
            %{--                            url += "1";--}%
            %{--                            location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosTransporteRegistro')}?" + "&desglose=" + 1 + "&obra=" + '${obra?.id}';--}%
            %{--                        },--}%
            %{--                        "Sin desglose de Trans.": function () {--}%
            %{--                            url += "0";--}%
            %{--                            location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosTransporteRegistro')}?" + "&desglose=" + 0 + "&obra=" + '${obra?.id}';--}%
            %{--                        },--}%
            %{--                        "Exportar Rubros a Excel": function () {--}%
            %{--                            var url = "${createLink(controller:'reportesExcel', action:'imprimirRubrosExcel')}?obra=${obra?.id}&transporte=";--}%
            %{--                            url += "1";--}%
            %{--                            location.href = url;--}%
            %{--                        },--}%
            %{--                        "VAE con desglose de Trans.": function () {--}%
            %{--                            urlVae += "1";--}%
            %{--                            location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosVaeRegistro')}?" + "&desglose=" + 1 + "&obra=" + '${obra?.id}';--}%
            %{--                        },--}%
            %{--                        "VAE sin desglose de Trans.": function () {--}%
            %{--                            urlVae += "0";--}%
            %{--                            location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosVaeRegistro')}?" + "&desglose=" + 0 + "&obra=" + '${obra?.id}';--}%
            %{--                        },--}%
            %{--                        "Exportar VAE a Excel": function () {--}%
            %{--                            var urlVaeEx = "${createLink(controller:'reportes3', action:'imprimirRubrosVaeExcel')}?obra=${obra?.id}&transporte=";--}%
            %{--                            urlVaeEx += "1";--}%
            %{--                            location.href = urlVaeEx;--}%
            %{--                        },--}%
            %{--                        "Imprimir las Ilustraciones y las Especificaciones de los Rubros (100 primeros)": function () {--}%
            %{--                            $.ajax({--}%
            %{--                                type: "POST",--}%
            %{--                                url: "${createLink(controller:'reportes2', action:'comprobarIlustracion')}",--}%
            %{--                                data: {--}%
            %{--                                    id: idObra,--}%
            %{--                                    tipo: "ie"--}%
            %{--                                },--}%
            %{--                                success: function (msg) {--}%
            %{--                                    var parts = msg.split('*');--}%
            %{--                                    if (parts[0] === 'SI') {--}%
            %{--                                        $("#divError").hide();--}%
            %{--                                        location.href = "${createLink(controller:'reportes2', action:'reporteRubroIlustracion')}?id=${obra?.id}&tipo=ie";--}%
            %{--                                    } else {--}%
            %{--                                        $("#spanError").html("El archivo  '" + parts[1] + "'  no ha sido encontrado");--}%
            %{--                                        $("#divError").show()--}%
            %{--                                    }--}%
            %{--                                }--}%
            %{--                            });--}%
            %{--                        },--}%
            %{--                        "Imprimir las Ilustraciones y las Especificaciones de los Rubros (101 en adelante)": function () {--}%
            %{--                            $.ajax({--}%
            %{--                                type: "POST",--}%
            %{--                                url: "${createLink(controller:'reportes2', action:'comprobarIlustracion')}",--}%
            %{--                                data: {--}%
            %{--                                    id: idObra,--}%
            %{--                                    tipo: "ie"--}%
            %{--                                },--}%
            %{--                                success: function (msg) {--}%
            %{--                                    var parts = msg.split('*');--}%

            %{--                                    if (parts[0] === 'SI') {--}%
            %{--                                        $("#divError").hide();--}%
            %{--                                        location.href = "${createLink(controller:'reportes2', action:'reporteRubroIlustracion2')}?id=${obra?.id}&tipo=ie";--}%
            %{--                                    } else {--}%
            %{--                                        $("#spanError").html("El archivo  '" + parts[1] + "'  no ha sido encontrado");--}%
            %{--                                        $("#divError").show()--}%
            %{--                                    }--}%
            %{--                                }--}%
            %{--                            });--}%
            %{--                        },--}%
            %{--                        "Cancelar": function () {--}%
            %{--                        }--}%
            %{--                    }--}%
            %{--                }--}%
            %{--            });--}%
            %{--        }   else{--}%
            %{--            $.box({--}%
            %{--                imageClass: "box_info",--}%
            %{--                text: "Imprimir los análisis de precios unitarios de los rubros usados en la obra<br><span style='margin-left: 42px;'>Ilustraciones y Especificaciones</span>",--}%
            %{--                title: "Imprimir Rubros de la Obra",--}%
            %{--                iconClose: true,--}%
            %{--                dialog: {--}%
            %{--                    resizable: false,--}%
            %{--                    draggable: false,--}%
            %{--                    width: 600,--}%
            %{--                    height: 260,--}%
            %{--                    buttons: {--}%

            %{--                        "Con desglose de Trans.": function () {--}%
            %{--                            url += "1";--}%
            %{--                            location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosTransporteRegistro')}?" + "&desglose=" + 1 + "&obra=" + '${obra?.id}';--}%
            %{--                        },--}%
            %{--                        "Sin desglose de Trans.": function () {--}%
            %{--                            url += "0";--}%
            %{--                            location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosTransporteRegistro')}?" + "&desglose=" + 0 + "&obra=" + '${obra?.id}';--}%
            %{--                        },--}%
            %{--                        "Exportar Rubros a Excel": function () {--}%
            %{--                            var url = "${createLink(controller:'reportesExcel', action:'imprimirRubrosExcel')}?obra=${obra?.id}&transporte=";--}%
            %{--                            url += "1";--}%
            %{--                            location.href = url;--}%
            %{--                        },--}%
            %{--                        "VAE con desglose de Trans.": function () {--}%
            %{--                            urlVae += "1";--}%
            %{--                            location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosVaeRegistro')}?" + "&desglose=" + 1 + "&obra=" + '${obra?.id}';--}%
            %{--                        },--}%
            %{--                        "VAE sin desglose de Trans.": function () {--}%
            %{--                            urlVae += "0";--}%
            %{--                            location.href = "${g.createLink(controller: 'reportesRubros2',action: 'reporteRubrosVaeRegistro')}?" + "&desglose=" + 0 + "&obra=" + '${obra?.id}';--}%
            %{--                        },--}%
            %{--                        "Exportar VAE a Excel": function () {--}%
            %{--                            var urlVaeEx = "${createLink(controller:'reportes3', action:'imprimirRubrosVaeExcel')}?obra=${obra?.id}&transporte=";--}%
            %{--                            --}%%{--var urlVaeEx = "${createLink(controller:'reportesExcel', action:'imprimirRubrosVaeExcel')}?obra=${obra?.id}&transporte=";--}%
            %{--                            urlVaeEx += "1";--}%
            %{--                            location.href = urlVaeEx;--}%
            %{--                        },--}%
            %{--                        "Imprimir las Ilustraciones y las Especificaciones de los Rubros": function () {--}%
            %{--                            $.ajax({--}%
            %{--                                type: "POST",--}%
            %{--                                url: "${createLink(controller:'reportes2', action:'comprobarIlustracion')}",--}%
            %{--                                data: {--}%
            %{--                                    id: idObra,--}%
            %{--                                    tipo: "ie"--}%
            %{--                                },--}%
            %{--                                success: function (msg) {--}%
            %{--                                    var parts = msg.split('*');--}%
            %{--                                    if (parts[0] === 'SI') {--}%
            %{--                                        $("#divError").hide();--}%
            %{--                                        location.href = "${createLink(controller:'reportes2', action:'reporteRubroIlustracion')}?id=${obra?.id}&tipo=ie";--}%
            %{--                                    } else {--}%
            %{--                                        $("#spanError").html("El archivo  '" + parts[1] + "'  no ha sido encontrado");--}%
            %{--                                        $("#divError").show()--}%
            %{--                                    }--}%
            %{--                                }--}%
            %{--                            });--}%

            %{--                        },--}%
            %{--                        "Cancelar": function () {--}%
            %{--                        }--}%
            %{--                    }--}%
            %{--                }--}%
            %{--            });--}%
            %{--        }--}%
            %{--    }--}%
            %{--});--}%
            %{--return false;--}%
        });

        $("#btn-consultar-geo").click(function () {
            busqueda();
        });

        $("#btn-consultar_CPC").click(function () {
            $("#dlgLoad").dialog("open");
            $(".ui-dialog-titlebar-close").html("x");
            busqueda_CPC();
        });

        $(".criterio_CPC").keydown(function (ev) {
            if (ev.keyCode === 13) {
                ev.preventDefault();
                busqueda_CPC();
                return false;
            }
        });

        $("#btnImprimir").click(function () {
            $("#dlgLoad").dialog("open");
            $(".ui-dialog-titlebar-close").html("x");
            location.href = "${g.createLink(controller: 'reportes', action: 'reporteRegistro', id: obra?.id)}";
            $("#dlgLoad").dialog("close")
        });

        $("#modal-var").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 800,
            height: 500,
            position: 'center',
            title: 'Variables'
        });

        $("#btnVar").click(function () {
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'variables', action:'variables_ajax')}",
                data: {
                    obra: "${obra?.id}"
                },
                success: function (msg) {

                    var btnSave = $('<a href="#"  class="btn btn-azul"><i class="fa fa-save"></i> Guardar</a>');
                    var btnCancel = $('<a href="#" class="btn" ><i class="fa fa-times"></i> Cancelar</a>');

                    btnSave.click(function () {
                        if ($("#frmSave-var").valid()) {
                            btnSave.replaceWith(spinner);
                        }
                        var data = $("#frmSave-var").serialize() + "&id=" + $("#id").val();
                        var url = $("#frmSave-var").attr("action");

                        $.ajax({
                            type: "POST",
                            url: url,
                            data: data,
                            success: function (msg) {
                                $("#modal-var").dialog("close");
                            }
                        });
                        return false;
                    });

                    btnCancel.click(function () {
                        $("#modal-var").dialog("close");
                    });

                    $("#modal_title_var").html("Variables");
                    $("#modal_body_var").html(msg);
                    <g:if test="${duenoObra == 1 && obra?.estado != 'R'}">
                    $("#modal_footer_var").html("").append(btnSave);
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
                            $("#copiarDialog").dialog("close");
                            var parts = msg.split('_');
                            if (parts[0] === 'NO') {
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            } else {
                                bootbox.alert('<i class="fa fa-check text-success fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            }
                        }
                    });
                },
                "Cancelar": function () {
                    $("#copiarDialog").dialog("close");
                }
            }
        });

        $("#copiarDialogOfe").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 420,
            position: 'center',
            title: 'Copiar la obra al sistema de oferentes',
            buttons: {
                "Aceptar": function () {
                    $("#dlgLoad").dialog("open");
                    $(".ui-dialog-titlebar-close").html("x");
                    $("#divOk").hide();
                    $("#divError").hide();
                    var originalId = "${obra?.id}";
                    var oferente = $("#oferenteCopia").val();
                    $.ajax({
                        type: "POST",
                        url: "${createLink(controller: "export", action: 'exportObra')}",
                        data: {
                            obra: originalId,
                            oferente: oferente
                        },
                        success: function (msg) {
                            $("#dlgLoad").dialog("close");
                            $("#copiarDialogOfe").dialog("close");
                            var parts = msg.split('_');
                            if (parts[0] === 'NO') {
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            } else {
                                bootbox.alert('<i class="fa fa-check text-success fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                            }
                        }
                    });
                },
                "Cancelar": function () {
                    $("#copiarDialogOfe").dialog("close");
                }
            }
        });

        $("#busqueda-geo").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 800,
            height: 600,
            position: 'center',
            title: 'Datos de Situación Geográfica'
        });

        $("#busqueda_CPC").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 800,
            height: 600,
            position: 'center',
            title: 'Código Compras Públicas'
        });

        $("#estadoDialog").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 350,
            height: 260,
            position: 'center',
            title: 'Cambiar estado de la Obra',
            buttons: {
                "Aceptar": function () {
                    var d = cargarLoader("Cargando...");
                    $("#dlgLoad").dialog("open");
                    $(".ui-dialog-titlebar-close").html("x");
                    var estadoCambiado = $("#estado").val();

                    if (estadoCambiado === 'N') {
                        estadoCambiado = 'R';
                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(action: 'regitrarObra')}",
                            data: "id=${obra?.id}",
                            success: function (msg) {
                                d.modal("hide");
                                if (msg !== "ok") {
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
                                                    $("#dlgLoad").dialog("close");
                                                }
                                            }
                                        }
                                    });
                                } else {
                                    $("#dlgLoad").dialog("close");
                                    location.reload()
                                }
                            }
                        });
                    } else {
                        $.ajax({
                            type: "POST",
                            url: "${g.createLink(action: 'desregitrarObra')}",
                            data: "id=${obra?.id}",
                            success: function (msg) {
                                if (msg !== "ok") {
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
                                                    $("#dlgLoad").dialog("close");
                                                }
                                            }
                                        }
                                    });
                                } else {
                                    estadoCambiado = 'N';
                                    $("#dlgLoad").dialog("close");
                                    location.reload()
                                }
                            }
                        });
                    }
                    $("#estadoDialog").dialog("close");
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

        function fp(url) {
            $("#dlgLoad").dialog("open");
            $(".ui-dialog-titlebar-close").html("x");
            $.ajax({
                async: false,
                type: "POST",
                url: url,
                success: function (msg2) {
                    if (msg2 === "ok" || msg2 === "OK") {
                        location.href = "${createLink(controller: 'formulaPolinomica', action: 'coeficientes', id:obra?.id)}";
                    }
                }
            });
        }

        $("#modal-formula").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 400,
            height: 180,
            position: 'center',
            title: 'Fórmula Polinómica'
        });

        $("#btnFormula").click(function () {
            $("#datos_formula").hide();
            $("#msg_formula").show();
            $("#modal-formula").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        });

        $("#irFP").click(function () {
            var sb = $("#matriz_genFP").val();
            location.href = "${g.createLink(controller: 'formulaPolinomica',action: 'coeficientes',id: obra?.id)}?sbpr=" + sb
        });
        $("#cancelaFP").click(function () {
            $("#modal-formula").dialog("close")
        });

        $(".btnFormula__s").click(function () {
            var url = $(this).attr("href");

            $.ajax({
                type: "POST",
                async: false,
                url: "${createLink(action: 'existeFP')}",
                data: {
                    obra: "${obra?.id}"
                },
                success: function (msg) {
                    if (msg === "true" || msg === true) {
                        fp(url);
                    } else {
                        $.box({
                            imageClass: "box_info",
                            text: "Asegúrese de que ya ha ingresado todos los rubros para generar la fórmula polinómica.",
                            title: "Confirmación",
                            iconClose: false,
                            dialog: {
                                resizable: false,
                                draggable: false,
                                closeOnEscape: false,
                                buttons: {
                                    "Continuar": function () {
                                        fp(url);
                                    },
                                    "Cancelar": function () {
                                    }
                                }
                            }
                        });
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
            createEditTipObra();
        });

        function createEditTipObra(id) {
            var title = id ? "Editar " : "Crear ";
            var data = id ? {id : id, grupo: '${grupoDir?.id}'} : {grupo: '${grupoDir?.id}'};

            $.ajax({
                type    : "POST",
                url: "${createLink(action:'crearTipoObra')}",
                data    : data,
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEditTO",
                        title   : title + " Tipo de Obra",
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
                                    return submitFormTipoObra();
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

        function submitFormTipoObra() {
            var $form = $("#frmSave-TipoObra");
            if ($form.valid()) {
                var data = $form.serialize();
                var dp = cargarLoader("Guardando...");
                $.ajax({
                    type    : "POST",
                    url     : $form.attr("action"),
                    data    : data,
                    success : function (msg) {
                        dp.modal('hide');
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

        $("#btnCrearClase").click(function () {
            createEditClase();
        });

        function createEditClase(id) {
            var title = id ? "Editar " : "Crear ";
            var data = id ? {id : id, grupo: '${grupoDir?.id}'} : {grupo: '${grupoDir?.id}'};

            $.ajax({
                type    : "POST",
                url: "${createLink(controller: 'claseObra', action:'form_ext_ajax')}",
                data    : data,
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEditC",
                        title   : title + " Clase",
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
                                    return submitFormClase();
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

        function submitFormClase() {
            var $form = $("#frmSave-claseObraInstance");
            if ($form.valid()) {
                var data = $form.serialize();
                var dp = cargarLoader("Guardando...");
                $.ajax({
                    type    : "POST",
                    url     : $form.attr("action"),
                    data    : data,
                    success : function (msg) {
                        dp.modal('hide');
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

        $("#btnCrearPrograma").click(function () {
            createEditPrograma();
        });

        function createEditPrograma(id) {
            var title = id ? "Editar " : "Crear ";
            var data = id ? {id : id} : {};

            $.ajax({
                type    : "POST",
                url: "${createLink(controller:'programacion', action:'form_ext_ajax')}",
                data    : data,
                success : function (msg) {
                    var b = bootbox.dialog({
                        id      : "dlgCreateEdit",
                        title   : title + " Programa",
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
                                    return submitFormPrograma();
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

        function submitFormPrograma() {
            var $form = $("#frmSave-Programacion");
            if ($form.valid()) {
                var data = $form.serialize();
                var dp = cargarLoader("Guardando...");
                $.ajax({
                    type    : "POST",
                    url     : $form.attr("action"),
                    data    : data,
                    success : function (msg) {
                        dp.modal('hide');
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
                        $("#noEliminarDialog").dialog("open");
                        $(".ui-dialog-titlebar-close").html("x")
                    }
                    else {
                        $.ajax({
                            type: "POST",
                            url: "${createLink(action: 'delete')}",
                            data: "id=${obra?.id}",
                            success: function (msg) {
                                if (msg === 'ok') {
                                    location.href = "${createLink(action: 'registroObra')}"
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

        $("#revisarPrecios").click(function () {
            <g:if test="${verifOK}">
            location.href = "${g.createLink(controller: 'verificacionPrecios', action: 'preciosCero', id: obra?.id)}";
            </g:if>
            <g:else>
            bootbox.alert('<i class="fa fa-exclamation-triangle text-warning fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No se puede generar la Verificación de Precios, la obra no cuenta con una Matriz" + '</strong>');
            </g:else>
        });

        $("#criterio-geo").keydown(function (ev) {
            if (ev.keyCode === 13) {
                ev.preventDefault();
                busqueda();
                return false;
            }
        });

        function busqueda() {
            var buscarPor = $("#buscarPor-geo").val();
            var criterio = $("#criterio-geo").val();
            var ordenar = $("#ordenar-geo").val();
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

        function busqueda_CPC() {
            var buscarPor = $("#buscarPor_CPC").val();
            var criterio = $(".criterio_CPC").val();
            var ordenar = $("#ordenar_CPC").val();
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'obra', action:'codigoCPC_ajax')}",
                data: {
                    buscarPor: buscarPor,
                    criterio: criterio,
                    ordenar: ordenar
                },
                success: function (msg) {
                    $("#divTabla_CPC").html(msg);
                    $("#dlgLoad").dialog("close");
                }
            });
        }
    });

    $("#errorDialog").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 350,
        height: 180,
        zIndex: 1060,
        position: 'center',
        title: 'Error',
        buttons: {
            "Aceptar": function () {
                $("#errorDialog").dialog("close");
            }
        }
    });

</script>
</body>
</html>