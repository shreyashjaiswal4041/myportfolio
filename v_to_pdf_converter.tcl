##########################################################
###################################################################################################
# Verilog to PDF Converter (Cross-Platform for macOS/Linux)
# Converts all .v files in the current directory to PDFs
############################################################

# ---------------------------
# Helper: Detect available PDF converter
# ---------------------------
set pdf_converter ""
if {[catch {exec which ps2pdf} result]} {
    if {[catch {exec which ps2pdfwr} result2]} {
        puts "Error: Neither ps2pdf nor ps2pdfwr found. Install Ghostscript."
        exit
    } else {
        set pdf_converter "ps2pdfwr"
    }
} else {
    set pdf_converter "ps2pdf"
}

puts "Using PDF converter: $pdf_converter"

# ---------------------------
# Get all .v files
# ---------------------------
set v_files [glob *.v]

if {[llength $v_files] == 0} {
    puts "No Verilog (.v) files found in current directory."
    exit
}

# ---------------------------
# Convert each .v file to PDF
# ---------------------------
foreach vf $v_files {
    set base [file rootname $vf]
    set pdf_file "${base}.pdf"
    
    # Command to convert text to PostScript then to PDF
    set cmd "enscript -B -f Courier10 $vf -o - | $pdf_converter - $pdf_file"

    if {[catch {exec sh -c $cmd} err]} {
        puts "Error converting $vf: $err"
    } else {
        puts "Converted $vf → $pdf_file"
    }
}

puts "=== All Verilog files converted to PDFs successfully ==="
