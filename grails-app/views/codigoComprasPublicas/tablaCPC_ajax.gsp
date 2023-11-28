
<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 15%">Código</th>
        <th style="width: 70%">Descripción</th>
        <th style="width: 9%">Acciones</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 430px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table table-bordered table-striped table-condensed table-hover">
        <tbody>
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 14%">${dt.cpacnmro}</td>
                <td style="width: 68%">${dt.cpacdscr}</td>
                <td style="width: 10%; text-align: center">
                    <a class="btn btn-success btn-xs btn-edit" href="#"  title="Editar" data-id="${dt?.cpac__id}">
                        <i class="fa fa-edit"></i>
                    </a>
                    <a class="btn btn-danger btn-xs btn-delete" href="#" title="Eliminar" data-id="${dt?.cpac__id}">
                        <i class="fa fa-trash"></i>
                    </a>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

<script type="text/javascript">


    $(".btn-edit").click(function () {
        var id = $(this).data("id");
        createEditRowCPC(id);
    }); //click btn edit

    $(".btn-delete").click(function () {
        var id = $(this).data("id");
        deleteRowCPC(id);
    });


</script>