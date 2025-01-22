
        	<script type="text/javascript" src="{$url_js_libs}/jquery/jquery-1.9.0.min.js"></script>


	<script type="text/javascript" src="{$url_js_libs}/uploadifive/jquery.uploadifive.js"></script>


    
    <link href="{$url_js_libs}/uploadifive/uploadifive.css" rel="stylesheet" type="text/css" />



<div style="float:left">
<form action="{$action_x}" method="post" enctype="multipart/form-data" name="f_upload" id="f_upload">
	<input type="hidden" value="{$hash}" name="hash" id="hash" />
	<input type="hidden" value="{$todo}" name="todo" id="todo" />
    <input type="hidden" value="{$session_id}" name="session_id" id="session_id" />
</form>
</div>
<div>
<input type="file" name="file_upload" id="file_upload" />
</div>
<script type="text/javascript">

	setTimeout(function () {ldelim}
	$(function() {
		$('#file_upload').uploadifive({
			'formData'     : {
				'hash' : '{$hash}',
				'todo' : '{$todo}',
				'session_id' :'{$session_id}'
			},
			'uploadScript' : $('#f_upload').attr("action"),
			'buttonText': 'Seleccionar Archivo',
			'multi': false,
			'fileTypeDesc' : 'Archivos',
			'fileType':'{$filter}',
			'fileObjName': '{$hash}',
			'removeCompleted':false,
			'onUploadComplete' : function(file, data) {
            	var myData = $.parseJSON(data);				
				if (myData.status == 1){
					;					
				}else{
					alert(myData.error);
				}
				
        	} 			
			
		});
		{rdelim},0);		
	});


</script>