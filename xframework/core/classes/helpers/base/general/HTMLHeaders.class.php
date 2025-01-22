<?php
	/**
	*	@autor Sebastian Balestrini <sbalestrini@gmail.com>
	*	@version 1.0	2008-11-07
	*	Manager de Header de los documentos HTML
	*
	*/
	class HTMLHeaders
	{ //
		// variables
	
		/**
		 * Constructor
		 * Nota: $types no son extensiones, si no por ejemplo image/jpeg.	 
		 *
		 */          	
		function HTMLHeaders(){
		   //constructor;
		} // end constructor
		
		
		/**
		 *   
		 *  uploadImage
		 *  Sube una imagen
		 *  	 
		 *  @autor -
		 *  @param -
		 *  @return -
		 */               	
		function getJSGlobal($path, &$smarty){
			
			//require_once(path_classes("Dir.php"));
			//require_once(path_classes("File.php"));
			
			$Dir = new Dir($path);
			
			$content = array();
			$archivos_js = $Dir->getArrayFiles($path, "js_global", false);
			
			$salida_js = "";
			
			
	
			foreach ($archivos_js as $js) {
			
				$contenido = $smarty->fetch($js); 	
				
				$content = array_merge($content,$this->getContentToArray($contenido));	
				
				
			}
			
	
			
			foreach ($content as $un_js) {
				
				
				// Este es un archivo JS de los que estaban en el Header
				$File = new File($un_js);
				$salida_js .= $File->getContent();
				
				
				
			}
			
			
			return $salida_js;
					  
					  
			
		
		}//end moveTo
		
		/**
		 *
		 *
		 **/              
		function getJSGlobal2html($path, &$smarty){
		
	
			//require_once(path_classes("Dir.php"));
			//require_once(path_classes("File.php"));
			
			$Dir = new Dir($path);
			
			$content = array();
			$archivos_js = $Dir->getArrayFiles($path, "js_global", false);
			
			$salida_js = "";
			
			
	
			foreach ($archivos_js as $js) {
			
				$contenido = $smarty->fetch($js); 	
				
				$content = array_merge($content,$this->getContentToArray($contenido));	
				
				
			}
			
	
			
			foreach ($content as $un_js) {
				
				
				// Este es un archivo JS de los que estaban en el Header
				/*$File = new File($un_js);
				$salida_js .= $File->getContent();*/
				if ($un_js != ""){
				 $salida_js .= '<script language="javascript"  type="text/javascript" charset="ISO-8859-1"  src="'.$un_js.'"></script>';
				}
				
				
				
			}
			
			
			return $salida_js;
		
		}
		
		
		function getContentToArray($content , $separator = ";"){
			
			$arreglo = explode($separator, $content);
			
			foreach ($arreglo as $key=>$value) {
				$arreglo[$key] = trim($value);
			}
			
			return $arreglo;
			
	
		}
		
		
		/**
		 *   
		 *  getCssContent
		 *  REcorre un directorio y devuelve todo el contenido de los Archivos CSS como una unica salida de texto.
		 *  	 
		 *  @autor Sebastian Balestrini
		 *  @param string $path Path a los 
		 *  @return -
		 */               	
		function getCssContent($path, &$smarty){
			
			//require_once(path_classes("Dir.php"));
			//require_once(path_classes("File.php"));
			
			$Dir = new Dir($path);

			$content = array();
			$archivos_css = $Dir->getArrayFiles($path, NULL, false);
			
			$salida_css = "";
			
			
	
			foreach ($archivos_css as $css) {
			
				// Este es un archivo JS de los que estaban en el Header
				$File = new File($css);
				$salida_css .= $File->getContent();
				
			}

			return $salida_css;
				  

		}//end getCssContent
			
		
	} // end class ManagerUpload

?>
