<?php

$file = path_config("init.config.php");

// Open the file to get existing content
$content = file_get_contents($file);

//reemplazar el contenido con el nuevo valor
$valor=$this->request["valor"];
   $modify_content=preg_replace("/\"MONTO_CUOTA\"\,.*[0-9]+/","\"MONTO_CUOTA\",$valor", $content);

// Write the contents back to the file
$rdo=file_put_contents($file, $modify_content,LOCK_EX);
if($rdo){
    $this->finish(["result"=>true,"msg"=>"Registro actualizado con éxito"]);
}else{
     $this->finish(["result"=>false,"msg"=>"Ha ocurrido un error"]);
}
