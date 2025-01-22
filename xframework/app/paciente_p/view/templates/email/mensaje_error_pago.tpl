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
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            Nous vous avons envoyé cet e-mail car nous n'avons pas pu traiter votre paiement pour votre {if $tipo=="consultaexpress"}Conseil Nº {$consulta.numeroConsultaExpress}{else}Vidéo Consultation Nº {$consulta.numeroVideoConsulta}{/if} 
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    {if $movimiento}
                                        <td>
                                            <p><strong>Montant:</strong> 
                                                &euro;{$movimiento.monto}
                                            </p>
                                            {if $metodo_pago.card}
                                                <p><strong>Carte:</strong> 
                                                    {$metodo_pago.card.brand|upper}  **** {$metodo_pago.card.last4}
                                                </p>
                                                <p><strong>Expiration:</strong> 
                                                    {$metodo_pago.card.exp_month}/{$metodo_pago.card.exp_year}
                                                </p>
                                            {/if}
                                        </td>
                                    {/if}
                                </tr>
                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            Cela peut se produire si votre carte de crédit a expiré ou a été annulée et que nous n'avons pas reçu d'informations de paiement valides de votre part.
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif;">
                                            Veuillez mettre à jour votre compte de facturation avec des informations de paiement valides  
                                        </p>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                            <a href="{$url}panel-paciente/estado-cuenta/" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #F95450; text-decoration: none; border-radius: 4px;">Payer</a>
                                        </p>
                                    </td>
                                </tr>

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
                    Salutations, <br>
                    L'équipe WorknCare
                </p>
            </td>
        </tr>
    </table>

    <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
        <tr>
            <td style="padding: 4px 16px;">
                <p style="color:#999999; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">
                    Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. Si {$paciente.email} n'est pas votre compte sur DoctorPlus, envoyez-nous s'il vous plait un email à support@workncare.io pour déconnecter votre adresse email de ce compte. 
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


