<?php
	/**
	* 	File.php
	*
	*	Clase que Abstrae un directorio
	*
	*	@author Sebastian Balestrini <sbalestrini@gmail.com>
	* 	@version 1.0 
	*
	*/	

	/**
	* class ManagerDBConnections: Clase Administradora de conexiones MySQL
	*
	*	
	*/ 
    
    require_once(path_helpers("base/files/FilesystemElement.class.php"));

	class File extends FilesystemElement  {
	
		var $resourse;
		var $path;
		

		function File($path = NULL) {
			
			if (is_null($path) || $path == "") {
				return false;
			} else {
			    $this->path = $path;     
				return is_file($path); 
			}
			
		} 
		
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Borra un archivo o directorio
		* 	
		* 	@return bool
		*/
		function delete() {

			// Se borra un archivo.			
            if (file_exists($this->path) && is_file($this->path) ){			
                return unlink($this->path);
            }else{
                return false;
            }               			 

		}
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Actualiza el path
		* 	
		* 	@return bool
		*/
		function setPath($path){
            $this->path = $path;
        }
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Mueve un directrio a una ubicacion en particular
		* 	
		* 	@return bool
		*/
		function moveTo($newPath) {
            
           if (file_exists($this->path)){                
                return rename($this->path, $newPath);
            }else{
                return false;
            }
                

		}
		
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Copia un directrio a una ubicacion en particular
		* 	
		* 	@return bool
		*/
		function copyTo($path) {
              
            
            copy($this->path, $path);

		}	     	
		
		function write($content){
           // $this->resource = fopen($this->path, "w");
           return file_put_contents($this->path,$content);
        }
	
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	devuelve una cadena de texto que contiene el path al elemento
		* 	
		* 	@return string
		*/
		function getPath() {
		
            return pathinfo($this->path,PATHINFO_DIRNAME  )."/";
        
		}
		
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	devuelve una resource del directorio
		* 	
		* 	@return string
		*/
		function getResourse() {
		
		}
		

		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Cambia los permisos del directorio
		* 	
		* 	@return string
		*/
		function chmod($mod) {
		
		  chmod($this->path, $mod);

		}		
		
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Cambia el propiedario
		* 	
		* 	@return string
		*/
		function chown($own) {
		
		}
		
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Cambia el grupo
		* 	
		* 	@return string
		*/
		function chgrp($grp) {
		
		}
		
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Cambia todas las propeidades del archivo o solo algunas
		* 	
		* 	@return string
		*/
		function chall($mod = NULL, $own = NULL, $grp = NULL) {
		
		}


		/**
		* 	
		* 	@version 1.0
		* 
		*	Devuelve el tipo mime de un archivo
		* 	
		* 	@return string
		*/		
		function getMime(){
        
            preg_match("|\.([a-z0-9]{2,4})$|i", $this->path, $fileSuffix);
    
            switch(strtolower($fileSuffix[1]))
            {
                case "js" :
                    return "application/x-javascript";
                case "json":
                    return "application/json";
                case "jpg":
                case "jpeg":
                case "jpe":
                    return "image/jpg";
                case "png":
                case "gif":
                case "bmp":
                case "tiff":
                    return "image/".strtolower($matches[1]);
                case "css":
                    return "text/css";
                case "xml":
                    return "application/xml";
                case "doc":
                case "docx":
                    return "application/msword";
                case "xls":
                case "xlt":
                case "xlm":
                case "xld":
                case "xla":
                case "xlc":
                case "xlw":
                case "xll":
                    return "application/vnd.ms-excel";
                case "ppt":
                case "pps":
                    return "application/vnd.ms-powerpoint";
                case "rtf":
                    return "application/rtf";
                case "pdf":
                    return "application/pdf";
                case "html":
                case "htm":
                case "php":
                    return "text/html";
                case "txt":
                    return "text/plain";
                case "mpeg":
                case "mpg":
                case "mpe":
                    return "video/mpeg";
                case "mp3":
                    return "audio/mpeg3";
                case "wav":
                    return "audio/wav";
                case "aiff":
                case "aif":
                    return "audio/aiff";
                case "avi":
                    return "video/msvideo";
                case "wmv":
                    return "video/x-ms-wmv";
                case "mov":
                    return "video/quicktime";
                case "zip":
                    return "application/zip";
                case "tar":
                    return "application/x-tar";
                case "swf":
                    return "application/x-shockwave-flash";
    
                default :
                if(function_exists("mime_content_type"))
                {
                    $fileSuffix = mime_content_type($filename);
                }
    
                return "unknown/" . trim($fileSuffix[0], ".");
            }
    }
    
    
    function getExtension(){
        
        preg_match("|\.([a-z0-9]{2,4})$|i", $this->path, $fileSuffix);
        
        return $fileSuffix[1];        	
    }
    
    function getName(){
        
        return pathinfo($this->path,PATHINFO_FILENAME );        	
    }    
	
	function getContent(){
		        

        return file_get_contents($this->path);

    }

	function getContentToArray($separator = ";"){
        
        $content =  file_get_contents($this->path);
		$arreglo = explode($separator, $content);
		
		foreach ($arreglo as $key=>$value) {
			$arreglo[$key] = trim($value);
		}
		
		return $arreglo;
		

    }
        
		
		
}
?>
