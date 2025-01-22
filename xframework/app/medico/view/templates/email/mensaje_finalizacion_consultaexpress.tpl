<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width">
    </head>
    <body style="margin:0;padding:0">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
            <tr>
                <td bgcolor="#F7F7F7" style="padding: 24px 0">

                    <table width="600" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td style="padding:12px 0"><img src="{$IMGS}logo_workncare_color.png" alt="WorknCare" style="border:none"/></td>
                        </tr>
                    </table>

                    <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="21" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td style="padding:16px">
                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif"><span style="color:#F33243; font-size:18px">Bonjour {$consulta_express.paciente.nombre} {$consulta_express.paciente.apellido} </span></p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:0 16px 16px 16px">
                                <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                    <tr>
                                        <td style="padding:0 16px 16px 16px">
                                            <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                                <tr>
                                                    <td width="100%"  align="center" valign="middle" style="padding:6px;">
                                                        {if $consulta_express.medico.imagen.perfil!=""}
                                                            <img src="{$consulta_express.medico.imagen.perfil}" alt="{$consulta_express.medico.titulo_profesional.titulo_profesional} {$consulta_express.medico.nombre} {$consulta_express.medico.apellido}" style="border:none; border-radius:50%;"/>
                                                        {else}
                                                            <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$consulta_express.medico.titulo_profesional.titulo_profesional} {$consulta_express.medico.nombre} {$consulta_express.medico.apellido}" style="border:none; border-radius:50%;"/>
                                                        {/if}    
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle" align="center">
                                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold;">
                                                            <a href="{$url}panel-paciente/profesionales/{$consulta_express.medico.idmedico}-{$consulta_express.medico.nombre|str2seo}-{$consulta_express.medico.apellido|str2seo}.html"  class="rsp-lnk" target="_blank"  style="color:#0EC2A1; text-decoration:none">{$consulta_express.medico.titulo_profesional.titulo_profesional} {$consulta_express.medico.nombre} {$consulta_express.medico.apellido}</a> a finalisé votre <a href="{$url}panel-paciente/consultaexpress/finalizadas.html"  class="rsp-lnk" target="_blank"  style="color:#0EC2A1; text-decoration:none">Conseil</a>
                                                        </p>
                                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                                            Motif: <span style="font-size:16px;">{$consulta_express.motivoConsultaExpress}</span>
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="padding:0 16px">
                                            <hr>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td style="padding:0 16px 16px 16px">
                                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                                <a href="{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$idperfilsaludconsulta}" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #F95450; text-decoration: none; border-radius: 4px;">Voir conclusions</a>
                                            </p>
                                            {*<p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                            ou suivez ce lien pour accéder aux conclusions.
                                            </p>
                                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                            <a style="text-decoration:none; line-height:32px; color:#415B70; font-weight:bold" class="rsp-lnk" href="{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$idperfilsaludconsulta}" target="_blank">{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$idperfilsaludconsulta}</a>
                                            </p>*}
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding:0 16px 0px 16px">
                                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                                Merci d'utiliser nos services !
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding:0 16px 0px 16px">
                                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                                Salutations, <br>
                                                L’équipe WorknCare 
                                            </p>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    </table>

                    <table width="600" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td style="padding: 4px 16px;">
                                <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">

                                    Cette adresse email ne permet pas de recevoir de réponse. 

                                    Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. 
                                    Si {$consulta_express.paciente.email} n'est pas à votre compte sur WorknCare, envoyez-nous s'il vous plait un email à <a href="mailto:support@workncare.io">support@workncare.io</a> pour déconnecter votre adresse email de ce compte.

                                </p>
                            </td>
                        </tr>
                    </table>
                    <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td align="center" style="padding-top:24px;">
                                <img src="{$url}mails/workncare-logo-bw.png" alt="WorknCare" style="border:none"/>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <table width="100%" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
            <tr>
                <td align="center" bgcolor="#3A3D43">
                    <p style="color:#FFFFFF; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">&copy; {$smarty.now|date_format:"%Y"} WorknCare, Tous droits réservés.</p>
                </td>
            </tr>
        </table>
        {literal}
            <style type="text/css">
                @media only screen and (max-width: 600px), screen and (max-device-width: 600px){
                    table{
                        width:100%;
                    }
                    .rsp-img{
                        display: block;
                        width: 100%;
                    }
                    .rsp-lnk{
                        word-break: break-all;
                        line-height: 18px !important;
                        display: block;
                        padding-top: 12px;
                    }
                }
            </style>
        {/literal}
    </body>
</html>
