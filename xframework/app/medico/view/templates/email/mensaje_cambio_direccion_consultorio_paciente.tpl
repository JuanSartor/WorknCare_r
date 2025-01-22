<body style="margin:0;padding:0">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
        <tr>
            <td bgcolor="#F7F7F7" style="padding: 24px 0">

                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding:12px 0"><img src="{$IMGS}logo_workncare_color.png" alt="workncare" style="border:none"/></td>
                    </tr>
                </table>

                <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding:16px">
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif"><span style="color:#F33243; font-size:18px">Bonjour {$paciente.nombre} {$paciente.apellido} </span></p>
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
                                                    {if $medico.images.perfil!=""}
                                                        <img src="{$medico.images.perfil}" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}" style="border:none; border-radius:50%;"/>
                                                    {else}
                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}" style="border:none; border-radius:50%;"/>
                                                    {/if}                                                    </td>
                                                <td style="padding:16px" valign="middle">
                                                    <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold;">
                                                        <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html"  class="rsp-lnk" target="_blank"  style="color:#31A592; text-decoration:none">{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}</a>  a changé l'adresse de son cabinet de consultation.
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
                                    <td style="padding:16px">
                                        <p style="color:#415B70; font-size:16px; font-weight:bold; font-family:'Helvetica', Arial, sans-serif">
                                            Vous avez le Rendez-vous Nº {$turno.idturno} -  {$turno.fecha_str}hs 
                                        </p>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                            Cabinet de consultation: {if $consultorio.is_virtual=="0"} Cabinet Présentiel - {$consultorio.direccion} {$consultorio.numero}, {$consultorio.localidad} - {$consultorio.provincia}{else}Cabinet Virtuel{/if}
                                        </p>
                                    </td>
                                </tr>
                                {if $consultorio.is_virtual=="0"}
                                    <tr>
                                        <td colspan="2">
                                            {assign var="url_icon" value="{$url_themes}imgs/icons/ico_pointer_blue.png"}
                                            <a href="http://maps.google.com/maps?z=17&t=m&q=loc:{$consultorio.lat}+{$consultorio.lng}" ><img src="https://maps.googleapis.com/maps/api/staticmap?maptype=roadmap&markers=icon:{$url_icon}|{$consultorio.lat},{$consultorio.lng}&zoom=16&size=640x400&key={$GOOGLE_MAPS_KEY}"/></a>
                                        </td>
                                    </tr>
                                {/if}

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

                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td style="padding: 4px 16px;">
                            <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">
                                Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. 
                                Si {$paciente.email} n'est pas à votre compte sur WorknCare, envoyez-nous s'il vous plait un email à  <a href="mailto:support@workncare.io">support@workncare.io</a> pour déconnecter votre adresse email de ce compte. 
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
