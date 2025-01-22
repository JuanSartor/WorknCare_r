<?php
	/**
	* 	Date.php
	*
	*	Clase que Abstrae una Fecha
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
	class Date {
	

		function Date() {
			
			
		} 
		
		/**
		*
		*	@author Sebastian Balestrini 
		*	@version 1.0
		*    
		*   devuelve un arreglo de Meses para un idioma determinado
		*	@param string $lang idioma
		*	@return array Arreglo de meses
		*	@todo completar para los demas idiomas diferentes al español
		*         		 
		*/                  		
		function getMonths($lang = "es"){

             switch ($lang) {  
                case "es" :                           
							$meses = array (1 => "Enero",
											2 => "Febrero",
											3 => "Marzo",
											4 => "Abril",
											5 => "Mayo",
											6 => "Junio",
											7 => "Julio",
											8 => "Agosto",
											9 => "Septiembre",
											10 =>"Octubre" ,
											11 =>"Noviembre" ,    
											12 =>"Diciembre"
											);
							break;
                case "en" :                           
							$meses = array (1 => "Enero",
											2 => "Febrero",
											3 => "Marzo",
											4 => "Abril",
											5 => "Mayo",
											6 => "Junio",
											7 => "Julio",
											8 => "Agosto",
											9 => "Septiembre",
											10 =>"Octubre" ,
											11 =>"Noviembre" ,    
											12 =>"Diciembre"
											);
							break;
                case "fr" :                           
							$meses = array (1 => "Enero",
											2 => "Febrero",
											3 => "Marzo",
											4 => "Abril",
											5 => "Mayo",
											6 => "Junio",
											7 => "Julio",
											8 => "Agosto",
											9 => "Septiembre",
											10 =>"Octubre" ,
											11 =>"Noviembre" ,    
											12 =>"Diciembre"
											);
							break;
                case "pt" :                           
							$meses = array (1 => "Enero",
											2 => "Febrero",
											3 => "Marzo",
											4 => "Abril",
											5 => "Mayo",
											6 => "Junio",
											7 => "Julio",
											8 => "Agosto",
											9 => "Septiembre",
											10 =>"Octubre" ,
											11 =>"Noviembre" ,    
											12 =>"Diciembre"
											);
							break;                                    
            }
            
            return $meses;
        }

		/**
		*
		*	@author Sebastian Balestrini 
		*	@version 1.0
		*    
		*   devuelve un arreglo de Dias para un idioma determinado
		*	@param string $lang idioma
		*	@return array Arreglo de dias
		*	@todo completar para los demas idiomas diferentes al español
		*         		 
		*/
		function getDaysOfWeek($lang = "es"){                                   
			
			switch ($lang) {  
				case "es" :                                	       	
							$dias = array(
									0 => "Domingo",
									1 => "Lunes",
									2 => "Martes",
									3 => "Mi&eacute;rcoles",
									4 => "Jueves",
									5 => "Viernes",
									6 => "S&aacute;bado",	
								);
							break;
				case "en" :                                	       	
							$dias = array(
									0 => "Domingo",
									1 => "Lunes",
									2 => "Martes",
									3 => "Mi&eacute;rcoles",
									4 => "Jueves",
									5 => "Viernes",
									6 => "S&aacute;bado",	
								);
							break;
				case "pt" :                                	       	
							$dias = array(
									0 => "Domingo",
									1 => "Lunes",
									2 => "Martes",
									3 => "Mi&eacute;rcoles",
									4 => "Jueves",
									5 => "Viernes",
									6 => "S&aacute;bado",	
								);
							break;
				case "fr" :                                	       	
							$dias = array(
									0 => "Domingo",
									1 => "Lunes",
									2 => "Martes",
									3 => "Mi&eacute;rcoles",
									4 => "Jueves",
									5 => "Viernes",
									6 => "S&aacute;bado",	
								);
							break;                                	
			}
		}        
			
			
	} //EndClass

?>