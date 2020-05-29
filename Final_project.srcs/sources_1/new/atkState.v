`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Apple
// Engineer: Thanapat Sanguansab
// 
// Create Date: 05/26/2020 10:33:11 PM
// Design Name: 
// Module Name: atkState
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module atkState(
     input clk
    ,input game_clk
    ,input [4:0] direction
    ,input state
    ,input [2:0] monster
    ,output reset
    ,output [9:0] xPlayer
    ,output [9:0] yPlayer
    ,output [6:0] hpPlayer
	,output [6:0] hpMonster
    );
    reg [9:0] xCurrent;
    reg [9:0] yCurrent;
    reg [6:0] VhpMonster;
    reg left_right;
    reg stop;
    //reg state = 1;
    wire [6:0] damage; 
    
    initial begin 
        xCurrent = 320;
        yCurrent = 393;
        stop = 0;
        left_right = 1; //right
        VhpMonster = 100; //min 0 max 100
    end
    
    assign xPlayer = xCurrent;
    assign yPlayer = yCurrent;
    assign hpMonster = VhpMonster;
    
    damageCompute dc(
                    .game_clk(game_clk),
                    .xCurrent(xCurrent),
                    .monster(monster),
                    .damage(damage)
                    );
    always @(state)
        begin
            if (state) begin 
            //stop =0; 
            end
        end  
    always @(direction)
        begin
        if (state)begin
            case(direction)
            5'b10000: begin
                xCurrent = xCurrent;//Spacebar  , attack
                
                //stop = 1;
                if ((VhpMonster <= damage) && (!stop)) begin VhpMonster = 10; //win
                    // TODO: reset VhpMonster after 1 sec -> VhpMonster = 100;
                    // TODO: change state to map
                    
                end
                else if ((VhpMonster > damage) && (!stop))begin 
                    VhpMonster = VhpMonster - damage;
                    
                    // TODO: change state to defState
                    end;
                stop = 1;
                end   
                
            endcase
        end
    end
    
    always @(posedge game_clk)
        begin
        if (state) begin
        if (!stop)
            begin
                if (left_right == 1)//right
                    begin 
                        xCurrent <= xCurrent+1;
                        if (xCurrent >= 544)
                            begin
                                left_right = 0; //left
                            end
                    end
                else if (left_right == 0) //left
                    begin
                        xCurrent <= xCurrent-1;
                        if (xCurrent <= 96)
                            begin
                                left_right = 1; //right
                            end
                    end
            end
        end
        end

endmodule
