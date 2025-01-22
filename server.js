//1.inbcluir librerias
var express = require('express'); 
var fs      = require("fs");        // file system core module
var app = express();
var https = require('https'); // https server core module

var mysql = require('mysql'); //libreria mysql
var db_config=require('./db_config.json'); //archivo json conexion DB

//var server = require('http').Server(app);    //localhost
        




//2. poner a correr el servidor  en el puerto deseado

/*Localhost
server.listen(8000, function () {
    console.log('Servidor corriendo en http://localhost:8000');
});*/

//remoto: debemos pasarles las credenciales ssl
var webServer = https.createServer(
{
    key:  fs.readFileSync("/etc/letsencrypt/live/www.doctorplus.eu/privkey.pem"),
    cert: fs.readFileSync("/etc/letsencrypt/live/www.doctorplus.eu/cert.pem")
},app).listen(8000,function(){console.log("Servidor corriendo en https://www.doctorplus.fr:8000")});

// 3.Iniciar Socket.io y añadirlo  to Express server
var io = require('socket.io')(webServer);
io.set('heartbeat timeout', 4000); 
io.set('heartbeat interval', 2000);


/*CONEXION A LA BD*/
// Definicion de credenciales de conexion a la BD
var db = mysql.createConnection(db_config);

// conexion a la BD
try{
    db.connect(function (error) {
    if (error) {

        throw error;
    } else {
        console.log('Conectado a la BD');
    }
});
}catch(error){
        console.log("Error de conexion");
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*Desarrollo de la aplicacion a partir de aqui*/

//listados de objetos
var medicos = new Object();
//var medicos = new Object();
var pacientes = new Object();
var familiares = new Object();
var conexiones = new Object();
var especialidades = new Object();


/*Funcion que detecta la conexion de un socket*/
io.sockets.on('connection', function (socket) {

	socket.on("get_medicos",function(data){
		io.sockets.emit('list_medicos', medicos);

	});

		socket.on("get_pacientes",function(data){
		io.sockets.emit('list_pacientes', pacientes);

	});


    if (socket.handshake.query.tipo_usuario == "medico") {

        console.log('Medico conectado');
		//console.log(socket.id);
		storeMedicoInfo(socket.handshake.query);
	//	console.log(medicos);

    }
    if (socket.handshake.query.tipo_usuario == "paciente") {
        console.log('Paciente conectado');
	//	console.log(socket.id);
		storePacienteInfo(socket.handshake.query);
		//console.log(pacientes);

    }

    /**Evento recibido del cliente php cuando se insert una notificacion nueva
     * Se verifica el tipo de notificacion  y a quien esta dirigida para notificarle
     *
     */
    socket.on('notificacion_creada_php', function (data) {

        //verificamos si es medico
        if (data!=undefined && data.medico_idmedico != undefined) {

            emit_sockets_medico(data.medico_idmedico, 'nueva_notificacion', {});
        } else {//verificamos si es paciente
            if (data!=undefined && data.paciente_idpaciente != undefined) {
                emit_sockets_paciente(data.paciente_idpaciente, 'nueva_notificacion', {});
            }
        }

    });
    /**Evento recibido del cliente php cuando el medico cambia el estado de un turno
     * Se verifica  a quien pertenece el turno y se notifica al paciente
     *
     */
    socket.on('cambio_estado_turno_php', function (data) {
        if(data!=undefined){
        if (data.paciente_idpaciente != undefined) {
            var query_str = "SELECT count(t.idturno) as cant FROM turno t where t.paciente_idpaciente =? and t.estado=1";
            query_str += " and t.fecha>SYSDATE()";

            db.query(query_str, [data.paciente_idpaciente], function (err, rows) {
                if (err) {
                    throw err;
                }
                emit_sockets_paciente(data.paciente_idpaciente, 'cambio_estado_turno', rowsToObject(rows));
            });

        }
		}
    });


    /**Evento recibido del cliente php cuando se cambia el estado de una consulta express
     * Se verifica  el medico  y paciente de la consulta express y se envia un mensaje con los nuevos contadores de CE
     *
     */
    socket.on('cambio_estado_consultaexpress_php', function (data) {
		if(data!=undefined){
		console.log(data);
        try {

            if (data.paciente_idpaciente != undefined) {
                var pendientes_p = 0, abiertas_p = 0, abiertas_total_p = 0, rechazadas_p = 0, rechazadas_total_p = 0, finalizadas_p = 0,pendientes_finalizacion=0, finalizadas_total_p = 0, vencidas_p = 0, vencidas_total_p = 0;

                //formamos las query para obtener las cantidades
                var query_str_pendientes = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=1"
                        + " AND visualizar_consulta_paciente=1 AND paciente_idpaciente=" + data.paciente_idpaciente;


                //solo las no leidas
                var query_str_abiertas = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=2"
                        + " AND visualizar_consulta_paciente=1  AND paciente_idpaciente=" + data.paciente_idpaciente;

                var query_str_abiertas_total = "select count(*) as cantidad,'Abiertas_total' AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=2"
                        + " AND visualizar_consulta_paciente=1 AND paciente_idpaciente=" + data.paciente_idpaciente;
                //solo las no leidas
                var query_str_rechazadas = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=3"
                        + " AND visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=" + data.paciente_idpaciente;

                var query_str_rechazadas_total = "select count(*) as cantidad,'Rechazadas_total' AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=3"
                        + " AND visualizar_consulta_paciente=1 and paciente_idpaciente=" + data.paciente_idpaciente;
                //solo las no leidas
                var query_str_finalizadas = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE (estadoConsultaExpress_idestadoConsultaExpress=4 OR estadoConsultaExpress_idestadoConsultaExpress=8)"
                        + " AND visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=" + data.paciente_idpaciente;

                var query_str_finalizadas_total = "select count(*) as cantidad,'Finalizadas_total' AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE (estadoConsultaExpress_idestadoConsultaExpress=4 OR estadoConsultaExpress_idestadoConsultaExpress=8)"
                        + " AND visualizar_consulta_paciente=1 and paciente_idpaciente=" + data.paciente_idpaciente;
                //solo las no leidas
                var query_str_vencidas = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=5"
                        + " AND visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=" + data.paciente_idpaciente;

                var query_str_vencidas_total = "select count(*) as cantidad,'Vencidas_total' AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=5"
                        + " AND visualizar_consulta_paciente=1 and paciente_idpaciente=" + data.paciente_idpaciente;
						   //pendientes de finalizcacion
                var query_str_pendientes_finalizacion = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=8"
                        + " AND visualizar_consulta_paciente=1 AND paciente_idpaciente=" + data.paciente_idpaciente;



                var query = "(" + query_str_pendientes + ") UNION (" + query_str_abiertas + ") UNION (" + query_str_abiertas_total + ") UNION (" + query_str_rechazadas + ") UNION (" + query_str_rechazadas_total + ") UNION (" + query_str_finalizadas + ") UNION (" + query_str_finalizadas_total + ") UNION (" + query_str_vencidas + ") UNION (" + query_str_vencidas_total + ") UNION (" + query_str_pendientes_finalizacion +")";

                //realizamos las consultas a la BD y almacenamos la cantidad en una variable temporal

                db.query(query, [], function (err, rows) {
                    if (err) {

                        throw err;
                    }

                    pendientes_p = rows[0].cantidad;
                    abiertas_p = rows[1].cantidad;
                    abiertas_total_p = rows[2].cantidad;
                    rechazadas_p = rows[3].cantidad;
                    rechazadas_total_p = rows[4].cantidad;
                    finalizadas_p = rows[5].cantidad;
                    finalizadas_total_p = rows[6].cantidad;
                    vencidas_p = rows[7].cantidad;
                    vencidas_total_p = rows[8].cantidad;
					pendientes_finalizacion_p = rows[9].cantidad;
                    //creamos el objeto con todas los contadores de notificaciones
                    var notificaciones_ce = {};
                    notificaciones_ce.pendientes = pendientes_p;
                    notificaciones_ce.abiertas = abiertas_p;
                    notificaciones_ce.abiertas_total = abiertas_total_p;
                    notificaciones_ce.rechazadas = rechazadas_p;
                    notificaciones_ce.rechazadas_total = rechazadas_total_p;
                    notificaciones_ce.finalizadas = finalizadas_p;
                    notificaciones_ce.finalizadas_total = finalizadas_total_p;
                    notificaciones_ce.vencidas = vencidas_p;
                    notificaciones_ce.vencidas_total = vencidas_total_p;
					notificaciones_ce.pendientes_finalizacion = pendientes_finalizacion_p;
                    notificaciones_ce.notificacion_general = abiertas_p + rechazadas_p + finalizadas_p + vencidas_p;
                    notificaciones_ce.idconsultaExpress = data.idconsultaExpress;

                    emit_sockets_paciente(data.paciente_idpaciente, 'cambio_estado_consultaexpress', notificaciones_ce);

                });

            }

            if (data.medico_idmedico != undefined) {
                var pendientes = 0, abiertas = 0, abiertas_total = 0, rechazadas = 0,rechazadas_total = 0, finalizadas = 0,finalizadas_total = 0, vencidas = 0,vencidas_total= 0, red = 0;


                //formamos las query para obtener las cantidades
                var query_str_pendientes = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=1"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;

                //solo las no leidas
                var query_str_abiertas = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=2"
                        + " AND visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=" + data.medico_idmedico;

                var query_str_abiertas_total = "select count(*) as cantidad,'Abiertas_total' AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=2"
                        + " AND visualizar_consulta_medico=1  and medico_idmedico=" + data.medico_idmedico;

                //solo las no leidas
                var query_str_rechazadas = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=3"
                        + " AND visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=" + data.medico_idmedico;

                var query_str_rechazadas_total = "select count(*) as cantidad,'Rechazadas_total' AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=3"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;
                //solo las no leidas
                var query_str_finalizadas = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=4"
                        + " AND visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=" + data.medico_idmedico;

                var query_str_finalizadas_total = "select count(*) as cantidad,'Finalizadas_total' AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=4"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;
                //solo las no leidas
                var query_str_vencidas = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=5"
                        + " AND visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=" + data.medico_idmedico;

                var query_str_vencidas_total = "select count(*) as cantidad,'Vencidas_total' AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=5"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;

                var query_str_red = "SELECT COUNT(*) as cantidad,'red' AS estado from ("
						+ " SELECT idconsultaExpress"
						+ " FROM consultaexpress ce"
						+ " INNER JOIN filtrosbusquedaconsultaexpress fc on (fc.consultaExpress_idconsultaExpress=ce.idconsultaExpress)"
						+ " INNER JOIN especialidadmedico em on (em.especialidad_idespecialidad=fc.especialidad_idespecialidad)"
						+ " INNER JOIN  medico m on (m.idmedico=em.medico_idmedico) "
						+ " WHERE estadoConsultaExpress_idestadoConsultaExpress=1"
						+ " AND tipo_consulta=0"
						+ " AND m.idmedico=" + data.medico_idmedico
						+ " )t";
				var query_str_pendientes_finalizacion = "select count(*) as cantidad,e.estadoConsultaExpress AS estado"
                        + " FROM consultaexpress ce INNER JOIN estadoconsultaexpress e ON (ce.estadoConsultaExpress_idestadoConsultaExpress = e.idestadoConsultaExpress)"
                        + " WHERE estadoConsultaExpress_idestadoConsultaExpress=8"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;


                var query = "(" + query_str_pendientes + ") UNION (" + query_str_abiertas + ") UNION (" + query_str_abiertas_total +") UNION (" + query_str_rechazadas + ") UNION ("+ query_str_rechazadas_total + ") UNION (" + query_str_finalizadas + ") UNION ("+ query_str_finalizadas_total + ") UNION (" + query_str_vencidas + ") UNION ("+ query_str_vencidas_total + ") UNION (" + query_str_red +") UNION (" +query_str_pendientes_finalizacion+")";


                //realizamos las consultas a la BD y almacenamos la cantidad en una variable temporal

                db.query(query, [], function (err, rows) {
                    if (err) {

                        throw err;
                    }

                    console.log(rows);
                    pendientes = rows[0].cantidad;
                    abiertas = rows[1].cantidad;
                    abiertas_total = rows[2].cantidad;
                    rechazadas = rows[3].cantidad;
                    rechazadas_total = rows[4].cantidad;
                    finalizadas = rows[5].cantidad;
                    finalizadas_total = rows[6].cantidad;
                    vencidas = rows[7].cantidad;
                    vencidas_total = rows[8].cantidad;
                    red = rows[9].cantidad;
					pendientes_finalizacion = rows[10].cantidad;
                    //creamos el objeto con todas los contadores de notificaciones
                    var notificaciones_ce = {};
                    notificaciones_ce.pendientes = pendientes;
                    notificaciones_ce.abiertas = abiertas;
                    notificaciones_ce.abiertas_total = abiertas_total;
                    notificaciones_ce.rechazadas = rechazadas;
                    notificaciones_ce.rechazadas_total = rechazadas_total;
                    notificaciones_ce.finalizadas = finalizadas;
                    notificaciones_ce.finalizadas_total = finalizadas_total;
                    notificaciones_ce.vencidas = vencidas;
                    notificaciones_ce.vencidas_total = vencidas_total;
                    notificaciones_ce.red = red;
					notificaciones_ce.pendientes_finalizacion = pendientes_finalizacion;
                    notificaciones_ce.notificacion_general =  abiertas+pendientes_finalizacion + pendientes + red;
                    notificaciones_ce.idconsultaExpress = data.idconsultaExpress;

                    emit_sockets_medico(data.medico_idmedico, 'cambio_estado_consultaexpress', notificaciones_ce);

                });


            }

        } catch (err) {
            console.log("Error:");
            console.log(err);
        }
		}
    });



    /**Evento recibido del cliente php cuando se crea una  consulta express o cambia de estado
     * Se verifica  la especialidad  y se envia un mensaje con los nuevos contadores de CE en la red a todos los medicos
     *
     */
    socket.on('cambio_estado_consultaexpress_red_php', function (data) {
		if(data!=undefined){

        try {

            if (data.idespecialidad != undefined) {
                var red = 0;

                //formamos las query para obtener las cantidades
                var query_str= "select count(*) as cantidad, idespecialidad,especialidad"
                        +" FROM consultaexpress ce"
						+" INNER JOIN filtrosbusquedaconsultaexpress f on (f.consultaExpress_idconsultaExpress=ce.idconsultaExpress)"
						+"INNER  JOIN especialidad es on (es.idespecialidad=f.especialidad_idespecialidad)"
                        + " WHERE ce.estadoConsultaExpress_idestadoConsultaExpress=1"
                        + " AND tipo_consulta=0 and idespecialidad=" + data.idespecialidad;



                //realizamos las consultas a la BD y almacenamos la cantidad en una variable temporal

                db.query(query_str, [], function (err, rows) {
                    if (err) {

                        throw err;
                    }

                    red= rows[0].cantidad;

                    //creamos el objeto con todas los contadores de notificaciones
                    var notificaciones_red = {};
                    notificaciones_red.cantidad = red;
					notificaciones_red.idespecialidad = data.idespecialidad;

                    emit_sockets_medico('all', 'cambio_estado_consultaexpress_red', notificaciones_red);

                });

            }
		}catch (err) {
            console.log("Error:");
            console.log(err);
        }
		}
	});




    /**Evento recibido del cliente php cuando se crea una  videoconsulta o cambia de estado
     * Se verifica  la especialidad  y se envia un mensaje con los nuevos contadores de VC en la red a todos los medicos
     *
     */
    socket.on('cambio_estado_videoconsulta_red_php', function (data) {
		if(data!=undefined){

        try {

            if (data.idespecialidad != undefined) {
                var red = 0;

                //formamos las query para obtener las cantidades
                var query_str= "select count(*) as cantidad, idespecialidad,especialidad"
                        +" FROM videoconsulta vc"
						+" INNER JOIN filtrosbusquedavideoconsulta f on (f.videoconsulta_idvideoconsulta=vc.idvideoconsulta)"
						+"INNER  JOIN especialidad es on (es.idespecialidad=f.especialidad_idespecialidad)"
                        + " WHERE vc.estadoVideoConsulta_idestadoVideoConsulta=1"
                        + " AND tipo_consulta=0 and idespecialidad=" + data.idespecialidad;



                //realizamos las consultas a la BD y almacenamos la cantidad en una variable temporal

                db.query(query_str, [], function (err, rows) {
                    if (err) {

                        throw err;
                    }
				   red= rows[0].cantidad;

                    //creamos el objeto con todas los contadores de notificaciones
                    var notificaciones_red = {};
                    notificaciones_red.cantidad = red;
					notificaciones_red.idespecialidad = data.idespecialidad;
                  console.log(notificaciones_red);
                    emit_sockets_medico('all', 'cambio_estado_videoconsulta_red', notificaciones_red);

                });

            }
		}catch (err) {
            console.log("Error:");
            console.log(err);
        }
		}
	});
 /**Evento recibido del cliente php cuando se cambia el estado de una video consulta
     * Se verifica  el medico  y paciente de la video consulta y se envia un mensaje con los nuevos contadores de VC
     *
     */
    socket.on('cambio_estado_videoconsulta_php', function (data) {
		if(data!=undefined){
        try {

            if (data.paciente_idpaciente != undefined) {
                var pendientes_p = 0, abiertas_p = 0, abiertas_total_p = 0, rechazadas_p = 0, rechazadas_total_p = 0, finalizadas_p = 0, finalizadas_total_p = 0, vencidas_p = 0, vencidas_total_p = 0,pendientes_finalizacion_p = 0;

                //formamos las query para obtener las cantidades
                var query_str_pendientes = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=1"
                        + " AND visualizar_consulta_paciente=1 AND paciente_idpaciente=" + data.paciente_idpaciente;


                //solo las no leidas
                var query_str_abiertas = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=2"
                        + " AND visualizar_consulta_paciente=1 AND leido_paciente=0 AND paciente_idpaciente=" + data.paciente_idpaciente;

                var query_str_abiertas_total = "select count(*) as cantidad,'Abiertas_total' AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=2"
                        + " AND visualizar_consulta_paciente=1 AND paciente_idpaciente=" + data.paciente_idpaciente;
                //solo las no leidas
                var query_str_rechazadas = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=3"
                        + " AND visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=" + data.paciente_idpaciente;

                var query_str_rechazadas_total = "select count(*) as cantidad,'Rechazadas_total' AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=3"
                        + " AND visualizar_consulta_paciente=1 and paciente_idpaciente=" + data.paciente_idpaciente;
                //solo las no leidas
                var query_str_finalizadas = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=4"
                        + " AND visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=" + data.paciente_idpaciente;

                var query_str_finalizadas_total = "select count(*) as cantidad,'Finalizadas_total' AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=4"
                        + " AND visualizar_consulta_paciente=1 and paciente_idpaciente=" + data.paciente_idpaciente;
                //solo las no leidas
                var query_str_vencidas = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=5"
                        + " AND visualizar_consulta_paciente=1 and leido_paciente=0 and paciente_idpaciente=" + data.paciente_idpaciente;

                var query_str_vencidas_total = "select count(*) as cantidad,'Vencidas_total' AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=5"
                        + " AND visualizar_consulta_paciente=1 and paciente_idpaciente=" + data.paciente_idpaciente;
                 //pendientes de finalizcacion
                var query_str_pendientes_finalizacion = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=8"
                        + " AND visualizar_consulta_paciente=1 AND paciente_idpaciente=" + data.paciente_idpaciente;

                var query = "(" + query_str_pendientes + ") UNION (" + query_str_abiertas + ") UNION (" + query_str_abiertas_total + ") UNION (" + query_str_rechazadas + ") UNION (" + query_str_rechazadas_total + ") UNION (" + query_str_finalizadas + ") UNION (" + query_str_finalizadas_total + ") UNION (" + query_str_vencidas + ") UNION (" + query_str_vencidas_total +") UNION (" + query_str_pendientes_finalizacion + ")";




                //realizamos las consultas a la BD y almacenamos la cantidad en una variable temporal

                db.query(query, [], function (err, rows) {
                    if (err) {

                        throw err;
                    }

                    pendientes_p = rows[0].cantidad;
                    abiertas_p = rows[1].cantidad;
                    abiertas_total_p = rows[2].cantidad;
                    rechazadas_p = rows[3].cantidad;
                    rechazadas_total_p = rows[4].cantidad;
                    finalizadas_p = rows[5].cantidad;
                    finalizadas_total_p = rows[6].cantidad;
                    vencidas_p = rows[7].cantidad;
                    vencidas_total_p = rows[8].cantidad;
                    pendientes_finalizacion_p = rows[9].cantidad;
                    //creamos el objeto con todas los contadores de notificaciones
                    var notificaciones_vc = {};
                    notificaciones_vc.pendientes = pendientes_p;
                    notificaciones_vc.abiertas = abiertas_p;
                    notificaciones_vc.abiertas_total = abiertas_total_p;
                    notificaciones_vc.rechazadas = rechazadas_p;
                    notificaciones_vc.rechazadas_total = rechazadas_total_p;
                    notificaciones_vc.finalizadas = finalizadas_p;
                    notificaciones_vc.finalizadas_total = finalizadas_total_p;
                    notificaciones_vc.vencidas = vencidas_p;
                    notificaciones_vc.vencidas_total = vencidas_total_p;
                    notificaciones_vc.pendientes_finalizacion = pendientes_finalizacion_p;
                    notificaciones_vc.notificacion_general = abiertas_p + rechazadas_p + finalizadas_p + vencidas_p;
                    notificaciones_vc.idvideoconsulta = data.idvideoconsulta;

                    emit_sockets_paciente(data.paciente_idpaciente, 'cambio_estado_videoconsulta', notificaciones_vc);

                });

				//verificamos si posee una vc en el consultorio virtual para marcarlo como activo
				    var query_habilitar_consultorio = "select count(*) as habilitadas"
                        + " FROM videoconsulta vc "
                        + " WHERE (estadoVideoConsulta_idestadoVideoConsulta=7 OR (estadoVideoConsulta_idestadoVideoConsulta=2 and SYSDATE()>=inicio_sala))"
                        + " AND paciente_idpaciente=" + data.paciente_idpaciente;

					db.query(query_habilitar_consultorio, [], function (err, rows) {
						if (err) {

							throw err;
						}

                    var habilitadas = rows[0].habilitadas;
					if(habilitadas>0){
							emit_sockets_paciente(data.paciente_idpaciente, 'habilitar_consultorio_virtual', {mostrar:1});
					}else{
							emit_sockets_paciente(data.paciente_idpaciente, 'habilitar_consultorio_virtual', {mostrar:0});
					}
					});


            }

            if (data.medico_idmedico != undefined) {
                var pendientes = 0, abiertas = 0, abiertas_total = 0, rechazadas = 0,rechazadas_total = 0, finalizadas = 0,finalizadas_total = 0, vencidas = 0,vencidas_total= 0, red = 0,pendientes_finalizacion = 0;


                //formamos las query para obtener las cantidades
                var query_str_pendientes = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=1"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;

                //solo las no leidas
                var query_str_abiertas = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=2"
                        + " AND visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=" + data.medico_idmedico;

                var query_str_abiertas_total = "select count(*) as cantidad,'Abiertas_total' AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=2"
                        + " AND visualizar_consulta_medico=1  and medico_idmedico=" + data.medico_idmedico;

                //solo las no leidas
                var query_str_rechazadas = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=3"
                        + " AND visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=" + data.medico_idmedico;

                var query_str_rechazadas_total = "select count(*) as cantidad,'Rechazadas_total' AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=3"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;
                //solo las no leidas
                var query_str_finalizadas = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=4"
                        + " AND visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=" + data.medico_idmedico;

                var query_str_finalizadas_total = "select count(*) as cantidad,'Finalizadas_total' AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=4"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;
                //solo las no leidas
                var query_str_vencidas = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=5"
                        + " AND visualizar_consulta_medico=1 and leido_medico=0 and medico_idmedico=" + data.medico_idmedico;

                var query_str_vencidas_total = "select count(*) as cantidad,'Vencidas_total' AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=5"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;

                var query_str_red = "SELECT COUNT(*) as cantidad,'red' AS estado from ("
						+ " SELECT idvideoconsulta"
                        + " FROM videoconsulta vc"
						+ " INNER JOIN filtrosbusquedavideoconsulta fv on (fv.videoconsulta_idvideoconsulta=vc.idvideoconsulta)"
						+ " INNER JOIN especialidadmedico em on (em.especialidad_idespecialidad=fv.especialidad_idespecialidad)"
						+ " INNER JOIN  medico m on (m.idmedico=em.medico_idmedico)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=1"
                        + " AND tipo_consulta=0"
						+ " AND m.idmedico="+data.medico_idmedico
						+ " ) t"


                var query_str_pendientes_finalizacion = "select count(*) as cantidad,e.estadoVideoConsulta AS estado"
                        + " FROM videoconsulta vc INNER JOIN estadovideoconsulta e ON (vc.estadoVideoConsulta_idestadoVideoConsulta = e.idestadoVideoConsulta)"
                        + " WHERE estadoVideoConsulta_idestadoVideoConsulta=8"
                        + " AND visualizar_consulta_medico=1 and medico_idmedico=" + data.medico_idmedico;

                var query = "(" + query_str_pendientes + ") UNION (" + query_str_abiertas + ") UNION (" + query_str_abiertas_total +") UNION (" + query_str_rechazadas + ") UNION ("+ query_str_rechazadas_total + ") UNION (" + query_str_finalizadas + ") UNION ("+ query_str_finalizadas_total + ") UNION (" + query_str_vencidas + ") UNION ("+ query_str_vencidas_total + ") UNION (" + query_str_red +") UNION (" +query_str_pendientes_finalizacion+")";


                //realizamos las consultas a la BD y almacenamos la cantidad en una variable temporal

                db.query(query, [], function (err, rows) {
                    if (err) {

                        throw err;
                    }

                    console.log(rows);
                    pendientes = rows[0].cantidad;
                    abiertas = rows[1].cantidad;
                    abiertas_total = rows[2].cantidad;
                    rechazadas = rows[3].cantidad;
                    rechazadas_total = rows[4].cantidad;
                    finalizadas = rows[5].cantidad;
                    finalizadas_total = rows[6].cantidad;
                    vencidas = rows[7].cantidad;
                    vencidas_total = rows[8].cantidad;
                    red = rows[9].cantidad;
                    pendientes_finalizacion = rows[10].cantidad;
                    //creamos el objeto con todas los contadores de notificaciones
                    var notificaciones_vc = {};
                    notificaciones_vc.pendientes = pendientes;
                    notificaciones_vc.abiertas = abiertas;
                    notificaciones_vc.abiertas_total = abiertas_total;
                    notificaciones_vc.rechazadas = rechazadas;
                    notificaciones_vc.rechazadas_total = rechazadas_total;
                    notificaciones_vc.finalizadas = finalizadas;
                    notificaciones_vc.finalizadas_total = finalizadas_total;
                    notificaciones_vc.vencidas = vencidas;
                    notificaciones_vc.vencidas_total = vencidas_total;
                    notificaciones_vc.red = red;
                    notificaciones_vc.pendientes_finalizacion = pendientes_finalizacion;
                    notificaciones_vc.notificacion_general = abiertas+pendientes_finalizacion + pendientes + red;
                    notificaciones_vc.idvideoconsulta = data.idvideoconsulta;

                    emit_sockets_medico(data.medico_idmedico, 'cambio_estado_videoconsulta', notificaciones_vc);

                });
					//verificamos si posee una vc en el consultorio virtual para marcarlo como activo
				    var query_habilitar_consultorio = "select count(*) as habilitadas"
                        + " FROM videoconsulta vc "
                        + " WHERE (estadoVideoConsulta_idestadoVideoConsulta=7 OR (estadoVideoConsulta_idestadoVideoConsulta=2 and SYSDATE()>=inicio_sala))"
                        + " AND medico_idmedico=" + data.medico_idmedico;

					db.query(query_habilitar_consultorio, [], function (err, rows) {
						if (err) {

							throw err;
						}

                    var habilitadas = rows[0].habilitadas;
					if(habilitadas>0){
							emit_sockets_medico(data.medico_idmedico, 'habilitar_consultorio_virtual', {mostrar:1});
					}else{
							emit_sockets_medico(data.medico_idmedico, 'habilitar_consultorio_virtual', {mostrar:0});
					}
					});

            }

        } catch (err) {
            console.log("Error:");
            console.log(err);
        }
		}
    });

/**Metodo recibido desde php para notificiarle a los clientes un evento mediante una noificacion emergente
*
*/
socket.on('notify_php',function(data){
	console.log("notify");
	console.log(data);
	if(data!=undefined){
		if(data.paciente_idpaciente!=""){
			        emit_sockets_paciente(data.paciente_idpaciente, 'show_notify', data);
		}
		if(data.medico_idmedico!=""){
			        emit_sockets_medico(data.medico_idmedico, 'show_notify', data);
		}
	}

})


    /**
     * Evento de desconexion de un socket cliente
     */
    socket.on('disconnect', function (data) {
		if(data!=undefined){

		console.log("data del disconnect: "+data);

        /*verificamos si es medico o paciente*/
        if (conexiones[socket.id] != undefined) {
            if (conexiones[socket.id].tipo_usuario == "medico") {
				console.log("Medico desconectado:"+socket.id);
				//console.log("Listado medicos antes");
				//console.log(medicos);
                /*medico*/
                /*eliminamos el socket del listado de sockets que tiene el medico*/
                var arr_ids = medicos[conexiones[socket.id].idmedico].clientIds;
                arr_ids.splice(arr_ids.indexOf(socket.id), 1);
                medicos[conexiones[socket.id].idmedico].clientIds = arr_ids;
                /*si no hay mas sockets abiertos por el medico, lo eliminamos del listado*/

                if (medicos[conexiones[socket.id].idmedico].clientIds.length == 0) {
                    delete medicos[conexiones[socket.id].idmedico];
                }
			//console.log("Listado medicos despues");
			//	console.log(medicos);


            } else {
				console.log("Paciente desconectado:"+socket.id);
				//	console.log("Listado pacientes antes");
		//	console.log(pacientes);
                /*paciente*/
                /*eliminamos el socket del listado de sockets que tiene el paciente*/
                var arr_ids = pacientes[conexiones[socket.id].idpaciente].clientIds;

                arr_ids.splice(arr_ids.indexOf(socket.id), 1);

                pacientes[conexiones[socket.id].idpaciente].clientIds = arr_ids;
                /*si no hay mas sockets abiertos por el paciente, lo eliminamos del listado*/
                if (pacientes[conexiones[socket.id].idpaciente].clientIds.length == 0) {
                    delete pacientes[conexiones[socket.id].idpaciente];
                }
					//	console.log("Listado pacientes despues");
	//		console.log(pacientes);

            }

            delete conexiones[socket.id];


        }

		}
    });

    /**
     * Evento que obtiene la cantidad de notificaciones sin leer del medico o paciente y emite un mensaje
     */
    socket.on('actualizar_notificaciones', function (data) {
		if(data!=undefined){

        if (data.tipo_usuario == "medico" && data.idmedico != undefined) {
            var query_str = 'SELECT count(*) as cant_notificaciones FROM notificacion where leido=0 and medico_idmedico=?';
            db.query(query_str, [data.idmedico], function (err, rows) {
                if (err)
                    throw err;
                emit_sockets_medico(data.idmedico, 'notificaciones', rowsToObject(rows));
            });
        } else if (data.tipo_usuario == "paciente" && data.idpaciente != undefined) {
            var query_str = 'SELECT count(*) as cant_notificaciones FROM notificacion where leido=0 and paciente_idpaciente=?';
            db.query(query_str, [data.idpaciente], function (err, rows) {
                if (err)
                    throw err;


                emit_sockets_paciente(data.idpaciente, 'notificaciones', rowsToObject(rows));
            });
        }


		}
    });




    /**Funcion que emite un mensaje 'msg' de tipo 'evento' al todos los sockets que tiene el medico
     *
     * @param {type} idmedico medico del cual se obtienen los sockets
     * @param {type} msg_type tipo de mensaje emitido
     * @param {type} msg mensaje que se emite
     * @returns {undefined}
     */
    function emit_sockets_medico(idmedico, msg_type, msg) {



if(idmedico=="all"){
	//iteramos sobre todos los objetos contenidos en el listado de objetos->cada propiedad:valor contiene un medico


	for (var idmedico in medicos) {

		  medicos[idmedico].clientIds.forEach(function (socketId) {

                if (io.sockets.connected[socketId] != undefined) {

                    io.sockets.connected[socketId].emit(msg_type, msg);
                }
            });
			};
}else{
	if (medicos[idmedico] != undefined) {
            medicos[idmedico].clientIds.forEach(function (socketId) {

                if (io.sockets.connected[socketId] != undefined) {
			console.log("socket entonctraedo", socketId);
                    io.sockets.connected[socketId].emit(msg_type, msg);
                }
            });
        }
}


    }

    /**Funcion que emite un mensaje 'msg' de tipo 'evento' al todos los sockets que tiene el medico
     *
     * @param {type} idpaciente_msg del paciente al que se genera el evento
     * @param {type} msg_type tipo de mensaje emitido
     * @param {type} msg mensaje que se emite
     * @returns {undefined}
     */
    function emit_sockets_paciente(idpaciente_msg, msg_type, msg) {

        //me fijo si es paciente familiar o titular
        if (familiares[idpaciente_msg] != undefined) {


            var idpaciente = familiares[idpaciente_msg];
            msg.idpaciente = idpaciente_msg;
        } else {
            //si es titular se identifica como 'self'

            var idpaciente = idpaciente_msg;
            msg.idpaciente = 'self';
        }
        if (pacientes[idpaciente] != undefined) {
            pacientes[idpaciente].clientIds.forEach(function (socketId) {
                if (io.sockets.connected[socketId] != undefined) {

                    io.sockets.connected[socketId].emit(msg_type, msg);
                }


            });
        }
    }


    /**Funcion que emite un mensaje 'msg' de tipo 'evento' al todos los sockets que tiene el los medicos de la especialidad
     *
     * @param {type} idmedico medico del cual se obtienen los sockets
     * @param {type} msg_type tipo de mensaje emitido
     * @param {type} msg mensaje que se emite
     * @returns {undefined}
     */
    function emit_sockets_medico_especialidad(idespecialidad, msg_type, msg) {

        if (especialidades[idespecialidad] != undefined) {
          especialidades[idespecialidad].forEach(function (idmedico) {
			  console.log("emitiendo socket a medico "+idmedico+" de especialidad:"+idespecialidad )
                               emit_sockets_medico(idmedico, msg_type, msg)

            });
        }

    }


    /**
     * Evento disparado al conectarse un medico, que almacena la informacion del mismo
     */

    function storeMedicoInfo(data) {


        /*Guardamos la informacion del socket y a que tipo de usuario corresponde*/
        var idmedico = data.idmedico;

        var clientInfo = new Object();
        clientInfo.tipo_usuario = "medico";
        clientInfo.idmedico = idmedico;

        conexiones[socket.id] = clientInfo;

        /*Agregamos el medico al listado de medicos*/
        /*verificamos si ya existe, agregamos el socketId al listado de sockets que posee el medico actualmente*/
        if (medicos[idmedico] != undefined) {
            medicos[idmedico].clientIds.push(socket.id);
        } else {
            /*si no existe el medico creamos el objeto del medico en el listado*/
            var medicoInfo = new Object();
            medicoInfo.idusuarioweb = data.idusuarioweb;
            medicoInfo.idmedico = idmedico;
            medicoInfo.clientIds = [socket.id];
            medicos[idmedico] = medicoInfo;

        }
		/*Agregamos el medico al listado de especialides conectadas*/
		if(data.idespecialidad!=undefined){
			var idespecialidad=data.idespecialidad;

		if(especialidades[idespecialidad]!=undefined){

		if(especialidades[idespecialidad].indexOf(idmedico)<0){
			especialidades[idespecialidad].push(idmedico);
		}


		}else{
			/*si no existen medicos en la especialid creamos el objeto de la especialidad con el medico en el listado*/
         especialidades[idespecialidad]=[idmedico];

		}

		}



    }

    /**
     * Evento disparado al conectarse un paciente, que almacena la informacion del mismo
     */
    function storePacienteInfo(data) {

        /*Guardamos la informacion del socket y a que tipo de usuario corresponde*/
        var idpaciente = data.idpaciente;
        var clientInfo = new Object();
        clientInfo.tipo_usuario = "paciente";
        clientInfo.idpaciente = idpaciente;

        conexiones[socket.id] = clientInfo;

        /*Agregamos el paciente al listado de pacientes*/
        /*verificamos si ya existe, agregamos el socketId al listado de sockets que posee el paciente actualmente*/
        if (pacientes[idpaciente] != undefined) {
            pacientes[idpaciente].clientIds.push(socket.id);
        } else {
            /*si no existe el paciente creamos el objeto del paciente en el listado*/
            var pacienteInfo = new Object();
            pacienteInfo.idusuarioweb = data.idusuarioweb;
            pacienteInfo.idpaciente = idpaciente;
            pacienteInfo.clientIds = [socket.id];
            pacientes[idpaciente] = pacienteInfo;

        }
        /*Agregamos los familiares del paciente al listado de 'familiares'*/
        storeFamiliaresInfo(idpaciente);

    }
    /**Funcion que recupera los pacientes del grupo familiar cuando se conecta un paciente  a partir de su idpaciente y los almacena
     * en un listado 'familiares'.
     * Se guarda la relacion entre el familiar y el paciete titular de la cuenta logueada.
     * Este arreglo se utiliza para recuperar los sockets del paciente titular almacenados en el listado 'pacientes',
     * entonces cuando ocurra un evento asociado a un paciente familiar o titular se obtienen los sockets para notificar el evento
     *
     *
     * @returns {undefined}
     */
    function storeFamiliaresInfo(idpaciente) {
        if (idpaciente != undefined) {


            var query_str = "select pacienteGrupo from pacientegrupofamiliar where pacienteTitular=?";
            db.query(query_str, [idpaciente], function (err, rows) {
                if (err) {
                    throw err;
                }
                rows.forEach(function (familiar) {
                    //guardo el familiar y a que paciente pertenece
                    familiares[familiar.pacienteGrupo] = idpaciente;
                });

            });

        }
    }
});
/**Funcion que toma el array de DataRowPacket y lo pasa a un objeto que contiene el campo 'rows' con este array
 *
 * @param {type} rows
 * @returns {rowsToObject.result|Object}
 */
function rowsToObject(rows) {
    var result = new Object();
    var result_rows = [];
    rows.forEach(function (row) {
        result_rows.push(row);

    });
    result.rows = result_rows;
    return result;
}
