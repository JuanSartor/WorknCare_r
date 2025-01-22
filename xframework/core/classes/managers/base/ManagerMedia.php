<?php

/**
 *  Manager
 *
 *  Clase que maneja las entidades que manejan imagenes y archivos de medios
 *  @author Sebastian Balestrini <sbalestrini@gmail.com>
 *  @author Xinergia <info@e-xinergia.com>	
 *  @version 1.0
 *
 */
//require_once(path_managers("base/Manager.php"));
require_once(path_managers("base/Manager.php"));

class ManagerMedia extends Manager {

    protected $img_types = array(); //arrray de tipo de imagenes
    protected $thumbs_config = array(); //array de resolusiones para los thumbs
    protected $img_w = 0;
    protected $img_h = 0;
    protected $watermark = NULL;
    protected $imgContainer = ""; //directorio donde se alojaran las imagenes asociadas a la entiedad.
    protected $fileContainer = ""; //directorio donde se alojaran los archivos adjuntos asociadas a la entiedad.
    protected $imgContainerMultiple = ""; //directorio donde se alojaran los archivos múltiples adjuntos asociadas a la entiedad.
    protected $img_max_size = 9000000;
    protected $filter = "";
    protected $evaluateMinPixelSize = true;
    protected $minWidthPixelSize = 90;
    protected $minHeightPixelSize = 90;

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 	
     * 	constructor de la clase 
     */
    function __construct($db, $table, $id) {

        parent::__construct($db, $table, $id);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 	
     * 	Inserta un registro en la tabla correspondiente basandose en el arraglo recibido como parametros 
     * 	
     * 	@param mixed $record Arreglo que contiene todos los campos a insertar
     * 	@return int Retorna el ID Insertado o 0
     */
    public function insert($record) {

        $newid = parent::insert($record);

        if ($newid) {
            //si tiene contenedor de imgen creamos el subdirectorio para el id
            if ($this->imgContainer != "") {

                $dir = new Dir(path_entity_files($this->imgContainer . "/$newid"));

                $dir->chmod(0777);
                //si se subio una imgen temporal ccopiamos la imagen y generamos los thumbs
                if (isset($record["hash"])) {

                    if (is_array($record["hash"])) {

                        foreach ($record["hash"] as $hash) {
                            if ($_SESSION[$hash]["image"] != "" && file_exists(path_root($_SESSION[$hash]["image"])) && is_file(path_root($_SESSION[$hash]["image"]))) {
                                if ($_SESSION[$hash]["name"] != "") {
                                    $this->modifyImg(path_root($_SESSION[$hash]["image"]), $newid, $_SESSION[$hash]["name"]);
                                } else {
                                    $this->modifyImg(path_root($_SESSION[$hash]["image"]), $newid);
                                }
                            }
                        }
                    } else {

                        $hash = $record["hash"];
                        if ($_SESSION[$hash]["image"] != "" && file_exists(path_root($_SESSION[$hash]["image"])) && is_file(path_root($_SESSION[$hash]["image"]))) {
                            if ($_SESSION[$hash]["name"] != "") {
                                $this->modifyImg(path_root($_SESSION[$hash]["image"]), $newid, $_SESSION[$hash]["name"]);
                            } else {
                                $this->modifyImg(path_root($_SESSION[$hash]["image"]), $newid);
                            }
                        }
                    }
                }
            }
            //return false;

            $this->setMsg(array("result" => true, "msg" => "Datos guardados con éxito", "id" => $newid));

            return $newid;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error"));
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Realiza Update de un registro
     *
     * 	@param mixed $record Arreglo que contiene todos los campos para su actualizacion
     * 	@param int $id PrimaryKey del registro a actualizar.
     *
     * 	@return booelan Retorna verdadero o falso segun se haya o no realizado el UPDATE correctamente
     */
    public function update($record, $id = NULL) {

        $result = parent::update($record, $id);

        if ($result && $this->imgContainer != "") {

            if (isset($record["hash"])) {

                if (is_array($record["hash"])) {

                    foreach ($record["hash"] as $hash) {

                        if ($_SESSION[$hash]["image"] != "" && file_exists(path_root($_SESSION[$hash]["image"])) && is_file(path_root($_SESSION[$hash]["image"]))) {

                            if ($_SESSION[$hash]["name"] != "") {

                                $this->modifyImg(path_root($_SESSION[$hash]["image"]), $id, $_SESSION[$hash]["name"]);
                            } else {
                                $this->modifyImg(path_root($_SESSION[$hash]["image"]), $id);
                            }
                        }
                    }
                } else {

                    $hash = $record["hash"];

                    if ($_SESSION[$hash]["image"] != "" && file_exists(path_root($_SESSION[$hash]["image"])) && is_file(path_root($_SESSION[$hash]["image"]))) {

                        if ($_SESSION[$hash]["name"] != "") {
                            $this->modifyImg(path_root($_SESSION[$hash]["image"]), $id, $_SESSION[$hash]["name"]);
                        } else {
                            $this->modifyImg(path_root($_SESSION[$hash]["image"]), $id);
                        }
                    }
                }
            }
        }

        return $result;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     * 	
     * 	Elimina un registro de la tabla alumnos
     * 	
     * 	@return booelan Retorna verdadero o falso segun se haya o no realizado el DELETE correctamente
     */
    public function delete($id, $force = true) {


        $result = parent::delete($id, $force);

        if ($result) {

            //si tiene contenedor de imgen eliminadmos el directorio y las imagenes para el id
            if ($this->imgContainer != "") {
                // Requerimos la clase Directorio                    
                $dir = new Dir(path_entity_files($this->imgContainer . "/$id"));
                //si se subio una imgen temporal ccopiamos la imagen y generamos los thumbs
                $dir->deleteDir(path_entity_files($this->imgContainer . "/$id"));
            }
            if ($force) {
                $this->setMsg(array("result" => true, "msg" => "Registro eliminado")
                );
            } else {
                $this->setMsg(array("result" => true, "msg" => "Registro Inactivo")
                );
            }
            return true;
        } else {
            $this->setMsg(array("result" => false, "msg" => "Error")
            );
            return false;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Establese el container de imagenes de la entidad representada por el manager
     *
     * 	@param string  $container Nombre del directorio contenedor
     * 	@return void
     *
     */
    public function setImgContainer($container = NULL) {
        //setea el conteedor de imagenes
        if (is_null($container)) {
            $container = $this->table;
        } else {
            $this->imgContainer = $container;
        }
    }

    public function setImgContainerMultiple($container = NULL) {
        //setea el conteedor de imagenes
        if (is_null($container)) {
            $container = $this->table;
        } else {
            $this->imgContainerMultiple = $container;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	@version 1.0
     *
     * 	Devuelve el Nombre del Container de imagenes para la entidad representada por el manager
     *
     * 	@return string Nombre del Container
     *
     */
    public function getImgContainer() {
        return $this->imgContainer;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@version 1.0
     *
     * 	Establese el maximo tama�o de Imagen que manejar�  la entidad representada por el manager
     *
     * 	@param int  $size Tama�o en bytes
     *
     */
    public function setImgMaxSize($size = 900000) {
        $this->img_max_size = (int) $size;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Devuelve el maximo tama�o de Imagen que manejar�  la entidad representada por el manager
     *
     * 	@return int  Tama�o en bytes
     *
     */
    public function getImgMaxSize() {
        return $this->img_max_size;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Establese el maximo tama�o de Imagen que manejar�  la entidad representada por el manager
     *
     * 	@param string  $hash Cadena hash que corresponde al componente de upload que se ha instanciado en la interfaz
     *
     */
    public function uploadImg($hash) {

        //$uploader = new Uploader($hash, $this->getImgMaxSize(), $this->getImgType());
        $uploader = new UploaderGen($hash, $this->getImgMaxSize(), "multi_img");
        $uploadData = $_SESSION[$hash];

        $ext = $uploader->getExtensionFromUploadedFile();

        if ($ext == "jpeg") {

            $ext = "jpg";
        }

        $path = path_root("xframework/files/temp/images/{$hash}.{$ext}");

        $result = $uploader->moveTo($path);

        if ($result) {

            //tamaño minimo de subida general
            if ($this->evaluateMinPixelSize) {

                $size = @getimagesize($path);

                //en $size[0] esta el ancho, $size[1]  esta el alto
                if ($this->minWidthPixelSize > $size[0] || $this->minHeightPixelSize > $size[1]) {

                    if (file_exists($path)) {

                        unlink($path);
                    }

                    return -5;
                }
            }


            $_SESSION[$hash]["image"] = "xframework/files/temp/images/{$hash}.{$ext}";
            return 1;
        } else {
            return 0;
        }
    }

    /**
     * Método para el upload de imagen para el upload_gen
     * Correciones al método uploadImg.
     * Subía cualquier tipo de archivo y no validaba que era imagen
     * 
     * @param type $hash
     * @param type $max_size_img
     * @param type $filter
     * @return int
     */
    public function uploadImgGen($hash) {

        $max_size_img = $this->img_max_size;

        $filter = $this->filter;

        //$uploader = new Uploader($hash, $this->getImgMaxSize(), $this->getImgType());
        $uploader = new UploaderGen($hash, $max_size_img, $filter);
        $uploadData = $_SESSION[$hash];

        $ext = $uploader->getExtensionFromUploadedFile();

        if ($ext == "jpeg") {

            $ext = "jpg";
        }

        $path = path_root("xframework/files/temp/images/{$hash}.{$ext}");

        $result = $uploader->moveTo($path);

        if ($result > 0) {
            $_SESSION[$hash]["image"] = "xframework/files/temp/images/{$hash}.{$ext}";
            return 1;
        } else {
            return $result;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Método que sube la imagen a una carpeta temporal utilizada para subir múltiples imágenes
     *
     * 	@param string  $request Cadena hash que corresponde al componente de upload que se ha instanciado en la interfaz
     *        @param string  $id_group id que pertenece al upload...
     */
    public function uploadMultipleImg($request, $id_group) {
        $hash = $request['hash'];



        //$uploader = new Uploader($hash, $this->getImgMaxSize(), $this->getImgType());
        $uploader = new Uploader($hash, $this->getImgMaxSize(), "multi_img");

        //obtenemos la extension
        $ext = $uploader->getExtensionFromMime($_FILES[$hash]["type"][0]);

        $_FILES[$hash]["filename"][0] = $_FILES[$hash]["name"][0];
        //parseamos el nombre para sacar caracteres extranños
        $_FILES[$hash]["name"][0] = str_replace(".$ext", "", $_FILES[$hash]["name"][0]);
        $_FILES[$hash]["name"][0] = str2seo($_FILES[$hash]["name"][0]);

        //Path donde se guardarán las imágenes de manera temporal, hasta que se realice el submit
        $path_file = path_root("xframework/files/temp/$this->imgContainerMultiple/$id_group");

        //Pregunto si es directorio, sino lo creo
        if (!is_dir($path_file)) {
            $dir = new Dir($path_file);
            $dir->chmod(0777);
        }
        //LIMPIAMOS LOS ARCHIVOS VIEJOS - otro hash

        $files_list = scandir($path_file);
        $cantidad = 0;
        foreach ($files_list as $existing_file) {
            if ($existing_file != "." && $existing_file != "..") {
                //si tiene otro hash es previo- lo eliminamos
                if (strpos($existing_file, $hash) === false) {
                    unlink("{$path_file}/{$existing_file}");
                } else {
                    //sumamos contador de archivos
                    $cantidad ++;
                };
            }
        }



        $path = "{$path_file}/{$hash}_{$cantidad}.$ext";

        //Valido todo
        //no hay archivo seteado

        $file = $_FILES[$hash];

        if (!$file) {
            $result = 0;
            return $result;
        }

        //superado maximo permitido                    
        if ($file['size'][0] > $uploader->maxSize) {
            $result = -1;
            return $result;
        }

        //superado cantidad permitido  
        if ($cantidad >= 20) {
            $result = -4;
            return $result;
        }

        //tipos de archivos permitidos
        if (!is_null($uploader->types)) {
            if (is_array($uploader->types)) {
                $uploader_types = implode(",", $uploader->types);

                if (strpos($uploader_types, $ext)) {

                    $result = 1;
                } else {
                    $result = -2;
                    return $result;
                }
            } elseif ($uploader->types == "*") {

                $result = 1;
            } else {
                $result = -2;
                return $result;
            }
        } else {
            $result = 1;
        }


        if ($result > 0) {

            if (move_uploaded_file($_FILES[$hash]['tmp_name'][0], $path)) {

                $result = 1;
            } else {
                $result = -3;
                return $result;
            }
        }


        //$result = $uploader->moveTo($path);

        if ($result > 0) {


            $_SESSION[$hash][$cantidad]["name"] = $_FILES[$hash]["name"][0];
            $_SESSION[$hash][$cantidad]["filename"] = $_FILES[$hash]["filename"][0];
            $_SESSION[$hash][$cantidad]["image"] = "xframework/files/temp/{$this->imgContainerMultiple}/$id_group/{$hash}_{$cantidad}.$ext";
            $_SESSION[$hash][$cantidad]["ext"] = $ext;
        }

        return $result;
    }

    /**
     * Método que elimina la imaagen proveniente del componente de eliminación múltiple
     * @param type $request
     * @return int|boolean
     */
    public function deleteMultipleImg($request) {
        //Chekeo que venga el nombre de la imagen
        if (!isset($request["name"]) || $request["name"] == "") {
            $this->setMsg(["msg" => "Error. No ha seleccionado imagen", "result" => false]);
            return -1;
        }
        $name = $request["name"];
        //Chequeo que venga el hash que son las únicas que necesito..
        if (!isset($request["hash"]) || $request["hash"] == "") {
            $this->setMsg(["msg" => "Error. No se pudo eliminar la imagen", "result" => false]);
            return false;
        }
        $hash = $request["hash"];

        $iteracion = 0;
        $eliminado = false;
        do {
            if (isset($_SESSION[$hash][$iteracion])) {
                //Si poseen el mismo name, los elimino
                if ($name == $_SESSION[$hash][$iteracion]["filename"]) {
                    //Se elimina
                    $path = PATH_ROOT . separator() . $_SESSION[$hash][$iteracion]["image"];
                    if (is_file($path)) {
                        unlink($path);
                        unset($_SESSION[$hash][$iteracion]);
                        $eliminado = true;
                    }
                }
            }
            $iteracion++;
        } while ($iteracion <= 20);

        if ($eliminado) {
            return 1;
        } else {
            $this->setMsg(["result" => false, "msg" => "Error. No se encontró la imagen"]);
            return -1;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Modifica la imagen de la entidad representada por el manager
     *
     * 	@param int $id Clave primaria
     * 	@param mixed $image Archivo que corresponde a la imagen
     *
     */
    function modifyImg($image, $id, $name = NULL) {

        $path = path_entity_files($this->imgContainer . "/$id/");
        $Dir = new Dir($path);
        $File = new File($image);

        $ext = $File->getExtension();

        if (is_null($name)) {
            $name = $id;
        }

        $newImg = path_entity_files($this->imgContainer . "/$id/$name.$ext");


        //si es la misma imagen salgo
        if (trim($image) == trim($newImg)) {
            return false;
        } else {
            //elimino las imagenes anteriores
            //$Dir->doEmpty(false);



            if (file_exists($newImg)) {
                unlink($newImg);
            }

            if (count($this->thumbs_config) > 0) {
                foreach ($this->thumbs_config as $key => $config) {

                    if (file_exists(path_entity_files($this->imgContainer . "/$id/$name" . $config["suffix"] . ".$ext"))) {
                        unlink(file_exists($this->imgContainer . "/$id/$name" . $config["suffix"] . ".$ext"));
                    }
                }
            }
        }


        //fix para imagenes subidas con el movil y se suben rotadas
        $imageExif = imagecreatefromstring(file_get_contents($image));
        $exif = exif_read_data($image);

        //file_put_contents(path_files("exif.txt"),  print_r($exif , true ));

        if (!empty($exif['Orientation'])) {

            $rotate = false;

            switch ($exif['Orientation']) {
                case 8:
                    $imageRotate = imagerotate($imageExif, 90, 0);
                    $rotate = true;
                    break;
                case 3:
                    $imageRotate = imagerotate($imageExif, 180, 0);
                    $rotate = true;
                    break;
                case 6:

                    $imageRotate = imagerotate($imageExif, -90, 0);

                    $rotate = true;
                    break;
            }

            if ($rotate) {

                $fileExt = pathinfo($image, PATHINFO_EXTENSION);

                switch ($fileExt) {
                    case "jpg":case "jpeg":
                        $fName = "imagejpeg";
                        break;
                    case "png":
                        $fName = "imagepng";
                        break;
                    case "gif":
                        $fName = "imagegif";
                        break;
                }

                if (isset($fName)) {

                    $fName($imageRotate, $image, 100);
                }
            }
        }

        rename($image, $newImg);


        $manImg = new Images();

        if (count($this->thumbs_config) > 0) {
            foreach ($this->thumbs_config as $key => $config) {

                //evaluar anchos y si es un thumb proporcional					
                $manImg->resize($newImg, path_entity_files($this->imgContainer . "/$id/$name" . $config["suffix"] . ".$ext"), $config["w"], $config["h"], $config["force_proportional"]);
            }
        }

        //resize de la imagen original
        if ($this->img_w > 0) {
            $manImg->resize($newImg, $newImg, $this->img_w, $this->img_h, false);
        }/* else if (!is_null($this->watermark)){
          $manImg->pasteWaterMark($newImg, $this->watermark);
          } */
    }

    /**
     * 
     * @param type $image
     * @param type $id
     * @param type $name
     */
    function modifyImgResizeThumb($image, $id, $name = NULL) {

        $File = new File($image);

        $ext = $File->getExtension();

        if (is_null($name)) {
            $name = $id;
        }


        $manImg = new Images();

        if (count($this->thumbs_config) > 0) {
            foreach ($this->thumbs_config as $key => $config) {


                if (file_exists(path_entity_files($this->imgContainer . "/$id/$name" . $config["suffix"] . ".$ext"))) {
                    unlink(file_exists($this->imgContainer . "/$id/$name" . $config["suffix"] . ".$ext"));
                }
                //evaluar anchos y si es un thumb proporcional					
                $manImg->resize($image, path_entity_files($this->imgContainer . "/$id/$name" . $config["suffix"] . ".$ext"), $config["w"], $config["h"], $config["force_proportional"]);
            }
        }

        //resize de la imagen original
        if ($this->img_w > 0) {
            $manImg->resize($image, $image, $this->img_w, $this->img_h, false);
        }

        return true;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Elimina la imagen de la entidad representada por el manager
     *
     * 	@param string $hash Hash del compoennte de upload instanciado en la interfaz
     *
     */
    public function deleteImg($hash) {

        $uploadData = $_SESSION[$hash];

        //si no tiene id es un archivo temporal
        if ($uploadData["id"] == "") {
            //solo eliminamos nuestro hash
            $this->deleteImgTemp($hash);
        } else {
            //vaciamos el directorio con todos los thumbs q se hayan creado
            $path = path_entity_files($this->imgContainer . "/" . $uploadData["id"] . "/");

            if ($uploadData["name"] != "") {
                $name = $uploadData["name"];
            } else {
                $name = $uploadData["id"];
            }



            foreach ($this->thumbs_config as $key => $config) {

                //evaluar anchos y si es un thumb proporcional

                foreach ($this->img_types as $k2 => $type) {

                    $imagen = $path . "$name" . $config["suffix"] . ".$type";


                    if (file_exists($imagen)) {
                        unlink($imagen);
                    }
                }
            }

            foreach ($this->img_types as $k2 => $type) {

                $imagen = $path . "$name.$type";

                if (file_exists($imagen)) {
                    unlink($imagen);
                }
            }


            $_SESSION[$hash]["image"] = "";
            $_SESSION[$hash]["todo"] = "modify";

            return true;
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Elimina la temporal subida para una entidad
     *
     * 	@param string $hash Hash del compoennte de upload instanciado en la interfaz
     *
     */
    public function deleteImgTemp($hash) {

        //solo eliminamos nuestro hash
        if ($_SESSION[$hash]["image"] != "") {
            if (unlink(path_root($_SESSION[$hash]["image"]))) {
                $_SESSION[$hash]["image"] = "";
                return true;
            } else {
                return false;
            }
        }
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Anexa una configuracion de thumbs a la entidad representada por el manager
     *
     * 	@param int $w  Width en px de la imagen
     * 	@param int $h  Height en px de la imagen
     * 	@param string $suffix  Sufijo que se  utilizar� sobre el thumbs generado
     *
     */
    public function addThumbConfig($w, $h = NULL, $suffix = "_th", $force_proportional = false, $watermark = NULL) {

        $this->thumbs_config[] = array("w" => $w, "h" => $h, "suffix" => $suffix, "force_proportional" => $force_proportional, "watermark" => $watermark);
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Setea una configuracion de imgs a la entidad representada por el manager
     *
     * 	@param int $w  Width en px de la imagen
     * 	@param int $h  Height en px de la imagen
     *
     */
    public function setImgConfig($w = 0, $h = 0) {
        $this->img_w = $w;
        $this->img_h = $h;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Watermark para la imagen original
     *
     * 	@param string $wm  Nombre de la imagen de watermark
     * 	@param int $h  Height en px de la imagen
     *
     */
    public function setWatermark($wm) {
        $this->watermark = $wm;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	Anexa un tipo de imagen permitido para que pueda manipular imgs la entidad representada por el manager
     *
     * 	@param string $type Tipo de la img
     *
     */
    public function addImgType($type) {

        $this->img_types[] = $type;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	@return string Devuelve los tipos de IMGS soportados por la entidad
     *
     */
    public function getImgType() {


        return $this->img_types;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	@return mixed Devuelve la imagen asociada a esta entidad
     *
     */
    public function getMyImg($id, $name = NULL) {

        if (is_null($name)) {
            $name = $id;
        }

        $jpg = path_entity_files($this->imgContainer . "/$id/$name.jpg");
        $gif = path_entity_files($this->imgContainer . "/$id/$name.gif");
        $png = path_entity_files($this->imgContainer . "/$id/$name.png");

        if (file_exists($jpg)) {

            return $this->imgContainer . "/$id/$name.jpg";
        }

        if (file_exists($gif)) {
            return $this->imgContainer . "/$id/$name.gif";
        }

        if (file_exists($png)) {
            return $this->imgContainer . "/$id/$name.png";
        }
        return false;
    }

    /**
     * 	@author Sebastian Balestrini
     * 	@author Emanuel del Barco
     *
     * 	@return mixed Devuelve la extension del archivo de imagen asociada a esta entidad
     *
     */
    public function getMyImgExtension($id, $name = NULL) {

        if (is_null($name)) {
            $name = $id;
        }

        $jpg = path_entity_files($this->imgContainer . "/$id/$id.jpg");
        $gif = path_entity_files($this->imgContainer . "/$id/$id.gif");
        $png = path_entity_files($this->imgContainer . "/$id/$id.png");


        if (file_exists($jpg)) {
            return "jpg";
        }

        if (file_exists($gif)) {
            return "gif";
        }


        if (file_exists($png)) {
            return "png";
        } else {
            return "";
        }
    }

    /**
     * @author Emanuel del Barco
     *
     * Setea para un registro de datos, para cada uno de los registros si tiene asociada una imagen.
     *                         
     * @param integer $id para buscar los datos seo
     * @param string $lang idioma a devolver
     *                  
     * @return void        
     */
    public function findImages(&$records, $name = NULL) {


        $container = $this->imgContainer;

        $my_name = $name;

        foreach ($records as $key => $record) {

            $records[$key]["image"] = array("status" => 0, "type" => "");

            foreach ($this->img_types as $k2 => $type) {

                if (is_null($name)) {
                    $my_name = $record[$this->id];
                }

                if (file_exists(path_entity_files("$container/" . $record[$this->id] . "/" . $my_name . ".$type"))) {

                    $records[$key]["image"] = array("status" => 1, "type" => $type);
                }
            }
        }

        return;
    }

    /**
     * @author Sebastian Balestrini
     * @author Emanuel del Barco
     * attachFiles: Adjunta un fichero a un registro		
     *
     * @param $id int
     * @param $request array
     * 		
     * @return bool
     */
    protected function attachFiles($id, $request) {

        /* $container = $this->filesContainer;    
          $dir = new Dir(path_entity_files($container."/$id"));

          $dir->chmod(0777);

          //Actualizo la llave llave
          $this->db->AutoExecute($this->table, array("file_key"=>sha1($id),$this->id=>$id), 'UPDATE',  sprintf("%s = %d",$this->id,$id));

          //si se subieron ficheros
          if(isset($request["hash"])){

          $hashes = $request["hash"];

          // echo "proceso hash $hash";

          foreach ($hashes as $k => $hash) {

          if (isset($_SESSION[$hash])){
          $file = $_SESSION[$hash];
          $name = $file["name"];
          if ($file["realName"]!="" &&  file_exists(path_root( "temp/".$name ))){


          if (file_exists(path_entity_files("$container/$id/".$file["realName"]) ) &&  $file["realName"] !="" ){
          unlink(path_entity_files("$container/$id/".$file["realName"]));
          }
          rename(path_root("temp/".$name ),path_entity_files("$container/$id/".$file["realName"]));

          unset($_SESSION[$hash]);
          }
          }
          }
          } */

        return;
    }

    /**
     * @author Sebastian Balestrini
     * @author Emanuel del Barco
     * Elimina el archivo adjunto de una entidad
     * 		
     *
     * @param $id int
     * 		
     * @return bool
     */
    public function deleteAttachedFile($id, $name) {

        /* $myFile = path_entity_files($this->filesContainer."/$id/$name");

          if (file_exists($myFile)){
          if ( unlink($myFile) ){
          //Actualizo la llave llave
          $this->db->AutoExecute($this->table, array("file_key"=>"",$this->id=>$id), 'UPDATE',  sprintf("%s = %d",$this->id,$id));
          return true;
          }else{
          return false;
          }
          }else{
          return false;
          }

         */
    }

    /**
     * @author Sebastian Balestrini
     * @author Emanuel del Barco
     * Obtiene un listdo de los archivos asociados a la entiedad
     * 		
     *
     * @param $id int
     * 		
     * @return array
     */
    public function getAttachedFiles($id) {

        /* $Dir = new Dir(path_entity_files($this->filesContainer."/$id/"));

          $files = $Dir->getArrayFiles($Dir->path);

          return $files; */
    }

    /**
     * @author Sebastian Balestrini
     * @author Emanuel del Barco
     * Obtiene el nombre del directorio que contiene los archivos asociados a la entidad
     * 		
     * @return string
     */
    public function getFilesConainer() {

        return $this->filesContainer;
    }

    /**
     * @author Sebastian Balestrini
     * @author Emanuel del Barco
     * Setea el dierectorio que contiene los archivos asociados
     * 		
     * @return string
     */
    public function setFilesContainer($container) {

        return $this->filesContainer = $container;
    }

    /**
     * Método que obtiene los filters de un Manager
     */
    public function getFilters() {
        return $this->filter;
    }

    /**
     * Método que setea la variable filter del manager
     * @param type $filters
     */
    public function setFilters($filters) {
        $this->filter = $filters;
    }

    /**
     * Método que obtiene el tamaño máximo preconfigurado en el manager
     */
    public function getFileMaxSize() {
        return $this->img_max_size;
    }

    /**
     * Método que setea el tamaño máximo preconfigurado en el manager
     * @param type $img_max_size
     */
    public function setFileMaxSize($img_max_size) {
        $this->img_max_size = $img_max_size;
    }

}

// EndClass
?>