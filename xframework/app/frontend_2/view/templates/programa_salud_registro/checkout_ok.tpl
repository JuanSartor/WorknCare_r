<style>
    #Main {
        min-height: 100%;
        background: #02b8c1;
    }
</style>
{include file="programa_salud_registro/menu.tpl"}
{include file="programa_salud_registro/login.tpl"}
<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">
    {*verificamos si se genero la suscripcion para empresa o si se pagó el pack si es obra social*}
    {if ($suscripcion.subscriptionId!="" || $suscripcion.pack_pago_pendiente=="2" || $empresa.contratacion_manual=='1') && $contratante.hash!=""}
        <section class="pass-sante-registro-planes col-xs-12" style="display:none">
            <div class="header-container text-center">
                <div class="logo-container">
                    <img src="{$IMGS}logo_workcnare_blanco.png"/>
                    <span class="label-logo">par DoctorPlus</span>
                </div>
            </div>
            <div class="card-pass-sante">
                <div class="header">
                    <div class="text-center" style="width:60px;">
                        <div class="animationContainer animated rubberBand">
                            <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 85 82" xml:space="preserve">

                            </svg>
                        </div>
                    </div>
                    <h2>{"Crear mis cheques"|x_translate}</h2>
                </div>
                <div class="card">
                    <h4 class="title">{"Código del Plan de Salud"|x_translate} </h4>
                    <div class="codigo">{$plan_contratado.codigo_pass}</div>
                    <p>
                        {"El código de acceso le permite beneficiarse de las condiciones de soporte en nuestra plataforma."|x_translate}
                    </p>

                </div>
                <div class="okm-row">
                    <div class="mapc-registro-form-row center">
                        <a href="javascript:;" class="btn-default btn-generar-link">{"compartir con mis beneficiarios"|x_translate}</a>
                    </div>
                </div>
            </div>
        </section>

        {*preview mensaje bienvenida*}
        <section class="pass-sante-registro-planes bienvenida-preview" >
            <div class="container-header">
                <h2>{"Genera un enlace para enviar directamente a tus beneficiarios"|x_translate}</h2>
                <div class="buttons">
                    <button  href="javascript:;" class="btn-default btn-copy-link" title='{"Copiar el link"|x_translate}' data-toggle="modal" data-target="#modal-compartir-pass">{"Copiar el link"|x_translate}&nbsp; <i class="fa fa-share"></i></button >
                    <a  href="{$url}frontend_2.php?action=1&modulo=programa_salud_registro&submodulo=invitacion_pass_pdf&hash={$empresa.hash}" class="btn-default btn-download" target="_blank">{"Descargar invitación"|x_translate}&nbsp;<i class="fa fa-download"></i></a>
                    <button  href="javascript:;" class="btn-default btn-conectarme" title='{"Conectarme a mi cuenta"|x_translate}'>{"Conectarme a mi cuenta"|x_translate}</button>
                </div>
                <div class="okm-row">
                    <div class="col-xs-12">
                        <div class="disclaimer text-center">
                            <span>
                                {"El mensaje que enviarás a tus beneficiarios"|x_translate}
                            </span>
                            <button class="btn btn-default btn-preview-mensaje">{"VER"|x_translate}</button>
                        </div>

                    </div>

                </div>

            </div>
            <div class="preview-container">

                <div class="preview-mensaje" id="preview-mensaje" style="display:none;">
                    {include file="programa_salud_registro/bienvenida_beneficiario.tpl"}
                </div>

            </div>
            {include file="programa_salud_registro/modal_compartir_pass.tpl"}
        </section>
        {literal}
            <script>
                $(function () {
                    var copyToClipboard = function (elementId) {
                        console.log("copy" + elementId);
                        var input = document.getElementById(elementId);
                        var isiOSDevice = navigator.userAgent.match(/ipad|iphone/i);
                        if (isiOSDevice) {

                            var editable = input.contentEditable;
                            var readOnly = input.readOnly;
                            input.contentEditable = true;
                            input.readOnly = false;
                            var range = document.createRange();
                            range.selectNodeContents(input);
                            var selection = window.getSelection();
                            selection.removeAllRanges();
                            selection.addRange(range);
                            input.setSelectionRange(0, 999999);
                            input.contentEditable = editable;
                            input.readOnly = readOnly;
                        } else {
                            input.select();
                        }

                        document.execCommand('copy');
                    };
                    function CopyToClipboard2(containerid) {
                        if (window.getSelection) {
                            //limpiar seleccion
                            if (window.getSelection().empty) {  // Chrome
                                window.getSelection().empty();
                            } else if (window.getSelection().removeAllRanges) {  // Firefox
                                window.getSelection().removeAllRanges();
                            }

                            var range = document.createRange();
                            range.selectNode(document.getElementById(containerid));
                            window.getSelection().addRange(range);
                            document.execCommand("Copy");
                        } else if (document.selection) {
                            document.selection.empty();
                            var range = document.body.createTextRange();
                            range.moveToElementText(document.getElementById(containerid));
                            range.select().createTextRange();
                            document.execCommand("Copy");
                        }
                        var icon_content = "<div class='text-center'><br><img src='" + BASE_PATH + "xframework/app/themes/dp02/imgs/icon-ctrl-v.png' style='width: 50%;'></div>";
                        x_alert(x_translate("Ahora pega este mensaje en el cuerpo de tu correo electrónico presionando las teclas Ctrl + V en tu teclado.") + icon_content);
                    }
                    $("#btn-copy-contenido").click(function () {
                        CopyToClipboard2("content_to_copy");
                    });
                    //desplegar modal login
                    $(".btn-conectarme").click(function () {
                        $("#loginbtn").trigger("click");
                    });
                    //desplegar mensaje 
                    $(".btn-preview-mensaje").click(function () {
                        $("#preview-mensaje").slideToggle();
                    });

                });
            </script>
        {/literal}
    {else}
        <section class="pass-sante-registro-planes col-xs-12">
            <div class="okm-container">
                <div class="card" style="margin-top: 60px;">
                    <div class="plogin-header">
                        <h3>{"No se ha podido procesar su suscripión al Pase de Salud"|x_translate}</h3>
                        <p class="text-center">{"Por favor intente nuevamente o contacte a nuestro soporte"|x_translate} </p>
                    </div>
                    <div class="text-center">
                        <a href="javascript:history.back()" class="btn-default">{"volver"|x_translate}</a>
                    </div>
                </div>
            </div>
            </div>
        {/if}