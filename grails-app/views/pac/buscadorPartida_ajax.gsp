<div id="listaRbro" style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <label class="col-md-2 control-label text-info">
                    Buscar Por
                </label>
                <span class="col-md-3">
                    <g:select name="buscarPor" class="buscarPor col-md-12 form-control" from="${[1: 'Descripción', 2: 'Código']}" optionKey="key"
                              optionValue="value"/>
                </span>
                <label class="col-md-1 control-label text-info">
                    Criterio
                </label>
                <span class="col-md-4">
                    <g:textField name="buscarCriterio" id="criterioCriterio" class="form-control"/>
                </span>
            </span>
            <div class="col-md-1" style="margin-top: 1px">
                <button class="btn btn-info" id="btnBuscarPP"><i class="fa fa-search"></i></button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaPP" style="height: 460px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    buscarPP();

    $("#btnBuscarPP").click(function () {
        buscarPP();
    });

    function buscarPP() {
        var buscarPor = $("#buscarPor option:selected").val();
        var criterio = $("#criterioCriterio").val();
        $.ajax({
            type: "POST",
            url: "${createLink(controller: 'pac', action:'tablaPartida_ajax')}",
            data: {
                buscarPor: buscarPor,
                criterio: criterio
            },
            success: function (msg) {
                $("#divTablaPP").html(msg);
            }
        });
    }

</script>