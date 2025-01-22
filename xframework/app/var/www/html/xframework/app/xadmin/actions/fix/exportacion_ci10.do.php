<?php

  $fila = 1;
  
  ini_set('memory_limit', '512M');
  ini_set('max_execution_time', '300');


  if (is_file(path_files("CSV_CIE10.csv"))) {
      echo "es archivos";
  }
  
  if (($gestor = fopen(path_files("CSV_CIE10.csv"), "r")) !== FALSE) {
      
      
      $manager = $this->getManager("ManagerImportacionCIE10");
      
      $i=0;
      while (! feof($gestor)) {
          //echo fgets($gestor) . "<br/>";
          $manager->insert(array("linea" => fgets($gestor)));
      
          echo $i++ . "<br/>";
      }
      fclose($gestor);
  }
  else{
      echo "no abrió el archivo";
  }
  
  
  