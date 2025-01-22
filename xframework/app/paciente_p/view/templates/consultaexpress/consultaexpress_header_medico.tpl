{if $consulta.tipo_consulta == "0"}
    <div class="colx3 pce-dr-col">
        <div class="cs-ca-colx3-inner dr-col">
            {if $consulta.especialidad!=""}
                <h3 class="cs-ca-especialidad">{$consulta.especialidad}</h3>
            {/if}
            {if $consulta.programa_salud.programa_salud!="" ||  $consulta.programa_categoria.programa_categoria!=""}
                <h3 class="cs-ca-especialidad">
                    {if $consulta.programa_salud.programa_salud!=""}
                        {$consulta.programa_salud.programa_salud}
                    {/if}
                    {if $consulta.programa_categoria.programa_categoria!=""}
                        - {$consulta.programa_categoria.programa_categoria}
                    {/if}
                </h3>
            {/if}
        </div>
    </div>
{else}
    <div class="colx3 pce-dr-col">
        <div class="cs-ca-colx3-inner dr-col">
            <div class="cs-ca-usr-avatar">
                <a href="{$url}panel-paciente/profesionales/{$consulta.medico.idmedico}-{$consulta.medico.nombre|str2seo}-{$consulta.medico.apellido|str2seo}.html">
                    {if $consulta.medico.imagen.list != ""}
                        <img src="{$consulta.medico.imagen.list}" alt="user" />
                    {else}
                        <img src="{$IMGS}extranet/noimage-paciente.jpg" alt="user" />
                    {/if}
                </a>
            </div>
            <div class="cs-ca-usr-data-holder">
                <h2>
                    <a href="{$url}panel-paciente/profesionales/{$consulta.medico.idmedico}-{$consulta.medico.nombre|str2seo}-{$consulta.medico.apellido|str2seo}.html">
                        {$consulta.medico.titulo_profesional.titulo_profesional} {$consulta.medico.nombre} {$consulta.medico.apellido}
                    </a>
                </h2>
                <span>{$consulta.medico.mis_especialidades.0.especialidad}</span>
            </div>
        </div>
    </div>
{/if}