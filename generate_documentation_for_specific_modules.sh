rm -rf Sources/Common/Docs
rm -rf Sources/CodeGenerator/Docs
rm -rf Sources/ReferenceExtractor/Docs
rm -rf Sources/Pipelines/Docs
rm -rf Sources/GASTBuilder/Docs
rm -rf Sources/GASTTree/Docs

swift doc generate Sources/Common --module-name SurfGen --output Sources/Common/Docs --base-url=./
swift doc generate Sources/CodeGenerator --module-name SurfGen --output Sources/CodeGenerator/Docs --base-url=./Docs
swift doc generate Sources/ReferenceExtractor --module-name SurfGen --output Sources/ReferenceExtractor/Docs --base-url=./
swift doc generate Sources/Pipelines --module-name SurfGen --output Sources/Pipelines/Docs --base-url=./
swift doc generate Sources/GASTBuilder --module-name SurfGen --output Sources/GASTBuilder/Docs --base-url=./
swift doc generate Sources/GASTTree --module-name SurfGen --output Sources/GASTTree/Docs --base-url=./

mv Sources/CodeGenerator/Docs/Home.md Sources/CodeGenerator/README.md 