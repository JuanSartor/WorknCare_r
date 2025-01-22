<?php

    /**
     *  Upload comun para todos los modulos, mueve un archivo temporal
     *  temps/file.tmp o el temps/$_REQUEST['name'].tmp 
     *  Guarda en una variable de session los datos de $_FILES['file_temp']   
     *
     */

  
  ini_set('upload_max_filesize', '10M');
  ini_set('post_max_size', '10M');

    $hash = $_REQUEST['hash'];

    $uploadData = $_SESSION[$hash];

    $manager = new Uploader($hash, $uploadData['max_size'],"*");

    $todo = $_REQUEST["todo"];

    if ($uploadData["name"] != "") {
        $name = $uploadData["name"];
    } else {
        $name = $hash;
    }
    $path = path_files("temp/$name");
    
    if ( file_exists($path) && is_file($path)){
        
        unlink($path);
    }
    
    $result = $manager->moveTo($path);

    if ($result > 0) {
        $_SESSION[$hash]["realName"] = $manager->getFileName();
    }else{
        $_SESSION[$hash]["realName"] = "";
        
    }



    //se mueve el archivo

    switch ($result) {
        case 1:
            $return = array(
                  'status' => '1',
                  'hash' => $hash,
                  "fileName" => $_SESSION[$hash]["realName"] 
            );
            break;
        case 2:
            $return = array(
                  'status' => '1',
                  'msg' => "Enlevé avec succès"
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
    header('Content-Type: application/json');
    echo json_encode($return);
?>
