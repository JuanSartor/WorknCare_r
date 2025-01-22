<section class="pbn-section-buscador">
    <div class="okm-container">
        <div class="okm-row pbn-background_not">
            <div class="pbn-buscador-col"><h2>{"Buscador de profesionales"|x_translate}</h2></div>
            <div class="pbn-buscador-btn-col">
                <a href="{$url}panel-paciente/busqueda-profesional/" class="btn-oil-square pbn-buscador-btn"><span>{"Nueva búsqueda"|x_translate}</span> <i class="icon-doctorplus-search"></i></a>
            </div>
        </div>
    </div>
</section>
<section class="pbn-section-tags-map">
    <div class="okm-container pbn-tags-map" style="padding: 10px;">

        {if $programa_salud.programa_salud!="" || $programa_categoria.programa_categoria!=""}
            <h3>
                {if $programa_salud.programa_salud!=""}
                    {$programa_salud.programa_salud}
                {/if}
                {if $programa_categoria.programa_categoria!=""}
                    &nbsp;-&nbsp;{$programa_categoria.programa_categoria}
                {/if} 
            </h3>
        {/if}
        {if $especialidad.especialidad!=""}
            <h3>{$especialidad.especialidad}</h3>
        {/if}

        {include file="busqueda/busqueda_profesional_mapa.tpl"}
    </div>
</section>




<div id="modulo_listado_consultorios" class="relative">


</div>



{include file="busqueda/como_funciona.tpl" }

<script>
    $("#tagsinput").tagsinput({ldelim}itemValue: 'id', itemText: 'text', freeInput: false{rdelim});
    {foreach from = $tags_inputs item = tag}
        $("#tagsinput").tagsinput('add', {ldelim}"id": '{$tag.id}', "text": '{$tag.name}', "clave": '{$tag.tipo}'{rdelim});
    {/foreach}
            $(".bootstrap-tagsinput > input").hide();
            $(".tagsinput-primary span[data-role='remove']").remove();
</script>

{x_load_js}
