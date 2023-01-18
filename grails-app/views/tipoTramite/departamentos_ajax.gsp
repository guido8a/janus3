<h5>Coordinación de ${tipoTramite}</h5>

<div class="well">
    <div class="row">
        <span class="grupo">
            <label for="rolTramite" class="col-md-2 control-label text-info">
                Rol
            </label>
            <span class="col-md-8">
                <g:select name="rolTramite" from="${janus.RolTramite.list()}" optionKey="id" optionValue="descripcion" class="many-to-one form-control required" />
            </span>
        </span>
    </div>

    <div class="row">
        <span class="grupo">
            <label for="departamento" class="col-md-2 control-label text-info">
                Coordinación
            </label>
            <span class="col-md-8">
                <g:select name="departamento" from="${janus.Departamento.list()}" optionKey="id" optionValue="descripcion" class="many-to-one form-control required" />
            </span>
            <span class="span2" style="width:110px;margin-top: 10px">
                <a href="#" id="btnAdd" class="btn btn-success">
                    <i class="fa fa-plus"></i>
                    Agregar
                </a>
            </span>
        </span>
    </div>
</div>

<table class="table table-bordered table-striped table-condensed table-hover">
    <thead>
    <tr>
        <th style="width: 25%">Rol</th>
        <th style="width: 65%">Coordinación</th>
        <th style="width: 10%">Acciones</th>
    </tr>
    </thead>
    <tbody id="tablaDepartamentos">
    </tbody>
</table>


<script type="text/javascript">

    cargarTablaDepartamentos(${tipoTramite?.id});

    function cargarTablaDepartamentos(id) {
        $.ajax({
            type: 'POST',
            url: "${createLink(action: 'tablaTipoTramite_ajax')}",
            data:{
                id: id
            },
            success: function (msg) {
                $("#tablaDepartamentos").html(msg)
            }
        })
    }

    $("#btnAdd").click(function () {
        var rol = $("#rolTramite option:selected").val();
        var coordinacion = $("#departamento option:selected").val();

        $.ajax({
            type: 'POST',
            url: '${createLink(action: 'guardarDepartamentoTramite_ajax')}',
            data:{
                tipoTramite: '${tipoTramite?.id}',
                rolTramite: rol,
                departamento: coordinacion
            },
            success: function (msg) {
                var parts = msg.split("_");
                if(parts[0] === 'ok'){
                    log(parts[1], "success");
                    cargarTablaDepartamentos(${tipoTramite?.id});
                }else{
                    bootbox.alert('<i class="fa fa-exclamation-triangle text-danger fa-3x"></i> ' + '<strong style="font-size: 14px">' + parts[1] + '</strong>');
                }
            }
        })

    });

</script>