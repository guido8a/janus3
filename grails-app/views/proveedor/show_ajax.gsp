
<%@ page import="janus.pac.Proveedor" %>

<div id="show-proveedor" class="span5" role="main">

    <form class="form-horizontal">

        <g:if test="${proveedorInstance?.especialidad}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Especialidad
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.especialidad?.descripcion}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.tipo}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Tipo
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.tipo == 'N' ?  "Natural" : 'Jurídica' }
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.ruc}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Ruc
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.ruc}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.nombre}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Nombre
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.nombre}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.nombreContacto}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Nombre Contacto
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.nombreContacto}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.apellidoContacto}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Apellido Contacto
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.apellidoContacto}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.garante}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Gerente
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.garante}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.direccion}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Dirección
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.direccion}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.telefonos}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Telefonos
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.telefonos}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.fechaContacto}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Fecha Contacto
                    </label>
                    <span class="col-md-8">
                        <g:formatDate date="${proveedorInstance?.fechaContacto}" format="dd-MM-yyyy" />
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.email}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Email
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.email}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.titulo}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Titulo
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.titulo}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.estado}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Estado
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.estado == '1' ? 'Activo' : 'Inactivo'}
                    </span>
                </span>
            </div>
        </g:if>

        <g:if test="${proveedorInstance?.observaciones}">
            <div class="form-group">
                <span class="grupo">
                    <label class="col-md-2 control-label text-info">
                        Observaciones
                    </label>
                    <span class="col-md-8">
                        ${proveedorInstance?.observaciones}
                    </span>
                </span>
            </div>
        </g:if>

    </form>
</div>
