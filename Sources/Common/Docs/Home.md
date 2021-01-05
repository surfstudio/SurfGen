# Types

  - [CommonError](/CommonError):
    Must be used Error
    Contains meta information about error
    whis is useful for debugging and understading in `What was happen?!`
  - [Dependency](/Dependency):
    It's like a node of dependency graph.
    But this struct describes one file of API specification
  - [SurfGenError](/SurfGenError):
    Just a wrapper on other errors
    Tha main feature is that whis error implemntation can print error tree with shifts

# Protocols

  - [FileProvider](/FileProvider):
    Interface for object which can deal with files in file system

# Global Functions

  - [wrap(\_:​message:​)](/wrap\(_:message:\))
