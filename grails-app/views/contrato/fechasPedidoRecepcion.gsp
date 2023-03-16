<%@ page contentType="text/html;charset=UTF-8" %>
<html>
    <head>
        <meta name="layout" content="main">
        <title>Fechas de pedido de recepción</title>
    </head>

    <body>

        <div class="row" style="margin-bottom: 10px;">
            <div class="span9 btn-group" role="navigation">
                <g:link controller="contrato" action="verContrato" params="[id: contrato?.id]" class="btn btn-info btn-new" title="Regresar al contrato">
                    <i class="fa fa-arrow-left"></i>
                    Contrato
                </g:link>
                <g:link controller="planilla" action="listFiscalizador" id="${contrato?.id}" class="btn " title="Planillas">
                    <i class="fa fa-list"></i>
                    Planillas
                </g:link>
                <a href="#" class="btn btn-success" id="btnSave"><i class="fa fa-save"></i> Guardar</a>
            </div>
        </div>

        <div class="alert alert-info" style="margin-bottom: 20px; font-size: 16px">Fecha de pedido de recepción</div>

        <div id="create-Contrato" class="col-md-12" role="main" style="height: 400px">
            <g:form class="form-horizontal" name="frmSave" action="saveFechas" id="${contrato.id}">
                <span class="grupo col-md-12" style="margin-bottom: 20px">
                    <label for="fechaPedidoRecepcionContratista" class="col-md-2 control-label text-info">
                        Del contratista
                    </label>
                    <span class="col-md-3">
                        <input aria-label="" name="fechaPedidoRecepcionContratista" id='fechaPedidoRecepcionContratista' type='text' class="form-control required" value="${contrato.fechaPedidoRecepcionContratista?.format("dd-MM-yyyy")}" />
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                </span>

                <span class="grupo col-md-12">
                    <label for="fechaPedidoRecepcionFiscalizador" class="col-md-2 control-label text-info">
                        Del fiscalizador
                    </label>
                    <span class="col-md-3">
                        <input aria-label="" name="fechaPedidoRecepcionFiscalizador" id='fechaPedidoRecepcionFiscalizador' type='text' class="form-control required" value="${contrato.fechaPedidoRecepcionFiscalizador?.format("dd-MM-yyyy")}" />
                        <p class="help-block ui-helper-hidden"></p>
                    </span>
                </span>
            </g:form>
        </div>

        <script type="text/javascript">

            $('#fechaPedidoRecepcionContratista, #fechaPedidoRecepcionFiscalizador').datetimepicker({
                locale: 'es',
                format: 'DD-MM-YYYY',
                icons: {
                }
            });

            $(function () {
                $("#btnSave").click(function () {
                    submitFormFechasRecepcion();
                });
            });

            function submitFormFechasRecepcion() {
                var $form = $("#frmSave");
                if ($form.valid()) {
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
                } else {
                    return false;
                }
            }

        </script>
    </body>
</html>