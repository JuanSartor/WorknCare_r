<!-- -->
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
                            <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold"><span style="color:#F33243; font-size:18px">Bonjour {$paciente_titular.nombre} {$paciente_titular.apellido}</span></p>
                            <p style="color:#415B70;font-weight:bold; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                Le professionnel que vous avez consulté a rédigé son compte-rendu. 
                            </p>
                        </td>
                    </tr>



                    <tr>
                        <td style="padding:10px 16px 16px 16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                <a href="{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$consulta.idperfilSaludConsulta}" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #F95450; text-decoration: none; border-radius: 4px;">Voir conclusions</a>
                            </p>
                            {* <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                            ou suivez ce lien pour accéder à la Consultation finalisée. 
                            </p>
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                            <a style="text-decoration:none;  color:#415B70; font-weight:bold" class="rsp-lnk" href="{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$consulta.idperfilSaludConsulta}" target="_blank">{$url}panel-paciente/perfil-salud/registros-consultas-medicas-detalle/{$consulta.idperfilSaludConsulta}</a>
                            </p>*}
                        </td>
                    </tr>

                    <tr>
                        <td style="padding:0 16px 16px 16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; ">
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
                                Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. Si {$usuario.email} n'est pas votre compte sur WorknCare, envoyez-nous s'il vous plait un email à support@workncare.io pour déconnecter votre adresse email de ce compte.
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