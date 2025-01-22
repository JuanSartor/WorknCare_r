	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/mootools.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/Fx.ProgressBar.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/Swiff.Uploader.js"></script>

	<script type="text/javascript" src="{$url_js_libs}/FancyUpload/FancyUploadGallery.js"></script>


{literal}
	<style type="text/css">
		/**
 * FancyUpload Showcase
 *
 * @license		MIT License
 * @author		Harald Kirschner <mail [at] digitarald [dot] de>
 * @copyright	Authors
 */

/* CSS vs. Adblock tabs */
.swiff-uploader-box a {
	display: none !important;
}

/* .hover simulates the flash interactions */
a:hover, a.hover {
	color: red;
}

#demo-status {
	padding: 10px 15px;
	width: 420px;
	border: 1px solid #eee;
}

#demo-status .progress {
{/literal}
	background: url({$url}xframework/core/libs/libs_js/FancyUpload/imgs/progress-bar/progress.gif) no-repeat;
{literal}
	background-position: +50% 0;
	margin-right: 0.5em;
	vertical-align: middle;
}

#demo-status .progress-text {
	font-size: 0.9em;
	font-weight: bold;
}

#demo-list {
	list-style: none;
	width: 450px;
	margin: 0;
}

#demo-list li.validation-error {
	padding-left: 44px;
	display: block;
	clear: left;
	line-height: 40px;
	color: #8a1f11;
	cursor: pointer;
	border-bottom: 1px solid #fbc2c4;
{/literal}
	background: #fbe3e4 url({$url}xframework/core/libs/libs_js/FancyUpload/imgs/failed.png) no-repeat 4px 4px;
{literal}
}

#demo-list li.file {
	border-bottom: 1px solid #eee;
{/literal}	
	background: url({$url}xframework/core/libs/libs_js/FancyUpload/imgs/file.png) no-repeat 4px 4px;
{literal}
	overflow: auto;
}
#demo-list li.file.file-uploading {
{/literal}
	background-image: url({$url}xframework/core/libs/libs_js/FancyUpload/imgs/uploading.png);
{literal}
	background-color: #D9DDE9;
}
#demo-list li.file.file-success {
{/literal}
	background-image: url({$url}xframework/core/libs/libs_js/FancyUpload/imgs/success.png);
{literal}
}
#demo-list li.file.file-failed {
{/literal}
	background-image: url({$url}xframework/core/libs/libs_js/FancyUpload/imgs/failed.png);
{literal}
}

#demo-list li.file .file-name {
	font-size: 1.2em;
	margin-left: 44px;
	display: block;
	clear: left;
	line-height: 40px;
	height: 40px;
	font-weight: bold;
}
#demo-list li.file .file-size {
	font-size: 0.9em;
	line-height: 18px;
	float: right;
	margin-top: 2px;
	margin-right: 6px;
}
#demo-list li.file .file-info {
	display: block;
	margin-left: 44px;
	font-size: 0.9em;
	line-height: 20px;
	clear:both;
}
#demo-list li.file .file-remove {
	clear: right;
	float: right;
	line-height: 18px;
	margin-right: 6px;
}	</style>

{/literal}
 <link href="{$url_js_libs}/FancyUpload/style.css" rel="stylesheet" type="text/css" />
    

    
<div>
			<form action="{$url}common.php?action=1&modulo=queued_photo_uploader&submodulo=upload" method="post" enctype="multipart/form-data" id="form-upload">
		
            <input type="hidden" value="{$id}" name="id" id="id" />
            <input type="hidden" value="{$manager}" name="manager" id="manager" />
            <input type="hidden" value="{$session_id}" name="session_id" id="session_id" />

	<fieldset id="demo-fallback" style="display:none">
		<legend>&nbsp;</legend>
		<label for="demo-photoupload">
			Upload a Photo:
			<input type="file" name="Filedata" />
		</label>
	</fieldset>

	<div id="demo-status" class="hide">
		<div>
			<a href="#" id="demo-browse" style="height:30px;" class="attach">Buscar Archivos</a> |
			<a href="#" id="demo-clear" class="attach">Limpiar Lista</a> |
			<a href="#" id="demo-upload" class="attach">Subir</a>
		</div>
		<div>
			<strong class="overall-title"></strong><br />
			<img src="{$url}xframework/core/libs/libs_js/FancyUpload/imgs/progress-bar/bar.gif" class="progress overall-progress" />
		</div>
		<div>
			<strong class="current-title"></strong><br />
			<img src="{$url}xframework/core/libs/libs_js/FancyUpload/imgs/progress-bar/bar.gif" class="progress current-progress" />
		</div>
		<div class="current-text"></div>
	</div>

	<ul id="demo-list" style="display:none"></ul>

</form>		</div>

<script type="text/javascript">
	{literal}
	
	
	var up = new FancyUploadGallery($('demo-status'), $('demo-list'), { // options object
		// we console.log infos, remove that in production!!
		verbose: true,
		
		// url is read from the form, so you just have to change one place
		url: $('form-upload').action,
		
		data:$('form-upload').toQueryString() ,
		
		{/literal}
		// path to the SWF file
		path: '{$url}xframework/core/libs/libs_js/FancyUpload/Swiff.Uploader.swf',
		
		{literal}
		
		// remove that line to select all files, or edit it, add more items
		typeFilter: {
			'Images (*.jpg, *.jpeg)': '*.jpg; *.jpeg'
		},
		
		// this is our browse button, *target* is overlayed with the Flash movie
		target: 'demo-browse',
		
		// graceful degradation, onLoad is only called if all went well with Flash
		onLoad: function() {
			$('demo-status').removeClass('hide'); // we show the actual UI
			$('demo-fallback').destroy(); // ... and hide the plain form
			
			// We relay the interactions with the overlayed flash to the link
			this.target.addEvents({
				click: function() {
					return false;
				},
				mouseenter: function() {
					this.addClass('hover');
				},
				mouseleave: function() {
					this.removeClass('hover');
					this.blur();
				},
				mousedown: function() {
					this.focus();
				}
			});

			// Interactions for the 2 other buttons
			
			$('demo-clear').addEvent('click', function() {
				up.remove(); // remove all files
				return false;
			});

			$('demo-upload').addEvent('click', function() {
				up.start(); // start upload
				return false;
			});
		},
		
		// Edit the following lines, it is your custom event handling
		
		/**
		 * Is called when files were not added, "files" is an array of invalid File classes.
		 * 
		 * This example creates a list of error elements directly in the file list, which
		 * hide on click.
		 */ 
		onSelectFail: function(files) {
			files.each(function(file) {
				new Element('li', {
					'class': 'validation-error',
					html: file.validationErrorMessage || file.validationError,
					title: MooTools.lang.get('FancyUpload', 'removeTitle'),
					events: {
						click: function() {
							this.destroy();
						}
					}
				}).inject(this.list, 'top');
			}, this);
		},
		
		/**
		 * This one was directly in FancyUploadGallery before, the event makes it
		 * easier for you, to add your own response handling (you probably want
		 * to send something else than JSON or different items).
		 */
		onFileSuccess: function(file, response) {
			var json = new Hash(JSON.decode(response, true) || {});
			
			if (json.get('status') == '1') {
				file.element.addClass('file-success');
				file.info.set('html', '<strong>Imagen Subida:</strong> ' + json.get('width') + ' x ' + json.get('height') + 'px, <em>' + json.get('mime') + '</em>)');
			} else {
				file.element.addClass('file-failed');
				file.info.set('html', '<strong>Ha ocurrido un error:</strong> ' + (json.get('error') ? (json.get('error') + ' #' + json.get('code')) : response));
			}
		},
		
		/**
		 * onFail is called when the Flash movie got bashed by some browser plugin
		 * like Adblock or Flashblock.
		 */
		onFail: function(error) {
			switch (error) {
				case 'hidden': // works after enabling the movie and clicking refresh
					alert('To enable the embedded uploader, unblock it in your browser and refresh (see Adblock).');
					break;
				case 'blocked': // This no *full* fail, it works after the user clicks the button
					alert('To enable the embedded uploader, enable the blocked Flash movie (see Flashblock).');
					break;
				case 'empty': // Oh oh, wrong path
					alert('A required file was not found, please be patient and we fix this.');
					break;
				case 'flash': // no flash 9+ :(
					alert('To enable the embedded uploader, install the latest Adobe Flash plugin.')
			}
		},
  {/literal}	
  {if $smarty.request.reload_func}	
		onComplete: function() {ldelim}
			parent.{$smarty.request.reload_func}();
		{rdelim}
  {/if}		
  {literal}			
	});
	

	{/literal}
</script>