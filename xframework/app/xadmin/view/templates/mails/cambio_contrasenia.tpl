<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Documento sin título</title>
    </head>

    <body style="background-color:#F7F7F7; font-family:Arial, Helvetica, sans-serif; font-size:1em;">

        <div style="padding:20px 30px; max-width:700px;">

            <a href="http://www.workncare.io" title="WorknCare"><img src="{$url}mails/mail_logo.png" width="373" height="80"  border="0" /></a>
            <div style="background-color:#FFF; padding:30px 20px; margin-top:20px;" style="font-size:12px;">

                <p>Hola, {$usuario.nombre}:</p>

                <p>La contraseña para tu cuenta de DoctorPlus, {$usuario.email}, se ha cambiado recientemente.<br />
                    Si la has cambiado, no necesitas realizar ninguna otra acción.</p>

                <p>Si no la has cambiado, es posible que tu cuenta haya sido vulnerada. Para poder volver a iniciar sesión en tu cuenta, 
                    deberás restablecer la contraseña.</p>
                <p>
                    <a href="{$url}recuperacion_contrasenia/{$hash}.html" target="_blank"  title="Recuperar contraseña"><img border="0"  src="{$url}mails/mail_btn_recuperar.png"  alt="Recuperar contraseña" style="vertical-align:middle" /></a> o a través de este link <a href="{$url}recuperacion_contrasenia/{$hash}.html"  alt="Recupere su Contraseña Aquí">{$url}recuperacion_contrasenia/{$hash}.html</a>
                    <br /><br />
                </p>
                <p>
                    Atentamente, <br />
                    El equipo de DoctorPlus
                </p>

                <p style="font-size:10px;">Esta dirección de correo electrónico no admite respuestas. Para obtener más información, visita el Centro de ayuda de DoctorPlus. 	
                    Si {$usuario.email} no es tu cuenta de DoctorPlus, envianos un email a <a href="mailto:unsubscribe@workncare.io">unsubscribe@workncare.io</a> para desconectar tu dirección de correo electrónico de esta cuenta. 
                </p>

            </div>

            <div style="text-align:center; margin:20px 0px;">
                <a href=""  title="Políticas de Privacidad"><img src="{$url}mails/mail_link_politicas.png" width="266"  border="0" height="62" alt="Políticas de Privacidad" title="Políticas de Privacidad" longdesc="http://www.workncare.io/politicas-de-privacidad.html" /></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a href="" alt="Soporte Técnico"><img src="{$url}mails/mail_link_soporte.png" width="266" height="62" border="0"  alt="Soporte Técnico" title="Soporte Técnico" longdesc="http://www.workncare.io/soporte.html" /></a>
            </div>

            <div style="text-align:center; margin:20px 0px;">
                <img src="{$url}mails/mail_logo_footer.png" width="313" height="58"  border="0" title="WorknCare 2023 - Tous droits réservés" />
            </div>        
        </div>

    </body>
</html>
