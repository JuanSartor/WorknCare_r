<?php

	require_once(path_classes("helpers/base/general/smsc.class.php"));
 /**
	* class XSMS: Clase Administradora de envio de sms mediante plataforma SMSC
	*
	*/
	class XSMS extends SMSC   {

		
		private static $instance;

                function __construct($NOMBRE_CREDENCIALES_SMSC, $CREDENCIALES_SMSC) {
                    
                    parent::__construct($NOMBRE_CREDENCIALES_SMSC,$CREDENCIALES_SMSC);
                    
                }
                
                /**
		* 	@author Sebastian Balestrini
		* 	@version 1.0
		*
		*	Retorna la instancia para poder implementar el patr�n Singleton
		*
		* 	@return void
		*/
		public static function getInstance(){

			if( !self::$instance ){
				self::$instance = new XSMS(NOMBRE_CREDENCIALES_SMSC,CREDENCIALES_SMSC);
			}
			return self::$instance;
		}

        }
