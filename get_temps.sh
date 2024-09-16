#!/bin/bash

# Function to get the CPU temperature using vcgencmd
get_cpu_temp() {
  /usr/bin/vcgencmd measure_temp | grep -oP '\d+\.\d+'
}

# Array to store temperature readings
temps_5m=()
#temps_15m=()

# Function to collect temperature data for 5 and 15 minutes
collect_temps() {
  local interval=$1
  local -n temps=$2

  for (( i=0; i<$interval*60; i++ )); do
    temp=$(get_cpu_temp)
    temps+=($temp)
    sleep 1
  done
}

# Function to create an ASCII graph using gnuplot
create_graph() {
  local -n temps=$1
  local title=$2
  local filename="temp_data.dat"
  local plot_script="plot_script.plt"

  # Create data file
  printf "%s\n" "${temps[@]}" > $filename

  # Create gnuplot script
  cat << EOF > $plot_script
set terminal dumb size 100, 20
set title "$title"
set xlabel "Time (seconds)"
set ylabel "Temperature (°C)"
plot "$filename" using (\$0):(\$1) with lines title 'CPU Temp'
EOF

  # Run gnuplot script
  gnuplot $plot_script

  # Clean up
  rm $filename $plot_script
}

# Collect temperature data
echo "Collecting temperature data for 5 minutes..."
collect_temps 5 temps_5m

#echo "Collecting temperature data for 15 minutes..."
#collect_temps 15 temps_15m

# Create and display graphs
echo "Creating and displaying graph for 5-minute interval..."
create_graph temps_5m "CPU Temperature over 5 Minutes"

#echo "Creating and displaying graph for 15-minute interval..."
#create_graph temps_15m "CPU Temperature over 15 Minutes"
