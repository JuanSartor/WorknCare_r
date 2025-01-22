

<div style="background-color:#F7F7F7; font-family:Arial, Helvetica, sans-serif; font-size:1em;">

    <div style="padding:20px 30px; max-width:700px;">

        <a href="http://www.workncare.io" title="WorknCare"><img src="{$url}mails/mail_logo.png" width="373" border="0" height="80" /></a>
        <div style="background-color:#FFF; padding:30px 20px; margin-top:20px;" style="font-size:12px;">

            <h3>Rappel d'événement<span style="color:#ED3545"> {$usuario.nombre} {$usuario.apellido}</span></h3>

            <p >L'e-mail vous est envoyé pour vous rappeler d'un événement planifié.<br /><br />

                <strong>
                    {$evento.comentario}
                </strong>
                <br /><br />
                <a href="{$url}"  alt="Ingrese a WorknCare"><img  border="0" src="mail_btn_activar_paciente.png"   alt="Ingrese a WorknCare" style="vertical-align:middle" /></a> ou accédez à votre compte via ce lien <a href="{$url}" >{$url}</a>
                <br /><br />
            <div style="color:#ED3545;">Se connecter facilement</div>
            <h1  style="color:#31A592; margin-top:0px; font-size:24px; font-weight:normal;">NOUS SOIGNONS MIEUX DE NOTRE SANTÉ</h1>
            <br />
            </p>
            <p>
                Profitez-en!
            </p>
            <p>
                Salutations, <br>
                L’équipe WorknCare
            </p>

            <p style="font-size:10px;">                            
                Cette adresse email ne permet pas de recevoir de réponse. Si vous avez besoin de plus d'informations, veuillez-vous rapprochez de notre équipe support. Si {$usuario.email} n'est pas votre compte sur WorknCare, envoyez-nous s'il vous plait un email à <a href="mailto:support@workncare.io">support@workncare.io</a> pour déconnecter votre adresse email de ce compte. 
            </p>


        </div>

        <div style="text-align:center; margin:20px 0px;">
            <a href=""  title="Políticas de Privacidad"><img src="{$url}mails/mail_link_politicas.png" border="0" width="266" height="62" alt="Políticas de Privacidad" title="Políticas de Privacidad" longdesc="http://www.WorknCare.io/politicas-de-privacidad.html" /></a>
            &nbsp;&nbsp;&nbsp;&nbsp;
            <a href="" alt="Soporte Técnico"><img src="{$url}mails/mail_link_politicas.png" width="266" border="0" height="62" alt="Soporte Técnico" title="Soporte Técnico" longdesc="http://www.workncare.io/soporte.html" /></a>
        </div>

        <div style="text-align:center; margin:20px 0px;">
            <img src="{$url}mails/mail_logo_footer.png" width="313" height="58"  border="0"/>
        </div>        
    </div>

</div>

