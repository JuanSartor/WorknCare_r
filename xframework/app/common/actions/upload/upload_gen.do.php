<?php

/**
 * Upload Genérico.
 * Notas:
 * Si viene Manager Toma los filtros definidos en el manager:
 * image/*,application/pdf,audio/*,video/*,image/*
 * 
 * Si Se sube solamente imagen, se recibe el parámetro is_image = 1 => Método 
 */
ini_set('max_execution_time', 600); //300 seconds = 5 minutes
$hash = $_REQUEST['hash'];

$uploadData = $_SESSION[$hash];

/**
 * Si es eliminación del archivo
 */
if (isset($this->request["delete"]) && (int) $this->request["delete"] == 1) {
    if ($this->request["name"] != "") {
        $ext = pathinfo($this->request["name"], PATHINFO_EXTENSION);
        $path_dir = path_files("temp");
        $path = "{$path_dir}/{$hash}.{$ext}";
        if (file_exists($path) && is_file($path)) {
            unlink($path);
        }
        $return = array(
            "result" => true,
            'error' => "Le fichier a été supprimé avec succès"
        );
    } else {
        $return = array(
            "result" => false,
            'error' => "Le fichier à supprimer est introuvable."
        );
    }
}
/**
 * Si es Upload delk archivo
 */ else {

    //Que se procese si no hay error en el $_FILE. Estos errores te los tira cuando no cumple con la configuración del apache del server
    if ((int) $_FILES[$hash]["error"] == 0) {

        if (isset($this->request["manager"]) && $this->request["manager"] != "") {
            $manager = $this->getManager($this->request["manager"]);

            //Seteo de los filtros. Primera instancia carga los configurados del manager, si es que hay, sino los que vienen en el request
            $filters = $manager->getFilters() != "" ? $manager->getFilters() : $this->request["filter"];
            if (!isset($filters) || $filters == "") {
                $filters = "*";
            }

            //Obtengo el tamaño máximo
            $max_size = $manager->getFileMaxSize() != "" ? $manager->getFileMaxSize() : $uploadData['max_size'];


            /**
             * IF is imagen-> Va a utilizar el upload img del manager
             */
            if ((int) $this->request["is_image"] == 1) {

                $result = $manager->uploadImgGen($hash, $max_size, $filters);
                if ($result == 1) {
                    $result = 2;
                }
            }
        } else {
            //Si no hay Manager, tomo los parámetros por defecto o los que vienen del Request
            $filters = $this->request["filter"] != "" ? $this->request["filter"] : "*";

            $max_size = (int) $uploadData['max_size'] > 0 ? $uploadData['max_size'] : 9000000;
        }

        //Si usa la clase uploader
        if (!isset($this->request["is_image"]) || (int) $this->request["is_image"] != 1) {

            $uploader = new UploaderGen($hash, $max_size, $filters);

            $ext = pathinfo($uploader->getFileName(), PATHINFO_EXTENSION);

            if ($uploadData["name"] != "") {
                $name = $uploadData["name"];
            } else {
                $name = $hash;
            }

            //Path donde se guardarán las imágenes de manera temporal, hasta que se realice el submit
            $path_dir = path_files("temp");

            //Pregunto si es directorio, sino lo creo
            if (!is_dir($path_dir)) {
                $dir = new Dir($path_dir);
                $dir->chmod(0777);
            }


            //Si hay un archivo previamente subido, lo elimino.. 
            //Esto es porque puede que suba con otra extensión
            if (isset($this->request["name_old"]) && $this->request["name_old"] != "") {
                $ext_old = pathinfo($this->request["name_old"], PATHINFO_EXTENSION);

                $path_old = "{$path_dir}/{$hash}.{$ext_old}";

                if (file_exists($path_old) && is_file($path_old)) {
                    unlink($path_old);
                }
            }


            $path = "{$path_dir}/{$hash}.{$ext}";


            if (file_exists($path) && is_file($path)) {
                unlink($path);
            }

            $result = $uploader->moveTo($path);

            if ($result > 0) {
                $_SESSION[$hash]["realName"] = $uploader->getFileName();
                $_SESSION[$hash]["ext"] = $ext;
            } else {
                $_SESSION[$hash]["realName"] = "";
            }
        }
    }

    switch ($result) {
        case 0:
            $return = array(
                'status' => '0',
                'error' => "Le fichier n`a pas pu être téléchargé"
            );
            break;
        case 1:
            $extra = pathinfo($_SESSION[$hash]["realName"]);

            $return = array(
                'status' => '1',
                'hash' => $hash,
                'fileName' => $_SESSION[$hash]["realName"],
                'extension' => $extra["extension"],
                'name' => $extra["filename"]
            );
            break;
        case 2:
            $return = array(
                'status' => '1',
                'hash' => $hash,
                'image' => $_SESSION[$hash]["image"]
            );
            break;
        case -1:
            $return = array(
                'status' => '0',
                'error' => "Le fichier dépasse la taille autorisée (Taille limitée à 8 MB.)"
            );
            break;
        case -2:
            $return = array(
                'status' => '0',
                'error' => "Type de fichier incorrect"
            );
            break;
        case -3:
            $return = array(
                'status' => '0',
                'error' => "Impossible de télécharger le fichier, essayez de recharger"
            );
            break;
        default :
            $return = array(
                'status' => '0',
                'error' => "Erreur lors de l`envoi du fichier ($result) "
            );
    }
}
header('Content-Type: application/json');
echo json_encode($return);

