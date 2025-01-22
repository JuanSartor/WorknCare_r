<?php

/**
 *  Upload comun para todos los modulos, mueve una imagen temporal
 *  temps/file.tmp o el temps/$hash.tmp 
 *  Guarda en una variable de session los datos de $_FILES['file_temp']   
 *
 */
//	require_once(path_managers("ManagerUpload.php"));
//session_start();

$hash = $this->request['hash'];

//	ini_set('display_errors','1');
//	error_reporting(6143);




ini_set('upload_max_filesize', '10M');
ini_set('post_max_size', '10M');
ini_set('max_execution_time', 600); //300 seconds = 5 minutes
$uploadData = $_SESSION[$hash];

$managerStr = $uploadData["manager"];

//$data =  print_r($uploadData,true).print_r($_FILES,true);
//file_put_contents(path_root("log_upload.txt"), $data);

$manager = $this->getManager($managerStr);

// $debug = "";

if ($manager != "") {
    $result = $manager->uploadMultipleImg($this->request, $_SESSION[$hash]["id_group"]);
} else {
    $debug = "NO entro a manager \n";
}

switch ($result) {


    case 1:
        $return = array(
            'status' => '1',
            'hash' => $hash,
            'image' => $_SESSION[$hash]["image"]
        );
        break;
    case 2:
        $return = array(
            'status' => '1',
            'msg' => "Enlevé avec succès"
        );

        break;



    case -2:
        $return = array(
            'status' => '0',
            'error' => "Erreur, l`extension du fichier n`est pas correcte"
        );

        break;
    case -3:
        $return = array(
            'status' => '0',
            'error' => "Le fichier n`a pas pu être supprimé"
        );

        break;

    case -4:
        $return = array(
            'status' => '0',
            'error' => "Erreur, 20 images maximum"
        );

        break;



    default :

        $return = array(
            'status' => '0',
            'error' => "Erreur lors de l`envoi du fichier ($result) $debug "
        );
}

header('Content-Type: application/json');

echo json_encode($return);
?>
