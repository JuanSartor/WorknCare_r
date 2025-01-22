	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/mootools.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/Fx.ProgressBar.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/Swiff.Uploader.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/FancyUploadPincho.js"></script>
    
    <link href="{$url_js_libs}/FancyUpload/style.css" rel="stylesheet" type="text/css" />

{literal}
<style>
.carpintero_img {
    background: none repeat scroll 0 0 #017C2B;
    border: 2px solid #006600;
    color: #FFFFFF;
    float: left;
    font-size: 11px;
    height: 77px;
    margin: 0 5px;
    padding: 2px;
    text-align: center;
    width: 77px;
}

.attach {
{/literal}
	background:url({$url_js_libs}/FancyUpload/imgs/bt_green.png) no-repeat top;
	width:107px;
	height:20px;
	display:block;
	float:right;
	font-family:Arial, Helvetica, sans-serif;
	font-size:13px;
	font-weight:bold;
	cursor:pointer;
	text-decoration:none;
	color:#FFFFFF;
	text-align:center;
	padding-top:4px;
	margin: 5px 10px;
{literal}	
}
.attach:hover {
{/literal}
	background:url({$url_js_libs}/FancyUpload/imgs/bt_green.png) no-repeat bottom;
{literal}
}
</style>    
{/literal}
<form name="f_upload" id="f_upload" action="{$action_x}" method="post" >
<input type="hidden" value="{$hash}" name="hash" id="hash" />
<input type="hidden" value="{$todo}" name="todo" id="todo" />
<input type="hidden" value="{$session_id}" name="session_id" id="session_id" />

{if !$image}
<img src="{$url_js_libs}/FancyUpload/imgs/noavatar.png" alt="Sin Imagen" class="carpintero_img" id="img_thumb"/>
{else}
<img src="common.php?action=1&modulo=images&submodulo=getThumb&w=100&h=100&image={$image}&{$smarty.now|date_format:'%S'}" alt="Sin Imagen" class="carpintero_img" id="img_thumb"/>
{/if}
<p>Cargue el logo de su empresa</p>

    <a href="#" class="attach" id="attach-1">ADJUNTAR</a>
  	<ul class="attach-list" id="attach-list-1" style="display:none"></ul>
    
{*<table width="350" border="0" cellpadding="0" cellspacing="0">

<tr>
    <td height="21" valign="top">
    <a href="#" class="attach" id="attach-1">Adjuntar Imagen</a>
  	<ul class="attach-list" id="attach-list-1"></ul>
   </td>
    <td>
    <img id="img_thumb" style="display:none" src="common.php?action=1&modulo=images&submodulo=getThumb&w=40&h=40&image={$image}&{$smarty.now|date_format:'%S'}" border="0" />
    
    <div id="imagen_original_container">
    {if $image != "temp/images/no_image.png" && $image!= ""}
    <img id="img_temp" src="common.php?action=1&modulo=images&submodulo=getThumb&w=40&h=40&image={$image}&{$smarty.now|date_format:'%S'}" border="0" />
    <a href="javascript:;" onclick="removeImg()" title="Borrar imagen"><img src="{$url_js_libs}/FancyUpload/imgs/delete.png" border="0" /></a>
     {/if}
    </div>
   
    </td>
    <td>&nbsp;</td>
</tr>
<tr>
    <td height="83">&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
</tr>
</table>*}
   
   

                    
</form>                    
</div>
<div style="float:right">
</div>
<script type="text/javascript">
{literal}
	//createImgAttach();
	
	/**
	 * Uploader instance
	 */
	var list = "attach-list-1"; 
    var button = "attach-1";
    var item = 1;

	var up = new FancyUploadPincho.Attach(list, button, {
{/literal}	
		path: '{$url}xframework/core/libs/libs_js/FancyUpload/Swiff.Uploader.swf',
{literal}
		url: $('f_upload').action,
		data: $('f_upload').toQueryString() , 
		fieldName: $('hash').get('value'), 
		fileSizeMax: 500 * 1024 * 1024,
		fileListMax: 2,
		
		verbose: true,
		
		onSelectFail: function(files) {
			files.each(function(file) {
				new Element('li', {
					'class': 'file-invalid',
					events: {
						click: function() {
							this.destroy();
						}
					}
				}).adopt(
					new Element('span', {html: file.validationErrorMessage || file.validationError})
				).inject(this.list, 'bottom');
			}, this);	
		},
		
		onFileSuccess: function(file,response) {
	        
            var myJSON = JSON.decode(response, true);
            
            var status = myJSON.status;
	        
	        if (parseInt(status)>0 ){
    		    var hash=  myJSON.name;
            	new Element('input', {type: 'hidden', 'checked': true ,"id":"item_"+item,"name":"name_"+item,"value":hash }).inject(file.ui.element, 'top');
    			file.ui.element.highlight('#e6efc2');	
                
                file.ui.cancel.set('html', 'Eliminar').removeEvents().addEvent('click', function() {
    				if (confirm("Eliminar esta imagen?")){
                        removeImgTemp();
        				file.remove();
        				return false;
        			}
    			});
    			
    			$('img_thumb').setProperty("src","common.php?action=1&modulo=images&submodulo=getThumb&w=100&h=100&image="+ myJSON.image +"&ms="+new Date().getTime() );//random time parameter

    			//$('img_thumb').setStyle('display', 'inline');
				
				// Ocultamos la imagen origial si existe
				//$('imagen_original_container').setStyle('display', 'none');
    			
    		 }else{
                alert(status = JSON.decode(response, true).error);
                file.remove();
             }
             	

                        
            		
		},
		
		onFileError: function(file) {
			file.ui.cancel.set('html', 'Retry').removeEvents().addEvent('click', function() {
				file.requeue();
				return false;
			});
			
			new Element('span', {
				html: file.errorMessage,
				'class': 'file-error'
			}).inject(file.ui.cancel, 'after');
		},
		
		onFileRequeue: function(file) {
			file.ui.element.getElement('.file-error').destroy();
			
			file.ui.cancel.set('html', 'Cancel').removeEvents().addEvent('click', function() {
				file.remove();
				return false;
			});
			
			this.start();
		}
		
	});	


/**
 *  Elimina un archivo subido previamente
 *
 **/  

function removeImg(){
    
    
    $('todo').set("value","delete");
    
    var myRequest = new Request({
         method: 'post',
         url:$('f_upload').action,
         /*onRequest: function() { ;},*/
         onSuccess: function(responseText, responseXML){
            
            var myJSON = JSON.decode(responseText, true);            
            var status = myJSON.status; 
            if (parseInt(status)>0 ){
                alert(myJSON.msg);
                $('img_temp').setProperty("src","common.php?action=1&modulo=images&submodulo=getThumb&w=40&h=40&image=temp/images/no_image.png" +"&ms="+new Date().getTime() );               
            }else{
                 alert(myJSON.error);
            }                                                              
                         
        },
         onFailure: function(){alert('Error');}
      }).send($('f_upload').toQueryString());
      
    $('todo').set("value","add");

}

function removeImgTemp(){
    
    
    $('todo').set("value","delete_temp");
    
    var myRequest = new Request({
         method: 'post',
         url:$('f_upload').action,
         /*onRequest: function() { ;},*/
         onSuccess: function(responseText, responseXML){
            
            var myJSON = JSON.decode(responseText, true);            
            var status = myJSON.status; 
            if (parseInt(status)>0 ){
                //alert(myJSON.msg);
                $('img_thumb').setStyle('display', 'none');
				
				// Ocultamos la imagen origial si existe
				$('imagen_original_container').setStyle('display', 'inline');
				
                //$('img_thumb').setProperty("src","common.php?action=1&modulo=images&submodulo=getThumb&w=50&h=50&image=temp/images/no_image.png" +"&ms="+new Date().getTime() );
            }else{
                 alert(myJSON.error);
            }                                                              
                         
        },
         onFailure: function(){alert('Error');}
      }).send($('f_upload').toQueryString());
      
    $('todo').set("value","add");

}
	
{/literal}

{if $filter!= ""}
	up.options.typeFilter = {ldelim}{$filter}{rdelim};
{/if}
</script>