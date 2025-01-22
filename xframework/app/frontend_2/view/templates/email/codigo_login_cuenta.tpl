<body style="margin:0;padding:0">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
        <tr>
            <td bgcolor="#F7F7F7" style="padding: 24px 0">

                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding:12px 0"><img src="{$IMGS}logo_workncare_color.png" alt="WorknCare" style="border:none"/></td>
                    </tr>
                </table>

                <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding:16px 16px 0px 16px">
                            <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold"><span style="color:#31A592; font-size:18px">Bonjour {$usuario.nombre} {$usuario.apellido}</span></p>
                            <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif">
                                {if $usuario.idioma_predeterminado =="fr"}  Utilisez ce code de connexion:{else} Use this login code:{/if}
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:0 16px">
                            <p style="text-align:center; color:#415B70; font-size:24px; font-family:'Helvetica', Arial, sans-serif">
                                <span style="letter-spacing: 8px; padding: 8px 16px; color: #fff; background-color: #F95450; text-decoration: none; border-radius: 4px;" >{$codigoVerificacionLogin}</a>
                            </p>

                        </td>
                    </tr>

                    <tr>
                        <td style="padding:0 16px 0px 16px">
                            <p style="color:#415B70; font-size:18px; font-family:'Helvetica', Arial, sans-serif">
                                <strong> {if $usuario.idioma_predeterminado =="fr"}Pourquoi utiliser un code?{else}Why use a code?{/if}</strong>
                            </p>
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                {if $usuario.idioma_predeterminado =="fr"}  Pour sécuriser l’accès à votre compte.{else}To secure access to your account. {/if}
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:0 16px 0px 16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                {if $usuario.idioma_predeterminado =="fr"}   Cordialement,<br>
                                    L’équipe WorknCare{else}
                                    Sincerely,<br>
                                    The WorknCare Team
                                {/if}
                            </p>
                        </td>
                    </tr>

                </table>
                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding: 4px 16px;">
                            <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">
                                {if $usuario.idioma_predeterminado =="fr"}   Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. Si {$usuario.email} n'est pas votre compte sur WorknCare, envoyez-nous s'il vous plait un email à support@workncare.io pour déconnecter votre adresse email de ce compte.
                                {else}
                                    This email address does not allow for a reply. If you need more information, please contact our support team. If {$usuario.email} is not your account on WorknCare, please email us at support@workncare.io to disconnect your email address from this account.
                                {/if}
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
                <p style="color:#FFFFFF; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">&copy; {$smarty.now|date_format:"%Y"} WorknCare,  {if $usuario.idioma_predeterminado =="fr"}Tous droits réservés.{else}All rights reserved.{/if}</p>
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