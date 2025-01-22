<script language="javascript" type="text/javascript" >

    var global_vars = new Object();
            var controller = "{$controller}";
    {if $layout != "maestra_print"}
    //conexion al servidor node.js
    //array acount definido en maestra.html
    var params = "tipo_usuario=paciente&idusuarioweb=" + account.idusuarioweb + "&idpaciente=" + account.idpaciente;
    //url donde esta corriendo el servidor node js
    //*'forceNew':true,
    var socket = io.connect("{$HTTP_HOST}:{$SERVER_NODE_PORT}", {ldelim} 'reconnection': true,'reconnectionDelay': 500,'reconnectionDelayMax' : 5000,'reconnectionAttempts': Infinity, 'query':params {rdelim});
      socket.on('disconnect', function(reason){
     console.log("desconectado:");
     
     console.log(reason);
  
     
   });
   
    {/if}


</script>