
<g:if test="${persona?.departamento?.codigo == 'UTFPU'}">
    <g:if test="${obra?.id == null}">
        <div class="col-md-1">Resp. de las Cantidades</div>

        <div class="col-md-3"><g:select name="inspector.id" class="inspector required" from="${personasRolInsp}"
            optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + " " + it.apellido }}"
            value="${obra?.inspector?.id}" title="Persona para Inspección de la Obra"/></div>

        <div class="col-md-1">Responsable Técnico1</div>

        <div class="col-md-3">
            <g:select name="revisor.id" class="revisor required" from="${personasRolRevi}" optionKey="id"
                      optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + ' ' + it.apellido }}"
                      value="${obra?.revisor?.id}" title="Persona para la revisión de la Obra"/></div>

        <div class="col-md-1" style="margin-left: -10px">Elaboró presupuesto</div>

        <g:if test="${personasUtfpu}">
            <div class="col-md-3"><g:select name="responsableObra.id" class="responsable required" from="${personasUtfpu}"
                 optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it?.nombre + ' ' + it?.apellido }}"
                 value="${obra?.responsableObra?.id}" title="Persona responsable de la Obra"/></div>

        </g:if>
        <g:else>
            <div class="col-md-3">
                <g:select name="responsableObra.id" class="responsable required" from="" optionKey="id"
                          title="No existen personas responsable de la Obra asignadas!"/>
            </div>
        </g:else>


    </g:if>
    <g:else>

        <g:if test="${duenoObra == 1}">
            <div class="col-md-1">Resp. de las Cantidades</div>

            <div class="col-md-3">
                <g:select name="inspector.id" class="inspector required" from="${personasRolInsp}"
                optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + " " + it.apellido }}"
                value="${obra?.inspector?.id}" title="Persona para Inspección de la Obra"
                style="width: 250px"/></div>


            <div class="col-md-1">Responsable Técnico</div>

            <div class="col-md-3">
                <g:select name="revisor.id" class="revisor required" from="${personasRolRevi}"
                 optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + ' ' + it.apellido }}"
                 value="${obra?.revisor?.id}" title="Persona para la revisión de la Obra"
                 style="width: 250px"/></div>

            <div class="col-md-1" style="margin-left: -10px">Elaboró presupuesto</div>

            <g:if test="${personasUtfpu}">
                <div class="col-md-3">
                    <g:select name="responsableObra.id" class="responsable required" from="${personasUtfpu}"
                        optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it?.nombre + ' ' + it?.apellido }}"
                        value="${obra?.responsableObra?.id}" title="Persona responsable de la Obra"
                        style="width: 250px"/></div>
            </g:if>
            <g:else>
                <div class="col-md-3">
                    <g:select name="responsableObra.id" class="responsable required" from="" optionKey="id"
                        title="No existen personas responsable de la Obra asignadas!"/>
                </div>
            </g:else>


        </g:if>
        <g:else>

            <div class="col-md-1">Resp. de las Cantidades</div>

            <g:hiddenField name="inspector.id" id="hiddenInspector" value="${obra?.inspector?.id}"/>
            <div class="col-md-3"><g:textField name="inspector" class="inspector required" value="${obra?.inspector?.nombre + " " + obra?.inspector?.apellido}" readonly="readonly" title="Persona para Inspección de la Obra"/></div>

            <div class="col-md-1" style="margin-left: -30px">Responsable Técnico</div>

            <g:hiddenField name="revisor.id" id="hiddenRevisor" value="${obra?.revisor?.id}"/>
            <div class="col-md-3"><g:textField name="revisorText" class="revisor required" value="${obra?.revisor?.nombre + " " + obra?.revisor?.apellido}" readonly="readonly" title="Persona para la revisión de la Obra"/></div>

            <div class="col-md-1">Elaboró Presupuesto</div>


        <g:if test="${personasUtfpu}">
            <g:hiddenField name="responsableObra.id" id="hiddenResponsable" value="${obra?.responsableObra?.id}"/>
            <div class="col-md-3"><g:textField name="responsableText" class="responsable required"
                 value="${ (obra?.responsableObra?.titulo ?: '')+ ' ' + obra?.responsableObra?.nombre + " " +
                         obra?.responsableObra?.apellido}" readonly="readonly" title="Persona responsable de la Obra"/></div>
        </g:if>
        <g:else>
                <div class="col-md-3"><g:select name="responsableObra.id" class="responsable required" from="" optionKey="id" title="No existen personas responsable de la Obra asignadas!"/></div>
         </g:else>
        </g:else>

    </g:else>

</g:if>
<g:else>
    <g:if test="${obra?.id == null}">


        <g:if test="${persona?.departamento?.id == obra?.inspector?.departamento?.id || obra?.id == null}">
            <div class="col-md-1">Resp. de las Cantidades4</div>
            <div class="col-md-3"><g:select name="inspector.id" class="inspector required" from="${personasRolInsp}" optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + " " + it.apellido }}" value="${obra?.inspector?.id}" title="Persona para Inspección de la Obra"/></div>
        </g:if>
        <g:else>
            <div class="col-md-1">Resp. de las Cantidades</div>
            <g:hiddenField name="inspector.id" id="hiddenInspector" value="${obra?.inspector?.id}"/>
            <div class="col-md-3"><g:select name="inspector.id" class="inspector required" from="${personasRolInsp}" optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + " " + it.apellido }}" value="${obra?.inspector?.id}" title="Persona para Inspección de la Obra"/></div>
        </g:else>

        <g:if test="${persona?.departamento?.id == obra?.revisor?.departamento?.id || obra?.id == null}">
            <div class="col-md-1">Responsable Técnico</div>
            <div class="col-md-3"><g:select name="revisor.id" class="revisor required" from="${personasRolRevi}" optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + ' ' + it.apellido }}"
                                         value="${obra?.revisor?.id}" title="Persona para la revisión de la Obra"/></div>
        </g:if>
        <g:else>
            <div class="col-md-1" style="margin-left: -30px">Responsable Técnico</div>
            <g:hiddenField name="revisor.id" id="hiddenRevisor" value="${obra?.revisor?.id}"/>
            <div class="col-md-3"><g:select name="revisor.id" class="revisor required" from="${personasRolRevi}" optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + ' ' + it.apellido }}"
                                         value="${obra?.revisor?.id}" title="Persona para la revisión de la Obra"/></div>
        </g:else>



        <div class="col-md-1" style="margin-left: -10px">Elaboró presupuesto</div>
        %{--<div class="col-md-3"><g:select name="responsableObra.id" class="responsable required" from="${personasRolResp}" optionKey="id" optionValue="${{it?.nombre + ' ' + it?.apellido }}" value="${obra?.responsableObra?.id}" title="Persona responsable de la Obra"/></div>--}%
        <div class="col-md-3"><g:select name="responsableObra.id" class="responsable required" from="${personasRolElab}" optionKey="id" optionValue="${{(it?.titulo ?: '') + '' +it?.nombre + ' ' + it?.apellido }}" value="${obra?.responsableObra?.id}" title="Persona responsable de la Obra"/></div>


    </g:if>
    <g:else>

        <g:if test="${persona?.departamento?.direccion?.id == obra?.departamento?.direccion?.id && duenoObra != 1}">

            <div class="col-md-1">Resp. de las Cantidades5</div>
            <div class="col-md-3"><g:select name="inspector.id" class="inspector required" from="${personasRolInsp}" optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + " " + it.apellido }}" value="${obra?.inspector?.id}" title="Persona para Inspección de la Obra"/></div>


            <div class="col-md-1" style="margin-left: -30px">Responsable Técnico</div>
            <div class="col-md-3"><g:select name="revisor.id" class="revisor required" from="${personasRolRevi}" optionKey="id" optionValue="${{ (it?.titulo ?: '') + ' ' + it.nombre + ' ' + it.apellido }}"
                                         value="${obra?.revisor?.id}" title="Persona para la revisión de la Obra"/></div>

            <div class="col-md-1" style="margin-left: -10px">Elaboró presupuesto</div>
        %{--<div class="col-md-3"><g:select name="responsableObra.id" class="responsable required" from="${personasRolResp}" optionKey="id" optionValue="${{it?.nombre + ' ' + it?.apellido }}" value="${obra?.responsableObra?.id}" title="Persona responsable de la Obra"/></div>--}%
            <div class="col-md-3"><g:select name="responsableObra.id" class="responsable required" from="${personasRolElab}" optionKey="id" optionValue="${{(it?.titulo ?: '') + '' + it?.nombre + ' ' + it?.apellido }}" value="${obra?.responsableObra?.id}" title="Persona responsable de la Obra"/></div>


        </g:if>
        <g:else>


            <div class="col-md-1">Resp. de las Cantidades(6)</div>

            <g:hiddenField name="inspector.id" id="hiddenInspector" value="${obra?.inspector?.id}"/>
            <div class="col-md-3"><g:textField name="inspector" class="inspector required" value="${obra?.inspector?.nombre +
                    " " + obra?.inspector?.apellido}" readonly="readonly" title="Persona Resp. de las Cantidades de la Obra"
                    style="width: 220px" /></div>

            <div class="col-md-1" style="margin-left: -30px">Responsable Técnico</div>

            <g:hiddenField name="revisor.id" id="hiddenRevisor" value="${obra?.revisor?.id}"/>
            <div class="col-md-3"><g:textField name="revisorText" class="revisor required" value="${obra?.revisor?.nombre +
                    " " + obra?.revisor?.apellido}" readonly="readonly" title="Persona Responsable Técnico de la Obra"
                    style="width: 220px"/></div>

        %{--<div class="col-md-1">Responsable</div>--}%
            <div class="col-md-1">Elaboró Presupuesto</div>

            <g:hiddenField name="responsableObra.id" id="hiddenResponsable" value="${obra?.responsableObra?.id}"/>
            <div class="col-md-3"><g:textField name="responsableText" class="responsable required"
                 value="${(obra?.responsableObra?.titulo ?: '') + '' + obra?.responsableObra?.nombre + " " +
                 obra?.responsableObra?.apellido}" readonly="readonly" title="Persona responsable de la Obra"
                 style="width: 300px"/></div>

        </g:else>


    </g:else>

</g:else>

