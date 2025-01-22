{include file="perfil_salud/profile_settings.tpl"}

{include file="perfil_salud/menu_perfil_salud.tpl"}
{*<section class="module-header container-fluid">
<div class="row ">
<div class="col-md-12">
<div class="container">
<ol class="breadcrumb">
<li><a href="{$url}panel-paciente/home.html">{"Inicio"|x_translate}</a></li>
<li><a href="{$url}panel-paciente/perfil-salud/">{"Perfil de Salud"|x_translate}</a></li>
<li class="active">{"Controles y chequeos"|x_translate}</li>
</ol>
</div>
</div>
</div>
</section>*}

{if $listado|@count > 0}
    <section class="module-header container ajustes-panel-paciente">
        <figure class="dpp-chequeos"></figure>
        <h1>{"Controles y chequeos"|x_translate}</h1>
    </section>
    <!-- /main header -->


    <section class="container">
        <div class="row">

            <div class="col-sm-12" >

                <table class="table-responsive historico-consultas-table notificaciones-table">
                    <thead>
                        <tr>
                            <td class="col-1">{"Fecha"|x_translate}</td>
                            <td class="">{"Tipo"|x_translate}</td>
                            <td class="col-3">{"Descripción"|x_translate}</td>
                            <td class="col-4"></td>
                        </tr>
                    </thead>
                    <tbody>

                        {foreach from=$listado item=registro}
                            <tr>
                                <td>{$registro.fechaNotificacion|date_format:"%d/%m/%Y"}</td>
                                <td>{$registro.tipoControlChequeo}</td>
                                <td>{$registro.titulo}</td>

                                <td>
                                    <a href="javascript:;" class="btnMarcarLeida" data-status="{$registro.leido}" data-id="{$registro.idnotificacion}">
                                        {if $registro.leido == 1}
                                            <span class="dpp-flag deactivated"></span>
                                        {else}
                                            <span class="dpp-flag"></span>
                                        {/if}
                                    </a>
                                </td>
                            </tr>

                        {/foreach}
                    </tbody>
                </table>
            </div>
        </div>
    </section>
{else}
    <div class="cs-nc-section-holder">
        <section class="container cs-nc-p2">
            <div class="sin-registros">
                <i class="dpp-chequeos"></i>
                <h6>{"¡La sección está vacía!"|x_translate}</h6>
                <p>{"Ud. no tiene Controles y chequeos."|x_translate}</p>
            </div>
        </section>
    </div>
{/if}



{literal}
    <script>
        $("ul.slider-menu li a").removeClass("active");
        $("ul.slider-menu li i.dpp-chequeos").parent().addClass("active");

        $(".btnMarcarLeida").click(function () {
            $this = $(this);
            var id = $this.data("id");
            var status = $this.data("status");
            var leido = 0;
            if (parseInt(status) == 0) {
                leido = 1;
            }

            if (parseInt(id) > 0) {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'marcar_leido_p.do',
                        "ids=" + id + "&leido=" + leido,
                        function (data) {
                            if (data.result) {
                                actualizar_notificaciones();
                                if (leido == 1) {
                                    $this.find("span").addClass("deactivated");
                                    $this.data("status", 1);
                                } else {
                                    $this.find("span").removeClass("deactivated");
                                    $this.data("status", 0);
                                }
                            }
                        }
                );
            } else {
                x_alert(x_translate("No se encontró el control y chequeo"));
                return false;
            }
        });


    </script>

{/literal}