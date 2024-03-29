# Dart usage

This folder contains best practices, guides and some utils for Dart which are very useful with SurfGen

# Usage guide

@MbIXjkee TODO

## Exporter (Umbrella header)

By the [bash script ExportModelsGenerator](./ExportModelsGenerator.sh) you can create a file, which will export all DTO (or whatever you want). 

This script has 2 arguments:
1. Path to directory with files which should be exported in umbrella
2. Path to Umbrella file

**How it works**

1. Script remove file by Ubrella path (by second arg)
2. Script reads all files in directory (by first arg)
3. Script extract `filename.ext` from filepathes in the directory
4. Script create new umbrella (by second arg)
5. Script removes file by Umbrella path (by second arg)
6. Script reads all files in directory (by first arg)
7. Script extracts `filename.ext` from filepathes in the directory
8. Script exclude all files with patter `filename.g.dart`
9. Script creates new umbrella (by second arg)
10. Script writes each `filename.ext` with template `export 'filename.ext';` to umbrella


For example lets assume that we have 
```
ExportModelsGenerator.sh
src
 ├── services
 |    └─...
 └── models
        ├── model1.dart
        ├── model2.dart
        ├── model3.dart
        └── model4.dart
```
So we can automatically generate file like
```Dart
export 'model1.dart';
export 'model2.dart';
export 'model3.dart';
export 'model4.dart';
```

Just by command `sh ExportModelsGenerator.sh src/mdoels /src/models/Umbrella.dart

And then we can `import` all models by this file

So you can generate different umrellas by this script

Even so, you can create a `wrapper` on surfgen

Simple example:

```Bash
# cmd args
config=$1
pathToApi=$2
name=$3

exporterPath=$4
pathToUmbrella=$5

# generate code

./surfgen generate -c $config $pathToApi $name

# execute post-gen scripts

sh ExportModelsGenerator.sh $exporterPath $pathToUmbrella
```

and call it 

```Shell
sh surfgen.sh .surfgen.generator.yaml spec/auth/api.yaml auth src/mdoels /src/models/Umbrella.dart
```
