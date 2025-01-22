<?php
	
	/**
	*  ManagerGallery
	*
	*  Clase que maneja galerias de imagenes asociadas a una entidad	
	*  @author Xinergia <info@e-xinergia.com>	
	*  @version 1.0
	*
	*/

    require_once(path_managers("base/ManagerMedia.php"));
    	
	class ManagerGallery extends ManagerMedia {
	
		protected $my_container = "";
		protected $parent_id = "";
		
		/**
		*	@author Sebastian Balestrini
		*	@version 1.0
		*	
		*	constructor de la clase 
		*/
		function __construct($db,$table,$id) {
            
			parent::__construct($db,$table,$id);
		} 
		



        /**
        *	@author Emanuel del Barco
        *			
        *	uploadImgGallery de manager.
        *	para subir multiples imagenes para una galeria.
        *	
        *   @param int $idgaleria id de la galeria.                        
        *	@return void
        */	
        public function uploadImgGallery($id){
        
            $this->cheCkConfig();
        

            $uploader = new Uploader("Filedata", $this->getImgMaxSize(), "*");

            
            $idimagen = $this->insert(array($this->parent_id=>$id));
            
            $container = $this->my_container."/$id";	
            
            //compruebo que exista el dir, si no lo creo.
            if (! file_exists(path_entity_files($container))){                
                $dir = new Dir(path_entity_files($container));                                     
                $dir->chmod(0777);            
            }
            
            
            $name = $idimagen;
                           
                
            $result =  $uploader->moveTo(path_entity_files($container."/$name.jpg"));
            

            if ($result != false){
        
                $manImg = new Images();                
                
                foreach ($this->thumbs_config as $key=>$config) {
                                      
                    
                    //evaluar anchos y si es un thumb proporcional
                    $manImg->resize(path_entity_files($container."/$name.jpg"), 
                                    path_entity_files($container."/$name".$config["suffix"].".jpg"),
                                    $config["w"],$config["h"],$config["force_proportional"],$config["watermark"] );	
                }
                
                /*if (!is_null($this->watermark)){
                    $manImg->pasteWaterMark(path_entity_files($container."/$name.jpg"), $this->watermark);                    
                } */               

                                
            
            }else{
                //Si sale mal la subida, o es un archivo incorrecto elimino el registro creado
                //previamente.
                $this->delete($idimagen);
                
            }
                
            return $result;
          
        }



        /**
        *	@author Emanuel del Barco
        *	@version 1.0 
        *			
        *	Elimina el registro de una imagen en la base de datos.
        *   Y todos los arhivos de imagen asociados a el.	        
        *	
        *   @param int $idimagen id de la galeria.                        
        *	@return boolean
        */          
        public function deleteImage($idimagen){
            
            $this->cheCkConfig();
            
            $myImg = $this->get($idimagen);
            
            $parent_id = $myImg[$this->parent_id];
            
            $eliminado = $this->delete($idimagen,true);
           // $eliminado = true;
            
            $container = $this->my_container."/$parent_id";	            
            
            if ($eliminado){
                foreach ($this->thumbs_config as $key=>$config) {
                
                    //evaluar anchos y si es un thumb proporcional
                    $imagen =   path_entity_files($container."/$idimagen".$config["suffix"].".jpg");
                    
                    if (file_exists($imagen)){
                        unlink($imagen);       
                    }                                  
                }

                $imagen =   path_entity_files($container."/$idimagen".".jpg");

                if (file_exists($imagen)){
                    unlink($imagen);       
                } 
            
                $this->setMsg(array("result"=>true,"msg"=>"Eliminado con exito"));
                return true;                
                
            }else{
                $this->setMsg(array("result"=>false,"msg"=>"No se pudo eliminar la imagen"));
                return false;
            }
        
        
        }   


        /**
         * Checkea que los valores requeridos esten seteados
         *
         **/                                   
        private function checkConfig(){
            
            if ($this->parent_id == "" || $this->my_container == ""){
                throw new Exception("NO ha sido definido parent id o container para la galeria");
                return false;
            }
            
            return true;
        }	
		/**
		*	@author Sebastian Balestrini
		*	@version 1.0
		*
		*	Realia un ordenamiento de una secuencia de elementos de este tipo
		*
		*	@param array $sec Elementos
		*	@return array Secuencia ordenada
		*/
		public function sort($sec){
		      
            
			$ids = explode(",", $sec);
			//echo $secuencia;
			for($i=1;$i<=count($ids);$i++){
			 
             $this
                ->db
                ->Execute(
                    sprintf("UPDATE %s SET orden=%d WHERE %s = %d",$this->table,$i,$this->id,$ids[$i-1])
                );
             //$this->update(array("position"=>$i),$ids[$i-1]);
			}
			return true;

		}


               
	} // EndClass
?>