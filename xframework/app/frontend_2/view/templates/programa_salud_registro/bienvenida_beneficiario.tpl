<style>
    body{
        margin-top:20px !important;
    }
    .check-color{
        color: #02b8c1;
        margin-right: 15px;
    }
    .card-logo-socio{
        position: relative;
        left: 310px;
        bottom: 30px;
    }
    @media (max-width: 600px){
        .card-pass{
            position: relative;
            right: 90px;
        }
        .card-logo-socio{
            left: 90px;
        }

    }

    @media (min-width: 600px){
        .logo-workncare{
            width: 120px !important;
            height: 25px !important;
        }

    }
</style>
<div>
    <div class="header-container header-container-nuevo">
    </div>

    <div class="description-content">

        <p style="margin-bottom:0px;"><strong style="color:#F29100;">{"Hola!"|x_translate}</strong></p>
        <p><strong>{"Nos complace enviarle un"|x_translate}</strong> <strong style="color:#02b8c1;">Pass.</strong></p>
        <p class="texto-debajo-bonjour"> 
            <br>
            <br><i class="fa fa-check-square check-color"></i>{"Haz una pregunta a un profesional y chatea con él"|x_translate}       
            <br><i class="fa fa-check-square check-color"></i>{"Tener una sesión con un profesional en Visio"|x_translate}       
            <br><i class="fa fa-check-square check-color"></i>{"Reembolsarle los servicios presenciales (por ejemplo: sesión de osteo, sofrólogo, membresía de gimnasio, tratamiento de Yves Rocher, MyzenTV, etc.)"|x_translate}                 
        </p>
        <p style="font-weight: 600; margin: 0 0 0px; margin-top: 40px;">
            {"Vous devez vous inscrire avec votre"|x_translate}  <span style="color: #02b8c1;" >{"email personnel"|x_translate}</span> {" (ne pas utiliser son email professionnel!)"|x_translate}
        </p>
        <p style="font-weight: 600; margin: 0 0 0px; margin-bottom: 60px;">
            {"Votre employeur n’a pas accès aux informations de votre compte personnel."|x_translate}

        </p>
        <h5 style="text-align: center;" class="h5-mobile">{"¡Utilice este numero para poder inscribirse:"|x_translate}</h5>
        <div class="card-pass-sante">
            <div class="card">
                <div class="card-logo  {if $empresa.image!=''} card-pass {/if}">
                    <img class="logo-workncare"  src="{$IMGS}logo_workncare_color.png"/>
                </div>
                {if $empresa.image!=''}
                    <div class="card-logo card-logo-socio">
                        <img  style="width: 50px; height: 50px;" src="{$empresa.image.perfil}?t={$smarty.now}"/>
                    </div>
                {/if}
                <h4 class="title">{"Su Codigo"|x_translate} </h4>
                <div class="codigo">{$plan_contratado.codigo_pass}</div>
                <p>
                    {"El código de acceso le permite beneficiarse de las condiciones de soporte en nuestra plataforma."|x_translate}
                </p>
            </div>
        </div>

    </div>
    <div class="okm-row">
        <div class="mapc-registro-form-row center col-xs-12">
            {if $smarty.request.modulo=="programa_salud_registro" && $smarty.request.submodulo == "checkout_ok"}
                <a style="background: #F29100;" href="javascript:;" class="btn-default btn-incribirme btn-inscripcion-nuevo">{"Yo me inscribo"|x_translate}</a>
            {else}
                <a style="background: #F29100;" href="{$url}beneficiaire/creer-un-compte.html?pass_esante={$contratante.hash}" target="_blank" class="btn-default btn-incribirme btn-inscripcion-nuevo">{"Yo me inscribo"|x_translate}</a>
            {/if}
        </div>
    </div>
    {**   <div class="resumen-pass">
    <h4 class="h4-mobile">{"¿Qué se puede hacer con el Pase de Salud?"|x_translate}</h4>
    <a href="https://youtu.be/rqT99Q1T61o" target="_blank" class="boton margen-information btn-info-invitacion-beneficiario">{"Informacion"|x_translate}</a>
    </div>**}

    {**   <div class="resumen-pass okm-row">
    <h4 class="saber-mas h4-mobile">{"Saber más"|x_translate}:</h4>
    <div class="col-md-12 link-brochure-container">
    <div class="row">
    <a class="link-brochure texto-link-brochure" href="{$url}Brochure Bénéficiaire Pass Bien-être empleado.pdf" target="_blank">
    <img class="margen-right-brochure-mobile" src="{$IMGS}passbienetre_minuatura_brochure.jpg" />
    {"Presentación pase de bien estar"|x_translate}
    </a>
    </div>
    </div>
    <div class="col-md-8 col-md-offset-2">
    <div class="row">
    <iframe width="100%" height="310"  src="https://www.youtube.com/embed/V0-PRBAITuU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
    </div>
    </div>
    </div> **}

</div>

{if $smarty.request.modulo=="programa_salud_registro" && $smarty.request.submodulo == "checkout_ok"}
    <script>
        var RECAPTCHA_PUBLIC = "{$RECAPTCHA_PUBLIC}";
    </script>
    <script src="https://www.google.com/recaptcha/api.js?hl=fr&render={$RECAPTCHA_PUBLIC}" async defer>
    </script>
    {literal}
        <script>
            $(function () {
                $(".btn-guardar-mensaje").click(function (e) {
                    e.preventDefault();
                    grecaptcha.ready(function () {
                        grecaptcha.execute(RECAPTCHA_PUBLIC, {action: 'submit'}).then(function (token) {
                            $(".g-recaptcha-response").val(token);
                            //limpiamos los tooltip de validacion anteriores



                            if ($("#mensaje-complementario").val() != "") {

                                $("body").spin("large");
                                x_sendForm($('#form-mensaje-complementario'), true, function (data) {
                                    $("body").spin(false);
                                    x_alert(data.msg);
                                });
                            }
                        });
                    });
                });

            });
        </script>
    {/literal}
{/if}