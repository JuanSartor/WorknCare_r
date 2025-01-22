
    <!-- end NAV -->
    <nav class="paciente-nav">
	<div class="container paciente-nav-container">
			<div class="paciente-nav-usr">
				<a href="#" class="paciente-nav-trigger">
					{if $account.mi_logo}
                    <img src="{$url}xframework/files/entities/pacientes/{$account.paciente.idpaciente}/{$account.paciente.idpaciente}_perfil.jpg" class="img-responsive img-circle  dl-trigger " id="imagen_menu_privado_perfil">
                    {else}
                    <img src="{$IMGS}extranet/noimage-paciente.jpg" id="imagen_menu_privado_perfil">
                    {/if}
					<label>{$account.name} {$account.lastname}</label>
				</a>
		
			</div>
		
			<div class="paciente-nav-logo">
				<a href="{$url}" target="doctorplus" title="DoctorPlus">
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
    {literal}   
    <script language="javascript" type="text/javascript">
        $(function() {
			
			

           
           
            
        });
    </script>        
	{/literal}