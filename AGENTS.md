# Xiaomi TV Operations

Thư mục này dùng để quản lý cấu hình, ứng dụng và nội dung cho TV Xiaomi trong mạng nội bộ.

## Thiết bị đang quản lý

- IP: `192.168.0.107`
- ADB endpoint: `192.168.0.107:5555`
- Manufacturer: `xiaomi`
- Model: `MiTV-ANSP0`
- Android: `9`
- Product/device code: `jobs`
- Home launcher mặc định: Emotn UI TV Launcher `com.oversea.aslauncher/.ui.main.MainActivity`
- Xác minh kết nối thành công lần cuối: `2026-08-11`

IP có thể thay đổi nếu router cấp lại DHCP. Nếu kết nối thất bại, dùng `adb mdns services` để tìm endpoint hiện tại trước khi kết luận TV ngoại tuyến.

## Kết nối ADB

Máy điều khiển và TV phải ở cùng mạng LAN. Trên macOS, Terminal/Codex cần được cấp quyền tại **System Settings → Privacy & Security → Local Network**. VPN hoặc chế độ chặn truy cập LAN cũng phải được tắt hoặc cấu hình cho phép LAN.

```bash
adb kill-server
adb start-server
adb connect 192.168.0.107:5555
adb devices -l
```

Kết nối hợp lệ phải hiện thiết bị ở trạng thái `device`, không phải `offline` hoặc `unauthorized`:

```text
192.168.0.107:5555 device product:jobs model:MiTV_ANSP0 device:jobs
```

TV có thể không phản hồi `ping`; hãy kiểm tra trực tiếp cổng ADB và trạng thái thiết bị:

```bash
nc -vz -w 3 192.168.0.107 5555
adb -s 192.168.0.107:5555 get-state
```

Đọc lại thông tin nhận dạng:

```bash
adb -s 192.168.0.107:5555 shell 'getprop ro.product.manufacturer; getprop ro.product.model; getprop ro.build.version.release'
```

## Home launcher

Launcher thay thế đang dùng là Emotn UI TV Launcher `1.0.9.0`. APK lưu tại:

```text
atv_apks/xiaomi/Emotn-UI-TV-Launcher_1.0.9.0.apk
```

Đọc launcher mặc định hiện tại:

```bash
adb -s 192.168.0.107:5555 shell 'cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME'
```

Đặt lại Emotn làm Home sau khi firmware Xiaomi cập nhật:

```bash
adb -s 192.168.0.107:5555 shell cmd package set-home-activity --user 0 com.oversea.aslauncher/.ui.main.MainActivity
adb -s 192.168.0.107:5555 shell input keyevent KEYCODE_HOME
```

Khôi phục Home gốc của Xiaomi khi được yêu cầu:

```bash
adb -s 192.168.0.107:5555 shell cmd package set-home-activity --user 0 com.mitv.tvhome/.MainActivityUserMode
adb -s 192.168.0.107:5555 shell input keyevent KEYCODE_HOME
```

## Package inventory

Snapshot package hiện tại được lưu tại `XIAOMI_TV_PACKAGES.md`. File gồm package name, version, version code, phân loại system/user, trạng thái và đường dẫn APK.

Phân tích package dư thừa, mức rủi ro và quy trình disable/rollback được lưu tại `XIAOMI_TV_DEBLOAT_PLAN.md`. Phải đọc file này và kiểm tra live state trước khi thay đổi package; không chạy hàng loạt danh sách cũ.

Đề xuất ứng dụng giải trí, phiên bản tham chiếu, nguồn tải, hash/chữ ký và giới hạn tương thích của TV được lưu tại `XIAOMI_TV_ENTERTAINMENT_APPS.md`. Không cài APK gắn nhãn mod/clone/premium nếu chưa xác minh package, ABI, hash và chữ ký nhà phát hành.

Cập nhật lại inventory trực tiếp từ TV:

```bash
zsh scripts/export_tv_packages.sh 192.168.0.107:5555 XIAOMI_TV_PACKAGES.md
```

Luôn kiểm tra tổng số dòng trong bảng khớp với `adb shell pm list packages` sau khi xuất.

## Nguyên tắc vận hành

- Luôn đọc trạng thái hiện tại trước khi thay đổi cài đặt.
- Chỉ thao tác đúng thiết bị `192.168.0.107:5555`; dùng `adb -s` khi có nhiều thiết bị.
- Sau mỗi thay đổi, đọc lại trạng thái hoặc kiểm tra trực tiếp trên TV để xác nhận.
- Không factory reset, reboot, gỡ ứng dụng, xóa dữ liệu, tắt launcher hoặc thay đổi cấu hình mạng nếu người dùng chưa yêu cầu rõ ràng.
- Không lưu khóa ADB, mật khẩu Wi-Fi, token hoặc dữ liệu bí mật trong repository.
- Khi cài APK, giữ file nguồn trong thư mục phù hợp và ghi lại package name, version cùng kết quả xác minh.
- Ghi các thay đổi cấu hình đáng kể vào mục lịch sử bên dưới.

## Lịch sử thay đổi

- `2026-08-11`: Đối chiếu danh sách legal Kodi add-ons từ Reddit với kho live. Cài/enable Pluto TV `1.6.2`, Plex `0.3.5`, NASA `3.0.3+matrix.1`, NHK Live `4.0.11`, YouTube for Kodi `7.4.4` và dependency chính thức. Vá NHK để bỏ qua API VOD/EPG đã chết và dùng luồng Smart TV hiện hành; xác minh NHK phát video thật. Vá Plex cho Python 3.11; xác minh mở tới màn hình Sign In. Pluto trả menu nhưng catalog rỗng tại IP Việt Nam; NASA TV 24/7 đã dừng từ 2024. Không cài Tubi vì addon Kodi/SlyGuy được bài Reddit nêu không còn tồn tại và bundle APKMirror chưa tải/xác minh được do Cloudflare. Chi tiết/bản vá lưu tại `XIAOMI_TV_ENTERTAINMENT_APPS.md` và `atv_apks/kodi-addons/PATCHES.md`.
- `2026-08-11`: Bổ sung nguồn phim/hoạt hình hợp pháp từ kho Kodi Omega: Internet Archive `1.0.0`, Vimeo `6.0.4`, PBS Kids `4.0.1` và t1m Library `4.0.9`; enable toàn bộ và xác minh trực tiếp Kodi trả về danh mục cho cả ba add-on (PBS Kids trả về 68 mục). Không cài repository torrent/phim lậu hoặc bypass thuê bao dù yêu cầu có `--force`.
- `2026-08-11`: Cài Kodi `21.0` từ `kodi.apk.dog` sau khi MD5 khớp nguồn và certificate xác nhận XBMC Foundation; cập nhật YouTube TV `2.02.08 → 7.12.300` và Stremio `1.6.7 → 1.10.4` bằng chữ ký khớp để giữ dữ liệu. Kodi được cấu hình tiếng Việt, ưu tiên phụ đề Việt/Anh; cài/enable OpenSubtitles.com `1.0.9` cùng các Python dependency, IPTV Simple `21.11.0` ARMv7 và ba InputStream dependency từ Kodi Omega. OpenSubtitles còn cần người dùng nhập tài khoản; IPTV chưa gắn playlist chưa xác minh. Đã xác nhận ba app mở, Emotn vẫn là Home và không reboot TV.
- `2026-08-11`: Đánh giá app giải trí theo cấu hình live của TV (`armeabi-v7a`, Android 9, 1080p, không có GMS/Play Store); lưu đề xuất và cảnh báo nguồn APK tại `XIAOMI_TV_ENTERTAINMENT_APPS.md`. Chưa tải hoặc cài app mới.
- `2026-08-11`: Thực hiện debloat đợt 1 bằng `disable-user` cho `com.miui.analytics`, `com.mitv.shoplugin`, `com.sohu.inputmethod.sogou.tv`, `com.xiaomi.mitv.calendar`, `com.xiaomi.screenrecorder`. Xác minh 5 package disabled/process dừng, Settings mở được, Emotn Home và LeanKey không đổi; lưu snapshot trước thay đổi tại `XIAOMI_TV_PACKAGES.before-debloat-2026-08-11.md` và cập nhật inventory hiện tại.
- `2026-08-11`: Audit danh sách debloat cũ: 16 package đã `installed=false` cho user 0, 5 package không tồn tại; ghi kế hoạch và ứng viên còn sót vào `XIAOMI_TV_DEBLOAT_PLAN.md`. Chưa disable/uninstall thêm package nào.
- `2026-08-11`: Chụp inventory gồm 110 package (85 system, 25 user, 0 disabled) vào `XIAOMI_TV_PACKAGES.md`; thêm script tái tạo `scripts/export_tv_packages.sh`.
- `2026-08-11`: Đặt lại Emotn UI TV Launcher `1.0.9.0` làm Home mặc định sau khi firmware Xiaomi chuyển về launcher tiếng Trung; xác minh phím Home mở `com.oversea.aslauncher/.ui.main.MainActivity`. Giữ nguyên launcher gốc Xiaomi.
- `2026-08-11`: Xác nhận kết nối ADB thành công; ghi nhận Xiaomi `MiTV-ANSP0`, Android `9`, endpoint `192.168.0.107:5555`.
