<%@ page import="janus.TipoLista; janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Rubros
    </title>

    <asset:javascript src="/jquery/plugins/jquery-validation-1.9.0/jquery.validate.min.js"/>
    <asset:javascript src="/jquery/plugins/jquery-validation-1.9.0/messages_es.js"/>
    <asset:javascript src="/jquery/plugins/jquery.livequery.js"/>

    <style type="text/css">

    .table-responsive {
        overflow: visible !important;
    }

    </style>
</head>

<body>

<div class="col-md-12">
    <g:if test="${flash.message}">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status">
            <a class="close" data-dismiss="alert" href="#">×</a>
            <elm:poneHtml textoHtml="${flash.message}"/>
        </div>
    </g:if>
</div>

<div id="spinner" class="row col-md-12 hide" style="z-index: 1; position: absolute; border: 1px solid black;
width: 160px; height: 120px; top: 10%; left: 40%; background-color: #cdcdcd; text-align: center">
    <img src="${resource(dir: 'images', file: 'spinner.gif')}" alt='Cargando...' width="64px" height="64px" z-index="100"/>
    <p>Cargando...Por favor espere</p>
</div>


<div class="col-md-12 btn-group" role="navigation">
    <a href="#" class="btn" id="btn_lista">
        <i class="fa fa-list"></i>
        Lista
    </a>
    <a href="${g.createLink(action: 'rubroPrincipal')}" class="btn btn-ajax btn-new">
        <i class="fa fa-file"></i>
        Nuevo
    </a>
    <a href="#" class="btn btn-ajax btn-new btn-primary" id="guardar">
        <i class="fa fa-save"></i>
        Guardar
    </a>
    <a href="#" class="btn btn-ajax btn-new" id="borrar">
        <i class="fa fa-trash"></i>
        Borrar
    </a>
    <a href="${g.createLink(action: 'rubroPrincipal')}" class="btn btn-ajax btn-new">
        <i class="fa fa-times"></i>
        Cancelar
    </a>

    <a href="#" class="btn btn-ajax btn-new" id="calcular" title="Calcular precios">
        <i class="fa fa-table"></i>
        Calcular
    </a>
    <a href="#" class="btn btn-ajax btn-new" id="transporte" title="Transporte">
        <i class="fa fa-truck"></i>
        Transporte
    </a>
    <g:if test="${rubro}">
        <a href="#" class="btn btn-ajax btn-new" id="imprimir" title="Imprimir">
            <i class="fa fa-print"></i>
            Imprimir
        </a>
    </g:if>
    <g:if test="${rubro}">
        <a href="#" class="btn btn-ajax btn-new" id="excel" title="Imprimir">
            <i class="fa fa-file-excel"></i>
            Excel
        </a>
    </g:if>

    <g:if test="${rubro}">
        <g:if test="${rubro?.codigoEspecificacion}">
            <a href="#" id="detalle" class="btn btn-ajax btn-new">
                <i class="fa fa-book"></i>
                Especificaciones
            </a>
        </g:if>
    </g:if>
    <g:if test="${rubro}">
        <a href="#" id="foto" class="btn btn-ajax btn-new">
            <i class="fa fa-image"></i>
            Ilustración
        </a>
    </g:if>
</div>

<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 10px;margin-left: -10px">

    <div style="border-bottom: 1px solid black;padding-left: 50px;position: relative;">
        <g:form name="frmRubro" action="save" style="height: 100px;">
            <input type="hidden" id="rubro__id" name="rubro.id" value="${rubro?.id}">

            <p class="css-vertical-text">Rubro</p>

            <div class="linea" style="height: 100px;"></div>

            <div class="row-fluid">

                <div class="col-md-1" style="width: 150px;">
                    Código
                    <g:textField name="rubro.codigo" id="input_codigo" class="allCaps required input-small"
                                 value="${rubro?.codigo ?: ''}"
                                 maxlength="30" minlength="2"/>
                    <p class="help-block ui-helper-hidden"></p>

                </div>

                <div class="col-md-2" style="margin-left: 20px">
                    Código Especificación
                    <g:textField name="rubro.codigoEspecificacion" class="allCaps required input-small"
                                 value="${rubro?.codigoEspecificacion}" id="input_codigo_es" maxlength="30"/>

                    <p class="help-block ui-helper-hidden"></p>
                </div>

                <div class="col-md-5" style="margin-left: -10px">
                    Descripción
                    <g:textField name="rubro.nombre" class="col-md-12" value="${rubro?.nombre}" id="input_descripcion"/>
                </div>

                <div class="col-md-2" style="margin-left: -10px">
                    Fecha Creación
                    <g:textField name="rubroFC" class="" value="${rubro?.fecha?.format("dd-MM-yyyy")}" style="width: 100px" readonly="true"/>
%{--                    <input aria-label="" name="rubro.fechaReg" id='fecha_registro' type='text' class="required input-small" value="${rubro?.fecha ?: new java.util.Date().format('dd-MM-yyyy')}" style="width: 100px"/>--}%
                </div>

                <div class="col-md-1"  style="width: 170px; margin-left: -60px">
                    Fecha Modificación
                    <g:textField name="rubroFM" class="" value="${rubro?.fechaModificacion?.format("dd-MM-yyyy")}" style="width: 100px" readonly="true"/>
%{--                    <input aria-label="" name="rubro.fechaMod" id='fecha_modificacion' type='text' class="required input-small" value="${rubro?.fechaModificacion ?: new java.util.Date().format('dd-MM-yyyy')}" style="width: 100px"/>--}%
                </div>

            </div>

            <div class="row-fluid">
                <div class="col-md-3" style="width: 150px;">
                    <label>Dirección responsable</label>
                    <g:select name="rubro.grupo.id" id="selClase" from="${grupos}" class="col-md-12" optionKey="id" optionValue="descripcion"
                              value="${rubro?.departamento?.subgrupo?.grupo?.id}" noSelection="${['': '--Seleccione--']}"/>
                </div>

                <div id="seleccionarGrupo" class="col-md-2" style="width: 310px; margin-left: 10px">

                </div>

                <div class="col-md-3" id="seleccionarSubgrupo" style="width: 200px; margin-left: 10px">

                </div>

                <div class="col-md-1" style="width: 100px; margin-left: 10px">
                    <label>Unidad</label>
                    <g:select name="rubro.unidad.id" from="${janus.Unidad.list()}" class="col-md-12" optionKey="id" optionValue="codigo" value="${rubro?.unidad?.id}"/>
                </div>

                <div class="col-md-2" style="color: #01a; width: 250px; margin-left: 10px" >
                    <label>Responsable:</label>  <br>
                    <input type="hidden" name="rubro.responsable" class="col-md-12" value="${rubro?.responsable?.id?:session.usuario.id}" id="selResponsable">
                    <g:textField name="persona" class="col-md-12" value="${rubro?.responsable?:session.usuario}" id="Responsable" readonly="true" />

                </div>
            </div>
        </g:form>
    </div>

    <div style="border-bottom: 1px solid black;padding-left: 50px;margin-top: 10px;position: relative; height: 80px">
        <p class="css-vertical-text">Items</p>

        <div class="linea" style="height: 100px;"></div>

        <div class="row-fluid" style="color: #248">

            <div class="col-md-3" style="width: 440px;">
                Lista de precios: MO y Equipos
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAllByTipoLista(janus.TipoLista.get(6))}"
                          optionKey="id" optionValue="descripcion" id="ciudad" style="width: 250px"/>
            </div>

            <div class="col-md-3" style="width: 180px;">
                % costos indirectos
                <g:textField style="width: 40px;" name="costo_indi" value="22.5"/>
            </div>

            <div class="form-group ${hasErrors(bean: administracionInstance, field: 'fechaInicio', 'error')} ">
                <span class="grupo">
                    <label class="col-md-1 control-label text-info">
                        Fecha
                    </label>
                    <span class="col-md-2" style="width: 120px; margin-left: -40px">
                        <input aria-label="" name="item.fecha" id='fecha_precios' type='text' class="required input-small"
                               value="${new java.util.Date().format('dd-MM-yyyy')}" style="width: 100px"/>
                    </span>
                </span>
            </div>

            <g:if test="${rubro}">
                <div class="col-md-2" style="margin-left: 85px">
                    <a class="btn btn-xs btn-warning " href="#" rel="tooltip" title="Copiar " id="btn_copiarComp">
                        <i class="fa fa-copy"></i> Copiar composición
                    </a>
                </div>
                <div class="col-md-1" style="margin-left: -50px; width: 40px">
                    <a class="btn btn-xs btn-info infoItem" href="#" rel="tooltip" title="Información">
                        <i class="fa fa-book"></i> Info</a>
                </div>
            </g:if>
            <g:else>
                <div class="col-md-2" style="margin-left: 30px">
                    <a class="btn btn-xs btn-warning " href="#" rel="tooltip" title="Copiar " disabled>
                        <i class="fa fa-copy"></i> Copiar composición
                    </a>
                </div>
                <div class="col-md-1" style="margin-left: -50px; width: 40px">
                    <a class="btn btn-xs btn-info infoItem" href="#" rel="tooltip" title="Información" disabled>
                        <i class="fa fa-book"></i> Info</a>
                </div>
            </g:else>
        </div>

        <div class="row-fluid" style="margin-bottom: 5px">
            <div class="col-md-2">
                CÓDIGO
                <g:textField name="item.codigo" id="cdgo_buscar" class="col-md-12 allCaps required input-small" readonly="true"/>
                <input type="hidden" id="item_id">
                <input type="hidden" id="item_tipoLista">
            </div>

            <div class="col-md-1" style="margin-top: 16px; width: 60px; margin-left: -28px">
                <a class="btn btn-xs btn-primary btn-ajax" href="#" rel="tooltip" title="Agregar rubro" id="btnRubro">
                    <i class="fa fa-search"></i> Buscar
                </a>
            </div>

            <div class="col-md-5" style="margin-left: 5px">
                DESCRIPCIÓN
                <g:textField name="item.descripcion" id="item_desc" class="col-md-12" readonly="true"/>
            </div>

            <div class="col-md-1" style="margin-right: 0px;margin-left: -20px; width: 120px">
                UNIDAD
                <g:textField name="item.unidad" id="item_unidad" class="col-md-8" readonly="true"/>
            </div>

            <div class="col-md-1" style="margin-left: -50px !important; width: 120px">
                CANTIDAD
                <g:textField name="item.cantidad" class="col-md-12" id="item_cantidad" value="0" style="text-align: right"/>
            </div>

            <div class="col-md-1" style="width: 160px; margin-left: -20px">
                RENDIMIENTO
                <g:textField name="item.rendimiento" class="col-md-12" id="item_rendimiento" value="1"
                             style="text-align: right; color: #44a;"/>
            </div>

            <div class="col-md-1" style="border: 0px solid black;height: 45px;padding-top: 16px;margin-left: -10px; width: 90px">
                <a class="btn btn-xs btn-primary btn-ajax" href="#" rel="tooltip" title="Agregar" id="btn_agregarItem">
                    <i class="fa fa-plus"></i>
                </a>
            </div>
        </div>
    </div>

    <input type="hidden" id="actual_row">

    <div style="border-bottom: 1px solid black;padding-left: 50px;position: relative;float: left;width: 95%" id="tablas">
        <p class="css-vertical-text">Composición</p>

        <div class="linea" style="height: 98%;"></div>
        <table class="table table-bordered table-striped table-condensed table-hover" style="margin-top: 10px;">
            <thead>
            <tr>
                <th style="width: 80px;">
                    CÓDIGO
                </th>
                <th style="width: 600px;">
                    EQUIPO
                </th>
                <th style="width: 80px;">
                    CANTIDAD
                </th>
                <th class="col_tarifa" style="display: none;">TARIFA <br>($/hora)</th>
                <th class="col_hora" style="display: none;">COSTO($)</th>
                <th class="col_rend" style="width: 50px">RENDIMIENTO</th>
                <th class="col_total" style="display: none;"><C class="TOTAL"></C>C.TOTAL($)<br>($/hora)</th>
                <th style="width: 40px" class="col_delete"></th>
            </tr>
            </thead>
            <tbody id="tabla_equipo">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 3}">
                    <tr class="item_row " id="${rub.id}" tipo="${rub.item.departamento.subgrupo.grupo.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="5" locale="ec"/>
                        </td>

                        <td class="col_tarifa cod_${rub.item.codigo?.replaceAll('\\.', '_')}" style="display: none;text-align: right" id="i_${rub.item.id}"></td>
                        <td class="col_hora" style="display: none;text-align: right"></td>
                        <td class="col_rend rend" style="width: 50px;text-align: right" valor="${rub.rendimiento}">
                            <g:formatNumber number="${rub.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="5" locale="ec"/>
                        </td>
                        <td class="col_total" style="display: none;text-align: right"></td>
                        <td style="width: 50px;text-align: center" class="col_delete">
                            <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}">
                                <i class="fa fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>
        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th style="width: 80px;">
                    CÓDIGO
                </th>
                <th style="width: 600px;">
                    MANO DE OBRA
                </th>
                <th style="width: 80px">
                    CANTIDAD
                </th>

                <th class="col_jornal" style="display: none;">JORNAL<br>($/hora)</th>
                <th class="col_hora" style="display: none;">COSTO($)</th>
                <th class="col_rend" style="width: 50px;">RENDIMIENTO</th>
                <th class="col_total" style="display: none;">C.TOTAL($)</th>
                <th style="width: 40px" class="col_delete"></th>
            </tr>
            </thead>
            <tbody id="tabla_mano">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 2}">
                    <tr class="item_row" id="${rub.id}" tipo="${rub.item.departamento.subgrupo.grupo.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="5" locale="ec"/>
                        </td>

                        <td class="col_jornal" style="display: none;text-align: right" id="i_${rub.item.id}"></td>
                        <td class="col_hora" style="display: none;text-align: right"></td>
                        <td class="col_rend rend" style="width: 50px;text-align: right" valor="${rub.rendimiento}">
                            <g:formatNumber number="${rub.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="5" locale="ec"/>
                        </td>
                        <td class="col_total" style="display: none;text-align: right"></td>
                        <td style="width: 50px;text-align: center" class="col_delete">
                            <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}">
                                <i class="fa fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>
        <table class="table table-bordered table-striped table-condensed table-hover">
            <thead>
            <tr>
                <th style="width: 80px;">
                    CÓDIGO
                </th>
                <th style="width: 600px;">
                    MATERIAL
                </th>
                <th style="width: 60px" class="col_unidad">
                    UNIDAD
                </th>
                <th style="width: 80px">
                    CANTIDAD
                </th>
                <th style="width: 40px" class="col_delete"></th>
                <th class="col_precioUnit" style="display: none;">UNITARIO</th>
                <th class="col_total" style="display: none;">C.TOTAL($)</th>
            </tr>
            </thead>
            <tbody id="tabla_material">
            <g:each in="${items}" var="rub" status="i" >
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 1}">
                    <tr class="item_row" id="${rub.id}" tipo="${rub.item.departamento.subgrupo.grupo.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="width: 60px !important;text-align: center" class="col_unidad">${rub.item.unidad.codigo}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="5" locale="ec"/>
                        </td>
                        <td class="col_precioUnit" style="display: none;text-align: right" id="i_${rub.item.id}"></td>

                        <td class="col_total" style="display: none;text-align: right"></td>
                        <td style="width: 50px;text-align: center" class="col_delete">
                            <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}">
                                <i class="fa fa-trash"></i>
                            </a>
                        </td>
                    </tr>
                </g:if>
            </g:each>
            </tbody>
        </table>

        <div id="tabla_transporte"></div>

        <div id="tabla_indi"></div>

        <div id="tabla_costos" style="height: 120px;display: none;float: right;width: 100%;margin-bottom: 10px;"></div>
    </div>
</div>

<div id="modal-rubro" style=";overflow: hidden;">

    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 20px">
%{--            <div class="col-md-2">--}%
%{--                Tipo--}%
%{--                <g:select name="buscarTipo" class="buscarPor col-md-12" from="${listaRbro}" optionKey="key"--}%
%{--                          optionValue="value"/>--}%
%{--            </div>--}%
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPorComposicion" class="buscarPor col-md-12" from="${listaItems}" optionKey="key"
                          optionValue="value"/>
            </div>
            <div class="col-md-2">Criterio
            <g:textField name="criterioComposicion" id="criterioComposicion" class="critC" style="width: 80%"/>
            </div>

            <div class="col-md-2">Ordenado por
            <g:select name="ordenarComposicion" class="ordenar" from="${listaItems}" style="width: 100%" optionKey="key"
                      optionValue="value"/>
            </div>
            <div class="col-md-2" style="margin-top: 6px">
                <button class="btn btn-info" id="cnsl-rubros-composicion"><i class="fa fa-search"></i> Consultar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaRbroComposicion" style="height: 460px; overflow: auto">
        </div>
    </fieldset>

</div>

<div id="modal-detalle" style=";overflow: hidden;">

    <div class="modal-body" id="modalBody-detalle">
        Especificaciones:<br>
        <textarea id="especificaciones" style="width: 700px;height: 150px;resize: none;margin-top: 10px">
            ${rubro?.especificaciones}
        </textarea>
    </div>

    <div class="modal-footer" id="modalFooter-detalle">
        <a href="#" id="save-espc" class="btn btn-info">Guardar</a>
    </div>
</div>

<div id="dialTransporte" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px; margin-top: 10px">
        <div class="col-md-2">
            Volquete
        </div>
        <div class="col-md-2">
            <g:select name="volquetes" from="${volquetes2}" optionKey="id" optionValue="nombre" id="cmb_vol"
                      noSelection="${['-1': 'Seleccione']}" value="${aux.volquete.id}"/>
        </div>

        <div class="col-md-3"></div>

        <div class="col-md-2">
            Costo
        </div>
        <div class="col-md-2">
            <g:textField style="width: 60px;text-align: right" disabled="" name="costo_volqueta" />
        </div>
        <div class="col-md-2">
            Chofer
        </div>

        <div class="col-md-5">
            <g:select name="volquetes" from="${choferes}" optionKey="id" optionValue="nombre" id="cmb_chof"
                      style="" noSelection="${['-1': 'Seleccione']}" value="${aux.chofer.id}"/>
        </div>

        <div class="col-md-2">
            Costo
        </div>
        <div class="col-md-3">
            <g:textField style="width: 60px;text-align: right" disabled="" name="costo_chofer"/>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px; margin-top: 15px; border-style: solid; border-color: #444; border-width: 1px">
        <div class="col-md-6">
            <b>Distancia peso</b>
        </div>
        <div class="col-md-5" style="margin-left: 30px;">
            <b>Distancia volumen</b>
        </div>
    </fieldset>

    <div class="row-fluid" style="margin-top: 10px">
        <div class="col-md-2">
            Canton
        </div>
        <div class="col-md-3">
            <g:textField name="dist_p1" value="0.00"/>
        </div>

        <div class="col-md-4">
            Materiales Petreos Hormigones
        </div>

        <div class="col-md-3">
            <g:textField name="dist_v1" value="0.00"/>
        </div>

    </div>

    <div class="row-fluid">
        <div class="col-md-2">
            Especial
        </div>

        <div class="col-md-3">
            <g:textField style="width: 50px;" name="dist_p2" value="0.00"/>
        </div>

        <div class="col-md-4">
            Materiales Mejoramiento
        </div>

        <div class="col-md-3">
            <g:textField style="width: 50px;" name="dist_v2" value="0.00"/>
        </div>
    </div>

    <div class="row-fluid">
        <div class="col-md-5">
        </div>

        <div class="col-md-4">
            Materiales Carpeta Asfáltica
        </div>

        <div class="col-md-3">
            <g:textField style="width: 50px;" name="dist_v3" value="0.00"/>
        </div>
    </div>

    <fieldset class="borde" style="border-radius: 4px; margin-top: 90px; border-style: solid;
    border-color: #444; border-width: 1px">
        <div class="col-md-6">
            <b>Listas de precios</b>
        </div>
    </fieldset>

    <div class="col-md-12" style="margin-top: 10px">
        <div class="col-md-1">
            Canton
        </div>

        <div class="col-md-4">
            <g:select name="item.ciudad.id" from="${janus.Lugar.findAllByTipoLista(janus.TipoLista.get(1))}"
                      optionKey="id" optionValue="descripcion" class="col-md-11" id="lista_1"/>
        </div>

        <div class="col-md-3">
            Petreos Hormigones
        </div>

        <div class="col-md-4">
            <g:select name="item.ciudad.id" from="${janus.Lugar.findAllByTipoLista(janus.TipoLista.get(3))}"
                      optionKey="id" optionValue="descripcion" class="col-md-12" id="lista_3"/>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 10px">
        <div class="col-md-1">
            Especial
        </div>

        <div class="col-md-4">
            <g:select name="item.ciudad.id" from="${janus.Lugar.findAllByTipoLista(janus.TipoLista.get(2))}"
                      optionKey="id" optionValue="descripcion" class="col-md-11" id="lista_2"/>
        </div>

        <div class="col-md-3">
            Mejoramiento
        </div>

        <div class="col-md-4">
            <g:select name="item.ciudad.id" from="${janus.Lugar.findAllByTipoLista(janus.TipoLista.get(4))}"
                      optionKey="id" optionValue="descripcion" class="col-md-12" id="lista_4"/>
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 10px">
        <div class="col-md-5"></div>

        <div class="col-md-3">
            Carpeta Asfáltica
        </div>

        <div class="col-md-4">
            <g:select name="item.ciudad.id" from="${janus.Lugar.findAllByTipoLista(janus.TipoLista.get(5))}"
                      optionKey="id" optionValue="descripcion" class="col-md-12" id="lista_5"/>
        </div>
    </div>

</div>

<div id="imprimirTransporteDialog">
    <fieldset>
        <div class="col-md-12" style="margin-top: 10px;">
            <strong>¿Desea imprimir el reporte desglosando el transporte?</strong>
        </div>
        <div class="col-md-12 table-responsive" style="margin-top: 10px">
            Se imprime a la Fecha de: <input aria-label="" name="fechaSalida" id='fechaSalidaId' type='text' class="required input-small" value="${rubro?.fechaModificacion ?: new java.util.Date().format('dd-MM-yyyy')}" style="width: 100px"/>
        </div>
    </fieldset>
</div>

<div id="copiar_dlg">
    <input type="hidden" id="rub_select">
    Factor: <g:textField name="factor" class="ui-corner-all" style="width:150px;"/>
</div>
</fieldset>
</div>

<div class="modal hide fade" id="modal-tree">
    <div class="modal-header" id="modal-header-tree">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle-tree"></h3>
    </div>

    <div class="modal-body" id="modalBody-tree">
    </div>

    <div class="modal-footer" id="modalFooter-tree">
    </div>
</div>

<div id="busqueda" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 20px">
            <div class="col-md-2">Grupo
            <g:select name="buscarGrupo_name"  id="buscarGrupo"
                      from="['1': 'Materiales', '2': 'Mano de Obra', '3': 'Equipos']"
                      optionKey="key" optionValue="value"/>
            </div>

            <div class="col-md-2">Buscar Por
            <g:select name="buscarPor" class="buscarPor" from="${[1: 'Nombre', 2: 'Código']}"
                      style="width: 100%" optionKey="key"
                      optionValue="value"/>
            </div>

            <div class="col-md-2">Criterio
            <g:textField name="criterio" class="criterio" style="width: 80%"/>
            </div>

            <div class="col-md-2">Ordenado por
            <g:select name="ordenar" class="ordenar" from="${[1: 'Nombre', 2: 'Código']}"
                      style="width: 100%" optionKey="key"
                      optionValue="value"/>
            </div>
            <div class="col-md-2" style="margin-top: 6px">
                <button class="btn btn-info" id="btn-consultar"><i
                        class="icon-check"></i> Consultar
                </button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTabla" style="height: 460px; overflow-y:auto; overflow-x: auto;">
        </div>
    </fieldset>
</div>


<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 20px">
            %{--<div class="col-md-2">--}%
            %{--Tipo--}%
            %{--<g:select name="buscarTipo" class="buscarPor col-md-12" from="${listaRbro}" optionKey="key"--}%
            %{--optionValue="value"/>--}%
            %{--</div>--}%
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPorLista" class="col-md-12" from="${listaItems}" optionKey="key"
                          optionValue="value"/>
            </div>

            <div class="col-md-2">Criterio
            <g:textField name="criterioLista" style="width: 80%"/>
            </div>

            <div class="col-md-2">Ordenado por
            <g:select name="ordenarLista" from="${listaItems}" style="width: 100%" optionKey="key"
                      optionValue="value"/>
            </div>
            <div class="col-md-2" style="margin-top: 6px">
                <button class="btn btn-info" id="cnsl-rubros"><i class="fa fa-search"></i> Consultar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaRbro" style="height: 460px; overflow: auto">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    $('#fecha_precios, #fecha_registro, #fecha_modificacion, #fechaCreacion, #fechaSalidaId').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    function validarNumDec(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#codigo").keydown(function (ev) {
        return validarNumDec(ev)
    });

    $("#btnRubro").click(function () {
        $("#busqueda").dialog("open");
        $(".ui-dialog-titlebar-close").html("x");
        return false;
    });

    $("#busqueda").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 1000,
        height: 500,
        position: 'center',
        title: 'Items'
    });


    $("#modal-rubro").dialog({
        autoOpen: false,
        resizable: false,
        modal: true,
        draggable: false,
        width: 1000,
        height: 500,
        position: 'center',
        title: 'Copiar rubros'
    });

    $("#btn-consultar").click(function () {
        busqueda();
    });

    function busqueda() {
        var buscarPor = $("#buscarPor").val();
        var criterio = $(".criterio").val();
        var ordenar = $("#ordenar").val();
        var grupo = $("#buscarGrupo").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubro', action:'listaItem')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio,
                ordenar: ordenar,
                grupo: grupo
            },
            success: function (msg) {
                $("#divTabla").html(msg);
            }
        });
    }

    $("#btn_precio").click(function () {
        var idItem = $("#item_id").val();
        if(idItem){
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller: 'rubro', action:'precio_ajax')}",
                data    : {
                    item        : idItem
                },
                success : function (msg) {
                    var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cancelar</a>');
                    var btnSave = $('<a href="#"  class="btn btn-success"><i class="icon-ok"></i> Guardar</a>');
                    btnSave.click(function () {
                        if($("#precioUnitario").val() === 0){
                            $("#modal-tree").modal("hide");
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese un valor diferente de 0" + '</strong>');
                        }else{
                            $.ajax({
                                type    : "POST",
                                url     : $("#frmSave").attr("action"),
                                data    : $("#frmSave").serialize(),
                                success : function (msg) {
                                    if (msg === "OK") {
                                        $("#modal-tree").modal("hide");
                                        bootbox.alert('<i class="fa fa-check text-success fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Precio creado correctamente" + '</strong>');
                                    } else {
                                        $("#modal-tree").modal("hide");
                                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al crear el precio" + '</strong>');
                                    }
                                }
                            });
                        }
                        return false;
                    });

                    $("#modalTitle-tree").html("Nuevo Precio");
                    $("#modalBody-tree").html(msg);
                    $("#modalFooter-tree").html("").append(btnOk).append(btnSave);
                    $("#modal-tree").modal("show");
                }
            });
        }else{
            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un item" + '</strong>');
        }
    });

    var urlS = "${resource(dir:'images', file:'spinner_24.gif')}";
    var spinner = $("<img style='margin-left:15px;' src='" + urlS + "' alt='Cargando...'/>");

    $("#btnRegistrar").click(function () {
        var idRubro = '${rubro?.id}';

        bootbox.confirm({
            title: "Info",
            message: "Está seguro de cambiar el estado de este"  + '<p style="margin-left: 42px">' + "rubro a " +
                '<strong style="color: #1a7031">' + "APROBADO" + "?" + '</strong>' + '</p>',
            buttons: {
                cancel: {
                    label: '<i class="fa fa-times"></i> Cancelar',
                    className: 'btn-primary'
                },
                confirm: {
                    label: '<i class="fa fa-check"></i> Cambiar',
                    className: 'btn-success'
                }
            },
            callback: function (result) {
                if(result){
                    $("#btnRegistrar").replaceWith(spinner);
                    $.ajax({
                        type: 'POST',
                        url: '${createLink(controller: 'rubro', action: 'registrar_ajax')}',
                        data:{
                            id: idRubro
                        },
                        success: function (msg) {
                            if(msg === 'ok'){
                                $("#spanOk").html("Rubro registrado correctamente");
                                $("#divOk").show();
                                setTimeout(function () {
                                    location.reload()
                                }, 1000);
                            }else{
                                $("#spanError").html("Error al cambiar el estado del rubro a registrado");
                                $("#divError").show()
                            }
                        }
                    })
                }
            }
        });
    });

    function agregar(id,tipo){
        var tipoItem=$("#item_id").attr("tipo");
        var cant = $("#item_cantidad").val();
        if (cant === "")
            cant = 0;
        if (isNaN(cant))
            cant = 0;
        if(tipoItem*1>1){
            if(cant>0){
                var c = Math.ceil(cant);
                if(c>cant){
                    cant=0
                }
            }
        }
        var rend = $("#item_rendimiento").val();
        if (isNaN(rend))
            rend = 1;
        if ($("#item_id").val() * 1 > 0) {
            if (cant > 0) {
                var data = "rubro="+id+"&item=" + $("#item_id").val() + "&cantidad=" + cant + "&rendimiento=" + rend;
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'rubro',action:'addItem')}",
                    data     : data,
                    success  : function (msg) {
                        // if(tipo=="H"){
                            window.location.href="${g.createLink(action: 'rubroPrincipal')}/"+id;
                        // }
                        var tr = $("<tr class='item_row'>");
                        var td = $("<td>");
                        var band = true;
                        var parts = msg.split(";");
                        tr.attr("id", parts[1]);
                        tr.attr("tipoLista", parts[5]);
                        var a;
                        td.addClass("cdgo");
                        td.html($("#cdgo_buscar").val());
                        tr.append(td);
                        td = $("<td>");
                        td.html($("#item_desc").val());
                        tr.append(td);
                        //
                        // if (parts[0] === "1") {
                        //     $("#tabla_material").children().find(".cdgo").each(function () {
                        //         if ($(this).html() === $("#cdgo_buscar").val()) {
                        //             var tdCant = $(this).parent().find(".cant");
                        //             var tdRend = $(this).parent().find(".rend");
                        //             tdCant.html(number_format(parts[3], 5, ".", ""));
                        //             tdRend.html(number_format(parts[4], 5, ".", ""));
                        //             tdRend.attr("valor", parts[4]);
                        //             band = false
                        //         }
                        //     });
                        //     if (band) {
                        //         td = $("<td style='text-align: center' class='col_unidad'>");
                        //         td.html($("#item_unidad").val());
                        //         tr.append(td);
                        //         td = $("<td style='text-align: right' class='cant'>");
                        //         td.html(number_format($("#item_cantidad").val(), 5, ".", ""));
                        //         tr.append(td);
                        //         td = $('<td class="col_precioUnit" style="display: none;text-align: right"></td>');
                        //         td.attr("id", "i_" + parts[2]);
                        //         tr.append(td);
                        //         td = $('<td class="col_vacio" style="width: 40px;display: none"></td>');
                        //         tr.append(td);
                        //         td = $('<td class="col_vacio" style="width: 40px;display: none"></td>');
                        //         tr.append(td);
                        //         td = $('<td class="col_total" style="display: none;text-align: right"></td>');
                        //         tr.append(td);
                        //         td = $('<td  style="width: 40px;text-align: center" class="col_delete">');
                        //         a = $('<a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="' + parts[1] + '"><i class="icon-trash"></i></a>');
                        //         td.append(a);
                        //         tr.append(td);
                        //         $("#tabla_material").append(tr);
                        //     }
                        // } else {
                        //     if (parts[0] === "2") {
                        //         $("#tabla_mano").children().find(".cdgo").each(function () {
                        //             if ($(this).html() === $("#cdgo_buscar").val()) {
                        //                 var tdCant = $(this).parent().find(".cant");
                        //                 var tdRend = $(this).parent().find(".rend");
                        //                 tdCant.html(number_format(parts[3], 5, ".", ""));
                        //                 tdRend.html(number_format(parts[4], 5, ".", ""));
                        //                 tdRend.attr("valor", parts[4]);
                        //                 band = false
                        //             }
                        //         });
                        //         if (band) {
                        //             td = $("<td style='text-align: right' class='cant'>");
                        //             td.html(number_format(parts[3], 5, ".", ""));
                        //             tr.append(td);
                        //             td = $('<td class="col_jornal" style="display: none;text-align: right"></td>');
                        //             td.attr("id", "i_" + parts[2]);
                        //             tr.append(td);
                        //             td = $('<td class="col_hora" style="display: none;text-align: right"></td>');
                        //             tr.append(td);
                        //             td = $("<td style='text-align: right' class='col_rend rend'>");
                        //             td.attr("valor", parts[4]);
                        //             td.html(number_format(parts[4], 5, ".", ""));
                        //             tr.append(td);
                        //             td = $('<td class="col_total" style="display: none;text-align: right"></td>');
                        //             tr.append(td);
                        //             td = $('<td  style="width: 40px;text-align: center" class="col_delete">');
                        //             a = $('<a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="' + parts[1] + '"><i class="icon-trash"></i></a>');
                        //             td.append(a);
                        //             tr.append(td);
                        //             $("#tabla_mano").append(tr)
                        //         }
                        //
                        //     } else {
                        //         $("#tabla_equipo").children().find(".cdgo").each(function () {
                        //             if ($(this).html() === $("#cdgo_buscar").val()) {
                        //                 var tdCant = $(this).parent().find(".cant");
                        //                 var tdRend = $(this).parent().find(".rend");
                        //                 tdCant.html(number_format(parts[3], 5, ".", ""));
                        //                 tdRend.html(number_format(parts[4], 5, ".", ""));
                        //                 tdRend.attr("valor", parts[4]);
                        //                 band = false
                        //             }
                        //         });
                        //
                        //         if (band) {
                        //             td = $("<td style='text-align: right' class='cant'>");
                        //             td.html(number_format(parts[3], 5, ".", ""));
                        //             tr.append(td);
                        //             td = $('<td class="col_tarifa" style="display: none;text-align: right"></td>');
                        //             td.attr("id", "i_" + parts[2]);
                        //             tr.append(td);
                        //             td = $('<td class="col_hora" style="display: none;text-align: right"></td>');
                        //             tr.append(td);
                        //             td = $("<td style='text-align: right' class='col_rend rend'>");
                        //             td.attr("valor", parts[4]);
                        //             td.html(number_format(parts[4], 5, ".", ""));
                        //             tr.append(td);
                        //             td = $('<td class="col_total" style="display: none;text-align: right"></td>');
                        //             tr.append(td);
                        //             td = $('<td  style="width: 40px;text-align: center" class="col_delete">');
                        //             a = $('<a class="btn btn-small btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="' + parts[1] + '"><i class="icon-trash"></i></a>');
                        //             td.append(a);
                        //             tr.append(td);
                        //             $("#tabla_equipo").append(tr)
                        //         }
                        //     }
                        // }

                        // tr.bind("dblclick", function () {
                        //     var row = $(this);
                        //     var hijos = row.children();
                        //     var desc = $(hijos[1]).html();
                        //     var cant;
                        //     var codigo = $(hijos[0]).html();
                        //     var unidad;
                        //     var rendimiento;
                        //     var item;
                        //     var tipo = row.attr("tipo");
                        //     for (i = 2; i < hijos.length; i++) {
                        //         if ($(hijos[i]).hasClass("cant"))
                        //             cant = $(hijos[i]).html();
                        //         if ($(hijos[i]).hasClass("col_unidad"))
                        //             unidad = $(hijos[i]).html();
                        //         if ($(hijos[i]).hasClass("col_rend"))
                        //             rendimiento = $(hijos[i]).attr("valor");
                        //         if ($(hijos[i]).hasClass("col_tarifa"))
                        //             item = $(hijos[i]).attr("id");
                        //         if ($(hijos[i]).hasClass("col_precioUnit"))
                        //             item = $(hijos[i]).attr("id");
                        //         if ($(hijos[i]).hasClass("col_jornal"))
                        //             item = $(hijos[i]).attr("id");
                        //     }
                        //     item = item.replace("i_", "");
                        //     $("#item_cantidad").val(cant.toString().trim());
                        //     if (rendimiento)
                        //         $("#item_rendimiento").val(rendimiento.toString().trim());
                        //     $("#item_id").val(item).attr("tipo",tipo);
                        //     $("#cdgo_buscar").val(codigo);
                        //     $("#item_desc").val(desc);
                        //     $("#item_unidad").val(unidad);
                        // });

                        %{--if (a) {--}%
                        %{--    a.bind("click", function () {--}%
                        %{--        var tr = $(this).parent().parent();--}%
                        %{--        bootbox.confirm({--}%
                        %{--            title: "Eliminar",--}%
                        %{--            message: "Está seguro de eliminar este registro? Esta acción no puede deshacerse.",--}%
                        %{--            buttons: {--}%
                        %{--                cancel: {--}%
                        %{--                    label: '<i class="fa fa-times"></i> Cancelar',--}%
                        %{--                    className: 'btn-primary'--}%
                        %{--                },--}%
                        %{--                confirm: {--}%
                        %{--                    label: '<i class="fa fa-trash"></i> Borrar',--}%
                        %{--                    className: 'btn-danger'--}%
                        %{--                }--}%
                        %{--            },--}%
                        %{--            callback: function (result) {--}%
                        %{--                if(result){--}%
                        %{--                    $.ajax({--}%
                        %{--                        type : "POST",--}%
                        %{--                        url : "${g.createLink(controller: 'rubro',action:'eliminarRubroDetalle')}",--}%
                        %{--                        data     : "id=" + $(this).attr("iden"),--}%
                        %{--                        success  : function (msg) {--}%
                        %{--                            if (msg === "Registro eliminado") {--}%
                        %{--                                tr.remove()--}%
                        %{--                            }--}%
                        %{--                            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg + '</strong>');--}%
                        %{--                        }--}%
                        %{--                    });--}%
                        %{--                }--}%
                        %{--            }--}%
                        %{--        });--}%
                        %{--    });--}%
                        %{--}--}%
                        $("#item_desc").val("");
                        $("#item_id").val("");
                        $("#item_cantidad").val("0");
                        $("#cdgo_buscar").val("").focus();
                        $("#cdgo_unidad").val("");
                    }
                });
            } else {
                var msg = "La cantidad debe ser un número positivo.";
                if(tipoItem*1>1){
                    msg="Para mano de obra y equipos, la cantidad debe ser un número entero positivo."
                }
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg + '</strong>');
            }
        } else {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione un item" + '</strong>');
        }
    }
    function enviarItem() {
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
        var tipo = $(".tipo.active").attr("tipo");
        data+="&tipo="+tipo;
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'rubro',action:'buscaItem')}",
            data     : data,
            success  : function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });
    }

    function enviarCopiar() {
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
            url : "${g.createLink(controller: 'rubro',action:'buscaRubroComp')}",
            data     : data,
            success  : function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });
    }

    function transporte() {
        var dsp0 = $("#dist_p1").val();
        var dsp1 = $("#dist_p2").val();
        var dsv0 = $("#dist_v1").val();
        var dsv1 = $("#dist_v2").val();
        var dsv2 = $("#dist_v3").val();
        var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," +
            $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val();
        var volqueta = $("#costo_volqueta").val();
        var chofer = $("#costo_chofer").val();

        $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'transporte')}",
            data     : "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2  +
                "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val() + "&id=${rubro?.id}&lugar=" +
                $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof").val() + "&volq=" + $("#cmb_vol").val(),
            success  : function (msg) {
                $("#tabla_transporte").html(msg);
                tablaIndirectos();
            }
        });
    }

    function totalEquipos() {
        var trE = $("<tr id='total_equipo' class='total'>");
        var equipos = $("#tabla_equipo").children();
        var totalE = 0;
        var td = $("<td>");
        td.html("<b>SUBTOTAL</b>");
        trE.append(td);
        for (i = 0; i < 5; i++) {
            td = $("<td>");
            trE.append(td)
        }

        equipos.each(function () {
            totalE += parseFloat($(this).find(".col_total").html())
        });

        td = $("<td class='valor_total'  style='text-align: right;;font-weight: bold'>");
        td.html(number_format(totalE, 5, ".", ""));
        trE.append(td);
        $("#tabla_equipo").append(trE);
        transporte()
    }

    function calculaHerramientas() {
        var h2 = $(".i_3490");
        var h3 = $(".cod_103_001_001");
        var h5 = $(".cod_103_001_002");
        var h;
        if (h2.html())
            h = h2;
        if (h3.html())
            h = h3;
        if (h5.html())
            h = h5;
        if (h) {
            var precio = 0;
            var listas = "" + $("#lista_1").val() + "#" + $("#lista_2").val() + "#" + $("#lista_3").val() + "#" + $("#lista_4").val() + "#" + $("#lista_5").val() + "#" + $("#ciudad").val();

            var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val() + "&tipo=C" + "&listas=" + listas + "&ids=" + str_replace("i_", "", h.attr("id"));
            $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'getPreciosItem')}",
                data     : datos,
                success  : function (msg) {
                    var precios = msg.split("&");
                    for (i = 0; i < precios.length; i++) {
                        var parts = precios[i].split(";");
                        if (parts.length > 1) {
                            precio = parseFloat(parts[1].trim())
                        }
                    }
                    var padre = h.parent();
                    var rend = padre.find(".rend");
                    var hora = padre.find(".col_hora");
                    var total = padre.find(".col_total");
                    var cant = padre.find(".cant");
                    var tarifa = padre.find(".col_tarifa");
                    rend.html(number_format(1, 5, ".", ""));
                    cant.html(number_format($("#total_mano").find(".valor_total").html(), 5, ".", ""));
                    tarifa.html(number_format(precio, 5, ".", ""));
                    hora.html(number_format(parseFloat(cant.html()) * parseFloat(tarifa.html()), 5, ".", ""));
                    total.html(number_format(parseFloat(hora.html()) * parseFloat(rend.html()), 5, ".", ""));
                    totalEquipos()
                }
            });
        } else {
            totalEquipos()
        }
    }

    function calcularTotales() {
        var materiales = $("#tabla_material").children();
        var equipos = $("#tabla_equipo").children();
        var manos = $("#tabla_mano").children();
        var totalM = 0, totalE = 0, totalMa = 0;
        var trM = $("<tr id='total_material' class='total'>");
        var trMa = $("<tr id='total_mano' class='total'>");
        var trE = $("<tr id='total_equipo' class='total'>");

        var td = $("<td>");
        td.html("<b>SUBTOTAL</b>");
        trM.append(td);
        td = $("<td>");
        td.html("<b>SUBTOTAL</b>");
        trMa.append(td);
        td = $("<td>");
        td.html("<b>SUBTOTAL</b>");
        trE.append(td);
        for (i = 0; i < 5; i++) {
            if (i < 3) {
                td = $("<td>");
                trM.append(td);
            }
            td = $("<td>");
            trMa.append(td);
            td = $("<td>");
            trE.append(td);
        }

        td = $("<td>");
        trM.append(td);
        materiales.each(function () {
            var val = $(this).find(".col_total").html();
            if (val === "")
                val = 0;
            if (isNaN(val))
                val = 0;
            totalM += parseFloat(val)
        });
        manos.each(function () {
            totalMa += parseFloat($(this).find(".col_total").html())
        });
        td = $("<td class='valor_total' style='text-align: right;font-weight: bold'>");
        td.html(number_format(totalM, 5, ".", ""));
        trM.append(td);
        td = $("<td class='valor_total'  style='text-align: right;font-weight: bold'>");
        td.html(number_format(totalMa, 5, ".", ""));
        trMa.append(td);
        $("#tabla_material").append(trM);
        $("#tabla_mano").append(trMa);
        $("#totMat_h").val(totalMa);
        calculaHerramientas()
    }

    function tablaIndirectos() {
        var total = 0;
        $(".valor_total").each(function () {
            total += $(this).html() * 1
        });
        var indi = $("#costo_indi").val();
        if (isNaN(indi))
            indi = 21;
        indi = parseFloat(indi);
        var tabla = $('<table class="table table-bordered table-striped table-condensed table-hover">')
        tabla.append("<thead><tr><th colspan='3'>COSTOS INDIRECTOS</th></tr><tr><th style='width: 885px;'>DESCRIPCION</th><th style='text-align: right'>PORCENTAJE</th><th style='text-align: right'>VALOR</th></tr></thead>");
        tabla.append("<tbody><tr><td>COSTOS INDIRECTOS</td><td style='text-align: right'>" + indi + "%</td><td style='text-align: right;font-weight: bold'>" + number_format(total * indi / 100, 5, ".", "") + "</td></tr></tbody>");
        tabla.append("</table>");
        $("#tabla_indi").append(tabla);
        tabla = $('<table class="table table-bordered table-striped table-condensed table-hover" ' +
            'style="width: 360px;float: right;border: 1px solid #00485a">');
        tabla.append("<tbody>");
        tabla.append("<tr><td style='width: 300px;font-weight: bolder;'>COSTO UNITARIO DIRECTO</td><td style='text-align: right;font-weight: bold'>" + number_format(total, 5, ".", "") + "</td></tr>");
        tabla.append("<tr><td style='font-weight: bolder'>COSTOS INDIRECTOS</td><td style='text-align: right;font-weight: bold'>" + number_format(total * indi / 100, 5, ".", "") + "</td></tr>");
        tabla.append("<tr><td style='font-weight: bolder'>COSTO TOTAL DEL RUBRO</td><td style='text-align: right;font-weight: bold'>" + number_format(total * indi / 100 + total, 5, ".", "") + "</td></tr>");
        tabla.append("<tr><td style='font-weight: bolder'>PRECIO UNITARIO ($USD)</td><td style='text-align: right;font-weight: bold'>" + number_format(total * indi / 100 + total, 2, ".", "") + "</td></tr>");
        tabla.append("</tbody>");
        $("#tabla_costos").append(tabla).show("slide");
    }

    $(function () {
        $("#save-espc").click(function () {
            if ($("#especificaciones").val().trim().length < 1024) {
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'rubro', action:'saveEspc')}",
                    data     : "id=${rubro?.id}&espc=" + $("#especificaciones").val().trim(),
                    success  : function (msg) {
                        if (msg === "ok") {
                            $("#modal-detalle").modal("hide");
                        } else {
                            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ha ocurrido un error" + '</strong>');
                        }
                    }
                });
            } else {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Las especificaciones deben tener un máximo de 1024 caracteres" + '</strong>');
            }
        });

        $("#copiar_dlg").dialog({
            autoOpen : false,
            width    : 400,
            height   : 200,
            title    : "Copiar composición",
            modal    : true,
            buttons  : {
                "Cancelar" : function () {
                    $("#copiar_dlg").dialog("close")
                },
                "Copiar"   : function () {
                    $("#dlgLoad").dialog("open");
                    var factor = $("#factor").val();
                    if (isNaN(factor))
                        factor = 0;
                    else
                        factor = factor * 1;
                    if (factor > 0) {

                        var idReg = $("#rub_select").val();
                        var datos = "rubro=" + $("#rubro__id").val() + "&copiar=" + idReg + "&factor=" + factor;
                        $.ajax({
                            type : "POST",
                            url : "${g.createLink(controller: 'rubro', action: 'copiarComposicion')}",
                            data     : datos,
                            success  : function (msg) {
                                // $("#modal-rubro").modal("hide");
                                location.reload()
                            }
                        });
                    } else {
                        $("#dlgLoad").dialog("close");
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "El factor debe ser un número positivo" + '</strong>');
                    }
                }
            }
        });

        $("#fecha_precios").change(function(){
            $("#cmb_vol").change();
            $("#cmb_chof").change();
        });

        $("#foto").click(function () {
            var child = window.open('${createLink(controller:"rubro",action:"showFoto",id: rubro?.id, params:[tipo:"il"])}', 'Mies', 'width=850,height=600,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');

            if (child.opener == null)
                child.opener = self;
            window.toolbar.visible = false;
            window.menubar.visible = false;
        });

        $("#detalle").click(function () {
            var child = window.open('${createLink(controller:"rubro",action:"showFoto",id: rubro?.id, params:[tipo:"dt"])}',
                'Mies', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');

            if (child.opener == null)
                child.opener = self;
            window.toolbar.visible = false;
            window.menubar.visible = false;
        });

        $("#borrar").click(function () {
            <g:if test="${rubro}">

            bootbox.confirm({
                title: "Eliminar",
                message: "Está seguro de eliminar este registro? Esta acción no puede deshacerse.",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-trash"></i> Borrar',
                        className: 'btn-danger'
                    }
                },
                callback: function (result) {
                    if(result){
                        $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'borrarRubro')}",
                            data     : "id=${rubro?.id}",
                            success  : function (msg) {
                                $("#dlgLoad").dialog("close");
                                if (msg === "ok") {
                                    location.href = "${createLink(action: 'rubroPrincipal')}"
                                } else {
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "El rubro seleccionado no se pudo eliminar. Esta referenciado en las siguientes obras: <br>" + msg + '</strong>');
                                }
                            }
                        });
                    }
                }
            });
            </g:if>
        });

        $("#costo_indi").blur(function () {
            var indi = $(this).val();
            if (isNaN(indi) || indi * 1 < 0) {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "El porcentaje de costos indirectos debe ser un número positvo" + '</strong>');
                $("#costo_indi").val("21")
            }
        });

        $("#excel").click(function () {
            var dsp0 = $("#dist_p1").val();
            var dsp1 = $("#dist_p2").val();
            var dsv0 = $("#dist_v1").val();
            var dsv1 = $("#dist_v2").val();
            var dsv2 = $("#dist_v3").val();
            var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," +
                $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val();
            var volqueta = $("#costo_volqueta").val();
            var chofer = $("#costo_chofer").val();

            datos = "?dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2 + "&prvl="
                + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val() + "&id=${rubro?.id}&lugar=" +
                $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof").val() + "&volq=" +
                $("#cmb_vol").val() + "&indi=" + $("#costo_indi").val();

            location.href = "${g.createLink(controller: 'reportesExcel2',action: 'imprimirRubroExcel')}" + datos;
        });

        $("#imprimir").click(function (e) {
            $("#imprimirTransporteDialog").dialog("open");
        });

        $("#dialTransporte").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 800,
            height: 400,
            position: 'center',
            title: 'Variables de Transporte',
            buttons   : {
                "Cerrar": function () {
                    $("#dialTransporte").dialog("close");
                }
            }
        });

        $("#transporte").click(function () {
            if ($("#fecha_precios").val().length < 8) {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione una fecha para determinar la lista de precios" + '</strong>');
                $(this).removeClass("active")
            } else {
                $("#dialTransporte").dialog("open");
                $(".ui-dialog-titlebar-close").html("x")
            }
        });

        $("#cmb_vol").change(function () {
            if ($("#cmb_vol").val() !== "-1") {
                var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val() + "&ids=" + $("#cmb_vol").val();
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                    data     : datos,
                    success  : function (msg) {
                        var precios = msg.split("&");
                        for (i = 0; i < precios.length; i++) {
                            var parts = precios[i].split(";");
                            if (parts.length > 1)
                                $("#costo_volqueta").val(parts[1].trim())
                        }
                    }
                });
            } else {
                $("#costo_volqueta").val("0.00")
            }
        });

        $("#cmb_vol").change();
        $("#cmb_chof").change(function () {
            if ($("#cmb_chof").val() !== "-1") {
                var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val() + "&ids=" + $("#cmb_chof").val()
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                    data     : datos,
                    success  : function (msg) {
                        var precios = msg.split("&");
                        for (i = 0; i < precios.length; i++) {
                            var parts = precios[i].split(";");
                            if (parts.length > 1)
                                $("#costo_chofer").val(parts[1].trim())
                        }
                    }
                });
            } else {
                $("#costo_chofer").val("0.00")
            }

        });

        $("#cmb_chof").change();

        $(".item_row").dblclick(function () {
            var row = $(this);
            var hijos = row.children();
            var desc = $(hijos[1]).html();
            var cant;
            var codigo = $(hijos[0]).html();
            var unidad;
            var rendimiento;
            var item;
            var tipo = row.attr("tipo");
            for (i = 2; i < hijos.length; i++) {
                if ($(hijos[i]).hasClass("cant"))
                    cant = $(hijos[i]).html();
                if ($(hijos[i]).hasClass("col_unidad"))
                    unidad = $(hijos[i]).html();
                if ($(hijos[i]).hasClass("col_rend"))
                    rendimiento = $(hijos[i]).attr("valor");
                if ($(hijos[i]).hasClass("col_tarifa"))
                    item = $(hijos[i]).attr("id");
                if ($(hijos[i]).hasClass("col_precioUnit"))
                    item = $(hijos[i]).attr("id");
                if ($(hijos[i]).hasClass("col_jornal"))
                    item = $(hijos[i]).attr("id");
            }
            item = item.replace("i_", "");
            $("#item_cantidad").val(cant.toString().trim());
            if (rendimiento)
                $("#item_rendimiento").val(rendimiento.toString().trim());
            $("#item_id").val(item).attr("tipo",tipo);
            $("#cdgo_buscar").val(codigo);
            $("#item_desc").val(desc);
            $("#item_unidad").val(unidad)
        });

        cargarGrupo($("#selClase option:selected").val());

        function cargarGrupo(clase){
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'gruposPorClase')}",
                data    : {
                    id : clase,
                    rubro: '${rubro?.id}'
                },
                success : function (msg) {
                    $("#seleccionarGrupo").html(msg)
                }
            });
        }

        $("#selClase").change(function () {
            var clase = $("#selClase option:selected").val();
            cargarGrupo(clase);
        });

        $(".tipoPrecio").click(function () {
            if (!$(this).hasClass("active")) {
                var tipo = $(this).attr("id");
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(action:'ciudadesPorTipo')}",
                    data    : {
                        id : tipo
                    },
                    success : function (msg) {
                        $("#ciudad").replaceWith(msg);
                    }
                });
            }
        });

        $("#calcular").click(function () {
            if ($(this).hasClass("active")) {
                $(this).removeClass("active");
                $(".col_delete").show();
                $(".col_unidad").show();
                $(".col_tarifa").hide();
                $(".col_hora").hide();
                $(".col_total").hide();
                $(".col_jornal").hide();
                $(".col_precioUnit").hide();
                $(".col_vacio").hide();
                $(".total").remove();
                $("#tabla_indi").html("");
                $("#tabla_costos").html("");
                $("#tabla_transporte").html("")
            } else {
                $(this).addClass("active");
                var fecha = $("#fecha_precios").val();

                if (fecha.length < 8) {
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione una fecha para determinar la lista de precios" + '</strong>');
                    $(this).removeClass("active")
                } else {
                    var items = $(".item_row");
                    if (items.size() < 1) {
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Añada items a la composición del rubro antes de calcular los precios" + '</strong>');
                        $(this).removeClass("active")
                    } else {
                        var tipo = "C";
                        if ($("#V").hasClass("active"))
                            tipo = "V";
                        var listas = "";
                        listas += $("#lista_1").val() + "#" + $("#lista_2").val() + "#" + $("#lista_3").val() + "#" +
                            $("#lista_4").val() + "#" + $("#lista_5").val() + "#" + $("#ciudad").val();

                        var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val() + "&tipo=" +
                            tipo + "&listas=" + listas + "&ids=";
                        $.each(items, function () {
                            datos += $(this).attr("id") + "#"
                        });
                        $.ajax({
                            type : "POST",
                            url : "${g.createLink(controller: 'rubro',action:'getPrecios')}",
                            data     : datos,
                            success  : function (msg) {
                                var precios = [];
                                precios = msg.split("&");
                                if (precios.length > 1)
                                    for (i = 0; i < precios.length; i++) {
                                        var parts = precios[i].split(";");
                                        var celda = $("#i_" + parts[0]);
                                        celda.html(number_format(parts[1], 5, ".", ""));
                                        var padre = celda.parent();
                                        var celdaRend = padre.find(".col_rend");
                                        var celdaTotal = padre.find(".col_total");
                                        var celdaCant = padre.find(".cant");
                                        var celdaHora = padre.find(".col_hora");
                                        var rend = 1;
                                        if (celdaHora.hasClass("col_hora")) {
                                            celdaHora.html(number_format(parseFloat(celda.html()) * parseFloat(celdaCant.html()), 5, ".", ""))
                                        }
                                        if (celdaRend.html()) {
                                            rend = celdaRend.attr("valor") * 1
                                        }
                                        celdaTotal.html(number_format(parseFloat(celda.html()) * parseFloat(celdaCant.html()) * parseFloat(rend), 5, ".", ""))
                                    }
                                calcularTotales()
                            }
                        });

                        $(".col_delete").hide();
                        $(".col_tarifa").show();
                        $(".col_hora").show();
                        $(".col_total").show();
                        $(".col_jornal").show();
                        $(".col_precioUnit").show();
                        $(".col_vacio").show()
                    }
                }
            }
        });

        $("#btn_copiarComp").click(function () {
            var dp = cargarLoader("Cargando...");
            if ($("#rubro__id").val() * 1 > 0) {
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'rubro',action:'verificaRubro')}",
                    data     : "id=${rubro?.id}",
                    success  : function (msg) {
                        dp.modal("hide");
                        dp.on('hidden.bs.modal', function (e) {
                            $("#dlgLoad").dialog("close");
                            var parts = msg.split("_");
                            if(parts[0] === "1"){
                                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Este rubro ya forma parte de la obra: " + parts[1] + '</strong>');
                            }else{
                                var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
                                $("#modalTitle").html("Lista de rubros");
                                $("#modalFooter").html("").append(btnOk);
                                $(".contenidoBuscador").html("");
                                $("#tipos").hide();
                                // $("#btn_reporte").show();
                                // $("#btn_excel").show();
                                $("#modal-rubro").dialog("open");
                                // $("#buscarDialog").unbind("click").bind("click", enviarCopiar);
                            }
                        })
                    }
                });
            } else {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Primero guarde el rubro o seleccione uno para editar" + '</strong>');
            }
        });

        $(".borrarItem").click(function () {
            var tr = $(this).parent().parent();
            var boton = $(this);

            bootbox.confirm({
                title: "Eliminar",
                message: "Está seguro de eliminar este registro? Esta acción no puede deshacerse.",
                buttons: {
                    cancel: {
                        label: '<i class="fa fa-times"></i> Cancelar',
                        className: 'btn-primary'
                    },
                    confirm: {
                        label: '<i class="fa fa-trash"></i> Borrar',
                        className: 'btn-danger'
                    }
                },
                callback: function (result) {
                    if(result){
                        $.ajax({
                            type : "POST",
                            url : "${g.createLink(controller: 'rubro',action:'verificaRubro')}",
                            data     : "id=${rubro?.id}",
                            success  : function (msg) {
                                $("#dlgLoad").dialog("close");
                                var resp = msg.split('_');
                                if(resp[0] === "1"){
                                    bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Este rubro ya forma parte de la(s) obra(s):" + resp[1]  + "</br>  * Si desea eliminar el item, necesita crear el historico del rubro" +'</strong>');
                                }else{
                                    $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'eliminarRubroDetalle')}",
                                        data     : "id=" + boton.attr("iden"),
                                        success  : function (msg) {
                                            if (msg === "Registro eliminado") {
                                                tr.remove()
                                            }
                                            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg  + '</strong>');
                                        }
                                    });
                                }
                            }
                        });
                    }
                }
            });
        });

        $(".infoItem").click(function () {
            var tr = $(this).parent().parent();
            var boton = $(this);

            $("#dlgLoad").dialog("open");
            $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'verificaRubro')}",
                data     : "id=${rubro?.id}",
                success  : function (msg) {
                    $("#dlgLoad").dialog("close");
                    var resp = msg.split('_');
                    if(resp[0] === "1"){
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Este rubro forma parte de la(s) obra(s):" + resp[1]  + '</strong>');
                    }else{
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Este rubro no forma parte de ninguna obra"  + '</strong>');
                    }
                }
            });
        });

        $("#btn_lista").click(function () {
            $("#listaRbro").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        });

        $("#listaRbro").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 1000,
            height: 500,
            position: 'center',
            title: 'Rubros'
        });

        $("#cnsl-rubros").click(function () {
            buscaRubros();
        });

        $("#cnsl-rubros-composicion").click(function () {
            buscaRubrosComposicion();
        });

        function buscaRubros() {
            var buscarPor = $("#buscarPorLista").val();
            // var tipo = $("#buscarTipo").val();
            var criterio = $("#criterioLista").val();
            var ordenar = $("#ordenarLista").val();
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'rubro', action:'listaRubros')}",
                data: {
                    buscarPor: buscarPor,
                    // buscarTipo: tipo,
                    criterio: criterio,
                    ordenar: ordenar,
                    rubro: '${rubro?.id}'
                },
                success: function (msg) {
                    $("#divTablaRbro").html(msg);
                }
            });
        }

        function buscaRubrosComposicion() {
            var buscarPor = $("#buscarPorComposicion").val();
            // var tipo = $("#buscarTipo").val();
            var criterio = $("#criterioComposicion").val();
            var ordenar = $("#ordenarComposicion").val();
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'rubro', action:'listaRubros')}",
                data: {
                    buscarPor: buscarPor,
                    // buscarTipo: tipo,
                    criterio: criterio,
                    ordenar: ordenar,
                    rubro: '${rubro?.id}',
                    tipo: "composicion"
                },
                success: function (msg) {
                    $("#divTablaRbroComposicion").html(msg);
                }
            });
        }

        $("#criterioLista").keydown(function (ev) {
            if (ev.keyCode === 13) {
                buscaRubros();
                return false;
            }
            return true;
        });

        $("#criterio").keydown(function (ev) {
            if (ev.keyCode === 13) {
                busqueda();
                return false;
            }
            return true;
        });

        $("#cdgo_buscar").keydown(function (ev) {
            if (ev.keyCode * 1 !== 9 && (ev.keyCode * 1 < 37 || ev.keyCode * 1 > 40)) {
                $("#item_tipoLista").val("");
                $("#item_id").val("");
                $("#item_desc").val("");
                $("#item_unidad").val("")
            }
        });

        $("#guardar").click(function () {
            var cod = $("#input_codigo").val();
            var desc = $("#input_descripcion").val();
            var subGr = $("#selSubgrupo").val();
            var msg = "";
            var resp = $("#selResponsable").val();
            var espec = $("#input_codigo_es").val();

            if (cod.trim().length > 30 || cod.trim().length < 2) {
                msg = "<br><strong>Error:</strong> La propiedad código debe tener entre 2 y 30 caracteres."
            }

            if (resp === "-1") {
                msg += "<br><strong>Error:</strong> Seleccione un responsable."
            }

            var gg = cargarLoader("Guardando...");

            $.ajax({
                type : "POST",
                url : "${g.createLink(controller: 'rubro', action:'repetido')}",
                async    : false,
                data     : "codigo=" + cod + "&id=" + $("#rubro__id").val(),
                success  : function (retorna) {
                    gg.modal("hide");
                    if (retorna === "no") {
                        msg = "<br><strong>Error:</strong> el código " + cod.toUpperCase() + " está repetido"
                    }
                    if (desc.trim().length > 160 || desc.trim().length < 1) {
                        msg += "<br>La propiedad descripción debe tener entre 1 y 160 caracteres."
                    }

                    if (isNaN(subGr) || subGr * 1 < 1) {
                        msg += "<br>Seleccione un subgrupo usando las listas de Dirección, Grupo y Subgrupo"
                    }

                    if (msg !== "") {
                        bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + msg + '</strong>');
                    } else {
                        $("#frmRubro").submit()
                    }
                }
            });
        });

        <g:if test="${rubro}">
        $("#btn_agregarItem").click(function () {
            if($('#item_desc').val().length === 0)  {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "No hay item que agregar al APU" + '</strong>');
                return false
            }
            if ($("#calcular").hasClass("active")) {
                bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Antes de agregar items, por favor desactive la opción calcular precios en el menú superior" + '</strong>');
                return false
            }
            $("#dlgLoad").dialog("open");
            $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'verificaRubro')}",
                data     : "id=${rubro?.id}",
                success  : function (msg) {
                    $("#dlgLoad").dialog("close");
                    var resp = msg.split('_');
                    if(resp[0] === "1"){
                        bootbox.confirm({
                            title: "Alerta",
                            message: "Este rubro ya forma parte de la(s) obra(s):" + resp[1] + "Desea crear una nueva versión de este rubro, y hacer una versión histórica?",
                            buttons: {
                                cancel: {
                                    label: '<i class="fa fa-times"></i> Cancelar',
                                    className: 'btn-primary'
                                },
                                confirm: {
                                    label: '<i class="fa fa-copy"></i> Copiar',
                                    className: 'btn-success'
                                }
                            },
                            callback: function (result) {
                                if(result){
                                    $("#dlgLoad").dialog("open");
                                    $.ajax({
                                        type : "POST",
                                        url : "${g.createLink(controller: 'rubro',action:'copiaRubro')}",
                                        data     : "id=${rubro?.id}",
                                        success  : function (msg) {
                                            $("#dlgLoad").dialog("close");
                                            if(msg==="true"){
                                                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Error al generar histórico del rubro, comunique este error al administrador del sistema" + '</strong>');
                                            }else{
                                                $("#boxHiddenDlg").dialog("close");
                                                agregar(msg,"H");
                                            }
                                        }
                                    });
                                }
                            }
                        });
                    }else{
                        agregar('${rubro?.id}',"");
                    }
                }
            });
        });
        </g:if>
        <g:else>
        $("#btn_agregarItem").click(function () {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Primero guarde el rubro o seleccione uno para editar" + '</strong>');
            return false;
        });
        </g:else>

        $("#imprimirTransporteDialog").dialog({
            autoOpen  : false,
            resizable : false,
            modal     : true,
            dragable  : false,
            width     : 470,
            height    : 350,
            position  : 'center',
            title     : 'Imprimir Rubro',
            buttons   : {
                "Si VAE" : function () {
                    var dsp0 = $("#dist_p1").val();
                    var dsp1 = $("#dist_p2").val();
                    var dsv0 = $("#dist_v1").val();
                    var dsv1 = $("#dist_v2").val();
                    var dsv2 = $("#dist_v3").val();
                    var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," + $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val()
                    var volqueta = $("#costo_volqueta").val();
                    var chofer = $("#costo_chofer").val();
                    var fechaSalida = $("#fechaSalidaId").val();

                    datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2
                        + "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val()
                        + "&id=${rubro?.id}&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof").val() + "&volq="
                        + $("#cmb_vol").val() + "&indi=" + $("#costo_indi").val() + "&fechaSalida=" + fechaSalida;
                    location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosV2')}?" + datos;

                    $("#imprimirTransporteDialog").dialog("close");
                },
                "No VAE" : function () {
                    var dsp0 = $("#dist_p1").val();
                    var dsp1 = $("#dist_p2").val();
                    var dsv0 = $("#dist_v1").val();
                    var dsv1 = $("#dist_v2").val();
                    var dsv2 = $("#dist_v3").val();
                    var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," + $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val();
                    var volqueta = $("#costo_volqueta").val();
                    var chofer = $("#costo_chofer").val();
                    var fechaSalida = $("#fechaSalidaId").val();

                    datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2
                        + "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val()
                        + "&id=${rubro?.id}&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" + $("#cmb_chof").val() + "&volq="
                        + $("#cmb_vol").val() + "&indi=" + $("#costo_indi").val() + "&trans=no" + "&fechaSalida=" + fechaSalida;
                    location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosV2')}?" + datos;

                    $("#imprimirTransporteDialog").dialog("close");
                },
                "Si" : function () {
                    var dsp0 = $("#dist_p1").val();
                    var dsp1 = $("#dist_p2").val();
                    var dsv0 = $("#dist_v1").val();
                    var dsv1 = $("#dist_v2").val();
                    var dsv2 = $("#dist_v3").val();
                    var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," + $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val();
                    var volqueta = $("#costo_volqueta").val();
                    var chofer = $("#costo_chofer").val();
                    var fechaSalida = $("#fechaSalidaId").val();

                    datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2
                        + "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val()
                        + "&id=${rubro?.id}&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof="
                        + $("#cmb_chof").val() + "&volq=" + $("#cmb_vol").val() + "&indi=" + $("#costo_indi").val() + "&fechaSalida=" + fechaSalida;
                    location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosTransporteV2')}?" + datos;

                    $("#imprimirTransporteDialog").dialog("close");
                },
                "No" : function () {
                    var dsp0 = $("#dist_p1").val();
                    var dsp1 = $("#dist_p2").val();
                    var dsv0 = $("#dist_v1").val();
                    var dsv1 = $("#dist_v2").val();
                    var dsv2 = $("#dist_v3").val();
                    var listas = $("#lista_1").val() + "," + $("#lista_2").val() + "," + $("#lista_3").val() + "," +
                        $("#lista_4").val() + "," + $("#lista_5").val() + "," + $("#ciudad").val();
                    var volqueta = $("#costo_volqueta").val();
                    var chofer = $("#costo_chofer").val();
                    var fechaSalida = $("#fechaSalidaId").val();

                    datos = "dsp0=" + dsp0 + "&dsp1=" + dsp1 + "&dsv0=" + dsv0 + "&dsv1=" + dsv1 + "&dsv2=" + dsv2 +
                        "&prvl=" + volqueta + "&prch=" + chofer + "&fecha=" + $("#fecha_precios").val()
                        + "&id=${rubro?.id}&lugar=" + $("#ciudad").val() + "&listas=" + listas + "&chof=" +
                        $("#cmb_chof").val() + "&volq=" + $("#cmb_vol").val()
                        + "&indi=" + $("#costo_indi").val() + "&trans=no" + "&fechaSalida=" + fechaSalida;
                    location.href = "${g.createLink(controller: 'reportesRubros',action: 'reporteRubrosTransporteV2')}?" + datos;


                    $("#imprimirTransporteDialog").dialog("close");
                },
                "Cancelar" :  function () {
                    $("#imprimirTransporteDialog").dialog("close");
                }
            }
        });
    });
</script>
</body>
</html>