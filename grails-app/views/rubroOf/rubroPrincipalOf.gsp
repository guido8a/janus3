<%@ page import="janus.Grupo" %>
<!doctype html>
<html>
<head>
    <meta name="layout" content="main">
    <title>
        Rubros
    </title>
</head>

<body>

<div class="span6 btn-group" role="navigation">
    <a href="#" class="btn  btn-primary" id="btn_lista">
        <i class="fa fa-list"></i>
        Lista
    </a>
    <a href="${g.createLink(action: 'rubroPrincipalOf')}" class="btn btn-info btn-new">
        <i class="fa fa-times"></i>
        Cancelar
    </a>
    <g:if test="${rubro}">
        <a href="#" class="btn btn-success btn-new" id="calcular" title="Calcular precios">
            <i class="fa fa-table"></i>
            Calcular
        </a>
    </g:if>
</div>

<div class="span6 btn-group" role="navigation">
    <g:if test="${rubro}">
        <a href="#" class="btn btn-ajax btn-info" id="imprimir" title="Imprimir">
            <i class="fa fa-print"></i>
            Imprimir
        </a>
        <a href="#" class="btn btn-ajax btn-info" id="vae" title="Imprimir Vae">
            <i class="fa fa-print"></i>
            Imprimir Vae
        </a>
        <a href="#" class="btn btn-ajax btn-success" id="excel" title="Imprimir">
            <i class="fa fa-file-excel"></i>
            Excel
        </a>
        <a href="#" class="btn btn-ajax btn-success" id="excelVae" title="Imprimir Excel Vae">
            <i class="fa fa-file-excel"></i>
            Excel Vae
        </a>
    </g:if>
</div>


<div id="list-grupo" class="col-md-12" role="main" style="margin-top: 10px;margin-left: -10px">
    <div style="border-bottom: 1px solid black;padding-left: 50px;position: relative;">
        <g:form name="frmRubro" action="save" style="height: 80px;">
            <input type="hidden" id="rubro__id" name="rubro.id" value="${rubro?.id}">

            <p class="css-vertical-text">Rubro</p>

            <div class="linea" style="height: 80px;"></div>

            <div class="row-fluid">
                <div class="col-md-2">
                    <label> Código </label>
                    <g:textField name="rubro.codigo" id="input_codigo" class="form-control"
                                 value="${rubro?.codigo ?: ''}" readonly="" />
                </div>

                <div class="col-md-2">
                    <label> Especificación </label>
                    <g:textField name="rubro.codigoEspecificacion" id="input_codigo_es" class="form-control"
                                 value="${rubro?.codigoEspecificacion ?: ''}" readonly="" />
                </div>
                <div class="col-md-6" >
                    <label>Descripción</label>
                    <g:textField name="rubro.nombre" id="input_descripcion" class="form-control"
                                 value="${rubro?.nombre ?: ''}" readonly="" />
                </div>
                <div class="col-md-2">
                    <label>Unidad</label>
                    <g:textField name="unidad.id" class="form-control"
                                 value="${rubro?.unidad?.descripcion ?: ''}" readonly="" />
                </div>
            </div>
            <div class="row-fluid">

            </div>
        </g:form>
    </div>

    <div style="border-bottom: 1px solid black;height: 100px; padding-left: 50px;margin-top: 10px;position: relative;">
        <p class="css-vertical-text">Items</p>

        <div class="linea" style="height: 100px;"></div>

        <div class="col-md-12">
            <div class="col-md-3" style="color: #008">
                Porcentaje de costos indirectos
            </div>
            <div class="col-md-1">
                <g:textField name="unidad.id" id="costo_indi" class="form-control"
                             value="${obra ? obra.totales : '22.5'}" />
            </div>



            %{--            <g:if test="${rubro}">--}%
            <div class="col-md-2" style="margin-left: 85px">
                <a class="btn btn-xs btn-warning " href="#" rel="tooltip" title="Copiar " id="btn_copiarComp" ${rubro ? '' : 'disabled'}>
                    <i class="fa fa-copy"></i> Copiar composición
                </a>
            </div>
            %{--            </g:if>--}%
            %{--            <g:else>--}%
            %{--                <div class="col-md-2" style="margin-left: 30px">--}%
            %{--                    <a class="btn btn-xs btn-warning " href="#" rel="tooltip" title="Copiar " disabled>--}%
            %{--                        <i class="fa fa-copy"></i> Copiar composición--}%
            %{--                    </a>--}%
            %{--                </div>--}%
            %{--            </g:else>--}%

        </div>

        <div class="row-fluid" style="margin-bottom: 5px">
            <div class="col-md-2" >
                <label>Código</label>
                <input type="hidden" id="item_id">
                <input type="hidden" id="item_tipoLista">
                <g:textField name="item.codigo" id="cdgo_buscar" class="form-control" readonly="" />
            </div>
            <div class="col-md-3">
                <label>Descripción</label>
                <g:textField name="item.descripcion" id="item_desc" class="form-control" readonly="" />
            </div>
            <div class="col-md-1" >
                <label>Unidad</label>
                <g:textField name="item.unidad" id="item_unidad" class="form-control" readonly="" />
            </div>
            <div class="col-md-2">
                <label>Precio incluye transp.</label>
                <g:textField name="item.precio" id="item_precio" class="form-control" value="1" style="text-align: right" />
            </div>
            <div class="col-md-1">
                <label>Cantidad</label>
                <g:textField name="item.cantidad" id="item_cantidad" class="form-control" value="1" style="text-align: right" />
            </div>
            <div class="col-md-1">
                <label> Rendimiento </label>
                <g:textField name="item.rendimiento" id="item_rendimiento" class="form-control" value="1" style="text-align: right" />
            </div>
            <div class="col-md-1">
                <label>VAE (%)</label>
                <g:textField name="item.vae" id="item_vae" class="form-control" value="100" style="text-align: right" />
            </div>

            <g:if test="${rubro?.id}">
                <div class="col-md-1" style="height: 45px;padding-top: 22px;margin-left: 15px; width: 35px">
                    <a class="btn btn-sm btn-primary" href="#" rel="tooltip" title="Agregar" id="btn_agregarItem">
                        <i class="fa fa-plus"></i>
                    </a>
                </div>
            </g:if>
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
                    Código
                </th>
                <th style="width: 600px;">
                    Descripción Equipo
                </th>
                <th style="width: 80px;">
                    Cantidad
                </th>
                <th class="col_tarifa" style="display: none;">Tarifa <br>($/hora)</th>
                <th class="col_hora" style="display: none;">Costo($)</th>
                <th class="col_rend" style="width: 50px">Rendimiento</th>
                <th class="col_total" style="display: none;">C.Total($)<br>($/hora)</th>
                <th style="width: 40px" class="col_delete"></th>
            </tr>
            </thead>
            <tbody id="tabla_equipo">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 3}">
                    <tr class="item_row" id="${rub.id}" data-item="${rub.item.id}" tipo="${rub.item.departamento.subgrupo.grupo.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                        </td>

                        <td class="col_tarifa" style="display: none;text-align: right" id="i_${rub.item.id}" ></td>
                        <td class="col_hora" style="display: none;text-align: right"></td>
                        <td class="col_rend rend" style="width: 50px;text-align: right"  valor="${rub.rendimiento}">
                            <g:formatNumber number="${rub.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec" />
                        </td>
                        <td class="col_total" style="display: none;text-align: right"></td>
                        <td style="width: 40px;text-align: center" class="col_delete">
                            <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}" data-id="${rub.id}">
                                <i class="fa fa-trash"></i></a>
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
                    Código
                </th>
                <th style="width: 600px;">
                    Descripción Mano de obra
                </th>
                <th style="width: 80px">
                    Cantidad
                </th>

                <th class="col_jornal" style="display: none;"  >Jornal<br>($/hora)</th>
                <th class="col_hora" style="display: none;">Costo($)</th>
                <th class="col_rend" style="width: 50px;">Rendimiento</th>
                <th class="col_total" style="display: none;">C.Total($)</th>
                <th style="width: 40px" class="col_delete"></th>
            </tr>
            </thead>
            <tbody id="tabla_mano">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 2}">
                    <tr class="item_row" id="${rub.id}" data-item="${rub.item.id}" tipo="${rub.item.departamento.subgrupo.grupo.id}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />
                        </td>

                        <td class="col_jornal" style="display: none;text-align: right" id="i_${rub.item.id}"></td>
                        <td class="col_hora" style="display: none;text-align: right"></td>
                        <td class="col_rend rend" style="width: 50px;text-align: right"  valor="${rub.rendimiento}">
                            <g:formatNumber number="${rub.rendimiento}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7" locale="ec"  />
                        </td>
                        <td class="col_total" style="display: none;text-align: right"></td>
                        <td style="width: 40px;text-align: center" class="col_delete">
                            <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar" iden="${rub.id}" data-id="${rub.id}">
                                <i class="fa fa-trash"></i></a>
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
                    Código
                </th>
                <th style="width: 600px;">
                    Descripción Material
                </th>
                <th style="width: 60px" class="col_unidad">
                    Unidad
                </th>
                <th style="width: 80px">
                    Cantidad
                </th>
                <th style="width: 40px" class="col_delete"></th>
                <th class="col_precioUnit" style="display: none;">Unitario</th>
                <th class="col_vacio" style="width: 55px;display: none"></th>
                <th class="col_vacio" style="width: 55px;display: none"></th>
                <th class="col_total" style="display: none;">C.Total($)</th>
            </tr>
            </thead>
            <tbody id="tabla_material">
            <g:each in="${items}" var="rub" status="i">
                <g:if test="${rub.item.departamento.subgrupo.grupo.id == 1}">
                    <tr class="item_row" id="${rub.id}" data-item="${rub.item.id}"  tipo="${rub.item.departamento.subgrupo.grupo.id}" data-unidad="${rub.item.unidad.codigo}">
                        <td class="cdgo">${rub.item.codigo}</td>
                        <td>${rub.item.nombre}</td>
                        <td style="width: 60px !important;text-align: center" class="col_unidad">${rub.item.unidad.codigo}</td>
                        <td style="text-align: right" class="cant">
                            <g:formatNumber number="${rub.cantidad}" format="##,#####0" minFractionDigits="5" maxFractionDigits="7"  locale="ec"  />
                        </td>
                        <td class="col_precioUnit" style="display: none;text-align: right" id="i_${rub.item.id}"></td>
                        <td class="col_vacio" style="width: 50px;display: none;"></td>
                        <td class="col_vacio" style="width: 50px;display: none"></td>
                        <td class="col_total" style="display: none;text-align: right"></td>
                        <td style="width: 40px;text-align: center" class="col_delete">
                            <a class="btn btn-xs btn-danger borrarItem" href="#" rel="tooltip" title="Eliminar material" iden="${rub.id}" data-id="${rub.id}">
                                <i class="fa fa-trash"></i></a>
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

<div class="modal large hide fade " id="modal-detalle" style=";overflow: hidden;">
    <div class="modal-header btn-info">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modalTitle-detalle">Especificaciones</h3>
    </div>

    <div class="modal-body" id="modalBody-detalle">
        Especificaciones:<br>
        <textarea id="especificaciones" style="width: 700px;height: 150px;resize: none;margin-top: 10px">
            ${rubro?.especificaciones}
        </textarea>
    </div>

    <div class="modal-footer" id="modalFooter-detalle">
        <a href="#"id="save-espc" class="btn btn-info">Guardar</a>
    </div>
</div>
<div class="modal large hide fade " id="modal-transporte" style=";overflow: hidden;">
    <div class="modal-header btn-primary">
        <button type="button" class="close" data-dismiss="modal">×</button>

        <h3 id="modal_trans_title" >
            Variables de transporte
        </h3>
    </div>

    <div class="modal-body" id="modal_trans_body">
        <div class="row-fluid">
            <div class="span2">
                Volquete
            </div>
            <div class="span5">
                <g:select name="volquetes" from="${volquetes}" optionKey="id" optionValue="nombre" id="cmb_vol" noSelection="${['-1':'Seleccione']}" value="${aux.volquete.id}"/>
            </div>
            <div class="span2">
                Costo
            </div>
            <div class="span3">
                <input type="text" style="width: 60px;text-align: right" disabled="" id="costo_volqueta">
            </div>
        </div>
        <div class="row-fluid">
            <div class="span2">
                Chofer
            </div>
            <div class="span5">
                <g:select name="volquetes" from="${choferes}" optionKey="id" optionValue="nombre" id="cmb_chof" style="" noSelection="${['-1':'Seleccione']}" value="${aux.chofer.id}" />
            </div>
            <div class="span2">
                Costo
            </div>
            <div class="span3">
                <input type="text" style="width: 60px;text-align: right" disabled="" id="costo_chofer" >
            </div>
        </div>
        <div class="row-fluid" style="border-bottom: 1px solid black;margin-bottom: 10px">
            <div class="span6">
                <b>Distancia peso</b>
            </div>
            <div class="span5" style="margin-left: 30px;">
                <b>Distancia volumen</b>
            </div>
        </div>

        <div class="row-fluid">
            <div class="span2">
                Canton
            </div>
            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_p1" value="0.00">
            </div>
            <div class="span4">
                Materiales Petreos Hormigones
            </div>
            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_v1" value="0.00">
            </div>

        </div>
        <div class="row-fluid">
            <div class="span2">
                Especial
            </div>
            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_p2" value="0.00">
            </div>
            <div class="span4">
                Materiales Mejoramiento
            </div>
            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_v2" value="0.00">
            </div>
        </div>
        <div class="row-fluid">
            <div class="span5">

            </div>
            <div class="span4">
                Materiales Carpeta Asfáltica
            </div>
            <div class="span3">
                <input type="text" style="width: 50px;" id="dist_v3" value="0.00">
            </div>
        </div>
        <div class="row-fluid" style="border-bottom: 1px solid black;margin-bottom: 10px">
            <div class="span6">
                <b>Listas de precios</b>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span1">
                Canton
            </div>
            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=1')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_1" noSelection="['-1':'Seleccione..']"/>
            </div>
            <div class="span3">
                Petreos Hormigones
            </div>
            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=3')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_3" noSelection="['-1':'Seleccione..']"/>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span1">
                Especial
            </div>
            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=2')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_2" noSelection="['-1':'Seleccione..']"/>
            </div>

            <div class="span3">
                Mejoramiento
            </div>
            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=4')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_4" noSelection="['-1':'Seleccione..']"/>
            </div>
        </div>
        <div class="row-fluid">
            <div class="span5"></div>
            <div class="span3">
                Carpeta Asfáltica
            </div>
            <div class="span4">
                <g:select name="item.ciudad.id" from="${janus.Lugar.findAll('from Lugar  where tipoLista=5')}" optionKey="id" optionValue="descripcion" class="span10" id="lista_5" noSelection="['-1':'Seleccione..']"/>
            </div>
        </div>

    </div>
    <input type="hidden" id="totMat_h">

    <div class="modal-footer" id="modal_trans_footer">
        <a href="#" data-dismiss="modal" class="btn btn-primary">OK</a>
    </div>

    <div id="imprimirTransporteDialog">
        <fieldset>
            <div class="span3">
                Desea imprimir el reporte incluido transporte?
            </div>
        </fieldset>
    </div>

    <div id="listaRbro" style="overflow: hidden">
        <fieldset class="borde" style="border-radius: 4px">
            <div class="row-fluid" style="margin-left: 20px">
                <div class="col-md-2">
                    Buscar Por
                    <g:select name="buscarPor" class="buscarPor col-md-12" from="${listaItems}" optionKey="key"
                              optionValue="value"/>
                </div>

                <div class="col-md-3">Criterio
                <g:textField name="buscarCriterio" id="criterioCriterio" style="width: 80%"/>
                </div>

                <div class="col-md-2">Ordenado por
                <g:select name="ordenar" class="ordenar" from="${listaItems}" style="width: 100%" optionKey="key"
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
                        class="fa fa-search"></i> Consultar
                </button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde">
        <div id="divTabla" style="height: 460px; overflow-y:auto; overflow-x: auto;">
        </div>
    </fieldset>
</div>

<div id="modal-rubro" style=";overflow: hidden;">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 20px">
            <div class="col-md-2">
                Buscar Por
                <g:select name="buscarPorComposicion" class="buscarPor col-md-12" from="${listaItems}" optionKey="key"
                          optionValue="value"/>
            </div>
            <div class="col-md-2">Criterio
            <g:textField name="criterioComposicion" id="criterioComposicion" style="width: 80%"/>
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

<script type="text/javascript">



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
            url: "${createLink(controller: 'rubroOf', action:'listaItem')}",
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

    $("#cnsl-rubros").click(function () {
        buscaRubros(null);
    });

    function buscaRubros(band) {
        var buscarPor = $("#buscarPor").val();
        var tipo = $("#buscarTipo").val();
        var criterio = $("#criterioCriterio").val();
        var ordenar = $("#ordenar").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'rubroOf', action:'listaRubros')}",
            data: {
                buscarPor: buscarPor,
                buscarTipo: tipo,
                criterio: criterio,
                ordenar: ordenar,
                band: band,
                rubro: '${rubro?.id}'
            },
            success: function (msg) {
                if(band === 'composicion'){
                    $("#divTablaRbroComposicion").html(msg);
                }else{
                    $("#divTablaRbro").html(msg);
                }

            }
        });
    }

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
        var precio = $("#item_precio").val();
        if (isNaN(precio))
            precio = 0;
        var vae = $("#item_vae").val();
        if (isNaN(vae))
            vae = 0;

        if ($("#item_id").val() * 1 > 0) {
            if (cant > 0 && precio>0) {
                var g = cargarLoader("Guardando...");
                var data = "rubro=${rubro?.id}&item=" + $("#item_id").val() + "&cantidad=" + cant + "&rendimiento=" + rend+"&precio="+precio+"&vae="+vae;
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'rubroOf',action:'addItem')}",
                    data     : data,
                    success  : function (msg) {
                        g.modal("hide");
                        $("#item_desc").val("");
                        $("#item_id").val("");
                        $("#item_cantidad").val("1");
                        $("#cdgo_buscar").val("");
                        $("#item_unidad").val("");
                        $("#item_precio").val("1");
                        $("#item_vae").val("100");
                        $("#cdgo_buscar").focus();
                        location.reload();
                    }
                });
            } else {
                var msg = "La cantidad debe ser un número positivo.";
                if(tipoItem*1>1){
                    msg="Para mano de obra y equipos, la cantidad debe ser un número entero positivo."
                }
                bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + "<strong style='font-size: 14px'>" +  msg +  "</strong>");
            }
        } else {
            bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + "<strong style='font-size: 14px'>" +  "Seleccione un item" +  "</strong>");
        }
    }
    function getPrecio(){
        $.ajax({
            type : "POST",
            url : "${g.createLink(controller: 'rubro',action:'getPrecioOferente')}",
            data:{
                id: $("#item_id").val()
            },
            success  : function (msg) {
                $("#item_precio").val(number_format(msg.split('_')[0], 2, ".", ""));
                $("#item_vae").val(number_format(msg.split('_')[1], 2, ".", ""));
            }
        });
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
            data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" + $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
        }
        data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
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
            data = "tc=" + $("#tipoCampo").val() + "&campos=" + $("#campo :selected").val() + "&operadores=" + $("#operador :selected").val() + "&criterios=" + $("#criterio").val()
        }
        data += "&ordenado=" + $("#campoOrdn :selected").val() + "&orden=" + $("#orden :selected").val();
        $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'buscaRubroComp')}",
            data     : data,
            success  : function (msg) {
                $("#spinner").hide();
                $("#buscarDialog").show();
                $(".contenidoBuscador").html(msg).show("slide");
            }
        });
    }

    function totalEquipos(){
        var trE=$("<tr id='total_equipo' class='total'>");
        var equipos = $("#tabla_equipo").children();
        var totalE= 0;
        var td=$("<td>");
        td.html("<b>SUBTOTAL</b>");
        trE.append(td);
        for(i=0;i<5;i++){
            td=$("<td>");
            trE.append(td)
        }

        equipos.each(function(){
            totalE+=parseFloat($(this).find(".col_total").html())
        });

        td=$("<td class='valor_total'  style='text-align: right;;font-weight: bold'>");
        td.html(number_format(totalE, 5, ".", ""));
        trE.append(td);
        $("#tabla_equipo").append(trE);
        tablaIndirectos();
    }


    function calculaHerramientas(){
//        console.log("calc herramientas")
        var h2 = $("#i_820")  //herramientas al 2% no se usa
        var h3 = $("#i_818")  //herramientas al 3%
        var h5 = $("#i_819")  //herramientas al 5%
        var h
        var precio =0
        if(h2.html()){
            h=h2
            precio=0.02
        }
        if(h3.html()){
            h=h3
            precio=0.03

        }
        if(h5.html()){
            h=h5
            precio=0.05
        }

        if(h){
            var datos = "tipo=C"+"&ids="+ str_replace("i_","",h.attr("id"))

            var padre = h.parent()
            var rend = padre.find(".rend")
            var hora = padre.find(".col_hora")
            var total= padre.find(".col_total")
            var cant = padre.find(".cant")
            var tarifa = padre.find(".col_tarifa")
            rend.html(number_format(1, 5, ".", ""))
            cant.html(number_format($("#total_mano").find(".valor_total").html(), 5, ".", ""))
            tarifa.html(number_format(precio, 5, ".", ""))
            hora.html(number_format(parseFloat(cant.html())*parseFloat(tarifa.html()), 5, ".", ""))
            total.html(number_format(parseFloat(hora.html())*parseFloat(rend.html()), 5, ".", ""))
            totalEquipos()
        } else{
            totalEquipos()
        }
    }

    function calcularTotales(){
        var materiales = $("#tabla_material").children()
        var equipos = $("#tabla_equipo").children()
        var manos = $("#tabla_mano").children()
        var totalM= 0,totalE= 0,totalMa=0
        var trM=$("<tr id='total_material' class='total'>")
        var trMa=$("<tr id='total_mano' class='total'>")
        var trE=$("<tr id='total_equipo' class='total'>")

        var td=$("<td>")
        td.html("<b>SUBTOTAL</b>")
        trM.append(td)
        td=$("<td>")
        td.html("<b>SUBTOTAL</b>")
        trMa.append(td)
        td=$("<td>")
        td.html("<b>SUBTOTAL</b>")
        trE.append(td)
        for(i=0;i<5;i++){
            td=$("<td>")
            trM.append(td)
            td=$("<td>")
            trMa.append(td)
            td=$("<td>")
            trE.append(td)
        }

        td=$("<td>")
        trM.append(td)
        materiales.each(function(){
            var val =$(this).find(".col_total").html()
            if(val=="")
                val=0
            if(isNaN(val))
                val=0
            totalM+=parseFloat(val)
        })
        manos.each(function(){
            totalMa+=parseFloat($(this).find(".col_total").html())
        })
        td=$("<td class='valor_total' style='text-align: right;font-weight: bold'>")
        td.html(number_format(totalM, 5, ".", ""))
        trM.append(td)
        td=$("<td class='valor_total'  style='text-align: right;font-weight: bold'>")
        td.html(number_format(totalMa, 5, ".", ""))
        trMa.append(td)
        $("#tabla_material").append(trM)
        $("#tabla_mano").append(trMa)
        $("#totMat_h").val(totalMa)
        calculaHerramientas()
    }

    function tablaIndirectos(){
        var total=0
        $(".valor_total").each(function(){
            total+=$(this).html()*1
        })
        var indi = $("#costo_indi").val()
        if(isNaN(indi))
            indi=21
        indi=parseFloat(indi)
        var tabla = $('<table class="table table-bordered table-striped table-condensed table-hover">')
        tabla.append("<thead><tr><th colspan='3'>Costos indirectos</th></tr><tr><th style='width: 885px;'>Descripción</th><th style='text-align: right'>Porcentaje</th><th style='text-align: right'>Valor</th></tr></thead>")
        tabla.append("<tbody><tr><td>Costos indirectos</td><td style='text-align: right'>"+indi+"%</td><td style='text-align: right;font-weight: bold'>"+number_format(total*indi/100, 5, ".", "")+"</td></tr></tbody>")
        tabla.append("</table>")
        $("#tabla_indi").append(tabla)
        tabla = $('<table class="table table-bordered table-striped table-condensed table-hover" style="width: 360px;float: right;border: 1px solid #FFAC37">')
        tabla.append("<tbody>");
        tabla.append("<tr><td style='width: 300px;font-weight: bolder;'>Costo unitario directo</td><td style='text-align: right;font-weight: bold'>"+number_format(total, 5, ".", "")+"</td></tr>")
        tabla.append("<tr><td style='font-weight: bolder'>Costos indirectos</td><td style='text-align: right;font-weight: bold'>"+number_format(total*indi/100, 5, ".", "")+"</td></tr>")
        tabla.append("<tr><td style='font-weight: bolder'>Costos total del rubro</td><td style='text-align: right;font-weight: bold'>"+number_format(total*indi/100+total, 5, ".", "")+"</td></tr>")
        tabla.append("<tr><td style='font-weight: bolder'>Precio unitario ($USD)</td><td style='text-align: right;font-weight: bold'>"+number_format(total*indi/100+total, 5, ".", "")+"</td></tr>")
        tabla.append("</tbody>");
        $("#tabla_costos").append(tabla)
        $("#tabla_costos").show("slide")
    }

    $(function () {
        $("#detalle").click(function () {
            var child = window.open('${createLink(controller:"rubro",action:"showFoto",id: rubro?.id, params:[tipo:"dt"])}', 'Mies', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');

            if (child.opener == null)
                child.opener = self;
            window.toolbar.visible = false;
            window.menubar.visible = false;
        });
        $("#save-espc").click(function(){
            if($("#especificaciones").val().trim().length<1024){
                $.ajax({type : "POST", url : "${g.createLink(controller: 'rubroOf',action:'saveEspc')}",
                    data     : "id=${rubro?.id}&espc="+$("#especificaciones").val().trim(),
                    success  : function (msg) {
                        if(msg==="ok"){
                            $("#modal-detalle").modal("hide");
                        }else{
                            $.box({
                                imageClass : "box_info",
                                text       : "Error",
                                title      : "Alerta",
                                iconClose  : false,
                                dialog     : {
                                    resizable : false,
                                    draggable : false,
                                    buttons   : {
                                        "Aceptar" : function () {
                                        }
                                    },
                                    width     : 500
                                }
                            });
                        }
                    }
                });
            }else{
                bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-danger'></i>" + "<strong style='font-size: 14px'>" +  "Las especificaciones deben tener un máximo de 1024 caracteres" +  "</strong>");
            }
        });

        $("#foto").click(function () {
            var child = window.open('${createLink(controller:"rubro",action:"showFoto",id: rubro?.id, params:[tipo:"il"])}', 'Mies', 'width=850,height=800,toolbar=0,resizable=0,menubar=0,scrollbars=1,status=0');
            if (child.opener == null)
                child.opener = self;
            window.toolbar.visible = false;
            window.menubar.visible = false;
        });

        $("#borrar").click(function(){
            <g:if test="${rubro}">
            if(confirm("Esta Seguro?")){
                var g = cargarLoader("Borrando...");
                $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'borrarRubro')}",
                    data     : "id=${rubro?.id}",
                    success  : function (msg) {
                        g.modal("hide");
                        if(msg==="ok"){
                            location.href="${createLink(action: 'rubroPrincipal')}"
                        }else{
                            bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-danger'></i>" + "<strong style='font-size: 14px'>" +  "El rubro seleccionado no se pudo eliminar. Esta referenciado en las siguientes obras: <br>"+msg, +  "</strong>");
                        }
                    }
                });
            }
            </g:if>
        });

        <g:if test="${!rubro?.departamento?.subgrupo?.grupo?.id}">
        $("#selClase").val("");
        </g:if>

        $("#costo_indi").blur(function(){
            var indi = $(this).val();
            if(isNaN(indi) || indi*1<0){
                bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-danger'></i>" +
                    "<strong style='font-size: 14px'>" +  "El porcentaje de costos indirectos debe ser un número positvo" +
                    "</strong>");
                //$("#costo_indi").val("21")
            }
        });

        $("#excel").click(function(){
            datos="id=${rubro?.id}&indi="+$("#costo_indi").val()+"&oferente=${session.usuario.id}" + "&obra=${obra?.id}";
            location.href="${g.createLink(controller: 'reportesExcel2',action: 'imprimirRubroOferentesExcel')}?"+datos;
        });

        $("#imprimir").click(function(){
            var dsp0=$("#dist_p1").val();
            var dsp1=$("#dist_p2").val();
            var dsv0=$("#dist_v1").val();
            var dsv1=$("#dist_v2").val();
            var dsv2=$("#dist_v3").val();
            var listas = $("#lista_1").val()+","+$("#lista_2").val()+","+$("#lista_3").val()+","+$("#lista_4").val()+
                ","+$("#lista_5").val()+","+$("#ciudad").val();
            var volqueta=$("#costo_volqueta").val();
            var chofer=$("#costo_chofer").val();

            datos="dsp0="+dsp0+"&dsp1="+dsp1+"&dsv0="+dsv0+"&dsv1="+dsv1+"&dsv2="+dsv2+"&prvl="+volqueta+"&prch="+chofer+
                "&oferente=${session.usuario.id}&id=${rubro?.id}&lugar="+$("#ciudad").val()+"&listas="+listas+
                "&chof="+$("#cmb_chof").val()+"&volq="+$("#cmb_vol").val()+"&indi="+$("#costo_indi").val()+"&obra2=${obra?.id}";
            location.href = "${g.createLink(controller: 'reportes6',action: '_imprimirRubroOferentes')}?"+datos;
        });

        $("#vae").click(function () {
            var dsp0=$("#dist_p1").val();
            var dsp1=$("#dist_p2").val();
            var dsv0=$("#dist_v1").val();
            var dsv1=$("#dist_v2").val();
            var dsv2=$("#dist_v3").val();
            var listas = $("#lista_1").val()+","+$("#lista_2").val()+","+$("#lista_3").val()+","+$("#lista_4").val()+
                ","+$("#lista_5").val()+","+$("#ciudad").val();
            var volqueta=$("#costo_volqueta").val();
            var chofer=$("#costo_chofer").val();

            datos="dsp0="+dsp0+"&dsp1="+dsp1+"&dsv0="+dsv0+"&dsv1="+dsv1+"&dsv2="+dsv2+"&prvl="+volqueta+"&prch="+
                chofer+"&oferente=${session.usuario.id}&id=${rubro?.id}&lugar="+$("#ciudad").val()+"&listas="+listas+
                "&chof="+$("#cmb_chof").val()+"&volq="+$("#cmb_vol").val()+"&indi="+$("#costo_indi").val()+"&obra2=${obra?.id}";
            location.href = "${g.createLink(controller: 'reportes6',action: '_imprimirRubroOferentesVae')}?"+datos;
        });

        $("#excelVae").click(function(){
            datos="id=${rubro?.id}&indi="+$("#costo_indi").val()+"&oferente=${session.usuario.id}" + "&obra=${obra?.id}";
            location.href= "${g.createLink(controller: 'reportesExcel2',action: 'imprimirRubroOferentesExcelVae')}?"+datos
        });

        $("#transporte").click(function(){
            if ($("#fecha_precios").val().length < 8) {
                bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" +
                    "<strong style='font-size: 14px'>" +  "Seleccione una fecha para determinar la lista de precios" +  "</strong>");
                $(this).removeClass("active")
            }else{
                $("#modal-transporte").modal("show");
            }
        });

        $("#cmb_vol").change(function(){
            if($("#cmb_vol").val() !== "-1"){
                var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val() + "&ids="+$("#cmb_vol").val();
                $.ajax({type : "POST", url : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                    data     : datos,
                    success  : function (msg) {
                        var precios = msg.split("&");
                        for(i=0;i<precios.length;i++){
                            var parts = precios[i].split(";");
                            if(parts.length>1)
                                $("#costo_volqueta").val(parts[1].trim())
                        }
                    }
                });
            }else{
                $("#costo_volqueta").val("0.00")
            }
        });

        $("#cmb_chof").change(function(){
            if($("#cmb_chof").val() !== "-1"){
                var datos = "fecha=" + $("#fecha_precios").val() + "&ciudad=" + $("#ciudad").val()  + "&ids="+$("#cmb_chof").val();
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'rubro',action:'getPreciosTransporte')}",
                    data     : datos,
                    success  : function (msg) {
                        var precios = msg.split("&");
                        for(i=0;i<precios.length;i++){
                            var parts = precios[i].split(";");
                            if(parts.length>1)
                                $("#costo_chofer").val(parts[1].trim())
                        }
                    }
                });
            }else{
                $("#costo_chofer").val("0.00")
            }
        });

        $(".item_row").dblclick(function(){
            var hijos = $(this).children();
            var desc=$(hijos[1]).html();
            var cant;
            var codigo=$(hijos[0]).html();
            var unidad = $(this).data("unidad");
            var rendimiento;
            var item;

            for(i=2;i<hijos.length;i++){

                if($(hijos[i]).hasClass("cant"))
                    cant=$(hijos[i]).html();
                // if($(hijos[i]).hasClass("col_unidad"))
                //     unidad=$(hijos[i]).html();
                if($(hijos[i]).hasClass("col_rend"))
                    rendimiento=$(hijos[i]).attr("valor");
            }

            item = $(this).data("item");

            $("#item_cantidad").val(cant.toString().trim());

            if(rendimiento)
                $("#item_rendimiento").val(rendimiento.toString().trim());
            $("#item_id").val(item);
            $("#item_id").attr("tipo",$(this).attr("tipo"));
            $("#cdgo_buscar").val(codigo);
            $("#item_desc").val(desc);
            $("#item_unidad").val(unidad);
            getPrecio();
        });

        $("#selClase").change(function () {
            var clase = $(this).val();
            var $subgrupo = $("<select id='selSubgrupo' class='span12'></select>");
            $("#selSubgrupo").replaceWith($subgrupo);
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'gruposPorClase')}",
                data    : {
                    id : clase
                },
                success : function (msg) {
                    $("#selGrupo").replaceWith(msg);
                }
            });
        });

        $("#selGrupo").change(function () {
            var grupo = $(this).val();
            $.ajax({
                type    : "POST",
                url     : "${createLink(action:'subgruposPorGrupo')}",
                data    : {
                    id : grupo
                },
                success : function (msg) {
                    $("#selSubgrupo").replaceWith(msg);
                }
            });
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
                var items = $(".item_row");
                if (items.size() < 1) {
                    bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" +
                        "<strong style='font-size: 14px'>" +  "Añada items a la composición del rubro antes de calcular los precios" +
                        "</strong>");
                    $(this).removeClass("active")
                } else {
                    var tipo = "C";
                    if ($("#V").hasClass("active"))
                        tipo = "V";
                    var listas ="";
                    listas+=$("#lista_1").val()+"#"+$("#lista_2").val()+"#"+$("#lista_3").val()+"#"+$("#lista_4").val()+
                        "#"+$("#lista_5").val()+"#"+$("#ciudad").val();

                    var datos = "tipo=" + tipo+"&listas="+listas+"&ids=";
                    $.each(items, function () {
                        datos += $(this).attr("id") + "#"
                    });

                    $.ajax({
                        type : "POST",
                        url : "${g.createLink(controller: 'rubroOf',action:'getPrecios')}",
                        data     : datos,
                        success  : function (msg) {
                            var precios = msg.split("&");
                            for(i=0;i<precios.length;i++){
                                var parts = precios[i].split(";");
                                var celda =$("#i_"+parts[0]);
                                celda.html(number_format(parts[1], 5, ".", ""));
                                var padre = celda.parent();
                                var celdaRend = padre.find(".col_rend");
                                var celdaTotal = padre.find(".col_total");
                                var celdaCant = padre.find(".cant");
                                var celdaHora =  padre.find(".col_hora");
                                var rend = 1;
                                if(celdaHora.hasClass("col_hora")){
                                    celdaHora.html(number_format(parseFloat(celda.html())*parseFloat(celdaCant.html()), 5, ".", ""))
                                }
                                if (celdaRend.html()) {
                                    rend = celdaRend.attr("valor") * 1
                                }
                                celdaTotal.html(number_format(parseFloat(celda.html())*parseFloat(celdaCant.html())*parseFloat(rend), 5, ".", ""))
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
                    $(".col_vacio").show();
                }
            }
        });

        // $("#btn_copiarComp").click(function () {
        //     if ($("#rubro__id").val() * 1 > 0) {
        //         var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
        //         $("#modalTitle").html("Lista de rubros");
        //         $("#modalFooter").html("").append(btnOk);
        //         $(".contenidoBuscador").html("");
        //         $("#modal-rubro").modal("show");
        //         $("#buscarDialog").unbind("click");
        //         $("#buscarDialog").bind("click", enviarCopiar)
        //     } else {
        //         bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" + "<strong style='font-size: 14px'>" +  "Primero guarde el rubro o seleccione uno para editar" +  "</strong>");
        //     }
        // });

        $(".borrarItem").click(function () {
            var tr = $(this).parent().parent();
            var id = $(this).data("id");
            bootbox.confirm({
                title: "Eliminar Rubro",
                message: "Esta seguro de eliminar este registro? Esta acción es irreversible",
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
                        var g = cargarLoader("Borrando...");
                        $.ajax({
                            type : "POST",
                            url : "${g.createLink(controller: 'rubroOf',action:'eliminarRubroDetalle')}",
                            data:{
                                id: id
                            },
                            success  : function (msg) {
                                g.modal("hide");
                                if (msg === "Registro eliminado correctamente") {
                                    log(msg, "success");
                                    setTimeout(function () {
                                        location.reload();
                                    }, 800);
                                    // tr.remove()
                                }else{
                                    log(msg, "error");
                                }
                            }
                        });
                    }
                }
            });
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

        $("#cdgo_buscar").dblclick(function () {
            $("#busqueda").dialog("open");
            $(".ui-dialog-titlebar-close").html("x");
            return false;
        });

        $("#cdgo_buscar").blur(function(){
            if($("#item_id").val()==="" && $("#cdgo_buscar").val()!==""){
                $.ajax({
                    type : "POST",
                    url : "${g.createLink(controller: 'rubro',action:'buscarRubroCodigo')}",
                    data     : "codigo=" + $("#cdgo_buscar").val(),
                    success  : function (msg) {
                        if (msg !== "-1") {
                            var parts = msg.split("&&");
                            $("#item_tipoLista").val(parts[1]);
                            $("#item_id").val(parts[0]);
                            $("#item_desc").val(parts[2]);
                            $("#item_unidad").val(parts[3]);
                        }else{
                            $("#item_tipoLista").val("");
                            $("#item_id").val("");
                            $("#item_desc").val("");
                            $("#item_unidad").val("")
                        }
                    }
                });
            }
        });

        $("#cdgo_buscar").keydown(function(ev){
            if(ev.keyCode*1!==9 && (ev.keyCode*1<37 || ev.keyCode*1>40)){
                $("#item_tipoLista").val("");
                $("#item_id").val("");
                $("#item_desc").val("");
                $("#item_unidad").val("")
            }else{
            }
        });

        $("#btn_lista").click(function () {
            $("#listaRbro").dialog("open");
            $(".ui-dialog-titlebar-close").html("x")
        }); //click btn new

        $("#listaRbro").dialog({
            autoOpen: false,
            resizable: true,
            modal: true,
            draggable: false,
            width: 1000,
            height: 550,
            position: 'center',
            title: 'Rubros'
        });

        $("#rubro_registro").click(function () {
            if ($(this).hasClass("active")) {
                if (confirm("Esta seguro de desregistrar este rubro?")) {
                    $("#registrado").val("N")
                    $("#fechaReg").val("")
                }
            } else {
                if (confirm("Esta seguro de registrar este rubro?")) {
                    $("#registrado").val("R")
                    var fecha = new Date()
                    $("#fechaReg").val(fecha.toString("dd/mm/yyyy"))
                }
            }
        });

        $("#guardar").click(function () {

            var cod = $("#input_codigo").val();
            var desc = $("#input_descripcion").val();
            var subGr = $("#selSubgrupo").val();
            var msg ="";
            if(cod.trim().length>20 || cod.trim().length<1){
                msg="<br>Error: La propiedad código debe tener entre 1 y 20 caracteres."
            }

            if(desc.trim().length>160 || desc.trim().length<1){
                if(msg==="")
                    msg="<br>Error: La propiedad descripción debe tener entre 1 y 160 caracteres."
                else
                    msg+="<br>La propiedad descripción debe tener entre 1 y 160 caracteres."
            }

            if(msg===""){
                $(".frmRubro").submit()
            }else{
                bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" +
                    "<strong style='font-size: 14px'>" +  msg +  "</strong>");
            }
        });

        <g:if test="${rubro}">
        $("#btn_agregarItem").click(function () {
            if ($("#calcular").hasClass("active")){
                bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" +
                    "<strong style='font-size: 14px'>" +
                    "Antes de agregar items, por favor desactive la opción calcular precios en el menú superior." +  "</strong>");
                return false
            }
            agregar(${rubro?.id},"");
        });
        </g:if>
        <g:else>
        $("#btn_agregarItem").click(function () {
            bootbox.alert("<i class='fa fa-exclamation-triangle fa-3x text-warning'></i>" +
                "<strong style='font-size: 14px'>" +  "Primero guarde el rubro o seleccione uno para editar" +  "</strong>");
        });
        </g:else>

        $("#imprimirTransporteDialog").dialog({

            autoOpen: false,
            resizable: false,
            modal: true,
            dragable: false,
            width: 350,
            height: 220,
            position: 'center',
            title: 'Imprimir con o sin transporte',
            buttons: {
                "Si" : function () {
                    var dsp0=$("#dist_p1").val();
                    var dsp1=$("#dist_p2").val();
                    var dsv0=$("#dist_v1").val();
                    var dsv1=$("#dist_v2").val();
                    var dsv2=$("#dist_v3").val();
                    var listas = $("#lista_1").val()+","+$("#lista_2").val()+","+$("#lista_3").val()+","+
                        $("#lista_4").val()+","+$("#lista_5").val()+","+$("#ciudad").val();
                    var volqueta=$("#costo_volqueta").val();
                    var chofer=$("#costo_chofer").val();

                    datos="dsp0="+dsp0+"Wdsp1="+dsp1+"Wdsv0="+dsv0+"Wdsv1="+dsv1+"Wdsv2="+dsv2+"Wprvl="+volqueta+
                        "Wprch="+chofer+"Woferente=${session.usuario.id}Wid=${rubro?.id}Wlugar="+$("#ciudad").val()+
                        "Wlistas="+listas+"Wchof="+$("#cmb_chof").val()+"Wvolq="+$("#cmb_vol").val()+"Windi="+$("#costo_indi").val()
                    var url = "${g.createLink(controller: 'reportes3',action: 'imprimirRubro')}?"+datos;
                    location.href="${g.createLink(controller: 'pdf',action: 'pdfLink')}?url="+url;
                    $("#imprimirTransporteDialog").dialog("close");
                },
                "No" : function () {
                    var dsp0=$("#dist_p1").val();
                    var dsp1=$("#dist_p2").val();
                    var dsv0=$("#dist_v1").val();
                    var dsv1=$("#dist_v2").val();
                    var dsv2=$("#dist_v3").val();
                    var listas = $("#lista_1").val()+","+$("#lista_2").val()+","+$("#lista_3").val()+","+
                        $("#lista_4").val()+","+$("#lista_5").val()+","+$("#ciudad").val();
                    var volqueta=$("#costo_volqueta").val();
                    var chofer=$("#costo_chofer").val();

                    datos="dsp0="+dsp0+"Wdsp1="+dsp1+"Wdsv0="+dsv0+"Wdsv1="+dsv1+"Wdsv2="+dsv2+"Wprvl="+volqueta+
                        "Wprch="+chofer+"Wfecha="+$("#fecha_precios").val()+"Wid=${rubro?.id}Wlugar="+
                        $("#ciudad").val()+"Wlistas="+listas+"Wchof="+$("#cmb_chof").val()+"Wvolq="+
                        $("#cmb_vol").val()+"Windi="+$("#costo_indi").val()+"Wtrans=no"
                    var url = "${g.createLink(controller: 'reportes3',action: 'imprimirRubro')}?"+datos;
                    location.href="${g.createLink(controller: 'pdf',action: 'pdfLink')}?url="+url;
                    $("#imprimirTransporteDialog").dialog("close");
                }
            }
        });

        $("#modal-rubro").dialog({
            autoOpen: false,
            resizable: false,
            modal: true,
            draggable: false,
            width: 1000,
            height: 540,
            position: 'center',
            title: 'Copiar rubros'
        });

        $("#btn_copiarComp").click(function () {
            var btnOk = $('<a href="#" data-dismiss="modal" class="btn">Cerrar</a>');
            $("#modalTitle").html("Lista de rubros");
            $("#modalFooter").html("").append(btnOk);
            $(".contenidoBuscador").html("");
            $("#tipos").hide();
            $("#modal-rubro").dialog("open");
        });

        $("#cnsl-rubros-composicion").click(function () {
            buscaRubrosComposicion();
        });

        function buscaRubrosComposicion() {
            var buscarPor = $("#buscarPorComposicion").val();
            var criterio = $("#criterioComposicion").val();
            var ordenar = $("#ordenarComposicion").val();
            $.ajax({
                type: "POST",
                url: "${createLink(controller: 'rubroOf', action:'listaRubros')}",
                data: {
                    buscarPor: buscarPor,
                    criterio: criterio,
                    ordenar: ordenar,
                    rubro: '${rubro?.id}',
                    tipo: "composicion",
                    oferente: true
                },
                success: function (msg) {
                    $("#divTablaRbroComposicion").html(msg);
                }
            });
        }

        $("#criterio").keydown(function (ev) {
            if (ev.keyCode === 13) {
                busqueda();
            }
        });

    });
</script>
</body>
</html>