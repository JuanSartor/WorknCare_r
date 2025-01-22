
<body style="margin:0;padding:0">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
        <tr>
            <td bgcolor="#F7F7F7" style="padding: 24px 0; background-color: white;">

                <table width="600" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td><img src="{$IMGS}logo_workncare_color.png" alt="WorknCare" style="border:none;"/></td>

                    </tr>
                </table>

                <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="12" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td>
                            <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold"><span style="color:#31A592; font-size:18px">Hello {$usuario.nombre} {$usuario.apellido}</span></p>
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                Malheureusement aujourd'hui vous n'êtes pas le gagnant :(
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <p style="color:#31A592; font-size:15px; font-family:'Helvetica', Arial, sans-serif">
                                Mais nouns vous invitons a participer a la prochaine occasion ou vous aurez sûrement plus de chance!
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                Salutations, <br>
                                Équipe WorknCare 

                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="z-index: 1000; position: relative; top: 120px;">
                            <a href="{$url}" target="_blank" style="padding: 8px 205px; color: #fff; background-color: #ED799E; text-decoration: none; border-radius: 4px;">www.workncare.io</a>

                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:left; line-height:14px">
                                Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d’informations, veuillez-vous rapprochez de notre équipe support. 
                                Si {$usuario.email} ne correspond pas à votre compte sur WorknCare, envoyez-nous s’il vous plait un email à <a style="text-decoration:none; line-height:14px; color:#415B70; font-weight:bold" class="rsp-lnk" href="mailto:support@workncare.io">support@workncare.io</a> pour déconnecter votre adresse email de ce compte. 
                            </p>
                        </td>
                    </tr>
                </table>
                <table width="600" align="center" border="0" valign="top" cellpadding="24" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td align="center">
                            <img src="{$url}mails/workncare-logo-bw.png" alt="WorknCare" style="border:none"/>
                        </td>
                    </tr>
                </table>
                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td align="center">
                            <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">Copyright &copy; {$smarty.now|date_format:"%Y"} WorknCare, Tous droits réservés.</p>
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