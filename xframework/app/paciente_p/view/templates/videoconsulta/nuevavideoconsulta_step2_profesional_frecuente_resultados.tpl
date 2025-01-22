<div id="div_profesionales_red_list">
    <form name="f_busqueda" id="f_busqueda" action="{$url}busqueda_profesionales_red.do" method="POST" role="form" onsubmit="return false">
        <input type="hidden" id="idvideoconsulta_f" name="idvideoconsulta" value="{$smarty.request.idvideoconsulta}">

    </form>
    <div class="pbn-section-buscador">	
        <section class="container cs-nc-p2">
            <div class="cs-nc-p2-header">
                {*<figure>
                <i class="icon-doctorplus-people-add"></i>
                </figure>
                <h2>{"Profesional en particular"|x_translate}</h2>*}
                <div class="pbn-section-tags-map" style="padding-top: 10px;">
                    <h3>  
                        {if $programa_salud.programa_salud!=""}
                            {$programa_salud.programa_salud}
                        {/if}
                        {if $programa_categoria.programa_categoria!=""}
                            &nbsp;-&nbsp;{$programa_categoria.programa_categoria}
                        {/if}
                    </h3>
                    {if $especialidad.especialidad!=""}
                        <h3>{$especialidad.especialidad}</h3>
                    {/if}
                </div>
            </div>
            <div class="row">
                <div class="nc-ce-p2res-search-bar">
                    <div class="search-holder">
                        <a id="btn-nueva-busqueda" class="btn btn-default btn-oil-square">{"Nueva búsqueda"|x_translate}&nbsp;<i class="icon-doctorplus-search"></i></a>
                    </div>
                </div>
            </div>

        </section>
        <div id="modulo_listado_consultorios" class="relative">

            {include file="busqueda/busqueda_profesional_resultado_modulo.tpl"}
        </div>



    </div>
</div>


<!-- Modal no hay profesionales -->
<div id="modal-no-profesionales" class="modal fade modal-profesionales" tabindex="-1" role="dialog" aria-labelledby="mySmallModalLabel">
    <div class="modal-dialog modal-sm modal-consulta-sm">


        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            </div>
            <p>{"No hay profesionales para asignar la consulta"|x_translate}</p>

        </div>
    </div>
</div>

{literal}

    <script>

        x_runJS();

        $(function () {
            //ir arriba
            if (getViewportWidth() < 600) {
                $('html, body').animate({
                    scrollTop: $("#videoconsulta-step-container").offset().top - 50}, 1000);
            } else {
                $('html, body').animate({
                    scrollTop: $("#Main")}, 1000);
            }

            $(':checkbox').radiocheck();
            renderUI2("videoconsulta-step-container");

            //nueva busqueda
            $("#btn-nueva-busqueda").click(function () {

                x_loadModule('videoconsulta', 'nuevavideoconsulta_step1', 'idvideoconsulta=' + $("#idvideoconsulta").val(), 'videoconsulta-step-container', BASE_PATH + "paciente_p");
            });

        });


    </script>
{/literal}
