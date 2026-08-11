# Kế hoạch tinh gọn Xiaomi TV nội địa

## 1. Tóm tắt trước

**Kết luận:** Danh sách thủ công cũ đã được áp dụng: 16 package có trong firmware đều đang ở trạng thái `installed=false` cho user 0; 5 tên còn lại không tồn tại trên firmware này. Không nên chạy lại danh sách cũ. Tuy nhiên vẫn còn một số dịch vụ Trung Quốc/không cần thiết ngoài danh sách, nổi bật là `com.miui.analytics`, Sogou IME, shopping plugin, gallery/content, Mi Home và nhóm cast/push.

**Khuyến nghị:** Dùng `pm disable-user --user 0` trước, từng package một. Chạy thử TV ít nhất một ngày và kiểm tra Home, remote, HDMI, phát video, bàn phím, Wi-Fi và sleep/wake trước khi cân nhắc `pm uninstall --user 0`.

**Độ tin cậy:** Cao đối với trạng thái package và thành phần đang chạy vì được kiểm tra trực tiếp trên TV; trung bình đối với vai trò của một số package đóng nguồn vì chỉ có thể suy luận từ manifest, component và tên tiến trình.

**Thiết bị kiểm tra:** Xiaomi `MiTV-ANSP0`, Android `9`, build `21.7.26.2294`, user hiện tại `0`, endpoint `192.168.0.107:5555`.

**Thời điểm kiểm tra:** `2026-08-11 12:47:57 +07`.

## 2. Điều quan trọng cần sửa trong ghi chú cũ

`pm uninstall --user 0 PACKAGE` không chỉ “cho app ngủ đông”. Android đánh dấu package là **không được cài cho user 0**. Với app hệ thống, APK gốc vẫn nằm trong phân vùng `/system`, `/vendor` hoặc `/product`, nên lệnh này không giải phóng phần dung lượng firmware đó. Dữ liệu của app có thể bị xóa nếu không dùng `-k`.

Phương án ít rủi ro hơn:

```bash
adb -s 192.168.0.107:5555 shell pm disable-user --user 0 PACKAGE
```

Khôi phục package đã disable:

```bash
adb -s 192.168.0.107:5555 shell pm enable --user 0 PACKAGE
```

Khôi phục package hệ thống đã `uninstall --user 0`:

```bash
adb -s 192.168.0.107:5555 shell cmd package install-existing --user 0 PACKAGE
```

Firmware này đã được kiểm tra và có hỗ trợ `install-existing`. Factory reset thường khôi phục app hệ thống theo ảnh firmware, nhưng không nên coi đó là cơ chế rollback chính và không nên kỳ vọng dữ liệu/cấu hình cũ luôn được giữ nguyên.

## 3. Kiểm tra lại danh sách thủ công cũ

TV biết tổng cộng 126 package trong firmware/package database, nhưng chỉ 110 package đang được cài cho user 0. Chênh lệch đúng 16 package và đó chính là 16 mục hợp lệ trong danh sách cũ.

### 3.1 Đã được gỡ cho user 0 — không chạy lại

Tất cả package dưới đây đều có `User 0: installed=false`:

| Package | Version | Vị trí hiện còn trong firmware/update | Nhận xét |
|---|---:|---|---|
| `com.xiaomi.mitv.upgrade` | `1.2.1` | `/vendor/app/MiTVUpgrade` | Trình nâng cấp Xiaomi; là package `PERSISTENT`, hiện đã gỡ cho user 0. |
| `com.miui.systemAdSolution` | `2017.01.04` | `/vendor/app/AdServer` | Dịch vụ quảng cáo hệ thống; đã gỡ. |
| `com.xiaomi.mibox.gamecenter` | `MITV_3.5.46_20200908` | `/vendor/app/MiTvGameCenter` | Game Center; đã gỡ. |
| `com.duokan.videodaily` | `2.7.4.4` | `/data/app/...` | Nội dung/video Duokan; đã gỡ. |
| `com.xiaomi.tweather` | `2.2.21` | `/system/app/TWeather` | Thời tiết Trung Quốc; đã gỡ. |
| `com.xiaomi.mitv.handbook` | `2.0.2` | `/data/app/...` | Hướng dẫn Xiaomi TV; đã gỡ. |
| `com.xiaomi.mitv.payment` | `2.8.8` | `/vendor/app/MiTVPayment` | Thanh toán; đã gỡ. |
| `com.xiaomi.mitv.pay` | `1.2` | `/vendor/app/MiTVPay` | Thanh toán; đã gỡ. Đây là package khác với `com.xiaomi.mitv.payment`. |
| `com.mipay.wallet.tv` | `0.0.13` | `/vendor/app/Mipay` | Ví Mi Pay; đã gỡ. |
| `com.xiaomi.mitv.appstore` | `2.5.81` | `/data/app/...` | Kho ứng dụng Xiaomi; đã gỡ. |
| `com.xiaomi.mitv.shop` | `4172` | `/data/app/...` | Cửa hàng Xiaomi; đã gỡ. |
| `com.miui.tv.analytics` | `1.33.71` | `/data/app/...` | Analytics TV cũ; đã gỡ. Lưu ý vẫn còn package khác là `com.miui.analytics`. |
| `com.xiaomi.voicecontrol` | `4.12.0` | `/data/app/...` | Voice control Trung Quốc; đã gỡ. |
| `com.xiaomi.gamecenter.sdk.service.mibox` | `2.5.8` | `/vendor/app/MiGameCenterSDKService` | SDK Game Center; đã gỡ. |
| `com.droidlogic` | `9` | `/vendor/priv-app/droidlogic-res` | Overlay/resource package chính xác này đã gỡ. Không được nhầm với các package `com.droidlogic.*` đang phục vụ phần cứng TV. |
| `com.xiaomi.statistic` | `1.0` | `/vendor/app/MiTVStat` | Thống kê Xiaomi; đã gỡ. |

### 3.2 Không tồn tại trên firmware hiện tại

Không chạy lệnh với các tên sau vì `pm list packages -u` và `dumpsys package` đều không tìm thấy:

- `com.xiaomi.mitv.advertise`
- `com.xiaomi.tv.appupgrade`
- `com.ktcp.tvvideo`
- `com.pptv.tvsports.preinstall`
- `com.pplive.atv`

Các tên này có thể thuộc model/firmware Xiaomi khác hoặc là tên cũ. Không thay bằng package có tên gần giống nếu chưa kiểm tra component và chức năng.

## 4. Package còn sót — nên thử disable trước

Chỉ disable từng package một. Sau mỗi package, kiểm tra theo checklist ở phần 7.

| Package | Version | Bằng chứng live | Khuyến nghị | Rủi ro |
|---|---:|---|---|---|
| `com.miui.analytics` | `6.7.0` | Có `AnalyticsService`, `AnalyticsReceiver`, `MarketingDistrictService`; tiến trình đang chạy. Đây là package khác với `com.miui.tv.analytics` đã gỡ. | Ưu tiên disable đầu tiên. | Thấp |
| `com.mitv.shoplugin` | `9.0.0` | Có activity mua sắm và component Alibaba/Taobao. | Disable nếu không dùng dịch vụ mua sắm Trung Quốc. | Thấp |
| `com.sohu.inputmethod.sogou.tv` | `7.4.190918` | Sogou IME đang có process, nhưng IME mặc định và IME duy nhất đang bật là LeanKey `com.liskovsoft.leankeyboard`. | Có thể disable; kiểm tra gõ chữ ngay sau đó. | Thấp, vì LeanKey đã hoạt động |
| `com.xiaomi.mitv.calendar` | `1.3.9` | Có Calendar, sync, notification và voice-control receiver. | Disable nếu không dùng lịch Xiaomi. | Thấp |
| `com.xiaomi.mimusic2` | `3.3.13` | Mi Music, player và MiPlay receiver. | Disable nếu không dùng trình nghe nhạc Xiaomi. | Thấp–trung bình |
| `com.xiaomi.smarthome.tv` | `2.5.6` | Mi Home/IoT, camera provider; tiến trình đang chạy. | Disable nếu không điều khiển thiết bị Mi Home từ TV. | Thấp–trung bình |
| `com.xiaomi.screenrecorder` | `1.0` | TV Screen Recorder; tiến trình đang chạy dù không mở giao diện. | Disable nếu không quay màn hình. | Thấp–trung bình |
| `com.xiaomi.tv.gallery` | `3.7` | Gallery mới đang chạy; package có asset/component liên quan AdServer và analytics. | Thử disable nhưng giữ `com.mitv.gallery` trong giai đoạn đầu. | Trung bình |

Lệnh mẫu cho **một** package:

```bash
PACKAGE=com.miui.analytics
adb -s 192.168.0.107:5555 shell pm disable-user --user 0 "$PACKAGE"
adb -s 192.168.0.107:5555 shell pm list packages -d --user 0 "$PACKAGE"
adb -s 192.168.0.107:5555 shell pidof "$PACKAGE"
```

Nếu có lỗi:

```bash
PACKAGE=com.miui.analytics
adb -s 192.168.0.107:5555 shell pm enable --user 0 "$PACKAGE"
```

Không copy một vòng lặp để disable toàn bộ bảng cùng lúc; làm như vậy sẽ khó xác định package gây lỗi.

## 5. Package chỉ xử lý nếu không dùng tính năng tương ứng

### 5.1 Cast, AirPlay, Miracast và kết nối hệ sinh thái Xiaomi

Các package sau đều đang chạy hoặc phục vụ cast/chia sẻ. Chỉ disable nếu TV không cần cast từ điện thoại/máy tính:

| Package | Vai trò suy ra từ runtime/component | Rủi ro |
|---|---|---|
| `com.duokan.airkan.tvbox` | AirKan daemon/cast receiver | Trung bình |
| `com.xiaomi.miplay` | MiPlay và MIoT host | Trung bình |
| `com.xiaomi.mi_connect_service` | Mi Connect service | Trung bình–cao |
| `com.xiaomi.mitv.smartshare` | AirPlay, Bluetooth và SmartShare | Trung bình–cao |
| `com.xiaomi.wfdsinkhelperservice` | Wi-Fi Display/Miracast sink helper | Trung bình–cao |

Nếu cần tinh gọn nhóm này, disable lần lượt theo thứ tự: AirKan → MiPlay → Mi Connect → SmartShare → WFD Sink. Sau từng bước phải thử cast và sleep/wake.

### 5.2 Dịch vụ phụ thuộc cách sử dụng

| Package | Bằng chứng/điều kiện | Khuyến nghị |
|---|---|---|
| `com.mitv.alarmcenter` | Alarm service đang chạy. | Chỉ disable nếu không dùng báo thức, hẹn giờ bật/tắt hoặc lịch nhắc. |
| `com.xiaomi.mitv.tvpush.tvpushservice` | Hai process push/MQTT đang chạy; có installer whitelist. | Thử disable nếu không dùng push/cài app từ điện thoại Xiaomi; kiểm tra remote và sideload. |
| `com.xm.webcontent` | Xiaomi WebView/content activities. | Chỉ disable sau khi các app shopping/content đã tắt và đã kiểm tra Settings không phụ thuộc. |
| `com.xiaomi.mibox.lockscreen` | Child mode, PIN và lock screen. | Chỉ disable nếu không dùng khóa trẻ em/PIN. |
| `com.mitv.gallery` | Gallery cũ; đã quan sát thấy activity screensaver của package này chạy. | Giữ trong đợt đầu. Chỉ disable sau khi cấu hình screensaver khác hoạt động. |
| `com.xiaomi.mitv.karaoke.service` | Đang được cấu hình làm Accessibility Service. | Không disable trực tiếp. Phải tắt accessibility này trước và kiểm tra remote/phím cứng. |
| `com.xiaomi.account` và `com.xiaomi.account.auth` | Xiaomi account/authenticator, chạy với quyền system. | Chỉ xem xét khi đã đăng xuất Mi Account và không dùng Mi Home/MiPlay. |

## 6. Package nên giữ

Không disable/uninstall các nhóm sau trong kế hoạch hiện tại:

- `android`, `com.android.*`: framework, System UI, provider và settings nền tảng.
- `com.droidlogic.*`, `com.droidlogic.overlay`, `mitv.service`: TV input, âm thanh, subtitle và lớp phần cứng Amlogic/DroidLogic.
- `com.xiaomi.mitv.systemui`: giao diện hệ thống.
- `com.xiaomi.mitv.settings`, `com.xiaomi.mitv.providers.settings`: Settings và provider cấu hình.
- `com.xiaomi.mitv.remotecontroller.service`: điều khiển TV/remote.
- `com.xiaomi.mitv.tvmanager`: service quản lý hệ thống và package; để lại trong giai đoạn đầu.
- `com.xiaomi.tvqs`: performance/quality service đặc quyền system; vai trò chính xác chưa đủ bằng chứng để tắt an toàn.
- `com.xiaomi.mitv.tvplayer`, `com.mitv.mivideoplayer`, `com.mitv.videoplayer`, `com.mitv.codec.update`: pipeline phát video/codec của firmware.
- `com.xiaomi.mitv.mediaexplorer`: đọc USB/media; chỉ cân nhắc nếu chắc chắn không dùng nguồn phát ngoài.
- `com.oversea.aslauncher`: Emotn Home hiện tại.
- `com.mitv.tvhome`: Home gốc Xiaomi. Tạm giữ làm fallback cho tới khi Emotn được kiểm tra qua reboot và một chu kỳ sử dụng ổn định.
- `com.xiaomi.mitv.csi`, `com.xiaomi.android.TV.audio`: component hệ thống chưa đủ bằng chứng; hiện không phải mục tiêu ưu tiên vì không thấy lợi ích rõ khi disable.

Đặc biệt, không dùng wildcard hoặc suy luận rằng mọi package bắt đầu bằng `com.droidlogic` đều là rác. Nhiều package trong namespace này điều khiển TV input, âm thanh và phụ đề.

## 7. Quy trình áp dụng an toàn

### 7.1 Trước khi thay đổi

```bash
adb connect 192.168.0.107:5555
adb -s 192.168.0.107:5555 get-state
zsh scripts/export_tv_packages.sh 192.168.0.107:5555 XIAOMI_TV_PACKAGES.before-debloat.md
adb -s 192.168.0.107:5555 shell settings get secure default_input_method
adb -s 192.168.0.107:5555 shell 'cmd package resolve-activity --brief -a android.intent.action.MAIN -c android.intent.category.HOME'
```

Kỳ vọng trước khi bắt đầu:

- IME: `com.liskovsoft.leankeyboard/.ime.LeanbackImeService`
- Home: `com.oversea.aslauncher/.ui.main.MainActivity`

### 7.2 Sau mỗi package

1. Nhấn Home và mở vài ứng dụng.
2. Kiểm tra remote, phím âm lượng và Settings.
3. Phát video có tiếng ít nhất vài phút.
4. Thử HDMI/TV input nếu có sử dụng.
5. Cho TV sleep rồi wake lại.
6. Với package liên quan cast, thử cast thật.
7. Xác nhận ADB vẫn kết nối và không có crash loop:

```bash
adb -s 192.168.0.107:5555 shell 'dumpsys activity activities | grep mResumedActivity | head -1'
adb -s 192.168.0.107:5555 logcat -d -t 300 | grep -E 'FATAL EXCEPTION|AndroidRuntime'
```

### 7.3 Sau khi ổn định

Giữ package ở trạng thái disabled là đủ để ngăn chạy nền. Chỉ dùng lệnh sau nếu thật sự muốn package không còn được cài cho user 0:

```bash
PACKAGE=example.package
adb -s 192.168.0.107:5555 shell pm uninstall -k --user 0 "$PACKAGE"
```

`-k` giữ lại data/cache để rollback ít mất cấu hình hơn. Lệnh này vẫn không xóa APK gốc khỏi phân vùng firmware.

## 8. Claim ledger

| Nhận định | Loại bằng chứng | Nguồn | Xác minh | Tin cậy | Ý nghĩa |
|---|---|---|---|---|---|
| TV có 110 package installed và 126 package khi gồm user-uninstalled | Runtime | `pm list packages`, `pm list packages -u` trên TV | Có | Cao | Có đúng 16 package đã được gỡ cho user 0. |
| 16 package hợp lệ trong danh sách cũ đều `installed=false` | Runtime | `dumpsys package PACKAGE` | Có | Cao | Không chạy lại danh sách cũ. |
| 5 package trong danh sách cũ không tồn tại trên firmware | Runtime | `pm list packages -u`, `dumpsys package` | Có | Cao | Không đoán package thay thế theo tên gần giống. |
| `disable-user` và `uninstall --user` là hai trạng thái khác nhau | Official + Runtime | Android ADB/package manager docs và `pm help` trên TV | Có | Cao | Dùng disable trước để rollback nhanh. |
| `install-existing` được firmware hỗ trợ | Runtime + Source | Probe lệnh trên TV trả `NameNotFoundException` cho tên giả, thay vì unknown command; AOSP PackageManager shell | Có | Cao | Có thể phục hồi system package đã gỡ cho user 0. |
| LeanKey đang là IME mặc định và Sogou không được bật làm IME | Runtime | `settings get secure default_input_method`, `ime list -s` | Có | Cao | Sogou là ứng viên disable ít rủi ro. |
| Karaoke service đang giữ accessibility | Runtime | `settings get secure enabled_accessibility_services` | Có | Cao | Không disable trực tiếp package karaoke. |
| Vai trò cụ thể của các package Xiaomi đóng nguồn | Runtime + Inference | Tên activity/service/receiver, process và package flags từ `dumpsys package`/`ps` | Một phần | Trung bình | Phải kiểm thử theo tính năng, không disable hàng loạt. |

## 9. Nguồn tham khảo

- [Android Debug Bridge — Package manager commands](https://developer.android.com/tools/adb): định nghĩa `list packages`, `uninstall`, `enable`, `disable-user` và tùy chọn `--user`/`-k`.
- [AOSP — Test multiple users](https://source.android.com/docs/devices/admin/multi-user-testing): giải thích lệnh cài, gỡ và disable theo từng user, cùng khuyến nghị chỉ rõ user ID.
- [AOSP PackageManagerShellCommand source](https://android.googlesource.com/platform/frameworks/base/+/bcb4d3cf6385/services/core/java/com/android/server/pm/PackageManagerShellCommand.java): help/source cho `install-existing`, `uninstall`, `enable` và `disable-user`.
- Runtime snapshot: [XIAOMI_TV_PACKAGES.md](XIAOMI_TV_PACKAGES.md).

## 10. Trạng thái áp dụng

Đợt đầu đã được thực hiện ngày `2026-08-11`, lần lượt từng package:

| Package | Kết quả | Xác minh tức thời |
|---|---|---|
| `com.miui.analytics` | `disabled-user` | Process dừng; ADB, Home và IME bình thường. |
| `com.mitv.shoplugin` | `disabled-user` | Process không chạy; ADB, Home và IME bình thường. |
| `com.sohu.inputmethod.sogou.tv` | `disabled-user` | Process dừng; LeanKey vẫn là IME mặc định và IME duy nhất được bật. |
| `com.xiaomi.mitv.calendar` | `disabled-user` | Process không chạy; ADB, Home và IME bình thường. |
| `com.xiaomi.screenrecorder` | `disabled-user` | Process dừng; ADB, Home và IME bình thường. |

Kiểm tra chung sau đợt thay đổi:

- Settings mở thành công tại `com.android.tv.settings/.MainSettings`.
- Phím Home quay về `com.oversea.aslauncher/.ui.main.MainActivity`.
- Không thấy fatal exception gần thời điểm thay đổi của System UI hoặc Emotn.
- Inventory sau thay đổi có 110 package installed và đúng 5 package disabled.
- Snapshot trước thay đổi: `XIAOMI_TV_PACKAGES.before-debloat-2026-08-11.md`.
- Snapshot hiện tại: `XIAOMI_TV_PACKAGES.md`.

Rollback riêng từng package bằng `pm enable --user 0 PACKAGE`. Nếu cần rollback toàn bộ đợt đầu:

```bash
adb -s 192.168.0.107:5555 shell pm enable --user 0 com.miui.analytics
adb -s 192.168.0.107:5555 shell pm enable --user 0 com.mitv.shoplugin
adb -s 192.168.0.107:5555 shell pm enable --user 0 com.sohu.inputmethod.sogou.tv
adb -s 192.168.0.107:5555 shell pm enable --user 0 com.xiaomi.mitv.calendar
adb -s 192.168.0.107:5555 shell pm enable --user 0 com.xiaomi.screenrecorder
```

Hành động tiếp theo là quan sát TV qua ít nhất một chu kỳ sleep/wake và sử dụng bình thường. Sau khi ổn định mới đánh giá Mi Music/Mi Home/gallery và nhóm cast; không thay đổi các nhóm này cùng một lúc.
