# build generator framework
xcodebuild -project ../ModelsGenerator/ModelsCodeGeneration.xcodeproj -scheme MacOSModelsCodeGeneration -derivedDataPath ./DerivedData

# copy framework to surfgen app 
rm -rf ../surfgen/MacOSModelsCodeGeneration.framework
cp -a ./DerivedData/Build/Products/Debug/MacOSModelsCodeGeneration.framework ../surfgen

