class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets

// ****************Yapp_1 seq***********************

class yapp_1_packets extends yapp_base_seq;

`uvm_object_utils(yapp_1_packets)

  // Constructor
  function new(string name="yapp_1_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_packets sequence", UVM_LOW)
    //  repeat(5)
      `uvm_do_with (req, {addr == 1;})
  endtask

endclass: yapp_1_packets

// *****************************Yapp_012 seq***************************************

class yapp_012_packets extends yapp_base_seq;

`uvm_object_utils(yapp_012_packets)

  // Constructor
  function new(string name="yapp_012_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_012_packets sequence", UVM_LOW)
    //  repeat(5)
      `uvm_do_with (req, {addr == 0;})
      `uvm_do_with (req, {addr == 1;})
      `uvm_do_with (req, {addr == 2;})
  endtask

endclass: yapp_012_packets

// *****************************Yapp_111_seq***************************************

class yapp_111_packets extends yapp_base_seq;

`uvm_object_utils(yapp_111_packets)
  yapp_1_packets seq1;
  function new(string name="yapp_111_packets");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_packets sequence", UVM_LOW)
    repeat(3)
      `uvm_do(seq1)
  endtask

endclass: yapp_111_packets

// *****************************yapp_repeat_addr_packets***************************************

class yapp_repeat_addr_packets extends yapp_base_seq;

`uvm_object_utils(yapp_repeat_addr_packets)
  
  rand bit [1:0] prev_addr;

  constraint valid_addr {prev_addr != 3;}

  function new(string name="yapp_repeat_addr_packets");
    super.new(name);
  endfunction

  virtual task body();
  if(!this.randomize()) `uvm_fatal(get_type_name(), "Randomization failed for yapp_repeat_addr_packets")
    `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq: Two packets to the same random address (not 3)", UVM_LOW)
//    repeat(3)
      `uvm_do_with(req, {addr == prev_addr;})
      //`uvm_do_with(req, {addr == prev_addr;})

  endtask

endclass: yapp_repeat_addr_packets


// *****************************Yapp_incr_payload_seq***************************************

class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)
  yapp_1_packets seq1;

  function new(string name="yapp_incr_payload_seq");
    super.new(name);
  endfunction


  virtual task body();
  `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)

  `uvm_create(req)

  assert(req.randomize());

  foreach (req.payload[i]) begin
    req.payload[i] = i;
  end

  req.set_parity(); 

  `uvm_send(req)
  endtask


endclass: yapp_incr_payload_seq 





