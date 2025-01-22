<?php

  /**
   * 	@autor Xinergia
   * 	@version 1.0	29/05/2014
   * 	Manager que administra la imagen de DNI adjuntada por el medico en el registro de la cuenta para comprobar su identidad 
   *
   */
  class ManagerImageDNI extends ManagerMedia {

      /** constructor
       * 	@param $db instancia de adodb
       */
      function __construct($db) {

          // Llamamos al constructor del a superclase
          parent::__construct($db, "imagedni", "idimageDNI");


          $this->setImgContainer("dni_medico");
          $this->addImgType("jpg");
          $this->addThumbConfig(50, 50, "_perfil");
//          $this->setFileMaxSize(8388608); //2MB
          $this->setFilters("jpg");
      }
      
      public function insert($record) {
          
          $record[$this->id] = "";
          $_SESSION[$record["hash"][0]]["name"] = "";
          return parent::insert($record);
      }

      /**
       * Método que obtiene un array con los paths de las imágenes correspondientes a un DNI de un médico
       * @param type $id
       * @return string
       */
      public function getImgs($id) {
          if (is_file(path_entity_files("dni_medico/$id/$id.jpg"))) {
              
              $image_dni = array(
                    "perfil" => URL_ROOT . "xframework/files/entities/dni_medico/$id/{$id}_perfil.jpg",
                    "imagen" => URL_ROOT . "xframework/files/entities/dni_medico/$id/$id.jpg"
              );

              return $image_dni;
          }
      }

  }
  