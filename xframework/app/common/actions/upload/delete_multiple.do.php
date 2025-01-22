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

  $managerStr = $this->request["manager"];

  //$data =  print_r($uploadData,true).print_r($_FILES,true);
  //file_put_contents(path_root("log_upload.txt"), $data);

  $manager = $this->getManager($managerStr);

  //$manager->print_r($this->request);

  // $debug = "";

  if ($manager != "") {
      $result = $manager->deleteMultipleImg($this->request);
  } else {
      $debug = "NO entro a manager \n";
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
          $return = $manager->getMsg();

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
  