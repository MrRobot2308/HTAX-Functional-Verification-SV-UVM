///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////


class random_test extends base_test;

	`uvm_component_utils(random_test)

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		uvm_config_wrapper::set(this,"tb.vsequencer.run_phase", "default_sequence", random_vsequence::type_id::get());
		super.build_phase(phase);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		super.run_phase(phase);
		`uvm_info(get_type_name(),"Starting Random test",UVM_NONE)
	endtask : run_phase

endclass : random_test



///////////////////////////// VIRTUAL SEQUENCE ///////////////////////////


class random_vsequence extends htax_base_vseq;

	`uvm_object_utils(random_vsequence)

	htax_packet_c pkt0;
	htax_packet_c pkt1;
	htax_packet_c pkt2;
	htax_packet_c pkt3;

	function new (string name = "random_vsequence");
		super.new(name);		
		pkt0 = new();
		pkt1 = new();
		pkt2 = new();
		pkt3 = new();
	endfunction : new


	int port[4] = {0, 1, 2 ,3};
	
	task body();
	repeat(500) begin
		for (int j = 0; j < 4; j++) begin
		// Shuffle ports before assigning them
		foreach (port[i]) begin
			int rand_idx = $urandom_range(3, i); // Random index between i and 3
			int temp = port[i];
			port[i] = port[rand_idx];
			port[rand_idx] = temp;
		end

		// Fork and send packets with randomized ports
		fork
			`uvm_do_on_with(pkt0, p_sequencer.htax_seqr[port[0]], {pkt0.dest_port == port[0]; pkt0.length inside {[3:10]}; pkt0.delay < 5;})
			`uvm_do_on_with(pkt1, p_sequencer.htax_seqr[port[1]], {pkt1.dest_port == port[1]; pkt1.length inside {[3:10]}; pkt1.delay < 5;})
			`uvm_do_on_with(pkt2, p_sequencer.htax_seqr[port[2]], {pkt2.dest_port == port[2]; pkt2.length inside {[3:10]}; pkt2.delay < 5;})
			`uvm_do_on_with(pkt3, p_sequencer.htax_seqr[port[3]], {pkt3.dest_port == port[3]; pkt3.length inside {[3:10]}; pkt3.delay < 5;})
		join
		end
	end
	endtask : body

endclass : random_vsequence