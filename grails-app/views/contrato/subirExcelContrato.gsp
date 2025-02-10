<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main">
    <title>Subir archivo excel contrato</title>
    <style type="text/css">
    table, th, td {
        border: 1px solid white;
    }
    </style>
</head>

<body>

<div class="row">
    <div class="col-md-1">
        <a href="#" class="btn btn-primary btnRegresar">
            <i class="fa fa-arrow-left"></i>
            Regresar
        </a>
    </div>
    <div class="col-md-11" style="margin-top: -15px">
        <h3 style="text-align: center">Cargar valores contratados y cronograma del contrato: ${contrato.codigo}</h3>
    </div>

</div>

<g:if test="${flash.message}">
    <div class="alert alert-error">
        ${flash.message}
    </div>
</g:if>

%{--<div class="alert alert-warning">--}%
    <div class="alert alert-warning"><i class="fa fa-exclamation-triangle fa-2x text-info"></i> <strong style="font-size: 16px"> Ingrese a CRONOGRAMA TOTAL antes de subir cualquier archivo excel </strong></div>
%{--</div>--}%

<g:uploadForm controller="cronogramaContrato" action="uploadFile" method="post" name="frmUpload" id="${contrato?.id}" style="padding: 10px">
    <g:hiddenField name="id" value="${contrato?.id}"/>
    <div id="list-grupo" class="col-md-12" role="main">
        <div class="" style="margin: 0 0 20px 0;">
            <div class="col-md-2 text-info">Formato del archivo <strong>Excel xlsx</strong></div>
            <div class="col-md-9">

                <table class="table" style="background-color: #5a7ab2; color: #fff;">
                    <tr>
                        <th style="border: 1px solid #ddd; text-align: center">
                            A - NÚMERO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            B - DESCRIPCIÓN DEL RUBRO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            C - UNIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            C - CANTIDAD
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            D - PRECIO UNITARIO OFERTADO
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            E - PRECIO TOTAL
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            F - MES 1
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            G - MES 2
                        </th>
                        <th style="border: 1px solid #ddd; text-align: center">
                            ...
                        </th>
                    </tr>
                    <tr style="background-color: #dfdfff; text-align: center; color: #000;">
                        <td>1</td>
                        <td>Replanteo y niv..</td>
                        <td>m</td>
                        <td>2941.96</td>
                        <td>1.28501</td>
                        <td>3780.44802</td>
                        <td>3780.44802</td>
                        <td>0</td>
                        <td>0</td>
                    </tr>
                    <tr style="background-color: #dfdfff; text-align: center; color: #000;">
                        <td>..</td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </table>

                <br/>
            </div>
        </div>

        <div class="col-md-12" style="margin-top: 20px">
            <div class="col-md-2"><b>Archivo Excel a subir:</b></div>
            <div class="col-md-8">
                <input type="file" class="required" id="fileCrono" name="file" multiple accept=".xlsx"
                       style="width: 100%; font-size: 12pt" value="Arch"/>
            </div>
            <div class="col-md-2">
                <a href="#" class="btn btn-success" id="btnSubmitCrono"><i class="fa fa-upload"></i>
                    Subir cronograma</a>
            </div>
        </div>
    </div>

</g:uploadForm>

<script type="text/javascript">

    $(".btnRegresar").click(function () {
        location.href="${createLink(controller: 'contrato', action: 'registroContrato')}?contrato=" +
            '${contrato?.id}'
    });

    $("#btnSubmitCrono").click(function () {
        if ($("#frmUpload").valid()) {
            $("#frmUpload").submit();
        }
     });

</script>
</body>
</html>