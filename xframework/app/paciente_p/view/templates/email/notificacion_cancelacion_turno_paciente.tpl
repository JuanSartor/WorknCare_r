<body style="margin:0;padding:0">
    <table width="100%" border="0" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
        <tr>
            <td bgcolor="#F7F7F7">

                <table width="600" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td><img src="{$IMGS}logo_workncare_color.png" alt="DoctorPlus" style="border:none;"/></td>
                    </tr>
                </table>
                <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">

                    <tr>
                        <td style="margin-top:0px; padding-top:0px">

                            <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                <tr>
                                    <td style="padding:16px">
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif"><span style="color:#31A592; font-size:18px">Bonjour {$medico.titulo_profesional.titulo_profesional} {$medico.nombre} {$medico.apellido}</span></p>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="padding:0 16px 16px 16px">
                                        <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                            <tr>
                                                <td>
                                                    <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                                        <tr>
                                                            <td>

                                                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif"><strong>Nous vous informons que le {if $turno_videoconsulta==1} rendez-vous de Vidéo Consultation {else} rendez-vous au cabinet{/if} avec le patient {$paciente_turno.nombre} {$paciente_turno.apellido} est anulée</strong></p>

                                                            </td>
                                                        </tr>

                                                        <tr>
                                                            <td style="padding-top:16px">

                                                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">Motif: {$motivo|escape:"htmlall"}</p>

                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>

                                            <tr>
                                                <td style="padding:16px;text-align:center;">
                                                    <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                                        <a href="{$url}medico.php?&modulo=agenda&submodulo=agenda_diaria&fecha={$turno.fecha|date_format:"%d/%m/%Y"}&idconsultorio={$turno.consultorio_idconsultorio}" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #F95450; text-decoration: none; border-radius: 4px;">Voir l'agenda</a>
                                                    </p>

                                                </td>
                                            </tr>

                                        </table>
                                    </td>
                                </tr>
                            </table>
                            <table width="100%" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                <tr style="border-top: 1px #ccc solid;">
                                    <td>
                                        <table width="100%" align="left" bgcolor="#ffffff" border="0" valign="top" cellpadding="6" cellspacing="0" style="border-collapse:collapse">
                                            <tr  align="left">
                                                <td width="64"  align="left">
                                                    <img src="{$url}mails/doctor.png" >
                                                </td>
                                                <td align="left">
                                                    <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif">
                                                        {$paciente_turno.nombre} {$paciente_turno.apellido}
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
                                                        {$fecha_turno}hs
                                                    </p>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                {if $consultorio.is_virtual=="0"}
                                    <tr style="border-top: 1px #ccc solid;">
                                        <td>
                                            <table width="100%" align="left" bgcolor="#ffffff" border="0" valign="top" cellpadding="6" cellspacing="0" style="border-collapse:collapse">
                                                <tr align="left">
                                                    <td width="64"  align="left">
                                                        <img src="{$url}mails/map.png" >
                                                    </td>
                                                    <td align="left">
                                                        <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif">
                                                            Cabinet Présentiel - {$consultorio.direccion} {$consultorio.numero}<br>
                                                            {$consultorio.localidad}, {$consultorio.pais}
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
                                                    <td width="64" align="left"><img src="{$url}mails/map-virtual.png"  width="42" height="42"> </td>
                                                    <td  align="left">
                                                        <p style="color:#415B70; font-size:17px; font-family:'Helvetica', Arial, sans-serif">Le cabinet connecté</p>
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


                    <tr>
                        <td>
                            <table width="100%" align="center" bgcolor="#fff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; margin-top:0px;">
                                            Salutations,  <br>
                                            L'équipe WorknCare
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
                                            Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. 
                                            Si {$email} n'est pas votre compte sur WorknCare, envoyez-nous s'il vous plait un email à <a href="mailto:support@workncare.io">support@workncare.io</a>  pour déconnecter votre adresse email de ce compte.                                    
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
                            <img src="{$url}mails/workncare-logo-bw.png" alt="workncare" style="border:none"/>
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

