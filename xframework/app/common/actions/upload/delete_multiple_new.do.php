<?php

/**
 *  Delete comun para todos los modulos, Elimina la imagen del temporal
 *  temps/file.tmp o el temps/$hash.tmp 
 *  Guarda en una variable de session los datos de $_FILES['file_temp']   
 *
 */
$hash = $this->request['hash'];

//  ini_set('display_errors', '1');
//  error_reporting(6143);

$name = $this->request["name"];
if (!isset($name) || $name == "") {
    $mensaje = [
        "msg" => "Erreur. Vous n`avez pas sélectionné d`image",
        "result" => false
    ];
    $result = -1;
}



//Chequeo que venga el hash que son las únicas que necesito..
if (!isset($hash) || $hash == "") {
    $mensaje = [
        "msg" => "Erreur. Le fichier n a pas pu être supprimée",
        "result" => false
    ];
    $result = -1;
}

$iteracion = 0;
$eliminado = false;

do {

    if (isset($_SESSION[$hash][$iteracion])) {
        //Si poseen el mismo name, los elimino
        $filename = str_replace(".{$_SESSION[$hash][$iteracion]["ext"]}", "", $name);
        $filename = str2seo($filename);

        if ($filename == $_SESSION[$hash][$iteracion]["filename"]) {

            //Se elimina

            $path = $_SESSION[$hash][$iteracion]["path"];

            if (is_file($path)) {

                unlink($path);
                unset($_SESSION[$hash][$iteracion]);
            }
            $eliminado = true;
        }
    }
    $iteracion++;
} while (!$eliminado && $iteracion < $_SESSION[$hash]["cantidad"]);

if ($eliminado) {
    $result = 1;
} else {
    $mensaje = [
        "result" => false,
        "msg" => "Erreur. Le fichier n`a pas été trouvée"
    ];
    $result = -1;
}

switch ($result) {


    case 1:
        $return = array(
            'status' => '1',
            'hash' => $hash,
            "result" => true
        );
        break;
    case -1:
        $return = $mensaje;

        break;


    default :

        $return = array(
            'status' => '0',
            'error' => "Erreur lors de la suppression du fichier ($result) $debug ",
            "result" => false
        );
}

header('Content-Type: application/json');

echo json_encode($return);
