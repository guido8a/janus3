

<%@ page import="janus.Nota" contentType="text/html;charset=UTF-8" %>
<html>
<head>

    <style type="text/css">
    @page {
        /*size   : 21cm 29.7cm;  !*width height *!*/
        size   : 29.7cm 21cm;  /*width height */
        margin : 2cm;
    }

    body {
        background : none !important;
    }

    .hoja {
        height      : 24.7cm; /*29.7-(1.5*2)*/
        font-family : serif;
        font-size   : 10px;
        width       : 25cm;
    }

    .tituloPdf {
        height        : 50px;
        font-size     : 11px;
        text-align    : center;
        margin-bottom : 5px;
        width         : 95%;
    }

    .totales {
        font-weight : bold;
    }

    .theader{
        border-bottom: 1px solid #000000 !important;
        border-top: 1px solid #000000 !important;
    }

    .theaderBot {
        border-bottom: 1px solid #000000;
    }

    .theaderup {
        border-top: 1px solid #000000;
    }

    .padTopBot{
        padding-top: 5px !important;
        padding-bottom: 5px !important;
    }

    thead th{
        background : #FFFFFF !important;
        color: #000000 !important;
    }

    .num {
        text-align : right;
    }

    .header {
        background : #333333 !important;
        color      : #AAAAAA;
    }

    td {
        background : #ededed !important;
        /*color      : #AAAAAA;*/
    }

    thead tr {
        margin : 0px
    }

    th, td {
        font-size : 10px !important;
    }

    .row-fluid {
        width  : 100%;
        height : 20px;
    }

    .span3 {
        width  : 29%;
        float  : left;
        height : 100%;
    }

    .span8 {
        width  : 79%;
        float  : left;
        height : 100%;
    }

    .span7 {
        width  : 69%;
        float  : left;
        height : 100%;
    }

    </style>
</head>

<body>
<div class="hoja" style="margin-bottom: 40px">

    <div class="tituloPdf" style="margin-bottom: 5px !important; text-align: center">
        <p style="font-size: 14px; ">
            <b>G. A. D. PROVINCIA DE PICHINCHA</b>
        </p>
        <p style="font-size: 14px; margin-bottom: 5px">
            <b>LISTA DE USUARIOS</b>
        </p>
    </div>

    <div style="font-size: 12px; font-weight: bold"></div>
    <table class="table table-bordered table-striped table-condensed table-hover">
        <thead>
        <tr class="theaderBot theaderup padTopBot">
            <th style="width: 10%;"  >
                Usuario
            </th>
            <th style="width: 15%;" >
                Nombre
            </th>
            <th style="width: 15%;" >
                Apellido
            </th>
            <th style="width: 30%;" >
                Departamento
            </th>
            <th style="width: 10%;" >
                Estado
            </th>
            <th style="width: 20%;">
                Perfiles
            </th>
        </tr>
        </thead>
        <tbody id="tabla_material">

        <g:each in="${datos}" var="usuario" status="j">
            <tr class="item_row" >
                <td style="width: 10%" class="orden">${usuario.prsnlogn}</td>
                <td style="width: 15%" class="orden">${usuario.prsnnmbr}</td>
                <td style="width: 15%" class="orden">${usuario.prsnapll}</td>
                <td style="width: 30%" class="orden">${janus.Departamento.get(usuario.dpto__id).descripcion}</td>
                <td style="width: 10%" class="orden">${usuario.prsnactv == 0 ? 'Inactivo' : 'Activo'}</td>
                <td style="width: 20%">
                    <ul>
                        <g:each in="${seguridad.Sesn.findAllByUsuario(seguridad.Persona.get(usuario.prsn__id))}" var="perfiles">
                            <li>${perfiles?.perfil?.descripcion ?: ''}</li>
                        </g:each>
                    </ul>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>
</div>

</body>
</html>