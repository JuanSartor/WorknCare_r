<body style="margin:0;padding:0">
    <table width="100%" border="0" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
        <tr>
            <td bgcolor="#F7F7F7">

                <table width="600" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td><img src="{$IMGS}logo_workncare_color.png" alt="WorknCare" style="border:none;"/></td>
                    </tr>
                </table>
                <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td>
                            <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                <tr>
                                    <td>

                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">Rappel de rendez-vous {if $turno_videoconsulta==1}en Visio {/if} demandé pour </p>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; text-align:center; margin-top: 5px; margin-bottom: 5px;"><span style="color:#F33243; font-size:18px">{$turno.nombre_paciente} {$turno.apellido_paciente}</span></p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td style="margin-top:0px; padding-top:0px">
                            <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                <tr style="border-top: 1px #ccc solid;">
                                    <td>
                                        <table width="100%" align="left" bgcolor="#ffffff" border="0" valign="top" cellpadding="6" cellspacing="0" style="border-collapse:collapse">
                                            <tr  align="left">
                                                <td width="64"  align="left">
                                                    <img src="{$url}mails/doctor.png">
                                                </td>
                                                <td align="left">
                                                    <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif">
                                                        {$medico.tituloprofesional} {$medico.nombre} {$medico.apellido} <br>
                                                        {$medico.mis_especialidades.0.especialidad}
                                                    </p>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr style="border-top: 1px #ccc solid;">
                                    <td>
                                        <table width="100%" align="left" bgcolor="#ffffff" border="0" valign="top" cellpadding="6" cellspacing="0" style="border-collapse:collapse">
                                            <tr align="left">
                                                <td width="64"  align="left">
                                                    <img src="{$url}mails/calendario.png" >
                                                </td>
                                                <td align="left">
                                                    <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif">
                                                        {$fecha_turno}
                                                    </p>
                                                </td>
                                            </tr>
                                        </table>
                                </tr>
                                {if $consultorio.is_virtual=="0"}
                                    <tr style="border-top: 1px #ccc solid;">
                                        <td>
                                            <table width="100%" align="left" bgcolor="#ffffff" border="0" valign="top" cellpadding="6" cellspacing="0" style="border-collapse:collapse">
                                                <tr align="left">
                                                    <td width="64"  align="left">
                                                        <img src="{$url}mails/map.png" >
                                                    </td>
                                                    <td  align="left">
                                                        <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif">
                                                            Cabinet Présentiel - {$consultorio.direccion} {$consultorio.numero}<br>
                                                            {$consultorio.localidad}, {$consultorio.provincia}
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>

                                    </tr>
                                {else}
                                    <tr style="border-top: 1px #ccc solid;">
                                        <td>
                                            <table width="100%" align="left" bgcolor="#ffffff" border="0" valign="top" cellpadding="6" cellspacing="0" style="border-collapse:collapse">
                                                <tr align="left">
                                                    <td width="64"  align="left"><img src="{$url}mails/map-virtual.png"  width="42" height="42"> </td>
                                                    <td align="left">
                                                        <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif">Cabinet Virtuel</p>
                                                    </td>
                                                </tr>
                                            </table>								
                                        </td>
                                    </tr>
                                {/if}
                                {if $consultorio.is_virtual=="0"}
                                    <tr>
                                        <td colspan="2">
                                            {assign var="url_icon" value="{$url_themes}imgs/icons/ico_pointer_blue.png"}
                                            <a href="http://maps.google.com/maps?z=17&t=m&q=loc:{$consultorio.lat}+{$consultorio.lng}"><img src="https://maps.googleapis.com/maps/api/staticmap?maptype=roadmap&markers=icon:{$url_icon}|{$consultorio.lat},{$consultorio.lng}&zoom=16&size=640x400&key={$GOOGLE_MAPS_KEY}"/></a>
                                        </td>
                                    </tr>
                                {/if}
                            </table>
                        </td>
                    </tr>
                    {if $turno.estado==1}
                        {if $turno_videoconsulta!="1"}
                            <tr>
                                <td>
                                    <table width="100%" align="center" bgcolor="#f6f6f6" border="0" valign="top" cellpadding="12" cellspacing="0" style="border-collapse:collapse">
                                        <tr>
                                            <td>
                                                <p style="color:#34495e; font-size:17px; font-family:'Helvetica', Arial, sans-serif; margin-bottom: 6px;">
                                                    <strong>Numéro de Rendez-vous: {$turno.idturno}</strong>
                                                </p>	
                                                <span style="color:#34495e; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                                    Veuillez s’il vous plait utiliser ce numéro à l’accueil / secrétariat
                                                </span>				
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        {else}
                            <tr>
                                <td>
                                    <table width="100%" align="center"  border="0" valign="top" cellpadding="12" cellspacing="0" style="border-collapse:collapse">
                                        <tbody>
                                            <tr>
                                                <td align="center">
                                                    <a href="{$url}patient/checkrtc.html" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #23b89f; text-decoration: none; border-radius: 4px;">Démarrer le test d'utilisation</a>									
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <table width="100%" align="center" bgcolor="#f6f6f6" border="0" valign="top" cellpadding="12" cellspacing="0" style="border-collapse:collapse">
                                        <tr>
                                            <td>
                                                <p style="color:#34495e; font-size:17px; font-family:'Helvetica', Arial, sans-serif; margin-bottom: 6px;">
                                                    <strong>Numéro de Rendez-vous de Vidéo Consultation: {$turno.idturno}</strong>											
                                                </p>	
                                                <span style="color:#34495e; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                                    Une fois que le Professionnel vous appelle, n'oubliez pas que vous avez {$VIDEOCONSULTA_VENCIMIENTO_SALA} minutes pour entrer dans le Cabinet virtuel. Soyez attentifs car une fois le délai passé, le Professionnel pourra prendre une autre consultation!
                                                </span>										
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        {/if}


                        <tr>
                            <td>
                                <table width="100%" align="center" bgcolor="#fff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                    <tr>
                                        <td>
                                            {if $turno_videoconsulta!="1"}
                                                <p style="color:#415B70; font-size:12px; font-family:'Helvetica', Arial, sans-serif; margin-top:0;">
                                                    Nous vous conseillons de vous présenter au rendez-vous un peu en avance afin de réaliser les vérifications usuelles (carte d'assuré). Si vous avez besoin de modifier ou annuler un rendez-vous, veuillez vous connecter à votre compte sur WorknCare!
                                                </p>
                                            {else}
                                                <p style="color:#415B70; font-size:12px; font-family:'Helvetica', Arial, sans-serif; margin-top:0;">
                                                    Si vous avez besoin de modifier ou annuler un rendez-vous, veuillez vous connecter à votre compte sur WorknCare!
                                                </p>
                                            {/if}
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                    {/if}

                    <tr>
                        <td>
                            <table width="100%" align="center" bgcolor="#fff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; margin-top:0px;">
                                            Salutations, <br>
                                            L’équipe WorknCare
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <table width="100%" align="center" bgcolor="#fff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                <tr>
                                    <td>
                                        <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">
                                            Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. Si {$turno.email} n'est pas votre compte sur WorknCare, envoyez-nous s'il vous plait un email à <a href="mailto:support@workncare.io">support@workncare.io</a> pour déconnecter votre adresse email de ce compte. 

                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>

                <table width="600" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td align="center">
                            <img src="{$url}mails/workncare-logo-bw.png" alt="WorknCare" style="border:none"/>
                        </td>
                    </tr>
                </table>

            </td>
        </tr>
    </table>
    <table width="100%" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
        <tr>
            <td align="center" bgcolor="#3A3D43">
                <p style="color:#FFFFFF; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">&copy; {$smarty.now|date_format:"%Y"} WorknCare, Tous droits réservés.</p>
            </td>
        </tr>
    </table>

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

</body>

