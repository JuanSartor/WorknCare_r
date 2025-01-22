<div id="loginbox">
<div id="login-inner">
		<table border="0" cellpadding="0" cellspacing="0">
        
		<tr>
			<th colspan="2">Elegir nueva contrase&ntilde;a</th>			
		</tr>
        <tr>
			<th colspan="2">&nbsp;</th>			
		</tr>
         {if !$reset}
		<tr>
			<th>&nbsp;</th>
			<td> La solicitud no es v&aacute;lida </td>
		</tr>
       {elseif $reset.valido == 'f'}
		<tr>
			<th>&nbsp;</th>
			<td> La solicitud ha expirado </td>
		</tr>       
       
       {elseif $reset.valido == 't'}
       
		<tr>
			<th>Contrase&ntilde;a</th>
			<td> 
            <form action="{$controller}.php?action=1&modulo=login&submodulo=resetPass" method="post" name="f_recuperar" id="f_recuperar">
            <input type="hidden" id="hash" name="hash" value="{$reset.hash}"  />
            	{x_form_input class="login-inp"  id="password" descriptor="none" password=1 isRequired="true" maxChars=100}   
                
            </form>    
            </td>
		</tr>
		<tr>
			<th></th>
			<td>
            <input type="button" name="button" id="button" value="Guardar" onclick="x_sendForm($('f_recuperar'),true,'doResetPass');" class="submit-login" /> 
            </td>
		</tr>
        {/if}
		</table>
        
     
	</div>
</div>
{x_load_js}


