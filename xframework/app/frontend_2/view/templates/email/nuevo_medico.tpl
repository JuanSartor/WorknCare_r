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
                        <td style="padding:16px ">
                            <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold">
                                <span style="color:#31A592; font-size:18px">Un nouveau Professionnel s'est enregistré sur DoctorPlus:</span>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:0 16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                <span style="text-decoration:none; line-height:32px; color:#415B70; font-weight:bold">{$usuario.nombre} {$usuario.apellido}</span>
                            </p>

                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                <span style="text-decoration:none; line-height:32px; color:#415B70; font-weight:bold">Email:  {$usuario.email}</span>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:16px">

                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                            <p>Connectez-vous au panel admin et vérifiez que les informations entrées par le Professionnel sont correctes</p>
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="padding:16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                <a href="{$url}xadmin.php" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #F95450; text-decoration: none; border-radius: 4px;">connecter</a>
                            </p>

                        </td>
                    </tr>
                    <tr>
                        <td style="padding:16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                Cordialement,<br>
                                L’équipe WorknCare
                            </p>
                        </td>
                    </tr>

                </table>
                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding: 4px 16px;">
                            <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">
                                Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support.
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


