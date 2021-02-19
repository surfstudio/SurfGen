
<p align="center">
  <img src="Docs/logo.png">
</p>

[![Build Status](https://travis-ci.com/JohnReeze/SurfGen.svg?token=ZXokqeDnBGm8WAqyowYA&branch=master)](https://travis-ci.com/JohnReeze/SurfGen) [![codebeat badge](https://codebeat.co/badges/09676c44-a507-48e8-bfa7-c286ce949212)](https://codebeat.co/projects/github-com-johnreeze-surfgen-master) [![codecov](https://codecov.io/gh/JohnReeze/SurfGen/branch/master/graph/badge.svg)](https://codecov.io/gh/JohnReeze/SurfGen)
 ![Swift Version](https://img.shields.io/badge/swift-5.0-orange) ![LISENCE](https://img.shields.io/badge/LICENSE-MIT-green)

SurfGen is an language and plaform agnostic CLI tool written which is used for generate Model and Service layers from OpenAPI 3.x specification

## How it works

1. SurfGen parses OpenAPI file 
2. Collects all dependencies (resolves `$ref` even for another files)
3. Create an internal representation of specification
4. Send internal representation to code generator
5. Code generator read code templates and generate files via them.

You can use our templates, or just write your own.

In SurfGen you determine the result platform and language by templates you give to SurfGen!

## Supported OpenAPI features

We support lots of thing. Just it will be more easy to say what we don't support (:

## Unsupported OpenAPI features

- We don't support key `not`
- We don't support in-place schema declration (when you don't create a `components/schemas/Object` but you write schema just in place where you use it (for example in response))
- We don't support groups (oneOf, allOf, anyOf) which are include arrays
- We don't support arrays whose item's type is aray (like arrays of arrays)

... and may be we forgot something ...

BUT if you find something that isn't work - plz contact us, or create an issue and we will fix it!

And if you need some of the features that isn't supported - create an issue, or create a PR (:

## Supported plaforms

SurfGen can be run on:

- MacOS
- Ubuntu

## Templates

At this moment we have:

- iOS
- Android
- Flutter

To create your own templates use [https://stencil.fuller.li](https://stencil.fuller.li)

## Installation

Just add next snippet to your Podfile
```
pod 'SurfGen', :git => "https://github.com/surfstudio/SurfGen.git"
```

Also you can build it from source and just add it to your project using next snippet
```sh
git clone https://github.com/surfstudio/SurfGen
cd SurfGen
make executable
cp -R Binary <your_project_path>
```
In order to use generate command you need to setup configuration file. See Configuration File 

## Usage

SurfGen currently has 2 workflows: **linter** and **generator**.

### Lint command

Use `lint` command to check if your OpenAPI spec is correct in terms of SurfGen. If not, you will see log with errors and warnings, describing what exactly is wrong with the spec.

```sh
SurfGen lint <pathToSpec>
```

where `pathToSpec` is a path either to one file in OpenAPI spec or to the directory containing whole spec.

#### Available parameters:

`-c, --config <pathToConfig>` (optional) Config for linting is just a list of files, which are to be ignored while linting, provided in following format:

```yaml
exclude:
- /Path/To/OpenAPI/Project/fileName.yaml
- /Path/To/OpenAPI/Project/anotherFile.yaml
```

**Warning:** this ignore-list can contain paths only to files, not directories.

### Generate command

Use `generate` command to generate files with code.

```sh
SurfGen generate <pathToSpec>
```

where `pathToSpec` is a path to one file in OpenAPI spec which describes service you need to generate.

#### Available parameters:

`-c, --config <pathToConfig>` (**necessary**) Generation config keeps description of templates and output files. See [Generation config](Sources/CodeGenerator/Stages/GenerationStage/Template.md) for details.

`-n, --name <serviceName>` (**necessary**) This name will be used as name for generated service files.

#### Available flags:

`-r, --rewrite` If set, new generated files will replace existing ones. Default is `false`

## Editing templates

See [Templates](TEMPLATES.md)
