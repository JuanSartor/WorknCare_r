<div id="colRight">
	<div class="title_bar"><span class="text">EDITAR PERFIL &raquo; </span>
    <span id="toolbar_node">
 
        </span> 	
    </div>
    <div class="block" >    	
		<div class="top">&nbsp;</div>

        <div class="contenido" id="content">

    <div class="xForm">
	    <form action="{$controller}.php?action=1&modulo=usuarios&submodulo=perfil_form" method="post" name="f_datos" id="f_datos">
	    <div class="form_container">
        	<div class="title">Perfil de {$user.username}</div>
            <!-- Begin ItemsForm -->
            <ul>  
			{if $account.idlevel  < 2}
			<li class="wide">
                <label for="email_input">
                   Email
                </label> 

                  {x_form_input  id="email" descriptor="email" isRequired="true" maxChars=50 class="" record=$user}

            
            {else}
			<li class="wide">
                <label>
                   Email
                </label>                
                {$user.email}
            </li>  
            {/if}      
            
    
           <li class="left">
                <label>
                    Nombre
                </label> 
                    {x_form_input  id="nombre" descriptor="none" isRequired="true" maxChars=70 class="" record=$user}

           </li>
           <li class="left">
				<label>
                    Apellido
                </label> 
                    {x_form_input  id="apellido" descriptor="none" isRequired="false" maxChars=70 class="" record=$user}
            </li>
    
   
             <li class="clear"></li>
			<li class="wide">           
             {x_form_html_button id="Save" label="Guardar" function_name="x_sendForm" class="icon save" type="button" p1="$('#f_datos')" p2="true" p3="doModifyFromWindow" p4="{ldelim}modulo:'usuarios',submodulo:'miperfil'{rdelim}"}
           
            </li>
             <li class="clear"></li>

            
            
            
           </ul>
           <!-- End ItemsForm -->
        </div>
         </form>
	</div>

	<div class="clear">&nbsp;</div>
    
    
    <div class="xForm w750">
        <form action="{$controller}.php?action=1&modulo=usuarios&submodulo=changepass" method="post" id="f_cambioPass"  name="f_cambioPass">
        <div class="form_container">
            <div class="title">Cambiar Contrase&ntilde;a</div>
            
             <!-- Begin ItemsForm -->
            <ul>
            
                <li class="left">
                   <label>Contrase&ntilde;a anterior</label>
                   {x_form_input  id="oldPassword" password="yes" descriptor="none" isRequired="true" maxChars=150 class="" password="1"}
                    </label>
				<li>
				<li class="left">
                    <label>Contrase&ntilde;a Nueva</label>
                    {x_form_input  id="newPassword" password="yes" descriptor="none" isRequired="true" maxChars=150 class="" password="1"}
                </li>   
    
			    <li class="left">
                    <label>Confirmar </label>
                    {x_form_input  id="confirm_password"  descriptor="username" isRequired="true" maxChars=100 class="w200" password="1"}
                </li>
                        
   

              <li class="clear"></li>
               <li>           
              {x_form_html_button id="SavePass" label="Guardar" function_name="changePass" type="button" p1="$('#f_cambioPass')" class="icon save"}
           
	          </li>
              <li class="clear"></li>

			</ul>            
             <!-- End ItemsForm -->

            
        </div>
        </form>
    </div>


        </div>   
       <div class="end">&nbsp;</div> 
	</div>   
 </div> 