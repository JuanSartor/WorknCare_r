<div id="colRight">

	<input type="hidden" id="list_actual_page" value="{$paginate.current_page}" />

	<div class="block">

		<div class="title_bar">
			<span class="text">OBRA SOCIAL - PREPAGA &raquo; PLANES  &raquo; {if $record} EDITAR {else} NUEVA{/if}</span>

			{x_form_html_button id="btnNew" label="Nuevo" w="100" type="button" class="icon add"}&nbsp;
                        
                        {x_form_html_button id="btnBack" label="Volver" w="100" type="button" class="icon arrowleft"}

		</div>
		<div class="top">
			&nbsp;
		</div>
		<div class="contenido">

			<div class="xForm">
				<form action="{$controller}.php?action=1&modulo=maestros_os&submodulo=maestros_planes_list" target="_blank"  method="post"  name="f_busqueda" id="f_busqueda" >
					<input type="hidden" name="idplanObraSocial" id="idplanObraSocial" value="{$record.idplanObraSocial}" />
					<input type="hidden" name="obraSocial_idobraSocial" id="obraSocial_idobraSocial" value="{$obraSocial.idobraSocial}" />

					<div class="form_container">
						<div class="title">
							Consulta de Planes de Obras Sociales - Prepagas
						</div>

						<ul>

							<li class="wide">
								<label>Obra Social / Prepaga</label>
								<span class="lbl" id="pre_id" >{$obraSocial.nombre} {if $obraSocial.siglas!=""} - {$obraSocial.siglas} {/if}</span>
							</li>

							
							<li class="left">
								<label>Nombre Plan</label>
								{x_form_input  id="nombre" descriptor="none" isRequired="false" maxChars=100 class="" value=$paginate.request.nombrePlan}
							</li>

							<li class="clear"></li>
							<li class="wide">
								{x_form_html_button id="btnFilter" label="Buscar" class="icon search" w="100" type="button"}

								{x_form_html_button id="btnLimpiar" label="Limpiar" class="icon loop" w="100" type="button"}

							</li>
							<li class="clear"></li>

						</ul>

					</div>
				</form>
			</div>

			<div  class="xTable" id="xTable">

				<div class="container">

					<table id="list"></table>

					<div id="pager"></div>

				</div>

			</div>
		</div>
		<div class="end">
			&nbsp;
		</div>
	</div>

</div>