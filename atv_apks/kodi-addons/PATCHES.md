# Kodi add-on compatibility patches

Các thư mục dưới `patched/` chứa đúng source add-on đã cài lên Kodi 21 trên Xiaomi TV. Giữ lại để có thể tái cài sau khi Kodi hoặc firmware bị cập nhật.

## NHK Live 4.0.11

File: `patched/plugin.video.nhklive/resources/lib/scraper.py`

- API VOD/EPG cũ `nwapi.nhk.jp` không còn phân giải DNS.
- Menu vẫn hiện `NHK Live` khi API VOD lỗi.
- Khi EPG lỗi, add-on tạo một mục live trực tiếp.
- Luồng cũ của add-on trả playlist con `404`; thay bằng endpoint Smart TV hiện hành `https://masterpl.hls.nhkworld.jp/hls/w/live/smarttv.m3u8`.
- Đã xác minh Kodi phát bằng player nội bộ trên TV ngày `2026-08-11`.

## Plex 0.3.5

File: `patched/script.plex/lib/_included_packages/plexnet/signalslot/signal.py`

- Kodi 21 dùng Python 3.11, đã bỏ `inspect.getargspec()`.
- Thay bằng `inspect.getfullargspec(...).varkw` để giữ nguyên kiểm tra callback chấp nhận keyword arguments.
- Đã xác minh add-on mở được màn hình `Sign In` trên TV ngày `2026-08-11`.

## YouTube plugin 7.4.4

File cấu hình triển khai: `config/plugin.video.youtube/settings.xml`.

- Tắt setup wizard sau lần cấu hình đầu.
- Đặt chất lượng tối đa 1080p phù hợp màn hình TV.
- Add-on được cài để phục vụ các liên kết YouTube trong NASA add-on; một số live ID cũ của NASA đã ngừng hoạt động và có thể yêu cầu đăng nhập YouTube.
