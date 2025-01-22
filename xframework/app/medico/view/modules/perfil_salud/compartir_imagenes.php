<?php

  if ($this->request["ids"] != "") {
      $list_ids = explode(",", $this->request["ids"]);
      if ($list_ids && count($list_ids) > 0) {
          $ManagerPerfilSaludEstudiosImagen = $this->getManager("ManagerPerfilSaludEstudiosImagen");
//          $ManagerPerfilSaludEstudiosImagen->debug();
          $array_return = array();
          foreach ($list_ids as $key => $idperfilSaludEstudio) {
              if ((int) $idperfilSaludEstudio > 0) {
                  $list_imagenes = $ManagerPerfilSaludEstudiosImagen->getListImages($idperfilSaludEstudio);
                  if ($list_imagenes && count($list_imagenes)) {
                      foreach ($list_imagenes as $key => $imagen) {
                          $array_return[]["imagen"] = $imagen["path_images_perfil"];
                      }
                  }
              }
          }

          if (count($array_return) > 0) {
              $this->assign("listado_imagenes", $array_return);
          }
      }
  }