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
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">Bonjour </p>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">Ce message vous a été envoyé par:  </p>
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
                                                    {if $paciente.imagen.perfil!=""}
                                                        <img src="{$paciente.imagen.perfil}" alt="{$paciente.nombre} {$paciente.apellido}" style="border:none; border-radius:50%;"/>
                                                    {else}
                                                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="{$paciente.nombre} {$paciente.apellido}" style="border:none; border-radius:50%;"/>
                                                    {/if}         
                                                </td>
                                                <td  valign="middle">
                                                    <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; font-weight:bold;">
                                                        {if $paciente.sexo==1}Mr.{else}Mme.{/if} {$paciente.nombre} {$paciente.apellido} 
                                                    </p>

                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">à travers la plateforme de téléconsultation doctorplus ({$url}). Celui-ci a réalisé une téléconsultation avec son médecin, qui lui a adressé une ordonnance dématérialisée. </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td  valign="middle">
                                        <p style="color:#415B70; font-size:16px; text-align:center; font-family:'Helvetica', Arial, sans-serif; font-weight:bold;">
                                            Le patient a choisi votre pharmacie pour la délivrance de ses médicaments.
                                        </p>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="color:#000000; font-weight:bold; font-size:16px; font-family:'Helvetica', Arial, sans-serif">Comment procéder?  </p>
                                    </td>
                                </tr>

                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            <span style="font-weight:bold">1)</span>   Cliquez sur le lien ci-dessous vous permettant d'accéder à l'espace pharmacie
                                        </p>

                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            <span style="font-weight:bold">2)</span> Entrez le code d'accès que vous allez maintenant recevoir dans un deuxième e-mail 
                                        </p>

                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            <span style="font-weight:bold">3)</span> Visualisez l'ordonnance du patient et vérifiez si vous pouvez délivrer tous les médicaments
                                        </p>

                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            <span style="font-weight:bold">4)</span> Imprimez l'ordonnance
                                        </p>

                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            <span style="font-weight:bold">5)</span> Vérifiez l'identité du patient lorsqu'il se présentera à votre pharmacie
                                        </p>

                                    </td>
                                </tr>

                                <tr>
                                    <td >
                                        <p style="color:#415B70; text-align:center; font-size:16px;font-weight:bold; font-family:'Helvetica', Arial, sans-serif;">
                                            Attention, l'ordonnance ne pourra plus être délivrée après avoir été imprimée!
                                        </p>

                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="color:#000000; text-align:center; font-size:16px;font-weight:bold; font-family:'Helvetica', Arial, sans-serif;">
                                            VEUILLEZ CLIQUER SUR CE LIEN:
                                        </p>

                                    </td>
                                </tr>

                                <tr>
                                    <td >
                                        <p style="color:#000000; text-align:center; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            <a href="{$url}ordonnance/{$receta.codigo}" target="_blank"><span style="font-weight:bold">{$url}ordonnance/{$receta.codigo}</span></a>                                   
                                        </p>

                                    </td>
                                </tr>


                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-weight:bold;font-family:'Helvetica', Arial, sans-serif;">
                                            Prescription par voie électronique
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td >
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            La loi du 13 août 2004 relative à l'Assurance maladie (art. 34) a introduit la possibilité de prescrire des soins ou des médicaments par courriel, sous réserve que certaines conditions soient remplies:
                                        </p>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            - Le prescripteur doit être clairement identifié.
                                        </p>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            - L'ordonnance doit être « établie, transmise et conservée dans des conditions propres à garantir son intégrité et sa confidentialité ».
                                        </p>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            - Le médecin doit avoir préalablement procédé à l'examen clinique du patient, sauf exceptionnellement en cas d'urgence.
                                        </p>
                                    </td>
                                </tr


                                <tr>
                                    <td >
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            Salutations, <br>
                                            L'équipe WorknCare
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>

                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td >
                            <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">

                                Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. 


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
