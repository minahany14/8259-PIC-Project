module RWModule (input rd ,wr,A0,cs,[7:0]isr ,irr,imr ,inout [7:0]D ,output  reg[7:0]datatologic,reg[4:1]ICWs,reg[3:1]OCWs);

  reg[7:0] txtocpu ,rxfromcpu; 

  localparam icw1 = 1 , icw2 = 2 ,icw3=3 , icw4=4 ,ocw1=1,ocw2=2,ocw3=3;
  reg [4:1]icflag= 4'b1111;
  always@(wr or cs)begin
    
    if(~wr && ~cs)begin
      rxfromcpu = D;     //ehtemal tehtag always lwahdaha
      OCWs = 0;
      ICWs = 0;
    if(icflag != 0 )begin
      
      
      if(A0 == 0 && rxfromcpu[4]==1 && icflag[icw1]==1)begin
        datatologic = rxfromcpu;
        ICWs[icw1]=1;
        icflag[icw1] = 0;
        icflag[icw4] = rxfromcpu[0];
        icflag[icw3] = ~rxfromcpu[1];
      end
    else if (A0 == 1 )begin
        if(icflag[icw2:icw1]==2'b10)begin
          datatologic = rxfromcpu;
          ICWs[icw2] = 1;
          icflag[icw2] = 0;
        end 
        else if(icflag[icw3 :icw1]==3'b100)begin
          datatologic = rxfromcpu;
          ICWs[icw3] = 1;
          icflag[icw3] = 0;
        end
        else if(icflag[icw4 :icw1]==4'b1000)begin
          datatologic = rxfromcpu;
          ICWs[icw4] = 1;
          icflag[icw4] = 0;
        end
        end 
      end
      else begin 
        if(A0 == 1)begin
          //ocw2
          OCWs[ocw1] = 1;
          datatologic = rxfromcpu;
         end
         else if(A0 ==0 && D[4:3]==0)begin
          //ocw2
          OCWs[ocw2] = 1;
          datatologic =  rxfromcpu;
         end
         else if(A0 ==0 && D[4:3]==2'b01 &&D[7]==0)begin
          //ocw3
          OCWs[ocw3] = 1;
          datatologic = rxfromcpu;
         end
      end
    end
    
    
  end

  //write to cpu :
  assign D = (~rd && ~cs )?txtocpu:8'bZ;
  always @ (isr)begin
    txtocpu <=isr;
  end 
  always @(irr)begin
    txtocpu = irr;
  end
  always@(imr)begin
    txtocpu = imr;
  end

  
  
  endmodule

