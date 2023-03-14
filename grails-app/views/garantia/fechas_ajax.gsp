<div class="container">
    <div class="col-md-12">
        <div class="col-md-1">
            Desde
        </div>

        <div class="col-md-2">
            <input aria-label="" name="fechaDesde_name" id='fechaDesde' type='text' class="form-control"  />
        </div>
    </div>

    <div class="col-md-12" style="margin-top: 5px">
        <div class="col-md-1">
            Hasta
        </div>

        <div class="col-md-2">
            <input aria-label="" name="fechaHasta_name" id='fechaHasta' type='text' class="form-control"  />
        </div>
    </div>
</div>


<script type="text/javascript">

    $('#fechaDesde, #fechaHasta').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });
</script>