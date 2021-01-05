# Types

  - [CommonError](./Docs/CommonError.md):
    Must be used Error
    Contains meta information about error
    whis is useful for debugging and understading in `What was happen?!`
  - [Dependency](./Docs/Dependency.md):
    It's like a node of dependency graph.
    But this struct describes one file of API specification
  - [SurfGenError](./Docs/SurfGenError.md):
    Just a wrapper on other errors
    Tha main feature is that whis error implemntation can print error tree with shifts

# Protocols

  - [FileProvider](./Docs/FileProvider.md):
    Interface for object which is can deal with files in file system

# Global Functions

  - [wrap(\_:​message:​)](./Docs/wrap\(_:message:\))
