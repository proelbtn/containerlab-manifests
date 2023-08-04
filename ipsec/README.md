## IPsec

### 最小構成

以下に、最小構成のIPsec接続用の設定を示す。この例では、RT01からのみ接続可能である。

自身がクライアントの場合、local.idは以下の用途で用いられる。

* サーバ側に自身のIDとして提示する
* Secretsから必要なsecretを取得する際の主キーとして利用する

server.idは以下の用途で用いられる。

* サーバ側のconnectionを指定する

また、自身がサーバの場合、server.idは以下の用途で用いられる。

* クライアントから接続されてきた際に、使用するconnectionを取得する際の主キーとして利用する

サーバ側では、クライアント側から提示されたIDを基にsecretsを引き、得られたsecretを用いてMACを計算する。

```
connections {
    rt02 {
        version = 2
        local_addrs = 192.168.0.1
        remote_addrs = 192.168.0.2
        
        local {
            auth = psk
            id = user1@proelbtn.com
        }

        remote {
            auth = psk
            id = server@proelbtn.com
        }

        children {
            default {
                local_ts = 172.16.1.0/24
                remote_ts = 172.16.2.0/24
                mode = tunnel
            }
        }
    }
}

secrets {
    ike-user1 {
        id = user1@proelbtn.com
        secret = "ZEnJ1BS4mf717Plf"
    }
}
```

```
connections {
    rt01 {
        version = 2
        local_addrs = 192.168.0.2
        
        local {
            auth = psk
            id = server@proelbtn.com
        }

        remote {
            auth = psk
        }

        children {
            default {
                local_ts = 172.16.2.0/24
                remote_ts = 172.16.1.0/24
                mode = tunnel
            }
        }
    }
}

secrets {
    ike-user1 {
        id = user1@proelbtn.com
        secret = "ZEnJ1BS4mf717Plf"
    }
}
```