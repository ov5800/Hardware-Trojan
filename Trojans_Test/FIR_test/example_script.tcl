create_project example_project ./example -part xc7s15csga225-1Q
set_property simulator_language Verilog [current_project]
add_files -norecurse ./des3_T1.v
update_compile_order -fileset sources_1
set_property STEPS.SYNTH_DESIGN.ARGS.FLATTEN_HIERARCHY full [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.BUFG 0 [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.FSM_EXTRACTION off [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.KEEP_EQUIVALENT_REGISTERS true [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.NO_LC true [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.NO_SRLEXTRACT true [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.SHREG_MIN_SIZE 0 [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.MAX_BRAM 0 [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.MAX_URAM 0 [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.MAX_DSP 0 [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.MAX_BRAM_CASCADE_HEIGHT 0 [get_runs synth_1]
set_property STEPS.SYNTH_DESIGN.ARGS.MAX_URAM_CASCADE_HEIGHT 0 [get_runs synth_1]
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]
launch_runs synth_1 -jobs 8
after 70000
open_run synth_1 -name synth_1
create_clock -period 50.000 -name clk -waveform {0.000 25.000} [get_ports clk]
set_input_delay -clock clk 0 [all_inputs]
set_output_delay -clock clk 0 [all_outputs]
set_delay_model -interconnect estimated
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 5000 -nworst 10 -input_pins -routable_nets -file ./des3_T1_timing_zero.txt
reset_timing
create_clock -period 50.000 -name clk -waveform {0.000 25.000} [get_ports clk]
set_input_delay -clock clk 12.5 [all_inputs]
set_output_delay -clock clk 12.5 [all_outputs]
set_delay_model -interconnect estimated
report_timing_summary -delay_type min_max -report_unconstrained -check_timing_verbose -max_paths 5000 -nworst 10 -input_pins -routable_nets -file ./des3_T1_timing_est.txt
set_switching_activity -default_toggle_rate 0.5
report_power -file {./des3_T1_power.txt}
report_utilization -file ./des3_T1_utilization.txt
close_project
