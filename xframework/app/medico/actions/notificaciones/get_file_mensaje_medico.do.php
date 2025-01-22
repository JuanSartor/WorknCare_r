<?php
// request para obtener el archivo adjuntado como mensaje en la notificacion
$notificacion = $this->getManager("ManagerNotificacion")->get($this->request["idnotificacion"]);
//comproabmos que la notificacion pertenece al paciente
if ($notificacion && $notificacion["medico_idmedico_emisor"] == $_SESSION[URL_ROOT][CONTROLLER]["logged_account"]["medico"]["idmedico"]) {
    $path = "archivos_mensaje_paciente/{$notificacion["medico_idmedico_emisor"]}/{$notificacion["paciente_idpaciente"]}/{$notificacion["idnotificacion"]}/{$this->request["filename"]}";
    $path_file = path_entity_files($path);

    if (file_exists($path_file) && is_file($path_file)) {
        
          header('Content-Description: File Transfer');
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
    }
} else {
    $this->finish(["result" => false]);
}