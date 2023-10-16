<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="es">
<head>
    <meta name="layout" content="main">
    <asset:stylesheet src="/summernote-0.8.18-dist/summernote.min.css"/>
    <asset:javascript src="/summernote-0.8.18-dist/summernote.min.js"/>



    <style type="text/css">

    .texto {
        font-family : arial;
        font-size   : 12px;
    }

    .aparecer {
        display : none;
    }

    .error {
        color       : #ff072f;
        margin-left : 140px;
    }

    </style>

    <title>Formato de Impresión</title>
</head>

<body>
<g:if test="${flash.message}">
    <div class="col-md-12" style="z-index: 1000; margin-top: 0">
        <div class="alert ${flash.clase ?: 'alert-info'}" role="status" style="margin-bottom: 0px; margin-left: -15px;">
            <a class="close" data-dismiss="alert" href="#">×</a>
            ${raw(flash.message)}
        </div>
    </div>
</g:if>

<div class="col-md-12 hide" style="margin-bottom: 10px;" id="divError">
    <div class="alert alert-error" role="status">
        <a class="close" data-dismiss="alert" href="#">×</a>
        <span id="spanError"></span>
    </div>
</div>

<div class="col-md-12 hide" style="margin-bottom: 10px;" id="divOk">
    <div class="alert alert-info" role="status">
        <a class="close" data-dismiss="alert" href="#">×</a>
        <span id="spanOk"></span>
    </div>
</div>

<div style='page-break-after: auto'></div>

<div id="tabs" style="width: 800px; height: 760px">
    <ul>
        <li><a href="#tab-presupuesto">Presupuesto</a></li>
        <li><a href="#tab-memorando">Informe</a></li>
        <li><a href="#tab-polinomica">F. Polinómica</a></li>
        <li><a href="#tab-memorandoPresu">Adm. Directa/Cogestión</a></li>
        <li><a href="#tab-textosFijos">Textos Fijos</a></li>
    </ul>

    <div id="tab-presupuesto" class="tab">

        <div class="tipoReporte">
            <fieldset class="borde">
                <div class="col-md-3">
                    <legend>Tipo de Reporte</legend>
                </div>
                <div class=" row col-md-8" style="margin-bottom: 10px;">
                    <div class="col-md-6">
                        <input type="radio" name="tipoPresupuesto" class="radioPresupuesto uno" value="1" checked/>  Base de Contrato
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="tipoPresupuesto" class="radioPresupuesto" value="2"
                               style="margin-left: -60px"/> Presupuesto Referencial
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="encabezado" class="encabezado uno" value="1" checked/>  Con encabezado
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="encabezado" class="encabezado" value="0"
                               style="margin-left: -60px"/> Sin encabezado
                    </div>
                </div>
            </fieldset>
        </div>

        <div class="piePagina" style="margin-bottom: 10px">
            <fieldset class="borde">

                <legend>Pie de Página</legend>

                <div class="col-md-12" style="margin-top: 10px">
                    <div id="div_sel">
                        <g:select name="piePaginaSel" class="form-control" from="${janus.Nota.findAllByTipoIsNull()}" value="${nota?.id}" optionValue="descripcion"
                                  optionKey="id" style="width: 300px;" noSelection="['-1': 'Seleccione una nota...']"/>
                    </div>

                    <div class="row btn-group" style="margin-left: 310px; margin-top: -40px; margin-bottom: 10px">
                        <button class="btn btn-info" id="btnNuevo"><i class="fa fa-edit"></i> Nuevo</button>
                        <button class="btn btn-warning" id="btnCancelar"><i class="fa fa-eraser"></i> Cancelar</button>
                        <button class="btn btn-success" id="btnAceptar"><i class="fa fa-save"></i> Grabar</button>
                        <button class="btn btn-danger" id="btnEliminar"><i class="fa fa-trash"></i> Eliminar</button>
                    </div>
                </div>
                <g:hiddenField name="obra" value="${obra?.id}"/>

                <div class="col-md-12" style="margin-top: 10px">
                    <div style="margin-left: -1px">Nombre de la Nota:
                    <g:textField name="descripcion" value="${nota?.descripcion}" style="width: 480px; margin-left: 1px" class="required form-control" maxlength="253"/>
                    </div>
                </div>

                <div class="col-md-12" style="margin-top: 10px">
                    Descripción de la Nota
                    <g:textArea name="texto" id="texto" class="form-control" value="${nota?.texto}" rows="5" cols="5"
                                style="height: 85px; width:685px ; resize: none" maxlength="1023"/>
                </div>

                <div class="col-md-12">
                    Nota al Pie Adicional (15 líneas aprox)
                </div>

                <div class="col-md-6">
                    <g:textArea name="adicional" class="form-control" value="${nota?.adicional}" rows="5" cols="5"
                                style="height: 85px; width:685px ; resize: none" maxlength="1023"/>
                </div>

                <g:hiddenField name="obraTipo" value="${obra?.claseObra?.tipo}"/>
            </fieldset>
        </div>

        <div class="setFirmas" style="margin-top: 1px">
            <fieldset class="borde">
                <legend>Firmas</legend>
                <div class="col-md-6" style="width: 700px; margin-top: -20px">
                    <table class="table table-bordered table-striped table-hover table-condensed " id="tablaFirmas">
                        <thead>
                        <tr>
                            <th style="width: 350px">Nombre</th>
                            <th style="width: 250px">Rol</th>
                        </tr>
                        </thead>
                        <tbody id="firmasFijasPresu">
                        <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
                            <g:if test="${duenoObra == 1}">
                                <tr>
                                    <td>
                                        <g:select name="coordinador" class="form-control" from="${personasUtfpuCoor}" optionValue="persona" optionKey="id" style="width: 380px"/>
                                    </td>
                                    <td>
                                        COORDINADOR
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:if test="${cordinadorOtros[0]}">
                                    <tr>
                                        <td style="color: #ff2a08">
                                            <g:hiddenField name="coordinador" value="${cordinadorOtros[0]?.id}"/>
                                            <g:textField name="coordinadorText" class="form-control" value="${cordinadorOtros[0]?.persona?.nombre + ' ' + cordinadorOtros[0]?.persona?.apellido}" readonly="readonly" style="width: 380px"/>
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:if>
                                <g:else>
                                    <tr>
                                        <td style="color: #ff2a08">
                                            SIN COORDINADOR
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:else>
                            </g:else>
                        </g:if>
                        <g:else>
                            <g:if test="${duo == 1}">
                                <tr>
                                    <td style="color: #ff2a08">
                                        <g:hiddenField name="coordinador" value="${personasUtfpuCoor[0]?.id}"/>
                                        <g:textField name="coordinadorText" value="${personasUtfpuCoor[0]?.persona?.nombre + ' ' + personasUtfpuCoor[0]?.persona?.apellido}" readonly="readonly" style="width: 380px"/>
                                    </td>
                                    <td>
                                        COORDINADOR
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:if test="${coordinadores}">
                                    <tr>
                                        <td style="color: #ff2a08">
                                            <g:select name="coordinador" class="form-control" from="${coordinadores}" optionValue="persona" optionKey="id" style="width: 380px"/>
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:if>
                                <g:else>
                                    <tr>
                                        <td style="color: #ff2a08">
                                            SIN COORDINADOR
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:else>

                            </g:else>
                        </g:else>
                        </tbody>

                        <tbody id="bodyFirmas_presupuesto">

                        </tbody>

                    </table>
                </div>
            </fieldset>
        </div>
    </div>

    <div id="tab-memorando" class="tab" style="">

        <div class="tipoReporteMemo">
            <fieldset class="borde">
                <div class="col-md-3">
                    <legend>Tipo de Reporte</legend>
                </div>

                <div class="col-md-6" style="margin-bottom: 10px">
                    <input type="radio" name="tipoPresupuestoMemo" class="radioPresupuestoMemo" value="1" checked/>  Base de Contrato
                </div>
            </fieldset>
        </div>

        <div class="cabecera">

            <fieldset class="borde">
                <legend>Cabecera</legend>

                <div class="col-md-12">
                    <div class="col-md-2">Informe N°</div>

                    <div class="col-md-10"><g:textField name="numeroMemo" value="${obra?.memoSalida}" disabled="true"/></div>
                </div>

                <div class="col-md-12">
                    <div class="col-md-2">DE:</div>
                    <div class="col-md-10"><g:textField name="deMemo" style="width: 470px"
                                                        value="${'COORDINACIÓN DE FIJACIÓN DE COSTOS'}" disabled="true"/></div>

                </div>

                <div class="col-md-12">
                    <div class="col-md-2">PARA:</div>

                    <div class="col-md-10">
                        <g:textField name="paraMemo" value="${obra?.departamento?.direccion?.nombre + ' - ' +
                                obra?.departamento?.descripcion}" style="width: 100%"
                                     disabled="true"/></div>
                </div>

                <div class="col-md-12">
                    <div class="col-md-2">Valor de la Base:</div>

                    <div class="col-md-10">
                        <g:textField name="baseMemo" style="width: 100px" disabled="true" value="${totalPresupuestoBien}"/>
                    </div>
                </div>
            </fieldset>
        </div>

        <div class="texto">

            <fieldset class="borde">
                <legend>Texto</legend>
                <g:hiddenField name="id" value="${"1"}"/>
                <g:hiddenField name="obra" value="${obra?.id}"/>

                <div class="col-md-12" style="margin-top: -10px;">
                    <div id="divSelMemo" class="col-md-6">
                        <g:select name="selMemo" class="form-control" from="${notaMemo}" value="${nota?.id}" optionValue="descripcion"
                                  optionKey="id" style="width: 340px;" noSelection="['-1': 'Seleccione una nota...']"/>
                    </div>

                    <div class="row col-md-5" style="margin-top: -1px">
                        <div class="btn-group" style="margin-bottom: 10px">
                            <button class="btn btn-info" id="btnNuevoMemo"><i class="fa fa-edit"></i> Nuevo</button>
                            <button class="btn btn-success" id="btnAceptarMemo"><i class="fa fa-save"></i> Grabar</button>
                            <button class="btn btn-danger" id="btnEliminarMemo"><i class="fa fa-trash"></i> Eliminar</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-12" >
                    <div style="margin-left: -1px">Nombre de la Nota: <g:textField name="descripcionMemo" class="form-control" value="${nota?.descripcion}" style="width: 480px;" maxlength="253" readonly="" />
                    </div>
                </div>

                <div class="col-md-12"  style="margin-top: 10px">
                    Texto
                    <g:textArea name="memo1" class="form-control" value="${auxiliarFijo?.memo1}" rows="4" cols="4"
                                style="width: 100%; height: 55px; resize: none;" maxlength="1023"/>
                </div>

                <div class="col-md-12"  style="margin-top: 10px">
                    Pie
                    <g:textArea name="memo2" class="form-control" value="${auxiliarFijo?.memo2}" rows="4" cols="4"
                                style="width: 100%; height: 55px; resize: none;" maxlength="1023"/>
                </div>
            </fieldset>
        </div>

        <div class="setFirmas" style="margin-top: 20px">

            <fieldset class="borde">

                <legend>Firmas</legend>
                <div class="col-md-6" style="width: 700px; margin-top: -10px">

                    <table class="table table-bordered table-striped table-hover table-condensed" id="tablaFirmasMemo">

                        <thead>
                        <tr>
                            <th style="width: 350px">Nombre</th>
                            <th style="width: 250px">Rol</th>
                        </tr>

                        </thead>

                        <tbody id="firmasFijasMemo">

                        <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
                            <g:if test="${duenoObra == 1}">
                                <tr>
                                    <td>
                                        <g:select name="coordinador" class="form-control" from="${personasUtfpuDire}" optionValue="persona" optionKey="id" style="width: 380px"/>
                                    </td>
                                    <td>
                                        DIRECTOR/COORDINADOR
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:if test="${cordinadorOtros[0]}">
                                    <tr>
                                        <td style="color: #ff2a08">
                                            <g:hiddenField name="coordinador" value="${cordinadorOtros[0]?.id}"/>
                                            <g:textField name="coordinadorText" class="form-control" value="${cordinadorOtros[0]?.persona?.nombre + ' ' + cordinadorOtros[0]?.persona?.apellido}" readonly="readonly" style="width: 380px"/>
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:if>
                                <g:else>
                                    <tr>
                                        <td style="color: #ff2a08">
                                            SIN COORDINADOR
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:else>
                            </g:else>
                        </g:if>
                        <g:else>
                            <g:if test="${duo == 1}">

                                <tr>
                                    <td style="color: #ff2a08">
                                        <g:hiddenField name="coordinador" value="${personasUtfpuCoor[0]?.id}"/>
                                        <g:textField name="coordinadorText" class="form-control" value="${personasUtfpuCoor[0]?.persona?.nombre + ' ' + personasUtfpuCoor[0]?.persona?.apellido}" readonly="readonly" style="width: 380px"/>
                                    </td>
                                    <td>
                                        COORDINADOR
                                    </td>
                                </tr>

                            </g:if>
                            <g:else>
                                <g:if test="${coordinadores}">
                                    <tr>
                                        <td style="color: #ff2a08">
                                            <g:select name="coordinador" class="form-control" from="${coordinadores}" optionValue="persona" optionKey="id" style="width: 380px"/>
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:if>
                                <g:else>
                                    <tr>
                                        <td style="color: #ff2a08">
                                            SIN COORDINADOR
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:else>

                            </g:else>
                        </g:else>

                        </tbody>

                        <tbody id="bodyFirmas_memo">

                        </tbody>

                    </table>

                </div>

            </fieldset>

        </div>

    </div>

    <div id="tab-polinomica" class="tab" style="">

        <div class="textoFormula">
            <fieldset class="borde">
                <legend>Cabecera</legend>
                <div class="col-md-12">

                    <div class="col-md-12" style="margin-top: 10px">
                        <div class="col-md-4">Fórmula Polinómica N°</div>

                        <div class="col-md-4"><g:textField name="numeroFor" value="${obra?.formulaPolinomica}" disabled="true"/></div>
                    </div>

                    <div class="col-md-12">
                        <div class="col-md-4">Fecha de Lista de Precios:</div>

                        <div class="col-md-1"><g:textField name="fechaFor"
                                                           value="${formatDate(date: obra?.fechaPreciosRubros, format: "yyyy-MM-dd")}"
                                                           style="width: 100px" disabled="true"/></div>
                    </div>

                    <div class="col-md-12">
                        <div class="col-md-4">Monto del Contrato:</div>
                        <div class="col-md-4">
                            <g:textField name="montoFor"
                                         value="${formatNumber(number: totalPresupuestoBien, format: '##,##0', maxFractionDigits: 2, minFractionDigits: 2, locale: 'ec')}"
                                         disabled="true"/>
                        </div>
                    </div>
                </div>
            </fieldset>
        </div>

        <div class="texto col-md-12">

            <fieldset class="borde">
                <legend>Nota</legend>

                <g:hiddenField name="id" value="${"1"}"/>
                <g:hiddenField name="obra" value="${obra?.id}"/>
                <div class="col-md-12" style="margin-top: 10px">
                    <div>
                        <g:select name="selFormu" from="${notaFormu}" class="form-control" value="${nota?.id}" optionValue="descripcion"
                                  optionKey="id" style="width: 300px;" noSelection="['-1': 'Seleccione una nota...']"/>
                    </div>

                    <div class="row btn-group" style="margin-left: 310px; margin-top: -40px; margin-bottom: 10px">
                        <button class="btn btn-info" id="btnNuevoFormu"><i class="fa fa-edit"></i> Nuevo</button>
                        <button class="btn btn-success" id="btnAceptarFormu"><i class="fa fa-save"></i> Grabar</button>
                        <button class="btn btn-danger" id="btnEliminarFormu"><i class="fa fa-trash"></i> Eliminar</button>
                    </div>
                </div>

                <div class="col-md-12" style="margin-top: 10px">
                    <div style="margin-left: -1px">Nombre de la Nota:
                        <g:textField name="descripcionFormu" class="form-control" value="${nota?.descripcion}"  style="width: 480px;" maxlength="253"  readonly="" /></div>
                </div>

                <div class="col-md-12" style="margin-top: 10px">
                    Descripción de la Nota
                    <g:textArea name="notaFormula" rows="4" value="${notaFormu}" cols="4" class="form-control"
                                style="width: 690px; height: 70px; resize: none" maxlength="1022"/>
                </div>
            </fieldset>

        </div>

        <div class="setFirmas" style="margin-top: -10px">
            <fieldset class="col-md-12 borde">

                <legend>Firmas</legend>

                <div class="col-md-6" style="width: 700px; margin-top: -20px">

                    <table class="table table-bordered table-striped table-hover table-condensed" id="tablaFirmasFor">
                        <thead>
                        <tr>
                            <th style="width: 350px">Nombre</th>
                            <th style="width: 250px">Rol</th>
                        </tr>
                        </thead>

                        <tbody id="firmasFijasPoli">

                        <g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
                            <g:if test="${duenoObra == 1}">
                                <tr>
                                    <td>
                                        <g:select name="coordinador" class="form-control" from="${personasUtfpuCoor}" optionValue="persona" optionKey="id" style="width: 380px"/>
                                    </td>
                                    <td>
                                        COORDINADOR
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:if test="${cordinadorOtros[0]}">
                                    <tr>
                                        <td style="color: #ff2a08">
                                            <g:hiddenField name="coordinador" value="${cordinadorOtros[0]?.id}"/>
                                            <g:textField name="coordinadorText" class="form-control" value="${cordinadorOtros[0]?.persona?.nombre + ' ' + cordinadorOtros[0]?.persona?.apellido}" readonly="readonly" style="width: 380px"/>
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:if>
                                <g:else>
                                    <tr>
                                        <td style="color: #ff2a08">
                                            SIN COORDINADOR
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:else>
                            </g:else>
                        </g:if>
                        <g:else>
                            <g:if test="${duo == 1}">
                                <tr>
                                    <td style="color: #ff2a08">
                                        <g:hiddenField name="coordinador" value="${personasUtfpuCoor[0]?.id}"/>
                                        <g:textField name="coordinadorText" class="form-control" value="${personasUtfpuCoor[0]?.persona?.nombre + ' ' + personasUtfpuCoor[0]?.persona?.apellido}" readonly="readonly" style="width: 380px"/>
                                    </td>
                                    <td>
                                        COORDINADOR
                                    </td>
                                </tr>
                            </g:if>
                            <g:else>
                                <g:if test="${coordinadores}">
                                    <tr>
                                        <td style="color: #ff2a08">
                                            <g:select name="coordinador" class="form-control" from="${coordinadores}" optionValue="persona" optionKey="id" style="width: 380px"/>
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:if>
                                <g:else>
                                    <tr>
                                        <td style="color: #ff2a08">
                                            SIN COORDINADOR
                                        </td>
                                        <td>
                                            COORDINADOR
                                        </td>
                                    </tr>
                                </g:else>
                            </g:else>
                        </g:else>
                        </tbody>

                        <tbody id="bodyFirmas_polinomica">

                        </tbody>
                    </table>
                </div>
            </fieldset>
        </div>
    </div>

    <div id="tab-textosFijos" class="tab" style="">

        <div class="col-md-12 cabecera">

            <fieldset class="borde">
                <legend>Cabecera</legend>
                <g:form class="memoGrabar" name="frm-textoFijo" controller="auxiliar" action="saveTextoFijo">
                    <g:hiddenField name="id" value="${"1"}"/>
                    <g:hiddenField name="obra" value="${obra?.id}"/>

                    <div class="col-md-12">
                        <label>Título</label>
                        <g:textField name="titulo" class="form-control" value="${auxiliarFijo?.titulo}" style="width: 560px"
                                     disabled="true"/>
                    </div>

                    <div class="col-md-12">
                        <label>Base de Contratos</label>
                        <g:textArea name="baseCont" class="form-control" value="${auxiliarFijo?.baseCont}" rows="4" cols="4"
                                    style="width: 665px; height: 40px; resize: none;" disabled="true"/>
                    </div>

                    <div class="col-md-12">
                        <label>Presupuesto Referencial</label>
                        <g:textArea name="presupuestoRef" class="form-control" value="${auxiliarFijo?.presupuestoRef}"
                                    rows="4" cols="4" style="width: 665px; height: 35px; resize: none;" disabled="true"/>
                    </div>
                </g:form>
                <div class="row btn-group" style="margin-left: 280px; margin-bottom: 10px">
                    <button class="btn btn-info" id="btnEditarTextoF"><i class="fa fa-edit"></i> Editar</button>
                    <button class="btn btn-success" id="btnAceptarTextoF"><i class="fa fa-check"></i> Aceptar</button>
                </div>
            </fieldset>

        </div>

        <div class="cabecera">
            <fieldset class="col-md-12 borde">
                <legend>Pie de Página</legend>
                <g:form class="memoGrabar" name="frm-textoFijoRet" controller="auxiliar" action="savePiePaginaTF">
                    <g:hiddenField name="id" value="${"1"}"/>
                    <g:hiddenField name="obra" value="${obra?.id}"/>

                    <div class="col-md-12">
                        NOTA (15 líneas aproximadamente)
                        <div class="col-md-12">
                            <g:textArea name="notaAuxiliar" class="form-control" value="${auxiliarFijo?.notaAuxiliar}" rows="4"
                                        cols="4" style="width: 665px; height: 260px; resize: none;" disabled="true"/></div>
                    </div>
                </g:form>

                <div class="row btn-group" style="margin-left: 280px; margin-bottom: 10px">
                    <button class="btn btn-info" id="btnEditarTextoRet"><i class="fa fa-edit"></i> Editar</button>
                    <button class="btn btn-success" id="btnAceptarTextoRet"><i class="fa fa-check"></i> Aceptar</button>
                </div>
            </fieldset>
        </div>
    </div>

    <div id="tab-memorandoPresu" class="tab" style="">

        <div class="cabecera">

            <fieldset class="borde" style="margin-top: -10px">
                <legend>Cabecera</legend>

                <div class="col-md-12" style="margin-top: -10px">
                    <div class="col-md-2">PARA:</div>

                    <div class="col-md-9">
                        <g:select name="paraMemoPresu" from="${janus.Direccion.list()}" optionKey="id"
                                  optionValue="nombre" style="width: 485px"/>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="col-md-2">DE:</div>
                    <div class="col-md-9">
                        <g:textField name="deMemoPresu" style="width: 470px"
                                     value="${persona?.departamento?.descripcion}" disabled="true"/>
                    </div>

                </div>

                <div class="col-md-12">
                    <div class="col-md-2">FECHA:</div>
                    <div class="col-md-9">
                        <g:textField name="fechaMemoPresu" style="width: 200px"
                                     value="${new java.util.Date().format("dd-MM-yyyy")}" disabled="true"/>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="col-md-2">ASUNTO:</div>
                    <div class="col-md-9">
                        <g:textField name="asuntoMemoPresu" style="width: 470px" value="" maxlength="100"/></div>
                </div>

            </fieldset>

        </div>

        <div class="texto">

            <fieldset class="borde">
                <legend>Texto</legend>
                <div class="col-md-12">
                    <div class="col-md-8" style="margin-top: -10px; margin-left: -40px">
                        <g:form class="memoGrabarPresu" name="frm-memoPresu" controller="auxiliar" action="saveMemoPresu">
                            <g:hiddenField name="id" value="${"1"}"/>
                            <g:hiddenField name="obra" value="${obra?.id}"/>

                            <div class="col-md-1">Texto</div>

                            <div class="col-md-7" style="margin-left: 10px">
                                <g:textArea name="notaMemoAd" class="form-control" value="${auxiliarFijo?.notaMemoAd}" rows="4" cols="4"
                                            style="width: 500px; height: 55px; resize: none;" disabled="true"/>
                            </div>
                        </g:form>
                    </div>

                    <div class="col-md-4">
                        <div class="row btn-group" style="margin-left: 90px; margin-top: -5px; width: 170px">
                            <button class="btn btn-info" id="btnEditarMemoPresu"><i class="fa fa-edit"></i> Editar</button>
                            <button class="btn btn-success" id="btnAceptarMemoPresu"><i class="fa fa-check"></i> Aceptar</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="col-md-8" style="margin-top: 10px; margin-left: -40px">
                        <g:form class="memoGrabarAdjunto" name="frm-memoAdj" controller="auxiliar" action="saveMemoAdj">
                            <g:hiddenField name="id" value="${"1"}"/>
                            <g:hiddenField name="obra" value="${obra?.id}"/>

                            <div class="col-md-1">Adjunto</div>

                            <div class="col-md-7" style="margin-left: 10px">
                                <g:textArea name="notaPieAd" class="form-control" value="${auxiliarFijo?.notaPieAd}" rows="4" cols="4"
                                            style="width: 500px; height: 55px; resize: none;" disabled="true"/>
                            </div>

                        </g:form>
                    </div>
                    <div class="col-md-4">
                        <div class="raw btn-group" style="margin-left: 90px; margin-top: 15px; width: 170px">
                            <button class="btn btn-info" id="btnEditarAdjunto"><i class="fa fa-edit"></i> Editar</button>
                            <button class="btn btn-success" id="btnAceptarAdjunto"><i class="fa fa-check"></i> Aceptar</button>

                        </div>
                    </div>
                </div>
            </fieldset>
        </div>

        <div class="valores">
            <fieldset class="borde">
                <legend>Valores</legend>

                <div class="col-md-12">
                    <div class="col-md-8">Presupuesto Referencial por Contrato:</div>
                    <div class="col-md-3">
                        <g:textField name="baseMemoPresu" style="width: 100px" disabled="true"
                                     value="${formatNumber(number: totalPresupuestoBien, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'ec')}"/>
                    </div>

                    <div class="col-md-8">Materiales:</div>
                    <g:set var="totalMaterial" value="${0}"/>
                    <g:each in="${resComp}" var="r">
                        <g:set var="totalMaterial" value="${totalMaterial + ((r.transporte + r.precio) * r.cantidad)}"/>
                    </g:each>
                    <div class="col-md-3">
                        <g:hiddenField name="tMaterial" value="${totalMaterial}"/>
                        <g:textField name="materialesMemo" style="width: 100px"
                                     value="${formatNumber(number: totalMaterial, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'ec')}"
                                     readonly="true"/>
                    </div>

                    <div class="col-md-8">Mano de Obra:</div>
                    <g:set var="totalMano" value="${0}"/>
                    <g:each in="${resMano}" var="r">
                        <g:set var="totalMano" value="${totalMano + ((r.transporte + r.precio) * r.cantidad)}"/>
                    </g:each>
                    <div class="col-md-3">
                        <g:hiddenField name="tMano" value="${totalMano}"/>
                        <g:textField name="manoObraMemo" style="width: 100px"
                                     value="${formatNumber(number: totalMano, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'ec')}"
                                     readonly="true"/>
                    </div>

                    <div class="col-md-8">Equipos:</div>
                    <g:set var="totalEquipo" value="${0}"/>
                    <g:each in="${resEq}" var="r">
                        <g:set var="totalEquipo" value="${totalEquipo + ((r.transporte + r.precio) * r.cantidad)}"/>
                    </g:each>
                    <div class="col-md-3">
                        <g:hiddenField name="tEquipo" value="${totalEquipo}"/>
                        <g:textField name="equiposMemo" style="width: 100px" value="${formatNumber(number: totalEquipo, format: '##,##0', minFractionDigits: 2, maxFractionDigits: 2, locale: 'ec')}" readonly="true"/>
                    </div>

                    <div class="col-md-8">Costos Indirectos:</div>

                    <div class="col-md-3" style="margin-left: -78px; width: 240px">
                        <input id="costoPorcentaje" name="costoPorcentaje" type="number" style="width: 60px" maxlength="3" max="25" min="0" step="0.1"/>
                        <span class="add-on">%</span>
                        <g:textField name="costoMemo" style="width: 100px" disabled="true"/>
                    </div>

                    <div class="col-md-8">Timbres y costos financieros (para materiales):</div>

                    <div class="col-md-3" style="margin-left: -68px; width: 240px" >
                        <input id="pcntFinanciero" name="pcntFinanciero" type="number" style="width: 50px" maxlength="3" max="5" min="0" step="0.1"/>
                        <span class="add-on">%</span>
                        <g:textField name="costoFinanciero" style="width: 100px" disabled="true"/>
                    </div>

                    <div class="col-md-8">TOTAL:</div>
                    <div class="col-md-2" style="margin-left: 0px"><g:textField name="totalMemoPresu" style="width: 100px" disabled="true"/></div>
                </div>
            </fieldset>
        </div>


        <div class="setFirmas" style="margin-top: -10px">

            <fieldset class="borde">

                <legend>Firmas</legend>
                <div class="col-md-6" style="width: 700px; margin-top: -20px">

                    <table class="table table-bordered table-striped table-hover table-condensed" id="tablaFirmasMemoPresu">

                        <thead>
                        <tr>
                            <th style="width: 350px">Nombre</th>
                            <th style="width: 250px">Rol</th>
                        </tr>

                        </thead>

                        <tbody id="firmasFijasMemoPresu">
                        <g:if test="${firmaDirector != null}">
                            <tr data-id="${firmaDirector?.persona?.id}">
                                <td id="${firmaDirector?.persona?.nombre + " " + firmaDirector?.persona?.apellido}">
                                    ${firmaDirector?.persona?.nombre + " " + firmaDirector?.persona?.apellido}
                                </td>
                                <td>
                                    DIRECTOR
                                </td>
                            </tr>
                        </g:if>
                        <g:else>
                            <tr>
                                <td style="color: #ff2a08">
                                    DIRECCIÓN SIN DIRECTOR
                                </td>
                                <td>
                                    DIRECTOR
                                </td>
                            </tr>
                        </g:else>
                        <tr data-id="${obra?.revisor?.id}">
                            <td id=" ${obra?.revisor?.nombre + " " + obra?.revisor?.apellido + " " + "       (REVISOR)"}">
                                ${obra?.revisor?.nombre + " " + obra?.revisor?.apellido}
                            </td>
                            <td>
                                SUPERVISIÓN
                            </td>

                        </tr>
                        <tr data-id="${obra?.responsableObra?.id}">

                            <td id=" ${obra?.responsableObra?.nombre + " " + obra?.responsableObra?.apellido + " " + " (ELABORO)"}">
                                ${obra?.responsableObra?.nombre + " " + obra?.responsableObra?.apellido}
                            </td>
                            <td>
                                ELABORÓ
                            </td>
                        </tr>
                        </tbody>

                        <tbody id="bodyFirmas_memoPresu">

                        </tbody>
                    </table>
                </div>
            </fieldset>
        </div>
    </div>

    <div class="btn-group" style="margin-bottom: 10px; margin-top: 0px; margin-left: 180px; text-align: center">
        <button class="btn btn-primary" id="btnSalir"><i class="fa fa-arrow-left"></i> Regresar</button>
        <button class="btn btn-info" id="btnImprimir"><i class="fa fa-print"></i> Imprimir</button>
        <button class="btn btn-info" id="btnImprimirDscr"><i class="fa fa-print"></i> con descripción</button>
        <button class="btn btn-info" id="btnImprimirVae"><i class="fa fa-print"></i> Imprimir VAE</button>
        <button class="btn aparecer btn-success" id="btnDocExcel"><i class="fa fa-file-excel"></i> Excel</button>
    </div>

    <div id="tipoReporteDialog">
        <fieldset>
            <div class="col-md-3">
                Debe elegir un Tipo de Reporte antes de imprimir el documento!!
            </div>
        </fieldset>
    </div>

    <div id="reajustePresupuestoDialog" class="texto">

        <fieldset>
            <div class="col-md-3" style="margin-top: 10px">

                Incluir Iva <g:checkBox name="reajusteIva" style="margin-left: 132px"/>

            </div>

            <div class="col-md-3" style="margin-top: 10px">
                Incluir Proyección del reajuste <g:checkBox name="proyeccionReajuste" style="margin-left: 20px"/>

            </div>

            <div class="col-md-3" style="margin-top: 10px">

                Meses: <g:textField name="mesesReajuste" style="width: 55px; margin-left: 20px"/>
            </div>

        </fieldset>
    </div>


    %{--    <div id="maxFirmasDialog">--}%

    %{--        <fieldset>--}%
    %{--            <div class="col-md-3">--}%

    %{--                A ingresado el número máximo de firmas para este documento.--}%

    %{--            </div>--}%
    %{--        </fieldset>--}%
    %{--    </div>--}%


    <div id="mesesCeroDialog">

        <fieldset>
            <div class="col-md-3">
                <br>
                Es necesario colocar un número válido en el campo <b>Meses</b> !!
            </div>
        </fieldset>
    </div>


    <div id="cambioMonedaExcel">

        <fieldset>
            <div class="col-md-3" style="margin-bottom: 20px">

                Coloque la tasa de cambio que se aplicará a los valores del reporte en excel.

            </div>

            <div class="col-md-3">

                Tasa de Cambio: <g:textField name="cambioMoneda" style="width: 55px; margin-left: 20px"/>

            </div>

        </fieldset>
    </div>


    <div id="tasaCeroDialog">

        <fieldset>
            <div class="col-md-3">

                Si desea que su reporte sea calculado con una tasa de cambio se debe colocar un número válido en el campo Tasa!!

            </div>
        </fieldset>
    </div>


    %{--    <div id="borrarFirmaPresuDialog">--}%
    %{--        <fieldset>--}%
    %{--            <div class="col-md-3">--}%
    %{--                Está seguro que desea remover esta firma del documento a ser impreso?--}%
    %{--            </div>--}%
    %{--        </fieldset>--}%
    %{--    </div>--}%


    %{--    <div class="modal hide fade" id="modal-borrarFirma">--}%
    %{--        <div class="modal-header">--}%
    %{--            <button type="button" class="close" data-dismiss="modal">×</button>--}%

    %{--            <div id="modalTitle"></div>--}%
    %{--        </div>--}%

    %{--        <div class="modal-body" id="modalBody">--}%
    %{--        </div>--}%

    %{--        <div class="modal-footer" id="modalFooter">--}%
    %{--        </div>--}%
    %{--    </div>--}%


    <div id="reajusteMemoDialog" class="texto">

        <fieldset>
            <div class="col-md-12" style="margin-top: 10px">

                Incluir Iva <g:checkBox name="reajusteIvaMemo" style="margin-left: 132px"/>

            </div>

            <div class="col-md-12" style="margin-top: 10px">
                Incluir Proyección del reajuste <g:checkBox name="proyeccionReajusteMemo" style="margin-left: 20px"/>

            </div>

            <div class="col-md-12" style="margin-top: 10px">

                Meses: <g:textField name="mesesReajusteMemo" style="width: 55px; margin-left: 20px"/>
            </div>

        </fieldset>
    </div>

</div>

<script type="text/javascript">

    // $(document).ready(function() {
    //     $('#texto').summernote({
    //         spellCheck: true,
    //         disableGrammar: true
    //     });
    // });

    var tipoClick;
    var tipoClickMemo = $(".radioPresupuestoMemo").attr("value");
    var tg = 0;
    var forzarValue;
    var notaValue;
    var notaMemoValue;
    var firmasId = [];
    var firmasIdMP = [];
    var firmasIdMemo = [];
    var firmasIdFormu = [];
    var firmasFijas = [];
    var firmasFijasMP = [];
    var firmasFijasMemo = [];
    var firmasFijasFormu = [];
    var firmasIdMemoPresu = [];
    var totalPres = $("#baseMemo").val();
    var reajusteMemo = 0;
    var proyeccion;
    var reajusteIva;
    var reajusteMeses;
    var tasaCambio;
    var idObraMoneda;
    var proyeccionMemo;
    var reajusteIvaMemo;
    var reajusteMesesMemo;
    var paraMemo1;
    var firmaCoordinador;
    var firmaElaboro;

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

    function validarNumDec(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39 || ev.keyCode === 190 || ev.keyCode === 110);
    }

    $("#mesesReajuste").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {

        var enteros = $(this).val();

        if (parseFloat(enteros) > 100) {
            $(this).val(100)
        }
        if (parseFloat(enteros) <= 0) {
            $(this).val(1)
        }
    });

    $("#mesesReajusteMemo").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {

        var enteros = $(this).val();

        if (parseFloat(enteros) > 100) {
            $(this).val(100)
        }
        if (parseFloat(enteros) <= 0) {
            $(this).val(1)
        }
    });

    $("#cambioMoneda").keydown(function (ev) {

        var val = $(this).val();
        var dec = 2;

        if (ev.keyCode === 110 || ev.keyCode === 190) {

            if (!dec) {
                return false;
            } else {
                if (val.length === 0) {
                    $(this).val("0");
                }
                if (val.indexOf(".") > -1) {
                    return false;
                }
            }
        } else {
            if (val.indexOf(".") > -1) {
                if (dec) {
                    var parts = val.split(".");
                    var l = parts[1].length;
                    if (l >= dec) {
                        return false;
                    }
                }
            } else {
                return validarNumDec(ev);
            }
        }

        return validarNumDec(ev);

    }).keyup(function () {
        var enteros = $(this).val();

        if (parseFloat(enteros) > 10000) {
            $(this).val(1)
        }
        if (parseFloat(enteros) <= 0) {
            $(this).val(1)
        }
    });

    $("#porcentajeMemo").keydown(function (ev) {
        return validarNum(ev);
    }).keyup(function () {
        var enteros = $(this).val();
        if (parseFloat(enteros) > 100) {
            $(this).val(100)
        }
    });

    function loadNota() {
        var idPie = $("#piePaginaSel").val();
        $.ajax({
            type     : "POST",
            dataType : 'json',
            url      : "${g.createLink(action:'getDatos')}",
            data     : {id : idPie},
            success  : function (msg) {
                $("#descripcion").val(msg.descripcion);
                $("#texto").val(msg.texto);
                $("#adicional").val(msg.adicional);
            }
        });
    }

    loadNota();

    function loadNotaMemo() {
        var idPie = $("#selMemo").val();
        $.ajax({
            type     : 'POST',
            dataType : 'json',
            url      : "${g.createLink(action: 'getDatosMemo')}",
            data     : {id : idPie},
            success  : function (msg) {
                $("#descripcionMemo").val(msg.descripcion);
                $("#memo1").val(msg.texto);
                $("#memo2").val(msg.adicional);
            }
        })
    }

    loadNotaMemo();

    function loadNotaFormu() {
        var idPie = $("#selFormu").val();
        $.ajax({
            type     : 'POST',
            dataType : 'json',
            url      : "${g.createLink(action: 'getDatosFormu')}",
            data     : {id : idPie},
            success  : function (msg) {
                $("#descripcionFormu").val(msg.descripcion);
                $("#notaFormula").val(msg.texto);
            }
        })
    }

    loadNotaFormu();

    $("#tabs").tabs();

    $("#btnSalir").click(function () {
        location.href = "${g.createLink(controller: 'obra', action: 'registroObra')}" + "?obra=" + "${obra?.id}";
    });

    $("#btnEditarMemo").click(function () {
        $("#memo1").attr("disabled", false);
        $("#memo2").attr("disabled", false)
    });

    $("#btnEditarMemoPresu").click(function () {
        $("#notaMemoAd").attr("disabled", false);
    });

    $("#btnEditarAdjunto").click(function () {
        $("#notaPieAd").attr("disabled", false);
    });

    $(".radioPresupuestoMemo").click(function () {

        tipoClickMemo = $(this).attr("value");

        if (tipoClickMemo === '1') {
            $("#reajusteMemo").attr("disabled", true);
            $("#porcentajeMemo").attr("disabled", false);
            $("#btnCalBase").attr("disabled", false)
        }
        if (tipoClickMemo === '2') {
            $("#reajusteMemo").attr("disabled", true);
            $("#reajusteMemo").val(" ");
            $("#porcentajeMemo").attr("disabled", true);
            $("#porcentajeMemo").val(" ");
            $("#btnCalBase").attr("disabled", true)
        }

        return tipoClickMemo
    });

    $("#btnCalBase").click(function () {
        var porcentajeCal = $("#porcentajeMemo").val();
        var totalPres = $("#baseMemo").val();
        var base = (porcentajeCal * (totalPres)) / 100;
        $("#reajusteMemo").val(number_format(base, 2, ".", ""))
    });

    var active2 = $("#tabs").tabs("option", "event");

    $("#tabs").click(function () {

        var active = $("#tabs").tabs("option", "active");

        if(active === 0){
            $("#btnImprimirVae").show();
            $("#btnImprimirDscr").show()
        }else{
            $("#btnImprimirDscr").hide();
            $("#btnImprimirVae").hide()
        }

        if (active !== 2) {
            $("#btnDocExcel").hide();
        }
        else {
            $("#btnDocExcel").show();
        }

        if (active === 4) {
            $("#btnImprimir").hide()
        }
        else {
            $("#btnImprimir").show()
        }
    });

    $("#btnImprimir").click(function () {
        if (!$(this).hasClass("disabled")) {
            reajusteMemo = $("#reajusteMemo").val();

            var active = $("#tabs").tabs("option", "active");
            if (active === 0) {

                var idCoordinador = $("#coordinador").val();
                var idFirmaCoor

                if (idCoordinador != null) {
                    idFirmaCoor = $("#coordinador").val()
                } else {
                    idFirmaCoor = ''
                }

                firmasId = '';
                firmasFijas = '';
                firmaCoordinador = idFirmaCoor;
                firmaElaboro = ${obra?.responsableObra?.id}

                    $("#firmasFijasPresu").children("tr").each(function (i) {
                        if ($(this).data("id")) {
                            if (firmasFijas !== '') {
                                firmasFijas += ','
                            } else {
                                firmasFijas += '-1,'
                            }
                            firmasFijas += $(this).data("id")
                        }
                    });

                notaValue = $("#piePaginaSel").val();

                if ($("#forzar").attr("checked") === "checked") {
                    forzarValue = 1;
                } else {
                    forzarValue = 2;
                }
                if (1 !== 1) {
                    $("#tipoReporteDialog").dialog("open");
                } else {
                    proyeccion = $("#proyeccionReajuste").is(':checked');
                    reajusteIva = $("#reajusteIva").is(':checked');
                    reajusteMeses = $("#mesesReajuste").val();

                    var tipoReporte

                    if ($(".uno").is(':checked')) {
                        tipoReporte = 1
                    } else {
                        tipoReporte = 2
                    }

                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'nota', action: 'saveNota')}",
                        data    : {
                            piePaginaSel : $("#piePaginaSel").val(),
                            obra         : ${obra?.id},
                            descripcion  : $("#descripcion").val(),
                            texto        : $("#texto").val(),
                            adicional    : $("#adicional").val(),
                            obraTipo     : "${obra?.claseObra?.tipo}"
                        },
                        success : function (msg) {
                            var part = msg.split('_');
                            if (part[0] === 'ok') {
                                location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteDocumentosObra',id: obra?.id)}?tipoReporte=" + tipoReporte +
                                    "&forzarValue=" + forzarValue + "&notaValue=" + part[1] + "&firmasId=" + firmasId +
                                    "&proyeccion=" + proyeccion + "&iva=" + reajusteIva + "&meses=" + reajusteMeses +
                                    "&firmasFijas=" + firmasFijas + "&firmaCoordinador=" + firmaCoordinador +
                                    "&firmaElaboro=" + firmaElaboro + "&encabezado=" + $(".encabezado:checked").val();
                            }
                        }
                    });
                }
            }

            if (active === 1) {

                var idCoordinador = $("#coordinador").val();
                var idFirmaCoor

                if (idCoordinador != null) {
                    idFirmaCoor = $("#coordinador").val()
                } else {
                    idFirmaCoor = ''
                }

                firmaCoordinador = idFirmaCoor;
                firmasIdMemo = [];
                firmasFijasMemo = [];
                notaMemoValue = $("#selMemo").val();

                var paraMemo = $("#paraMemo").val();
                var textoMemo = $("#memo1").val();
                var pieMemo = $("#memo2").val();

                $("#bodyFirmas_memo").children("tr").each(function (i) {
                    firmasIdMemo[i] = $(this).data("id")
                });

                $("#firmasFijasMemo").children("tr").each(function (i) {
                    firmasFijasMemo[i] = $(this).data("id")
                });

                if (firmasIdMemo.length === 0) {
                    firmasIdMemo = "";
                }
                if (firmasFijasMemo.length === 0) {
                    firmasFijasMemo = "";
                }

                if (tipoClickMemo === '1') {
                    $("#reajusteMemoDialog").dialog("open")
                }else {
                    var tipoReporte = tipoClickMemo;

                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'nota', action: 'saveNotaMemo')}",
                        data    : {
                            piePaginaSel : $("#selMemo").val(),
                            obra         : ${obra?.id},
                            descripcion  : $("#descripcionMemo").val(),
                            texto        : $("#memo2").val(),
                            adicional    : $("#memo1").val(),
                            obraTipo     : "${obra?.claseObra?.tipo}"
                        },
                        success : function (msg) {
                            var part = msg.split('_');
                            if (part[0] === 'ok') {
                                location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteDocumentosObraMemo',id: obra?.id)}?tipoReporte=" + tipoReporte +
                                    "&firmasIdMemo=" + firmasIdMemo  + "&totalPresupuesto=" + totalPres + "&proyeccionMemo=" + proyeccionMemo +
                                    "&reajusteIvaMemo=" + reajusteIvaMemo + "&reajusteMesesMemo=" + reajusteMesesMemo +
                                    "&para=" + paraMemo + "&firmasFijasMemo=" + firmasFijasMemo + "&texto=" + textoMemo + "&pie=" + pieMemo +
                                    "&notaValue=" + part[1] + "&firmaCoordinador=" + firmaCoordinador+"&firmaNueva="+$("#tab-memorando").find("#coordinador").val()
                            }
                        }
                    });
                }
            }

            if (active === 2) {     /* fórmula polinómica */

                firmasIdFormu = [];
                firmasFijasFormu = [];

                var idCoordinador = $("#coordinador").val();
                var idFirmaCoor

                if (idCoordinador != null) {
                    idFirmaCoor = $("#coordinador").val()
                } else {
                    idFirmaCoor = ''
                }

                firmaCoordinador = idFirmaCoor;

                $("#bodyFirmas_polinomica").children("tr").each(function (i) {
                    firmasIdFormu[i] = $(this).data("id")
                });

                $("#firmasFijasPoli").children("tr").each(function (i) {
                    firmasFijasFormu[i] = $(this).data("id")
                });

                if (firmasIdFormu.length === 0) {
                    firmasIdFormu = "";
                }
                if (firmasFijasFormu.length === 0) {
                    firmasFijasFormu = "";
                }

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'nota', action: 'saveNotaFormu')}",
                    data    : {
                        selFormu    : $("#selFormu").val(),
                        obra        : ${obra?.id},
                        descripcion : $("#descripcionFormu").val(),
                        texto       : $("#notaFormula").val(),
                        obraTipo    : "${obra?.claseObra?.tipo}"
                    },
                    success : function (msg) {
                        var part = msg.split('_');
                        if (part[0] === 'ok') {
                            location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteDocumentosObraFormu',id: obra?.id)}?firmasIdFormu=" + firmasIdFormu + "&totalPresupuesto=" + totalPres + "&firmasFijasFormu=" + firmasFijasFormu
                                + "&notaFormula=" + $("#notaFormula").val() + "&notaValue=" + part[1] + "&firmaElaboro=" + ${obra?.responsableObra?.id} +"&firmaCoordinador=" + firmaCoordinador
                        }
                    }
                });
            }

            if (active === 3) {   /* administracion directa */

                var materiales = $("#materialesMemo").val();
                var manoObra = $("#manoObraMemo").val();
                var equipos = $("#equiposMemo").val();
                var costoPorcentaje = $("#costoPorcentaje").val();
                var costo = $("#costoMemo").val();
                var total = $("#totalMemoPresu").val();
                var texto = $("#notaMemoAd").val();
                var para = $("#paraMemoPresu").val();
                var de = $("#deMemoPresu").val();
                var fecha = $("#fechaMemoPresu").val();
                var asunto = $("#asuntoMemoPresu").val();
                var financiero = $("#pcntFinanciero").val();

                firmasIdMP = [];
                firmasFijasMP = [];

                $("#bodyFirmas_memoPresu").children("tr").each(function (i) {
                    firmasIdMP[i] = $(this).data("id")
                });

                $("#firmasFijasMemoPresu").children("tr").each(function (i) {
                    firmasFijasMP[i] = $(this).data("id")
                });

                location.href = "${g.createLink(controller: 'reportes' ,action: 'reportedocumentosObraMemoAdmi',id: obra?.id)}?firmasIdMP=" +
                    firmasIdMP + "&totalPresupuesto=" + totalPres + "&firmasFijasMP=" + firmasFijasMP + "&materiales=" + materiales +
                    "&manoObra=" + manoObra + "&equipos=" + equipos + "&costoPorcentaje=" + costoPorcentaje + "&costo=" + costo + "&total=" + total +
                    "&texto=" + texto + "&para=" + para + "&de=" + de + "&fecha=" + fecha + "&asunto=" + asunto + "&financiero=" + financiero
            }
        }
        return false;
    });

    $("#btnImprimirDscr").click(function () {
        if (!$(this).hasClass("disabled")) {
            reajusteMemo = $("#reajusteMemo").val();
            var active = $("#tabs").tabs("option", "active");
            if (active === 0) {
                var idCoordinador = $("#coordinador").val();
                var idFirmaCoor;
                if (idCoordinador != null) {
                    idFirmaCoor = $("#coordinador").val()
                } else {
                    idFirmaCoor = ''
                }

                firmasId = '';
                firmasFijas = '';
                firmaCoordinador = idFirmaCoor;
                firmaElaboro = ${obra?.responsableObra?.id}

                    $("#firmasFijasPresu").children("tr").each(function (i) {
                        if ($(this).data("id")) {
                            if (firmasFijas !== '') {
                                firmasFijas += ','
                            } else {
                                firmasFijas += '-1,'
                            }
                            firmasFijas += $(this).data("id")
                        }
                    });

                notaValue = $("#piePaginaSel").val();

                if ($("#forzar").attr("checked") === "checked") {
                    forzarValue = 1;
                } else {
                    forzarValue = 2;
                }
                if (1 !== 1) {
                    $("#tipoReporteDialog").dialog("open");
                } else {
                    proyeccion = $("#proyeccionReajuste").is(':checked');
                    reajusteIva = $("#reajusteIva").is(':checked');
                    reajusteMeses = $("#mesesReajuste").val();

                    var tipoReporte;

                    if ($(".uno").is(':checked')) {
                        tipoReporte = 1
                    } else {
                        tipoReporte = 2
                    }

                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'nota', action: 'saveNota')}",
                        data    : {
                            piePaginaSel : $("#piePaginaSel").val(),
                            obra         : ${obra?.id},
                            descripcion  : $("#descripcion").val(),
                            texto        : $("#texto").val(),
                            adicional    : $("#adicional").val(),
                            obraTipo     : "${obra?.claseObra?.tipo}"
                        },
                        success : function (msg) {
                            var part = msg.split('_');
                            if (part[0] === 'ok') {
                                location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteDocumentosObraDscr',id: obra?.id)}?tipoReporte=" + tipoReporte +
                                    "&forzarValue=" + forzarValue + "&notaValue=" + part[1] + "&firmasId=" + firmasId +
                                    "&proyeccion=" + proyeccion + "&iva=" + reajusteIva + "&meses=" + reajusteMeses +
                                    "&firmasFijas=" + firmasFijas + "&firmaCoordinador=" + firmaCoordinador +
                                    "&firmaElaboro=" + firmaElaboro + "&encabezado=" + $(".encabezado:checked").val();
                            }
                        }
                    });
                }
            }
        }
        return false;
    });


    $("#btnImprimirVae").click(function () {
        if (!$(this).hasClass("disabled")) {
            reajusteMemo = $("#reajusteMemo").val();
            var active = $("#tabs").tabs("option", "active");
            if (active === 0) {

                var idCoordinador = $("#coordinador").val();
                var idFirmaCoor;
                if (idCoordinador != null) {
                    idFirmaCoor = $("#coordinador").val()
                } else {
                    idFirmaCoor = ''
                }

                firmasId = '';
                firmasFijas = '';
                firmaCoordinador = idFirmaCoor;
                firmaElaboro = ${obra?.responsableObra?.id}

                    $("#firmasFijasPresu").children("tr").each(function (i) {
                        if ($(this).data("id")) {
                            if (firmasFijas !== '') {
                                firmasFijas += ','
                            } else {
                                firmasFijas += '-1,'
                            }
                            firmasFijas += $(this).data("id")
                        }

                    });

                notaValue = $("#piePaginaSel").val();

                if ($("#forzar").attr("checked") === "checked") {
                    forzarValue = 1;
                } else {
                    forzarValue = 2;
                }
                if (1 !== 1) {
                    $("#tipoReporteDialog").dialog("open");
                } else {
                    proyeccion = $("#proyeccionReajuste").is(':checked');
                    reajusteIva = $("#reajusteIva").is(':checked');
                    reajusteMeses = $("#mesesReajuste").val();

                    var tipoReporte;

                    if ($(".uno").is(':checked')) {
                        tipoReporte = 1
                    } else {
                        tipoReporte = 2
                    }

                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'nota', action: 'saveNota')}",
                        data    : {
                            piePaginaSel : $("#piePaginaSel").val(),
                            obra         : ${obra?.id},
                            descripcion  : $("#descripcion").val(),
                            texto        : $("#texto").val(),
                            adicional    : $("#adicional").val(),
                            obraTipo     : "${obra?.claseObra?.tipo}"
                        },
                        success : function (msg) {
                            var part = msg.split('_');
                            if (part[0] === 'ok') {
                                location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteDocumentosObraVae',id: obra?.id)}?tipoReporte=" + tipoReporte +
                                    "&forzarValue=" + forzarValue + "&notaValue=" + part[1] + "&firmasId=" + firmasId +
                                    "&proyeccion=" + proyeccion + "&iva=" + reajusteIva + "&meses=" + reajusteMeses +
                                    "&firmasFijas=" + firmasFijas + "&firmaCoordinador=" + firmaCoordinador +
                                    "&firmaElaboro=" + firmaElaboro + "&encabezado=" + $(".encabezado:checked").val();

                            }
                        }
                    });
                }
            }
        }
        return false;
    });

    $("#btnDocExcel").click(function () {

        if (!$(this).hasClass("disabled")) {
            reajusteMemo = $("#reajusteMemo").val();
            var active = $("#tabs").tabs("option", "active");
            var notaPoli = $("#selFormu").val();

            if (active === 2) {
                firmasIdFormu = [];
                firmasFijasFormu = [];

                $("#bodyFirmas_polinomica").children("tr").each(function (i) {
                    firmasIdFormu[i] = $(this).data("id")
                });

                $("#firmasFijasPoli").children("tr").each(function (i) {
                    firmasFijasFormu[i] = $(this).data("id")
                });

                if (firmasIdFormu.length === 0) {
                    firmasIdFormu = "";
                }
                if (firmasFijasFormu.length === 0) {
                    firmasFijasFormu = "";
                }

                var idCoordinador = $("#coordinador").val();

                if (idCoordinador != null) {
                    idFirmaCoor = $("#coordinador").val()
                } else {
                    idFirmaCoor = ''
                }

                firmaCoordinador = idFirmaCoor;

                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'nota', action: 'saveNotaFormu')}",
                    data    : {
                        selFormu    : $("#selFormu").val(),
                        obra        : ${obra?.id},
                        descripcion : $("#descripcionFormu").val(),
                        texto       : $("#notaFormula").val(),
                        obraTipo    : "${obra?.claseObra?.tipo}"
                    },
                    success : function (msg) {
                        var part = msg.split('_');
                        if (part[0] === 'ok') {
                            location.href = "${g.createLink(controller: 'reportes5' ,action: 'reporteFormulaExcel',id: obra?.id)}?firmasIdFormu=" + firmasIdFormu + "&totalPresupuesto=" + totalPres + "&firmasFijasFormu="
                                + firmasFijasFormu + "&notaPoli=" + part[1] +  "&notaFormula=" + $("#notaFormula").val() +"&firmaCoordinador=" + firmaCoordinador
                        }
                    }
                });
            }
        }
    });

    $("#btnExcel").click(function () {
        $("#cambioMonedaExcel").dialog("open")
    });

    $("#btnEditarFor").click(function () {
        $("#notaFormula").attr("disabled", false);
    });

    $("#btnAceptarMemoPresu").click(function () {
        $("#frm-memoPresu").submit();
    });

    $("#btnAceptarAdjunto").click(function () {
        $("#frm-memoAdj").submit();
    });

    $("#btnEditarTextoF").click(function () {
        $("#presupuestoRef").attr("disabled", false);
        $("#baseCont").attr("disabled", false);
        $("#general").attr("disabled", false);
        $("#titulo").attr("disabled", false);
    });

    $("#btnAceptarTextoF").click(function () {
        $("#frm-textoFijo").submit();
    });

    $("#btnEditarTextoRet").click(function () {
        $("#retencion").attr("disabled", false);
        $("#notaAuxiliar").attr("disabled", false);
    });

    $("#btnAceptarTextoRet").click(function () {
        $("#frm-textoFijoRet").submit();
    });

    $("#piePaginaSel").change(function () {
        loadNota();
    });

    $("#selMemo").change(function () {
        loadNotaMemo();
    });

    $("#selFormu").change(function () {
        loadNotaFormu();
    });

    $(".btnQuitar").click(function () {
        var strid = $(this).attr("id");
        var parts = strid.split("_");
        var tipo = parts[1];
    });

    $("#btnAceptar").click(function () {
        if($("#descripcion").val() !== ''){
            if($("#texto").val() !== ''){
                var d = cargarLoader("Guardando...");
                $.ajax({
                    type    : "POST",
                    url     : "${createLink(controller: 'nota', action: 'guardarNotaPresupuesto')}",
                    data    : {
                        piePaginaSel : $("#piePaginaSel").val(),
                        obra         : ${obra?.id},
                        descripcion  : $("#descripcion").val(),
                        texto        : $("#texto").val(),
                        adicional    : $("#adicional").val(),
                        obraTipo     : "${obra?.claseObra?.tipo}"
                    },
                    success : function (msg) {
                        d.modal("hide")
                        var parts = msg.split("_");
                        if (parts[0] === 'ok') {
                            log(parts[1], "success");
                            setTimeout(function () {
                                location.reload()
                            }, 800);
                        } else {
                            log(parts[1],"error");
                        }
                    }
                });
            }else{
                bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese la descripción de la nota" + '</strong>');
            }
        }else{
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese el nombre de la nota" + '</strong>');
        }
    });

    $("#btnAceptarMemo").click(function () {
        if($("#memo1").val() !== ''){
            var d = cargarLoader("Guardando...");
            $.ajax({
                type    : 'POST',
                url     : '${createLink(controller: 'nota', action: 'saveNotaMemo')}',
                data    : {
                    obra        : ${obra?.id},
                    texto       : $("#memo1").val(),
                    pie         : $("#memo2").val(),
                    obraTipo    : "${obra?.claseObra?.tipo}",
                    selMemo     : $("#selMemo").val(),
                    descripcion : $("#descripcionMemo").val()
                },
                success : function (msg) {
                    d.modal("hide");
                    var parts = msg.split("_");
                    if (parts[0] === 'ok') {
                        log(parts[1], "success");
                        setTimeout(function () {
                            location.reload()
                        }, 800);
                    } else {
                        log(parts[1],"error");
                    }
                }
            });
        }else{
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese la descripción de la nota" + '</strong>');
        }
    });

    $("#btnAceptarFormu").click(function () {
        if($("#notaFormula").val() !== ''){
            var d = cargarLoader("Guardando...");
            $.ajax({
                type    : 'POST',
                url     : '${createLink(controller: 'nota', action: 'saveNotaFormu')}',
                data    : {
                    obra        : ${obra?.id},
                    texto       : $("#notaFormula").val(),
                    obraTipo    : "${obra?.claseObra?.tipo}",
                    selFormu    : $("#selFormu").val(),
                    descripcion : $("#descripcionFormu").val()
                },
                success : function (msg) {
                    d.modal("hide");
                    var parts = msg.split("_");
                    if (parts[0] === 'ok') {
                        log(parts[1], "success");
                        setTimeout(function () {
                            location.reload()
                        }, 800);
                    } else {
                        log(parts[1],"error");
                    }
                }
            });
        }else{
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Ingrese la descripción de la nota" + '</strong>');
        }
    });

    $("#btnNuevo").click(function () {
        $("#piePaginaSel").val('-1');
        $("#notaAdicional").attr("checked", true);
        $("#descripcion").val("");
        $("#texto").val("");
        $("#adicional").val("");
    });

    $("#btnNuevoMemo").click(function () {
        $("#memo1").val("");
        $("#memo2").val("");
        $("#descripcionMemo").val("");
        $("#selMemo").val('-1')
    });

    $("#btnNuevoFormu").click(function () {
        $("#notaFormula").val("");
        $("#descripcionFormu").val("");
        $("#selFormu").val('-1');
    });

    $("#btnCancelar").click(function () {
        loadNota();
    });

    function desbloquear() {
        $("#piePaginaSel").attr("disabled", false);
        $("#descripcion").attr("disabled", false);
        $("#texto").attr("disabled", false);
        $("#notaAdicional").attr("disabled", false)
    }

    $("#borrarFirmaPresuDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 180,
        position  : 'center',
        title     : 'Eliminar firma',
        buttons   : {
            "Aceptar"  : function () {
                $("#borrarFirmaPresu").parents("tr").remove();
                $("#borrarFirmaPresuDialog").dialog("close");
            },
            "Cancelar" : function () {
                $("#borrarFirmaPresuDialog").dialog("close");
            }
        }
    });

    $("#tipoReporteDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 180,
        position  : 'center',
        title     : 'Seleccione un Tipo de Reporte',
        buttons   : {
            "Aceptar" : function () {
                $("#tipoReporteDialog").dialog("close");
            }
        }
    });

    $("#cambioMonedaExcel").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 250,
        position  : 'center',
        title     : 'Tasa de cambio',
        buttons   : {
            "Aceptar"    : function () {
                tasaCambio = $("#cambioMoneda").val();
                if (tasaCambio === "") {
                    $("#tasaCeroDialog").dialog("open");
                } else {
                    location.href = "${g.createLink(controller: 'reportes',action: 'documentosObraTasaExcel',id: obra?.id)}?tasa=" + tasaCambio
                }
                $("#cambioMonedaExcel").dialog("close");
            },
            "Sin cambio" : function () {
                location.href = "${g.createLink(controller: 'reportes',action: 'documentosObraExcel',id: obra?.id)}";
                $("#cambioMonedaExcel").dialog("close");
            },
            "Cancelar"   : function () {
                $("#cambioMonedaExcel").dialog("close");
            }
        }
    });

    $("#reajustePresupuestoDialog").dialog({

        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 230,
        position  : 'center',
        title     : 'Reajuste del Presupuesto',
        buttons   : {
            "Aceptar"  : function () {

                proyeccion = $("#proyeccionReajuste").is(':checked');
                reajusteIva = $("#reajusteIva").is(':checked');
                reajusteMeses = $("#mesesReajuste").val();

                if (proyeccion === true && reajusteMeses === "") {
                    $("#mesesCeroDialog").dialog("open")
                }
                else {
                    var tipoReporte = tipoClick;
                    location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteDocumentosObra',id: obra?.id)}?tipoReporte=" + tipoReporte + "&forzarValue=" + forzarValue + "&notaValue=" + notaValue
                        + "&firmasId=" + firmasId + "&proyeccion=" + proyeccion + "&iva=" + reajusteIva + "&meses=" + reajusteMeses + "&firmasFijas=" + firmasFijas + "&firmaCoordinador=" + firmaCoordinador
                    $("#reajustePresupuestoDialog").dialog("close");
                }
            },
            "Cancelar" : function () {
                $("#reajustePresupuestoDialog").dialog("close");
            }
        }
    });

    $("#reajusteMemoDialog").dialog({

        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 230,
        position  : 'center',
        title     : 'Reajuste Memorando',
        buttons   : {
            "Aceptar"  : function () {
                proyeccionMemo = $("#proyeccionReajusteMemo").is(':checked');
                reajusteIvaMemo = $("#reajusteIvaMemo").is(':checked');
                reajusteMesesMemo = $("#mesesReajusteMemo").val();
                paraMemo1 = $("#paraMemo").val();

                var idCoordinador = $("#coordinador").val();
                var idFirmaCoor;

                if (idCoordinador != null) {
                    idFirmaCoor = $("#coordinador").val()
                } else {
                    idFirmaCoor = ''
                }

                firmaCoordinador = idFirmaCoor;

                if (proyeccionMemo === true && reajusteMesesMemo === "") {
                    $("#mesesCeroDialog").dialog("open")
                } else {
                    var tipoReporte = tipoClickMemo;
                    $.ajax({
                        type    : "POST",
                        url     : "${createLink(controller: 'nota', action: 'saveNotaMemo')}",
                        data    : {
                            piePaginaSel : $("#selMemo").val(),
                            obra         : ${obra?.id},
                            descripcion  : $("#descripcionMemo").val(),
                            texto        : $("#memo1").val(),
                            pie          : $("#memo2").val(),
                            obraTipo     : "${obra?.claseObra?.tipo}"
                        },
                        success : function (msg) {
                            var part = msg.split('_');
                            if (part[0] === 'ok') {
                                location.href = "${g.createLink(controller: 'reportes' ,action: 'reporteDocumentosObraMemo',id: obra?.id)}?tipoReporte=" + tipoReporte + "&firmasIdMemo=" + firmasIdMemo
                                    + "&totalPresupuesto=" + totalPres + "&proyeccionMemo=" + proyeccionMemo +
                                    "&reajusteIvaMemo=" + reajusteIvaMemo + "&reajusteMesesMemo=" + reajusteMesesMemo + "&para=" + paraMemo1 +
                                    "&firmasFijasMemo=" + firmasFijasMemo + "&texto=" + $("#memo1").val() + "&pie=" + $("#memo2").val() + "&notaValue=" + part[1] +
                                    "&firmaCoordinador=" + firmaCoordinador+"&firmaNueva="+$("#tab-memorando").find("#coordinador").val()
                            }
                        }
                    });
                    $("#reajusteMemoDialog").dialog("close");
                }
            },
            "Cancelar" : function () {
                $("#reajusteMemoDialog").dialog("close");
            }
        }
    });

    // $("#maxFirmasDialog").dialog({
    //     autoOpen  : false,
    //     resizable : false,
    //     modal     : true,
    //     draggable : false,
    //     width     : 350,
    //     height    : 200,
    //     position  : 'center',
    //     title     : 'Máximo Número de Firmas',
    //     buttons   : {
    //         "Aceptar" : function () {
    //             $("#maxFirmasDialog").dialog("close");
    //         }
    //     }
    // });

    $("#mesesCeroDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 200,
        position  : 'center',
        title     : 'No existe un valor en el campo Meses',
        buttons   : {
            "Aceptar" : function () {
                $("#mesesCeroDialog").dialog("close");
            }
        }
    });

    $("#tasaCeroDialog").dialog({
        autoOpen  : false,
        resizable : false,
        modal     : true,
        draggable : false,
        width     : 350,
        height    : 200,
        position  : 'center',
        title     : 'No existe una tasa de cambio!',
        buttons   : {
            "Aceptar" : function () {
                $("#tasaCeroDialog").dialog("close");
            }
        }
    });

    $("#btnEliminar").click(function () {
        var idNota = $("#piePaginaSel").val();
        if (idNota === "-1") {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione una nota" + '</strong>');
        } else {
            var d = cargarLoader("Borrando...");
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'nota' ,action: 'delete')}",
                data    : {
                    id   : idNota,
                    obra : ${obra?.id}
                },
                success : function (msg) {
                    d.modal("hide");
                    var parts = msg.split("_");
                    if (parts[0] === "ok") {
                        log(parts[1],"success");
                        setTimeout(function () {
                            location.reload()
                        }, 800);
                    } else {
                        log(parts[1],"error");
                    }
                }
            })
        }
    });

    $("#btnEliminarMemo").click(function () {
        var idNota = $("#selMemo").val();
        if (idNota === "-1") {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione una nota" + '</strong>');
        } else {
            var d = cargarLoader("Borrando...");
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'nota' ,action: 'delete')}",
                data    : {
                    id   : idNota,
                    obra : ${obra?.id}
                },
                success : function (msg) {
                    d.modal("hide");
                    var parts = msg.split("_");
                    if (parts[0] === "ok") {
                        log(parts[1],"success");
                        setTimeout(function () {
                            location.reload()
                        }, 800);
                    } else {
                        log(parts[1],"error");
                    }
                }
            })
        }
    });

    $("#btnEliminarFormu").click(function () {
        var idNota = $("#selFormu").val();
        if (idNota === "-1") {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Seleccione una nota" + '</strong>');
        } else {
            var d = cargarLoader("Borrando...");
            $.ajax({
                type    : "POST",
                url     : "${createLink(controller:'nota' ,action: 'delete')}",
                data    : {
                    id   : idNota,
                    obra : ${obra?.id}
                },
                success : function (msg) {
                    d.modal("hide");
                    var parts = msg.split("_");
                    if (parts[0] === "ok") {
                        log(parts[1],"success");
                        setTimeout(function () {
                            location.reload()
                        }, 800);
                    } else {
                        log(parts[1],"error");
                    }
                }
            })
        }
    });

    $(function () {

        $("#materialesMemo").click(function () {
            sumaTotal();
        });

        $("#manoObraMemo").click(function () {
            sumaTotal();
        });

        $("#equiposMemo").click(function () {
            sumaTotal();
        });

        $(".uno").prop("checked", true);

        $("#equiposMemo,#manoObraMemo,#materialesMemo").keydown(function (ev) {
            return validarNum(ev);
        }).keyup(function () {
            calculoPorcentaje();
            sumaTotal()
        });

        $("#costoPorcentaje").change(function () {
            calculoPorcentaje();
            sumaTotal();
        });

        $("#pcntFinanciero").change(function() {
            calculoPorcentaje();
            sumaTotal();
        });

        $(document).ready(function(){
            $("#costoPorcentaje").val(0);
            $("#pcntFinanciero").val(0);
            calculoPorcentaje();
            sumaTotal();
        });

        function calculoPorcentaje() {
            var porcentaje = 0;
            var financiero = 0;
            porcentaje = ((parseFloat($("#tMaterial").val()) + parseFloat($("#tMano").val()) + parseFloat($("#tEquipo").val())) * ($("#costoPorcentaje").val())) / 100;
            financiero = (parseFloat($("#tMaterial").val()) * ($("#pcntFinanciero").val())) / 100;

            $("#costoMemo").val(number_format(porcentaje, 2, ".", ""));
            $("#costoFinanciero").val(number_format(financiero, 2, ".", ""));
        }

        function sumaTotal() {
            var total = 0.0;
            total = parseFloat($("#tMaterial").val()) + parseFloat($("#tMano").val()) +
                parseFloat($("#tEquipo").val()) + parseFloat($("#costoMemo").val()) +
                parseFloat($("#costoFinanciero").val());

            $("#totalMemoPresu").val(number_format(total, 2, ".", ""))
        }
    });
</script>
</body>
</html>