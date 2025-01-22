{if $account.user.tipo_usuario|in_array:['1','3','4'] } 
    <style>
        #Main {
            min-height: 100%;
            background: #02b8c1;
        }
    </style>
    {*preview mensaje bienvenida*}
    <section class="pass-sante-registro-planes bienvenida-preview" >

        <div class="container-header">
            <h2>{"Genera un enlace para enviar directamente a tus beneficiarios"|x_translate}</h2>
            <div class="buttons">
                <button  href="javascript:;" class="btn-default btn-copy-link btn-enviar-invitacion" data-toggle="modal" data-target="#modal-compartir-pass">{"Copiar el link"|x_translate}&nbsp;<i class="fa fa-share"></i></button >
                <a  style="cursor: pointer;"   data-toggle="modal" data-target="#modal-flyer-invitacion" class="btn-default btn-flayer" target="_blank">{"Folleto imprimible"|x_translate}&nbsp;<i style="margin-left: 10px;" class="fa fa-print"></i></a>
                <a  href="{$url}empresa.php?action=1&modulo=home&submodulo=invitacion_pass_pdf" class="btn-default btn-download" target="_blank">{"Descargar invitación"|x_translate}&nbsp;<i class="fa fa-download"></i></a>
                <button  href="javascript:;" class="btn-default btn-conectarme btn-volver"><i class="fa fa-chevron-left"></i>&nbsp;{"Volver"|x_translate}</button >
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
                {include file="home/bienvenida_beneficiario.tpl"}
            </div>
        </div>
        {include file="home/modal_invitacion.tpl"}
        {include file="home/modal_compartir_pass.tpl"}
    </section>
    {literal}
        <script>
            $(function () {

                $(document).ready(function (e) {

                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'empresa.php?action=1&modulo=home&submodulo=generar_qr_invitacion',
                            function (data) {
                                $("body").spin(false);

                            }
                    );

                });


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
                $(".btn-volver").click(function () {
                    $("body").spin("large");
                    x_loadModule('home', 'home', '', 'Main').then(function () {
                        $("body").spin(false);
                    });
                });

                //desplegar mensaje 
                $(".btn-preview-mensaje").click(function () {
                    $("#preview-mensaje").slideToggle();
                });
            });
        </script>
    {/literal}
{/if}