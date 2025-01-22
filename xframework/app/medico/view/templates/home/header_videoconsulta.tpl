 <!-- end NAV -->
    <nav class="paciente-nav">
	<div class="container paciente-nav-container">
			<div class="paciente-nav-usr">
				<a href="javascript:;" class="paciente-nav-trigger">
					<i class="icon-doctorplus-burger"></i>					
                    {if $imagen_medico && $imagen_medico.perfil != ""}
                    <img src="{$imagen_medico.perfil}?{$smarty.now}"  id="imagen_menu_privado_perfil" >
                    {else}
                    <img src="{$IMGS}extranet/noimage_perfil.png" id="imagen_menu_privado_perfil">
                    {/if}
                    <label><span id="nombre_menu_privado_perfil">{$medico.tituloprofesional} {$medico.nombre} {$medico.apellido}</span></label>
				</a>
				
			</div>
		
			<div class="paciente-nav-logo">
				<a href="{$url}panel-medico/" target="doctorplus" title="DoctorPlus">
					<img src="{$IMGS}doctorplus_logo_mobile.png" alt="DoctorPlus"/>
				</a>
			</div>
			<div class="paciente-nav-menu">
				<a class="paciente-nav-menu-burger btnSalir" href="{$url}"><i class="icon-doctorplus-onoff"></i></a>
				<ul class="paciente-nav-menu-rsp" id="burger-menu">
                                    <li><a href="{$url}"  title="Salir" class="btnSalir"><i class="icon-doctorplus-onoff"></i><label>{"Salir"|x_translate}</label></a></li>
				</ul>
			</div>
	</div>
</nav>	
    <!-- end NAV -->        
    <script language="javascript" type="text/javascript">
        $(function() {
			
		
  
          
            
        });
    </script>   