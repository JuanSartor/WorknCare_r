   
<section class="container cs-nc-p2 cs-nc-p2-medicos-fav padding-top-0">
    <!--{* <div class="cs-nc-p2-header">
         <figure>
             <i class="icon-doctorplus-corazon"></i>
         </figure>
         <h2>Profesionales Favoritos</h2>
     </div>*}-->
    <div class="cs-nc-p2-inner">
        <div class="cs-nc-p2-medicos-fav-header">
            <figure>
                <i class="icon-doctorplus-corazon"></i>
            </figure>
            <h3>{"Médicos favoritos"|x_translate}</h3>
        </div>




        {if $medicos_list.rows && $medicos_list.rows|@count > 0}
        <div class="cs-nc-p2-listado-segunda-opcion">

            {foreach item=medico from=$medicos_list.rows}
            <div class="listado-row">
                <div class="listado-item-usr">

                    <div class="listado-item-usr-avatar-holder">
                        <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                            <figure>
                                {if !$medico.imagen}
                                <img src="{$IMGS}extranet/noimage_perfil.png" title="{$medico.nombre} {$medico.apellido}" alt="{$medico.nombre} {$medico.apellido}">
                                {else}
                                <img src="{$path_files}/entities/medicos/{$medico.idmedico}/{$medico.idmedico}_list.jpg" title="{$medico.nombre} {$medico.apellido}" alt="{$medico.nombre} {$medico.apellido}">
                                {/if}
                            </figure>
                        </a>


                    </div>
                    <div class="listado-item-usr-name-holder">
                        <div class="nombre">
                            <a href="{$url}panel-paciente/profesionales/{$medico.idmedico}-{$medico.nombre|str2seo}-{$medico.apellido|str2seo}.html">
                                {$medico.titulo_profesional} {$medico.nombre} {$medico.apellido}
                            </a>
                        </div>
                        <div class="especialidad">{$medico.especialidad.0.especialidad}</div>
                    </div>

                </div>
                <div class="listado-item-detail">
                    <p >
                        <span>
                        </span>
                    </p>
                    <div class="listado-item-detail-ratting cs-nc-p2-medicos-fav-ratting">
                        <!--	
                        Clase estrellas-n (n de 1 a 5 marca la cantidad de estrellas resaltadas)
                        -->
                        {*
                        <ul class="estrellas-{$medico.estrellas}">
                            <li><i class="icon-doctorplus-star"></i></li>
                            <li><i class="icon-doctorplus-star"></i></li>
                            <li><i class="icon-doctorplus-star"></i></li>
                            <li><i class="icon-doctorplus-star"></i></li>
                            <li><i class="icon-doctorplus-star"></i></li>
                        </ul>
                        *}
                        <p>
                            {*{if $medico.valoracion==0}<span>{"Profesional aún sin recomendaciones"|x_translate}</span>{/if}*}
                            {if $medico.valoracion >0}
                            {if $medico.valoracion ==1}
                            <span>{$medico.valoracion} {"paciente lo recomienda"|x_translate}</span>
                            {else}
                            <span>{$medico.valoracion} {"pacientes lo recomendaron"|x_translate}</span>
                            {/if}
                            {else}
                            <span>&nbsp;</span>
                            {/if}
                        </p>
                        <a href="javascript:;" data-id="{$medico.idmedico}" class="cs-nc-p2-medicos-fav-circle">
                            <i class="icon-doctorplus-corazon"></i>
                        </a>
                    </div>
                </div>

                <div class="listado-item-plan">
                    <div class="listado-item-plan-row">
                        <div class="consulta-col consulta-col-x1">
                            <div class="value"><div class="show-consulta-col">{if $medico.preferencia.valorPinesVideoConsulta>"0" && $medico.consultorio_virtual.idconsultorio!=""}&euro;{$medico.preferencia.valorPinesVideoConsulta}{else}<small>{"No publica"|x_translate}</small>{/if}</div></div>
                            <div class="icon">{if $medico.preferencia.valorPinesVideoConsulta>"0" && $medico.consultorio_virtual.idconsultorio!=""}<a  href="javascript:;" role="button" class="select-profesional-frecuente" data-id="{$medico.idmedico}"><i class="icon-doctorplus-video-call"></i></a>{else}<i class="icon-doctorplus-video-call"></i>{/if}</div>
                        </div>
                    </div>
                </div>
            </div>




            {/foreach}

        </div>
        {else}
        <div class="sin-registros-cs">      
            <p>{"No registra Profesionales Favoritos asociados al paciente"|x_translate}</p>
        </div>
        {/if}

        {if $medicos_list.rows && $medicos_list.rows|@count > 0}

        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="videoconsulta"
        submodulo="favoritos_list" 
        container_id="div_profesionales_favoritos_list"}

        {/if}

    </div>
</section>



{literal}
<script>
    x_runJS();

    $(function () {
        renderUI2();
        //forzamos la cantidad de caracteres de la subspecialidad

        $('#div_profesionales_favoritos_list p.text-cut span').each(function () {
            if ($(this).html().length > 180) {
                $(this).html($(this).html().substring(0, 180) + "...");
            }
        })




        // eliminar medico favorito
        $('a.cs-nc-p2-medicos-fav-circle').click(function () {
            $element = $(this);
            var id = $(this).data('id');
            jConfirm({
                title: x_translate("Eliminar profesional favorito"),
                text: x_translate('Está por eliminar el profesional seleccionado de su lista de profesionales favoritos. ¿Desea continuar?'),
                confirm: function () {

                    $("#div_profesionales_favoritos_list").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'marcar_favorito.do',
                            'idmedico=' + id,
                            function (data) {
                                $("#div_profesionales_favoritos_list").spin(false);
                                if (data.result) {
                                    x_loadModule('videoconsulta', 'favoritos_list', 'idvideoconsulta=' + $("#idvideoconsulta").val() + '&do_reset=1', 'div_profesionales_favoritos_list', BASE_PATH + "paciente_p");

                                } else {
                                    x_alert(data.msg);
                                }
                            }

                    );
                },
                cancel: function () {

                },
                confirmButton: x_translate("Si"),
                cancelButton: x_translate("No")
            });
        });

        //botones para crear la video consulta asociada a un medico
        $("#div_profesionales_favoritos_list .select-profesional-frecuente").click(function () {
            var idmedico = $(this).data('id');
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'nuevavideoconsulta_step2_profesionalfrecuente.do',
                    'idvideoconsulta=' + $("#idvideoconsulta").val() + '&medico_idmedico=' + idmedico,
                    function (data) {

                        if (data.result) {
                            x_loadModule('videoconsulta', 'nuevavideoconsulta_step3', 'idvideoconsulta=' + $("#idvideoconsulta").val(), 'videoconsulta-step-container', BASE_PATH + "paciente_p");

                        } else {
                            x_alert(data.msg);
                        }

                    }
            );

        });


    });

</script>
{/literal}

