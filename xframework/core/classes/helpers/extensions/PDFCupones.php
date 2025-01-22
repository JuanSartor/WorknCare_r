<?php

require_once(path_libs("libs_php/fpdf/fpdf.php"));

class PDFCupones extends FPDF{
	
	
    function __construct(){
        parent::__construct('P', 'mm', 'A4');
        $this->SetMargins(5,5);
        $this->SetAutoPageBreak(false);
    }
    
	
	public function getCupones($cupones , $file= NULL)  {
        
        $this->SetDisplayMode("real");	
        
		$this->doCupones($cupones);
                
		if (is_null($file)){
            $this->Output("cupones-".date("Y-m-d").".pdf","I");    
        }else{
            @$this->Output($file,"F");
        }
				
		
	}
    
    
    private function doCupones($cupones){

        //primer pagina datos de la grilla
		$this->AddPage();
        
        $this->SetLineWidth(0.1);
        $this->SetDash(0.8, 0.8);

        
        $this->AddFont('OleoScriptSwashCaps-Regular','','OleoScriptSwashCaps-Regular.php');
        $this->AddFont('TitilliumWeb-Regular','','TitilliumWeb-Regular.php');
        $this->AddFont('TitilliumWeb-Bold','B','TitilliumWeb-Bold.php');
        //$this->AddFont('trebuc','BI','trebucbi.php');
        

 
        
        
        $x_start =  5;
        $y_start = 40;        
        
        $h = 70;
        
        $i = 0;
        
        $this->SetXY($x_start,$y_start);  

        
        
        foreach ($cupones AS $key=>$cupon) {
            
            
            if ($cupon["tipo"] == 1){
                $valor = $cupon["valor"]." % descuento";
            }else{
                $valor = "$ ".$cupon["valor"];
            }
            
            $this->SetTextColor(217,1,1);
            
            $this->SetFont('OleoScriptSwashCaps-Regular','',29);
            
            $this->cell(100,20,$valor,0,0,'C');
            
            $this->SetXY($x_start,$y_start+20);
            
            $this->SetTextColor(50,60,66);
            
            $this->SetFont('TitilliumWeb-Bold','B',16);
            
            $this->cell(100,8,"C�digo: ".$cupon["cupon"],0,0,'C');

            $this->SetXY($x_start,$y_start+28);
            
            $this->SetFont('TitilliumWeb-Regular','',7);
            
            list($anio,$mes,$dia) = explode("-", $cupon["fecha_vencimiento"]);
            
            $this->cell(100,5,"V�lido hasta el $dia de ".getNombreMes($mes)." de $anio",0,0,'C');

            
            $i++;
            
            if ($i % 8 == 0){
                $this->AddPage();                
                $x_start =  5;
                $y_start = 40;                
            }else{
                if ($i % 2 == 0){
                    $x_start = 5;
                    $y_start+=$h;
                }else{
                  $x_start+=100;
                }
            }
            
            $this->SetXY($x_start,$y_start);  	
        }          
        

    
    
    }

    private function SetDash($black=false, $white=false){
        if($black and $white)
            $s=sprintf('[%.3f %.3f] 0 d', $black*$this->k, $white*$this->k);
        else
            $s='[] 0 d';
        $this->_out($s);
    }    
	
	
	
}

?>
