<?php

	/**
	* 	AbstractSql
	*
	*	Clase para manejar consultas sql sobre una sola tabla.
	*	Historial de modificaciones:
	*		- Modificacion de la clausula Where por default para soportar otras BD diferentes de MySQL
	*
	*	@author Sebastian Balestrini emanueldb@gmail.com
	* 	@version 1.0 
	*
	*/	

    class AbstractSql{ // Comienzo class AbstractSql
    	// variables
    	var $select= NULL;
    	var $from = NULL;
        var $where = " ( 1 = 1 )";
        var $groupby = NULL;
        var $orderby = NULL;
		var $limit = NULL;
		
    	// constructor
    	function AbstractSql()
    	{ 
    		
    	} // fin constructor
    	
        /**
        * @author  Sebastian Balestrini
        * @version 1.0
        * setea los campos de la select 
        * @param string $select campo para agregar a la selecct                
        *
        */                      	
        function setSelect($select){

            $this->select=$select;

        }        
		
        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * setea la tabla del FROM
        * @param string $tabla Nombre de la tabla                
        *
        */                      	
        function setFrom($from){

            $this->from = $from;
			
        }
		
        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * setea el WHERE de la consulta
        * @param string $condicion Condicion de la consulta               
        *
        */                      	
        function setWhere($where){

                $this->where=$where;
        }

        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * setea el ORDER BY de la consulta
        * @param string $orden Orden  de la consulta               
        *
        */                      	
        function setOrderBy($orderby){

            $this->orderby=$orderby;

        }
        
		/**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * setea el GROUP BY de la consulta
        * @param string $grupo Agrupacion de la consulta               
        *
        */                      	
        function setGroupBy($groupby){
            
            $this->groupby=$groupby;
        
        }
		
		/**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * setea el LIMIT de la consulta
        * @param string $grupo Agrupacion de la consulta               
        *
        */                      	
        function setLimit($limit){

            $this->limit=$limit;

        }

		/**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * setea el LIMIT de la consulta
        * @param string $grupo Agrupacion de la consulta               
        *
        */                      	
        function getLimit(){

            return $this->limit;

        }        
		
        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * Devuelve la select de la counlta
        * @returns string $select selecct de la consulta                
        *
        */                      	
        function getSelect(){

            return $this->select;

        }

        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * retorna el FROM de la consulta
        * @returns string FROM de la consulta               
        *
        */                      	
        function getFrom(){

            return $this->from;

        }
		
        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * retorna el WHERE de la consulta
        * @returns string where de la consulta               
        *
        */                      	
        function getWhere(){

            return $this->where;

        }

        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * setea el ORDER BY de la consulta
        * @param string $orden Orden  de la consulta               
        *
        */                      	
        function getOrderBy(){

            return $this->orderby=$orderby;

        }
		
        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * retorna el GROUP BY de la consulta
        * @returns string GROUP BY de la consulta               
        *
        */                      	
        function getGroupBy(){

            return $this->groupby;

        }
		
        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * devuelve la consulta SQL
        *
        */                      	
        function getSql(){
            
			if (is_null( $this->select)) {
				 $this->select = "*";
			}
					
            $sql = sprintf("SELECT %s FROM %s WHERE %s",
                            $this->select,
                            $this->from,
                            $this->where
                            );

			if (!is_null($this->groupby)) {
				$sql .= sprintf(" GROUP BY %s ",$this->groupby);
			}

			if (!is_null($this->orderby)) {
				$sql .= sprintf(" ORDER BY %s ",$this->orderby);
			}

			if (!is_null($this->limit)) {
				$sql .= sprintf(" LIMIT %s ",$this->limit);
			}

            return $sql;

        } 


        /**
        * @author  Sebastian Balestrini
        * @version 1.0 
        * Agrega una condicion and a la consulta
        * @param string $nuevaCondicion Condicion de la consulta               
        *
        */                      	
        function addAnd($nuevaCondicion){          

            $this->where .= " AND ( $nuevaCondicion ) " ;

        }
        /**
        * @author  Emanuel del Barco
        * @version 1.0 
        * Limpia la clase, vuelve todos los valores a NULL
        * @param string $nuevaCondicion Condicion de la consulta               
        *
        */                      	
        function clear(){          

         $this->select= NULL;
         $this->from = NULL;
         $this->where = " ( 1 = 1 ) ";
         $this->groupby = NULL;
         $this->orderby = NULL;
         $this->limit = NULL;

        }  


        /**
        * @author  Emanuel del Barco
        * @version 1.0 
        * Devuelve un array cono todos los campos posibles de la consulta
        * @return array             
        *
        */                      	
        function toArray(){          
            return array(
             "select"=>$this->select,
             "from"=>$this->from ,
             "where"=>$this->where,
             "groupby"=>$this->groupby ,
             "orderby"=>$this->orderby ,
             "limit"=>$this->limit
            );
        }
        

        /**
        * @author  Emanuel del Barco
        * @version 1.0 
        * Setea la consulta a partir de un array
        * @return array             
        *
        */                      	
        function fromArray($array){          
            
            if (isset($array["select"])){
                $this->select = $array["select"];
            }

            if (isset($array["from"])){
                $this->from = $array["from"];
            }

            if (isset($array["where"])){
                $this->where = $array["where"];
            }
            
            if (isset($array["groupby"])){
                $this->groupby = $array["groupby"];
            }
            
            if (isset($array["orderby"])){
                $this->orderby = $array["orderby"];
            }     

            if (isset($array["limit"])){
                $this->limit = $array["limit"];
            }
            
            return;
        }                                             
            
                       

    } // fin class Sql

?>
