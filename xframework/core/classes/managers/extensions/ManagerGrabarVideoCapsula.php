<?php

require_once(path_libs("libs_php/aws/aws-autoloader.php"));

use Aws\S3\S3Client;
use Aws\S3\Exception\S3Exception;

class ManagerGrabarVideoCapsula extends ManagerMedia {

    /** constructor
     * 	@param $db instancia de adodb
     */
    function __construct($db) {

        // Llamamos al constructor del a superclase
        parent::__construct($db, "grabarvideocapsula", "idgrabarvideocapsula");

        $this->setImgContainer("capsula/grabacion_video");

        $this->setImgContainerMultiple("capsula/grabacion_video");
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
    public function processGrabarVideo($request) {
        $ManagerCapsula = $this->getManager("ManagerCapsula");
        $requestCapsula["titulo"] = $request["titulo"];
        $requestCapsula["tipo_capsula"] = '4';
        $requestCapsula["usuarioempresa_idusuarioempresa"] = $_SESSION[URL_ROOT][CONTROLLER]['logged_account']["user"]["idusuario_empresa"];
        $idCapsula = $ManagerCapsula->process($requestCapsula);
        $request["capsula_idcapsula"] = $idCapsula;

        $par = 'recording';

        $arrN = explode("/", $_FILES['video']['type']);
        $request["ext"] = "mp4";
        $ex = $arrN[1];
        $request["nombre"] = 'recording';

        $idVideoCapsula = parent::insert($request);
        // creo la ruta donde va a ir el video es decir la carpeta con el ID
        $rutaSub = path_root("xframework/files/entities/capsula/grabacion_video/{$idVideoCapsula}");
        mkdir($rutaSub, 0777);
        // direccion donde se va a alojar y nombre
        // esto es para ver el video  y transformarlo en mp4
        $video = $_FILES['video']['tmp_name'];

        exec("ffmpeg -i " . $video . " -vcodec libx264 -acodec aac  " . "recording.mp4");

        $r = path_root("xframework/files/entities/capsula/grabacion_video/{$idVideoCapsula}/recording.mp4");
        $o = path_root("recording.mp4");

        $rdorigen = str_replace("/", "\\", $o);
        if (strlen(strstr($o, 'var')) > 0) {
            rename($o, $r);
        } else {
            rename($rdorigen, $r);
        }

        $fichero_subido = path_root("xframework/files/entities/capsula/grabacion_video/{$idVideoCapsula}/{$par}.mp4");
        $fichero_eliminar = path_root("xframework/files/entities/capsula/grabacion_video/{$idVideoCapsula}");
        /// aws   //////////////////

        $option = [
            'region' => 'us-east-1',
            'version' => 'latest',
            'credentials' => [
                'key' => AWS_KEY,
                'secret' => AWS_SECRET
            ]
        ];

        $file_name = "capsula/grabacion_video/" . $idVideoCapsula . "/" . $par . ".mp4";

        $file_path = $fichero_subido;


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
//
//
// este echo no es de debug sirve para poder ver el video, asi le asigno el path
        // echo $fichero_subido;
        rmDir_rf($fichero_eliminar);

        if ($idVideoCapsula) {
            $managerEmprea = $this->getManager("ManagerEmpresa");
            $managerEmprea->generar_hash_invitacion_capsula($idCapsula);
            $msje = $managerEmprea->getMsg();
            $this->setMsg(["msg" => "El video fue subido correctamente", "result" => true, "hash" => $msje["hash"], "idGrabacion" => $idVideoCapsula]);
            // rmdir($dir);
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

    /**
     *  actualizo los datos de la grabacion, nombre y extension y elimino de la carpeta la grabacion anterior e inserto la nueva
     * 
     * @param type $request
     * @return boolean
     */
    public function actualizarGrabarVideo($request) {

        $par = basename($_FILES['video']['name']);

        $arrN = explode("/", $_FILES['video']['type']);
        $request["ext"] = $arrN[1];
        $request["nombre"] = $_FILES['video']['name'];

        $this->update($request, $request["idGrabacion"]);

        $urlEliminar = 'xframework/files/entities/capsula/grabacion_video/' . $request["idGrabacion"] . '/' . $request["nombreViejo"];
        unlink($urlEliminar);


        $fichero_subido = path_root("xframework/files/entities/capsula/grabacion_video/{$request["idGrabacion"]}/{$par}");

//print_r($_FILES);

        move_uploaded_file($_FILES['video']['tmp_name'], $fichero_subido);
        echo $fichero_subido;
        if ($request["idGrabacion"]) {

            $this->setMsg(["msg" => "El video fue subido correctamente", "result" => true, "hash" => $request["hashCapsula"], "idGrabacion" => $request["idGrabacion"]]);
            return true;
        } else {
            $this->setMsg(["msg" => "Error. No hay video para insertar", "result" => false]);
            return true;
        }
    }

}

/**
 * 
 * @param type $carpeta
 * funcion para eliminar todo el directorio y lo de adentro
 * 
 * las carpetas quedan, no se eliminan. Eliminarlas de manera manual
 * estan ubicadas en xframework\files\entities\capsula\grabacion_video
 * 
 * 
 */
function rmDir_rf($carpeta) {

    foreach (glob($carpeta . "/*") as $archivos_carpeta) {
        if (is_dir($archivos_carpeta)) {
            rmDir_rf($archivos_carpeta);
        } else {
            unlink($archivos_carpeta);
        }
    }
    rmdir($carpeta);
}
