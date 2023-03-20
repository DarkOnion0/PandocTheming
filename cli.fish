#!/usr/bin/env fish

# Define the available CMD flag
set --local options 'h/help' 'f/file=' 's/style=' 'o/orientation='

# Parse the CMD flag
argparse $options -- $argv

# Take action according to the provdided CMD flags

if set --query _flag_help
  printf "Usage: [OPTIONS]\n\n"
  printf "Options:\n"
  printf "  -h/--help                       Prints help and exits\n"
  printf "  -f/--file                       Get a markdown file to convert to PDF\n"
  printf "  -s/--style                      Set some style overrides, /!\\ Be aware that this will make the style less reproductible /!\\ \n"
  printf "  -o/--orientatation-portrait     Set the output pdf orientation, (portrait)/landscape\n"
  return 0
end

if set --query _flag_file
    #set should_run "true"
    printf "File: %s\n" $_flag_file
    #cat $_flag_file
else
    set _flag_file "./texte.md"
end 

if set --query _flag_style
    #set should_run "true"
    printf "Style: %s\n" $_flag_style
end

if set --query _flag_orientation
    #set should_run "true"
    printf "Page orientation: %s\n" $_flag_orientation
else
    #set should_run "true"
    set _flag_orientation "portrait"
    #printf "%s\n" $_flag_orientation
end

# Run the parser

pandoc $_flag_file -t html --pdf-engine weasyprint --css @styleDir@/css/style-$_flag_orientation.css --css $_flag_style --template @templateDir@/default.html --katex -o (printf $_flag_file | sed 's/.md/.pdf/g')
