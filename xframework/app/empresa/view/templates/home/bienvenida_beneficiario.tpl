<style>
    body{
        margin-top:20px !important;
    }
</style>
<div>
    <div class="header-container">
        <h1><span>{"El bono de bienestar 100% digital!"|x_translate}</span></h1>
    </div>
    <div class="description-content">
        <p style="margin-bottom:0px;"><strong style="color:#02b8c1;">{"Hola!"|x_translate}</strong></p>
        <p><strong>{"Nos complace enviarle un"|x_translate}</strong> <strong style="color:#ED799E;">Pass.</strong></p>
        <p class="texto-debajo-bonjour"> 
            {"Como parte de su política de prevención y calidad de vida en el trabajo, su empleador ha optado por financiar una serie de servicios para usted que luego puede utilizar de forma privada, por ejemplo:"|x_translate}
            <br>
            <br><i class="fa fa-check-square check-color"></i>{"Haz una pregunta a un profesional y chatea con él"|x_translate}       
            <br><i class="fa fa-check-square check-color"></i>{"Tener una sesión con un profesional en Visio"|x_translate}       
            <br><i class="fa fa-check-square check-color"></i>{"Reembolsarle los servicios presenciales (por ejemplo: sesión de osteo, sofrólogo, membresía de gimnasio, tratamiento de Yves Rocher, MyzenTV, etc.)"|x_translate} 
        </p>
        <p> 
            <span class="resaltador">{"Debe registrarse con sus IDENTIFICADORES PERSONALES (¡no use su correo electrónico profesional!)."|x_translate}</span>&nbsp;
            {"Su empleador sólo interviene para la financiación y no tiene acceso a ninguna información que le concierna: consulta con total CONFIDENCIALIDAD."|x_translate}
        </p>
        <h5>{"¡Esperamos que el Pase de Salud pueda ayudarlo!"|x_translate}</h5>

        <div class='okm-row'>
            <form id="form-mensaje-complementario" class="mensaje-complementario"  role="form" action="{$url}{$controller}.php?action=1&modulo=home&submodulo=mensaje_complementario_form" method="POST" onsubmit="return false;">
                <input type="hidden" name="id" value="{$contratante.idusuario_empresa}">
                <input type="hidden" name="codigo_pass" value="{$contratante.codigo_pass}">
                <textarea name="mensaje_complementario" placeholder='{"Mesaje opcional"|x_translate}' id="mensaje-complementario" maxlength="800" rows="4">{$contratante.mensaje_complementario}</textarea>
                <span class="aclarion-mensaje">* {"Usted puede dejar su propio mensaje para sus beneficiarios"|x_translate}</span>
                <button class="btn btn-guardar-mensaje btn-default btn-xs">{"guardar"|x_translate}</button>
            </form>
        </div>

        <div class="card-pass-sante">
            <div class="card">
                <div class="card-logo">
                    <img  src="{$IMGS}logo_pass_bienetre.png"/>
                </div>
                <h4 class="title">{"Código del Plan de Salud"|x_translate} </h4>
                <div class="codigo">{$plan_contratado.codigo_pass}</div>
                <p>
                    {"El código de acceso le permite beneficiarse de las condiciones de soporte en nuestra plataforma."|x_translate}
                </p>
            </div>
        </div>
        <div class="firma">
            <p>{"Cordialmente"|x_translate}</p>
            <p>{$contratante.nombre} {$contratante.apellido}</p>
            {if $contratante.empresa!=""}
                <p>{$contratante.empresa|@htmlentities}</p>
            {/if}
        </div>
    </div>
    <div class="okm-row">
        <div class="mapc-registro-form-row center col-xs-12">
            <a href="javascript:;" class="btn-default btn-incribirme">{"Yo me inscribo"|x_translate}</a>
        </div>
    </div>
    <div class="resumen-pass">
        <h4>{"¿Qué se puede hacer con el Pase de Salud?"|x_translate}</h4>
        <p>{"Acceso a más de 100 profesionales en el marco de 17 programas en Salud y Bienestar."|x_translate}</p>
    </div>

    <div class="resumen-pass okm-row">
        <h4 class="saber-mas">{"Saber más"|x_translate}:</h4>
        <div class="col-md-12 link-brochure-container">
            <div class="row">
                <a class="link-brochure" href="{$url}brochure_passbienetre.pdf" target="_blank">
                    <img src="{$IMGS}passbienetre_minuatura_brochure.jpg" />
                    {"Presentación pase de bien estar"|x_translate}
                </a>
            </div>
        </div>
        <div class="col-md-8 col-md-offset-2">
            <div class="row">
                <iframe width="100%" height="310"  src="https://www.youtube.com/embed/V0-PRBAITuU" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>            
            </div>
        </div>
    </div>

</div>
{literal}
    <script>
        $(function () {
            $(".btn-guardar-mensaje").click(function (e) {
                e.preventDefault();
                if ($("#mensaje-complementario").val() != "") {

                    $("body").spin("large");
                    x_sendForm($('#form-mensaje-complementario'), true, function (data) {
                        $("body").spin(false);
                        x_alert(data.msg);
                    });
                }


            });

        });
    </script>
{/literal}
