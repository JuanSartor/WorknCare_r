<?php
	/**
	*	@autor Xinergia
	*	@version 1.0
	*	Manager de Entity
	*
	*/
require_once(path_managers("base/Manager.php"));

	/** 
	* @autor Xinergia
	* Class ManagerXSeoEntity
	*/
	class ManagerXSeoEntity extends Manager 	{
			
		/** constructor
		* 	@param $db instancia de adodb
		*/
		
		function  __construct($db) {

			// Llamamos al constructor del a superclase
			parent::__construct($db,"x_seo_entities","id");
            

		} 
        
        /**
         * Insert
         * 
         *
         **/                          	
        public function insert($request){                                    
            
            $id =  parent::insert($request);
            
            if ($id){
                $this->updateMyEntities($id);
            }
            
            return $id;
            
        }        
        
		/*
        *	@author Xinergia <info@e-xinergia.com>
        *
        *   Update
        */           
        public function update($request,$id){
            
            $result =  parent::update($request,$id);
        
            if ($result){
                $this->updateMyEntities($id);
            }
            
            return $result;
            
        }


		/*
        *	@author Xinergia <info@e-xinergia.com>
        *
        *   Actualiza el todos los directorios de las entidades relacionadas
        */           
        public function updateMyEntities($id){
            
            $record = $this->get($id);
            
            $entity = $record["entity"];
            $directory = $record["directory"];
            $seo_type = $record["seo_type"];
            
            return $this->db->Execute("UPDATE x_seo SET directory='$directory', seo_type = '$seo_type' WHERE entity='$entity'");
            
        }
        
        
        /**
         * Devuelve un entity a partir del nombre de la entidad
         *
         **/                          
        public function getByEntity($entity){
            
            return $this->getByField("entity",$entity);
            
        }

		/*
        *	@author Xinergia <info@e-xinergia.com>
        *
        *   Update
        */           
        public function getList(){
            

        	$query = new AbstractSql();
        	$query->setSelect("e.*");
            $query->setFrom("x_seo_entities e");                                
            
            return parent::getList($query,false);
        
        }   
        

             
                      
	} //END_class 
	
?>