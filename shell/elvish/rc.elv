eval (starship init elvish)

set E:http_proxy = "http://127.0.0.1:20172"
set E:https_proxy = "http://127.0.0.1:20172"
set E:all_proxy = "http://127.0.0.1:20172"

fn get {
  |@a| e:aria2c $@a
}

fn bget {
  |@a| e:aria2c -U "pan.baidu.com" $@a
}

fn rdp {
  e:cloudflared access rdp --hostname wre.ccccr.top --url rdp://localhost:33789
}
