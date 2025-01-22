<style>
    .cs-ca-chat-holder .chat-line-holder>.chat-content>figure>p {
        font-size: 16px !important;
    }

    .chat-msg-holder-btn-holder .file-trigger,.chat-msg-holder-btn-holder .chat-mic-rec{
        display: block;
        width: 50px;
        height: 50px;
        position: relative;
        border-radius: 50%;
        background-color: #16a085;
        color: #f2f2f2;
        margin: auto;
        overflow: visible;
        top: -4px !important;
        transition: all .2s ease-out;
    }
    .chat-msg-holder-btn-holder .mic-icon-label{
        position: absolute;
        bottom: -20px;
        left: -20px;
        color: #415b70;
        line-height: 14px;
        font-size: 14px;
        white-space: nowrap;
    }
    .chat-msg-holder-btn-holder .chat-mic-rec.delete-audio{
        background-color: #e74c3c;
    }

    .chat-msg-holder-btn-holder .file-trigger i.icon-doctorplus-camera{
        position: relative;
        top: 2px !important;
        left: -1px !important;
    }

    .chat-msg-holder-btn-holder .chat-mic-rec i:before  { 
        position: relative;
        top: 10px;
        left: 15px;
    }
    .chat-msg-input-holder textarea::placeholder{
        color:#415b70;
    }

    .chat-mic-rec-label{
        font-size: 14px;
        text-align: center;
    }
    .chat-mic-rec.grabando{
        animation: glow 2s ease-in-out infinite alternate;
    }
    .recording-label:after {
        overflow: hidden;
        display: inline-block;
        vertical-align: bottom;
        -webkit-animation: ellipsis steps(4,end) 2000ms infinite;      
        animation: ellipsis steps(4,end) 2000ms infinite;
        content: "\2026"; /* ascii code for the ellipsis character */
        width: 0px;
    }

    @keyframes ellipsis {
        to {
            width: 1.25em;
        }
    }
    .audio-actions-panel .audio-action-holder .ce-ca-responder.disabled{
        opacity:0.6;
        cursor: not-allowed;
    }

    .audio-reccord-holder .label_audio_component{
        display:none;

    }
    .audio-reccord-holder.procesando .label_audio_component{
        display:block;

    }
    .audio-reccord-holder .detener-grabacion-lbl{
        display: none;
    }
    .audio-reccord-holder.grabando .detener-grabacion-lbl{
        display: block;
    }
    .audio-reccord-holder.audio-file-holder{
        display: none;
    }
    .audio-reccord-holder.audio-file-holder.audio-success{
        display: block;
    }

    .audio-reccord-holder.audio-success .grabar-audio,
    .audio-reccord-holder.audio-success .grabar-audio-lbl,
    .audio-reccord-holder.uploading-audio .grabar-audio,
    .audio-reccord-holder.uploading-audio .grabar-audio-lbl,
    .audio-reccord-holder.grabando .grabar-audio-lbl,
    .audio-reccord-holder.procesando .grabar-audio-lbl,
    .audio-reccord-holder .delete-audio{
        display: none;
    }
    .audio-reccord-holder.audio-success .delete-audio{
        display: block;
    }

</style>
<nav class="section-header ce-ca-top profile">
    <div class="container">
        <div class="user-select pull-left user-select-sonsulta-express-rsp">

            <h1 class="section-name">
                <i class="icon-doctorplus-chat"></i>
                <a class="consulta-express-tittle-lnk" href="{$url}panel-medico/consultaexpress/">{"Consulta Express"|x_translate}</a>
            </h1>
        </div>
        <div class="settings consulta-express-pull-right">
            <div class="dropdown dropdown-express dropdown-portada">
                <select id="combo-select-menu" class="form-control select select-primary select-block mbl ce-nc-p2-res-list-select" style="width:100%">
                    <option value="" {if $smarty.request.submodulo=="bandeja_entrada"}selected{/if}>{"Consultas"|x_translate}</option>
                    <option value="pendientes" {if $smarty.request.submodulo=="consultaexpress_pendientes"}selected{/if}>{"Recibidas"|x_translate}</option>
                    <option value="red" {if $smarty.request.submodulo=="consultaexpress_red"}selected{/if}>{"Publicadas en la red"|x_translate}</option>
                    <option value="abiertas" {if $smarty.request.submodulo=="consultaexpress_abiertas"}selected{/if}>{"Abiertas"|x_translate}</option>
                    <option value="finalizadas" {if $smarty.request.submodulo=="consultaexpress_finalizadas"}selected{/if}>{"Finalizadas"|x_translate}</option>
                    <option value="declinadas" {if $smarty.request.submodulo=="consultaexpress_rechazadas"}selected{/if}>{"Declinadas"|x_translate}</option>
                    <option value="vencidas" {if $smarty.request.submodulo=="consultaexpress_vencidas"}selected{/if}>{"Vencidas"|x_translate}</option>
                </select>
            </div>
        </div>
        <div class="clearfix"></div>
    </div>
</nav>

<!-- Modal Consulta Express no habilitada-->
<div id="modal-consultaexpress-inhabilitada-medico" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" data-load="no" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button"  class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atención!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Complete su tarifa para acceder a Consulta Express"|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">
                    <button onclick="window.location.href = '{$url}panel-medico/perfil-profesional/consultorios/?show_tarifas=1'"><i class="dp-pin"></i>{"Tarifas"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>
<!--	ALERTAS -  Usabilidad chrome para audios	-->


<div id="modal-usabilidad-audio-chrome" class="modal fade bs-example-modal-lg modal-chrome" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <div class="modal-body">
                <div class="chrome-modal-holder">
                    <h2>{"Sugerencia de usabilidad"|x_translate}</h2>
                    <img src="{$IMGS}chrome-logo.png" alt="Sugerencia de usabilidad"/>
                    <p>{"Para el correcto funcionamiento de mensajes de audio en Consulta Express recomendamos navegar la sección con Google Chrome"|x_translate}</p>
                </div>
            </div>
        </div>
    </div>
</div>	
<!--	ALERTAS -  Consulta express actualizar listado	-->
<div id="modal-recagrar-consultaexpress" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atención!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"La página solicita recargarse para mantenerse actualizada."|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">
                    <button onclick="window.location.href = ''"> {"Recargar"|x_translate}</button>
                    <button data-dismiss="modal"> {"Permanecer en la página"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>
{include file="home/modal_display_file.tpl"}
<div class="modal fade modal-type-1" id="ver-archivo" data-load="no">
    <div class="modal-dialog">
        <div class="modal-content"></div>
    </div>
</div>
<script>
    $(document).ready(function (e) {
        $('#ver-archivo').on('hidden.bs.modal', function () {
            $(this)
                    .removeData('bs.modal')
                    .find(".modal-content").html('');
        });
    });
    //callbacks de la imagen
    var startImg = function (file) {
        //validamos tamaño maximo
        if ((file.size / 1024 / 1024) > 8) {
            return false;
        }
        if (file.previewElement) {
            file.previewElement.classList.add("dz-processing");
            if (file._removeLink) {
                file._removeLink.textContent = this.options.dictCancelUpload;
            }
        }
        //agregar icono para pdf
        if (file.type == "application/pdf") {
            file.previewElement.classList.add("dz-pdf");
            $(".dropzone .dz-pdf img").attr("src", BASE_PATH + "xframework/app/themes/dp02/imgs/ico_pdf.png");
        }


    };

    var successImg = function (file, responseText) {
        $("#cantidad_adjunto").val(parseInt($("#cantidad_adjunto").val()) + 1);
        $("#cantidad").val($("#cantidad_adjunto").val());
        if (file.previewElement && responseText.status == 1) {
            return file.previewElement.classList.add("dz-success");
        } else {
            //x_alert(responseText.error);
            errorImg(file, responseText.error);
        }
    };

    var stopImg = function (file) {

        if (file._removeLink) {
            file._removeLink.textContent = this.options.dictRemoveFile;
        }
        if (file.previewElement) {
            return file.previewElement.classList.add("dz-complete");
        }
        //$("#dropzone").spin(false);
    };
    var errorImg = function (file, message) {

        if (file._removeLink) {
            file._removeLink.click();
        }
        if (typeof message !== "String" && message.error) {
            message = message.error;
        }
        if ((file.size / 1024 / 1024) > 8) {
            message = x_translate("Error. Tamaño máximo de archivo 8 MB.");

        }
        x_alert(message);
        if (file.previewElement) {
            file.previewElement.remove();
        }
        if ($(".dropzone .dz-preview").length == 0) {
            $(".dropzone").removeClass("dz-started");
        }
        var node, _i, _len, _ref, _results;
        if (file.previewElement) {
            file.previewElement.classList.add("dz-error");
            if (typeof message !== "String" && message.error) {
                message = message.error;
            }
            _ref = file.previewElement.querySelectorAll("[data-dz-errormessage]");
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
                node = _ref[_i];
                _results.push(node.textContent = message);
            }
            return _results;
        }
    };
</script> 

<script>
    $(document).ready(function () {

        $('html, body').animate({
            scrollTop: $("#Main").offset().top - 50}, 1000);
        $(".perfil-dropdown-click").click(function () {
            var id = $(this).data("id");
            $(".a_change_member[data-id='" + id + "']").click();
        });

        $("#combo-select-menu").change(function () {
            if ($(this).val() != "") {
                window.location.href = BASE_PATH + "panel-medico/consultaexpress/" + $(this).val() + ".html";
            } else {
                window.location.href = BASE_PATH + "panel-medico/consultaexpress/";
            }
        });

    });
</script>


{*si no esta establecido el precio de la CE y se intenta acceder a consulta express lanazamos el modal de error*}
{if $cantidad_consulta.ispermitido!="1" }
    <script>
        var submodulo = '{$smarty.request.submodulo}';
        {literal}
            $(document).ready(function () {

                //al cerrar el modal redirigimos a la bandeja de entrada

                if (submodulo != 'bandeja_entrada') {

                    $("#modal-consultaexpress-inhabilitada-medico").on('hidden.bs.modal', function () {
                        window.location.href = BASE_PATH + "panel-medico/consultaexpress/";
                    });
                }
                $("#modal-consultaexpress-inhabilitada-medico").modal('show');

            });
        {/literal}
    </script>
{/if}

{literal}
    <script>
        x_runJS();


        $('.active-user').on('click', function () {
            $(".perfil-dropdown").stop().slideDown();
            return false;
        });

        $('.dp-arrow-down').parent('span').on('click', function () {
            $(".perfil-dropdown").stop().slideUp();
            return false;
        });


    </script>

{/literal}
