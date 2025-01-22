<?php
	/**
	*	@autor Xinergia Web - www.xinergiaweb.com
	*	@version 1.0
	*
	*
	*/

	
	// Incluimos la superclase Gestor
	require_once(path_managers("base/ManagerMedia.php"));	
	

	/** 
	* @autor Xinergia Web - www.xinergiaweb.com
	* @version 1.0
	* Class ManagerOrdenable
	* 
	*/
	class ManagerOrdenable extends ManagerMedia 	{
	
        private $parent_name = NULL;

		/*
        *	@author Xinergia Web - www.xinergiaweb.com 
        *
        *   Inserta un nuevo registro/si se subio un archivo ste lo asocia
        *           
        *
        *   @return int|boolean id del usuario creado o false en caso de error
        *
        */        
        public function insert($request){
        
        
            if (!is_null($this->parent_name)){
                $parent = $request[$this->parent_name];
            }else{
                $parent = NULL;
            }
            
                
            $request["position"] = $this->getOrdenUltimoValor($parent)+1;                            
                            
            $id = parent::insert($request);
            
            return $id;      
        }

        /**
        * Ordenar, obtiene el orden de ultimo registro 
        *
        **/                             
        protected function getOrdenUltimoValor($parent = NULL){
            
            
            if (!is_null($parent) && !is_null($this->parent_name)){
                $rs = $this->db->Execute( sprintf("SELECT MAX(position) AS ultimo FROM %s WHERE %s = '%s'",$this->getTable(), $this->parent_name,$parent ));
            }else{
                $rs = $this->db->Execute( sprintf("SELECT MAX(position) AS ultimo FROM %s",$this->getTable()));
            } 
            
            
            if ($rs){
                $result = $rs->FetchRow();
                return $result["ultimo"];
            }else{
                return 0;
            }
            
        }  



        /**
        * Ordenar, obtiene el primer orden para un rango
        *
        **/ 

        private function getOrdenPrimerValor($parent = NULL){

            if (!is_null($parent) && !is_null($this->parent_name)){
                $rs = $this->db->Execute( sprintf("SELECT  MIN(position) AS primero FROM %s WHERE %s = '%s'",$this->getTable(), $this->parent_name,$parent));
            }else{
                $rs = $this->db->Execute(sprintf("SELECT MIN(position) AS primero FROM %s",$this->getTable()));
            } 
                  
            
            if ($rs){
                $result = $rs->FetchRow();
                return $result["primero"];
            }else{
                return 0;
            }
            
        }                  


        /**
        * Ordenar, mueve en uno el orden hacia arriba
        *
        **/ 
        
        public function moverOrdenArriba($id){  
                    
            $record = $this->get($id);            
            
            if (is_null($this->parent_name)){
                $parent = NULL;
            }else{
                $parent = $record[$this->parent_name];
            }
            
            if ($record["position"]> 1 && $record["position"] != $this->getOrdenPrimerValor($parent)){
                
                $orden_nuevo = $record["position"]-1;
                
                $record_viejo = $this->getRecordByOrden($orden_nuevo,$parent);
                
                if ($record_viejo){
                    $this->setOrden($record_viejo[$this->getId()],$record["position"],$parent);
                }
                
                $this->setOrden($id,$orden_nuevo,$parent);
                
                //$this->setMsg("[true]Actualizado[true]");
                
            }else{
                //$this->setMsg("[false]No hay valores para ordenar[false]");
            }
            
            return;        
        }


        /**
        * Ordenar, mueve en uno el orden hacia Abajo
        *
        **/         
        public function moverOrdenAbajo($id){  

            $record = $this->get($id);    

            if (is_null($this->parent_name)){
                $parent = NULL;
            }else{
                $parent = $record[$this->parent_name];
            }
            
            if ($record["position"] != $this->getOrdenUltimoValor($parent)){
                
                $orden_nuevo = $record["position"]+1;
                
                $record_viejo = $this->getRecordByOrden($orden_nuevo,$parent);
                
                if ($record_viejo){
                    $this->setOrden($record_viejo[$this->getId()],$record["position"],$parent);
                }
                
                $this->setOrden($id,$orden_nuevo,$parent);
                
                //$this->setMsg("[true]Actualizado[true]");
                
            }else{
                //$this->setMsg("[false]No hay valores para ordenar[false]");
            }
            
            return;        
        }        

        /**
        * Ordenar, obtiene un usuario para un orden y rango
        *
        **/   
        
        private function getRecordByOrden($orden,$parent = NULL){

            if (!is_null($parent) && !is_null($this->parent_name)){
                $rs = $this->db->Execute( sprintf("SELECT *  FROM %s WHERE  position = $orden AND %s = '%s'",$this->getTable(), $this->parent_name,$parent));
            }else{
                $rs = $this->db->Execute(sprintf("SELECT *  FROM %s WHERE position = $orden",$this->getTable()));
            }             
            
            if ($rs){
                $result = $rs->FetchRow();
                return $result;
            }else{
                return false;
            }
        
        }

        /**
        * Ordenar, Establece si es posible un orden especifico
        *
        **/           
        public function setOrden($id,$orden,$parent){
                         
        
             if ((int)$orden > 0){
                
                $record = $this->get($id);
                
                $ultimo = $this->getOrdenUltimoValor($parent);
                
                if ($orden > $ultimo && $ultimo > 0){
                    $orden = $ultimo +1;
                }
                
               // $this->setMsg("[true]ok[true]");
                
                return $this->db->Execute(sprintf("UPDATE %s SET position=$orden WHERE %s=$id",$this->getTable(),$this->getId()));                
             
             }else{
               // $this->setMsg("[false]ko[false]");
             }             
            
        }
		
		
		/**
		 *
		 **/
         public function setOrderParentName($name = NULL){
            $this->parent_name =  $name;        
         }
         
         /**
          *
          **/                   
         public function getOrderParentName(){
            return $this->parent_name =  $name;        
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
                    sprintf("UPDATE %s SET position=%d WHERE %s = %d",$this->table,$i,$this->id,$ids[$i-1])
                );
             //$this->update(array("position"=>$i),$ids[$i-1]);
			}
			return true;

		}

	} //END_class 
	
?>