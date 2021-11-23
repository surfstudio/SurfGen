# SurfGen Kotlin templates

By default the [Surf template project][template] structure is followed.

## Usage
1. In your project create Templates directory and copy all stencil files from the current directory.
1. Add SurfGen config file, sample is located [here][config].
1. For each file replace package name `ru.surfgen.android` to your project's actual package name.
1. Fix imports for `transform`, `transformCollection` extensions according to their location in your project.
1. Run generate command according to the main documentation.

[template]: https://github.com/surfstudio/SurfAndroidStandard/tree/dev/G-0.5.0/template
[config]: config/kotlin.config.yaml