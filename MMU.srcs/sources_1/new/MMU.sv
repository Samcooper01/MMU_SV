
module MMU(
    input clk,
    input rst_n,
    input logic [15:0] MMU_rx_data,
    input logic [15:0] MMU_addr,
    input logic MMU_get,
    input logic MMU_set,
    output logic MMU_rdy,
    output logic [15:0] MMU_tx_data
    );
    
    always_comb begin
       if(MMU_get == 1) begin
            MMU_tx_data = data_array[MMU_addr];
            MMU_rdy = 1;
       end else if (MMU_set == 1) begin
            data_array[MMU_addr] = MMU_rx_data;
            $display("data_array[MMU_addr]: %b", data_array[MMU_addr]);
            MMU_rdy = 1;
       end
       else begin
            MMU_rdy = 0;
       end
    end
    

    always @(posedge MMU_get) begin
        open_file_for_read_and_store();
    end
    
    always @(negedge MMU_get) begin
        just_close();
    end
    
/*
   always @(posedge MMU_set) begin
        open_and_read_for_write();
    end
    
    always @(negedge MMU_set) begin
        if(MMU_get == 0) begin
            rewrite_and_close_file();
        end
    end
*/
    
    // Parameters for array dimensions
    parameter NUM_LINES = 200; // Adjust based on the number of lines in your file
    parameter BIT_WIDTH = 16; // Width of the binary number in the second column

    // Variables for file handling
    integer file_handle;
    string line;
    string second_column;
    integer status;
    integer i;

    // Declare a 2D array to store the binary numbers
    reg [BIT_WIDTH-1:0] data_array [NUM_LINES-1:0];
    
    task open_file_for_read_and_store();
            // Initialize index
        i = 0;

        // Open the file in read mode ("r")
        file_handle = $fopen("memory.EEPROM", "r");
        
        // Check if the file was opened successfully
        if (file_handle == 0) begin
            $display("Error: Unable to open file!");
            $finish;
        end
        
        // Read the file line by line and store the second column in the array
        while (!$feof(file_handle)) begin
            // Use fgets to get each line
            status = $fgets(line, file_handle);
            
            // Parse the line to extract the second column
            status = $sscanf(line, "%*s %s", second_column);
            
            // Convert the string to a bit vector and store it in the 2D array
            if (i < NUM_LINES) begin
                // Initialize to zero
                data_array[i] = 'b0;
                for (int j = 0; j < BIT_WIDTH; j++) begin
                    if (second_column[j] == "1") begin
                        data_array[i][BIT_WIDTH-1-j] = 1'b1;
                    end
                end
                i = i + 1;
            end
        end
    endtask
    
    task just_close();
        begin
            $fclose(file_handle);
        end
    endtask
    
    task open_and_read_for_write();
        // Initialize index
        i = 0;

        // Open the file in read mode ("r")
        file_handle = $fopen("memory.EEPROM", "w");
        
        // Check if the file was opened successfully
        if (file_handle == 0) begin
            $display("Error: Unable to open file!");
            $finish;
        end
        
        // Read the file line by line and store the second column in the array
        while (!$feof(file_handle)) begin
            // Use fgets to get each line
            status = $fgets(line, file_handle);
            
            // Parse the line to extract the second column
            status = $sscanf(line, "%*s %s", second_column);
            
            // Convert the string to a bit vector and store it in the 2D array
            if (i < NUM_LINES) begin
                // Initialize to zero
                data_array[i] = 'b0;
                for (int j = 0; j < BIT_WIDTH; j++) begin
                    if (second_column[j] == "1") begin
                        data_array[i][BIT_WIDTH-1-j] = 1'b1;
                    end
                end
                i = i + 1;
            end
        end    
    endtask
    
    task rewrite_and_close_file();
        begin
    
            // Write the contents of the 2D array to the file
            for (i = 0; i < NUM_LINES; i = i + 1) begin
                $fwrite(file_handle, "0x%04X %b\n", i, data_array[i]);
            end
            $fclose(file_handle);
        end
    endtask
endmodule