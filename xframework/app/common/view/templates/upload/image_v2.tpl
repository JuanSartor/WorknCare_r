	<script type="text/javascript" src="{$url_js_libs}/jquery/jquery-1.9.0.min.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/uploadify/jquery.uploadify.min.js"></script>


    
    <link href="{$url_js_libs}/uploadify/uploadify.css" rel="stylesheet" type="text/css" />
    
<div style="float:left">
<form name="f_upload" id="f_upload" action="{$action_x}" method="post" >
<input type="hidden" value="{$hash}" name="hash" id="hash" />
<input type="hidden" value="{$todo}" name="todo" id="todo" />
<input type="hidden" value="{$session_id}" name="session_id" id="session_id" />

<table width="350" border="0" cellpadding="0" cellspacing="0">

<tr>
    <td height="21" valign="top">
    <input type="file" name="file_upload" id="file_upload" />
    
   </td>
    <td>
    <img id="img_thumb" style="display:none" src="common.php?action=1&modulo=images&submodulo=getThumb&w=50&h=50&image={$image}&{$smarty.now|date_format:'%S'}" border="0" />
    
    <div id="imagen_original_container">
    {if $image != "temp/images/no_image.png" && $image!= ""}
    <img id="img_temp" src="common.php?action=1&modulo=images&submodulo=getThumb&w=50&h=50&image={$image}&{$smarty.now|date_format:'%S'}" border="0" />
    <a href="javascript:;" id="removeImg" title="Borrar imagen"><img src="{$url_js_libs}/FancyUpload/imgs/delete.png" border="0" /></a>
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
</table>
   
   

                    
</form>                    
</div>
<script type="text/javascript">
	$(function() {
		$('#file_upload').uploadify({
			'formData'     : {
				'hash' : '{$hash}',
				'todo' : '{$todo}',
				'session_id' :'{$session_id}'
			},
			'swf'      : '{$url_js_libs}/uploadify/uploadify.swf',
			'uploader' : $('#f_upload').attr("action"),
			'buttonText': 'Seleccionar Imagen',
			'multi': false,
			'fileTypeDesc' : 'Imagenes',
			'fileTypeExts':'{$filter}',
			'fileObjName': '{$hash}',
			'onUploadSuccess' : function(file, data, response) {
				
            	var myData = $.parseJSON(data);				
				if (myData.status == 1){
					$('#img_thumb').attr("src","common.php?action=1&modulo=images&submodulo=getThumb&w=50&h=50&image="+ myData.image +"&ms="+new Date().getTime() ).show();//random time parameter					
					$("#img_temp").hide();
				}else{
					alert(myData.error);
				}
				
        	} 			
			
		});
	});
	

/**
 *  Elimina un archivo subido previamente
 *
 **/  

var removeImg =  function(){
    
    $('#todo').val("delete");
	  

	$.ajax({
			url: $('#f_upload').prop("action"),				
			
			type: 'post',
			
			data: $('#f_upload').serialize(),
			
			dataType:"json",
		   
			success: function(myJSON) {
	  
				var status = myJSON.status; 
				if (parseInt(status)>0 ){					
					$('#todo').val("add");
					alert(myJSON.msg);
					$('#img_temp').attr("src","common.php?action=1&modulo=images&submodulo=getThumb&w=50&h=50&image=temp/images/no_image.png" +"&ms="+new Date().getTime() ).hide();               
				}else{
					 alert(myJSON.error);
				}  
									
			}
		});
	  
      
    

}

$("#removeImg").click(removeImg);

</script>