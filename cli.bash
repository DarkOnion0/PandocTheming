while getopts f:s:o: flag
do
    case "${flag}" in
        f) file=${OPTARG};;
        s) style=${OPTARG};;
        o) orientation=${OPTARG};;
    esac
done


pandoc $(echo $file) -t html --pdf-engine weasyprint --css @styleDir@/css/style-$(echo $orientation).css $(echo $style) --template @templateDir@/default.html --katex -o $(echo $file | sed 's/.md/.pdf/g')
