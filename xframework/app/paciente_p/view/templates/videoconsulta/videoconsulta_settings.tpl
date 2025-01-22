<form id="link_ingreso_sala" action="{$url}panel-paciente/videoconsulta/sala/"  method="POST"></form>

<nav class="section-header consulta-express-top profile">
    <div class="container">
        <div class="user-select user-select-sonsulta-express-rsp">
            <h1 class="section-name">
                <a class="consulta-express-tittle-lnk" href="{$url}panel-paciente/videoconsulta/">
                    <i class="icon-doctorplus-video-call"></i>
                    {"Video Consulta"|x_translate}
                </a>
            </h1>
            <div class="settings consulta-express-pull-right">

                <div class="dropdown dropdown-express">

                    <select id="combo-select-menu" class="form-control select select-primary select-block mbl ce-nc-p2-res-list-select" style="width:100%">
                        <option value="" {if $smarty.request.submodulo=="bandeja_entrada"}selected{/if} >{"Video Consultas"|x_translate}</option>
                        <option value="nuevavideoconsulta" {if $smarty.request.submodulo=="nuevavideoconsulta"}selected{/if}>{"Nueva Consulta"|x_translate}</option>
                        <option value="pendientes" {if $smarty.request.submodulo=="videoconsulta_pendientes"}selected{/if}>{"Pendientes"|x_translate}</option>
                        <option value="sala-espera" {if $smarty.request.submodulo=="videoconsulta_sala_espera"}selected{/if}>{"Sala de espera"|x_translate}</option>
                        <option value="finalizadas" {if $smarty.request.submodulo=="videoconsulta_finalizadas"}selected{/if}>{"Finalizadas"|x_translate}</option>
                        <option value="declinadas" {if $smarty.request.submodulo=="videoconsulta_rechazadas"}selected{/if}>{"Declinadas"|x_translate}</option>
                        <option value="vencidas" {if $smarty.request.submodulo=="videoconsulta_vencidas"}selected{/if}>{"Vencidas"|x_translate}</option>
                        <option value="sala" >{"Consultorio Virtual"|x_translate}</option>
                    </select>

                </div>
            </div>
        </div>
    </div>
</nav>

<!-- -->
<div id="modal-videoconsulta-inhabilitada" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" data-load="no" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button"  class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atención!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Complete su perfil de salud para acceder a Video Consulta"|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">
                    <button  data-dismiss="modal" aria-label="Close"> <i class="icon-doctorplus-cruz"></i>{"Cancelar"|x_translate}</button>
                    <button onclick="window.location.href = '{$url}panel-paciente/wizard_perfil_salud/'"><i class="icon-dp-info-salud"></i> {"Perfil de Salud"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>

<!--	ALERTAS -  VideoConsultas actualizar listado	-->
<div id="modal-recagrar-videoconsulta" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
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

{include file="home/modal_consulta_borrador.tpl"}
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
        console.log(file);
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
{*si no esta completo el perfil de salud y se intenta acceder a video consulta lanzamos el modal de error*}
{if $cantidad_consulta.ispermitido!="1" }
    <script>
        var submodulo = '{$smarty.request.submodulo}';
        {literal}
            $(document).ready(function () {

                //al cerrar el modal redirigimos a la bandeja de entrada

                if (submodulo != 'bandeja_entrada') {

                    $("#modal-videoconsulta-inhabilitada").on('hidden.bs.modal', function () {
                        window.location.href = BASE_PATH + "panel-paciente/videoconsulta/";
                    });
                }
                $("#modal-videoconsulta-borrador").modal("hide");
                $("#modal-videoconsulta-inhabilitada").modal('show');

            });
        {/literal}
    </script>
{/if}

{literal}

    <script>
        $(document).ready(function () {

            $("#combo-select-menu").change(function () {
                if ($(this).val() != "") {
                    if ($(this).val() == "sala") {
                        //window.location.href = BASE_PATH + "panel-paciente/videoconsulta/sala/";
                        $("#link_ingreso_sala").submit();

                    } else {
                        window.location.href = BASE_PATH + "panel-paciente/videoconsulta/" + $(this).val() + ".html";
                    }
                } else {
                    window.location.href = BASE_PATH + "panel-paciente/videoconsulta/";
                }
            });
        });
    </script>
{/literal}