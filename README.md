# auto sync from vthanhtv

- get new m3u from https://playlist.vthanhtivi.pw/, then change vthanhtv.m3u
- run script: node sync_iptv7.js
- check target file: iptv_7_new.m3u, and copy to main file.
- ./up.sh to push.

# tv

http://gg.gg/iptv_7 => https://tidusvn05.github.io/tv/iptv_7.m3u

# a sample playlist to specific resolution Full HD

https://vips-livecdn.fptplay.net/hda1/vtv1hd_vhls.smil/playlist.m3u8?token=eyJ1c2VyX2lkIjogIiIsICJjaGFubmVsX3VybCI6ICJ2dHYxaGRfdmhscy5zbWlsIiwgImlzcCI6ICJ2aWV0dGVsIiwgInRpbWVzdGFtcCI6IDE2NzQ3NDg1MjYsICJoYXNoX3NlY3JldCI6ICJjNzAwM2VjZDk2OTQ2NDM5NmM1NjIyZTdiN2MyZDg3ZCIsICJybWlwIjogIjExNS43Ni41NC45MiJ9

```
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-STREAM-INF:BANDWIDTH=1200000,CODECS="avc1.4d001f,mp4a.40.2",RESOLUTION=640x360
chunklist_b1200000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=1800000,CODECS="avc1.4d001f,mp4a.40.2",RESOLUTION=854x480
chunklist_b1800000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2500000,CODECS="avc1.640028,mp4a.40.2",RESOLUTION=1280x720
chunklist_b2500000.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=5000000,CODECS="avc1.640028,mp4a.40.2",RESOLUTION=1920x1080
chunklist_b5000000.m3u8
```

# Source FPT

- normal
  `https://livecdn.fptplay.net/hda1/vtv1hd_vhls.smil/playlist.m3u8`
- vip cdn
  ``

- user agent
  `Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36`

- token: `token=eyJ1c2VyX2lkIjogIiIsICJjaGFubmVsX3VybCI6ICJ2dHYxaGRfdmhscy5zbWlsIiwgImlzcCI6ICJ2aWV0dGVsIiwgInRpbWVzdGFtcCI6IDE2NzQ3NDg1MjYsICJoYXNoX3NlY3JldCI6ICJjNzAwM2VjZDk2OTQ2NDM5NmM1NjIyZTdiN2MyZDg3ZCIsICJybWlwIjogIjExNS43Ni41NC45MiJ9`

- reponse playlist includes many resolutions

# Source Viettel

http://171.238.181.230:18080/154.m3u8?AdaptiveType=HLS&VOD_RequestID=/0BqRzl1VbsZ/VFgXjcv/5uE+IUgcjIR3FcrqoWGAjTumPjnp9wGhD1ZTJCGbWu6cpHIaJEDcNeAk9JkbMYeiBKlIX5BHW2ocdJplj9OM4YYbriGCcL4eImfHcfBgOPSSsM0BCBFOhU64+sjTyeR8mitOSSos/txSEuu8vqk1PhUXh3ynlGKtSJmDhpQrAGo

# List URL

- freevip

`http://gg.gg/iipp1`

- simple
