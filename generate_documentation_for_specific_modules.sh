# adds `.md` extension to references. Because now all file references don't contain file extension. idk why.

add_ext_to_refs(){
    sed -i '' 's|):|.md):|g' $1
}

add_docks_path_to_refs(){
    sed -i '' 's|./|./Docs/|g' $1
}

fix_refs_in_dir(){
    for entry in "$1"/*
    do
        add_ext_to_refs $entry
    done
}

fix_readme_issues(){
    add_ext_to_refs $1
    add_docks_path_to_refs $1
}

rm -rf Sources/Common/Docs
rm -rf Sources/CodeGenerator/Docs
rm -rf Sources/ReferenceExtractor/Docs
# rm -rf Sources/Pipelines/Docs
rm -rf Sources/GASTBuilder/Docs
# rm -rf Sources/GASTTree/Docs

rm Sources/CodeGenerator/README.md
rm Sources/Common/README.md

swift doc generate Sources/Common --module-name SurfGen --output Sources/Common/Docs --base-url=./
swift doc generate Sources/CodeGenerator --module-name SurfGen --output Sources/CodeGenerator/Docs --base-url=./
swift doc generate Sources/ReferenceExtractor --module-name SurfGen --output Sources/ReferenceExtractor/Docs --base-url=./
# swift doc generate Sources/Pipelines --module-name SurfGen --output Sources/Pipelines/Docs --base-url=./
swift doc generate Sources/GASTBuilder --module-name SurfGen --output Sources/GASTBuilder/Docs --base-url=./
# swift doc generate Sources/GASTTree --module-name SurfGen --output Sources/GASTTree/Docs --base-url=./

mv Sources/CodeGenerator/Docs/Home.md Sources/CodeGenerator/README.md 
mv Sources/Common/Docs/Home.md Sources/Common/README.md 
mv Sources/GASTBuilder/Docs/Home.md Sources/GASTBuilder/README.md 
mv Sources/ReferenceExtractor/Docs/Home.md Sources/ReferenceExtractor/README.md 

fix_readme_issues Sources/CodeGenerator/README.md
fix_readme_issues Sources/Common/README.md
fix_readme_issues Sources/GASTBuilder/README.md
fix_readme_issues Sources/ReferenceExtractor/README.md