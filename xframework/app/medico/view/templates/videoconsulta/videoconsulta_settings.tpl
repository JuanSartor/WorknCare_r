<form id="link_ingreso_sala" action="{$url}panel-medico/videoconsulta/sala/"  method="POST"></form>
<nav class="section-header ce-ca-top profile">
    <div class="container">
        <div class="user-select pull-left user-select-sonsulta-express-rsp">

            <h1 class="section-name">
                <i class="icon-doctorplus-video-call"></i>
                <a class="consulta-express-tittle-lnk mvc-guia-title" href="{$url}panel-medico/videoconsulta/">{"Video Consulta"|x_translate}</a>
            </h1>
        </div>
        <div class="settings consulta-express-pull-right">
            <div class="dropdown dropdown-express dropdown-portada">
                <select id="combo-select-menu" class="form-control select select-primary select-block mbl ce-nc-p2-res-list-select" style="width:100%">
                    <option value="" {if $smarty.request.submodulo=="bandeja_entrada"}selected{/if}>{"Video Consultas"|x_translate}</option>
                    <option value="pendientes" {if $smarty.request.submodulo=="videoconsulta_pendientes"}selected{/if}>{"Recibidas"|x_translate}</option>
                    <option value="red" {if $smarty.request.submodulo=="videoconsulta_red"}selected{/if}>{"Publicadas en la red"|x_translate}</option>
                    <option value="sala-espera" {if $smarty.request.submodulo=="videoconsulta_sala_espera"}selected{/if}>{"Sala de espera"|x_translate}</option>
                    <option value="finalizadas" {if $smarty.request.submodulo=="videoconsulta_finalizadas"}selected{/if}>{"Finalizadas"|x_translate}</option>
                    <option value="declinadas" {if $smarty.request.submodulo=="videoconsulta_rechazadas"}selected{/if}>{"Declinadas"|x_translate}</option>
                    <option value="vencidas" {if $smarty.request.submodulo=="videoconsulta_vencidas"}selected{/if}>{"Vencidas"|x_translate}</option>
                    <option value="sala" >{"Consultorio Virtual"|x_translate}</option>

                </select>

            </div>
        </div>
        <div class="clearfix"></div>
    </div>
</nav>	
<!-- Modal Video Consulta no habilitada-->
<div id="modal-videoconsulta-inhabilitada-medico" class="modal fade bs-example-modal-lg modal-perfil-completo-acreditacion" tabindex="-1" data-load="no" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button"   class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title">{"¡Atención!"|x_translate}</h4>
            </div>
            <div class="modal-body">
                <p>
                    {"Complete su tarifa y establezca un Consultorio Virtual para acceder a Video Consulta"|x_translate}
                </p>
                <div class="modal-perfil-completo-action-holder">
                    <button onclick="window.location.href = '{$url}panel-medico/perfil-profesional/consultorios/?show_tarifas=1'"><i class="dp-pin"></i>{"Tarifas y Consultorio"|x_translate}</button>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- Modal Video Consultas pendientes de finalizacion -->

<div id="modal-videoconsulta-pendiente_finalizacion" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                <figure class="modal-icon"><i class="icon-doctorplus-sheet-edit"></i></figure>
                <h4 class="modal-title">{"Posee Video Consultas pendientes de registro médico"|x_translate}</h4>
                <h3 class="modal-sub-title"></h3>
            </div>
            <div class="modal-body">
                <div class="modal-action-row">
                    <a id="btn-resolver-videoconsulta" href="javascript:;" class="btn-default"  data-dismiss="modal">{"Resolver"|x_translate}</a>
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
{include file="home/modal_display_file.tpl"}
{literal}
    <script>
        $(document).ready(function () {
            $(".perfil-dropdown-click").click(function () {
                var id = $(this).data("id");
                $(".a_change_member[data-id='" + id + "']").click();
            });

            $("#combo-select-menu").change(function () {

                if ($(this).val() != "") {
                    if ($(this).val() == "sala") {
                        //window.location.href = BASE_PATH + "panel-medico/videoconsulta/sala/";
                        $("#link_ingreso_sala").submit();
                    } else {
                        window.location.href = BASE_PATH + "panel-medico/videoconsulta/" + $(this).val() + ".html";
                    }
                } else {
                    window.location.href = BASE_PATH + "panel-medico/videoconsulta/";
                }
            });

        });
    </script>
{/literal}

{*si no esta establecido el precio de la VC y se intenta acceder a video consulta lanazamos el modal de error*}
{if $cantidad_consulta.ispermitido!="1" }
    <script>
        var submodulo = '{$smarty.request.submodulo}';
        {literal}
            $(document).ready(function () {

                //al cerrar el modal redirigimos a la bandeja de entrada

                if (submodulo != 'bandeja_entrada') {

                    $("#modal-videoconsulta-inhabilitada-medico").on('hidden.bs.modal', function () {
                        window.location.href = BASE_PATH + "panel-medico/videoconsulta/";
                    });
                }
                $("#modal-videoconsulta-inhabilitada-medico").modal('show');

            });
        {/literal}
    </script>
{/if}

{literal}
    <script>
        x_runJS();

        $('html, body').animate({
            scrollTop: $("#Main").offset().top - 50}, 1000);

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
