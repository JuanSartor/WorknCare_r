<?php

  /**
   * Clase utilizada para dar el manejo de las excepciones de las páginas
   */
  class ExceptionErrorPage extends Exception {

      // Redefinir la excepción, por lo que el mensaje no es opcional
      public function __construct($message, $code = 0, Exception $previous = null) {
          parent::__construct($message, $code, $previous);
      }

      /**
       * Representación en cadena del objeto
       * 
       * @return type
       */
      public function __toString() {
          return "{$this->code}";
      }
      
      

  }
  