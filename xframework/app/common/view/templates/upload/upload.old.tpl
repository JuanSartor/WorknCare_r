	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/mootools.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/Fx.ProgressBar.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/Swiff.Uploader.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/FancyUploadUploader.js"></script>

    
    <link href="{$url_js_libs}/FancyUpload/style.css" rel="stylesheet" type="text/css" />

<div style="float:left">
<form action="{$action_x}" method="post" enctype="multipart/form-data" name="f_upload" id="f_upload">
	<input type="hidden" value="{$hash}" name="hash" id="hash" />
	<input type="hidden" value="{$todo}" name="todo" id="todo" />
    <input type="hidden" value="{$session_id}" name="session_id" id="session_id" />
</form>
</div>
<div>
  <a href="#" class="attach" id="attach-1">Subir archivo</a>
  	<ul class="attach-list" id="attach-list-1"></ul>
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

	var up = new FancyUploadUploader.Attach(list, button, {
		path: 'xframework/core/libs/libs_js/FancyUpload/Swiff.Uploader.swf',
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
                
                file.ui.cancel.set('html', 'Remove').removeEvents().addEvent('click', function() {
    				if (confirm("Eliminar el archivo?")){
                        removeFileTemp();
        				file.remove();
        				return false;
        			}
    			});
    			    		
    			
    		 }else{
                
                //console.debug(response);
                //alert(status = JSON.decode(response, true).error);
                parent.x_alert("No se pudeo adjuntar el archivo, por favor compruebe el tama&ntilde;o del mismo");
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


function removeFileTemp(){
    
    
    $('todo').set("value","delete_temp");
    
    var myRequest = new Request({
         method: 'post',
         url:$('f_upload').action,
         /*onRequest: function() { ;},*/
         onSuccess: function(responseText, responseXML){
            
            var myJSON = JSON.decode(responseText, true);            
            var status = myJSON.status; 
            if (parseInt(status)<=0 ){
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