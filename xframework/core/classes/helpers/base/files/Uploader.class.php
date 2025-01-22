<?php

/**
 * 	@autor Xinergia
 * 	@version 1.0	2008-04-14
 * 	Manager de upload de archivos
 *
 */
class Uploader { // class ManagerUpload
    // variables

    var $types = NULL;
    var $maxSize = 9000000;
    var $fieldName = "";

    /**
     * Constructor
     * Nota: $types no son extensiones, si no por ejemplo image/jpeg.	 
     *
     */
    function Uploader($fieldName, $maxSize = 9000000, $descriptionType = NULL) {
        $this->fieldName = $fieldName;
        $this->maxSize = $maxSize;
        //tipos posibles de archivo.		
        if (is_array($descriptionType)) {
            foreach ($descriptionType as $key => $type) {
                $types = $this->getMimeTypeByDescription($type);
                if (!is_null($types)) {

                    $types = explode(",", $types);

                    foreach ($types as $key => $newType) {
                        $this->types[] = $newType;
                    }
                }
            }
        } else {
            $types = $this->getMimeTypeByDescription($descriptionType);
            if (!is_null($types) && $types != "*") {
                $this->types = explode(",", $types);
            } elseif ($types == "*") {
                $this->types = "*";
            }
        }
    }

// end constructor

    /**
     *   
     *  Valida un archivo y lo mueve al directorio y archivo
     *  pasado como paramtreo
     *  	 
     *  @autor Xinergia
     *  @param $field string nombre del campo del arreglo $_FILES
     *  @param $newFile string ruta y nombre del archivo subido            	     
     *  @return integer resultado de la subida del archivo
     *     true: subida correcta
     *      0: No hay ningun archivo para subir.	 
     *     -1: Maximo del archivo superado                     
     *     -2: Tipo de archivo incorrecto
     *     -3: Error de directorio	 
     */
    function moveTo($newFile) {

        $result = $this->validate();

        if ($result > 0) {
            if (move_uploaded_file($_FILES[$this->fieldName]['tmp_name'], $newFile)) {
                return true;
            } else {
                return -3;
            }
        } else {
            return $result;
        }
    }

//end moveTo

    function getTempFile() {

        return $_FILES[$this->fieldName]['tmp_name'];
    }

    function getFileName() {
        return $_FILES[$this->fieldName]['name'];
    }

    /**
     * Valida un archivo para ser subido.
     * True: no hay errores     
     * Codigos de error:
     * 0: no hay archivo seteado
     * -1: Maximo tama�o de arhivo superado
     * -2: Tipo de archivo ah subir no permitido.          
     */
    function validate() {


        $file = $_FILES[$this->fieldName];

        //no hay archivo seteado
        if (!$file) {
            return 0;
        }

        //superado maximo permitido                    
        if ($file['size'] > $this->maxSize) {
            return -1;
        }

        //tipos de archivos permitidos

        if (!is_null($this->types)) {
            if (is_array($this->types)) {
                if ($file['type'] == "application/octet-stream") {
                    $file['type'] = "image/jpeg";
                }
                if (in_array($file['type'], $this->types)) {
                    return true;
                } else {
                    return -2;
                }
            } elseif ($this->types == "*") {
                return true;
            } else {
                return -2;
            }
        } else {
            return 1;
        }
    }

//end validate

    function getExtensionFromTempFile() {

        $file = $_FILES[$this->fieldName];

        if ($file) {
            return $this->getExtensionFromMime($file["type"]);
        } else {
            return false;
        }
    }

    /**
     *  Retorna el un tipo mime segun un descriptor
     *     
     *  @autor Xinergia
     *  @param $description descripcion del tipo mime
     *  @return $string tipo mime	 
     *     
     */
    function getMimeTypeByDescription($description) {


        $result = "";

        switch ($description) {
            case 'flash':
                $result = "application/x-shockwave-flash";
                break;
            case 'jpg':
                $result = "image/pjpeg,image/jpeg,image/jpg";
                break;
            case 'gif':
                $result = "image/gif";
                break;
            case 'png':
                $result = "image/png";
                break;
            case 'flash':
                $result = "application/octet-stream,image/pjpeg,image/jpeg";
                break;
            case 'multi_img':
                $result = "image/pjpeg,image/jpeg,image/jpg,image/gif,image/png";
                break;
            case '*':
                $result = "*";
                break;
        }

        return $result;
    }

    function getExtensionFromMime($mime) {
        switch ($mime) {
            case 'application/x-shockwave-flash':
                $result = "swf";
                break;
            case 'image/pjpeg':case 'image/jpeg':
                $result = "jpg";
                break;
            case 'image/gif':
                $result = "gif";
                break;
            case 'image/png':
                $result = "png";
                break;
            case 'application/pdf':
                $result = "pdf";
                break;
            // este ultimo case lo agrego Juan el 30-03-2023 para aceptar pptx
            case 'application/vnd.openxmlformats-officedocument.presentationml.presentation':
                $result = "pptx";
                break;
        }

        return $result;
    }

    function getMimeFromTempFile() {

        $file = $_FILES[$this->fieldName];

        if ($file) {
            return $file["type"];
        } else {
            return false;
        }
    }

    function getExtensionFromUploadedFile() {

        $file = $_FILES[$this->fieldName];

        if ($file) {

            $path_parts = pathinfo($file["name"]);

            return strtolower($path_parts['extension']);
        } else {
            return false;
        }
    }

    /**
     *  Retorna un hash para una cofiguracion de uplad
     *     
     *  @autor Xinergia
     *  @return $string hash md5 de time.	 
     *     
     */
    function getHashConfig() {
        return md5(time() + rand(1, 1000) + rand(1000, 2000));
    }

}

// end class ManagerUpload
?>
