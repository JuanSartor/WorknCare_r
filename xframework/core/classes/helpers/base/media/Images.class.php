<?php

  /**
   * 	@author Diveria
   * 	@version 1.0	2008-04-14
   * 	Manager de imagenes
   *
   */
  class Images { //
      // variables

      /**
       * Constructor
       * Nota: $types no son extensiones, si no por ejemplo image/jpeg.	 
       *
       */

      function Images() {
          //constructor;
      }

// end constructor

      /**
       *   
       *  uploadImage
       *  Sube una imagen
       *  	 
       *  @author Diveria
       *  @param $fileName string nombre del campo del arreglo $_FILES
       *  @param $maxSize tamaño maximo de la imagen            	   	 
       *  @param $typesImages tipos de imagen para permitir subir            	 
       *  @param $newFile string ruta y nombre del archivo subido            	     
       *  @return integer resultado de la subida del archivo (ver detalle en ManagerUpload)	 
       */
      function uploadImage($fileName, $maxSize, $typesImages, $newFile) {

          $managerUpload = new ManagerUpload($fileName, $maxSize, $typesImages);

          return $managerUpload->moveTo($newFile);
      }

//end moveTo

      /**
       *
       *  Devuelve el tipo mime de un archivo
       *  @param $filename string nombre de la imagen para pedir el tipo
       *  @return string tipo mime del archivo
       */
      function getType($filename) {

          if (function_exists("finfo_file")) {
              $finfo = new finfo(FILEINFO_MIME);
              if (!$finfo) {
                  return mime_content_type($filename);
              } else {
                  return $finfo->file($filename);
              }
          } else {
              return mime_content_type($filename);
          }
      }

      /**
       *
       *  Realiza un resize de una imagen proporcional o cortando lo imagen dependiendo
       *  del parametro de alto de la imagen resultante 
       *  @param $imgName string nombre de la imagen original para hacerle el resize
       *  @param $nameResized string nombre de la imagen resultante
       *  @param $maxX integer maximo en x o y para el resize
       *  @param $maxY integer maximo en  y para el resize      
       *  @param $quality integer calidad de la imagen
       *  @param $name string nombre de la nueva imagen 
       */
      function resize($imgName, $nameResized, $maxX = NULL, $maxY = NULL, $force_proportional = false, $quality = 95) {

          if (!$force_proportional && (is_null($maxY) || $maxY == 0)) {
              $this->resizeImgProportional($imgName, $nameResized, $maxX, $quality);
          } else {

              if ($force_proportional) {
                  $this->resizeImgProportional2($imgName, $nameResized, $maxX, $maxY, $quality);
              } else {
                  $this->resizeImg($imgName, $nameResized, $maxX, $maxY, $quality);
              }
          }
      }

      /**
       *
       *  Realiza un resize de una imagen teniendo en cuenta el maximo pedido.
       *  @param $imgName string nombre de la imagen original para hacerle el resize
       *  @param $maxX integer maximo en x o y para el resize   
       *  @param $dirResized path donde se alojara la nueva imagen
       *  @param $name string nombre de la nueva imagen 
       *  @param $bicubic integer indica si se hace un resize bicubic
       */
      function resizeImg($imgName, $nameResized, $maxX, $maxY, $calidad = 95) {

          $File = new File($imgName);

          switch ($File->getExtension()) {
              case "jpg":case"jpeg":
                  $fuente = imagecreatefromjpeg($imgName);
                  $fName = "imagejpeg";
                  break;
              case "png":
                  $fuente = imagecreatefrompng($imgName);
                  $fName = "imagepng";
                  $calidad = 0;
                  break;
              case "gif":
                  $fuente = imagecreatefromgif($imgName);
                  $fName = "imagegif";
                  break;
          }

          $imgAncho = imagesx($fuente);
          $imgAlto = imagesy($fuente);


          if ($maxX >= $imgAncho && $maxY >= $imgAlto) {

              return copy($imgName, $nameResized);
          } else {

              $newHandle = @imagecreatetruecolor($maxX, $maxY);
              if (!$newHandle)
                  return false;

              if ($imgAlto < $imgAncho) {
                  $ratio = (double) ($imgAlto / $maxY);

                  $cpyWidth = round($maxX * $ratio);

                  if ($cpyWidth > $imgAncho) {
                      $ratio = (double) ($imgAncho / $maxX);
                      $cpyWidth = $imgAncho;
                      $cpyHeight = round($maxY * $ratio);
                      $xOffset = 0;
                      $yOffset = round(($imgAlto - $cpyHeight) / 2);
                  } else {
                      $cpyHeight = $imgAlto;
                      $xOffset = round(($imgAncho - $cpyWidth) / 2);
                      $yOffset = 0;
                  }
              } else {

                  $ratio = (double) ($imgAncho / $maxX);

                  $cpyHeight = round($maxY * $ratio);
                  if ($cpyHeight > $imgAlto) {
                      $ratio = (double) ($imgAlto / $maxY);
                      $cpyHeight = $imgAlto;
                      $cpyWidth = round($maxX * $ratio);
                      $xOffset = round(($imgAncho - $cpyWidth) / 2);
                      $yOffset = 0;
                  } else {
                      $cpyWidth = $imgAncho;
                      $xOffset = 0;
                      $yOffset = round(($imgAlto - $cpyHeight) / 2);
                  }
              }

              @imagecopyresampled($newHandle, $fuente, 0, 0, $xOffset, $yOffset, $maxX, $maxY, $cpyWidth, $cpyHeight);

              return $fName($newHandle, $nameResized, $calidad);
          }
      }

      /**
       *
       *  Realiza un resize de una imagen teniendo en cuenta el maximo pedido.
       *  @param $imgName string nombre de la imagen original para hacerle el resize
       *  @param $maxX integer maximo en x o y para el resize   
       *  @param $dirResized path donde se alojara la nueva imagen
       *  @param $name string nombre de la nueva imagen 
       *  @param $bicubic integer indica si se hace un resize bicubic
       */
      function resizeCropImg($imgName, $nameCropped, $width_crop, $height_crop, $left, $top, $grados_rotacion, $calidad = 95) {

          $File = new File($imgName);

          switch ($File->getExtension()) {
              case "jpg":
                  $fuente = imagecreatefromjpeg($imgName);
                  $fName = "imagejpeg";
                  break;
              case "png":
                  $fuente = imagecreatefrompng($imgName);
                  $fName = "imagepng";
                  $calidad = 0;
                  break;
              case "gif":
                  $fuente = imagecreatefromgif($imgName);
                  $fName = "imagegif";
                  break;
          }

          //Ancho y Alto de la imagen a cortar
          $width_to_crop = imagesx($fuente);
          $height_to_crop = imagesy($fuente);


          //Pregunto si viene rotación...
          if ($grados_rotacion > 0 && $grados_rotacion < 360) {

              //Tengo que rotar la imagen $fuente
              $fuente_rotada = imagerotate($fuente, $grados_rotacion, 0);

              if (file_exists($imgName)) {
                  unlink($imgName);
              }
              //Imprimo la imagen creada en $fuente
              imagejpeg($fuente_rotada, $imgName, 100);
              imagedestroy($fuente_rotada);
              $fuente = imagecreatefromjpeg($imgName);
          }

          $imagen = imagecreatetruecolor($width_crop, $height_crop);



          imagecopyresampled($imagen, $fuente, 0, 0, floor($left), floor($top), floor($width_crop), floor($height_crop), floor($width_crop), floor($height_crop));

          if (file_exists($nameCropped)) {
              unlink($nameCropped);
          }

          return imagejpeg($imagen, $nameCropped, 100);
      }

      /**
       *
       *  Realiza un resize de una imagen teniendo en cuenta el maximo pedido.
       *  @param $imgName string nombre de la imagen original para hacerle el resize
       *  @param $maxX integer maximo en x o y para el resize   
       *  @param $dirResized path donde se alojara la nueva imagen
       *  @param $name string nombre de la nueva imagen 
       *  @param $bicubic integer indica si se hace un resize bicubic
       */
      function resizeImgProportional($imgName, $nameResized, $maxX, $calidad = 95) {


          $File = new File($imgName);

          switch ($File->getExtension()) {
              case "jpg":
                  $fuente = imagecreatefromjpeg($imgName);
                  $fName = "imagejpeg";
                  break;
              case "png":
                  $fuente = imagecreatefrompng($imgName);
                  $fName = "imagepng";
                  break;
              case "gif":
                  $fuente = imagecreatefromgif($imgName);
                  $fName = "imagegif";
                  break;
          }

          $imgAncho = imagesx($fuente);
          $imgAlto = imagesy($fuente);

          if ($imgAncho <= $maxX) {
              return copy($imgName, $nameResized);
          }

          if ($imgAncho > $imgAlto)
              $newY = ceil($maxX / $imgAncho * $imgAlto);
          else {
              $newY = $maxX;
              $maxX = ceil($newY / $imgAlto * $imgAncho);
          }
          $imagen = imagecreatetruecolor($maxX, $newY);


          //$this->ImageCopyResampledBicubic2($imagen,$fuente,0,0,0,0,$maxX,$newY,$imgAncho,$imgAlto);
          imagecopyresampled($imagen, $fuente, 0, 0, 0, 0, $maxX, $newY, $imgAncho, $imgAlto);

          return $fName($imagen, $nameResized, $calidad);
      }

      /**
       *
       *  Realiza un resize de una imagen teniendo en cuenta el maximo pedido. Verifcando el mayor de x o de y
       *  @param $imgName string nombre de la imagen original para hacerle el resize
       *  @param $maxX integer maximo en x o y para el resize   
       *  @param $dirResized path donde se alojara la nueva imagen
       *  @param $name string nombre de la nueva imagen 
       *  @param $bicubic integer indica si se hace un resize bicubic
       */
      function resizeImgProportional2($imgName, $nameResized, $maxX, $maxY, $calidad = 95) {


          $File = new File($imgName);

          switch ($File->getExtension()) {
              case "jpg":
                  $fuente = imagecreatefromjpeg($imgName);
                  $fName = "imagejpeg";
                  break;
              case "png":
                  $fuente = imagecreatefrompng($imgName);
                  $fName = "imagepng";
                  break;
              case "gif":
                  $fuente = imagecreatefromgif($imgName);
                  $fName = "imagegif";
                  break;
          }

          $imgAncho = imagesx($fuente);
          $imgAlto = imagesy($fuente);

          /* if ($imgAncho<=$maxX){
            return copy($imgName,$nameResized);
            } */

          if ($imgAncho > $imgAlto && !is_null($maxX)) {

              $newY = ceil($maxX / $imgAncho * $imgAlto);
              $newX = $maxX;
          } else {
              if (is_null($maxY)) {
                  $maxY = $newX;
              }

              $newX = ceil($maxY / $imgAlto * $imgAncho);
              $newY = $maxY;
          }
          $imagen = imagecreatetruecolor($newX, $newY);


          //$this->ImageCopyResampledBicubic2($imagen,$fuente,0,0,0,0,$maxX,$newY,$imgAncho,$imgAlto);
          imagecopyresampled($imagen, $fuente, 0, 0, 0, 0, $newX, $newY, $imgAncho, $imgAlto);

          if ($fName($imagen, $nameResized, $calidad)) {
              return $this->resizeImg($nameResized, $nameResized, $maxX, $maxY, 100);
          } else {
              return false;
          }
      }

      /**
       *  Ancho en pixeles de la imagen
       *
       * */
      function getWidth($imgName) {
          $fuente = imagecreatefromjpeg($imgName);
          return imagesx($fuente);
      }

      /**
       *  Alto en pixeles de la imagen
       *
       * */
      function getHeight($imgName) {
          $fuente = imagecreatefromjpeg($imgName);
          return imagesy($fuente);
      }

      /*       * *
       *  cool stuff
       */

      function ImageCopyResampledBicubic(&$dst_image, &$src_image, $dst_x, $dst_y, $src_x, $src_y, $dst_w, $dst_h, $src_w, $src_h) {
          // we should first cut the piece we are interested in from the source
          $src_img = ImageCreateTrueColor($src_w, $src_h);
          imagecopy($src_img, $src_image, 0, 0, $src_x, $src_y, $src_w, $src_h);

          // this one is used as temporary image
          $dst_img = ImageCreateTrueColor($dst_w, $dst_h);

          ImagePaletteCopy($dst_img, $src_img);
          $rX = $src_w / $dst_w;
          $rY = $src_h / $dst_h;
          $w = 0;
          for ($y = 0; $y < $dst_h; $y++) {
              $ow = $w;
              $w = round(($y + 1) * $rY);
              $t = 0;
              for ($x = 0; $x < $dst_w; $x++) {
                  $r = $g = $b = 0;
                  $a = 0;
                  $ot = $t;
                  $t = round(($x + 1) * $rX);
                  for ($u = 0; $u < ($w - $ow); $u++) {
                      for ($p = 0; $p < ($t - $ot); $p++) {
                          $c = ImageColorsForIndex($src_img, ImageColorAt($src_img, $ot + $p, $ow + $u));
                          $r += $c['red'];
                          $g += $c['green'];
                          $b += $c['blue'];
                          $a++;
                      }
                  }
                  ImageSetPixel($dst_img, $x, $y, ImageColorClosest($dst_img, $r / $a, $g / $a, $b / $a));
              }
          }

          // apply the temp image over the returned image and use the destination x,y coordinates
          imagecopy($dst_image, $dst_img, $dst_x, $dst_y, 0, 0, $dst_w, $dst_h);

          // we should return true since ImageCopyResampled/ImageCopyResized do it
          return true;
      }

      function ImageCopyResampledBicubic2($dst_img, $src_img, $dst_x, $dst_y, $src_x, $src_y, $dst_w, $dst_h, $src_w, $src_h) {
          $scaleX = ($src_w - 1) / $dst_w;
          $scaleY = ($src_h - 1) / $dst_h;

          $scaleX2 = $scaleX / 2.0;
          $scaleY2 = $scaleY / 2.0;

          $tc = imageistruecolor($src_img);

          for ($y = $src_y; $y < $src_y + $dst_h; $y++) {
              $sY = $y * $scaleY;
              $siY = (int) $sY;
              $siY2 = (int) $sY + $scaleY2;

              for ($x = $src_x; $x < $src_x + $dst_w; $x++) {
                  $sX = $x * $scaleX;
                  $siX = (int) $sX;
                  $siX2 = (int) $sX + $scaleX2;

                  if ($tc) {
                      $c1 = imagecolorat($src_img, $siX, $siY2);
                      $c2 = imagecolorat($src_img, $siX, $siY);
                      $c3 = imagecolorat($src_img, $siX2, $siY2);
                      $c4 = imagecolorat($src_img, $siX2, $siY);

                      $r = (($c1 + $c2 + $c3 + $c4) >> 2) & 0xFF0000;
                      $g = ((($c1 & 0xFF00) + ($c2 & 0xFF00) + ($c3 & 0xFF00) + ($c4 & 0xFF00)) >> 2) & 0xFF00;
                      $b = ((($c1 & 0xFF) + ($c2 & 0xFF) + ($c3 & 0xFF) + ($c4 & 0xFF)) >> 2);

                      imagesetpixel($dst_img, $dst_x + $x - $src_x, $dst_y + $y - $src_y, $r + $g + $b);
                  } else {
                      $c1 = imagecolorsforindex($src_img, imagecolorat($src_img, $siX, $siY2));
                      $c2 = imagecolorsforindex($src_img, imagecolorat($src_img, $siX, $siY));
                      $c3 = imagecolorsforindex($src_img, imagecolorat($src_img, $siX2, $siY2));
                      $c4 = imagecolorsforindex($src_img, imagecolorat($src_img, $siX2, $siY));

                      $r = ($c1['red'] + $c2['red'] + $c3['red'] + $c4['red'] ) << 14;
                      $g = ($c1['green'] + $c2['green'] + $c3['green'] + $c4['green']) << 6;
                      $b = ($c1['blue'] + $c2['blue'] + $c3['blue'] + $c4['blue'] ) >> 2;

                      imagesetpixel($dst_img, $dst_x + $x - $src_x, $dst_y + $y - $src_y, $r + $g + $b);
                  }
              }
          }
      }

  }

  // end class ManagerUpload
?>