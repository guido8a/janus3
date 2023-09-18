<%--
  Created by IntelliJ IDEA.
  User: fabricio
  Date: 27/09/21
  Time: 11:32
--%>


<table class="table table-bordered table-striped table-hover table-condensed" id="tabla">
    <thead>
    <tr>
        <th style="width: 8%">Código</th>
        <th style="width: 35%">Objeto</th>
        <th style="width: 8%">Fecha</th>
        <th style="width: 14%">Contratista</th>
        <th style="width: 15%">Administrador</th>
        <th style="width: 15%">Fiscalizador</th>
        <th style="width: 4%">Sel.</th>
        <th style="width: 1%"></th>
    </tr>
    </thead>
</table>

<div class="" style="width: 99.7%;height: 420px; overflow-y: auto;float: right; margin-top: -20px">
    <table class="table-bordered table-condensed table-hover" style="width: 100%">
        <g:each in="${data}" var="dt" status="i">
            <tr>
                <td style="width: 8%">${dt.cntrcdgo}</td>
                <td style="width: 35%">${dt.cntrobjt}</td>
                <td style="width: 8%"> ${dt?.cntrfcsb?.format('dd/MM/yyyy')}
                <td style="width: 14%"> ${dt.prvenmbr}
                <td style="width: 15%"> ${dt.admn}
                <td style="width: 15%"> ${dt.fscl}
                </td>
                <td style="width: 4%">
                    <div style="text-align: center" class="selecciona" id="reg_${i}"
                         regNmbr="${dt?.cntrobjt}" regCdgo="${dt?.cntrcdgo}"
                         data-id="${dt?.cntr__id}">
                        <button class="btn btn-xs btn-success"><i class="fa fa-check"></i></button>
                    </div>
                </td>
                <td style="width: 1%"></td>
            </tr>
        </g:each>
    </table>
</div>

<script type="text/javascript">
    $(".selecciona").click(function () {
        var g = cargarLoader("Cargando...");
        var id = $(this).data("id");
        $("#listaObra").dialog("close");
        $("#spinner").removeClass("hide");
        location.href = "${g.createLink(controller: 'contrato', action: 'verContrato')}" + "?contrato=" + id
    });
</script>