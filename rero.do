vlib work
vlog -timescale 1ns/1ns rero.v

vsim rero
log {/*}
add wave {/*}


force {wheel_config[0]} 0
force {wheel_config[1]} 0
force {wheel_config[2]} 0

force {rotate1} 0 0, 1 10 -r 20

force {in[12]} 1 0, 0 8 -r 16
run 1000