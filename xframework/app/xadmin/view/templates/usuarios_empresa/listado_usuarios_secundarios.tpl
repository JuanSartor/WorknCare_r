
<div class="title">
    {"Usuarios autorizados"|x_translate}
</div>

<div class="clear">
    &nbsp;
</div>
<div  class="xTable" id="xTable">

    <div class="container">		

        <table id="listado_usuarios_secundarios">
        </table> 

        <div id="pager_usuarios_secundarios"></div>

    </div>     
</div> 

{literal}
    <script>
        $("#listado_usuarios_secundarios").jqGrid({
            url: "xadmin.php?action=1&modulo=usuarios_empresa&submodulo=usuarios_secundarios_list&idempresa=" + $("#idempresa").val(),
            datatype: "json",
            colNames: ['', "Nombre", "Apellido", "Email", "Fecha alta", 'Accesos', "Estado", "Email confirmado","Estado email"],
            colModel: [//"nombre","apellido","email","fecha_alta_format","estado_format"
                {name: 'act', index: 'act', width: 200, sortable: false, align: "center", hidden: false},
                {name: 'nombre', index: 'nombre', width: 100, sortable: true},
                {name: 'apellido', index: 'apellido', width: 100, sortable: true},
                {name: 'email', index: 'email', width: 150, sortable: true},
                {name: 'fecha_alta', index: 'fecha_alta', align: "center", width: 150, sortable: true},
                {name: 'tipo_usuario_format', index: 'tipo_usuario', align: "center", width: 150, sortable: true},
                {name: 'activo', index: 'activo', align: "center", width: 100, sortable: true},
                {name: 'email_confirmado', index: 'estado', align: "center", width: 100, sortable: true},
                {name: 'act_des', index: 'act_des', width: 200, sortable: false, align: "center", hidden: false}
            ],
            rowNum: 100,
            pager: '#pager_usuarios_secundarios',
            sortname: 'fecha_alta',
            viewrecords: true,
            sortorder: "desc",
            caption: "Listado de usuarios",
            page: 1,
            autowidth: false,
            height: '100%',
            multiselect: true,
            loadComplete: function (data) {
                console.log("data", data);
                //$("#cant_usuarios_secundarios").text(data.records);

            },
            gridComplete: function (data) {
                var ids = $("#listado_usuarios_secundarios").jqGrid('getDataIDs');

                for (var i = 0; i < ids.length; i++) {

                    var id = ids[i];

                    be = "<button title=\"Cambiar contraseña\" class='cambiar_contrasenia' data-id=" + id + " >Cambiar contraseña</button>";


                    $("#listado_usuarios_secundarios").jqGrid('setRowData', ids[i], {act: be});
                    
                    
                    
                    
                      
                  var valor_email= $("#listado_usuarios_secundarios").jqGrid('getCell',ids[i],'email_confirmado');
                    
                    if(valor_email=='NO'){
                         btn_act_des = "<button title=\"Activar\" class='activar_desactivar' data-estado='Activar'    data-id=" + id +">Activar</button>";
                    }
                    else{
                           btn_act_des = "<button title=\"Desactivar\" class='activar_desactivar'  data-estado='Desactivar'  data-id=" + id + ">Desactivar</button>";
                    }
                  
                    
            

                    $("#listado_usuarios_secundarios").jqGrid('setRowData', ids[i], {act_des:  btn_act_des});
                    
                    
                    
                    
                    
                }
            }
        });

        $("#listado_usuarios_secundarios").on("click",".cambiar_contrasenia",function (e) {
            e.preventDefault();
            var id= $(this).data("id");
        console.log(id);
                jConfirm(
                        "Desea gener una nueva contraseña y enviarla al usuario?",
                        "Cambiar contraseña",
                        function (r) {
                        if (r) {
                        var url = "xadmin.php?";
                                var queryStr = "action=1&modulo=usuarios_empresa&submodulo=edit_password_usuario&idusuario_empresa=" + id;
                                x_doAjaxCall("POST",
                                        url,
                                        queryStr,
                                        function (data) {

                                        x_alert(data.msg);
                                        },
                                        "",
                                        "",
                                        true,
                                        true);
                        }
                        }
                );
        });
        
        
        
        
           $("#listado_usuarios_secundarios").on("click", ".activar_desactivar", function (e) {
            e.preventDefault();
           var id = $(this).data("id");

               // console.log(id);
           
              var titulo_accion = $(this).data("estado");
            //  console.log(titulo_accion);
            
          
            
            jConfirm(
                    "Desea cambiar el estado del Email",
                    "Cambiar estado Email",
                    function (r) {
                        if (r) {
                            var url = "xadmin.php?";
                            var queryStr = "action=1&modulo=usuarios_empresa&submodulo=editar_estado_email_usuario&idusuario_empresa=" + id + "&accion=" + titulo_accion ;
                            x_doAjaxCall("POST",
                                    url,
                                    queryStr,
                                    function (data) {

                                        x_alert(data.msg);
                                       $('#listado_usuarios_secundarios').trigger("reloadGrid");  
                                    },
                                    "",
                                    "",
                                    true,
                                    true);
                                    
                                    
                                    
                                    
                        }
                        
                    
                    }
            );
        
        });
             
        
        
            
        
        
    </script>
{/literal}
