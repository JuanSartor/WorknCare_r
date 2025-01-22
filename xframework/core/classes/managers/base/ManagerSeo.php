<?php
	
	/**
	*  Manager
	*
	*  Clase que maneja las entidades que abstrae los comportamientos genericos que pueden realizarse sobre las tablas.
	*
	*  @author Sebastian Balestrini <sbalestrini@gmail.com>
	*  @version 1.0
	*
	*/	
	

	require_once(path_managers("base/ManagerMediaOrdenable.php"));	
	
	class ManagerSeo extends ManagerMediaOrdenable {

        private $managerSeo = NULL;

		/**
		*	@author Emanuel del Barco
		*	@version 1.0
		*	
		*	constructor de la clase 
		*/
		function __construct($db,$table,$id,$title_seo = "titulo", $flag = NULL) {
            
			parent::__construct($db,$table,$id, $flag);
		
            $this->managerSeo = $this->getManager("ManagerXSeo");
            
            $this->managerSeo->configEntity($table,$title_seo);
        } 
		
		
		/**
		*	@author Sebastian Balestrini
		*	@version 1.0
		*	
		*	Inserta un registro en la tabla correspondiente basandose en el arraglo recibido como parametros 
		*	
		*	@param mixed $record Arreglo que contiene todos los campos a insertar
		*	@return int Retorna el ID Insertado o 0
		*/
		public function insert($record) {
            
            
            $newid =  parent::insert($record);
							
			if($newid){                
                
                $this->managerSeo->setSeo($newid,$record);
                			     
                //return false;
                //$this->setMsg("[true]New record: Ok[true]");
                return $newid;
			}else {
				//$this->setMsg("[error]Error[error]");
				return false;
			}
		}


		/**
		*	@author Sebastian Balestrini
		*	@version 1.0
		*
		*	Realiza Update de un registro
		*
		*	@param mixed $record Arreglo que contiene todos los campos para su actualizacion
		*	@param int $id PrimaryKey del registro a actualizar.
		*
		*	@return booelan Retorna verdadero o falso segun se haya o no realizado el UPDATE correctamente
		*/
		public function update($record,$id = NULL) {

			$result = parent::update($record,$id);
            
            if ($result && isset($record["idseo"])){
                
                $this->managerSeo->setSeo($id,$record);
            }
            
            return $result;
        }		
		
		/**
		*	@author Sebastian Balestrini
		*	@version 1.0
		*	
		*	Elimina un registro de la tabla alumnos
		*	
		*	@return booelan Retorna verdadero o falso segun se haya o no realizado el DELETE correctamente
		*/
		public function delete($id,$force = false) {
                                    
			$result =  parent::delete($id,$force);

            if ($result){
                $this->managerSeo->deleteSeo($id);
            }
            
            return $result;
		}


		/**
		*	@author Emanuel del Barco
		*	@version 1.0
		*	
		*	Obitnene un registro buscando los meta datos
		*	
		*	@retorna un registro
		*/	                        
        public function get($id){
            
            $record = parent::get($id);
            
            if ($record){
                $record["seo"] = $this->managerSeo->getSeo($id);
            }
            
            return $record;
            
        }
        


		/**
		*	@author Emanuel del Barco
		*	@version 1.0
		*	
		*	Obitnene un registro buscando a partir del seo encontrado en el manager seo
		*	
		*	@retorna un registro
		*/	                        
        public function getBySeo($seo){
            
            
            $record_related = $this->managerSeo->getBySeo($seo);
            
            if ($record_related){
            
                return $this->get($record_related["idrelated"]);
                 
            }else{
                
                return false;
            }                        
            
        }

	
	} // EndClass
?>