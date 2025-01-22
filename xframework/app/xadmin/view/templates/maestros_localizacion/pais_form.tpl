<div id="colRight">
	 
    <div class="block">
    
    <div class="title_bar"><div class="text">INFORMACIÓN GEOGRÁFICA &raquo; PAISES &raquo {if $record} EDITAR PA&Iacute;S  {else} NUEVO PA&Iacute;S {/if}</div>   

	{x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
      &nbsp;    
     {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'maestros_localizacion'" p2="'pais_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
    </div>
		<div class="top">&nbsp;</div>
        <div class="contenido">

	<input type="hidden" name="paramsReload" id="paramsReload" value="" />
	<input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

    <div class="xForm ">
	<form action="{$controller}.php?action=1&modulo=maestros_localizacion&submodulo=pais_form"  method="post"  name="f_record" id="f_record" >
    <input type="hidden" name="idpais" id="idpais" value="{$record.idpais}" />
  
    <div class="form_container ">
        <div class="title">Datos del Pa&iacute;s</div>
       	<ul>
        

        
             <li class="wide">
                <label>Nombre</label> 
                {x_form_input  id="pais" descriptor="none" isRequired="true" maxChars=45 class="" record=$record}
            </li>  

           
            <li class="clear">&nbsp;</li>
            
        </ul>
    </div> 
    

	<div class="clear">&nbsp;</div>

    
 </form>
</div> 
		</div>  
         <div class="end">&nbsp;</div> 
     </div>   
</div> 

