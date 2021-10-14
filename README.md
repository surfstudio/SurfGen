
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

## Supported plaforms

SurfGen can be run on:

- MacOS
- Ubuntu
- On Windows (through WSL)

## Templates

At this moment we have:

- iOS
- Android
- Flutter

To create your own templates use [https://stencil.fuller.li](https://stencil.fuller.li)

## Installation

> If you want to build it on Ubuntu beforehand you need to configure envoronment or just install Swift by our [bash script](InstallSwiftOnLinux.sh)

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

SurfGen currently has 3 workflows: 
- **linter** for linting OpenAPI 
- **generator** for generating code from OpenAPI
- **create-config** for generate config for **linter** and **generator**

### Create-Config command

Use it to generate config stub with marks and comment. Then you can change it manyally to your needs
```sh
SurfGen create-config -f swift -t generator
```

| Parameter | Description |
|---------|---------------|
| `--file-ext` or `-f` | Value for property `fileExtension` in config |
| `--type` or `-t` | Type of config. Must be `linter` or `generator` |


### Lint command

Use `lint` command to check if your OpenAPI spec is correct in terms of SurfGen (source coude can be generated without errors). If not, you will see log with errors and warnings, describing what exactly is wrong with the spec.

```sh
SurfGen lint <pathToSpec>
```

where `pathToSpec` is a path either to one file in OpenAPI spec or to the directory containing whole spec.

| Parameter | Description |
|---------|---------------|
| `--config` or `-c` | Path to config file |
| `--verbose` or `-v` | Prints `DEBUG` logs |


#### Linter Config

[Example (generated by `create-config`)](.surfgen.linter.yaml)

```yaml
exclude:
- /Path/To/OpenAPI/Project/fileName.yaml
- /Path/To/OpenAPI/Project/anotherFile.yaml
```

By `exclude` keyword you can specify files which you want to exclude from linting.

**Warning:** this ignore-list can contain paths only to files, not directories.

### Generate command

Use `generate` command to generate files with source code.

```sh
SurfGen generate -c <pathToConfig> <pathToSpec>
```

where `pathToSpec` is a path to one file in OpenAPI spec **which describes service** you need to generate.

| Parameter | Description |
|---------|---------------|
| `--config` or `-c` | Path to config file |
| `--verbose` or `-v` | Prints `DEBUG` logs |
| `--name` or `-n` | This name will be used for service which you want to generate. So models have their own names, but HTTP enpoint don't you need specify a name for you service|
| `--rewrite` or `-r` | If set wil rewrite old files by new ones. When SurfGen generate file it creates a name for file. If file with this name adlready exists then SurfGen will rewrite it |

#### Generator config

[Example (generated by `create-config`)](.surfgen.generator.yaml)

| Parameter | Description |
|---------|---------------|
| `templates`| Contains array of structures called `Tenpmlate` |
| `prefixesToCutDownInServiceNames` | See [Prefix Cutting](#prefix-cutting)|
| `useNewNullableDeterminationStrategy` | See [Nullability](#nullability) |

## Editing templates

See [Templates](TEMPLATES.md)

## Analytcs

There is a way to collect usage analytcs for your needs.

Analytics collection is turned off by default, but you can set it up with config.

To do this you need to add `analytcsConfig` section to ypu config. It can look like:

```Yaml
analytcsConfig:
    logstashEnpointURI: http://127.0.0.1:6644
    payload:
        project: Test
```

We use this setting in our projects just to understand how good SurfGen works. You can just delete it.

## Supported features

We support lots of thing. Just it will be more easy to say what we don't support (:

### Nullability

We support properties nullability by two strategies

Old strategy is based on `required` property of `schema` and we use it to determine if property nullable or not (if property is listed in `required` then it isn't nullable)

But also we have a new strategy that is based on `nullable` field. And if  `nullable: false` then the property will not be nullable. Also property won't be nullable if field `nullable` wasn't specified.

If `nullable: true` then the property will be `nullable`

**By default SurfGen use old strategy**

We do it in terms of backward compatibility, but we will change default haaviour in next major release.

Not if you want to use the new strategy you need to write it in root of your generation config:

```Yaml

useNewNullableDeterminationStrategy: true

templates:
    ...
analyticsConfig:
    ...
```

### Prefix Cutting

We can cut prefixes from URI in generated files. For example we have endpoints with this URIs:
```
/api/v1/auth
/api/v2/auth
/api/test/auth
```

But we dont want to have generated code like:
```
func apiv1Auth() {...}
func apiv2Auth() {...}
func apitestAuth() {...}
```

And we want to handle base path of URL manually so to cut those prefixes we should define `prefixesToCutDownInServiceNames` in generator config:
```
prefixesToCutDownInServiceNames:
    - /api/v1
    - /api/v2
    - /api/test
```

## Unsupported OpenAPI features

- We don't support key `not`
- We don't support in-place schema declration (when you don't create a `components/schemas/Object` but you write schema just in place where you use it (for example in response))
- We don't support groups (oneOf, allOf, anyOf) which are include arrays
- We don't support arrays whose item's type is aray (like arrays of arrays)

... and may be we forgot something ...

BUT if you find something that isn't work - plz contact us, or create an issue and we will fix it!

And if you need some of the features that isn't supported - create an issue, or create a PR (:
