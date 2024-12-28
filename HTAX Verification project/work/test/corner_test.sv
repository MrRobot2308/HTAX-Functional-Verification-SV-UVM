///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class corner_test extends base_test;

	`uvm_component_utils(corner_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", corner_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting Random test",UVM_NONE)
	endtask : run_phase

endclass : corner_test



///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class corner_vsequence extends htax_base_vseq;

	`uvm_object_utils(corner_vsequence)

	int dlen[2] = {3, 63};
	rand int index;

	function new (string name = "corner_vsequence");
		super.new(name);
	endfunction : new

	task body();
			// Exectuing 10 TXNs on ports {0,1,2,3} randomly 
		repeat(500) begin
		// port = $urandom_range(0,3);
			index = $urandom_range(0, 1);			
			`uvm_do_on_with(req, p_sequencer.htax_seqr[0], {req.length == dlen[index];} );
			`uvm_do_on_with(req, p_sequencer.htax_seqr[1], {req.length == dlen[index];} );
			`uvm_do_on_with(req, p_sequencer.htax_seqr[2], {req.length == dlen[index];} );
			`uvm_do_on_with(req, p_sequencer.htax_seqr[3], {req.length == dlen[index];} );			
		end
	endtask : body

endclass : corner_vsequence