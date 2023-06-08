
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Configurar Orden de inicio de obra</title>
    <meta name="layout" content="main"/>
</head>

<body>

<div class="alert alert-info" >
    Orden de inicio de la obra: <strong>${contrato?.codigo + " - " + obra?.descripcion}</strong>
</div>

<div class="row" style="margin-bottom: 15px;">
    <div class="col-md-3 btn-group" role="navigation">
        <g:link controller="contrato" action="verContrato" params="[contrato: contrato?.id]" class="btn btn-primary" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Contrato
        </g:link>
        <g:link controller="planilla" action="list" id="${contrato?.id}" class="btn btn-info" title="Regresar al contrato">
            <i class="fa fa-arrow-left"></i>
            Planillas
        </g:link>
    </div>
    <div class="col-md-6 btn-group" role="navigation">
        <div class="">
            <a href="#" class="btn btn-success" id="btnSave"><i class="fa fa-save"></i> Guardar</a>
        </div>
    </div>
</div>

<g:if test="${textos.size() > 0}">
    <g:form action="saveInicioObra" id="${obra.id}" name="frmInicio" >
        <div class="alert alert-warning info">
            <i class="fa fa-exclamation text-info fa-3x pull-left"></i>
            <ul>
                <li>
                    No se ha configurado la orden de inicio de obra. A continuación se presenta el texto por defecto. Realice las modifcaciones necesarias y haga clic en el botón Guardar.
                </li>
                <li>
                    <span style="font-size: larger; font-weight: bold;">Tenga en cuenta que una vez guardada no se podrá modificar.</span>
                </li>
            </ul>
        </div>

        <div class="well">
            <g:each in="${textos}" var="parrafo" status="j">
                <g:set var="i" value="${1}"/>
                <p style="margin-bottom: 30px;">
                    <g:each in="${parrafo}" var="elem">
                        <g:if test="${elem.tipo == 'E'}">
                            <g:textArea class="elem" name="edit_${j + 1}_${i}" value="${elem.string}" style="width: ${elem.w}; height: ${elem.h}; resize:none"/>
                            <g:set var="i" value="${i + 1}"/>
                        </g:if>
                        <g:else>
                            ${elem.string}
                        </g:else>
                    </g:each>
                </p>
            </g:each>

            <g:textArea name="extra" value="" style="width: 940px; height: 80px; resize: none"/>
        </div>
    </g:form>
</g:if>
<g:else>
    <div class="alert alert-success">
        <i class="fa fa-exclamation text-info fa-2x pull-left"></i>
        <ul>
            <li>
                La orden de inicio de obra ya se ha configurado por lo que no podrá ser modificada.
            </li>
        </ul>
    </div>

    <div class="well">
        <p>
            ${texto.parrafo1}
        </p>
        <p>
            ${texto.parrafo2}
        </p>
        <p>
            ${texto.parrafo3}
        </p>
        <p>
            ${texto.parrafo4}
        </p>
    </div>
</g:else>

<script type="text/javascript">

    function submitFormInicio() {
        var $form = $("#frmInicio");
        var data = $form.serialize();
        var dialog = cargarLoader("Guardando...");
        $.ajax({
            type    : "POST",
            url     : $form.attr("action"),
            data    : data,
            success : function (msg) {
                dialog.modal('hide');
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
    }

    $("#btnSave").click(function () {
        var ok = true;
        $(".elem").each(function () {
            if ($.trim($(this).val()) === "") {
                ok = false;
            }
        });
        if (!ok) {
            bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + "Complete todos los campos antes de guardar </br> El último párrafo es opcional" + '</strong>');
        } else {
            submitFormInicio();
        }
        return false;
    });
</script>

</body>
</html>