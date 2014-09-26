■サーバ側
★XAMPP
1. XAMPPをインストール
2. ローカルアクセス制限を削除（Webでデータベースを見る場合）
	「xampp\apache\conf\extra\httpd-xampp.conf」の一番後ろの部分をコメントアウト
	#<LocationMatch "^/(?i:(?:xampp|security|licenses|phpmyadmin|webalizer|server-status|server-info))">
	#        Require local
	#	ErrorDocument 403 /error/XAMPP_FORBIDDEN.html.var
	#</LocationMatch>
3. XAMPPを起動
	「xampp\xampp-control.exe」
		MySQL	必須
		Apache	非必須（Webでデータベースを見る場合）
4. Webでデータベースをアクセス
	http://ServerIP/phpmyadmin/
5. MySQLでデータベースおよびアカウントを作る
	WebでデータベースDBNAMEを作成
	GRANT ALL ON DBNAME.* TO 'USERNAME'@'%' IDENTIFIED BY 'PASSWORD';
6. テーブル定義をインポートして、テーブルを作成
	「setup\vmlog.sql」
7. ローカルの設定ファイルを作成
	「LogRelayConfig.exe」を実行して、「LogRelay.xml」を作成する。


■ローカル側
★VMWareとWin7間の通信テスト
1. Win7で「LogRelay.exe」を実行する
2. VMWareで「setup\udp_test.py」を実行する
3. Win7で「LogRelay.exe」の画面で、メッセージを受信すれば、OKです
★VMWare
1. 「setup\syslog.py」を実行する
2. 再起動または「service smb restart;service sysklogd restart」
★Win7
1. サーバ側で作成した「LogRelay.xml」を「LogRelay.exe」のフォルダに格納する
2. 起動する時に「LogRelay.exe -h」を実施する
※ローカルPCに「setup」及び「LogRelayConfig.exe」が不要です