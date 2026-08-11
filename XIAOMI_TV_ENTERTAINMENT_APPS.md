# Đề xuất ứng dụng giải trí cho Xiaomi TV nội địa

## 1. Tóm tắt trước

**Kết luận:** Kodi, YouTube TV và Stremio đã được cài/cập nhật, mở thử thành công trên Xiaomi TV. Kodi đã có giao diện tiếng Việt, OpenSubtitles.com, IPTV Simple Client, Pluto TV, Plex, NASA và NHK World. NHK World đã phát live thực tế; Plex mở được màn hình đăng nhập. Pluto cài được nhưng không trả nội dung tại IP Việt Nam, còn NASA TV 24/7 đã bị NASA dừng. Chỉ dùng APK `armeabi-v7a`/`ARM 32-bit` hoặc universal có ARMv7.

**Đã thực hiện ngày 2026-08-11:** Kodi `21.0`, YouTube TV `7.12.300` và Stremio Android TV `1.10.4`. VLC và TV Bro vẫn là đề xuất, chưa cài.

**Độ tin cậy:** Cao về khả năng tương thích kiến trúc/Android vì đã kiểm tra trực tiếp TV và đối chiếu nguồn phát hành chính thức. Trung bình với các dịch vụ DRM thương mại vì firmware không cung cấp đủ thông tin Widevine/certification.

**Trạng thái:** Đã xác minh live sau cài đặt; Emotn vẫn là Home mặc định và TV không reboot.

## 2. Khả năng thực tế của TV

| Thuộc tính | Giá trị | Hệ quả khi chọn APK |
|---|---|---|
| Model | Xiaomi `MiTV-ANSP0` | Firmware nội địa Trung Quốc |
| Android | `9`, API 28 | Phù hợp phần lớn app Android TV hiện tại nhưng không nên chọn build yêu cầu Android 10+ |
| CPU ABI | `armeabi-v7a`, 32-bit | Chọn `ARM`, `ARMv7`, `ARMV7A` hoặc universal có ARMv7; không chọn ARM64-only |
| Màn hình | `1920x1080`, density 320 | Không cần ưu tiên bản 4K nặng |
| Dung lượng `/data` | Khoảng 21 GB trống tại thời điểm kiểm tra | Đủ cho app và cache; không phù hợp lưu thư viện phim rất lớn nội bộ |
| Google services | Không có GMS, Play Store hoặc GSF | Ưu tiên APK tải trực tiếp; app phụ thuộc Google Play có thể lỗi |
| DRM | DRM service chạy nhưng không đọc được Widevine level/certification | Netflix/Disney+/Prime Video có thể không chạy hoặc bị giới hạn chất lượng |

## 3. Bộ app nên cài/cập nhật

### Ưu tiên 1 — nên có

| App | Phiên bản tham chiếu | Trạng thái hiện tại | Dùng cho | Đề xuất |
|---|---:|---|---|---|
| VLC for Android TV | `3.7.0` | Chưa cài; repo có APK `3.5.3` cũ | Phát file USB, SMB/NAS, HLS/DASH, audio, subtitle | Tải bản ARMv7 chính thức từ VideoLAN và cài mới. |
| Kodi | `21.0 Omega` | **Đã cài** từ file do `kodi.apk.dog` cung cấp | Media center, thư viện phim, NAS, IPTV M3U/XMLTV | Đã xác minh package, ABI, hash và chữ ký XBMC Foundation trước khi cài. |
| TV Bro | `2.1.5` | Chưa cài; repo có `1.8.6` cũ | Trình duyệt tối ưu remote, tab, bookmark, đổi user-agent, download | Tải release chính thức từ GitHub dự án. |
| Stremio Android TV | `1.10.4` ARM | **Đã cập nhật** từ `1.6.7` | Tổng hợp thư viện/nguồn streaming hợp pháp | Dữ liệu được giữ lại bằng `adb install -r`; chữ ký bản cũ/mới khớp nhau. |

Nguồn chính thức:

- VLC: <https://www.videolan.org/vlc/download-android.html>
- Kodi theo yêu cầu: <https://kodi.apk.dog/>; đối chiếu chữ ký với XBMC Foundation
- TV Bro: <https://github.com/truefedex/tv-bro/releases>
- Stremio Android TV: <https://www.stremio.com/downloads>

### Hồ sơ APK đã cài

| App | Package / version | File local | Kiểm tra trước cài |
|---|---|---|---|
| Kodi | `org.xbmc.kodi` `21.0` (`2100001`) | `atv_apks/managed/Kodi-21.0-apk.dog.apk` | MD5 `a0f99686011c974eb342a24ec9d1068a` khớp trang nguồn; SHA-1 certificate `5cd9110c3d8e066324615d1279fb93a13c78d666`; signer `XBMC Foundation`; ABI gồm `armeabi-v7a`. |
| YouTube TV | `com.google.android.youtube.tv` `7.12.300` (`712300320`) | `atv_apks/managed/YouTube-TV-7.12.300-armeabi-v7a.apk` | SHA-256 file `643e41f19606575b3be40125635e8da23742d669e21068f307fbd54c7c8f15c7`; signer SHA-256 `21199d112cece428c82cb0df221da24ff8674c7a982a83a17a970eec43305b4a`, khớp bản Google cũ trên TV. |
| Stremio | `com.stremio.one` `1.10.4` (`31048580`) | `atv_apks/managed/Stremio-1.10.4-androidTV-armeabi-v7a.apk` | APK Android TV ARMv7 chính thức; signer SHA-256 `7e6a979c968f771e3fbcf2c2e8718ce61e708d87caf91fc13e2d4c19a8022c6b`, khớp bản `1.6.7`. |

APK trước nâng cấp được giữ trong `atv_apks/backups/2026-08-11/`.

### Ưu tiên 2 — IPTV

TV này đang dùng repository M3U, vì vậy có hai lựa chọn tốt:

1. **Kodi + PVR IPTV Simple Client** — đã cài và enable bản `21.11.0` ARMv7. Add-on chính thức hỗ trợ M3U, XMLTV/EPG, nhiều cặp M3U/XML và catch-up khi nhà cung cấp hỗ trợ. Chưa gắn playlist vì các file M3U local chưa được xác minh quyền phát.
2. **OTT Navigator IPTV** — ưu tiên nếu muốn giao diện TV chuyên cho playlist lớn và điều khiển remote. Chỉ cài bản chính chủ của `Scillarium Studio`; app chỉ là player và không cung cấp nội dung.

Repo đang có các bản OTT Navigator cũ/mod từ năm 2022–2023. Không nên dùng chúng. Nếu dùng OTT Navigator, lấy bản chính chủ qua kênh mà nhà phát triển liệt kê, kiểm tra publisher là `Scillarium Studio` và package/signature trước khi cài.

Nguồn:

- Kodi IPTV Simple: <https://kodi.tv/addons/omega/pvr.iptvsimple/>
- Tài liệu Kodi IPTV: <https://kodi.wiki/view/Add-on:PVR_IPTV_Simple_Client>
- OTT Navigator FAQ/source: <https://github.com/ottnav/ottnav.github.io/blob/main/faq.md>
- Trang nhà phát triển OTT Navigator: <https://ott-nav.com/>

### Add-on Kodi đã cài

| Add-on | Phiên bản | Trạng thái | Mục đích / việc còn lại |
|---|---:|---|---|
| Vietnamese language pack | `11.0.78` | Enabled | Giao diện Kodi tiếng Việt. |
| OpenSubtitles.com | `1.0.9` | Enabled, đặt làm dịch vụ mặc định | Ưu tiên phụ đề `Vietnamese,English`; cần nhập tài khoản OpenSubtitles.com trong phần cấu hình add-on. |
| Requests + Python dependencies | `2.31.0` | Enabled | Thư viện chính thức cần cho OpenSubtitles.com (`certifi`, `chardet`, `idna`, `urllib3` cũng đã cài). |
| IPTV Simple Client | `21.11.0` | Enabled | Sẵn sàng cho M3U/XMLTV hợp pháp do người dùng hoặc nhà cung cấp cấp. |
| InputStream Adaptive | `21.5.22` | Enabled | DASH/HLS và nguồn adaptive. |
| InputStream FFmpeg Direct | `21.3.8` | Enabled | Phụ thuộc của IPTV Simple cho một số luồng. |
| RTMP Input | `21.1.2` | Enabled | Phụ thuộc cho nguồn RTMP hợp lệ. |
| Internet Archive | `1.0.0` | Enabled, đã đọc được danh mục live | Phim lưu trữ/public-domain, các bộ sưu tập phổ biến và tìm kiếm theo tên. |
| Vimeo | `6.0.4` | Enabled, đã đọc được danh mục live | Search, Featured, Trending và Categories cho phim ngắn/animation của nhà sáng tạo. |
| PBS Kids | `4.0.1` | Enabled, đã đọc được `68` mục live | Hoạt hình/giáo dục trẻ em; nội dung hoặc playback có thể bị giới hạn theo khu vực. |
| t1m Library | `4.0.9` | Enabled | Dependency chính thức của PBS Kids. |
| Pluto TV | `1.6.2` | Enabled; menu hoạt động nhưng danh mục rỗng tại IP Việt Nam | Add-on kho Kodi chính thức; metadata đã đánh dấu deprecated và dịch vụ phụ thuộc khu vực. Không dùng VPN/bypass vùng. |
| Plex for Kodi | `0.3.5` | Enabled; đã mở tới màn hình `Sign In` | Add-on chính thức của Plex. Đã vá tương thích Python 3.11; người dùng cần tự đăng nhập Plex trên TV. |
| NASA | `3.0.3+matrix.1` | Enabled; đọc được menu và 5 mục NASA | Add-on chính thức cũ. Các ID NASA TV 24/7 đã dừng từ 2024; thư viện trỏ sang YouTube và có thể cần đăng nhập/API phù hợp. |
| NHK Live | `4.0.11` | Enabled; **đã phát live thực tế** | Đã vá fallback do API VOD/EPG cũ bị gỡ và chuyển sang luồng Smart TV hiện hành; Kodi báo player video hoạt động. |
| YouTube for Kodi | `7.4.4` | Enabled; setup wizard hoàn tất | Dependency thực tế của NASA add-on. Live ID NASA cũ không phát; không lưu tài khoản hoặc API key trong repo. |

Tất cả add-on trên được tải từ kho Kodi Omega chính thức. OpenSubtitles.com yêu cầu đăng ký/import tài khoản trước khi dùng; không lưu username/password trong repository.

Các bản vá tương thích cục bộ và lý do được lưu tại `atv_apks/kodi-addons/PATCHES.md`.

### Đối chiếu danh sách Reddit ngày 2026-08-11

Nguồn người dùng cung cấp: <https://www.reddit.com/r/Addons4Kodi/comments/1rn4sba/10_best_legal_kodi_addons_in_2026_100_safe/?tl=vi>

| Dịch vụ | Kết quả triển khai |
|---|---|
| Pluto TV | Có trong Kodi Omega; đã cài `1.6.2`. Menu hoạt động nhưng Live/Categories/OnDemand đều rỗng tại Việt Nam, phù hợp khả năng giới hạn vùng. |
| Plex | Đã cài add-on Plex chính thức `0.3.5`, vá Python 3.11 và xác minh tới màn hình đăng nhập. |
| Tubi | **Chưa cài.** Tubi không còn trong kho Kodi Omega hoặc SlyGuy hiện tại như bài Reddit nêu. Bản Android TV `10.12.5000` ARMv7/API 28 trên APKMirror phù hợp phần cứng, nhưng là bundle và phiên tải tự động bị Cloudflare chặn; không thay bằng APK không rõ nguồn. |
| NASA | Đã cài `3.0.3+matrix.1`. NASA đã ngừng kênh TV tuyến tính 24/7 từ `2024-08-28` để chuyển sang NASA+; các live ID cũ trong add-on không còn phát. |
| NHK World | Đã cài `4.0.11`, vá API/stream cũ và xác minh phát live qua endpoint Smart TV hiện hành. |

Nguồn kiểm tra:

- Kodi Omega video add-ons: <https://kodi.tv/addons/omega/category/video-addons/>
- NASA add-on: <https://kodi.tv/addons/omega/plugin.video.nasa/>
- NASA+: <https://plus.nasa.gov/>
- Tubi supported devices: <https://tubitv.com/help-center/About-Tubi/articles/4409907124763>
- Tubi Android TV ARMv7 10.12.5000: <https://www.apkmirror.com/apk/tubi-tv/tubi-free-movies-live-tv-android-tv/tubi-free-movies-live-tv-android-tv-10-12-5000-release/tubi-free-movies-live-tv-android-tv-10-12-5000-android-apk-download/>

### Ngôn ngữ và phụ đề

- Giao diện Kodi vẫn là tiếng Việt.
- Pluto, NASA và NHK là dịch vụ quốc tế, không có danh mục/lồng tiếng Việt được xác minh trong các add-on này.
- NHK World live hiện có audio và closed captions tiếng Anh.
- Plex có thể dùng phụ đề Việt từ thư viện cá nhân; Kodi đã ưu tiên `Vietnamese,English` và OpenSubtitles.com.
- Tubi công bố hỗ trợ nhiều ngôn ngữ nhưng nội dung cụ thể phụ thuộc quốc gia; chưa xác minh catalog tiếng Việt trên TV này.

### Add-on phổ biến, hợp pháp cho phim và hoạt hình

| Add-on/nguồn | Phù hợp với | Ghi chú |
|---|---|---|
| YouTube | Hoạt hình, phim ngắn 3D, kênh thiếu nhi, trailer | TV đã có app YouTube TV mới nên không nhất thiết cài plugin Kodi. Plugin Kodi có thể cần API key riêng để đăng nhập. |
| Vimeo | Phim ngắn, hoạt hình nghệ thuật, animation/3D showcase | **Đã cài và kiểm tra danh mục**; nội dung và độ phân giải tùy video. |
| PBS Kids | Hoạt hình/giáo dục trẻ em | **Đã cài và kiểm tra danh mục**; khả năng phát có thể phụ thuộc khu vực. |
| Internet Archive | Phim tài liệu, giáo dục, phim công cộng | **Đã cài và kiểm tra danh mục**; phù hợp nội dung public-domain hơn phim thương mại mới. |
| Plex / Composite / Jellyfin | Thư viện phim và hoạt hình cá nhân | Lựa chọn tốt nhất nếu có NAS/media server; chất lượng phụ thuộc file của người dùng. |
| IPTV Simple Client | Truyền hình và VOD từ nhà cung cấp | Chỉ thêm URL M3U/XMLTV mà bạn có quyền sử dụng. Client không tự cung cấp nội dung. |
| FPT Play / VieON / TV360 | Phim Việt, phim châu Á, anime và truyền hình tại Việt Nam | Nên dùng app Android TV chính chủ và tài khoản hợp lệ; không dùng APK `Mod`, `AdFree`, `Premium`. |

Không cài các repository/add-on quảng cáo “phim miễn phí”, torrent cache hoặc bypass thuê bao. Chúng thường vi phạm bản quyền, thay đổi tên/URL nhanh và có rủi ro lấy token đăng nhập.

“Phim 2K” thường chỉ 1440p. Màn hình TV này là `1920x1080`, vì vậy nguồn 1440p sẽ bị downscale xuống 1080p; không tạo thêm chi tiết hiển thị so với một nguồn 1080p tốt. Nếu “hoạt hình 3D” nghĩa là stereoscopic 3D (SBS/MVC), cần kiểm tra riêng TV/panel/kính 3D; hiện chưa có bằng chứng model này hỗ trợ.

### Ưu tiên 3 — theo nhu cầu

| App | Phiên bản tham chiếu | Khi nên dùng | Điều kiện |
|---|---:|---|---|
| Jellyfin for Android TV | `0.19.9` | Có hoặc muốn dựng Jellyfin Server để xem thư viện phim cá nhân | Cần Jellyfin Server; tải release production, không dùng build master/debug. |
| Moonlight Android | `12.1` | Stream game/desktop từ PC lên TV | Cần PC chạy Sunshine và gamepad; ưu tiên H.264/1080p cho TV này. |
| RetroArch | `1.22.2` | Chơi game retro bằng ROM dump hợp pháp | Cần tay cầm; lấy APK chính thức hỗ trợ ARMv7 và tự cung cấp BIOS/ROM hợp pháp. |

Nguồn:

- Jellyfin Android TV: <https://github.com/jellyfin/jellyfin-androidtv/releases>
- Moonlight Android: <https://github.com/moonlight-stream/moonlight-android/releases>
- RetroArch: <https://github.com/libretro/RetroArch/releases>

## 4. YouTube và SmartTube — cần xử lý như vấn đề bảo mật

TV hiện có:

- YouTube for Android TV **`7.12.300`**, đã cập nhật từ `2.02.08` và mở thử thành công. Đây là APK ARMv7/min API 24, chữ ký Google khớp bản đã cài trước đó.
- `com.liskovsoft.videomanager` `6.17.739`, thuộc dòng SmartTube cũ và được sideload qua Android Package Installer.
- Repo có `SmartTubeNext_16.93_Stable_LamBass_Mod.apk`, là bản mod/đóng gói lại không nên tiếp tục dùng.

Dự án SmartTube hiện công bố rằng môi trường build từng bị nhiễm mã độc, một số build có thể bị ảnh hưởng và public signing keys có thể đã bị lộ. Dự án đã phát hành build/key mới và khuyên chỉ tải từ nguồn chính thức. Vì vậy:

1. Không cài file SmartTube mod trong repo.
2. Không cập nhật từ APK mirror, blog hoặc app store không chính thức.
3. Nếu đang đăng nhập Google trong SmartTube, cân nhắc thu hồi kết nối “YouTube TV/Google Drive” trước khi thay bản.
4. Với firmware Xiaomi Trung Quốc, dự án khuyên dùng nhánh **stable** thay vì beta.
5. Việc thay thế có thể cần backup cấu hình rồi uninstall bản ký bằng key cũ trước khi cài bản ký bằng key mới.

Nguồn chính thức và cảnh báo: <https://github.com/yuliskov/SmartTube>

SmartTube stable mới nhất được quan sát trong lần nghiên cứu trước là `31.73` (2026-05-27), nhưng phải kiểm tra lại release và chữ ký ngay tại thời điểm tải. Lần triển khai này không thay đổi SmartTube.

## 5. App Việt Nam và dịch vụ DRM

### Đã có

- TV360 `2.0.5` — đang cài nhưng khá cũ.

### Có file local nhưng không nên cài trực tiếp

- `FPTPlay_ATV_7.2.0_Mod_AdFree.apk`
- `VieON-for-AndroidTV_30.2.4.apk`
- Các APK BeeTV, FilmPlus, HDO Box, SportsTV, VeboTV, ZamTV và file gắn nhãn `Mod`, `Premium`, `AdFree`, `Clone`.

Lý do: không xác minh được chữ ký/nguồn, nhiều file cũ, có thể chứa mã quảng cáo hoặc credential collector, và một số dịch vụ có điều khoản bản quyền không rõ. Với FPT Play, VieON, TV360 hoặc ứng dụng trả phí, chỉ lấy APK từ nhà cung cấp/kho chính thức và dùng tài khoản hợp lệ.

### Netflix, Disney+, Prime Video

Chưa nên sideload. Không có Google services và chưa xác nhận Widevine/certification trên model nội địa này. APK có thể cài được nhưng không đảm bảo đăng nhập, điều khiển remote hoặc phát HD. Nếu đây là nhu cầu chính, phương án ổn định hơn là dùng TV stick/box Android TV được chứng nhận qua HDMI.

## 6. Thứ tự triển khai đề xuất

1. **Đã xong:** cài Kodi, cập nhật YouTube TV và Stremio; cấu hình Kodi tiếng Việt và phụ đề Việt/Anh.
2. Đăng nhập OpenSubtitles.com trực tiếp trên TV để hoàn tất phụ đề online.
3. Chỉ cấu hình IPTV Simple bằng playlist M3U/XMLTV có quyền sử dụng.
4. Cài VLC ARMv7 và TV Bro nếu vẫn cần player/browser riêng.
5. Audit/thay SmartTube theo quy trình key mới; không dùng file mod cũ.
6. Chỉ cài Jellyfin, Moonlight hoặc RetroArch nếu có nhu cầu tương ứng.

Không cài nhiều player trùng chức năng cùng lúc. VLC + Kodi đã phủ gần hết file local, NAS và IPTV; MX Player đang có có thể giữ làm fallback.

## 7. Claim ledger

| Nhận định | Bằng chứng | Tin cậy | Hệ quả |
|---|---|---|---|
| TV chỉ hỗ trợ ARMv7 32-bit, Android 9, 1080p | Runtime: `getprop`, `wm size` | Cao | Chọn ARM/ARMv7/ARMV7A, không ARM64-only. |
| TV không có GMS/Play Store/GSF | Runtime: `pm list packages` | Cao | Ưu tiên APK trực tiếp và app không phụ thuộc Google services. |
| VLC 3.7.0 hỗ trợ ARMv7, Android TV và network streams | Official: VideoLAN download page | Cao | Phù hợp nhất làm player nền tảng. |
| Kodi 21.0 từ nguồn người dùng chỉ định có ARMv7 và chữ ký XBMC Foundation | APK metadata, MD5 và certificate đã kiểm tra trước cài | Cao | Đã cài và mở thành công. |
| IPTV Simple 21.11.0 hỗ trợ M3U/EPG và có build Android ARMv7 | Kho Kodi Omega chính thức | Cao | Đã cài/enable; chưa thêm playlist chưa xác minh. |
| OpenSubtitles.com 1.0.9 hỗ trợ 75 ngôn ngữ và yêu cầu tài khoản | Kho Kodi Omega chính thức | Cao | Đã cài/enable và đặt ưu tiên Việt/Anh; người dùng còn phải đăng nhập. |
| Stremio Android TV có APK 1.10.4 ARM trực tiếp | Official: Stremio downloads + runtime | Cao | Đã nâng cấp tại chỗ từ 1.6.7. |
| YouTube TV 7.12.300 hỗ trợ ARMv7, Android 7+ và có chữ ký Google khớp | APK metadata/hash/signature + runtime | Cao | Đã nâng cấp tại chỗ từ 2.02.08. |
| SmartTube có cảnh báo build/signing-key gần đây | Source: repository chính thức | Cao | Không dùng APK mod/mirror; cần quy trình thay thế có kiểm soát. |
| Dịch vụ DRM thương mại sẽ chạy HD | Chưa xác minh Widevine/certification | Thấp | Không đề xuất sideload Netflix/Disney+/Prime ở giai đoạn này. |

## 8. Việc người dùng cần làm trên TV

1. Mở **Kodi → Add-ons → My add-ons → Subtitles → OpenSubtitles.com → Configure**.
2. Nhập tài khoản OpenSubtitles.com của bạn và dùng nút **Test Connection**. Không gửi mật khẩu để lưu vào repository.
3. Nếu có playlist hợp pháp: vào **Add-ons → My add-ons → PVR clients → IPTV Simple Client → Configure**, nhập URL/path M3U và XMLTV rồi restart riêng Kodi khi ứng dụng yêu cầu.
4. Đăng nhập lại YouTube/Stremio nếu ứng dụng yêu cầu sau nâng cấp; dữ liệu ứng dụng không bị xóa trong quá trình cài.
