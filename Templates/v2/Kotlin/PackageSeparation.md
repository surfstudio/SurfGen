# SurfGen Kotlin package separation

Api models which are defined in `models.yaml` could be generated to separate packages according specification. By default only models are generated separately, but it could be changed in future.

To enable such behaviour, define a specification root in config, for more info look at https://github.com/surfstudio/SurfGen#package-separation

For example, lets test specification like this:
```
/products
    api.yaml
    models.yaml
/profile
    api.yaml
    models.yaml
/very/long/dir
    api.yaml
    models.yaml
```

In your kotlin project you will see the same generated dirs (products, profile, very/long/dir).

By default the directory is different but the package is the same. Such approach simplifies imports problem. You will see that each entity, entry and enum has `package ru.surfgen.android.domain.entity`, `package ru.surfgen.android.domain.entry`, `package ru.surfgen.android.domain.enum` respectively according default templates.

So your IDE will show the warning that the package is different from its directory.

But it's made on purpose.

There is a way to generate a package name exactly as a dir name like this: `package ru.surfgen.android.domain.entity.{{ model.apiDefinitionFileRef|getPackageName }}` (try it out on template). But it breaks imports, so you must add them manually or you can probably define them statically in each model template like this:

```
// entity template
package ru.surfgen.android.domain.entity.{{ model.apiDefinitionFileRef|getPackageName }}

import ru.surfgen.android.domain.products.*
import ru.surfgen.android.domain.profile.*
import ru.surfgen.android.domain.very.long.dir.*
```

But it could be done only manually and must be updated for each specification updates.

That's why the package name is the same by default (the IDE warning could be ignored in this minor case). But it's up to you to decide your way, since it's possible.
