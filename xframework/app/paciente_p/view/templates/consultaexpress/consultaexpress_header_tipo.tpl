<div class="colx3 pce-profesional-col">
    <div class="cs-ca-colx3-inner pce-profesional">
        <div class="cs-ca-usr-avatar cs-ca-usr-avatar-sm">
            {if $consulta.tipo_consulta=="1"}
                {if $consulta.programa_categoria.imagen.original !=""}
                    <img src="{$consulta.programa_categoria.imagen.original}" title="{$consulta.programa_categoria.programa_categoria}" alt=" {$consulta.programa_categoria.programa_categoria}" style="width: 40px;border-radius: 0;" />
                {else}
                    <figure>
                        <i class="icon-doctorplus-user-add-like"></i>
                    </figure>
                {/if}
            {else}
                <figure>
                    <i class="icon-doctorplus-people-add"></i>
                </figure>
            {/if}
        </div>
        <div class="cs-ca-usr-data-holder">
            {if $consulta.tipo_consulta=="1"}

                {if $consulta.programa_salud!="" ||  $consulta.programa_categoria!=""}
                    <span class="nombre_categoria">
                        {if $consulta.programa_salud.programa_salud!=""}
                            {$consulta.programa_salud.programa_salud}
                        {/if}
                        {if $consulta.programa_categoria.programa_categoria!=""}
                            - {$consulta.programa_categoria.programa_categoria}
                        {/if}
                    </span>
                {else}
                    <span>{"PROFESIONAL FRECUENTE"|x_translate}</span>
                {/if}

            {else}
                <span>{"PROFESIONALES EN LA RED"|x_translate}</span>
            {/if}
        </div>
    </div>
</div>