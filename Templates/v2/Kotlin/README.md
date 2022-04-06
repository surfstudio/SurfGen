# SurfGen Kotlin templates

`RxJava` templates stand for an old tech stack in Surf, see [old template][oldTemplate].
`Coroutines` templates stand for a new tech stack, see [new template][newTemplate].

## Usage
1. In your project create Templates directory and copy all stencil files from the current directory.
1. Add SurfGen config file, sample is located [here][config].
1. For each template file replace package name `ru.surfgen.android` to your project's actual package name.
1. Fix imports for `transform`, `transformCollection` extensions according to their location in your project.
1. Run generate command according to the main documentation.

See also [package separation](PackageSeparation.md)

[oldTemplate]: https://github.com/surfstudio/SurfAndroidStandard/tree/dev/G-0.5.0/template
[newTemplate]: https://github.com/surfstudio/surf-mvi-demo
[config]: config/kotlin.config.yaml
