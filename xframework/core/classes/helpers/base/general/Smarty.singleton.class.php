<?php

	/**
	* 	SmartySingleton
	*
	*	@author Xinergia <info@e-xinergia.com>
	* 	@version 1.0
	*	Gestiona las conexiones a las Bases de Datos solicitadas
	*/

	// Requerimos la libreria Smarty
    require_once(path_libs_php("Smarty/Smarty.class.php"));



   /**
	* class DBConnector: Clase Administradora de conexiones MySQL
	*
	*/
	class SmartySingleton extends Smarty  {

		private static $instance;

		function __construct() {

			
            parent::__construct();
            
            $this->template_dir 	= path_smarty_templates(); 
			$this->compile_dir 	    = path_smarty_templates_c(); 
			$this->config_dir 		= path_smarty_configs(); 
			$this->cache_dir 		= path_smarty_cache(); 
			


		}

	 	/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		*
		*	Retorna la instancia para poder implementar el patrón Singleton
		*
		* 	@return void
		*/
		public static function getInstance(){

			if( !self::$instance ){
				self::$instance = new SmartySingleton();
			}
			return self::$instance;
		}

		

	 	/**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		*
		*	Activa/desactiva el debug 
		*
		*	@param bool $state  estado del debug
		* 	@return void
		*/
		public function setDebug($debug = false) {

			$this->debugging = $debug;
		}

		
	 	/**
		* 	@version 1.0
		*
		*	Activa/desactiva el caching 
		*
		*	@param bool $state  estado del caching
		* 	@return void
		*/
		public function setCaching($caching = false) {

			$this->caching = $smarty_caching;
		}
		
}
?>
