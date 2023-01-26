<%@ page import="janus.Item" %>

<div class="" style="border: solid; border: 1px">
    <fieldset class="borde">
        <legend>${itemInstance.nombre}</legend>

        <g:if test="${itemInstance?.departamento}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Subgrupo
                </div>
                <div class="col-md-6">
                    ${itemInstance?.departamento?.descripcion}
                </div>
            </div>
        </g:if>

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
        <g:if test="${itemInstance?.unidad}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Unidad
                </div>
                <div class="col-md-6">
                    ${itemInstance?.unidad}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance.departamento.subgrupo.grupo.id.toString() == '1'}">
            <div class="row">
                <div class="col-md-3 text-info">
                    ${(itemInstance?.tipoLista?.codigo[0] == 'P') ? 'Peso' : 'Volumen'}
                </div>
                <div class="col-md-6">
                    <g:formatNumber number="${itemInstance.peso}" maxFractionDigits="6" minFractionDigits="6" format='##,######0' locale='ec'/>
                    ${itemInstance?.tipoLista?.unidad}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.estado}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Unidad
                </div>
                <div class="col-md-6">
                    ${itemInstance.estado == 'A' ? 'ACTIVO' : itemInstance.estado == 'B' ? 'DADO DE BAJA' : ''}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.fecha}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Fecha de creación
                </div>
                <div class="col-md-6">
                    <g:formatDate date="${itemInstance?.fecha}" format="dd-MM-yyyy"/>
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.fechaModificacion}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Fecha de modificación
                </div>
                <div class="col-md-6">
                    <g:formatDate date="${itemInstance?.fechaModificacion}" format="dd-MM-yyyy"/>
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.codigoComprasPublicas}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Código CPC
                </div>
                <div class="col-md-6">
                    ${itemInstance?.codigoComprasPublicas?.numero}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.transportePeso}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Transporte Peso
                </div>
                <div class="col-md-6">
                    ${itemInstance?.transportePeso}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.transporteVolumen}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Transporte Volumen
                </div>
                <div class="col-md-6">
                    ${itemInstance?.transporteVolumen}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.padre}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Padre
                </div>
                <div class="col-md-6">
                    ${itemInstance?.padre}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.inec}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Inec
                </div>
                <div class="col-md-6">
                    ${itemInstance?.inec}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.rendimiento}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Rendimiento
                </div>
                <div class="col-md-6">
                    ${itemInstance?.rendimiento}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.tipo}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Tipo
                </div>
                <div class="col-md-6">
                    ${itemInstance?.tipo}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.registro}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Registro
                </div>
                <div class="col-md-6">
                    ${itemInstance?.registro}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.transporte}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Transporte
                </div>
                <div class="col-md-6">
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
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.combustible}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Combustible
                </div>
                <div class="col-md-6">
                    ${itemInstance.combustible == 'S' ? 'SI' : itemInstance.combustible == 'N' ? 'NO' : ''}
                </div>
            </div>
        </g:if>
        <g:if test="${itemInstance?.observaciones}">
            <div class="row">
                <div class="col-md-3 text-info">
                    Observaciones
                </div>
                <div class="col-md-8">
                    ${itemInstance.observaciones}
                </div>
            </div>
        </g:if>
    </fieldset>
</div>