
<body style="margin:0;padding:0">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
        <tr>
            <td bgcolor="#F7F7F7" style="padding: 24px 0">

                <table width="600" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td><img src="{$url}mails/doctorplus-logo.png" alt="DoctorPlus" style="border:none;"/></td>
                    </tr>
                </table>

                <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="12" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td>
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold"><span style="color:#31A592; font-size:18px">Bonjour {$usuario.nombre} {$usuario.apellido}</span></p>
                            <p style="color:#415B70; font-size:14px; font-family:'Helvetica', Arial, sans-serif">
                                Le service administratif de DoctorPlus a réinitialisé votre mot de passe:
                            </p>
                            <p  style="color:#415B70; font-size:14px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold">
                                Compte:{$usuario.username}
                            </p>
                            <p  style="color:#415B70; font-size:14px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold">
                                Nouveau mot de passe:{$password}
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>
                            <a href="{$url}extranet.php" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #F95450; text-decoration: none; border-radius: 4px; font-family:'Helvetica', Arial, sans-serif">Me connecter</a>

                        </td>
                    </tr>


                    <tr>

                    </tr>
                    <tr>
                        <td>
                            <p style="color:#415B70; font-size:14px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold">
                                Salutations, <br>
                                L'équipe DoctorPlus 
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p style="color:#999999; font-size:11px; font-family:'Helvetica', Arial, sans-serif; text-align:left; line-height:14px">
                                Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d’informations, veuillez-vous rapprochez de notre équipe support. 
                                Si {$usuario.email} ne correspond pas à votre compte sur DoctorPlus, envoyez-nous s’il vous plait un email à <a style="text-decoration:none; line-height:14px; color:#415B70; font-weight:bold" class="rsp-lnk" href="mailto:desinscription@doctorplus.eu">desinscription@doctorplus.eu</a> pour déconnecter votre adresse email de ce compte. 
                            </p>
                        </td>
                    </tr>
                </table>
                <table width="600" align="center" border="0" valign="top" cellpadding="24" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td align="center">
                            <img src="{$url}mails/doctor-plus-logo-bw.png" alt="DoctorPlus" style="border:none"/>
                        </td>
                    </tr>
                </table>
                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td align="center">
                            <p style="color:#999999; font-size:11px; font-family:'Helvetica', Arial, sans-serif; text-align:center">&copy; {$smarty.now|date_format:"%Y"} DoctorPlus, Tous droits réservés.</p>
                        </td>
                    </tr>
                </table>
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