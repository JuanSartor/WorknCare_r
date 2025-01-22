<?php

  /**
   *  Genera un thumb de ina imagen y produce la salida
   *
   */
  //previene que suban directorios, solo permitimos del path root hacia adentro

  $path_parts = pathinfo(str_replace("../", "", $this->request["image"]));

  //si no existe el directorio que nos piden
  if (!is_dir(path_root($path_parts['dirname']))) {
      die('Error, acceso denegado');
  }

  $manager = new Images();

  $image = path_root($this->request["image"]);


  if (isset($this->request["w"])) {
      $w = (int) $this->request["w"];
  } else {
      $w = 85;
  }

  if (isset($this->request["h"])) {
      $h = (int) $this->request["h"];
  } else {
      $h = 85;
  }
  ob_clean();


  if (file_exists($image) && exif_imagetype($image) !== false) {


      //fix para imagenes subidas con el movil y se suben rotadas
      $imageExif = imagecreatefromstring(file_get_contents($image));
      $exif = exif_read_data($image);

      //file_put_contents(path_files("exif.txt"),  print_r($exif , true ));

      if (!empty($exif['Orientation'])) {

          $rotate = false;

          switch ($exif['Orientation']) {
              case 8:
                  $imageRotate = imagerotate($imageExif, 90, 0);
                  $rotate = true;
                  break;
              case 3:
                  $imageRotate = imagerotate($imageExif, 180, 0);
                  $rotate = true;
                  break;
              case 6:

                  $imageRotate = imagerotate($imageExif, -90, 0);

                  $rotate = true;
                  break;
          }

          if ($rotate) {

              $fileExt = pathinfo($image, PATHINFO_EXTENSION);

              switch ($fileExt) {
                  case "jpg":case "jpeg":
                      $fName = "imagejpeg";
                      break;
                  case "png":
                      $fName = "imagepng";
                      break;
                  case "gif":
                      $fName = "imagegif";
                      break;
              }

              if (isset($fName)) {

                  $fName($imageRotate, $image, 100);
              }
          }
      }

      $File = new File($image);

      $mime = $File->getMime();

      header("Content-type: $mime");

      $manager->resize($image, path_files("temp/images/thumbTemp.tmp"), $w, $h);

      echo file_get_contents(path_files("temp/images/thumbTemp.tmp"));
  } else if (isset($this->request["show_noimage"]) && $this->request["show_noimage"] == 1) {

      $image = path_files("temp/images/no_image.jpg");

      $File = new File($image);

      $mime = $File->getMime();

      header("Content-type: $mime");

      $manager->resize($image, path_files("temp/images/thumbTemp.tmp"), $w, $h);

      echo file_get_contents(path_files("temp/images/thumbTemp.tmp"));
  } else {
      die("error file not exists");
  }
