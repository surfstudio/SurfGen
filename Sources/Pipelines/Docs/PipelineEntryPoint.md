# PipelineEntryPoint

This is the interface for entity which encapsulate all stages in pipeline
So it's the first stage of pipeline

``` swift
public protocol PipelineEntryPoint
```

## Requirements

### run(with:​)

Initiate the pipeline proccess

``` swift
func run(with input: Input) throws
```

#### Parameters

  - input: data which is nedded for pipeline
