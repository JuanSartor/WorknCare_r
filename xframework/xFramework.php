<?php

  // Incluimos las fuiniones globales
  require_once(PATH_ROOT . "/xframework/core/functions/function.path.php");

  
   

  // Base de Datos
  /* 	require_once(path_helpers("db/AbstractSql.php"));
    require_once(path_helpers("db/DBConnector.php")); */ /** 	
   * 	@author UTN
   * 	@version 1.0
   *
   *
   * Clase que procesa las solicitudes del sistema. 
   */
  class xFramework {

      /** Nombre que se utilizar� para referenciar a los modulos
       *
       * @var string
       */
      private $controller = NULL;/** 	
       * 	@author UTN
       * 	@version 1.0
       *
       * 
       * 	Constructor por defecto
       *
       * 	@return bool
       */

      function __construct($cname) {

          // Incluimos la clase RequestController
          if (!class_exists("RequestController")) {
              require_once(path_controllers("RequestController.php"));
          }
          $controller = $cname . "_RequestController";
          if (!class_exists($controller)) {
              require_once(path_controllers($cname . "/" . $controller . ".php"));
          }

          

          // Llamamos a la funcion Abstracta		
//          $this->controller = new $controller($cname); //$cname;
          // aca es importante que no haya error si lo hay puede haber error en algun manager

          try {
              // Llamamos a la funcion Abstracta		
              $this->controller = new $controller($cname, VIEW_DEBUG); //$cname;

              register_shutdown_function(array($this->controller, "fatalError"));
          } catch (Exception $e) {

              if (VIEW_DEBUG) {
                  die($e->getMessage());
              } else {
                  die("Ocurrió un error al inicializar la aplicación");
              }
          }
      }

      /** 	@author UTN 	@version 2.0
       * 
       * 	Realiza todo el procesamiento de la solicitud
       *
       *
       * 	@return void
       */
      public function process() {
          try {
              return $this->controller->process();
          } catch (ExceptionErrorPage $e) {
              $this->controller->accessError($e);
          }
      }

  }

  // end_class
?>