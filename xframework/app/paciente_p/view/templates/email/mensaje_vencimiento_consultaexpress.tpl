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
                        <td style="padding:16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif"><span style="color:#F33243; font-size:18px">Bonjour {$paciente.nombre} {$paciente.apellido}</span></p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:0 16px 16px 16px">
                            <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                <tr>
                                    <td style="padding:0 16px 16px 16px">
                                        <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                            <tr>
                                                <td width="60">
                                                    <img src="{$url}mails/icon-clock.png" style="border:none;"/>
                                                </td>
                                                <td style="padding:8px 16px" valign="top">
                                                    <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold; margin:0;padding:0;">
                                                        Pas de professionnel disponible… Le délai de réponse est <span style="color:#21B796">expiré </span>
                                                        pour votre <br>

                                                        <a href="{$url}panel-paciente/consultaexpress/vencidas-{$consulta.idconsultaExpress}.html" class="rsp-lnk" target="_blank" style="color:#21B796; text-decoration:none">Conseil</a> Nº{$consulta.numeroConsultaExpress}

                                                    </p>
                                                    <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                                        Motif: <span style="font-size:16px;">{$motivo}</span>
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
                                    <td style="padding:16px 16px 0 16px">
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            Le montant de celle-ci <strong>ne sera plus débité</strong> de votre carte. 
                                        </p>
                                        <p style="color:#415B70; font-size:18px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold;">
                                            Que souhaitez-vous faire?
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding:0 16px 16px 16px">
                                        <table width="90%" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                            <tr>
                                                <td align="left" valign="middle">
                                                    <img src="{$url}mails/icon-check.png"/>
                                                </td>
                                                <td align="left" valign="middle">
                                                    <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; line-height: 16px;">
                                                        Allonger le délai de réponse pour le(s) Professionnel(s) consulté(s)
                                                    </p>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" valign="middle">
                                                    <img src="{$url}mails/icon-check.png"/>
                                                </td>
                                                <td align="left" valign="middle">
                                                    <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; line-height: 16px;">
                                                        Republier la consultation auprès d'autres Professionnels
                                                    </p>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding:0 16px 16px 16px">
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                            <a href="{$url}panel-paciente/consultaexpress/vencidas-{$consulta.idconsultaExpress}.html" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #F95450; text-decoration: none; border-radius: 4px;">Voir Conseil expirée</a>
                                        </p>

                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>

                <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding:0 16px 0px 16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                Salutations,  <br>
                                L'équipe WorknCare
                            </p>
                        </td>
                    </tr>
                </table>

                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding: 4px 16px;">
                            <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">
                                Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. 
                                Si {$email} n'est pas votre compte sur WorknCare, envoyez-nous s'il vous plait un email à <a href="mailto:support@workncare.io">support@workncare.io</a>  pour déconnecter votre adresse email de ce compte.                                    
                            </p>
                        </td>
                    </tr>
                </table>
                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td align="center" style="padding-top:24px;">
                            <img src="{$url}mails/workncare-logo-bw.png" alt="workncare" style="border:none"/>
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


