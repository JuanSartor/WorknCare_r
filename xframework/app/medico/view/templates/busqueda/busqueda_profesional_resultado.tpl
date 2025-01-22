<section class="pbn-section-buscador">
    <div class="okm-container">
        <div class="okm-row pbn-background_not">
            <div class="pbn-buscador-col"><h2>{"Buscador de profesionales"|x_translate}</h2></div>
            <div class="pbn-buscador-btn-col">
                <a href="{$url}panel-medico/busqueda-profesional/" class="btn-oil-square pbn-buscador-btn"><span>{"Nueva búsqueda"|x_translate}</span> <i class="icon-doctorplus-search"></i></a>
            </div>
        </div>
    </div>
</section>
<section class="pbn-section-tags-map">
    <div class="okm-container pbn-tags-map">
        <h3>{$especialidad.especialidad}</h3>
        <p>
            {if $tags_inputs|@count > 0}
            {"Sus filtros de búsqueda"|x_translate}
            {else}
            &nbsp;
            {/if}
        </p>
        <div class="okm-row pbn-tags-row">
            <div class="pbn-tags-holder">
                <div class="tagsinput-primary ceprr-tags pbn-tags">
                    {if $tags_inputs|@count > 0}
                    <input name="tagsinput" id="tagsinput" />
                    {/if}
                </div>
            </div>
            <div class="pbn-map-action">
                <a href="#" class="btn-alert-square pbn-map-trigger pbn-static-btn"><i class="icon-doctorplus-map-check"></i> <span>{"ver mapa"|x_translate}</span></a>
            </div>

        </div>
        <div class="pbn-map-holder">
            <div class="pbn-map-inner" id="pbn-map" >
              
                <div id="map_canvas" style="height: 800px; width: 800px; margin:0px auto;"></div>
               
                <div class="pbn-map-close-btn">
                    <a href="#" class="btn-seconday-inverted-square pbn-map-trigger"><i class="icon-doctorplus-map-check"></i> {"ocultar mapa"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</section>




<div id="modulo_listado_consultorios">
    

</div>





<section class="banner-gestion-cobros">
	<div class="okm-container">
		<div class="okm-row">
			<div class="banner-gestion-cobros-img-holder">
				<div class="banner-gestion-cobros-card">
					<figure>
						<i class="icon-doctorplus-chat"></i>
					</figure>
					<div class="banner-gestion-cobros-content">
					<div class="banner-gestion-cobros-shadow">
					<div class="banner-gestion-cobros-inner">
						<h3>{"¡Aumente su capacidad productiva!"|x_translate}</h3>
						<p>{"Controle y capitalice las consultas de sus pacientes fuera de su consultorio a través del servicio de Consulta Express."|x_translate}</p>
						</div>
					</div>
					
					<div class="banner-gestion-cobros-footer">
						<p>{"Ud. Atienda la consulta."|x_translate} <br>
							{"DoctorPlus se encarga de gestionar su cobro."|x_translate}</p>
					</div>
					</div>
				</div>
			</div>
			
		</div>
	</div>
</section>
{x_load_js}
<script>
    $("#tagsinput").tagsinput({ldelim}
            itemValue: 'id',
            itemText: 'text'
    {rdelim}
    );
    {foreach from = $tags_inputs item = tag}
    $("#tagsinput").tagsinput('add', {ldelim} "id"
            : '{$tag.id}', "text": '{$tag.name}', "clave":'{$tag.tipo}' {rdelim});
    {/foreach}
</script>


