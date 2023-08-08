<div class="row">
    <div class="col-md-12">
        <div class="col-md-6">
            <label>
                Listas de Precios para:
            </label>
            <g:select name="lista" from="${janus.TipoLista.findAllByCodigoInList(['V', 'V1', 'V2'])}" optionValue="descripcion" optionKey="id" class="form-control" />
        </div>

%{--        <div class="col-md-4">--}%
%{--            <label>--}%
%{--                Fecha--}%
%{--            </label>--}%
%{--            <input aria-label="" name="fecha1" id='fecha1' type='text' class="form-control" value="${new Date().format("dd-MM-yyyy")}"/>--}%
%{--        </div>--}%
    </div>
</div>

<script type="text/javascript">

    // $('#fecha1').datetimepicker({
    //     locale: 'es',
    //     format: 'DD-MM-YYYY',
    //     sideBySide: true,
    //     icons: {
    //     }
    // });

</script>