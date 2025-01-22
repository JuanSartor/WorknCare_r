
<body style="margin:0;padding:0">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-collapse:collapse">

        <tr>
            <td bgcolor="#F7F7F7" style="padding: 24px 0; background-color: #3DB9C6; position: relative; width: 800px; height: 800px;">

                <table width="600" align="center" border="0" valign="top" cellpadding="16" cellspacing="0" style="border-collapse:collapse">
                    <tr>
                        <td><img src="{$IMGS}logo_workncare_blanco.png" alt="WorknCare" style="border:none; position: relative; left: 200px; z-index: 1000; "/></td>

                    </tr>
                </table>
            <!--    <div style="background-image: url({$IMGS}email_ganador.png); width: 990px; height: 900px; transform: scale(0.7); position: absolute; left: -120px; z-index: 1; top: -40px;">
                </div>  -->
                <table width="600" align="center" bgcolor="#ffffff"  border="0" valign="top" cellpadding="12" cellspacing="0" style="border-collapse:collapse; background: white; height: 550px;">
                    <tr>

                        <td style="z-index: 1000; position: absolute;">
                            <div style="margin-left: 45px;">
                                <img style="height: 180px;" src="{$IMGS}banner_izq.jpg" >
                                <img style="height: 180px;" src="{$IMGS}banner_der.jpg" >
                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td style="z-index: 1000; position: relative; top: 100px;">
                            <hr>
                            <p style="color:#000000; font-size:17px; font-family:'Helvetica', Arial, sans-serif; font-weight:500"><span style="color:#000000; font-size:18px">Félicitations {$usuario.nombre} {$usuario.apellido}</span></p>
                            <p style="color:#ED799E; font-size: 26px; top: 10px; position: relative; font-weight: 600; font-family:'Helvetica', Arial, sans-serif">
                                Vous avez gagné!
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td style="z-index: 1000; position: relative; top: 20px;">
                            <p style="color:#000000; font-size:20px; font-family:'Helvetica', Arial, sans-serif">
                                Veuillez vous connecter a votre compte pour utiliser la prestation qui vous est offerte.
                            </p>
                        </td>
                    </tr>
                    <tr>
                        <td style="z-index: 1000; position: relative; text-align: center;">
                            <a href="{$url}" target="_blank" style="padding: 8px 10px; color: #fff; background-color: #ED799E; text-decoration: none; border-radius: 4px;">www.workncare.io</a>

                        </td>
                    </tr>

                </table>


                <table width="600" align="center" border="0" valign="top" cellpadding="0" cellspacing="0" style="border-collapse:collapse">
                    <tr style="z-index: 1000; position: relative; top: 20px;">
                        <td align="center">
                            <p style="color:#000000; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center">Copyright &copy; {$smarty.now|date_format:"%Y"} WorknCare | All rights reserved.</p>
                        </td>

                    </tr>
                    <tr style="z-index: 1000; position: relative; top: 20px;">
                        <td style="z-index: 1000; position: relative;">
                            <p style="color:#000000; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center; line-height:14px">
                                Our mailing address is
                            </p>
                        </td>
                    </tr>
                    <tr style="z-index: 1000; position: relative;">
                        <td style="z-index: 1000; position: relative;">
                            <p style="color:#000000; font-size:12px; font-family:'Helvetica', Arial, sans-serif; text-align:center; line-height:14px">
                                <a style="text-decoration:underline; line-height:14px; color:#000000; font-weight:bold" class="rsp-lnk" href="mailto:support@workncare.io">support@workncare.io</a> 
                            </p>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

    </table>
    {literal}
        <style type="text/css">
            @media only screen and (max-width: 600px), screen and (max-device-width: 600px){
                table{
                    width:100%;
                }
                .rsp-img{
                    display: block;
                    width: 100%;
                }
                .rsp-lnk{
                    word-break: break-all;
                    line-height: 18px !important;
                    display: block;
                    padding-top: 12px;
                }
            }
        </style>
    {/literal}
</body>