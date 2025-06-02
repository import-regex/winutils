$files = Get-ChildItem *.wav
$inputs = foreach ($f in $files) { '-i'; $f.Name }
$file_count = $files.Count
$ratios=($files | foreach{ "["+($i++)+":0]"}) -join ""
$args = $inputs + '-filter_complex' + "${ratios}concat=n=${file_count}:v=0:a=1[out]" + '-map' + '[out]' + 'output.wav'
ffmpeg @args

#ffmpeg -i '01-AudioTrack 01.wav' -i '02-AudioTrack 02.wav' -filter_complex '[0:0][1:0]concat=n=2:v=0:a=1[out]' -map '[out]' output.wav

#ffmpeg -i input1.wav -i input2.wav -i input3.wav -i input4.wav \
#-filter_complex '[0:0][1:0][2:0][3:0]concat=n=4:v=0:a=1[out]' \
#-map '[out]' output.wav

#-i nput is a verbose list of files
#filter complex [0:0]..[n:0] , where n is the num of files
#concat=n=4 is the number of files