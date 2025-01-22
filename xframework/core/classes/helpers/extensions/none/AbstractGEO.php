<?php


	include(path_libs_php("geoip/geoip.inc"));
	
	/**
	*	@autor Sebastian Balestrini <sbalestrini@gmail.com>
	*	@version 1.0
	*	Abstrae todo el funcionamiento de GeoIP
	*
	*/
	class AbstractGEO
	{ //
	
		/**
		 * Constructor
		 * Nota: $types no son extensiones, si no por ejemplo image/jpeg.	 
		 *
		 */          	
		 
		 var $gi = NULL; // VAriable que almacena la instancia de geoIP
		 
		function AbstractGEO(){
		   //constructor;
		   
			$this->gi = geoip_open(path_libs_php("geoip/GeoIP.dat"),GEOIP_STANDARD);
		   
		} // end constructor
		
        /**
        * @author  Sebastian Balestrini
        * @version 1.0
        * Obtiene el Nombre del pais de la IP Remota
        */     
        function getRemoteCountry(){
			
			// Obtengo la IP	
			$ip = $_SERVER["REMOTE_ADDR"];
	
            return $this->getCountry($ip);

        }
		
		/**
        * @author  Sebastian Balestrini
        * @version 1.0
        * Obtiene el Nombre del pais dada una IP
        */     
        function getCountry($ip){
			
           return geoip_country_name_by_addr($this->gi, $ip);      

        }
		
		/**
        * @author  Sebastian Balestrini
        * @version 1.0
        * Obtiene el Nombre del pais de la IP Remota
        */     
        function getRemoteCode(){
			
			// Obtengo la IP	
			$ip = $_SERVER["REMOTE_ADDR"];
	
            return $this->getCode($ip);

        }
		
		/**
        * @author  Sebastian Balestrini
        * @version 1.0
        * Obtiene el Nombre del pais dada una IP
        */     
        function getCode($ip){
			
           return geoip_country_code_by_addr($this->gi, $ip);      

        }
				
	} // end class ManagerUpload
	
?>