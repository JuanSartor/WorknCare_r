<?php

//$this->finish(["download" => "www.google.com", "result" => true]) ;
$notificacion = $this->getManager("ManagerNotificacion")->get($this->request["idnotificacion"]);
$paciente = $this->getManager("ManagerPaciente")->getPacienteXHeader();
//comproabmos que la notificacion pertenece al paciente
if ($notificacion && $notificacion["paciente_idpaciente"] == $paciente["idpaciente"]) {
    $path = "archivos_mensaje_paciente/{$notificacion["medico_idmedico_emisor"]}/{$notificacion["paciente_idpaciente"]}/{$notificacion["idnotificacion"]}/{$this->request["filename"]}";
    $path_file = path_entity_files($path);

    //echo $path_file;
    if (file_exists($path_file) && is_file($path_file)) {
        //$this->finish(["download" => url_entity_files($path), "result" => true]);
        

          header('Content-Description: File Transfer');
          //header('Content-Type: application/octet-stream');
          header('Content-Type:'.mime_content_type($path_file));
          header('Content-Disposition: inline; filename=' . basename($path_file));
          header('Content-Transfer-Encoding: binary');
          header('Expires: 0');
          header('Cache-Control: must-revalidate, post-check=0, pre-check=0');
          header('Pragma: public');
          header('Content-Length: ' . filesize($path_file));

          ob_clean();
          flush();
          readfile($path_file);
          exit;
         

        // header('Location: ' . url_entity_files($path));
    }
} else {
    $this->finish(["result" => false]);
}

    