# hs-mumble


## regenerate Data.MumbleProto 

to regenerate the Data.MumbleProto source files run: 

```
hprotoc -d src --prefix=Data --lenses --verbose Mumble.proto
```

