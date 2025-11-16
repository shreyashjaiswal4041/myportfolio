# auto_sdc.tcl
# Automatically generate an SDC file

puts "Enter clock name:"
flush stdout
gets stdin clk_name

puts "Enter clock port:"
flush stdout
gets stdin clk_port

puts "Enter clock period (ns):"
flush stdout
gets stdin clk_period

puts "Enter comma-separated input ports (e.g., A,B,C,D):"
flush stdout
gets stdin in_ports_raw

puts "Enter comma-separated output ports (e.g., Y,Z):"
flush stdout
gets stdin out_ports_raw

# Convert comma-separated list into Tcl list
set input_ports  [split $in_ports_raw ","]
set output_ports [split $out_ports_raw ","]

# Create SDC file
set fd [open "constraints.sdc" w]

# Create clock
puts $fd "create_clock -name $clk_name -period $clk_period \[get_ports $clk_port\]"

# Input delays (50% of clock period)
set in_delay   [expr {$clk_period * 0.5}]
set in_drive   "INVX1"

foreach p $input_ports {
    puts $fd "set_input_delay $in_delay -clock $clk_name \[get_ports $p\]"
    puts $fd "set_driving_cell -lib_cell $in_drive \[get_ports $p\]"
}

# Output delays (20% of clock period)
set out_delay [expr {$clk_period * 0.2}]
set out_load  0.05

foreach p $output_ports {
    puts $fd "set_output_delay $out_delay -clock $clk_name \[get_ports $p\]"
    puts $fd "set_load $out_load \[get_ports $p\]"
}

close $fd

puts "======================================="
puts "SDC generated successfully: constraints.sdc"
puts "======================================="
