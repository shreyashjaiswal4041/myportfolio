############################################################
# UNIFIED SYNOPSYS REPORT → CSV CONVERTER
# Takes multiple DC reports and consolidates into ONE CSV
#to run dc_shell -f convert_all_reports.tcl
############################################################

# Enable report access (checks if required reports exist)
foreach rpt {timing.rpt area.rpt power_no_saif.rpt power_saif.rpt} {
    if {![file exists $rpt]} {
        puts "ERROR: Missing report → $rpt"
        exit
    }
}

# Helper procedure to read a value from file by matching a keyword
proc extract_value {filename keyword} {
    set fp [open $filename r]
    set data ""
    while {[gets $fp line] >= 0} {
        if {[string match "*$keyword*" $line]} {
            # extract last numeric word in the line
            regexp {([0-9]+(\.[0-9]+)?)$} $line match data
            break
        }
    }
    close $fp
    return $data
}

############################################################
# Extract Data From Reports
############################################################

# Timing
set wns   [extract_value "timing.rpt" "slack"]
set tns   [extract_value "timing.rpt" "tns"]
set fep   [extract_value "timing.rpt" "path"]

# Area
set total_area [extract_value "area.rpt" "Total cell area"]

# Power without SAIF
set int_no_saif  [extract_value "power_no_saif.rpt" "Internal power"]
set sw_no_saif   [extract_value "power_no_saif.rpt" "Switching power"]
set leak_no_saif [extract_value "power_no_saif.rpt" "Leakage power"]
set tot_no_saif  [extract_value "power_no_saif.rpt" "Total"]

# Power with SAIF
set int_saif  [extract_value "power_saif.rpt" "Internal power"]
set sw_saif   [extract_value "power_saif.rpt" "Switching power"]
set leak_saif [extract_value "power_saif.rpt" "Leakage power"]
set tot_saif  [extract_value "power_saif.rpt" "Total"]

############################################################
# Write to CSV
############################################################

set out [open "final_report.csv" w]

puts $out "Metric,Value"
puts $out "Worst Negative Slack (WNS),$wns"
puts $out "Total Negative Slack (TNS),$tns"
puts $out "Failing Endpoints,$fep"

puts $out "Total Cell Area,$total_area"

puts $out "Internal Power (no SAIF),$int_no_saif"
puts $out "Switching Power (no SAIF),$sw_no_saif"
puts $out "Leakage Power (no SAIF),$leak_no_saif"
puts $out "Total Power (no SAIF),$tot_no_saif"

puts $out "Internal Power (SAIF),$int_saif"
puts $out "Switching Power (SAIF),$sw_saif"
puts $out "Leakage Power (SAIF),$leak_saif"
puts $out "Total Power (SAIF),$tot_saif"

close $out

puts "=== Combined CSV Generated: final_report.csv ==="
