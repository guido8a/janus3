<elm:poneHtml textoHtml="${html}"/>

<script type="text/javascript">

    $(".btnEditar").click(function () {
        var id = $(this).data("id");
        var indice = $(this).data("indc");
        var periodo = $(this).data("prin");
        $.ajax({
            type    : "POST",
            url: "${createLink(action:'editarValorIndice_ajax')}",
            data    : {
                id: id,
                indice: indice,
                periodo: periodo
            },
            success : function (msg) {
                var b = bootbox.dialog({
                    id      : "dlgEditIndices",
                    title   : "Editar valor del índice",
                    class   : "modal-sm",
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
                                return submitFormValorIndices();
                            } //callback
                        } //guardar
                    } //buttons
                }); //dialog
            } //success
        }); //ajax
    });

    function submitFormValorIndices() {
        var $form = $("#frmSave-ValorIndice");
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
                        consultar();
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

    $(".btCopia").click(function () {
        var valorPrevio =  $(this).parent().prev().prev().prev().data('valor');
        var id = $(this).data("id");
        var indice = $(this).data("indc");
        var periodo = $(this).data("prin");
        $.ajax({
            type: 'POST',
            url: '${createLink(controller: 'indice', action: 'saveValorIndice_ajax')}',
            data:{
                id: id,
                valor: valorPrevio,
                indice: indice,
                periodo: periodo
            },
            success: function (msg){
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    consultar();
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                    return false;
                }
            }
        });
    });

</script>

