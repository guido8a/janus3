<%@ page import="janus.Item" %>



    <div class="" style="border: solid; border: 1px">
        <fieldset class="borde">
            <legend>${itemInstance.nombre}</legend>

            <g:if test="${itemInstance?.codigo}">
                <div class="row">
                    <div class="col-md-3 text-info">
                        Código
                    </div>
                    <div class="col-md-6">
                        ${itemInstance?.codigo}
                    </div>
                </div>
            </g:if>
        </fieldset>
    </div>

<form class="form-horizontal">


    <g:if test="${itemInstance?.unidad}">
        <div class="control-group">
            <div>
                <span id="unidad-label" class="control-label label label-inverse">
                    Unidad
                </span>
            </div>

            <div class="controls">
                <span aria-labelledby="unidad-label">
                    ${itemInstance?.unidad?.codigo}
                </span>
            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance.departamento.subgrupo.grupo.id.toString() == '1'}">
        <div class="control-group">
            <div>
                <span id="peso-label" class="control-label label label-inverse">
                    ${(itemInstance?.tipoLista?.codigo[0] == 'P') ? 'Peso' : 'Volumen'}
                </span>
            </div>

            <div class="controls">
                <span aria-labelledby="peso-label">
                    <g:formatNumber number="${itemInstance.peso}" maxFractionDigits="6" minFractionDigits="6" format='##,######0' locale='ec'/>
                    ${itemInstance?.tipoLista?.unidad}
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.departamento}">
        <div class="control-group">
            <div>
                <span id="departamento-label" class="control-label label label-inverse">
                    Subgrupo
                </span>
            </div>

            <div class="controls">
                <span aria-labelledby="departamento-label">
                    ${itemInstance?.departamento?.descripcion}
                </span>
            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.estado}">
        <div class="control-group">
            <div>
                <span id="estado-label" class="control-label label label-inverse">
                    Estado
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="estado-label">
                    ${itemInstance.estado == 'A' ? 'ACTIVO' : itemInstance.estado == 'B' ? 'DADO DE BAJA' : ''}
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.fecha}">
        <div class="control-group">
            <div>
                <span id="fecha-label" class="control-label label label-inverse">
                    Fecha creación
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="fecha-label">
                    <g:formatDate date="${itemInstance?.fecha}" format="dd-MM-yyyy"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.fechaModificacion}">
        <div class="control-group">
            <div>
                <span class="control-label label label-inverse">
                    Fecha última modificación
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="fecha-label">
                    <g:formatDate date="${itemInstance?.fechaModificacion}" format="dd-MM-yyyy"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.fechaModificacion}">
        <div class="control-group">
            <div>
                <span id="fechaModificacion-label" class="control-label label label-inverse">
                    Código CPC
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="fecha-label">
                    ${itemInstance?.codigoComprasPublicas?.numero}
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.transportePeso}">
        <div class="control-group">
            <div>
                <span id="transportePeso-label" class="control-label label label-inverse">
                    Transporte Peso
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="transportePeso-label">
                    <g:fieldValue bean="${itemInstance}" field="transportePeso"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.transporteVolumen}">
        <div class="control-group">
            <div>
                <span id="transporteVolumen-label" class="control-label label label-inverse">
                    Transporte Volumen
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="transporteVolumen-label">
                    <g:fieldValue bean="${itemInstance}" field="transporteVolumen"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.padre}">
        <div class="control-group">
            <div>
                <span id="padre-label" class="control-label label label-inverse">
                    Padre
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="padre-label">
                    <g:fieldValue bean="${itemInstance}" field="padre"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.inec}">
        <div class="control-group">
            <div>
                <span id="inec-label" class="control-label label label-inverse">
                    Inec
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="inec-label">
                    <g:fieldValue bean="${itemInstance}" field="inec"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.rendimiento}">
        <div class="control-group">
            <div>
                <span id="rendimiento-label" class="control-label label label-inverse">
                    Rendimiento
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="rendimiento-label">
                    <g:fieldValue bean="${itemInstance}" field="rendimiento"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.tipo}">
        <div class="control-group">
            <div>
                <span id="tipo-label" class="control-label label label-inverse">
                    Tipo
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="tipo-label">
                    <g:fieldValue bean="${itemInstance}" field="tipo"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.registro}">
        <div class="control-group">
            <div>
                <span id="registro-label" class="control-label label label-inverse">
                    Registro
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="registro-label">
                    <g:fieldValue bean="${itemInstance}" field="registro"/>
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.transporte}">
        <div class="control-group">
            <div>
                <span id="transporte-label" class="control-label label label-inverse">
                    Transporte
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="transporte-label">
                    ${(itemInstance.transporte == 'P') ? 'PESO' : itemInstance.transporte == 'V' ? 'VOLUMEN' : ''}
                    <g:if test="${itemInstance.transporte == 'P'}">
                        Peso (capital de cantón)
                    </g:if>
                    <g:elseif test="${itemInstance.transporte == 'P1'}">
                        Peso (especial)
                    </g:elseif>
                    <g:elseif test="${itemInstance.transporte == 'V'}">
                        Volumen (materiales pétreos para hormigones)
                    </g:elseif>
                    <g:elseif test="${itemInstance.transporte == 'V1'}">
                        Volumen (materiales pétreos para mejoramiento)
                    </g:elseif>
                    <g:elseif test="${itemInstance.transporte == 'V2'}">
                        Volumen (materiales pétreos para carpeta asfáltica)
                    </g:elseif>

                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.combustible}">
        <div class="control-group">
            <div>
                <span id="combustible-label" class="control-label label label-inverse">
                    Combustible
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="combustible-label">
                    ${itemInstance.combustible == 'S' ? 'SI' : itemInstance.combustible == 'N' ? 'NO' : ''}
                </span>

            </div>
        </div>
    </g:if>

    <g:if test="${itemInstance?.observaciones}">
        <div class="control-group">
            <div>
                <span id="observaciones-label" class="control-label label label-inverse">
                    Observaciones
                </span>
            </div>

            <div class="controls">

                <span aria-labelledby="observaciones-label">
                    <g:fieldValue bean="${itemInstance}" field="observaciones"/>
                </span>

            </div>
        </div>
    </g:if>

</form>