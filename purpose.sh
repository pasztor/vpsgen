prepare_basic () {
local rootfs
local initscript
local iinfo
rootfs="$1"
initscript="$2"
iinfo="$3"
echo "apt-get -y install vim less" >>$initscript
}

prepare_mini () {
local rootfs
local initscript
local iinfo
rootfs="$1"
initscript="$2"
iinfo="$3"
echo "apt-get -y install apache2" >>$initscript
chmod 1000.1000 ${rootfs}/var/www
}

prepare_maxi () {
local rootfs
local initscript
local iinfo
local mysqlrootpw
local pmadpw
rootfs="$1"
initscript="$2"
iinfo="$3"
mysqlrootpw=$(pwgen 12 1)
pmadpw=$(pwgen 8 1)
cat <<END >>$initscript
apt-get update
cat <<DEBC | debconf-set-selections
#debconf debconf-frontend select Readline
mysql-server-5.1 mysql-server/root_password_again string ${mysqlrootpw}
mysql-server-5.1 mysql-server/root_password string ${mysqlrootpw}
phpmyadmin phpmyadmin/dbconfig-install boolean true
phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2 
phpmyadmin phpmyadmin/mysql/admin-pass password ${mysqlrootpw}
phpmyadmin phpmyadmin/mysql/app-pass password ${pmadpw}
phpmyadmin phpmyadmin/app-password-confirm password ${pmadpw}
DEBC
apt-get --no-install-recommends -y install apache2 libapache2-mod-php5 php5-mysql php5 mysql-server phpmyadmin
echo -e '/Alias\ns/ \/phpmyadmin/ \/PmAd/\nw' | ed /etc/phpmyadmin/apache.conf 
END

cat <<END >>$rootfs/etc/hosts
127.0.1.1	$host.$domain $host
END

cat <<END >>$iinfo
Mysql root password: ${mysqlrootpw}
PHPMyadmin URL: http://$host.$domain/PmAd/
PHPMyadmin password: ${pmadpw}
END

}

do_all_purpose () {
for i in "${purpose[@]}"; do
	case "$i" in
		mini)
			prepare_mini "$rootfs" "$rootfs/root/initscript.sh" "$rootfs/root/installinfo.txt"
			;;
		maxi)
			prepare_maxi "$rootfs" "$rootfs/root/initscript.sh" "$rootfs/root/installinfo.txt"
			;;
		basic)
			prepare_basic "$rootfs" "$rootfs/root/initscript.sh" "$rootfs/root/installinfo.txt"
			;;
	esac
done
}
