<?php

require_once(path_libs("libs_php/aws/aws-autoloader.php"));

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

class ManagerVideoCapsula extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "videocapsula", "idvideocapsula");

        //$this->setImgContainer("capsula/video");
        //$this->setImgContainerMultiple("capsula/video");
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
    public function processVideo($request) {
        $requestCapsula["estado"] = '1';
        $requestCapsula["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $ManagerCapsula = $this->getManager("ManagerCapsula");
        $requestCapsula["titulo"] = $request["titulo"];
        $requestCapsula["tipo_capsula"] = '3';
        $requestCapsula["fecha_inicio"] = date("Y-m-d");
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"] != '') {
            $requestCapsula["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        } else {
            // aca ingresa cuando carga desde dp admin el usuario empresa signifca eso porque lo carga desde el admin
            $requestCapsula["usuarioempresa_idusuarioempresa"] = "0";
            $requestCapsula["contenedorcapsula_idcontenedorcapsula"] = $request["contenedorcapsula_idcontenedorcapsula_video"];
            $requestCapsula["titulo"] = $request["titulo_video"];
        }
        $idCapsula = $ManagerCapsula->process($requestCapsula);
        $request["capsula_idcapsula"] = $idCapsula;

        $par = basename($_FILES['addvideosinput']['name']);

        $arrN = explode("/", $_FILES['addvideosinput']['type']);
        $request["ext"] = $arrN[1];
        $ar1N = explode(".", $par);
        $request["nombre"] = $ar1N[0];

        // esto lo agregue por los video .MOV que no los reconoce correctamente
        if ($request["ext"] == 'octet-stream') {
            $request["ext"] = $ar1N[1];
        }

        $idVideoCapsula = parent::insert($request);


        /// aws   //////////////////

        $option = [
            'region' => 'us-east-1',
            'version' => 'latest',
            'credentials' => [
                'key' => AWS_KEY,
                'secret' => AWS_SECRET
            ]
        ];

        $file_name = "capsula/video/" . $idVideoCapsula . "/" . $request["nombre"] . "." . $request["ext"];

        $file_path = $_FILES['addvideosinput']['tmp_name'];


        try {
            $s3Client = new S3Client($option);

            $result = $s3Client->putObject([
                'Bucket' => 'capsula-bck-test',
                'Key' => $file_name,
                'SourceFile' => $file_path,
            ]);
        } catch (S3Exception $e) {

            $result = false;
        }

//// aws ///////////////////
        // $rutaSub = path_root("xframework/files/entities/capsula/video/{$idVideoCapsula}");
        //  mkdir($rutaSub, 0777);
        //   $fichero_subido = path_root("xframework/files/entities/capsula/video/{$idVideoCapsula}/{$par}");
//print_r($_FILES);
        //  move_uploaded_file($_FILES['addvideosinput']['tmp_name'], $fichero_subido);
        if ($idVideoCapsula) {

            $managerEmprea = $this->getManager("ManagerEmpresa");
            $managerEmprea->generar_hash_invitacion_capsula($idCapsula);
            $msje = $managerEmprea->getMsg();
            $this->setMsg(["msg" => "El video fue subido correctamente", "result" => true, "hash" => $msje["hash"]]);
            // rmdir($dir);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No hay video para insertar", "result" => false]);
            return true;
        }
    }

    /**
     * 
     * @param type $request
     * @return boolean
     */
    public function processVideoGenerico($request) {
        $requestCapsula["estado"] = '1';
        $requestCapsula["empresa_idempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idempresa"];
        $ManagerCapsula = $this->getManager("ManagerCapsula");
        $requestCapsula["titulo"] = $request["titulo"];
        $requestCapsula["tipo_capsula"] = '3';
        $requestCapsula["fecha_inicio"] = date("Y-m-d");
        if ($_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"] != '') {
            $requestCapsula["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        } else {
            // aca ingresa cuando carga desde dp admin el usuario empresa signifca eso porque lo carga desde el admin
            $requestCapsula["usuarioempresa_idusuarioempresa"] = "0";
            $requestCapsula["contenedorcapsula_idcontenedorcapsula"] = $request["contenedorcapsula_idcontenedorcapsula_video"];
            $requestCapsula["titulo"] = $request["titulo_video"];
        }
        $idCapsula = $ManagerCapsula->process($requestCapsula);
        $request["capsula_idcapsula"] = $idCapsula;


        $arr = explode("xframework", $request ["srcV"]);

        $arPrev = explode("/", $arr[1]);

        $ar1r = explode(".", $arPrev[6]);

        $request["nombre"] = $ar1r[0];
        $request["ext"] = $ar1r[1];

        $ext = $ar1r[1];

        $idO = $arPrev[5];

        $idVideoCapsula = parent::insert($request);

        //copiamos el archivo a su ubicacion final
        //   $path_entity_file = path_entity_files("{$this->getImgContainer()}/{$idVideoCapsula}/{$request["nombre"]}.{$ext}");
        //   $path_entity_file_origen = path_entity_files("{$this->getImgContainer()}/{$idO}/{$request["nombre"]}.{$ext}");
        // copy($path_entity_file_origen, $path_entity_file);
        // aws
        $sourceBucket = 'capsula-bck-test/capsula/video/' . $idO;
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
            'Key' => 'capsula/video/' . $idVideoCapsula . '/' . $sourceKeyname,
            'CopySource' => $sourceBucket . "/" . $sourceKeyname,
        ]);


///////////////




        if ($idVideoCapsula) {

            $managerEmprea = $this->getManager("ManagerEmpresa");
            $managerEmprea->generar_hash_invitacion_capsula($idCapsula);
            $msje = $managerEmprea->getMsg();
            $this->setMsg(["msg" => "El video fue subido correctamente", "result" => true, "hash" => $msje["hash"]]);

            return true;
        } else {
            $this->setMsg(["msg" => "Error. No hay video para insertar", "result" => false]);
            return true;
        }
    }

    /**
     * Método utilizado para eliminar el registro desde el dropzone
     * @param type $request
     */
    public function deleteDropzone($request) {
        if ((int) $request["id"] > 0) {
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
