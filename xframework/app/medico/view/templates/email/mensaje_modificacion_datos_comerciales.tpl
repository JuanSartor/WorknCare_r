<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width">
    </head>
    <body>
    <body style="margin:0;padding:0">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
            <tr>
                <td bgcolor="#F7F7F7" style="padding: 24px 0">

                    <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td style="padding:12px 0"><img src="{$IMGS}logo_workncare_color.png" alt="DoctorPlus" style="border:none"/></td>
                        </tr>
                    </table>

                    <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td style="padding:16px 16px 0px 16px">
                                <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold"><span style="color:#31A592; font-size:18px">{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}</span></p>
                                <p style="color:#F8425E; font-size:18px; font-family:'Helvetica', Arial, sans-serif">
                                    Avis de modification de coordonnées bancaires
                                </p>
                                <hr>
                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                    Nous avons bien pris en compte la modification des <strong>coordonnées bancaires</strong> associées à votre compte sur DoctorPlus. 

                                    <br>
                                    Si vous n'avez effectué aucune modification, veuillez s'il vous plait  <a href="mailto:support@workncare.io" style="color:#F8425E; text-decoration:none">nous écrire ici.</a>
                                </p>
                            </td>
                        </tr>



                        <tr>
                            <td style="padding:0 16px 0px 16px">
                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold">
                                    Salutations, <br>
                                    L’équipe WorknCare
                                </p>
                            </td>
                        </tr>

                    </table>

                    <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td style="padding: 4px 16px;">
                                <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">
                                    Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. Si {$medico.email} n'est pas votre compte sur DoctorPlus, envoyez-nous s'il vous plait un email à support@workncare.io pour déconnecter votre adresse email de ce compte
                                </p>
                            </td>
                        </tr>
                    </table>
                    <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td align="center" style="padding-top:24px;">
                                <img src="{$url}mails/workncare-logo-bw.png" alt="DoctorPlus" style="border:none"/>
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