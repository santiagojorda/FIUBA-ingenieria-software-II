$path = '/' + $PWD.Path -replace '[:]','' -replace '[\\]','/'

docker run -it --rm -p4567:4567 -v ${path}:/workspace registry.gitlab.com/fiuba-memo2/imagen-para-katas:1.9.0 /bin/bash