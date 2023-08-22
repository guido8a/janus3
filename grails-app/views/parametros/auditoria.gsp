<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <title>Auditoría</title>

    <style type="text/css">
    .table {
        font-size     : 12px;
        margin-bottom : 0 !important;
    }

    .perfiles option:first-child {
        font-weight : normal !important;
    }
    </style>
</head>

<body>

<div style="overflow: hidden">
    <fieldset class="borde" style="border-radius: 4px">
        <div class="row-fluid" style="margin-left: 10px">
            <span class="grupo">
                <span class="col-md-2">
                    <label class="control-label text-info">Fecha desde</label>
                    <input aria-label="" name="desde" id='desde' type='text' class="form-control" />
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">Fecha hasta</label>
                    <input aria-label="" name="hasta" id='hasta' type='text' class="form-control"  />
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">Dominio</label>
                    <g:select name="dominio" id="dominio" from="${dominios}" optionValue="${{it.audtdomn}}" optionKey="audtdomn" class="form-control"/>
                </span>
                <span class="col-md-2">
                    <label class="control-label text-info">ID registro</label>
                    <g:textField name="registro" id="registro" class="number form-control"/>
                </span>
            </span>
            <div class="col-md-1" style="margin-top: 20px">
                <button class="btn btn-info" id="btnBuscarAuditoria"><i class="fa fa-search"></i></button>
            </div>
            <div class="col-md-1" style="margin-top: 20px">
                <button class="btn btn-warning" id="btnLimpiarBusqueda"><i class="fa fa-eraser"></i>Limpiar</button>
            </div>
        </div>
    </fieldset>

    <fieldset class="borde" style="border-radius: 4px">
        <div id="divTablaAuditoria" style="height: 560px; overflow: auto; margin-top: 5px">
        </div>
    </fieldset>
</div>

<script type="text/javascript">

    function validarNum(ev) {
        return ((ev.keyCode >= 48 && ev.keyCode <= 57) ||
            (ev.keyCode >= 96 && ev.keyCode <= 105) ||
            ev.keyCode === 8 || ev.keyCode === 46 || ev.keyCode === 9 ||
            ev.keyCode === 37 || ev.keyCode === 39);
    }

    $("#registro").keydown(function (ev){
        return validarNum(ev)
    });

    $('#desde, #hasta').datetimepicker({
        locale: 'es',
        format: 'DD-MM-YYYY',
        sideBySide: true,
        icons: {
        }
    });

    $("#btnLimpiarBusqueda").click(function () {
        $("#desde").val('');
        $("#hasta").val('');
        $("#registro").val('');
        // $("#dominio").val('');
        //cargarTablaAuditoria();
    });

    // cargarTablaAuditoria();

    $("#btnBuscarAuditoria").click(function () {
        cargarTablaAuditoria();
    });

    function cargarTablaAuditoria(){
        var d = cargarLoader("Cargando...");
        var desde = $("#desde").val();
        var hasta = $("#hasta").val();
        var registro = $("#registro").val();
        var dominio = $("#dominio").val();

        if(desde > hasta){
            d.modal("hide");
            bootbox.alert('<i class="fa fa-exclamation-triangle text-info fa-3x"></i> ' + '<strong style="font-size: 14px">' + "La fecha inicial es mayor a la fecha final" + '</strong>')
        }else{
            $.ajax({
                type: 'POST',
                url: '${createLink(controller: 'parametros', action: 'tablaAuditoria_ajax')}',
                data:{
                    desde: desde,
                    hasta: hasta,
                    registro: registro,
                    dominio: dominio
                },
                success: function (msg){
                    d.modal("hide");
                    $("#divTablaAuditoria").html(msg)
                }
            })
        }
    }


</script>

</body>
</html>