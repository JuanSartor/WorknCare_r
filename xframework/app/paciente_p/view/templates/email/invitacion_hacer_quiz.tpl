<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <title></title>
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width">
    </head>
    <body style="margin:0;padding:0">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
            <tr>
                <td bgcolor="#FFFFFF" style="padding: 24px 0">

                    <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td>
                                <div style="margin-top: 50px; background: #ED799E; width: 800px; height: 60px; border-top-right-radius: 40px; border-bottom-left-radius: 40px; text-align: center;">
                                    <h2 style="font-size: 25px; color: white; font-weight: 700; padding-top: 15px;">{"ENCUESTA - PRUEBA TU SUERTE PARA GANAR UN BENEFICIO"|x_translate}</h2>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <table width="600" align="center" bgcolor="#ffffff" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                        <tr>
                            <td style="padding:16px">
                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif"><span style="color: #3db9c6; font-size: 22px; font-weight: 600;">Bonjour</span></p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:0 16px 0px 16px">
                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                    {"Tómese unos minutos para responder a estas preguntas. Esta encuesta es anónima."|x_translate}
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:0 16px 0px 16px">
                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif">
                                    {"En agradecimiento, estamos ofreciendo X servicios a los participantes, otorgados en forma de lotería."|x_translate}
                                    <span style="font-weight: 700;">{"Abre tu cuenta Pass Bien-etre para recibir tu beneficio si has ganado!"|x_translate}</span>
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:0 16px">
                                <p style="color:#ED799E; font-size:16px; font-family:'Helvetica', Arial, sans-serif; font-weight: 600; text-align: center;">
                                    {"Comienza el cuestionario"|x_translate}
                                </p>
                                <p style="color:#415B70; font-size:20px; font-family:'Helvetica', Arial, sans-serif; text-align: center;">
                                    <a href="{$url}profesional/registro-medico.html" target="_blank" style="padding: 8px 16px; color: #fff; background-color: #3db9c6; text-decoration: none; border-radius: 6px;">Me registro para probar suerte
                                    </a>
                                </p>
                            </td>
                        </tr>
                        <tr>
                            <td style="padding:0 16px 0px 16px">
                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; width: 460px; margin-inline: auto;">
                                    <mark>  {"Debes registrarte con tus IDENTIFICADORES PERSONALES para intentar ganar el servicio (¡no uses tu correo profesional!)"|x_translate}</mark>
                                </p>
                            </td>
                        </tr>

                        <tr>
                            <td style="padding:0 16px 0px 16px">
                                <p style="color:#415B70; font-size:16px; font-family:'Helvetica', Arial, sans-serif; margin-top: 30px;">
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
</html>
