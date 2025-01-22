<?php

require_once(path_libs("libs_php/aws/aws-autoloader.php"));

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

class ManagerFileCapsula extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

// Llamamos al constructor del a superclase
        parent::__construct($db, "filecapsula", "idfilecapsula");

//        $this->setImgContainer("capsula/files");
//
//        $this->setImgContainerMultiple("capsula/files");
        $this->addImgType("jpg");
        $this->addImgType("png");
        $this->addThumbConfig(50, 50, "_perfil");
        $this->addThumbConfig(150, 150, "_usuario");
        $this->addThumbConfig(110, 110, "_list");
    }

    /**
     * Método que procesa el upload de un solo archivo
     *  del Reembolso
     * @param type $request
     * @return boolean
     */
    public function processFile($request) {
        $requestCapsula["estado"] = '1';
        $requestCapsula["fecha_inicio"] = date("Y-m-d");
        $requestCapsula["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $ManagerCapsula = $this->getManager("ManagerCapsula");
        $requestCapsula["titulo"] = $request["titulo"];
        $requestCapsula["tipo_capsula"] = '1';


        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"] != '') {
            $requestCapsula["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        } else {
// aca ingresa cuando carga desde dp admin el usuario empresa signifca eso porque lo carga desde el admin
            $requestCapsula["usuarioempresa_idusuarioempresa"] = "0";
            $requestCapsula["contenedorcapsula_idcontenedorcapsula"] = $request["contenedorcapsula_idcontenedorcapsula"];
        }

        $idCapsula = $ManagerCapsula->process($requestCapsula);
        $request["capsula_idcapsula"] = $idCapsula;

        $hash = $request["hash"];
        $datos_session = $_SESSION[$hash];
        $val;
        for ($i = 0; $i < 20; $i++) {
            if ($datos_session[$i]["ext"] != '') {
                $val = $i;
            }
        }

//Flag para verificar si ocurre algún error.
        $flag_estudio_true = false;
//Variable para ver si hay imágenes
        $exist_images = false;


        if (isset($_SESSION[$hash][$val])) {
            $exist_images = true;

            $ext = $datos_session[$val]["ext"];


//$dir = path_root("xframework/files/temp/capsula/files/{$hash}/");
            $path = path_root("xframework/files/temp/capsula/files/{$hash}/{$val}.{$ext}");
//Si existe el path, se inserta la imagen

            if (is_file($path)) {

                $porciones = explode(".", $datos_session[$val]["name"]);

                $request["nombre"] = "{$porciones[0]}";
                $request["ext"] = $ext;
//guardamos en Session los datos de cada imagen para el insert multiple
                $_SESSION[$hash] = $datos_session[$val];

                $rdo = parent::insert($request);
//copiamos el archivo a su ubicacion final
                /*    $path_entity_file = path_entity_files("{$this->getImgContainer()}/{$rdo}/{$request["nombre"]}.{$ext}");

                  copy($path, $path_entity_file); */
//comprobamos que se hayan movido
///////////////////
/// aws   //////////////////

                $option = [
                    'region' => 'us-east-1',
                    'version' => 'latest',
                    'credentials' => [
                        'key' => AWS_KEY,
                        'secret' => AWS_SECRET
                    ]
                ];

                $file_name = "capsula/files/" . $rdo . "/" . $datos_session[0]["name"];

                $file_path = $datos_session[0]["path"];


                try {
                    $s3Client = new S3Client($option);

                    $result = $s3Client->putObject([
                        'Bucket' => 'capsula-bck-test',
                        'Key' => $file_name,
                        'SourceFile' => $file_path,
                    ]);
//echo "<pre>" . print_r($result, true) . "</pre>";
                } catch (S3Exception $e) {
// echo $e->getMessage() . "\n";
                    $result = false;
                }

//// aws ///////////////////


                if (!$result) {
                    $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
                    return false;
                }
                if (!$rdo) {


                    $this->setMsg(["msg" => "Error. No se pudo insertar la imagen [[{$request["nombre"] }]]", "result" => false]);
                    return false;
                } else {
                    $flag_estudio_true = true;
                }
//restauramos los datos de session con todas las imagenes
                $_SESSION[$hash] = $datos_session;
//Elimino el archivo
                unlink($path);
            }
        }


        if ($flag_estudio_true && $exist_images) {
            $managerEmprea = $this->getManager("ManagerEmpresa");
            $managerEmprea->generar_hash_invitacion_capsula($idCapsula);
            $msje = $managerEmprea->getMsg();

            $this->setMsg(["msg" => "Creado Correctamente", "result" => true, "hash" => $msje["hash"]]);
            return true;
        } else if ($flag_estudio_true == false && $exist_images) {
//Se produjo un error y existen imágenes
            $this->setMsg(["msg" => "Error. No se pudo subir ninguna imagen, verifique sus formatos y tamaños", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Error. No hay imágenes para insertar", "result" => false]);
            return true;
        }
    }

    public function processFileGenerico($request) {

        $requestCapsula["estado"] = '1';
        $requestCapsula["fecha_inicio"] = date("Y-m-d");
        $requestCapsula["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $ManagerCapsula = $this->getManager("ManagerCapsula");

        $requestCapsula["titulo"] = $request["titulo"];
        $requestCapsula["tipo_capsula"] = '1';


        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"] != '') {
            $requestCapsula["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        } else {
// aca ingresa cuando carga desde dp admin el usuario empresa signifca eso porque lo carga desde el admin
            $requestCapsula["usuarioempresa_idusuarioempresa"] = "0";
            $requestCapsula["contenedorcapsula_idcontenedorcapsula"] = $request["contenedorcapsula_idcontenedorcapsula"];
        }

        $idCapsula = $ManagerCapsula->process($requestCapsula);
        $request["capsula_idcapsula"] = $idCapsula;

        $arr = explode("xframework", $request ["src"]);
        $arPrev = explode("/", $arr[1]);


        $ar1r = explode(".", $arPrev[6]);
        $request["nombre"] = $ar1r[0];
        $request["ext"] = $ar1r[1];
        $ext = $ar1r[1];

        $idO = $arPrev[5];

        $rdo = parent::insert($request);
//copiamos el archivo a su ubicacion final
//    $path_entity_file = path_entity_files("{$this->getImgContainer()}/{$rdo}/{$request["nombre"]}.{$ext}");
//  $path_entity_file_origen = path_entity_files("{$this->getImgContainer()}/{$idO}/{$request["nombre"]}.{$ext}");
//  copy($path_entity_file_origen, $path_entity_file);
//comprobamos que se hayan movido
//        if (!is_file($path_entity_file_origen)) {
//            $this->setMsg(["msg" => "Error. No se pudo subir ningun archivos, verifique sus formatos y tamaños", "result" => false]);
//            return false;
//        }
// aws
        $sourceBucket = 'capsula-bck-test/capsula/files/' . $idO;
        $sourceKeyname = $request["nombre"] . "." . $ext;
        $targetBucket = 'capsula-bck-test';

        $s3 = new S3Client([
            'version' => 'latest',
            'region' => 'us-east-1',
            'credentials' => [
                'key' => AWS_KEY,
                'secret' => AWS_SECRET
            ]
        ]);



// Copy an object.
        $s3->copyObject([
            'Bucket' => $targetBucket,
            'Key' => 'capsula/files/' . $rdo . '/' . $sourceKeyname,
            'CopySource' => $sourceBucket . "/" . $sourceKeyname,
        ]);


///////////////



        if (!$rdo) {


            $this->setMsg(["msg" => "Error. No se pudo insertar la imagen [[{$request["nombre"] }]]", "result" => false]);
            return false;
        } else {
            $flag_estudio_true = true;
        }


        if ($flag_estudio_true) {
            $managerEmprea = $this->getManager("ManagerEmpresa");
            $managerEmprea->generar_hash_invitacion_capsula($idCapsula);
            $msje = $managerEmprea->getMsg();
            $this->setMsg(["msg" => "Creado Correctamente", "result" => true, "hash" => $msje["hash"]]);
            return true;
        } else if ($flag_estudio_true == false) {
//Se produjo un error y existen imágenes
            $this->setMsg(["msg" => "Error. No se pudo subir ninguna imagen, verifique sus formatos y tamaños", "result" => false]);
            return false;
        } else {
            $this->setMsg(["msg" => "Error. No hay imágenes para insertar", "result" => false]);
            return true;
        }
    }

    /**
     * Método utilizado para eliminar el registro desde el dropzone
     * @param type $request
     */
    public function deleteDropzone($request) {
        if ((int) $request["id"
                ] > 0) {
            $delete = parent::delete($request["id"]);
            if ($delete) {
                $this->setMsg(["msg" => "La imagen se eliminó con éxito", "result" => true]);
                return true;
            }
        }
        $this->setMsg(["msg" => "Error. No se pudo eliminar la imagen, recargue la página", "result" => false]);
        return false;
    }

}
