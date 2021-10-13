# Test Build On Linux

There you can find a docker environment to test build on linux

There are:
- `BaseImage` - image with swift (installed by SurfGen's script)
- `Dockerfile` - image wich build SurfGen (based on BaseImage)

How to use it:
1. You need to build `BaseImage` - `docker build . -f BaseImage -t SurfGenEnv --no-cache`
2. It's important -> `-t SurfGenEnv` 
3. Then you need to build `Dockerfile` - `docker build . -f Dockerfile -t SurfGenTest --no-cache`
4. Then you need to run it to check build - `docker run SurfGenTest`

Profit.

If ypu haven't ever work with docker - don't touch content of files and ask somebody in Issues. Or find out what is that Docker :)