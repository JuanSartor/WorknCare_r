<?php
	/**
	* 	FilesystemElement.php
	*
	*	Clase Abstrae un elemnto del filesystem (Directory ofr File o Archivo)
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
	class FilesystemElement  {
	
		var $resourse;
		var $path;
		

		function FilesystemElement($path = NULL) {
			
			
		} 
		
		
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Borra un archivo o directorio
		* 	
		* 	@return bool
		*/
		function delete($name) {

			// Se borra un directorio o archivo.
				// si es recursiva la eliminación y se trata de un directorio se borra el directorio completo
					// Si el directorio no tiene subdirectorios y solo archivos se borra	
			// Si no es recursiva y no está vacio no se borra

		}
		
	
		/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		* 
		*	Mueve un directrio a una ubicacion en particular
		* 	
		* 	@return bool
		*/
		function moveTo($path) {

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
		 *    Cuenta  la cantidad de elementos en un directorio
		 *    @author Emanuel del Barco
		 *    @param $dir strin directorio a evaluar    
		 *    @param $type tipo a buscar: directorios, archivos o ambos
		 *    @return integer cantidad de elementos encontrados                  
		 *         		 
		 */
        function countElements($dir,$type){
            switch ($type) {
                case 'dirs':
            	   return $this->countDirs($dir);
            	break;
                case 'files':
            	   return $this->countFiles($dir);
            	break;
                case 'both':
            	   return $this->countDirs($dir)+$this->countFiles($dir);
            	break;                                	
            }
        
        }                            		
		/**
		 *
		 *    Cuenta cantidad de archivos
		 */                  		
		function countFiles($dir){
            
            $counter = 0;
            if (is_dir($dir)){
                $d = dir($dir);
                while( ($entry = $d->read())){                     
                    if ($entry!= "." && $entry!= ".."){                        
                        if(is_file($dir."/".$entry)){
                            $counter++;
                        }//end if 
                    }//end if
                }//end while
            }//end if
            
            return $counter;                 
                
        }
		
		/**
		 *    cuenta cantidad de directorio
		 *
		 */                  		
        function countDirs($dir){
            
            $counter = 0;
            if (is_dir($dir)){
                $d = dir($dir);
                while( ($entry = $d->read())){ 
                    if ($entry!= "." && $entry!= ".."){
                        if(is_dir($dir."/".$entry)){
                            $counter++;
                        }//end if 
                    }//end if
                }//end while
            }//end if
            
            return $counter;                       
                    
        }        
}
?>
