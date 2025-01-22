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
ini_set('max_execution_time', 600); //300 seconds = 5 minutes
ini_set('upload_max_filesize', '10M');
ini_set('post_max_size', '10M');
//	ini_set('display_errors','1');
//	error_reporting(6143);



$uploadData = $_SESSION[$hash];
$cantidad = (int) $this->request["cantidad"];



//$uploader = new Uploader($hash, $this->getImgMaxSize(), $this->getImgType());
$uploader = new Uploader($hash);

$uploader->types = "*";


//obtenemos la extension
$ext = $uploader->getExtensionFromMime($_FILES[$hash]["type"][0]);
$_FILES[$hash]["filename"][0] = str_replace(".$ext", "", $_FILES[$hash]["name"][0]);
$_FILES[$hash]["filename"][0] = str2seo($_FILES[$hash]["filename"][0]);

//Path donde se guardarán las imágenes de manera temporal, hasta que se realice el submit
$folder = $this->request["folder"];
$path_file = path_root("xframework/files/temp/$folder/$hash");

//Pregunto si es directorio, sino lo creo
if (!is_dir($path_file)) {
    $dir = new Dir($path_file);
    $dir->chmod(0777);
}

$path = "{$path_file}/{$cantidad}.$ext";
//Valido todo
//no hay archivo seteado

$file = $_FILES[$hash];
if (!$file) {
    $result = 0;
}



//tipos de archivos permitidos

if (!is_null($uploader->types)) {

    if (is_array($uploader->types)) {
        if (in_array($file['type'][0], $uploader->types)) {
            $result = 1;
        } else {
            $result = -2;
        }
    } elseif ($uploader->types == "*") {
        $result = 1;
    } else {
        $result = -2;
    }
} else {

    $result = 1;
}


if ($result > 0) {

    if (move_uploaded_file($_FILES[$hash]['tmp_name'][0], $path)) {
//      if($uploader->moveTo($path)){
        $result = 1;
    } else {
        $result = -3;
    }
}


//$result = $uploader->moveTo($path);

if ($result) {
    $_SESSION[$hash][$cantidad]["name"] = $_FILES[$hash]["name"][0];
    $_SESSION[$hash][$cantidad]["filename"] = $_FILES[$hash]["filename"][0];

    $_SESSION[$hash][$cantidad]["path"] = "xframework/files/temp/{$folder}/{$hash}/{$cantidad}.$ext";
    $_SESSION[$hash][$cantidad]["ext"] = $ext;
    $_SESSION[$hash]["cantidad"] = $cantidad + 1;
}

switch ($result) {
    case 1:
        $arr_c = explode("/", $_SESSION[$hash][$cantidad]["path"]);
        $img_rs = $arr_c[count($arr_c) - 1];

        $return = array(
            'status' => '1',
            'hash' => $hash,
            'image' => $img_rs,
            'ext' => $ext,
            'filename' => $_SESSION[$hash][$cantidad]["name"]
        );
        break;
    case 2:
        $return = array(
            'status' => '1',
            'msg' => "Enlevé avec succès"
        );

        break;

    case -3:
        $return = array(
            'status' => '0',
            'error' => "Impossible d`entrer ce type de fichier"
        );

        break;

    case -2:
        $return = array(
            'status' => '0',
            'error' => "Erreur, l`extension du fichier n`est pas correcte"
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