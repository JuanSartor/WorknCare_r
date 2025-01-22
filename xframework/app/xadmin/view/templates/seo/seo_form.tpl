<div id="colRight">


    
    <div class="block">
    
    <div class="title_bar"><div class="text">SEO &raquo; {if $record} EDITAR {else} NUEVO {/if}</div>   

	{x_form_html_button id="btnGuardar" label="Guardar" w="100" type="button" class="icon save"}
      &nbsp;    
     {x_form_html_button id="new" label="Volver" function_name="x_goTo" w="100" type="button" p1="'seo'" p2="'seo_list'" p3="''" p4="'Main'" p5="this" class="icon arrowleft"}
    </div>
		<div class="top">&nbsp;</div>
        <div class="contenido">

	<input type="hidden" name="paramsReload" id="paramsReload" value="" />
	<input type="hidden" name="paramsReloadWindow" id="paramsReloadWindow" value="" />          

    <div class="xForm ">
	<form action="{$controller}.php?action=1&modulo=seo&submodulo=seo_form"  method="post"  name="f_record" id="f_record" >
    <input type="hidden" name="idseo" id="idseo" value="{$record.idseo}" />

    <div class="form_container ">
        <div class="title">Seo</div>
       	<ul>
  
          <li class="wide">
            <label>Directorio</label> 
            {x_form_input  id="directory" descriptor="none" isRequired="false" maxChars=150 class="" record=$record} 
        </li>    

                 
         <li class="left">
            <label>Tipo</label> 
             {x_form_boolean  label_yes='Directory' label_no='.html' value_yes='1' value_no='0' checked=$record.seo_type default='1' name="seo_type"}     
        </li> 

          <li class="wide">
            <label>Seo</label> 
            {x_form_input  id="seo" descriptor="none" isRequired="true" maxChars=150 class="" record=$record} 
        </li>    

          <li class="wide">
            <label>Meta Title</label> 
            {x_form_input  id="meta_title" descriptor="none" isRequired="false" maxChars=200 class="" record=$record}
        </li> 
        

          <li class="wide">
            <label>Meta Keywords</label> 
            {x_form_input  id="meta_keywords" descriptor="none" isRequired="false" maxChars=250 class="" record=$record}
        </li> 
        
         <li class="texarea wide">
            <label> Meta Description </label> 
            
            {x_form_textarea  id="meta_description" name="meta_description"  isRequired="false" rows=5  maxChars=1000 value=$record.meta_description}
            
        </li>                 
        
       </ul>
       
          <div class="clear">&nbsp;</div> 
       
   </div>
  


	<div class="clear">&nbsp;</div>
    

    
 </form>
</div> 
		</div>  
         <div class="end">&nbsp;</div> 
     </div>   
</div>