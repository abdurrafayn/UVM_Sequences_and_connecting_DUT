class yapp_tx_monitor extends uvm_monitor;

virtual yapp_if vif;

`uvm_component_utils(yapp_tx_monitor)

function new(string name = "yapp_tx_monitor", uvm_component parent = null);
    super.new(name,parent);
endfunction


function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "Running Simulation in Monitor class", UVM_HIGH);
        
    endfunction


    yapp_packet pkt;

  // Count packets collected
  int num_pkt_col;

  // UVM run() phase
  task run_phase(uvm_phase phase);
    `uvm_info(get_type_name(), "Running Simulation in Monitor class", UVM_HIGH);
    // Look for packets after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      pkt = yapp_packet::type_id::create("pkt", this);

      // concurrent blocks for packet collection and transaction recording
      fork
        // collect packet
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      join

      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(pkt);
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      num_pkt_col++;
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

  function void connect_phase(uvm_phase phase);
    if (!yapp_vif_config::get(this,"","vif", vif))
        `uvm_fatal("NOVIF","vif not set")
  endfunction

endclass




