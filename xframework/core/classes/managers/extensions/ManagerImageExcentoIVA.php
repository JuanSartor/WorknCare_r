<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	13/02/2017
 * 	Manager que administra la imagen de la constacia de Excento en IV adjuntada por el medico en el registro de informacion comercial 
 *
 */
class ManagerImageExcentoIVA extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "image_excento_iva", "idimage_excento_iva");


        $this->setImgContainer("informacion_comercial");
        $this->addImgType("jpg");
        $this->addThumbConfig(100, 100, "_usuario");
//          $this->setFileMaxSize(8388608); //2MB
        $this->setFilters("jpg");
    }

    public function insert($record) {

        if (!file_exists(path_files("temp/images/" . $record["hash"][0] . ".jpg"))) {
            $this->setMsg([ "msg" => "Error. Adjunte una imagen.", "result" => false]);
            return false;
        }

        $record[$this->id] = "";
        $_SESSION[$record["hash"][0]]["name"] = "";
        return parent::insert($record);
    }

    /**
     * Método que obtiene un array con los paths de las imágenes correspondientes a la constacia de Excento en IVA
     * @param type $id
     * @return string
     */
    public function getImgs($id) {
        if (is_file(path_entity_files("informacion_comercial/$id/$id.jpg"))) {

            $image_dni = array(
                "perfil" => URL_ROOT . "xframework/files/entities/informacion_comercial/$id/{$id}_usuario.jpg",
                "imagen" => URL_ROOT . "xframework/files/entities/informacion_comercial/$id/$id.jpg"
            );

            return $image_dni;
        }
    }

}
